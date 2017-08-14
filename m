Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38844 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdHNTIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 15:08:02 -0400
Received: by mail-wm0-f54.google.com with SMTP id f15so283132wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 12:08:02 -0700 (PDT)
Subject: Re: [PATCH v2 09/10] rtlwifi: use debugfs to debug.
To: Joe Perches <joe@perches.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
 <20170625154344.19213-10-Larry.Finger@lwfinger.net>
 <1502736968.8295.22.camel@perches.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <02ab7fe7-9e82-3aae-1273-321c26129196@broadcom.com> (sfid-20170814_210806_097886_84AE170C)
Date: Mon, 14 Aug 2017 21:08:00 +0200
MIME-Version: 1.0
In-Reply-To: <1502736968.8295.22.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-08-17 20:56, Joe Perches wrote:
> On Sun, 2017-06-25 at 10:43 -0500, Larry Finger wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>

Also the subject line is kinda generic. At least it made me smile ;-p

>> Use debugfs to dump register and btcoex status.
> []
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
> []
>> +void rtl_debug_add_one(struct ieee80211_hw *hw)
>> +{
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
>> +	struct dentry *parent;
>> +
>> +	snprintf(rtlpriv->dbg.debugfs_name, 18, "%02x-%02x-%02x-%02x-%02x-%02x",
>> +		 rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
>> +		 rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
>> +		 rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);
> 
> Why uses dashes and why not just use %pM

Indeed looks like good candidate to use %pM.

Regards,
Arend
