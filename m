Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60379 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0AQVBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 16:01:11 -0500
Message-ID: <4B537A94.9070807@openwrt.org>
Date: Sun, 17 Jan 2010 22:01:08 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the operating
 frequency and export it through nl80211
References: <4B536B05.6070301@openwrt.org>	 <1263758236.28067.11.camel@johannes.local>	 <1263758423.28067.12.camel@johannes.local>  <4B536F21.1090509@openwrt.org>	 <1263759278.28067.13.camel@johannes.local>  <4B5371C3.6060504@openwrt.org> <1263761294.28067.14.camel@johannes.local>
In-Reply-To: <1263761294.28067.14.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-17 9:48 PM, Johannes Berg wrote:
> On Sun, 2010-01-17 at 21:23 +0100, Felix Fietkau wrote:
> 
>> I want to be able to have some status info without having to go
>> through
>> hostapd or wpa_supplicant to get it. Currently the channel is exported
>> by wext, but not nl80211, so I want to fix that.
> 
> But like I said, you already have that information in the relevant
> cases. hostapd you can just look in the config file for it...
Nope, hostapd can deviate from the config, e.g. in the HT40 case. It'll
switch primary and secondary channel, if necessary, or switch from HT40
to HT20 entirely if there are overlapping BSSs. And what about STA mode?
The channel won't be in the config in that case.

> The problem with this is that not all drivers will be able to support
> it, and that you will be exporting stale information say in the case
> where we're not connected at all.
If we document the exported channel for the netdev as 'last configured
channel', it should be fine, IMHO.

- Felix
