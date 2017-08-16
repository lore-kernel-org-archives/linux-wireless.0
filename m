Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751552AbdHPO5V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 10:57:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v2 2/2] rtlwifi: btcoex: Use seq_file to dump btcoex status
References: <20170810164744.9336-1-Larry.Finger@lwfinger.net>
        <20170810164744.9336-3-Larry.Finger@lwfinger.net>
Date: Wed, 16 Aug 2017 17:57:17 +0300
In-Reply-To: <20170810164744.9336-3-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Thu, 10 Aug 2017 11:47:44 -0500")
Message-ID: <87a82ztvaq.fsf@purkki.adurom.net> (sfid-20170816_165725_040670_4D3BEDBC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> We use seq_file to replace RT_TRACE to dump status, then we can use 'cat'
> to access btcoex's status through debugfs.
> (i.e. /sys/kernel/debug/rtlwifi/00-11-22-33-44-55-66/btcoex)
> Other related changes are
> 1. implement btc_disp_dbg_msg() to access btcoex's common status.
> 2. remove obsolete field bt_exist
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> +static void halbtc_display_wifi_status(struct btc_coexist *btcoexist,
> +				       struct seq_file *m)
> +{
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	s32	wifi_rssi = 0, bt_hs_rssi = 0;
> +	bool	scan = false, link = false, roam = false, wifi_busy = false,
> +		wifi_under_b_mode = false,
> +		wifi_under_5g = false;
> +	u32	wifi_bw = BTC_WIFI_BW_HT20,
> +		wifi_traffic_dir = BTC_WIFI_TRAFFIC_TX,
> +		wifi_freq = BTC_FREQ_2_4G;
> +	u32	wifi_link_status = 0x0;
> +	bool	bt_hs_on = false, under_ips = false, under_lps = false,
> +		low_power = false, dc_mode = false;
> +	u8	wifi_chnl = 0, wifi_hs_chnl = 0, fw_ps_state;
> +	u8	ap_num = 0;

The indetation here is weird.

-- 
Kalle Valo
