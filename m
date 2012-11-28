Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56932 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2K1J26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:28:58 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4379401wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:28:57 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	gwingerde@gmail.com, IvDoorn@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] rt2x00: Use addr_mask to disallow invalid MAC addresses in mutli-bssid mode
Date: Wed, 28 Nov 2012 10:28:52 +0100
Message-Id: <1354094932-15703-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121128_102903_356716_00203FFE)
In-Reply-To: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com>
References: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Petr Stetiar <ynezz@true.cz>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 69097d1..f9d9754 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1182,6 +1182,13 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
 
 	/*
+	 * rt2x00 devices can only use the last n bits of the MAC address
+	 * for virtual interfaces.
+	 */
+	rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] =
+		(rt2x00dev->ops->max_ap_intf - 1);
+
+	/*
 	 * Determine which operating modes are supported, all modes
 	 * which require beaconing, depend on the availability of
 	 * beacon entries.
-- 
1.7.7

