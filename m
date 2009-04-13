Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:36370 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZDMQSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:18:43 -0400
Received: by qw-out-2122.google.com with SMTP id 8so2421107qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:18:41 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18915.26263.19973.135620@gargle.gargle.HOWL> (sfid-20090413_181846_671090_2793AECD)
Date: Mon, 13 Apr 2009 21:51:43 +0530
To: Steven Luo <steven@steven676.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: reset after PCI FATAL/PERR interrupts
In-Reply-To: <20090412095754.GA2594@steven676.net>
References: <20090412095754.GA2594@steven676.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steven Luo wrote:
> ath9k_hw_getisr() doesn't appear to set anything in the status mask for
> PCI FATAL or PERR interrupts (AR_INTR_SYNC_HOST1_FATAL/PERR), which
> the open-source HAL seems to do.  This means that the card isn't reset
> after these interrupts.
> 
> This patch seems to fix a problem where the wireless drops out with an
> "ath9k: received PCI FATAL interrupt" in dmesg after some time; the
> hardware is an AR5416 in an ASUS WL-500W running 2.6.28.7 (OpenWRT) and
> compat-wireless 2009-03-31.
> 
> Signed-off-by: Steven Luo <steven@steven676.net>
> ---
> 
> --- a/drivers/net/wireless/ath9k/hw.c	2009-04-09 23:23:35.000000000 -0700
> +++ b/drivers/net/wireless/ath9k/hw.c	2009-04-11 23:29:28.000000000 -0700
> @@ -3007,6 +3007,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, 
>  				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
>  					"received PCI PERR interrupt\n");
>  			}
> +			*masked |= ATH9K_INT_FATAL;
>  		}
>  		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
>  			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
> 

Thanks for the patch. The actual cause of the FATAL interrupt still remains unclear, though.
We'll work on this issue.

Sujith
