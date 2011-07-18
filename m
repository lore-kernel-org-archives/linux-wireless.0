Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1GRPHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 11:07:49 -0400
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAPjQAd895Ggdf0gK+HhnTMkNPX3mkd9=CqXhxU1whtMJvptZ=Q@mail.gmail.com> (sfid-20110718_161212_400250_0940E61F)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-6-git-send-email-thomas@cozybit.com>
	 <20110714062522.GA2534@jm.kir.nu>
	 <CAG6hwVN3HED+LZdKN0zpNfjmK9FmBuBWnZ0qe9gYTPPYmCedTg@mail.gmail.com>
	 <1310724023.4164.22.camel@jlt3.sipsolutions.net>
	 <CAPjQAd895Ggdf0gK+HhnTMkNPX3mkd9=CqXhxU1whtMJvptZ=Q@mail.gmail.com>
	 (sfid-20110718_161212_400250_0940E61F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 17:07:44 +0200
Message-ID: <1311001664.3942.7.camel@jlt3.sipsolutions.net> (sfid-20110718_170754_014304_1FD75E2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-18 at 07:11 -0700, Javier Cardona wrote:

> > I don't think PS support can be hard. We have all of it in AP mode
> > anyway, so you just need to generalise that a bit, maybe refactor like I
> > said in my other email, and you should be able to get it up & running
> > pretty quickly?
> 
> Mesh frame buffering can probably reuse most of the AP mode, yes.  The
> difficult part is on the receiving STA as it must track the beacon
> transmit times of each mesh peer.  I don't know how/if we can
> implement this in a vendor-neutral mac80211ish sort of way.
> 
> That said, only buffering seems to be mandatory: "A mesh STA SHALL
> have the capability to buffer frames and to perform mesh power mode
> tracking" but "A mesh STA MAY use mesh power modes to reduce its power
> consumption".

Right, if you don't want to go to sleep yourself you shouldn't really
have big issues different from the current PS code. Of course, you might
not have all the nice HW help we have for normal station mode, but
mac80211 can already deal with that (filtered frames etc.)

Implementing actual powersaving will likely be a bigger issue.

johannes

