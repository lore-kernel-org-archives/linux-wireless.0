Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57373 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1AXTDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 14:03:15 -0500
Received: by gyb11 with SMTP id 11so1402171gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 11:03:15 -0800 (PST)
Date: Mon, 24 Jan 2011 17:03:36 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: brudley@broadcom.com, henryp@broadcom.com, dowan@broadcom.com,
	vossen@broadcom.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: fix error report string
Message-ID: <20110124190336.GA4300@joana>
References: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reporting another issue here. The README file is not correct with the content
of the linux-firmware tree. Seems that the changes added in this patch

http://www.spinics.net/lists/linux-wireless/msg60937.html

never arrived to linux-firmware.

Other than that, you guys are doing a great workon putting this driver
mainline. Mine broadcom card is working fine. :)

Regards,

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-01-24 16:45:23 -0200]:

> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> ---
>  drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> index 5eb41d6..ee1bcc5 100644
> --- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
> +++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> @@ -6910,7 +6910,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
>  		preamble = 0;
>  		if (IS_CCK(rspec)) {
>  			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
> -				WL_ERROR("Short CCK\n");
> +				WL_ERROR("%s: Short CCK\n, __func__");
>  			rx_status->flag |= RX_FLAG_SHORTPRE;
>  		} else if (IS_OFDM(rspec)) {
>  			rx_status->flag |= RX_FLAG_SHORTPRE;
> -- 
> 1.7.4.rc2
> 

-- 
Gustavo F. Padovan
http://profusion.mobi
