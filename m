Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2JVMvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 08:51:45 -0400
Message-ID: <1350910332.10166.0.camel@jlt4.sipsolutions.net> (sfid-20121022_145148_515091_5AE73D4F)
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 22 Oct 2012 14:52:12 +0200
In-Reply-To: <5084256F.2030502@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	  <1350226137-13704-6-git-send-email-victorg@ti.com>
	 <1350414390.10177.16.camel@jlt4.sipsolutions.net> <5084256F.2030502@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-21 at 18:40 +0200, Victor Goldenshtein wrote:
> On 16/10/2012 21:06, Johannes Berg wrote:
> > Hmm, does that really work? I mean, it can do the update when the event
> > comes in, but is that fast enough, or should it give us the new beacon
> > already when programming the switching?
> >
> 
> Yes it works with our 12xx, in the 12xx the FW (upon channel switch 
> command) is responsible to decrement the channel switch count in the 
> beacon CSA IE and to remove the CSA IE from the beacon once device moves 
> to the new channel (+ to updates the DS).

So ... you've made this kind of behaviour a mandatory part of the
userspace API. Where is it documented then? How will it work with other
devices?

johannes

