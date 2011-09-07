Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGSqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:46:13 -0400
Subject: Re: [PATCH 0/2] QoS headers for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com> (sfid-20110907_203731_231306_61E580B9)
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
	 <1315418920.4002.13.camel@jlt3.sipsolutions.net>
	 <1315419259.4002.16.camel@jlt3.sipsolutions.net>
	 <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com>
	 (sfid-20110907_203731_231306_61E580B9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 20:46:09 +0200
Message-ID: <1315421169.4002.18.camel@jlt3.sipsolutions.net> (sfid-20110907_204618_101564_478AC6C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 11:36 -0700, Javier Cardona wrote:

> > So after looking at this again -- what I'd much rather see instead of
> > the second patch, and what will also require fewer changes, is *only*
> > doing the change to ieee80211_set_qos_hdr(). Then, if the peer is a QoS
> > station, we'll get the right header -- if it isn't then we can't really
> > mesh with it but we'll accept that for legacy reasons (for now).
> >
> > I'd rather not send QoS frames to mesh stations that don't advertise QoS
> > capability, and I'd also rather not have to worry about sending QoS
> > frames when we don't actually support it locally.
> 
> OK.  If QoS support is mandatory for mesh stations, then definitely
> that's the way to go.  We'll have to investigate how to advertise QoS
> for mesh interfaces:  this is currently not happening even though all
> the hardware we use for mesh supports it.

Right. I was thinking ... we could also just pretend all mesh stations
are QoS capable and always set the WLAN_STA_WME flag for them. That'd
still be cleaner in terms of how the current code flow works that adds
the QoS header and also wouldn't require any changes other than the one
to ieee80211_set_qos_hdr() (and the one to set WLAN_STA_WME of course).

johannes

