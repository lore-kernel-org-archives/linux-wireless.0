Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:37822 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbeAPRCM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 12:02:12 -0500
Received: by mail-oi0-f49.google.com with SMTP id e144so11111378oib.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jan 2018 09:02:12 -0800 (PST)
Subject: Re: [PATCH v2 09/10] rtlwifi: btcoex: Add common function for
 qeurying BT information
To: Kalle Valo <kvalo@codeaurora.org>
Cc: pkshih@realtek.com, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-10-pkshih@realtek.com>
 <47949eee-9fe9-271a-bb4c-a287bbd62ca2@lwfinger.net>
 <87wp0hztq0.fsf@purkki.adurom.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a498462e-74cb-5af0-4463-477838c1ada2@lwfinger.net> (sfid-20180116_180217_888354_9CA714BB)
Date: Tue, 16 Jan 2018 11:02:10 -0600
MIME-Version: 1.0
In-Reply-To: <87wp0hztq0.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2018 09:52 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
>>> From: Ping-Ke Shih <pkshih@realtek.com>
>>>
>>> This commit implement the common function to sort old features, and add
>>> more new features that are get_supported_feature, get_supported_version,
>>> get_ant_det_val, ble_scan_type, ble_scan_para, bt_dev_info,
>>> forbidden_slot_val, afh_map and etc.
>>>
>>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> [...]
> 
>>> @@ -459,6 +461,19 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
>>>      typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void
>>> *in_buf);
>>>    +typedef u32 (*bfp_btc_get_bt_coex_supported_feature)(void
>>> *btcoexist);
>>> +
>>> +typedef u32 (*bfp_btc_get_bt_coex_supported_version)(void *btcoexist);
>>> +
>>> +typedef u8 (*bfp_btc_get_ant_det_val_from_bt)(void *btcoexist);
>>> +
>>> +typedef u8 (*bfp_btc_get_ble_scan_type_from_bt)(void *btcoexist);
>>> +
>>> +typedef u32 (*bfp_btc_get_ble_scan_para_from_bt)(void *btcoexist, u8 scan_type);
>>> +
>>> +typedef bool (*bfp_btc_get_bt_afh_map_from_bt)(void *btcoexist, u8 map_type,
>>> +					       u8 *afh_map);
>>> +
>>>    typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
>>>    				   u32 value);
>>
>> I would prefer that you not add additional typedef statements, but I
>> will let it pass.
> 
> But I can't really take that :( Typedefs are not really liked in
> upstream and just makes code harder to read.

Kalle,

Overnight, I had prepared a patch to remove the typedefs. I have now respun it 
to handle only the old ones. As the merge of this new patch needs to be 
coordinated with PK's patches, I have sent it to him so that he can include it 
with v3 of his series.

Larry
