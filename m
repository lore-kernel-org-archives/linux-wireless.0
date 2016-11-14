Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753177AbcKNMto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:49:44 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 2/3] mwifiex: Introduce mwifiex_probe_of() to parse common properties
Date: Mon, 14 Nov 2016 18:19:11 +0530
Message-ID: <1479127752-23745-2-git-send-email-akarwar@marvell.com> (sfid-20161114_134947_683532_5D134B2D)
In-Reply-To: <1479127752-23745-1-git-send-email-akarwar@marvell.com>
References: <1479127752-23745-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajat Jain <rajatja@google.com>

Introduce function mwifiex_probe_of() to parse common properties.
Interface drivers get to decide whether or not the device tree node
was a valid one (depending on the compatible property),
Lets fill "adapter->dt_node" in mwifiex_add_card().

The function mwifiex_probe_of() is currently only a place holder with
the next patch adding content to it.

Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Same as v1
v3: Redundant flag "of_node_valid" is removed (Brian)
---
 drivers/net/wireless/marvell/mwifiex/main.c    | 12 ++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index dcceab2..835d330 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1552,6 +1552,16 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 }
 EXPORT_SYMBOL_GPL(mwifiex_do_flr);
 
+static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
+{
+	struct device *dev = adapter->dev;
+
+	if (!dev->of_node)
+		return;
+
+	adapter->dt_node = dev->of_node;
+}
+
 /*
  * This function adds the card.
  *
@@ -1581,6 +1591,8 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 	}
 
 	adapter->dev = dev;
+	mwifiex_probe_of(adapter);
+
 	adapter->iface_type = iface_type;
 	adapter->card_sem = sem;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index b697b61..bcd6408 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2235,10 +2235,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 		 * The cal-data can be read from device tree and/or
 		 * a configuration file and downloaded to firmware.
 		 */
-		if ((priv->adapter->iface_type == MWIFIEX_SDIO ||
-		    priv->adapter->iface_type == MWIFIEX_PCIE) &&
-		    adapter->dev->of_node) {
-			adapter->dt_node = adapter->dev->of_node;
+		if (adapter->dt_node) {
 			if (of_property_read_u32(adapter->dt_node,
 						 "marvell,wakeup-pin",
 						 &data) == 0) {
-- 
1.9.1
