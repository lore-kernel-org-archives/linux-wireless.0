Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762715AbXLMG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:33 -0500
Subject: [PATCH 73/48] libertas: make some more functions static
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2v-0005st-KP@shinybook.infradead.org> (sfid-20071213_065958_441033_4523B9B9)
Date: Thu, 13 Dec 2007 01:59:49 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 17:44:10 -0500

sparse was getting on my tits.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c    |   12 ++++++------
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 drivers/net/wireless/libertas/main.c   |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 0f07c2a..2228fec 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -14,8 +14,8 @@
 #include "cmd.h"
 
 static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
-struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
-void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
+static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
+static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    struct cmd_ctrl_node *ptempnode,
 		    u16 wait_option, void *pdata_buf);
 
@@ -1716,7 +1716,7 @@ done:
  *  @param priv		A pointer to struct lbs_private structure
  *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
  */
-struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
+static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
 	unsigned long flags;
@@ -1780,9 +1780,9 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
  *  @param pdata_buf	A pointer to informaion buffer
  *  @return 		0 or -1
  */
-void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
-		    struct cmd_ctrl_node *ptempnode,
-		    u16 wait_option, void *pdata_buf)
+static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
+				  struct cmd_ctrl_node *ptempnode,
+				  u16 wait_option, void *pdata_buf)
 {
 	lbs_deb_enter(LBS_DEB_HOST);
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index a0866ef..7c57ff4 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -113,7 +113,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
-void if_usb_fw_timeo(unsigned long priv)
+static void if_usb_fw_timeo(unsigned long priv)
 {
 	struct usb_card_rec *cardp = (void *)priv;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2fe7ad0..c51d3af 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -252,8 +252,8 @@ static ssize_t lbs_anycast_set(struct device *dev,
 	return strlen(buf);
 }
 
-int lbs_add_rtap(struct lbs_private *priv);
-void lbs_remove_rtap(struct lbs_private *priv);
+static int lbs_add_rtap(struct lbs_private *priv);
+static void lbs_remove_rtap(struct lbs_private *priv);
 
 /**
  * Get function for sysfs attribute rtap
@@ -1423,7 +1423,7 @@ static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 }
 
 
-void lbs_remove_rtap(struct lbs_private *priv)
+static void lbs_remove_rtap(struct lbs_private *priv)
 {
 	if (priv->rtap_net_dev == NULL)
 		return;
@@ -1432,7 +1432,7 @@ void lbs_remove_rtap(struct lbs_private *priv)
 	priv->rtap_net_dev = NULL;
 }
 
-int lbs_add_rtap(struct lbs_private *priv)
+static int lbs_add_rtap(struct lbs_private *priv)
 {
 	int rc = 0;
 	struct net_device *rtap_dev;
-- 
1.5.3.4

