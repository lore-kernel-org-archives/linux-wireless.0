Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34836 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYFAQaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 12:30:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K2qRW-0004lU-VP
	for linux-wireless@vger.kernel.org; Sun, 01 Jun 2008 16:30:02 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2008 16:30:02 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2008 16:30:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [BISECTED][NEXT] Wifi downloads capped at 105Kbytes/s
Date: Sun, 01 Jun 2008 17:22:04 +0100
Message-ID: <g1uicv$se6$1@ger.gmane.org> (sfid-20080601_183010_521602_3D14D7C5)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Download speeds are never more than 105Kbytes/s even though the bit rate is
54Mb/s in at least linux-net kernels from next-20080523 onwards. I have
bisected it down to commit [2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39]:

commit 2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 15 12:55:27 2008 +0200

    mac80211: use rate index in TX control

    This patch modifies struct ieee80211_tx_control to give band
    info and the rate index (instead of rate pointers) to drivers.
    This mostly serves to reduce the TX control structure size to
    make it fit into skb->cb so that the fragmentation code can
    put it there and we can think about passing it to drivers that
    way in the future.

    The rt2x00 driver update was done by Ivo, thanks.

    Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Reverting this seemed to allow speeds up to 1.3Mbytes/s (which is expected
on this network). I believe I see this behaviour with both iwl3945 and
rt2x00 drivers. Here is the bisection log:

# bad: [7b6c98f0853b86c101948f1bf4e0a21d3065944f] Add linux-next specific
files
# good: [703d73f83f3329ebf5108553017b4a1b66b8fe19] Add linux-next specific
files
git-bisect start 'next-20080523' 'next-20080515'
# good: [3ebc2a4ec3a093e76e402c40ce8e2e5e5f04d86d] Merge
commit 'x86/auto-x86-next'
git-bisect good 3ebc2a4ec3a093e76e402c40ce8e2e5e5f04d86d
# bad: [e290a752da9c074a1a0cf32f404ccf6c7193abcd] Merge
commit 'wireless/master'
git-bisect bad e290a752da9c074a1a0cf32f404ccf6c7193abcd
# good: [8183b598a8acd441c7d7dca5fdc33fbb292ebdf2] Merge commit 'acpi/test'
git-bisect good 8183b598a8acd441c7d7dca5fdc33fbb292ebdf2
# good: [b679aeb304e3070626750c15e043a40da0e942fc] libertas: sysfs interface
for accessing default mesh channel
git-bisect good b679aeb304e3070626750c15e043a40da0e942fc
# good: [4ce50b6156635f2cffbf8961975c2e0b437dbcd9] Merge commit '4xx/next'
git-bisect good 4ce50b6156635f2cffbf8961975c2e0b437dbcd9
# good: [189a2b5942d62bd18e1e01772c4c784253f5dd16] iwlwifi: trigger event
log from debugfs
git-bisect good 189a2b5942d62bd18e1e01772c4c784253f5dd16
# good: [6d4a6672c8263f98544d2b91690dc7074b144090] tipc: Update "previous
node" indicators when node address changes
git-bisect good 6d4a6672c8263f98544d2b91690dc7074b144090
# bad: [e48b0eeb0ab508021b654a45f332b30cac2163b9] b43: Add hooks for
firmware debugging
git-bisect bad e48b0eeb0ab508021b654a45f332b30cac2163b9
# bad: [e039fa4a4195ac4ee895e6f3d1334beed63256fe] mac80211: move TX info
into skb->cb
git-bisect bad e039fa4a4195ac4ee895e6f3d1334beed63256fe
# good: [36d6825b91bc492b65b6333c369cd96a2fc8c903] mac80211: let drivers
wake but not start queues
git-bisect good 36d6825b91bc492b65b6333c369cd96a2fc8c903
# bad: [e24549485f859be6518929bb1c9c0257d79f033d] mac80211: reorder some
transmit handlers
git-bisect bad e24549485f859be6518929bb1c9c0257d79f033d
# bad: [2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39] mac80211: use rate index
in TX control
git-bisect bad 2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39

Perhaps a change was made but drivers have yet to be updated?

-- 
Sitsofe | http://sucs.org/~sits/

