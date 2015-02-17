Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49920 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbbBQJXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 04:23:13 -0500
Received: by mail-wi0-f169.google.com with SMTP id em10so30067647wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 01:23:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424158996-8830-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1424158996-8830-1-git-send-email-vthiagar@qti.qualcomm.com>
	<1424158996-8830-2-git-send-email-vthiagar@qti.qualcomm.com>
Date: Tue, 17 Feb 2015 10:23:12 +0100
Message-ID: <CA+BoTQm9-VyEu3D2tR0EHJ-kh15z8WB4h-NzC6uZGCPPxM7NXA@mail.gmail.com> (sfid-20150217_102321_003794_90945975)
Subject: Re: [PATCH V2 2/2] ath10k: Fix interrupt storm
From: Michal Kazior <michal.kazior@tieto.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 February 2015 at 08:43, Vasanthakumar Thiagarajan
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
> index 3b5aaa3..66cc0a8 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -969,6 +969,15 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>         ar->num_started_vdevs++;
>         ath10k_recalc_radar_detection(ar);
>
> +       if (ar->filter_flags & FIF_PROMISC_IN_BSS) {
> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
> +               ath10k_dbg(ar, ATH10K_DBG_MAC,
> +                          "mac disabling promiscuous mode because vdev is started\n");
> +               ret = ath10k_monitor_recalc(ar);

The entire logic should go to ath10k_monitor_recalc().

Also I'm pretty sure this breaks 4addr station briding for main 636
fw. I can't fully test this now though (there seems to be a regression
against fw 636 and it keeps crashing with monitor vdev over and over
again).


Michał
