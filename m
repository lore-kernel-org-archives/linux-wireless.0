Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:29491 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYEOLqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:46:08 -0400
Received: by fk-out-0910.google.com with SMTP id 18so261163fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 04:46:07 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
Date: Thu, 15 May 2008 13:58:35 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <20080515105524.359863000@sipsolutions.net> <200805151332.35758.IvDoorn@gmail.com> <1210850544.8709.3.camel@johannes.berg>
In-Reply-To: <1210850544.8709.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805151358.36340.IvDoorn@gmail.com> (sfid-20080515_134614_166877_597AD71F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 May 2008, Johannes Berg wrote:
> 
> > > > A number of fixes were done by Ivo, as well as the rt2x00 part
> > > > of this patch.
> > > 
> > > I mangled it a bit though so you may want to check it, mac80211 now sets
> > > REQ_TX_STATUS so you can use that for status reporting, but you can't
> > > use it for queue kicking at least not in the future when mac80211 might
> > > not set it on all frames.
> > 
> > Well queue kicking from driver to mac80211 is in rt2x00 based on txdone
> > events on a particular queue. (When frame was succesfully transmitted
> > and is no longer full, then the queue will be awakened by rt2x00).
> 
> Yeah, but the patch you had sent me was removing the "driver generated"
> flag, and I kept that around now for this purpose.

I think we refer to different things when we talk about "queue kicking" ;)
Anyway, I'm fine with how it looks like now. It means I can remove a few
patches from rt2x00.git :)

> I have thought about this a bit, you may want to wait wrt. fragments
> because I'm going to rewrite fragmentation, and then we could change the
> mac80211/driver API to hand the driver an skb with all the fragments at
> once instead of handing it each fragment one by one, thoughts?

Well that would mostly be beneficial for rt61pci who is able to attach
multiple fragments into a single queue entry. But for the others that wouldn't
matter that much since each fragment occupies a single queue entry, so for
those drivers having mac80211 calling tx() multiple times, or having rt2x00
call write_tx_frame() multiple times isn't a big difference other then rt2x00
being able to better control frame flow by kicking the TX queue only when
all fragments are in the queue.

Ivo
