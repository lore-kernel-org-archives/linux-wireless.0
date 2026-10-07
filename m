Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAE3A6B67
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372281; cv=none; b=PXbfSNFgAucVK+lAkSZUXJsYBUDCpwKBsXu4BVB0yaGV23pqCDCEWBDglYDVroNc6nhrTHokd0ZduWwvruXDfFCk+Cuz1KQ1aIKwdIcinMi8X2efCfgZK1dpNY+Qt912I0wWR9Qw3orgsxsrbhXtKhlHwQRW/T+VQejYrWjh5NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372281; c=relaxed/simple;
	bh=fURwz8TWRCuLgwQKJEvKTpCu80fWixQeDTE+7cww7g8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAL/v0kG2Fm3MMhnHPsk8QYpn5/ogiohcNW0ROjaGE3ouKS1CaU1H6fU3Mj6GG425PTfDMirWFGHWyF5OjQC09j7ZGu6eAS9ql0L1mB5AGVC9uDnn0S9PIY1zxAzIwOaRFElDpomrJ5ZG/zObvFr7Ge1dE0gBBqQGDMpPXVXJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=HvNHSNUG; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="HvNHSNUG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f0Pb8S0beRPONcqS9nKwwiLlSBUbjqCLdqESJDiaDNI=; b=HvNHSNUGexh6nC/fV9cSow0W47
	vHavXSbMjPWy6PwaOWfZpHTHwzbMlUeN6uqZ0boiHnNpBrDAqFqtJ+pjoOIhFRJ4SRFnsywSZJigz
	yWSekzW8EGC2OGuqNscPqr58fHfEqY3e2PyMXnOWBP+Y7uzFne4faoPr+bpNDnXrbub4=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl1-00HY5A-0p
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 3/9] wifi: mt76: mt7921: fix of_node reference leaks in regd update
Date: Wed,  7 Oct 2026 13:24:13 +0200
Message-ID: <20261007112419.1277594-3-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7921_regd_channel_update() and __mt7921_mcu_set_clc() never
release the nodes returned by mt76_find_power_limits_node(),
of_get_child_by_name() and mt76_find_channel_node(). Each regulatory
domain change and each CLC update on a device with DT power limits
leaks these references.

Release every node after use. This relies on
mt76_find_power_limits_node() also returning a reference for the
fallback node, which it does since commit 3a62c9f7ec3d ("wifi: mt76:
Fix of_node reference leak in mt76_get_rate_power_limits()").

Fixes: 09382d8f8641 ("wifi: mt76: mt7921: update the channel usage when the regd domain changed")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  7 ++++-
 .../net/wireless/mediatek/mt76/mt7921/regd.c  | 28 ++++++++++++++++---
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index bdeb6614a5a9..25638c68c468 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/firmware.h>
+#include <linux/of.h>
 #include "mt7921.h"
 #include "regd.h"
 #include "mcu.h"
@@ -1363,6 +1364,7 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 		.mtcl_conf = mt792x_acpi_get_mtcl_conf(&dev->phy, alpha2),
 	};
+	struct device_node *np;
 	int ret, valid_cnt = 0;
 	u32 buf_len = 0;
 	u8 *pos;
@@ -1372,8 +1374,11 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_CLC_EVT_EN)
 		req.cap |= CLC_CAP_EVT_EN;
-	if (mt76_find_power_limits_node(&dev->mt76))
+
+	np = mt76_find_power_limits_node(&dev->mt76);
+	if (np)
 		req.cap |= CLC_CAP_DTS_EN;
+	of_node_put(np);
 
 	buf_len = le32_to_cpu(clc->len) - sizeof(*clc);
 	pos = clc->data;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
index fcdeb65cd8ef..699617d9e48f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
@@ -28,6 +28,21 @@ bool mt7921_regd_clc_supported(struct mt792x_dev *dev)
 	return true;
 }
 
+static bool
+mt7921_regd_dt_has_channel(struct device_node *band_np,
+			   struct ieee80211_channel *ch)
+{
+	struct device_node *chan_np;
+
+	if (!band_np)
+		return false;
+
+	chan_np = mt76_find_channel_node(band_np, ch);
+	of_node_put(chan_np);
+
+	return !!chan_np;
+}
+
 static void
 mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 {
@@ -43,14 +58,14 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 
 	sband = wiphy->bands[NL80211_BAND_5GHZ];
 	if (!sband)
-		return;
+		goto out;
 
 	band_np = np ? of_get_child_by_name(np, "txpower-5g") : NULL;
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
+		if (np && !mt7921_regd_dt_has_channel(band_np, ch)) {
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 			continue;
 		}
@@ -59,17 +74,18 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		if (IS_UNII_INVALID(0, 5845, 5925))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
+	of_node_put(band_np);
 
 	sband = wiphy->bands[NL80211_BAND_6GHZ];
 	if (!sband)
-		return;
+		goto out;
 
 	band_np = np ? of_get_child_by_name(np, "txpower-6g") : NULL;
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
+		if (np && !mt7921_regd_dt_has_channel(band_np, ch)) {
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 			continue;
 		}
@@ -81,6 +97,10 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		    IS_UNII_INVALID(4, 6875, 7125))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
+	of_node_put(band_np);
+
+out:
+	of_node_put(np);
 }
 
 int __mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
-- 
2.47.3

