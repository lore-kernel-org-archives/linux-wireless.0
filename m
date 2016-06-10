Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39483 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbcFJSnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 14:43:37 -0400
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
 <56B38FD1.40902@candelatech.com> <1455827536.2084.35.camel@sipsolutions.net>
 <56C62C4E.7020600@candelatech.com>
 <1455828330.2084.38.camel@sipsolutions.net>
 <56C630B7.7020604@candelatech.com>
 <1455830078.2084.47.camel@sipsolutions.net>
 <56C63D8B.9020900@candelatech.com>
 <1456225589.2041.24.camel@sipsolutions.net>
 <56E1B556.4080004@candelatech.com>
 <1458051349.2871.19.camel@sipsolutions.net>
 <56E833FE.1080904@candelatech.com>
 <1458073224.2871.22.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <575B0A58.8070408@candelatech.com> (sfid-20160610_204341_920494_02F468AF)
Date: Fri, 10 Jun 2016 11:43:36 -0700
MIME-Version: 1.0
In-Reply-To: <1458073224.2871.22.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2016 01:20 PM, Johannes Berg wrote:
> On Tue, 2016-03-15 at 09:10 -0700, Ben Greear wrote:
>>
>> The logic I wrote is basically exactly this.  It uses the configured
>> rates to specify which of the hardware's rates are allowed and
>> disabled.
>>
>
> I understand that. I just take issue with the fact that we have to
> sprinkle "magic pixie dust" (in form of the override function calls)
> everywhere throughout the code.
>
> johannes
>

So, I never could think up a way to make this more acceptable and meet
my own goals.

Any chance I could get just the netlink enum in place, even if it is
called something like 'api_placeholder_x'?

Otherwise, it is about impossible for me to keep any sane forward/back
compatibility with my hostap patches....

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0ab6b0..4573f87 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2130,6 +2130,8 @@ enum nl80211_attrs {

  	NL80211_ATTR_REG_INDOOR,

+	NL80211_ATTR_TX_ADVERT_RATEMASK,
+
  	/* add attributes here, update the policy in nl80211.c */

  	__NL80211_ATTR_AFTER_LAST,


Or, is there some other way to handle out-of-tree netlink stuff better?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

