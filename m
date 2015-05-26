Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43149 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbbEZN15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:27:57 -0400
Message-ID: <1432646873.5169.7.camel@sipsolutions.net> (sfid-20150526_152810_769264_3B4E5BB6)
Subject: Re: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely
 other drivers) when fixed mesh paths are used
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Date: Tue, 26 May 2015 15:27:53 +0200
In-Reply-To: <20150525161542.GA14318@localhost> (sfid-20150525_181607_881541_7801FE28)
References: <CAAnMG+OgtSzFXqLOoZ-JbOr7xnexC3P0+M0fFLWTBtWru=4SKg@mail.gmail.com>
	 <20150525161542.GA14318@localhost> (sfid-20150525_181607_881541_7801FE28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 12:15 -0400, Bob Copeland wrote:
> On Thu, May 21, 2015 at 06:05:13PM -0700, Alexis Green wrote:
> > This patch fixes a NULL dereference in ath9k (and likely other drivers) when
> > fixed mesh paths are used. The problem is that when a station comes up
> > sta_info_alloc allocates ath_node implicitly via hw->sta_data_size. When it
> > does that the ath_node is zeroed out. The ath_node isn’t actually initialized
> > until the station becomes associated and ath9k_sta_state is called.
> 
> Good catch.
> 
> I wonder if we should instead remove the mesh special case in
> ieee80211_tx_h_check_assoc() -- given that we require an assoc station in
> peering before we send data frames to that RA, and userspace should also be
> setting assoc flag after MPM completes, I can't think of a reason offhand why
> we'd need to bail out there.
> 
> Does this also fix the problem for you?  It passed the wpa_supplicant test
> cases at least (but we aren't fixing mpaths in any of those...)
> 
> From 246febaa51d555fda437cc8064798db06c5f4d6e Mon Sep 17 00:00:00 2001
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 25 May 2015 12:01:52 -0400
> Subject: [PATCH] mac80211: enable assoc check for mesh interfaces
> 
> We already set a station to be associated when peering completes,
> both in user space and in the kernel.  Thus we should always have
> an associated sta before sending data frames to that station.
> 
> Failure to do this can cause crashes in the lower-level driver due
> to transmitting unicast data frames before driver sta structures
> (e.g. ampdu state in ath9k) are initialized.  This could have
> happened if fixing mpaths, which could then allow TX to stations
> with whom we haven't yet completed peering.
> 
> Reported-by: Alexis Green <agreen@cococorp.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

This looks reasonable to me - Alexis?

johannes

