Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33056 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbeHLVXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 17:23:51 -0400
Received: by mail-wm0-f66.google.com with SMTP id r24-v6so5818960wmh.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2018 11:44:55 -0700 (PDT)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: Kalle Valo <kvalo@codeaurora.org>,
        Kristian Evensen <kristian.evensen@gmail.com>
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B708025.4090906@broadcom.com> (sfid-20180812_204503_893988_BC83DF3E)
Date: Sun, 12 Aug 2018 20:44:53 +0200
MIME-Version: 1.0
In-Reply-To: <871sb3zc3v.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/12/2018 8:14 PM, Kalle Valo wrote:
> Kristian Evensen <kristian.evensen@gmail.com> writes:
>
>> Enable the use of CQM with mt76-devices.
>>
>> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
>> ---
>>   drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
>> index 029d54bc..3eb328ff 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
>> @@ -305,6 +305,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
>>
>>   	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
>>
>> +	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
>
> So have you tested this and with what devices? For example, does it work
> with recently added USB devices?

I was looking into this as it looks suspicious to me. From reading the 
description of this ext_feature flag it seems this is an extention of CQM:

"""
  * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
  *	%NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
  *	RSSI threshold values to monitor rather than exactly one threshold.
"""

Also looking at mt76x2_bss_info_changed() it does not handle 
BSS_CHANGED_CQM so I doubt it has support for it (yet). The driver does 
not use IEEE80211_VIF_SUPPORTS_CQM_RSSI which is a requirement for it.

Regards,
Arend


https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt76x2_main.c#L223
