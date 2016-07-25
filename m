Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46529 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753113AbcGYPwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 11:52:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6PFoFQl031659
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:20 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 24c5xkfr1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 8/8] mwifiex: fix radar detection issue
Date: Mon, 25 Jul 2016 21:21:11 +0530
Message-ID: <1469461871-3135-9-git-send-email-akarwar@marvell.com> (sfid-20160725_175227_161596_BEFE42B3)
In-Reply-To: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
References: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

It's been observed that firmware sends RADAR detected event without
specifying bss_num/bss_type. Also, the event body is empty.
Currently the event is being ignored by driver.

This patch checks on which interface 11H is active, accordingly fills
bss_num/bss_type and handles the event. Condition
"if (le32_to_cpu(rdr_event->passed))" which always fails is also removed.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11h.c    | 27 +++++++++++----------------
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 18 ++++++++++++++++--
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index 81c60d0..43dccd5 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -260,22 +260,17 @@ int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 
 	rdr_event = (void *)(skb->data + sizeof(u32));
 
-	if (le32_to_cpu(rdr_event->passed)) {
-		mwifiex_dbg(priv->adapter, MSG,
-			    "radar detected; indicating kernel\n");
-		if (mwifiex_stop_radar_detection(priv, &priv->dfs_chandef))
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "Failed to stop CAC in FW\n");
-		cfg80211_radar_event(priv->adapter->wiphy, &priv->dfs_chandef,
-				     GFP_KERNEL);
-		mwifiex_dbg(priv->adapter, MSG, "regdomain: %d\n",
-			    rdr_event->reg_domain);
-		mwifiex_dbg(priv->adapter, MSG, "radar detection type: %d\n",
-			    rdr_event->det_type);
-	} else {
-		mwifiex_dbg(priv->adapter, MSG,
-			    "false radar detection event!\n");
-	}
+	mwifiex_dbg(priv->adapter, MSG,
+		    "radar detected; indicating kernel\n");
+	if (mwifiex_stop_radar_detection(priv, &priv->dfs_chandef))
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to stop CAC in FW\n");
+	cfg80211_radar_event(priv->adapter->wiphy, &priv->dfs_chandef,
+			     GFP_KERNEL);
+	mwifiex_dbg(priv->adapter, MSG, "regdomain: %d\n",
+		    rdr_event->reg_domain);
+	mwifiex_dbg(priv->adapter, MSG, "radar detection type: %d\n",
+		    rdr_event->det_type);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index c29f26d..d433aa0 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -480,13 +480,27 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
  */
 int mwifiex_process_event(struct mwifiex_adapter *adapter)
 {
-	int ret;
+	int ret, i;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct sk_buff *skb = adapter->event_skb;
-	u32 eventcause = adapter->event_cause;
+	u32 eventcause;
 	struct mwifiex_rxinfo *rx_info;
 
+	if ((adapter->event_cause & EVENT_ID_MASK) == EVENT_RADAR_DETECTED) {
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (priv && mwifiex_is_11h_active(priv)) {
+				adapter->event_cause |=
+					((priv->bss_num & 0xff) << 16) |
+					((priv->bss_type & 0xff) << 24);
+				break;
+			}
+		}
+	}
+
+	eventcause = adapter->event_cause;
+
 	/* Save the last event to debug log */
 	adapter->dbg.last_event_index =
 			(adapter->dbg.last_event_index + 1) % DBG_CMD_NUM;
-- 
1.9.1

