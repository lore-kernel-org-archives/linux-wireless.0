Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E070B38DC58
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 07:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086690; cv=none; b=ijSC330E4jZfCsc1uz5T+yVkzvay5k6HUQjYM3+cSzR7ZWneDbbvhI/CZhthkVJyCF2h4gcasMMbkXigEf2vFaIaaGecTFGk6izX96gAPMhHgeBHdsMFgfQx89Oy5KjBNA2JkSliZZLs3xyAQK7/K86HUSF1mFR+CI++WKbNazU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086690; c=relaxed/simple;
	bh=hE1FXbtA+p7/hmI2bQMYA39dEFWrpKC4J0fov1G7UF8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NGyFIo5J9HISv6PaQ46jZvT4lu8n5eDn6mgMToXOhGh04FuuOw30VgMEwEMSVsSmyQN55k1mx0h3YlDWIv2GFs6n7d2vviXCC/AivudkpEF5/79DdbZIfbIqCMy1MSyr9f/VOszvHGTUNvfbH6l4+DrUx797EToFVhhRUkZ2mMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DN5h7XHn; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DN5h7XHn"
X-UUID: 2ea3e1d8922f11f1b1788b6acf885367-20260807
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=aT5X5kEM+b1LPxhJkxfBtItNwRN3iR5kcevHOohFkWM=;
	b=DN5h7XHnfBT7k4pEWXLANngb2vcNLhmyYO0tLPzDDG4jrF9xzI8WguXaKDUYtisONZLPjImGVnaz8JrNi1uvrAW9nCfSKvuv0QuqaaayA4mRvk8VsuzgYdQ1N0u4gFAPwDJNEra3UAfpFp8KWXF8KGdLvsymhouv/fjcv6Vw/ic=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ca502086-3cf9-4522-9bee-4994413dc84c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:951cfe13-936d-4b8b-857d-7e30feac00f8,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2ea3e1d8922f11f1b1788b6acf885367-20260807
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1471496089; Fri, 07 Aug 2026 15:11:16 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 7 Aug 2026 15:11:15 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 7 Aug 2026 15:11:15 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7928: add debugfs to pin the 6GHz power mode
Date: Fri, 7 Aug 2026 15:11:14 +0800
Message-ID: <20260807071114.3056469-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

The 6GHz power mode follows the power type advertised by the AP, which
makes it hard to validate one specific power table on the FW side. Add a
debugfs knob that pins the power mode and pushes the CLC power table of
the selected mode down to the FW.

Key changes:
- Add power_type_user to struct mt792x_phy to flag a pinned power mode
- Add 6g_power_mode debugfs for selecting the 6GHz power mode:
  * 0: UNSET
  * 1: DEFAULT
  * 2: LPI
  * 3: SP
  * 4: VLP
  * 0xff: release the override
- Skip mt7925_regd_set_6ghz_power_type() while pinned, so that 6GHz
  (dis)association no longer overrides the selected power mode
- Return -EOPNOTSUPP when CLC is not supported and -EINVAL for values
  other than the ones listed above

Selecting a mode re-applies the regulatory domain with power_type_change
set, hence only the power table of that mode is sent to the FW. Releasing
the override does not send anything to the FW, it only restores the power
mode to its initial state so that the next 6GHz association or regulatory
domain change programs the power tables again.

Usage:
  echo 3 > /sys/kernel/debug/ieee80211/phy0/mt76/6g_power_mode
  cat /sys/kernel/debug/ieee80211/phy0/mt76/txpower_sku
  echo 0xff > /sys/kernel/debug/ieee80211/phy0/mt76/6g_power_mode

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 66 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  4 ++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  8 ++-
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  2 +
 4 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index 01a3655e8b82..3b34c20f7325 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -3,6 +3,7 @@
 
 #include "mt7925.h"
 #include "mcu.h"
+#include "regd.h"
 
 static int
 mt7925_reg_set(void *data, u64 val)
@@ -319,6 +320,69 @@ mt7928_txpwr_tbl_get(void *data, u64 *val)
 DEFINE_DEBUGFS_ATTRIBUTE(fops_txpwr_tbl, mt7928_txpwr_tbl_get,
 			 mt7928_txpwr_tbl_set, "%lld\n");
 
