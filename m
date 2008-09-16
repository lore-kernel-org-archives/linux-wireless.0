Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:60133 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbYIPSRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:17:38 -0400
Received: by ug-out-1314.google.com with SMTP id k3so165841ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 11:17:37 -0700 (PDT)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
Date: Tue, 16 Sep 2008 20:17:31 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mikko =?iso-8859-15?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1221494693.14102.22.camel@virkkmi-linux> <200809152328.50471.IvDoorn@gmail.com> <1221514881.4511.118.camel@localhost>
In-Reply-To: <1221514881.4511.118.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809162017.31956.IvDoorn@gmail.com> (sfid-20080916_201747_252010_96E5638D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008, Mattias Nissler wrote:
> On Mon, 2008-09-15 at 23:28 +0200, Ivo van Doorn wrote:
> > On Monday 15 September 2008, Johannes Berg wrote:
> > > On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:
> > > 
> > > > Well, I'm a big fan of modularizing everything in a clean way. This
> > > > whole mac80211 thingy is complex enough... But I don't really care as
> > > > long as everybody here is happy with it. Let's wait what Mikko says,
> > > > it's his code so far.
> > > 
> > > Sure. If you manage to split it out entirely, maybe by some struct that
> > > drivers embed in their private vif struct, that'd be great too.
> > 
> > I think the ACK handling could become quite complex, and although it
> > would be nice to modularize it a bit, however I am not really sure about
> > what the best approach would be for the implementation other then that
> > the driver should do as little as possible. ;)
> 
> Huh? I think a single function call for the matching in the rx path is
> enough. You call it in the rx handler for every received frame. It
> returns true if it found a match and reported the tx status (in which
> case you stop processing) or false and you can go on doing with the
> frame whatever you want. Am I missing something?

Although this isn't much overhead for a driver, but if it comes down
to a single function call anyway, why not handle it in mac80211 completely?

Ivo
