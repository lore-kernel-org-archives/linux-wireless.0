Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2DUVy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 17:54:56 -0400
Message-ID: <1335045295.6516.5.camel@jlt3.sipsolutions.net> (sfid-20120421_235459_916411_1B41CEED)
Subject: Re: [PATCH v3 2/2] mac80211: fix num_mcast_sta counting issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 21 Apr 2012 23:54:55 +0200
In-Reply-To: <1335045079.6516.4.camel@jlt3.sipsolutions.net> (sfid-20120421_235125_889769_FF8A6D4D)
References: <1335044533-37359-1-git-send-email-nbd@openwrt.org>
	 <1335044533-37359-2-git-send-email-nbd@openwrt.org>
	 <1335045079.6516.4.camel@jlt3.sipsolutions.net>
	 (sfid-20120421_235125_889769_FF8A6D4D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-04-21 at 23:51 +0200, Johannes Berg wrote:
> On Sat, 2012-04-21 at 23:42 +0200, Felix Fietkau wrote:
> 
> >  			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
> > +			new_4addr = true;
> >  		}
> >  
> > +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> > +		    sta->sdata->u.vlan.sta)
> > +			prev_4addr = true;
> 
> Doesn't that have to be before the assignment or something, otherwise
> it's always just true unless it was moved back to the AP iface, but
> still true if it was just assigned to an AP_VLAN iface?

There also seems to be another existing bug, if the station is moved out
of the VLAN interface then the u.vlan.sta isn't cleared.

johannes