+/* Pin the 6GHz power mode instead of following the AP advertised one and push
+ * only the CLC power table of that mode down to the FW:
+ *   0: UNSET, 1: DEFAULT, 2: LPI, 3: SP, 4: VLP
+ *   0xff: release the override and go back to the AP advertised power mode
+ *
+ * UNSET/DEFAULT keep the FW on the LPI table, which is what the driver uses
+ * when no 6GHz power type has been reported by the AP.
+ *
+ * While pinned, 6GHz (dis)association no longer touches the power mode and a
+ * regulatory domain change only refreshes the pinned 6G power table, so the
+ * 2/5G tables of the new country are not sent until the override is released.
+ *
+ * Releasing does not send anything to the FW, it only restores the power mode
+ * to its initial state so that the next 6GHz association or regulatory domain
+ * change programs the power tables again.
+ */
+static int
+mt7925_6g_power_mode_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	struct mt792x_phy *phy = &dev->phy;
+	int ret;
+
+	if (!mt7925_regd_clc_supported(dev))
+		return -EOPNOTSUPP;
+
+	if (val == 0xff) {
+		mt792x_mutex_acquire(dev);
+		phy->power_type_user = false;
+		phy->power_type = MT_AP_UNSET;
+		mt792x_mutex_release(dev);
+
+		return 0;
+	}
+
+	if (val > MT_AP_VLP)
+		return -EINVAL;
+
+	wiphy_lock(mt76_hw(dev)->wiphy);
+	mt792x_mutex_acquire(dev);
+	phy->power_type_user = true;
+	phy->power_type = (enum mt792x_reg_power_type)val;
+	ret = mt7925_mcu_apply_regd(dev, dev->mt76.alpha2,
+				    dev->country_ie_env, true);
+	mt792x_mutex_release(dev);
+	wiphy_unlock(mt76_hw(dev)->wiphy);
+
+	return ret;
+}
+
+static int
+mt7925_6g_power_mode_get(void *data, u64 *val)
+{
+	struct mt792x_phy *phy = &((struct mt792x_dev *)data)->phy;
+
+	*val = phy->power_type_user ? phy->power_type : 0xff;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_6g_power_mode, mt7925_6g_power_mode_get,
+			 mt7925_6g_power_mode_set, "%lld\n");
+
 static int
 mt7925_pm_set(void *data, u64 val)
 {
@@ -556,6 +620,8 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
 	debugfs_create_file("fixedrate", 0600, dir, dev, &fops_fixedrate);
 	debugfs_create_file("autorate", 0600, dir, dev, &fops_autorate);
+	debugfs_create_file("6g_power_mode", 0600, dir, dev,
+			    &fops_6g_power_mode);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index cbfbf39322de..0dba2de8e5a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -941,6 +941,10 @@ mt7925_regd_set_6ghz_power_type(struct ieee80211_vif *vif,
 	enum mt792x_reg_power_type old_power_type;
 	bool power_type_changed = false;
 
+	/* the 6GHz power mode is pinned through debugfs */
+	if (phy->power_type_user)
+		return;
+
 	old_power_type = phy->power_type;
 
 	/* Try to get channel from link_conf first, then vif->bss_conf, then phy */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 6e892860325b..39ca49506150 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3672,14 +3672,14 @@ __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		u8 pad1;
 		u8 alpha2[2];
 		u8 type[2];
-		u8 env_6g;
+		u8 power_type_user; /* 0: AP advertised, 1: forced by debugfs */
 		u8 rsvd[63];
 	} __packed req = {
 		.tag = cpu_to_le16(0x3),
 
 		.idx = idx,
 		.env = env_cap,
-		.env_6g = dev->phy.power_type,
+		.power_type_user = dev->phy.power_type_user,
 	};
 	int ret, valid_cnt = 0;
 	u8 *pos, *last_pos;
@@ -3720,8 +3720,10 @@ __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		 *   - Send 2/5G ('-') and 6G LPI ('0') and 6G VLP ('2')
 		 * power_type_change == true: from mt7925_regd_set_6ghz_power_type()
 		 *   - Send only the specific 6G power table based on power_type
+		 * A 6GHz power mode pinned through debugfs behaves like the
+		 * latter: only the 6G power table of that mode is sent.
 		 */
-		if (power_type_change) {
+		if (power_type_change || dev->phy.power_type_user) {
 			/* Only send the specific 6G power table */
 			if (rule->type[0] != target_6g_type)
 				continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 65e1b9874ead..c226e5a13164 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -222,6 +222,8 @@ struct mt792x_phy {
 	u8 sta_work_count;
 	u8 clc_chan_conf;
 	enum mt792x_reg_power_type power_type;
+	/* 6GHz power mode pinned through debugfs, ignore the AP advertised one */
+	bool power_type_user;
 
 	struct sk_buff_head scan_event_list;
 	struct delayed_work scan_work;
-- 
2.18.0

