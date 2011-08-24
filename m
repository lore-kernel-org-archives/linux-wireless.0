Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65449 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HXTCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:02:31 -0400
Received: by gya6 with SMTP id 6so1106322gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 12:02:30 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [RFC 0/3] enable HT in a mesh
Date: Wed, 24 Aug 2011 12:02:16 -0700
Message-Id: <1314212539-23669-1-git-send-email-thomas@cozybit.com> (sfid-20110824_210234_436333_70C4B446)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi I'm adding HT support for mesh.

This patchset is pretty basic, and relies on Alexander Simon's HT IE helper
funtions. No channel type negotiation takes place, and the HT info IE from the
peer is not even read.

In practice, nodes with mismatched channel types seem to communicate fine,
although throughput is affected (TX from HT40 -> HT20 is the worst case).

We measured these data rates in our (widely uncontrolled) office environment
using the ath9k_htc driver:

        A\B           NO HT             HT20                  HT40+           
       NO HT        r: 54Mb/s         r: MCS 13             r: MCS 13         
                    D: 20Mb/s         D: 16Mb/s             D: 16Mb/s         
       HT20         r: 54Mb/s         r: MCS 13             r: MCS 13         
                   D: 22.5Mb/s       D: 18.5Mb/s            D: 15Mb/s         
       HT40+        r: 54Mb/s         r: MCS 0          r: MCS 12 @ 40Mhz     
                    D: 22Mb/s        D: 5.1Mb/s             D: 20Mb/s  

	r: rate reported by minstrel.
	D: TX throughput (A -> B using 'iperf -c <B> -u -b400M')

Is it odd that even HT40+ -> HT40+ is not any better than the non-HT case? Are
we doing something wrong? Are you surprised that mismatched channel types work
at all?

So currently, our channel type is always just whatever the user configured
through iw. The path selection algorithm should be able to compensate by
detecting faster links and adjusting the respective mpaths accordingly.

If this is completely wrong, I would appreciate any suggestions on the right
way to handle mesh peers with different channel types.

Thanks,
Thomas

Thomas Pedersen (3):
  mac80211: comment allocation of mesh frames
  mac80211: add HT IEs to mesh frames
  mac80211: set HT capabilities for mesh peer

 net/mac80211/mesh.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h       |    4 ++++
 net/mac80211/mesh_hwmp.c  |   10 ++++++++--
 net/mac80211/mesh_plink.c |   39 ++++++++++++++++++++++++++++++++-------
 net/mac80211/tx.c         |   16 +++++++++++++---
 5 files changed, 100 insertions(+), 12 deletions(-)

-- 
1.7.4.1

