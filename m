Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3716 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYKPQVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 11:21:06 -0500
Date: Sun, 16 Nov 2008 11:20:19 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan McGee <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081116162019.GA15851@hash.localnet> (sfid-20081116_172111_497179_787DE4C5)
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com> <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com> <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com> <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com> <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com> <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com> <20081116055312.GA14126@hash.localnet> <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com> <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com> <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 10:15:31PM -0800, Luis R. Rodriguez wrote:
> The answer is drivers/base/dd.c really_probe(). Curious enough guess
> what, dev->driver = drv; is assigned *before* the device driver probe
> :) (bus probe in this case first, so dev->bus->probe) contrary to the
> other way around. So you're absolutely right the patch is not
> necessary then. Good catch.

Cool, so that's where that is.  

I got some more info, this looks like a miscompilation of some kind,
maybe a mismatch between kernel config and compat-wireless, but I didn't
see anything obvious.

Here's what I did:

--- drivers/net/wireless/ath5k/base.c	2008-11-14 00:11:09.000000000 -0500
+++ drivers/net/wireless/ath5k/my-base.c	2008-11-16 11:01:42.000000000 -0500
@@ -490,6 +490,9 @@
 		goto err_map;
 	}
 
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, 
+		hw->wiphy, sizeof(struct wiphy), 1);
+	printk(KERN_INFO "offset: %d\n", offsetof(struct wiphy, dev.bus_id));
 	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
 
 	/* Initialize driver private data */

Which produced:

ath5k_pci 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath5k_pci 0000:02:00.0: setting latency timer to 64
00000000: 00 00 00 00 00 00 00 00 b4 ea 07 b7 00 00 00 00  ................
00000010: 00 00 00 00 54 c0 03 b3 54 c0 03 b3 9a c0 24 78  ....T...T.....$x
00000020: 58 c0 24 78 00 00 00 00 00 00 00 00 00 00 00 00  X.$x............
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000080: c0 c0 03 b3 c0 c0 03 b3 00 00 00 00 40 b2 c0 b5  ............@...
00000090: 28 cf 42 78 00 00 00 00 01 00 00 00 01 00 00 00  (.Bx............
000000a0: 70 68 79 30 00 00 00 00 00 00 00 00 00 00 00 00  phy0............
000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000000c0: 01 00 00 00 04 c1 03 b3 04 c1 03 b3 00 00 00 00  ................
000000d0: 00 00 00 00 00 00 00 00 00 c0 03 b3 00 00 00 00  ................
000000e0: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000100: 40 c1 03 b3 40 c1 03 b3 00 00 00 00 00 00 00 00  @...@...........
00000110: 50 c1 03 b3 50 c1 03 b3 58 c1 03 b3 58 c1 03 b3  P...P...X...X...
00000120: 2c 0f 45 78 00 00 00 00 00 00 00 00 00 00 00 00  ,.Ex............
00000130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
offset: 164
ath5k_pci 0000:02:00.0: registered as ''
BUG: unable to handle kernel NULL pointer dereference at 00000000

As you can see, the modules think "phy0" should be at offset 164, but
it's really at 160.

Also I noticed the original config had CONFIG_DYNAMIC_FTRACE=y, unfortunately
turning that off didn't seem to change anything (hmm, I didn't get a build 
bug, was the breakage fixed in 2.6.27.y?)

-- 
Bob Copeland %% www.bobcopeland.com

