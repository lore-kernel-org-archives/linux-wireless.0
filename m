Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51518 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab2DLQdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 12:33:05 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 0/5] Add ethtool stats support for Wireless Devices.
Date: Thu, 12 Apr 2012 09:32:50 -0700
Message-Id: <1334248375-22967-1-git-send-email-greearb@candelatech.com> (sfid-20120412_183313_797160_83D15CBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This enables ethtool stats for mac80211 devices.  It also
adds hooks to call down into mac80211 drivers for additional
stats.  Patches to enable this hook in ath9k will be posted
in a different series.

There was a review question about how to make the ethtool
strings line up with the data in a less error prone manner.
This patch series does NOT address that.  I think it may
be more work than it's worth to try to do this, but we
can always retro-fit such behaviour later if desired.
Many drivers have this issue, so perhaps some support
code in the ethtool core is the way to go.

Ben Greear (5):
  cfg80211: Add framework to support ethtool stats.
  mac80211: Support getting sta_info stats via ethtool.
  mac80211: Framework to get wifi-driver stats via ethtool.
  mac80211: Add more ethtools stats: survey, rates, etc
  mac80211: Add sta_state to ethtool stats.

 include/net/cfg80211.h      |   17 +++++
 include/net/mac80211.h      |   17 +++++
 net/mac80211/cfg.c          |  159 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   37 ++++++++++
 net/mac80211/driver-trace.h |   15 ++++
 net/wireless/ethtool.c      |   29 ++++++++
 6 files changed, 274 insertions(+), 0 deletions(-)

-- 
1.7.3.4

