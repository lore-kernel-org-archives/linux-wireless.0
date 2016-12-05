Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24897 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbcLEVKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 16:10:44 -0500
Date: Tue, 6 Dec 2016 00:10:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] rtlwifi: Add TX report and disable key will wait
 until report acked.
Message-ID: <20161205211019.GI8176@mwanda> (sfid-20161205_221047_174230_FA09DD25)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-6-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161202014833.6856-6-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 01, 2016 at 07:48:24PM -0600, Larry Finger wrote:
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
> index 2d48ccd..0f9d9f0 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
> @@ -731,6 +731,14 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
>  			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
>  		}
>  
> +		/* tx report */
> +		if (ptcb_desc->use_spe_rpt) {
> +			u16 sn = rtl_get_tx_report_sn(hw);
> +
> +			SET_TX_DESC_SPE_RPT(pdesc, 1);
> +			SET_TX_DESC_SW_DEFINE(pdesc, sn);
> +		}
> +

All the callers of rtl_get_tx_report_sn() use this same 5 line block.
Let's move it to a separate function.

regards,
dan carpenter
