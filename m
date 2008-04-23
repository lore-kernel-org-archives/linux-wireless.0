Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYDWQZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:25:41 -0400
Subject: RE: Roaming problems
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <1208962748.31429.84.camel@johannes.berg>
References: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589>
	 (sfid-20080423_114948_059414_17607EB2)  <1208949162.31429.74.camel@johannes.berg>
	 <1208958783.5656.3.camel@localhost.localdomain>
	 <1208962748.31429.84.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 12:21:53 -0400
Message-Id: <1208967713.24395.4.camel@localhost.localdomain> (sfid-20080423_182619_242247_4A6944CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 16:59 +0200, Johannes Berg wrote:
> > > > +		// make sure no association start before we got a new BSSID
> > > > +		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
> > > 
> > > I don't think that patch makes sense, after all, userspace could request
> > > to disassociate and afterwards re-request to associate by setting the
> > > SSID and not setting the BSSID again, which would lose the fixed BSSID
> > > without userspace interaction.
> > > 
> > > However, I'm not sure how to fix this.
> > 
> > Enhance roaming support in wpa_supplicant I'd expect.  If you set the
> > BSSID explicitly, which wpa_supplicant does, then the driver should not
> > roam to any other BSSID until userspace sends SIOCSIWAP
> > 00:00:00:00:00:00 or sets whatever the 'disabled' flag is.  Such is
> > WEXT.
> > 
> > I'm not actually sure why wpa_supplicant sets the BSSID explicitly, but
> > I also haven't looked into it much.
> 
> Lars mentioned that it sets the SSID first and then the BSSID, maybe the
> trivial fix would be to make it do that the other way around?

Maybe, but why should the driver care?  It should be re-attempting
association when either of SSID or BSSID gets set, interrupting any
current ongoing association to a different AP.

Dan


