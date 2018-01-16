Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbeAPPwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 10:52:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: pkshih@realtek.com, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 09/10] rtlwifi: btcoex: Add common function for qeurying BT information
References: <20180111070932.9929-1-pkshih@realtek.com>
        <20180111070932.9929-10-pkshih@realtek.com>
        <47949eee-9fe9-271a-bb4c-a287bbd62ca2@lwfinger.net>
Date: Tue, 16 Jan 2018 17:52:39 +0200
In-Reply-To: <47949eee-9fe9-271a-bb4c-a287bbd62ca2@lwfinger.net> (Larry
        Finger's message of "Mon, 15 Jan 2018 13:15:59 -0600")
Message-ID: <87wp0hztq0.fsf@purkki.adurom.net> (sfid-20180116_165246_927909_EC73D82B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> This commit implement the common function to sort old features, and add
>> more new features that are get_supported_feature, get_supported_version,
>> get_ant_det_val, ble_scan_type, ble_scan_para, bt_dev_info,
>> forbidden_slot_val, afh_map and etc.
>>
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

>> @@ -459,6 +461,19 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
>>     typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void
>> *in_buf);
>>   +typedef u32 (*bfp_btc_get_bt_coex_supported_feature)(void
>> *btcoexist);
>> +
>> +typedef u32 (*bfp_btc_get_bt_coex_supported_version)(void *btcoexist);
>> +
>> +typedef u8 (*bfp_btc_get_ant_det_val_from_bt)(void *btcoexist);
>> +
>> +typedef u8 (*bfp_btc_get_ble_scan_type_from_bt)(void *btcoexist);
>> +
>> +typedef u32 (*bfp_btc_get_ble_scan_para_from_bt)(void *btcoexist, u8 scan_type);
>> +
>> +typedef bool (*bfp_btc_get_bt_afh_map_from_bt)(void *btcoexist, u8 map_type,
>> +					       u8 *afh_map);
>> +
>>   typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
>>   				   u32 value);
>
> I would prefer that you not add additional typedef statements, but I
> will let it pass.

But I can't really take that :( Typedefs are not really liked in
upstream and just makes code harder to read.

-- 
Kalle Valo
