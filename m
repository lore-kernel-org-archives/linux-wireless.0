Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53489 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3DVOY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:24:29 -0400
Message-ID: <5175481B.5070203@openwrt.org> (sfid-20130422_162436_716705_1B9872D5)
Date: Mon, 22 Apr 2013 16:24:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: add support for per-chain signal strength
 reporting
References: <1366461214-61176-1-git-send-email-nbd@openwrt.org> <1366639439.8637.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366639439.8637.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-22 4:03 PM, Johannes Berg wrote:
> On Sat, 2013-04-20 at 14:33 +0200, Felix Fietkau wrote:
> 
>> + * @NL80211_STA_INFO_CHAIN_SIGNAL: per-chain signal strength of last PPDU
>> + * @NL80211_STA_INFO_CHAIN_SIGNAL_AVG: per-chain signal strength average
> 
> please document the units/data structure (nested) here
Will do.

>> +		if (nla_put_u8(msg, i, signal[i]))
>> +			return false;
> 
> does u8 make sense? it takes the same space as u32.
I used u8 because the other signal strength attributes also use u8.

- Felix

