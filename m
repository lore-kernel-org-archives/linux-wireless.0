Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2L0ItJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 03:49:09 -0500
Message-ID: <1356598165.15149.3.camel@jlt4.sipsolutions.net> (sfid-20121227_094915_314133_0433EB40)
Subject: Re: Fw: [Bug 51901] New: mac80211/cfg.c:1995: possible bad call to
 memcpy ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 27 Dec 2012 09:49:25 +0100
In-Reply-To: <50DC0743.8050608@openwrt.org>
References: <20121222135545.1f134c5a@samsung-9>
	  (sfid-20121222_225554_897530_D9193457) <1356594315.15149.1.camel@jlt4.sipsolutions.net>
	 <50DC0743.8050608@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 09:30 +0100, Felix Fietkau wrote:
> On 2012-12-27 8:45 AM, Johannes Berg wrote:
> > On Sat, 2012-12-22 at 13:55 -0800, Stephen Hemminger wrote:
> > 
> >> static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device
> >> *dev,
> >>                     int rate[IEEE80211_NUM_BANDS])
> >> {
> >>     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> >> 
> >>     memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
> > 
> > Seems fine to me. If anyone's bothered by the warning, patch welcome,
> > but the code is ok since it's an array.
> I think the warning is correct and the code needs to be fixed. Since
> rate is a function parameter, sizeof(rate) == sizeof(int).
> I didn't know about this weird aspect of the C standard either, but I
> verified it with a simple user space test program. ;)

Yeah you're right, I even tried to test it but got it wrong. It should
be changed.

johannes

