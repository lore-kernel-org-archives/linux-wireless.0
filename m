Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1BDNHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 08:07:32 -0500
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296824755.3671.2.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	 <1296824755.3671.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 14:07:29 +0100
Message-ID: <1296824849.3671.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-04 at 14:05 +0100, Johannes Berg wrote:
> On Fri, 2011-02-04 at 17:55 +0530, Vivek Natarajan wrote:
> 
> > +	if (!(ieee80211_is_nullfunc(hdr->frame_control) &&
> > +	     ieee80211_has_pm(hdr->frame_control)) &&
> > +	    (ifmgd->flags & IEEE80211_STA_PS_PENDING))
> > +		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
> > +
> 
> That's still just as broken before -- you can't assume ifmgd is valid
> here.

Err, never mind, I see you moved it.

johannes

