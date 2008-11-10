Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15628 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbYKJO0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 09:26:13 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] orinoco: fix last beacon reporting on 64-bit systems
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 10 Nov 2008 09:25:53 -0500
Message-ID: <20081110142553.12216.42412.stgit@dv.roinet.com> (sfid-20081110_152618_374108_DC98CF2C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

orinoco_translate_scan() and orinoco_translate_ext_scan() wrongly
truncate last_scanned argument from unsigned long to unsigned int.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/orinoco/orinoco.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 12059f4..da5ba5e 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -5448,7 +5448,7 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 					   char *current_ev,
 					   char *end_buf,
 					   union hermes_scan_info *bss,
-					   unsigned int last_scanned)
+					   unsigned long last_scanned)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 	u16			capabilities;
@@ -5595,7 +5595,7 @@ static inline char *orinoco_translate_ext_scan(struct net_device *dev,
 					       char *current_ev,
 					       char *end_buf,
 					       struct agere_ext_scan_info *bss,
-					       unsigned int last_scanned)
+					       unsigned long last_scanned)
 {
 	u16			capabilities;
 	u16			channel;
