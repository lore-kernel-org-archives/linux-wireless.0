Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3061 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZBWQoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 11:44:24 -0500
Date: Mon, 23 Feb 2009 11:44:15 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090223164415.GA3558@hash.localnet> (sfid-20090223_174427_702725_7DB7F806)
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com> <40f31dec0902230815x6b43fa50h41edfeead96822a3@mail.gmail.com> <20090223162103.GA3383@hash.localnet> <40f31dec0902230827j5c0f9f20je02c7fb02709f71e@mail.gmail.com> <20090223163032.GA3450@hash.localnet> <40f31dec0902230841m712acff4qe1c1617819f028be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0902230841m712acff4qe1c1617819f028be@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 06:41:01PM +0200, Nick Kossifidis wrote:
> > No, that's intentional.  That was actually a bug we had at some point
> > (rs_more is a u8 so the bitwise AND overflowed).  The "!!" makes it zero
> > or one so it fits.
> >
> 
> AR5K_REG_MS is used for that, we should just shift it as we do with
> the other fields and btw i think we must change flags to be bool.

Fine with me, in fact I wrote it that way first but someone suggested
"!!" instead in a patch review.  Either way works.  Also ACK on using 
bool.

-- 
Bob Copeland %% www.bobcopeland.com

