Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45750 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887AbXKEQD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 11:03:57 -0500
Message-ID: <472F3EE3.5040201@lwfinger.net> (sfid-20071105_160406_997867_4D1F356F)
Date: Mon, 05 Nov 2007 10:03:47 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] ssb: Add code for SPROM Rev 4
References: <472c9192.8nd7AOTgl+jWptik%Larry.Finger@lwfinger.net> <200711051351.37252.mb@bu3sch.de>
In-Reply-To: <200711051351.37252.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Larry, I did not forget your patch.
> But I need to think a little bit more about this.

I knew that this one would take some time.

> The union above is not really what I'd like to have here. In fact,
> I think to get the v4 sprom implemented the sprom struct has to be
> redesigned.

The way I implemented it was as a "straw man" designed to get shot down. :-) The only benefit it had
was that this format has allowed my tester to get started enough to get b43 loaded. He is rapidly
implementing that part of the specs that are needed to get the BCM4328 with an N PHY working in G mode.

> I think we must leave the path of partitioning the sprom struct into
> versions, because that obviously doesn't work anymore.
> Instead, I think we must develop _one_ common struct that is capable
> of holding the information from any sprom. (Note that the struct layout
> does not need to reflect the real hardware layout).
> 
> And I think we should also remove the fields that are not needed at all,
> like the PCI ID stuff.

I agree.

> something like this:
> 
> 
> struct ssb_sprom_pathvar {
> 	bool this_pathvar_is_available;
> 
> 	...foobar data
> };
> 
> struct ssb_sprom {
> 	u8 wl_mac_addr[ETH_ALEN];
> 	u8 eth0_mac_addr[ETH_ALEN];
> 	u8 eth1_mac_addr[ETH_ALEN];
> 
> 	...
> 
> 	u8 gpio0;
> 	u8 gpio1;
> 	...
> 
> 	antennagain...
> 
> 	struct ssb_sprom_pathvar pv0;
> 	struct ssb_sprom_pathvar pv1;

I think this section can be

	u8 path_data0[SPROM_PATH_DATA_SIZE];
	u8 path_data1 ...

where SPROM_PATH_DATA_SIZE = 0x26. Once we see how the data are used, it may make more sense to have
these data be u16, or even a union so that we can have it both ways.

> 	...
> };
> 
> Note that I did _not_ look closely at the pathvar stuff, so this
> might be a bad idea to design it this way.
> But the point I was going to make with that was; we probably need
> some "this data is valid" bits for different parts of the sprom
> struct, as for example v1-3 don't have these pathvars (So the drivers
> must be told it's invalid data).
> The reason for all this "valid-bit" stuff is that I think we should
> remove any sprom-versioning knowledge from the drivers. That
> should be abstracted.

I agree.

> Any idea on how to improve that?

I'm not sure we need a separate "valid bit" for path data. In the sprom that we are working with,
only paths 1 & 2 are implemented - the paths 3 & 4 region contains all 1's just like any
unimplemented sprom data. It should be OK to initialize the first word of each path to 0xFFFF to
indicate it is unused.

To let you know how the specs translate into a device, here is the dump of the BCM4328 sprom:

ssb: SPROM r4 dump
ssb: 0x0000: 0x2801 0x0000 0x0009 0x1028 0x0000 0x0DBE 0xFF00 0x2BC4
ssb: 0x0010: 0x2A64 0x2964 0x2C64 0x3CE7 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0020: 0x4328 0x8000 0x0002 0x0000 0x1001 0x1800 0x0000 0x0000
ssb: 0x0030: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0040: 0x5372 0x004C 0x4A01 0x0000 0x0004 0x0000 0x0019 0x7DA5
ssb: 0x0050: 0x1912 0x0000 0x0001 0x83FF 0xFFFF 0xFFFF 0x0303 0x0202
ssb: 0x0060: 0xFFFF 0x3437 0x5B5B 0x1420 0x5B5B 0x0D0C 0x5B5B 0x1A1E
ssb: 0x0070: 0x5B5B 0x3844 0x3838 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0080: 0x3E4E 0xFEC6 0x15D3 0xFB3D 0x0000 0x3E3C 0x3C3C 0xFE6C
ssb: 0x0090: 0x1664 0xFA7B 0x0000 0xFE37 0x1401 0xFAE7 0x0000 0xFE5A
ssb: 0x00A0: 0x147E 0xFAC7 0x0000 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0x3E4E
ssb: 0x00B0: 0xFEC1 0x15BC 0xFB2F 0x0000 0x3E3C 0x3C3C 0xFE69 0x1608
ssb: 0x00C0: 0xFA81 0x0000 0xFE2A 0x1321 0xFB0B 0x0000 0xFE66 0x1595
ssb: 0x00D0: 0xFA88 0x0000 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x00E0: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x00F0: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0100: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0110: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0120: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x0130: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0x0000 0x0000 0x0000 0x0000
ssb: 0x0140: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
ssb: 0x0150: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
ssb: 0x0160: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
ssb: 0x0170: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
ssb: 0x0180: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
ssb: 0x0190: 0x0000 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x01A0: 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF 0xFFFF
ssb: 0x01B0: 0xFFFF 0xFFFF 0xFFFF 0x9404

As I said earlier, my current patch is working OK for present needs. Once we come to an agreement
regarding the sprom data structures, I will begin implementing them. As I see it, conversion will be
a 3-step process. We will need a patch to add the new structure, a second to populate that
structure, patches to convert b44, b43, and b43legacy to use the new data, and a final patch to
remove the old structure. In this manner, bisection will be supported.

Larry
