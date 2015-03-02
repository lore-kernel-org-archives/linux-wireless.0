Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:33384 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbCBIn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 03:43:29 -0500
Received: by wevk48 with SMTP id k48so31793930wev.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 00:43:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>
	<1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com>
Date: Mon, 2 Mar 2015 09:43:27 +0100
Message-ID: <CA+BoTQ=UFo=2Fa8FXw6JTGKkNLoG=m56py0a8AShyh3nTJ+TKQ@mail.gmail.com> (sfid-20150302_094332_725703_B344B4F8)
Subject: Re: [PATCH V3 2/2] ath10k: Fix interrupt storm
From: Michal Kazior <michal.kazior@tieto.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 February 2015 at 10:50, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
> Promiscuous mode is enabled when wlan interface is added to
> bridge. ath10k creates a monitor mode when promiscuous mode
> is enabled. When monitor vdev is runing along with other

s/runing/running/


> vdev(s) there is a huge number of interrupts generated
> especially in noisy condition. Fix this by not enabling
> promiscuous(monitor) mode when already a vdev is running.
> As disabling promiscuous mode may have issues with 4-address
> bridging in STA mode, the change is done specific to non-sta/ibss
> mode types. This does not change the support of virtual interface of
> type monitor along with other vdevs of any type.
>
> This could fix manangement frame drop in fw due to unavailable

s/manangement/management/


> buffers because in monitor mode device receives everything seen
> on the air. In noisy condition, disabling monitor mode helps assoc
> go through without any issue.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c |   35 +++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 3b5aaa3..885e984 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -766,12 +766,36 @@ static int ath10k_monitor_stop(struct ath10k *ar)
>         return 0;
>  }
>
> +static bool ath10k_disable_promisc_mode(struct ath10k *ar)

The function name implies something that has a side-effect.

If anything, this should be named more like:
ath10k_mac_should_disable_promisc() or ath10k_mac_is_promisc() (with
the logic inverted).


> +{
> +       struct ath10k_vif *arvif;
> +
> +       if (!ar->num_started_vdevs)
> +               return false;
> +
> +       list_for_each_entry(arvif, &ar->arvifs, list) {

This means function must be called while holding conf_mutex (my MCC
patch adds data_lock as an option, but current upstream tree uses
conf_mutex only).


> +               /* Disabling promiscuous mode when STA/IBSS is running */
> +               if (arvif->vdev_type == WMI_VDEV_TYPE_STA ||
> +                   arvif->vdev_type == WMI_VDEV_TYPE_IBSS)

Wouldn't `if (arvif->vdev_type != WMI_VDEV_TYPE_AP) return false` be
safer? We only know this is safe for AP, right?


> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
>  static int ath10k_monitor_recalc(struct ath10k *ar)
>  {
>         bool should_start;
>
>         lockdep_assert_held(&ar->conf_mutex);
>
> +       if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
> +           ath10k_disable_promisc_mode(ar)) {
> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
> +               ath10k_dbg(ar, ATH10K_DBG_MAC,
> +                          "mac disabling promiscuous mode because vdev is started\n");
> +       }
> +

I don't like this. You modify filter_flags. This shouldn't be
happening in the recalc function. The recalc function should have only
a side-effect of starting/stopping monitor vdev.

Instead:

 should_start = ar->monitor || ath10k_mac_is_promisc() ||
test_bit(ATH10K_CAC_RUNNING);

And put the promisc skipping logic in ath10k_mac_is_promisc().


>         should_start = ar->monitor ||
>                        ar->filter_flags & FIF_PROMISC_IN_BSS ||
>                        test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
> @@ -969,6 +993,10 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>         ar->num_started_vdevs++;
>         ath10k_recalc_radar_detection(ar);
>
> +       ret = ath10k_monitor_recalc(ar);
> +       if (ret)
> +               ath10k_vdev_stop(arvif);

You should warn here "failed to recalc monitor: %d\n". Also it'd be
nice if vdev_stop() was checked for error as well (but not with "ret"
as to not lose the original failure reason code; `ret2` is okay). A
warning for that is would also be desired.


> +
>         return ret;
>  }
>
> @@ -3476,6 +3504,13 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
>
>         changed_flags &= SUPPORTED_FILTERS;
>         *total_flags &= SUPPORTED_FILTERS;
> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
> +               if (ar->num_started_vdevs) {
> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
> +                                  "mac does not enable promiscuous mode when already a vdev is running\n");
> +                       *total_flags &= ~FIF_PROMISC_IN_BSS;
> +               }
> +       }

There's no need for that, is there? The monitor_recalc() is supposed
to deal with this.


Michał
