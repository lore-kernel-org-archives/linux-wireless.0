Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2DWGr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 02:47:26 -0400
Message-ID: <1335163643.3928.0.camel@jlt3.sipsolutions.net> (sfid-20120423_084733_278515_4FDDF329)
Subject: Re: [PATCH v3 2/2] mac80211: fix num_mcast_sta counting issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 23 Apr 2012 08:47:23 +0200
In-Reply-To: <4F9461E9.2050504@openwrt.org>
References: <1335044533-37359-1-git-send-email-nbd@openwrt.org>
	  <1335044533-37359-2-git-send-email-nbd@openwrt.org>
	 <1335045079.6516.4.camel@jlt3.sipsolutions.net>
	 <4F9461E9.2050504@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-22 at 21:54 +0200, Felix Fietkau wrote:
> On 2012-04-21 11:51 PM, Johannes Berg wrote:
> > On Sat, 2012-04-21 at 23:42 +0200, Felix Fietkau wrote:
> > 
> >>  			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
> >> +			new_4addr = true;
> >>  		}
> >>  
> >> +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> >> +		    sta->sdata->u.vlan.sta)
> >> +			prev_4addr = true;
> > 
> > Doesn't that have to be before the assignment or something, otherwise
> > it's always just true unless it was moved back to the AP iface, but
> > still true if it was just assigned to an AP_VLAN iface?

> This is just before the 'sta->sdata = vlansdata;' line, so it should be
> OK. Or am I missing something here?

Ah, I guess I missed that. Or maybe I was thinking what I also said on
IRC -- when you move a station out of the 4addr VLAN u.vlan.sta is never
reset to NULL.

johannes

