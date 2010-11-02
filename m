Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58846 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0KBIxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 04:53:35 -0400
Date: Tue, 2 Nov 2010 09:53:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 3/7] mwl8k: allow for padding in AP transmit descriptor
Message-ID: <20101102085334.GP1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1288659351-22313-3-git-send-email-brian@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288659351-22313-3-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 01, 2010 at 05:55:47PM -0700, Brian Cavagnolo wrote:

> +/*
> + * The size of the tx descriptors used by the firmware varies depending on
> + * whether we use AP firmware or STA firmware.  However, the fields used by
> + * this driver are identical, so the difference in size is treated as padding
> + * at the end of the structure.
> + */
> +#define MWL8K_TX_DESC_SIZE_STA			32
> +#define MWL8K_TX_DESC_SIZE_AP			52

This is misleading, if not downright a lie.

Only the STA firmware branch bothers to mostly keep a degree of ABI
compatibility -- the TX descriptor for STA firmware images is 32 bytes,
no matter whether you're on 8687, 8363, or 8366.

(I like this very much about STA firmware -- it meant I could take the
8687 STA driver and run it on 8363 and 8366 STA with hardly any changes.
And there's reports that mwl8k runs on 8361P STA with almost no patching
needed either.)

But the AP firmware branch changes stuff around all the time, as the AP
people generally supply their driver along with the firmware, and can
make concurrent changes to those while not having to give a damn about
the other users of their firmware.

E.g., the format of the SET_MAC_ADDR command packet changing if you're
compiling the AP firmware for multi-BSS (a 16 bit field is added in the
_middle_ of the command packet if you do that, see mwl8k_cmd_set_mac_addr)
-- and changing the TX descriptor format is another one of those things.

The reason that the AP TX descriptor for 8366 is 52 bytes is not because
it has been defined to be such, but because the "official" AP driver for
8366 just so happens, at this moment, to have 20 bytes of driver-private
info for every TX packet, which it stashes into the TX descriptor (that
doesn't even make any sense either, but hey).  If next week they decide
they need 4 more bytes for driver-private info, they'll just bump it to
56, and we'll be left to pick up the pieces.

So this

> +#define MWL8K_TX_DESC_SIZE_AP                        52

is very misleading, as:

- It suggests that something is set in stone which isn't set in stone at
  all.
- It only applies to this particular 8366 AP image, and might not apply
  to other 8366 AP images or even AP images in general.

In other words, it's just a quick hack to get things to work for one
more HW/firmware/version combo, but it doesn't solve the problem in a
clean way or in general.  (Then again, you probably don't care about
that anyway.)

Since you're being paid by Marvell to do this, please tell them that
this nonsense needs to stop, and that they need to add something to the
firmware so that the driver can figure out what options the firmware
has been built with, or include some way that we can reliably figure
out which ABI variation to use to talk to the firmware.
