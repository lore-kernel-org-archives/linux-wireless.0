Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:18345 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYHOMty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 08:49:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644039nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2008 05:49:53 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/5] rt2x00: Need to set wiphy->interface_modes
Date: Fri, 15 Aug 2008 14:49:18 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
References: <200808151445.07795.IvDoorn@gmail.com> <200808151446.01043.IvDoorn@gmail.com> <200808151446.34060.IvDoorn@gmail.com>
In-Reply-To: <200808151446.34060.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200808151449.18412.IvDoorn@gmail.com> (sfid-20080815_144958_829313_0719F23D)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>

One day I will understand the patching process. This patch is needed to
meet a requirement of Linux 2.6.27 drivers. Without it, userspace fails
to set the device to AP mode.

Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this one is for 2.6.28
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5278ae2..b363fad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1052,6 +1052,11 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
 
+	rt2x00dev->hw->wiphy->interface_modes =
+	    BIT(NL80211_IFTYPE_AP) |
+	    BIT(NL80211_IFTYPE_STATION) |
+	    BIT(NL80211_IFTYPE_ADHOC);
+
 	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
-- 
1.5.6.1

