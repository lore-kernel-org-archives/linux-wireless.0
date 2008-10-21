Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.dslextreme.com ([66.51.199.81]:34085 "HELO
	mail5.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751179AbYJUXQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 19:16:45 -0400
Subject: Re: Marvell TopDog Driver Work
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224595093.24581.15.camel@localhost.localdomain>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
	 <1224525810.6873.8.camel@the-omnibook>
	 <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>
	 <1224533105.6873.22.camel@the-omnibook>
	 <1224595093.24581.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 16:16:43 -0700
Message-Id: <1224631003.6873.39.camel@the-omnibook> (sfid-20081022_011648_952224_1A8DD99A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-21 at 09:18 -0400, Dan Williams wrote:
> Definitely, I've looked at marvell.git (topdog) and Luis's code, and
> earlier Marvell GPL code quite extensively.  The firmware interface is
> quite similar between the TopDog (802.11n) parts and the b/g parts, as
> are the TX and RX descriptors.  From my research, I didn't think it
> would be that hard to support both parts in the same driver.
> 
> My strategy would be this, assuming you have TopDog hardware.  If you do
> not, I can ship you a CardBus TopDog card:

The only TopDog hardware I have is the aforementioned Orion-based
router, which has OpenWRT in its future. That certainly fits the
strategy, but with somewhat unfortunate timing. I previously had access
to an 8335 card, but don't currently.

> 1) Use marvell.git and Luis' attempt to get minimal b/g support working
> for the TopDog parts
> 
> 2) Start adding in the support for 8335/8310 parts using mrv8k (and
> possibly BSD's malo(4)) as a guide
> 
> 3) Add the 802.11n bits of TopDog stuff

That contrasts slightly with the understanding I had:
1) Use the in-tree libertas library to get b/g going for 8335/8310
parts, using mrv8k/malo as a guide.
2) Start adding in the support for TopDog parts in b/g mode, from
mrvl_cb82.git
3) Add the 802.11n bits of TopDog stuff

> The _most_ important thing is first to get a stable b/g driver, then add
> the candy later.

I could not agree more.

> Since we have a full TopDog driver implementation,

Do we?

> that might be the best thing to get working first.  mrv8k was never able
> to get very far for me when I was poking at it, I couldn't even get
> reliable scan results.

