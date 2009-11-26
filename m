Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbZKZDYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 22:24:45 -0500
Subject: Re: [PATCH] mwl8k: split driver by chipset
From: Dan Williams <dcbw@redhat.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20091123110211.GS20214@mail.wantstofly.org>
References: <1258931158.12095.33.camel@localhost.localdomain>
	 <20091123110211.GS20214@mail.wantstofly.org>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 19:25:03 -0800
Message-Id: <1259205903.3956.101.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-23 at 12:02 +0100, Lennert Buytenhek wrote:
> Hi Dan,
> 
> 
> On Sun, Nov 22, 2009 at 03:05:58PM -0800, Dan Williams wrote:
> 
> > No functional changes, but split the code up to make it
> > easier to add support for other Libertas softmac chipsets
> > like the 88w8361, which has slightly different RX and TX
> > descriptors and some slightly different commands.
> 
> As to RX/TX desc layout, see below.
> 
> 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> > 
> > ---
> > Note: patch is large (code reshuffle) so in case it gets rejected:
> > 
> > http://bigw.org/~dan/mwl8k-split.patch
> 
> I've been thinking about splitting up mwl8k.c for a while as well
> now, but I've resisted it so far, as I wasn't sure what the split
> would have to look like after support for more device types would
> be added.
> 
> The interface with the wireless chip is almost entirely defined
> by the firmware running on it, and not by the actual wireless chip
> itself.  So e.g. putting the RX desc handling in files named after
> the chip is somewhat confusing (but I guess it's my fault for naming
> the rxd ops like that in the first place).

True.

> This isn't just a theoretical issue: there are generally two different
> firmware branches for the chips that mwl8k supports (AP firmware and
> STA firmware), and the rxd format depends on which firmware you use.
> So e.g. if you put a STA firmware image on, say, the 8366, you'll end
> up having to use the rxd ops that are currently marked as being for
> the 8687, and not the "8366" ones.  (I only found this out after
> submitting that round of patches.)
> 
> I was wondering if we should really make the support for each chip a
> different kernel module as you did in your patch, but then I figured
> that this might be a good way to let the user choose whether to load
> AP or STA firmware if we have both available, which was still one of
> the unsolved problems.  I.e., make mwl8366_ap and mwl8366_sta, and
> then let the user choose which one to load.  Or is there a better way
> of doing this?

Ugh.  I'd rather not have different kernel modules like this because
that's not how every other driver works.  It's a pain from userspace
because to switch to AP mode for whatever reason (like for connection
sharing or whatever in NM) we'd need to know to reload the driver and
messing with rmmod/modprobe just sucks.  Like we'd need to have a list
of cards with this issue, and what the module names were, hardcoded into
NM.

I'd much rather have some bit in cfg80211 that says that the card cannot
switch modes without killing all connections and reinitializing the
chip.  Some drivers reload firmware for stuff like this (orinoco, old
prism54, band switches) already.  From userspace it's much more useful
to be able to make a choice based on a flag than to reload hardcoded
modules.

> > Note #2: I've tested firmware loading and up to GET_HW_SPEC with an
> > 8361 card and I assume since there are no functional changes it will
> > continue to work with 8687 and 8366.
> 
> You mentioned that there are slightly different commands on the 8361
> firmware you have -- can you give some examples?

I'm using the 8361 marvell driver dump from linville's kernel.org
'marvell' tree, and also looking at the usb82 linux driver from
Extranet.

Some changes for 8361:

1) 8361 has a 'u32 signature' at the start of the rx & tx descriptors
which is set to a magic value (MRVL_PCI_DMA_SIGNATURE = 0xCAFEEFAC).
This appears to be only for the driver's use in ensuring that the
descriptor pool doesn't get corrupted, but it's part of the rx/tx
descriptors and thus I assume the firmware accounts for it.

2) the STA GET_HW_SPEC command is different; it ends with "caps2" and
does not include "num_tx_desc_per_queue" or "total_rxd"

3) GET_STAT has a different layout; mwl8k looks for ACK_FAILURE at index
9, but on 8361 it's index 5; mwl8k looks for RTS_FAILURE at 12 but on
8361 it's 4, etc.

4) 8361 doesn't appear to implement the "sniffer" stuff, so I had to
ignore the error when setting up the chip

5) struct peer_capability_info is shorter on 8361; it doesn't have
anything after 'ht_rates'

6) The firmware image starts with 0x10, not 0x01.  It does however load
and boot correctly.

That's all I can find for now.

8335 is a whole different beast which might actually deserve it's own
driver based on mwl8k.  It makes more extensive use of MMIO instead of
DMA (ex the helper firmware is written to device memory byte-at-a-time
instead of using DMA) and the command structures are correspondingly
different too.  Obviously it doesn't do 11n.  Might make sense to do a
mwl8k_lib module later on, but at the moment I'll be happy to get
8361pci working.

8338 and 8382 are both USB and of course their command submission will
be different.  We've got the usb82 sources in both Linville's 'marvell'
tree (though I think they are incomplete there) and also the usb82
driver the Extranet.  One step at a time though :)

So maybe we don't need to split up mwl8k yet.  Supporting 8361 may not
pollute the code too much.  8335 or USB support would probably require a
much more extensive split.  I'll go ahead and try to graft on 8361 and
see where I get.

Dan


