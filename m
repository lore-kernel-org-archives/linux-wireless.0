Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:35968 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdGCVIs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 17:08:48 -0400
Received: by mail-qt0-f180.google.com with SMTP id i2so152343201qta.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 14:08:47 -0700 (PDT)
Subject: Re: [PATCH v4 02/10] rtlwifi: Add BT_MP_INFO to c2h handler.
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
 <20170702181239.17911-3-Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <02d73d82-b609-036f-6560-ca7a657d7bf2@broadcom.com> (sfid-20170703_231053_498524_25285526)
Date: Mon, 3 Jul 2017 23:08:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170702181239.17911-3-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2-7-2017 20:12, Larry Finger wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> We use H2C to ask BT's status, and C2H will return the status.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> ---
> v2 - no changes
> v3 - no changes
> v4 - no changes
> ---
>  .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 17 ++++++++++++-
>  .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 28 ++++++++++++++++++++++
>  .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  1 +
>  .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  9 +++++--
>  .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  9 +++++--
>  .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 13 +++++++---
>  drivers/net/wireless/realtek/rtlwifi/wifi.h        |  2 ++
>  7 files changed, 71 insertions(+), 8 deletions(-)
> 

[...]

>  
> +void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
> +{
> +	u8 extid, seq, len;
> +	u16 bt_real_fw_ver;
> +	u8 bt_fw_ver;
> +
> +	if ((length < 4) || (!tmp_buf))
> +		return;
> +
> +	extid = tmp_buf[0];
> +	/* not response from BT FW then exit*/
> +	if (extid != 1) /* C2H_TRIG_BY_BT_FW = 1 */
> +		return;
> +
> +	len = tmp_buf[1] >> 4;
> +	seq = tmp_buf[2] >> 4;
> +
> +	/* BT Firmware version response */
> +	if (seq == 0x0E) {
> +		bt_real_fw_ver = tmp_buf[3] | (tmp_buf[4] << 8);
> +		bt_fw_ver = tmp_buf[5];
> +
> +		gl_bt_coexist.bt_info.bt_real_fw_ver = bt_real_fw_ver;
> +		gl_bt_coexist.bt_info.bt_fw_ver = bt_fw_ver;
> +	}
> +}

Just stumbled upon this and curious. I assume gl_bt_coexist is a global
variable so I guess this code will not work when running multiple
realtek device with btcoexist on your system.

Regards,
Arend
