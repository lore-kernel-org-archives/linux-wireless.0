Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2403 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYLSPR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 10:17:56 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Stefanik_G=C3=A1bor_?= <netrolller.3d@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
Date: Fri, 19 Dec 2008 10:15:16 -0500
Message-Id: <20081219151036.M48373@bobcopeland.com> (sfid-20081219_161803_442916_CD84B65D)
In-Reply-To: <1229439670.4471.41.camel@johannes.berg>
References: <20081118044037.GA18983@hash.localnet> <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com> <1229357080.12163.47.camel@localhost.localdomain> <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com> <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com> <b6c5339f0812160658y5ed2ceb4qdbb4b2ddf1fe07a5@mail.gmail.com> (sfid-20081216_155826_911157_CE1A0E9E) <1229439670.4471.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 16 Dec 2008 16:01:09 +0100, Johannes Berg wrote
> > The ath5k rx filter for unicast frames requires mac addresses to match in
> > order to accept or ack frames.  However, in monitor mode, mac80211 will
> > never call add_interface().  Instead, it should configure the filter to
> > put the card in promiscuous mode which then should enable all packets
> > to be passed back to the host.
> 
> FWIW, this is as designed, if you need to have ACKs then you need to
> bring up a monitor as well as a regular interface. Stefanik, please do
> that and report whether it works.

So in that case, ath5k definitely should not upload a mac until a normal
interface is brought up, i.e. we should keep the current functionality?

It's interesting that b43 works without a regular interface, by my reading of
its code the mac is also loaded and cleared at add/remove interface time.

-- 
Bob Copeland %% www.bobcopeland.com


