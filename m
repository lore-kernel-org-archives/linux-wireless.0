Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1CHTSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 14:18:38 -0500
Subject: Re: [RFC] mac80211: New notification to discover mesh peer
 candidates.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinSirogOWqx2X-LTHdL01vyNdJkApJ7gQwM6zj=@mail.gmail.com>
References: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
	 <1299550284-3167-2-git-send-email-javier@cozybit.com>
	 <1299597000.4676.19.camel@jlt3.sipsolutions.net>
	 <AANLkTinSirogOWqx2X-LTHdL01vyNdJkApJ7gQwM6zj=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 20:18:33 +0100
Message-ID: <1299611913.3734.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 10:56 -0800, Javier Cardona wrote:

> With this approach, when security is enabled, the decision to create
> the station is still made by the userspace daemon.  A normal sequence
> would be:
> 
> beacon is received
> mesh_matches_local is true
> no peer exists
> send NEW_PEER_CANDIDATE notification
> userspace creates unauthenticated station (optionally, to stop notifications)
> userspace authenticates station
> userspace sets authenticated flag
> 
> But alternatively userspace can create no station at all.  In that
> case a NEW_PEER_CANDIDATE notification is sent for every beacon
> received.

Ah, for some reason I thought mac80211 was now creating the
unauthenticated stations. I'll take another look.

johannes

