Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdG0JyN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 05:54:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 01/10] rtlwifi: Fill in_4way field by driver
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-2-Larry.Finger@lwfinger.net>
Date: Thu, 27 Jul 2017 12:54:08 +0300
In-Reply-To: <20170702181239.17911-2-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 2 Jul 2017 13:12:30 -0500")
Message-ID: <874ltyxl1b.fsf@purkki.adurom.net> (sfid-20170727_115424_257630_6D4B6E69)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> Because it isn't always correct to use EAPOL to check 4-way,
> we add a timer to handle exception.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -1408,6 +1408,11 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
>  
>  		return true;
>  	} else if (ETH_P_PAE == ether_type) {
> +		/* EAPOL is seens as in-4way */
> +		rtlpriv->btcoexist.btc_info.in_4way = true;
> +		rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
> +	rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
> +
>  		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
>  			 "802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");

The indentation looks wrong.

-- 
Kalle Valo
