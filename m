Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37054 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaAWG2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:28:47 -0500
Message-ID: <1390458525.4189.46.camel@porter.coelho.fi> (sfid-20140123_072850_872537_6CBF76B7)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jan 2014 08:28:45 +0200
In-Reply-To: <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for coming to this a bit late, but hopefully not too late. ;)

On Mon, 2014-01-20 at 15:09 +0100, Michal Kazior wrote:
> This extends NL80211_CMD_CHANNEL_SWITCH by adding
> a new attribute NL80211_ATTR_CH_SWITCH_IFACES. The
> attribute holds an array of CSA attributes. Each
> entry holds attributes that were used until now:
> ifindex, chandef, blocktx, beacon/proberesp.

Why is this necessary? I think it's easier to treat the CSA's
separately.  When wpa_supplicant decides to switch channel in one
interface, it asks cfg80211 to do so.  Then, if that interface change is
"approved" (ie. there's no internal reason why it would fail), cfg80211
sends a notification to userspace that the interface will switch.  Then
wpa_s decides whether any other interfaces need switching as well (ie.
if it's in the same channel context).



> The new attribute is used as a flag in
> send_wiphy() and a driver may advertise the
> capability with WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH.
> 
> Userspace may now submit CSA in the old way or
> with the new attribute set. If the new attribute
> is set attributes outside the nested attribute are
> ignored.
> 
> This makes it possible for userspace to request a
> multi-interface channel switch while allowing
> sanity checks wrt target interface/channel
> combination.

Okay, the sanity checks are an interesting issue.  But if the
combination is not good, the whole command will fail and none of the
interfaces will switch.  If wpa_s does this interface-by-interface,
separately, the triggering interface (ie. the one that decided to switch
in the first place) may succeed while the subsequent requests may fail
(eg. if the interface combination is not allowed in the new channel).
If the second one fails, wpa_s may make another decision, for instance
trying to switch the second interface to a *different* channel instead,
or not switch at all.

I think this approach makes things more flexible and simpler.

--
Luca.

