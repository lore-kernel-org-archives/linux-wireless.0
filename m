Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39019 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab0AQUXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:23:33 -0500
Message-ID: <4B5371C3.6060504@openwrt.org>
Date: Sun, 17 Jan 2010 21:23:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the operating
 frequency and export it through nl80211
References: <4B536B05.6070301@openwrt.org>	 <1263758236.28067.11.camel@johannes.local>	 <1263758423.28067.12.camel@johannes.local>  <4B536F21.1090509@openwrt.org> <1263759278.28067.13.camel@johannes.local>
In-Reply-To: <1263759278.28067.13.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-17 9:14 PM, Johannes Berg wrote:
> On Sun, 2010-01-17 at 21:12 +0100, Felix Fietkau wrote:
> 
>> > If you have an IBSS or managed mode then you know from the BSS info
>> what
>> > channel you should be on... APs are completely userspace controlled
>> > anyway, so are monitors.
>> I was thinking about scanning, but then again, that's not handled by
>> my patch series either. I'll simplify it and make it per-netdev.
> 
> But scanning isn't really interesting, it might be firmware controlled
> or whatever. What do you need the whole thing for? Why export the
> channel at all?
I want to be able to have some status info without having to go through
hostapd or wpa_supplicant to get it. Currently the channel is exported
by wext, but not nl80211, so I want to fix that.

- Felix
