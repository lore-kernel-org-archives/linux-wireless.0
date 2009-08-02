Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5760 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZHBSaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 14:30:19 -0400
Subject: [PATCH 2/2] rt2x00: cancel all work on disconnect
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com
From: Pavel Roskin <proski@gnu.org>
Date: Sun, 02 Aug 2009 14:30:15 -0400
Message-ID: <20090802183015.16766.56837.stgit@ct.roinet.com>
In-Reply-To: <20090802183002.16766.4142.stgit@ct.roinet.com>
References: <20090802183002.16766.4142.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 658a63b..b4c696d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -893,6 +893,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
+	 * Stop all work.
+	 */
+	cancel_work_sync(&rt2x00dev->filter_work);
+	cancel_work_sync(&rt2x00dev->intf_work);
+
+	/*
 	 * Uninitialize device.
 	 */
 	rt2x00lib_uninitialize(rt2x00dev);
