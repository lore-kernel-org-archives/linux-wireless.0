Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39119 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab2KVTW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:22:28 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH 1/3] mac80211: move Mesh Capability field definition to ieee80211.h
Date: Wed, 21 Nov 2012 18:40:30 -0800
Message-Id: <1353552032-15600-2-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121122_202236_052300_5A5B1D24)
In-Reply-To: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/linux/ieee80211.h |   14 ++++++++++++++
 net/mac80211/mesh.h       |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 85764a9..9a85397 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -666,6 +666,20 @@ struct ieee80211_meshconf_ie {
 } __attribute__ ((packed));
 
 /**
+ * enum mesh_config_capab_flags - Mesh Configuration IE capability field flags
+ *
+ * @MESHCONF_CAPAB_ACCEPT_PLINKS: STA is willing to establish
+ *	additional mesh peerings with other mesh STAs
+ * @MESHCONF_CAPAB_FORWARDING: the STA forwards MSDUs
+ * @MESHCONF_CAPAB_TBTT_ADJUSTING: TBTT adjustment procedure is ongoing
+ */
+enum mesh_config_capab_flags {
+	MESHCONF_CAPAB_ACCEPT_PLINKS =		0x01,
+	MESHCONF_CAPAB_FORWARDING =		0x08,
+	MESHCONF_CAPAB_TBTT_ADJUSTING =		0x20,
+};
+
+/**
  * struct ieee80211_rann_ie
  *
  * This structure refers to "Root Announcement information element"
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 9285f3f..7c9215f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -19,20 +19,6 @@
 /* Data structures */
 
 /**
- * enum mesh_config_capab_flags - mesh config IE capability flags
- *
- * @MESHCONF_CAPAB_ACCEPT_PLINKS: STA is willing to establish
- * additional mesh peerings with other mesh STAs
- * @MESHCONF_CAPAB_FORWARDING: the STA forwards MSDUs
- * @MESHCONF_CAPAB_TBTT_ADJUSTING: TBTT adjustment procedure is ongoing
- */
-enum mesh_config_capab_flags {
-	MESHCONF_CAPAB_ACCEPT_PLINKS = BIT(0),
-	MESHCONF_CAPAB_FORWARDING = BIT(3),
-	MESHCONF_CAPAB_TBTT_ADJUSTING = BIT(5),
-};
-
-/**
  * enum mesh_path_flags - mac80211 mesh path flags
  *
  *
-- 
1.7.9.5

