Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdGYMTA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:19:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 02/10] rtlwifi: Add BT_MP_INFO to c2h handler.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-3-Larry.Finger@lwfinger.net>
        <02d73d82-b609-036f-6560-ca7a657d7bf2@broadcom.com>
Date: Tue, 25 Jul 2017 15:18:54 +0300
In-Reply-To: <02d73d82-b609-036f-6560-ca7a657d7bf2@broadcom.com> (Arend Van
        Spriel's message of "Mon, 3 Jul 2017 23:08:43 +0200")
Message-ID: <87fudkk8up.fsf@codeaurora.org> (sfid-20170725_141904_248411_012FE41F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 2-7-2017 20:12, Larry Finger wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>
>> 
>> We use H2C to ask BT's status, and C2H will return the status.
>> 
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>> ---
>> v2 - no changes
>> v3 - no changes
>> v4 - no changes
>> ---
>>  .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 17 ++++++++++++-
>>  .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 28 ++++++++++++++++++++++
>>  .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  1 +
>>  .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  9 +++++--
>>  .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  9 +++++--
>>  .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 13 +++++++---
>>  drivers/net/wireless/realtek/rtlwifi/wifi.h        |  2 ++
>>  7 files changed, 71 insertions(+), 8 deletions(-)
>> 
>
> [...]
>
>>  
>> +void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
>> +{
>> +	u8 extid, seq, len;
>> +	u16 bt_real_fw_ver;
>> +	u8 bt_fw_ver;
>> +
>> +	if ((length < 4) || (!tmp_buf))
>> +		return;
>> +
>> +	extid = tmp_buf[0];
>> +	/* not response from BT FW then exit*/
>> +	if (extid != 1) /* C2H_TRIG_BY_BT_FW = 1 */
>> +		return;
>> +
>> +	len = tmp_buf[1] >> 4;
>> +	seq = tmp_buf[2] >> 4;
>> +
>> +	/* BT Firmware version response */
>> +	if (seq == 0x0E) {
>> +		bt_real_fw_ver = tmp_buf[3] | (tmp_buf[4] << 8);
>> +		bt_fw_ver = tmp_buf[5];
>> +
>> +		gl_bt_coexist.bt_info.bt_real_fw_ver = bt_real_fw_ver;
>> +		gl_bt_coexist.bt_info.bt_fw_ver = bt_fw_ver;
>> +	}
>> +}
>
> Just stumbled upon this and curious. I assume gl_bt_coexist is a global
> variable so I guess this code will not work when running multiple
> realtek device with btcoexist on your system.

Good catch, rtlwifi/btcoexist/halbtcoutsrc.c contains two global
variables even with a big fat comment stating that:

----------------------------------------------------------------------
/***********************************************
 *		Global variables
 ***********************************************/

struct btc_coexist gl_bt_coexist;

u32 btc_dbg_type[BTC_MSG_MAX];
----------------------------------------------------------------------

Global variables do not belong to upstream drivers, instead they should
be in per device structures so that multiple devices can be used at the
same time. Now that seems to be horribly broken.

These variables were added back in 2014:

aa45a673b291 rtlwifi: btcoexist: Add new mini driver

-- 
Kalle Valo
