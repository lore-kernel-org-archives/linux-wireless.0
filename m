Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36730 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdHCO2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:28:37 -0400
Received: by mail-wm0-f50.google.com with SMTP id t201so16897284wmt.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:28:36 -0700 (PDT)
Subject: Re: [PATCH v3 9/9] wil6210: make debugfs compilation optional
To: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Gidon Studinski <QCA_gidons@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
References: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1501766739-31996-10-git-send-email-qca_merez@qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dc3bcacf-4b93-f7dc-cb49-e132e50b1711@broadcom.com> (sfid-20170803_162840_022035_9F75776B)
Date: Thu, 3 Aug 2017 16:28:34 +0200
MIME-Version: 1.0
In-Reply-To: <1501766739-31996-10-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03-08-17 15:25, Maya Erez wrote:
> From: Gidon Studinski <qca_gidons@qca.qualcomm.com>
> 
> Since debugfs is a kernel configuration option, enable the driver to
> compile without debugfs.
> 
> Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/Makefile  | 2 +-
>  drivers/net/wireless/ath/wil6210/debugfs.c | 6 ++----
>  drivers/net/wireless/ath/wil6210/main.c    | 1 +
>  drivers/net/wireless/ath/wil6210/txrx.c    | 6 +++---
>  drivers/net/wireless/ath/wil6210/wil6210.h | 8 +++++++-
>  5 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
> index 4ae21da..63a751a 100644
> --- a/drivers/net/wireless/ath/wil6210/Makefile
> +++ b/drivers/net/wireless/ath/wil6210/Makefile
> @@ -4,7 +4,7 @@ wil6210-y := main.o
>  wil6210-y += netdev.o
>  wil6210-y += cfg80211.o
>  wil6210-y += pcie_bus.o
> -wil6210-y += debugfs.o
> +wil6210-$(CONFIG_DEBUG_FS) += debugfs.o

This looks good, but ....

>  wil6210-y += wmi.o
>  wil6210-y += interrupt.o
>  wil6210-y += txrx.o

[...]

> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> index e3c0c2f..d7b1e03 100644
> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -30,7 +30,6 @@
>  extern unsigned int mtu_max;
>  extern unsigned short rx_ring_overflow_thrsh;
>  extern int agg_wsize;
> -extern u32 vring_idle_trsh;
>  extern bool rx_align_2;
>  extern bool rx_large_buf;
>  extern bool debug_fw;
> @@ -693,6 +692,7 @@ struct wil6210_priv {
>  	u8 vring2cid_tid[WIL6210_MAX_TX_RINGS][2]; /* [0] - CID, [1] - TID */
>  	struct wil_sta_info sta[WIL6210_MAX_CID];
>  	int bcast_vring;
> +	u32 vring_idle_trsh; /* HW fetches up to 16 descriptors at once  */

this vring stuff seems worth a separate patch (or I am simply
misunderstanding it).

Regards,
Arend

>  	bool use_extended_dma_addr; /* indicates whether we are using 48 bits */
>  	/* scan */
>  	struct cfg80211_scan_request *scan_request;
