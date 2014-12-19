Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:49580 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaLSJ7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 04:59:15 -0500
Message-ID: <5493F6E5.5060907@broadcom.com> (sfid-20141219_105918_793930_B1FB9489)
Date: Fri, 19 Dec 2014 10:59:01 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Subject: Re: [RFC V2] cfg80211: Add feature flag for 4-way handshake offload
References: <1418935344-22159-1-git-send-email-arend@broadcom.com> <1418980707.1889.1.camel@sipsolutions.net> <5493F34A.4040500@broadcom.com>
In-Reply-To: <5493F34A.4040500@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/14 10:43, Arend van Spriel wrote:
> On 12/19/14 10:18, Johannes Berg wrote:
>> On Thu, 2014-12-18 at 21:42 +0100, Arend van Spriel wrote:
>>
>>> +    u8 ext_features[(NUM_NL80211_EXT_FEATURES / 8) + 1];
>>
>> Should probably use DIV_ROUND_UP() here.
>
> Will do.

Looking at this again I wonder if it would be of value to have this as 
NL80211_EXT_FEATURES_ATTR_LEN in nl80211.h so user-space can check the 
nla_len() against it and detect API in-compatibility. Just can not use 
DIV_ROUND_UP() in that case. What's your opinion?

Regards,
Arend
