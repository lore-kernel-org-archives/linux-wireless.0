Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54057 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbbAYTjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:39:04 -0500
Received: by mail-ob0-f172.google.com with SMTP id wp18so4899706obc.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 11:39:02 -0800 (PST)
Message-ID: <54C54655.3060807@lwfinger.net> (sfid-20150125_203907_439236_7048F471)
Date: Sun, 25 Jan 2015 13:39:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Set fw_ready flag
References: <1422100540-6338-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1422100540-6338-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2015 05:55 AM, Taehee Yoo wrote:
> After rtl8192cu download firmware routine, set fw_ready flag.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 3 +++
>   1 file changed, 3 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 5513217..2468850 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1000,6 +1000,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
>   	local_save_flags(flags);
>   	local_irq_enable();
>
> +	rtlhal->fw_ready = false;
>   	rtlhal->hw_type = HARDWARE_TYPE_RTL8192CU;
>   	err = _rtl92cu_init_mac(hw);
>   	if (err) {
> @@ -1013,6 +1014,8 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
>   		err = 1;
>   		goto exit;
>   	}
> +
> +	rtlhal->fw_ready = true;
>   	rtlhal->last_hmeboxnum = 0; /* h2c */
>   	_rtl92cu_phy_param_tab_init(hw);
>   	rtl92cu_phy_mac_config(hw);
>

