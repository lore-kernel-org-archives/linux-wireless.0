Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:61542 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbBLGrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 01:47:03 -0500
Received: by mail-we0-f177.google.com with SMTP id m14so2135363wev.8
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 22:47:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423717162-7788-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1423717162-7788-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Thu, 12 Feb 2015 07:47:01 +0100
Message-ID: <CA+BoTQmFhuK5vt8UnDu7CkH2=vUqGY8WkkXEgwoSb-NUoEYH-w@mail.gmail.com> (sfid-20150212_074709_293512_863ED2D2)
Subject: Re: [PATCH] ath10k: Fix interrupt storm
From: Michal Kazior <michal.kazior@tieto.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 February 2015 at 05:59, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
> Promiscuous mode is enabled when wlan interface is added to
> bridge. ath10k creates a monitor mode when promiscuous mode
> is enabled. When monitor vdev is runing along with other
> vdev(s) there is a huge number of interrupts generated
> especially in noisy condition. Fix this by not enabling
> promiscuous(monitor) mode when already a vdev is running.
> This does not change the support of virtual interface of
> type monitor along with other vdevs.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index d6d2f0f..310e608 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -932,6 +932,14 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>                 return ret;
>         }
>
> +       if (ar->filter_flags & FIF_PROMISC_IN_BSS) {
> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
> +               ath10k_dbg(ar, ATH10K_DBG_MAC, "Disabling promiscuous mode when we start a vdev\n");

The debug message style is: "mac <message>", i.e. "mac disabling
promiscuous mode because vdev is started".


> +               ret = ath10k_monitor_recalc(ar);
> +               if (ret)
> +                       return ret;

If you fail you should undo whatever the function did if it makes
sense. In this case it makes sense to stop the vdev.


> +       }
> +
>         ar->num_started_vdevs++;
>         ath10k_recalc_radar_detection(ar);
>
> @@ -3369,6 +3377,14 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
>
>         changed_flags &= SUPPORTED_FILTERS;
>         *total_flags &= SUPPORTED_FILTERS;
> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
> +               if (ar->num_started_vdevs) {
> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
> +                                  "Not enabling promiscuous mode when already a vdev is running\n");

Message style.


> +                       mutex_unlock(&ar->conf_mutex);
> +                       return;
> +               }
> +       }
>         ar->filter_flags = *total_flags;
>
>         ret = ath10k_monitor_recalc(ar);

Anyway the entire logic should go to ath10k_monitor_recalc(). It
already has access to it and just put calls to this function in
adequate callsites.

Moreover I'm pretty sure this patch breaks STA 4addr bridging. I'm
worried it also breaks other stuff (e.g  some IBSS usecases or even
some AP usecases) but I don't have time to check this now.


Michał
