Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18250 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbYGFNMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 09:12:37 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] hostap: don't compile prism2_suspend() for hostap_pci without
	CONFIG_PM
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Sun, 06 Jul 2008 09:12:30 -0400
Message-ID: <20080706131228.3236.35057.stgit@dv.roinet.com> (sfid-20080706_151249_887917_6F4C9F10)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 6c158a5..09004a6 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3417,7 +3417,7 @@ static void prism2_free_local_data(struct net_device *dev)
 }
 
 
-#ifndef PRISM2_PLX
+#if (defined(PRISM2_PCI) && defined(CONFIG_PM)) || defined(PRISM2_PCCARD)
 static void prism2_suspend(struct net_device *dev)
 {
 	struct hostap_interface *iface;
@@ -3436,7 +3436,7 @@ static void prism2_suspend(struct net_device *dev)
 	/* Disable hardware and firmware */
 	prism2_hw_shutdown(dev, 0);
 }
-#endif /* PRISM2_PLX */
+#endif /* (PRISM2_PCI && CONFIG_PM) || PRISM2_PCCARD */
 
 
 /* These might at some point be compiled separately and used as separate
