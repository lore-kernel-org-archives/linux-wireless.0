Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbBLHMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 02:12:52 -0500
Message-ID: <54DC517B.80402@qti.qualcomm.com> (sfid-20150212_081255_420606_282498EE)
Date: Thu, 12 Feb 2015 12:38:43 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix interrupt storm
References: <1423717162-7788-1-git-send-email-vthiagar@qti.qualcomm.com> <CA+BoTQmFhuK5vt8UnDu7CkH2=vUqGY8WkkXEgwoSb-NUoEYH-w@mail.gmail.com>
In-Reply-To: <CA+BoTQmFhuK5vt8UnDu7CkH2=vUqGY8WkkXEgwoSb-NUoEYH-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index d6d2f0f..310e608 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -932,6 +932,14 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>>                  return ret;
>>          }
>>
>> +       if (ar->filter_flags & FIF_PROMISC_IN_BSS) {
>> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
>> +               ath10k_dbg(ar, ATH10K_DBG_MAC, "Disabling promiscuous mode when we start a vdev\n");
>
> The debug message style is: "mac <message>", i.e. "mac disabling
> promiscuous mode because vdev is started".

Ok.

>
>
>> +               ret = ath10k_monitor_recalc(ar);
>> +               if (ret)
>> +                       return ret;
>
> If you fail you should undo whatever the function did if it makes
> sense. In this case it makes sense to stop the vdev.

Sure.

>
>
>> +       }
>> +
>>          ar->num_started_vdevs++;
>>          ath10k_recalc_radar_detection(ar);
>>
>> @@ -3369,6 +3377,14 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
>>
>>          changed_flags &= SUPPORTED_FILTERS;
>>          *total_flags &= SUPPORTED_FILTERS;
>> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
>> +               if (ar->num_started_vdevs) {
>> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
>> +                                  "Not enabling promiscuous mode when already a vdev is running\n");
>
> Message style.

Ok.

>
>
>> +                       mutex_unlock(&ar->conf_mutex);
>> +                       return;
>> +               }
>> +       }
>>          ar->filter_flags = *total_flags;
>>
>>          ret = ath10k_monitor_recalc(ar);
>
> Anyway the entire logic should go to ath10k_monitor_recalc(). It
> already has access to it and just put calls to this function in
> adequate callsites.

Ok.

>
> Moreover I'm pretty sure this patch breaks STA 4addr bridging. I'm
> worried it also breaks other stuff (e.g  some IBSS usecases or even
> some AP usecases) but I don't have time to check this now.

Can you please elaborate on this one?. I can review if we can for these
cases as well before disabling promiscuous mode.

Thanks,

Vasanth
