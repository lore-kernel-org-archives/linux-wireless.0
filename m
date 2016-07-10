Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37917 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbcGJSnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 14:43:01 -0400
Received: by mail-wm0-f41.google.com with SMTP id o80so24984160wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2016 11:43:00 -0700 (PDT)
Subject: Re: [RFC v2 1/3] nl80211: Add nl80211_notify_iface
To: Marcel Holtmann <marcel@holtmann.org>,
	Denis Kenzior <denkenz@gmail.com>
References: <1468044967-9236-1-git-send-email-denkenz@gmail.com>
 <1468044967-9236-2-git-send-email-denkenz@gmail.com>
 <1601C89F-62D4-42F5-B5A4-2C9E2F02A673@holtmann.org>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ab4b33b0-cc34-80d1-49a0-51846bb7c7f2@broadcom.com> (sfid-20160710_204310_681031_E4F816E5)
Date: Sun, 10 Jul 2016 20:42:50 +0200
MIME-Version: 1.0
In-Reply-To: <1601C89F-62D4-42F5-B5A4-2C9E2F02A673@holtmann.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 9-7-2016 16:05, Marcel Holtmann wrote:
> Hi Denis,
> 
>> This function emits NL80211_CMD_NEW_INTERFACE or
>> NL80211_CMD_DEL_INTERFACE events.  This is meant to be used by the core
>> to notify userspace applications such as wpa_supplicant when a netdev
>> related to a wireless device has been added or removed.
>>
>> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
>> ---
>> net/wireless/nl80211.c | 28 ++++++++++++++++++++++++++++
>> net/wireless/nl80211.h |  3 +++
>> 2 files changed, 31 insertions(+)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index f39fd4d..da03e17 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -11855,6 +11855,34 @@ void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
>> 				NL80211_MCGRP_CONFIG, GFP_KERNEL);
>> }
>>
>> +void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
>> +				struct wireless_dev *wdev,
>> +				enum nl80211_commands cmd)
>> +{
>> +	struct sk_buff *msg;
>> +	bool removal;
>> +
>> +	WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
>> +		cmd != NL80211_CMD_DEL_INTERFACE);
> 
> I would assume that BUILD_BUG_ON does a way job better here.

Why? I don't see why the condition would be compile-time constant as it
can be called from outside nl80211.c.

Regards,
Arend

> Regards
> 
> Marcel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
