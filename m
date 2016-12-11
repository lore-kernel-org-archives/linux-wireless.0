Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34577 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932088AbcLKPbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 10:31:18 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so8102000oig.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2016 07:31:18 -0800 (PST)
Subject: Re: [PATCH 02/14] rtlwifi_new: Remove RT_TRACE messages that use
 DBG_EMERG
To: Joe Perches <joe@perches.com>, kvalo@codeaurora.org
References: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
 <20161211054523.7119-3-Larry.Finger@lwfinger.net>
 <1481453445.1764.11.camel@perches.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <80f727c1-ee81-a144-22b5-d064bb0df554@lwfinger.net> (sfid-20161211_163122_252348_8B2B32E4)
Date: Sun, 11 Dec 2016 09:31:16 -0600
MIME-Version: 1.0
In-Reply-To: <1481453445.1764.11.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2016 04:50 AM, Joe Perches wrote:
> On Sat, 2016-12-10 at 23:44 -0600, Larry Finger wrote:
>> These messages are always logged and reprresent error conditions, thus
>> we can use pr_err().
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Ping-Ke Shih <pkshih@realtek.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/base.c  | 15 ++++-----
>>  drivers/net/wireless/realtek/rtlwifi/cam.c   | 14 +++------
>>  drivers/net/wireless/realtek/rtlwifi/core.c  | 21 +++++--------
>>  drivers/net/wireless/realtek/rtlwifi/debug.c |  9 ++----
>>  drivers/net/wireless/realtek/rtlwifi/debug.h |  2 +-
>>  drivers/net/wireless/realtek/rtlwifi/efuse.c |  3 +-
>>  drivers/net/wireless/realtek/rtlwifi/pci.c   | 36 ++++++++--------------
>>  drivers/net/wireless/realtek/rtlwifi/ps.c    |  3 +-
>>  drivers/net/wireless/realtek/rtlwifi/rc.c    |  3 +-
>>  drivers/net/wireless/realtek/rtlwifi/usb.c   | 46 +++++++++-------------------
>>  10 files changed, 53 insertions(+), 99 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> []
>> @@ -207,8 +207,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
>>  	 *highest supported RX rate
>>  	 */
>>  	if (rtlpriv->dm.supp_phymode_switch) {
>> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
>> -			 "Support phy mode switch\n");
>> +		pr_err("rtlwifi: Support phy mode switch\n");
>
> I believe most all of these are already prefixed
> by the wifi.h that has a #define pr_fmt

Yes, I missed that. V2 will not include the module name.

Larry
