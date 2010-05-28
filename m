Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43949 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0E1HBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 03:01:51 -0400
Subject: Re: [PATCH] cfg80211: Removed warning from cfg80211_send_rx_auth
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274952442.3669.28.camel@jlt3.sipsolutions.net>
References: <1274870625-19712-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1274872877.3658.4.camel@jlt3.sipsolutions.net>
	 <1274950081.20619.18.camel@paavo-desktop>
	 <1274952442.3669.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Fri, 28 May 2010 09:55:55 +0300
Message-Id: <1275029755.20619.1261.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 11:27 +0200, ext Johannes Berg wrote:
> On Thu, 2010-05-27 at 11:48 +0300, Teemu Paasikivi wrote:
> > On Wed, 2010-05-26 at 13:21 +0200, ext Johannes Berg wrote:
> > > On Wed, 2010-05-26 at 13:43 +0300, Teemu Paasikivi wrote:
> > > > In cfg80211_send_rx_auth function there was a warning if bssid of the received
> > > > authentication message was not found from the authtry_bsses table.
> > > > 
> > > > During the beginning of the authentication there is a small time window, when
> > > > handling of the received deauthentication message can cause information
> > > > for the access point to be removed from the authtry_bsses table before
> > > > authentication response is received. This triggers the warning. This has
> > > > been seen happening with several access points occasionally. At least
> > > > one of those (Asus) has been seen to send spurious deauthentication
> > > > messages after deauthentication. Possibly this warning could be triggered also
> > > > by forged deauthentication messages sent at a correct time.
> > > 
> > > This doesn't seem right. Why is mac80211 not preventing those messages
> > > from bubbling up in that case?
> > > 
> > > FWIW, this check is there for a reason -- we want to avoid telling
> > > userspace twice that we disconnected from a given AP, and we shouldn't
> > > be processing it anyway.
> 
> > Normally, when the stack in the idle state, or connected to other access
> > point, those deauth messages doesn't cause a problem. The problem arises
> > if that spurious deauth message is received at the right moment, when
> > authentication to the access point has been started but response is not
> > yet received. If I'm correct in that the deauthentication message from
> > the AP during authentication is legal, this would be quite hard to
> > filter out.
> 
> Yes .. I understand the scenario. You don't want to filter it out, you
> want to abort the authentication so you kill the work for it and never
> send the timeout to cfg80211.
> 
> johannes
> 

Isn't that already done? Aborting the authentication, I mean. The
warning is triggered by the authentication response in the
cfg80211_send_rx_auth function. Removal of the warning would keep logs
clean. I suppose that in the case where wdev->sme_state !=
CFG80211_SME_CONNECTING we could just bail out from the
cfg80211_send_rx_auth function instead of removing the warning.


Teemu


