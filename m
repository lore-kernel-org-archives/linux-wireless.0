Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49965 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbcEIXLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:23 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 00/21] ath10k patches, generic and CT firmware related.
Date: Mon,  9 May 2016 16:10:54 -0700
Message-Id: <1462835475-11079-1-git-send-email-greearb@candelatech.com> (sfid-20160510_011133_252907_B0052132)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

These are against wireless-testing from a few days ago.

Here are a bunch of ath10k patches.  First one is a crash
fix.  Next few are at least somewhat useful for generic
firmware, and more useful for CT firmware.  Much of it is related
to better debugging of firmware crashes.  If this can go in, then
I can much better handle random bug reports from prople using
stock kernels and CT firmware.  With some small tweaks to how they
package firmware, QCA could benefit as well.

The last bit is some initial support for CT firmware.  I figure it
is a long-shot, but it would surely be nice to get this (and more!)
upstream.  If nothing else, these can be a basis for potential
inclusion in openwrt or similar.

These patches are not overly dependent on each other for the most
part, so even if a few are not acceptable, maybe others can be
applied upstream.

Ben Greear (21):
  ath10k:  Fix crash related to printing features.
  ath10k: fix typo in logging message
  ath10k: Support setting debug mask from driver code.
  ath10k: rate-limit packet tx errors
  ath10k: save firmware debug log messages.
  ath10k: save firmware stacks upon firmware crash
  ath10k: save firmware RAM and ROM BSS sections on crash
  ath10k: make firmware text debug messages more verbose.
  ath10k: print fw debug messages in hex.
  ath10k: support logging ath10k_info as KERN_DEBUG
  ath10k: add fw-powerup-fail to ethtool stats.
  ath10k: Support up to 64 vdevs.
  ath10k: Document cycle count related counters.
  ath10k: Add tx/rx bytes, cycle counters to ethtool stats.
  ath10k: support CT firmware flag.
  ath10k: Support 32+ stations.
  ath10k: Enable detecting failure to install key in firmware (CT).
  ath10k: Note limitation on beaconing vdevs.
  ath10k: Enable adhoc mode for CT firmware.
  ath10k: read firmware crash over ioread32 if CE fails.
  ath10k: Read dbglog buffers over register ping-pong.

 drivers/net/wireless/ath/ath10k/core.c   |  70 ++++++-
 drivers/net/wireless/ath/ath10k/core.h   |  52 +++++-
 drivers/net/wireless/ath/ath10k/debug.c  | 268 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h  |  18 ++
 drivers/net/wireless/ath/ath10k/htt.h    |   7 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  23 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  22 ++-
 drivers/net/wireless/ath/ath10k/hw.h     |  36 ++++
 drivers/net/wireless/ath/ath10k/mac.c    |  74 +++++++-
 drivers/net/wireless/ath/ath10k/pci.c    | 311 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c    |  43 ++++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   6 +
 12 files changed, 897 insertions(+), 33 deletions(-)

-- 
2.4.3

