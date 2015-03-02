Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30857 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbCBKWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 05:22:05 -0500
Message-ID: <54F438C5.802@qti.qualcomm.com> (sfid-20150302_112210_540302_C4B04103)
Date: Mon, 2 Mar 2015 15:47:41 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re:  [PATCH V3 2/2] ath10k: Fix interrupt storm
References: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>	<1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com>,<CA+BoTQ=UFo=2Fa8FXw6JTGKkNLoG=m56py0a8AShyh3nTJ+TKQ@mail.gmail.com> <1425288686058.83668@qti.qualcomm.com>
In-Reply-To: <1425288686058.83668@qti.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-2"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>
>> buffers because in monitor mode device receives everything seen
>> on the air. In noisy condition, disabling monitor mode helps assoc
>> go through without any issue.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c |   35 +++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 3b5aaa3..885e984 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -766,12 +766,36 @@ static int ath10k_monitor_stop(struct ath10k *ar)
>>          return 0;
>>   }
>>
>> +static bool ath10k_disable_promisc_mode(struct ath10k *ar)
>
> The function name implies something that has a side-effect.
>
> If anything, this should be named more like:
> ath10k_mac_should_disable_promisc() or ath10k_mac_is_promisc() (with
> the logic inverted).

Ok.

>
>
>> +{
>> +       struct ath10k_vif *arvif;
>> +
>> +       if (!ar->num_started_vdevs)
>> +               return false;
>> +
>> +       list_for_each_entry(arvif, &ar->arvifs, list) {
>
> This means function must be called while holding conf_mutex (my MCC
> patch adds data_lock as an option, but current upstream tree uses
> conf_mutex only).

Ok. Sure, we can fix it when we have MCC change into the tree.

>
>
>> +               /* Disabling promiscuous mode when STA/IBSS is running */
>> +               if (arvif->vdev_type == WMI_VDEV_TYPE_STA ||
>> +                   arvif->vdev_type == WMI_VDEV_TYPE_IBSS)
>
> Wouldn't `if (arvif->vdev_type != WMI_VDEV_TYPE_AP) return false` be
> safer? We only know this is safe for AP, right?

Sure.

>
>
>> +                       return false;
>> +       }
>> +
>> +       return true;
>> +}
>> +
>>   static int ath10k_monitor_recalc(struct ath10k *ar)
>>   {
>>          bool should_start;
>>
>>          lockdep_assert_held(&ar->conf_mutex);
>>
>> +       if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
>> +           ath10k_disable_promisc_mode(ar)) {
>> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
>> +               ath10k_dbg(ar, ATH10K_DBG_MAC,
>> +                          "mac disabling promiscuous mode because vdev is started\n");
>> +       }
>> +
>
> I don't like this. You modify filter_flags. This shouldn't be
> happening in the recalc function. The recalc function should have only
> a side-effect of starting/stopping monitor vdev.
>
> Instead:
>
>   should_start = ar->monitor || ath10k_mac_is_promisc() ||
> test_bit(ATH10K_CAC_RUNNING);
>
> And put the promisc skipping logic in ath10k_mac_is_promisc().

Right, this is much better.

>
>
>>          should_start = ar->monitor ||
>>                         ar->filter_flags & FIF_PROMISC_IN_BSS ||
>>                         test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
>> @@ -969,6 +993,10 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>>          ar->num_started_vdevs++;
>>          ath10k_recalc_radar_detection(ar);
>>
>> +       ret = ath10k_monitor_recalc(ar);
>> +       if (ret)
>> +               ath10k_vdev_stop(arvif);
>
> You should warn here "failed to recalc monitor: %d\n". Also it'd be
> nice if vdev_stop() was checked for error as well (but not with "ret"
> as to not lose the original failure reason code; `ret2` is okay). A
> warning for that is would also be desired.

Sure.

>
>
>> +
>>          return ret;
>>   }
>>
>> @@ -3476,6 +3504,13 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
>>
>>          changed_flags &= SUPPORTED_FILTERS;
>>          *total_flags &= SUPPORTED_FILTERS;
>> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
>> +               if (ar->num_started_vdevs) {
>> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
>> +                                  "mac does not enable promiscuous mode when already a vdev is running\n");
>> +                       *total_flags &= ~FIF_PROMISC_IN_BSS;
>> +               }
>> +       }
>
> There's no need for that, is there? The monitor_recalc() is supposed
> to deal with this.

Right, but we may not want to create any inconsistencies between *total_flags and actual
filters enabled in the driver?.

Thanks for the review.

Vasanth
