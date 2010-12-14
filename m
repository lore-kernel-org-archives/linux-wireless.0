Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0LNHsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:48:25 -0500
Subject: Re: [PATCH] nl80211: Add notification for dropped Deauth/Disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101214074653.GA28072@jm.kir.nu>
References: <20101213220048.GA24752@jm.kir.nu>
	 <1292310907.3569.1.camel@jlt3.sipsolutions.net>
	 <20101214074653.GA28072@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 08:48:22 +0100
Message-ID: <1292312902.3569.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-14 at 09:46 +0200, Jouni Malinen wrote:
> On Tue, Dec 14, 2010 at 08:15:07AM +0100, Johannes Berg wrote:
> > On Tue, 2010-12-14 at 00:00 +0200, Jouni Malinen wrote:
> > > + * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
> > > + * @NL80211_CMD_UNPROT_DISASSOCIATE: Unprotected disassociation frame
> > 
> > I don't mind, but if we add the frame body should we really have two
> > commands? Or should we have just one? Are we likely to need similar
> > functionality for other frames? The only ones I can think of are class 3
> > frames from unassociated stations, but that seems like it should be
> > separate anyway.
> 
> This one followed the existing example of NL80211_CMD_DEAUTH/DISASSOC,
> but well, those are for both notification and requests, so I can see the
> difference there.. For these notification-only ones, I would be fine
> having a single command if that is desirable. Though, I would probably
> not go as far as merging any other frames to this list since
> deauth/disassoc are special case for the AP starting to send these as
> replies to any Class 2 or 3 frame.

Ok. I don't think we really need to go to a single command, and this may
be more helpful for drivers that might not be able to give us the frame
at all due to firmware implementation, so maybe it's better to keep it
as is and not rely on the frame in wpa_s.

johannes

