Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYJUNTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 09:19:32 -0400
Subject: Re: Marvell TopDog Driver Work
From: Dan Williams <dcbw@redhat.com>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224533105.6873.22.camel@the-omnibook>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
	 <1224525810.6873.8.camel@the-omnibook>
	 <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>
	 <1224533105.6873.22.camel@the-omnibook>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 09:18:13 -0400
Message-Id: <1224595093.24581.15.camel@localhost.localdomain> (sfid-20081021_151938_647942_453BE91A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 13:05 -0700, Daniel Gimpelevich wrote:
> On Mon, 2008-10-20 at 12:45 -0700, Luis R. Rodriguez wrote:
> > On Mon, Oct 20, 2008 at 11:03 AM, Daniel Gimpelevich
> > <daniel@gimpelevich.san-francisco.ca.us> wrote:
> > 
> > > The "Duh..." was a response to the "Not that I have heard of. Don't
> > > know." statement, which was pretty ironic.
> > 
> > Well your question was "Has anyone stepped up to help in the port of
> > this to mac80211" and I thought you already knew I had that tree.
> 
> I did not ask that, because I saw the tree, and that the initial import
> was from the marvell.git tree. The OP might not have realized that the
> code was TopDog-related even if he did see it. Since there is no working
> mac80211 code for TopDog, any existing hardware-specific code for it may
> prove to be a useful reference during the porting process. Anybody
> investigating the possibility of stepping up to help in the port needs
> to know what is already available and what is not.

Definitely, I've looked at marvell.git (topdog) and Luis's code, and
earlier Marvell GPL code quite extensively.  The firmware interface is
quite similar between the TopDog (802.11n) parts and the b/g parts, as
are the TX and RX descriptors.  From my research, I didn't think it
would be that hard to support both parts in the same driver.

My strategy would be this, assuming you have TopDog hardware.  If you do
not, I can ship you a CardBus TopDog card:

1) Use marvell.git and Luis' attempt to get minimal b/g support working
for the TopDog parts

2) Start adding in the support for 8335/8310 parts using mrv8k (and
possibly BSD's malo(4)) as a guide

3) Add the 802.11n bits of TopDog stuff

The _most_ important thing is first to get a stable b/g driver, then add
the candy later.  Since we have a full TopDog driver implementation,
that might be the best thing to get working first.  mrv8k was never able
to get very far for me when I was poking at it, I couldn't even get
reliable scan results.

> I don't think there is any question of *whether* TopDog support is
> possible in mrv8k, only when, and "right now" does not yet appear to be
> the answer. I really hope to be proven wrong on that, though.

Oh, it's certainly possible in mrv8k.  But obviously you just want to
get something up and running first, then add the tasty bits like N
support later.

Dan


