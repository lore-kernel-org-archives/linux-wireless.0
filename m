Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:51543 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYIOV2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:28:55 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1286515nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 14:28:53 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
Date: Mon, 15 Sep 2008 23:28:50 +0200
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Mikko =?iso-8859-15?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1221494693.14102.22.camel@virkkmi-linux> <1221510009.4511.99.camel@localhost> <1221510785.3700.87.camel@johannes.berg>
In-Reply-To: <1221510785.3700.87.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809152328.50471.IvDoorn@gmail.com> (sfid-20080915_232859_956870_D748327C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008, Johannes Berg wrote:
> On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:
> 
> > Well, I'm a big fan of modularizing everything in a clean way. This
> > whole mac80211 thingy is complex enough... But I don't really care as
> > long as everybody here is happy with it. Let's wait what Mikko says,
> > it's his code so far.
> 
> Sure. If you manage to split it out entirely, maybe by some struct that
> drivers embed in their private vif struct, that'd be great too.

I think the ACK handling could become quite complex, and although it
would be nice to modularize it a bit, however I am not really sure about
what the best approach would be for the implementation other then that
the driver should do as little as possible. ;)

Perhaps Mikko or the zd1211rw developers will have better ideas on this subject. :)

> > > But ACK is getting confusing, we're just reporting status based on
> > > reception (or non-reception!) of ACKs :) How about retries in the hw?
> > 
> > Retries in the hw? I don't understand? You mean that as a name?
> 
> Well, with all this we won't know how many times the hardware attempted
> to send a frame before it got an ACK, if it got one at all. We'd like to
> know this too, I guess, for the rate control algorithm.

Well this information would definately get lost with this ACK handling,
but at least we get *some* information about the TX status. ;)

Ivo
