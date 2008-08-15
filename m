Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYHOUTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 16:19:43 -0400
Subject: Re: Marvell TopDog Driver Work
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Pat Erley <pat@erley.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20080815195825.GD5935@tesla>
References: <48A5DBAB.9080405@erley.org>  <20080815195825.GD5935@tesla>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 16:08:37 -0400
Message-Id: <1218830917.14841.20.camel@localhost.localdomain> (sfid-20080815_221945_274998_5371DA18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-15 at 12:58 -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 15, 2008 at 12:40:27PM -0700, Pat Erley wrote:
> > Has anyone stepped up to help in the port of this to mac80211?  I just
> > picked up a wrvs4400n router that uses it and have been working on
> > getting 2.6.XX to work with it.
> 
> Not that I have heard of. Don't know.

There's code out there for the TopDog parts (Linville's marvell.git on
kernel.org), and I even have one or two of them lying around.  The
firmware interface isn't that different from the 8335 (mrv8k) and thus
the two product lines can probably share the same driver.

Lennert and Nick (from Marvell) are supposed to be working on a mac80211
driver for the 88w8687 part, which is probably just about the same
firmware interface as TopDog (aside from the N-specific bits, and
different TX & RX descriptors I'm sure).  I'd prefer to either start
fixing up mrv8k and then merge into whatever Lennert comes up with, or
see what they come up with and use that as a base for adding support for
older TopDog and 8310/8335 hardware.

mrv8k was always a bit rocky and never reliably got scan results on the
8335 cardbus hardware I had, even though the descriptor setup and the
mac80211 bits looked right.  There's some pre/post scan commands that we
need to hook into mac80211 which I posted patches for first, but
Johannes requested we not commit those until we really knew whether
pre/post scan were required.

Dan

