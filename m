Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:38526 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946413AbXBQFlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 00:41:11 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIIIU-0002Je-Kl
	for linux-wireless@vger.kernel.org; Sat, 17 Feb 2007 00:39:46 -0500
Subject: More breakage in wireless-dev.git
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Content-Type: text/plain
Date: Sat, 17 Feb 2007 00:41:08 -0500
Message-Id: <1171690868.31103.17.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

There are more problems with today's wireless-dev.git even after I
applied the two Johannes' patches.

Even after updating DadWifi to the new API, it keeps crashing, and
debugging shows that it doesn't happens around the changes code.

One of the crashes happens in spin_lock_init() on a spinlock that has
just been allocated by ieee80211_alloc_hw().  Maybe the size of the
private area is miscalculated.  I have most checks enabled, including
Ingo's lockdep checker, but everything worked with the yesterday's tree.

In another case, access to another field in the private are causes
kernel oops.  Looking at the code now, I see that both fields are close
to the end on the structure used for private data.  I guess something is
either messing with the private data or not enough space is allocated.

To exclude issues with DadWifi, I tried bcm43xx_d80211 from the kernel.
It has always worked for me, but this time I got a message:

FOUND UNSUPPORTED PHY (Analog 4, Type 0, Revision 7)

Attempt to bring the interface down resulted in this:

slab error in verify_redzone_free(): cache `size-64': double free detected
Call Trace:
 [<ffffffff8027c091>] __slab_error+0x21/0x30
 [<ffffffff8027c908>] cache_free_debugcheck+0xf8/0x220
 [<ffffffff880371cf>] :bcm43xx_d80211:bcm43xx_wireless_core_exit+0x3f/0x90
 [<ffffffff8027cc00>] kfree+0xb0/0x120
 [<ffffffff880371cf>] :bcm43xx_d80211:bcm43xx_wireless_core_exit+0x3f/0x90
 [<ffffffff8803789c>] :bcm43xx_d80211:bcm43xx_remove_interface+0xfc/0x140
 [<ffffffff8800d086>] :80211:ieee80211_stop+0x106/0x130
 [<ffffffff804612a2>] dev_close+0x62/0x90
 [<ffffffff804606bd>] dev_change_flags+0x6d/0x150
 [<ffffffff8049c97c>] devinet_ioctl+0x30c/0x730
 [<ffffffff804623b4>] dev_ioctl+0x304/0x370
 [<ffffffff802435b6>] up_read+0x26/0x30
 [<ffffffff8049d08c>] inet_ioctl+0x4c/0x70
 [<ffffffff804556c0>] sock_ioctl+0x210/0x240
 [<ffffffff8028dcdb>] do_ioctl+0x1b/0x60
 [<ffffffff8028df81>] vfs_ioctl+0x261/0x280
 [<ffffffff8028dfea>] sys_ioctl+0x4a/0x80
 [<ffffffff80209b1e>] system_call+0x7e/0x83

ffff81001d775c38: redzone 1:0x5a2cf071, redzone 2:0x5a2cf071.
slab: double free detected in cache 'size-64', objp ffff81001d775c38

Again, phy is a private part of the network device, and both direct
kfree() calls in bcm43xx_wireless_core_exit() are applied to pointers
kept in phy.

Copying to bcm43xx folks to alert them of the breakage.

-- 
Regards,
Pavel Roskin

