Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47075 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbcHCIBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 04:01:43 -0400
Message-ID: <1470207575.2638.12.camel@sipsolutions.net> (sfid-20160803_100147_139671_837B0843)
Subject: Re: [RFC v2 0/3] Improve wireless netdev detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 03 Aug 2016 08:59:35 +0200
In-Reply-To: <1468044967-9236-1-git-send-email-denkenz@gmail.com> (sfid-20160709_002109_981191_724B98E0)
References: <1468044967-9236-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160709_002109_981191_724B98E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-07-09 at 01:16 -0500, Denis Kenzior wrote:
> The current mechanism to detect hot-plug / unplug of wireless devices
> is
> somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events
> over
> nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
> somehow find a correlation between these events.  This involves
> userspace
> sending GET_INTERFACE or GET_WIPHY commands to the kernel, which
> incurs
> additional roundtrips.
> 
> This patch series proposes that NEW_INTERFACE and DEL_INTERFACE
> events are
> always emitted, regardless of whether a netdev was added/removed by
> the
> driver or explicitly via NEW_INTERFACE/DEL_INTERFACE commands.
> 
> v2: Squished patches 2+3, 4+5.  DEL_INTERFACE event notification is
> now
> sent inside cfg80211_unregister_wdev instead of
> nl80211_del_interface.
> 

Looks fine to me, care to resend as [PATCH]?

johannes
