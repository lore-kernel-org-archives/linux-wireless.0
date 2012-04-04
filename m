Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35878 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab2DDIpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 04:45:11 -0400
Received: by lahj13 with SMTP id j13so32418lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 01:45:09 -0700 (PDT)
Message-ID: <4F7C0A11.5090808@gmail.com> (sfid-20120404_104517_493000_FD5CE4EA)
Date: Wed, 04 Apr 2012 10:45:05 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Add channel information to NL80211_CMD_GET_INTERFACE
References: <1333463998-19329-1-git-send-email-pontus.fuchs@gmail.com>  (sfid-20120403_164012_468794_1452235E) <1333524885.3912.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333524885.3912.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-04 09:34, Johannes Berg wrote:
> On Tue, 2012-04-03 at 16:39 +0200, Pontus Fuchs wrote:
>> If the current channel is known, add frequency and channel type to
>> NL80211_CMD_GET_INTERFACE.
>>
...

>> -	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
>> +	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
>> +					       enum nl80211_channel_type *type);
>
> If you're adding it to GET_INTERFACE, maybe you should also get it per
> interface so we can do something smarter when we add multi-channel?

We'll fix multi-channel later if needed. Main usage for this (from my 
point of view) is for monitor interfaces.

Cheers,

Pontus
