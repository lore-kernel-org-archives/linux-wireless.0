Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50457 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab0AQUMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:12:19 -0500
Message-ID: <4B536F21.1090509@openwrt.org>
Date: Sun, 17 Jan 2010 21:12:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the operating
 frequency and export it through nl80211
References: <4B536B05.6070301@openwrt.org>	 <1263758236.28067.11.camel@johannes.local> <1263758423.28067.12.camel@johannes.local>
In-Reply-To: <1263758423.28067.12.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-17 9:00 PM, Johannes Berg wrote:
> On Sun, 2010-01-17 at 20:57 +0100, Johannes Berg wrote:
>> On Sun, 2010-01-17 at 20:54 +0100, Felix Fietkau wrote:
>> 
>> > +	int	(*get_channel)(struct wiphy *wiphy,
>> > +			       struct ieee80211_channel **chan,
>> > +			       enum nl80211_channel_type *channel_type);
>> 
>> Can you do that per netdev, please? We'll eventually get into having
>> to support different channels on different netdevs.
> 
> OTOH, where is this really needed?
> 
> If you have an IBSS or managed mode then you know from the BSS info what
> channel you should be on... APs are completely userspace controlled
> anyway, so are monitors.
I was thinking about scanning, but then again, that's not handled by my
patch series either. I'll simplify it and make it per-netdev.

- Felix
