Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C5331EB0
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788572170; cv=none; b=U7etLUconHLJ3ch6E16GHA7msM6ncRc7I/CWRzced7QGVO/7+vQKuO5ihCZpjZE1CHEk+jvBdEgiRu43KgomNC2icuVH/iebVrOuUHbDaYAI4IF4lXBgywKwX3oOLAIvIe5y7LfKF2SvFYfeHkjzT9Jy2Jmt26WFUupZmEKUgSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788572170; c=relaxed/simple;
	bh=lWVVfRMq0mtfxRPzste9WAisrmsNe8WSe9DWp+Wmrpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb3srDX969I+k1DD1Enzs7aNWN2rBS8LGEtmBIB0pkmzEerafelbWWPfmfQCN7dPg3AKf/+Y15za5d8n7ncircuEGgLbFh6gATLQIatXWeYZ5UMJ5FFwKxdPDAYUlLDwbiEcx5aqfTyRARmamaqeFP0eDaqRGZPaOCrPL8Z6wlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=fjFwoVhb; arc=none smtp.client-ip=95.215.58.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="fjFwoVhb"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lWVVfRMq0mtfxRPzste9WAisrmsNe8WSe9DWp+Wmrpc=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788572165; v=1; x=1789176965;
 b=fjFwoVhbIjcf5iO1mds199kq5QqxCBWkFgK9v/mfSUuKTjmqoAgDWNaVK/qARI6ItaOA9qKm
 HGF0pfOfvIDTIHagQYpNxlZY6nGqc9wOxwGsVB9ixcph88QicsysUeGTPqgFqBQ5j/oTpgr3svb
 mCvxN/fCFZdfUP4Yulw2mnbedsaQYpl5WpmcjW9xsb5+lLAyiO/fpu0JjSWzTAiAe/mI24R/y+7
 SrVbVrRKxBfm+RYHusbnZbyLCDvk2HHdd1N+U662W+/529R+sdyewsOm/8zAskok+YCaf00A1iu
 tIEWbCef2QhiiUaQNPu92nTsLvRHSyspjHbK5TyPSR1AQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 394ef676eb4014bf;
	Sat, 05 Sep 2026 01:35:55 +0000
X-Mizu-Trace-ID: 394ef676eb4014bf
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Sagun Kayastha <sgn.kayastha@gmail.com>
Subject: [PATCH wireless v2] wifi: mt76: mt792x: pick the SAR table layout from the table itself
Date: Fri,  4 Sep 2026 18:35:51 -0700
Message-ID: <20260905013551.24635-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811232839.515463-1-lucid_duck@justthetip.ca>
References: <20260811232839.515463-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SAR power tables are parsed with a version byte from a different
ACPI table, never their own.

Some firmware declares version 1 and ships version 2 tables. The
entries then start a byte early, and the 6 GHz limits the table
carries are dropped, because the older layout has no room for them.

  ASUS GA503RM, MTCL declares v1:
  MTGS  28 bytes   v1: (28-6) % 5 = 2, no fit   v2: 3 tables
  MTDS  19 bytes   v1: (19-6) % 6 = 1, no fit   v2: 1 table

The layouts accept disjoint lengths, so take whichever one fits and
keep it per table.

Reported-by: Sagun Kayastha <sgn.kayastha@gmail.com>
Closes: https://github.com/morrownr/mt76/issues/62
Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
The first version rejected these tables. Going back through the
bytes, they are version 2 tables that MTCL mislabels, so this reads
them instead. Rejecting left the machine with no SAR limit at all.

The layouts accept disjoint lengths over the whole legal range:

  MTDS  v1   12  18  24  30  36  42  48  54
        v2   19  31  43  55  67  79  91 103
  MTGS  v1   21  26  31  36  41  46
        v2   28  35  42  49  56  63

The declared count is checked against the length too.

Fed the reporter's three tables to an MT7922 through an ACPI
override. Patched, both come out v2 and every range is filled:

  stock    frp: 60 60 60 60 60 127 127 127 127 127 127
  patched  frp: 60 60 60 60 60  60  60  60  60  60  60

That adapter is world-roaming, so both arms read the table's WW row.
The FCC row is not reachable here. That is where the misread turns
0x1D into 0x00, and where the reporter measured a flat clamp.

 .../wireless/mediatek/mt76/mt792x_acpi_sar.c  | 110 +++++++++++-------
 .../wireless/mediatek/mt76/mt792x_acpi_sar.h  |   2 +
 2 files changed, 73 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..9f71cf7e2dfd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -108,68 +108,98 @@ mt792x_asar_acpi_read_mtcl(struct mt792x_dev *dev, u8 **table, u8 *version)
 	return ret;
 }
 
+/* A table's layout is decided by the version byte in MTCL, but some firmware
+ * labels a version 2 table as version 1.  Accept whichever layout the table
+ * actually has: for every accepted entry count the two do not overlap, since
+ * one is 6 + 5n bytes and the other 7 + 7n.
+ */
+static bool
+mt792x_asar_fits(u8 *table, int len, int prelen, int sarlen, int nr_off,
+		 int min, int max)
+{
+	int tblcnt;
+
+	if (len < prelen || (len - prelen) % sarlen)
+		return false;
+
+	tblcnt = (len - prelen) / sarlen;
+	if (tblcnt < min || tblcnt > max)
+		return false;
+
+	return tblcnt == table[nr_off];
+}
+
 /* MTDS : Dynamic SAR Power Table */
 static int
-mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version)
+mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version,
+			   u8 *used)
 {
-	int len, ret, sarlen, prelen, tblcnt;
-	bool enable;
+	int len, ret;
+	u8 *t;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTDS, table, &len);
 	if (ret)
 		return ret;
 
+	t = *table;
+
 	/* Table content validation */
-	switch (version) {
-	case 1:
-		enable = ((struct mt792x_asar_dyn *)*table)->enable;
-		sarlen = sizeof(struct mt792x_asar_dyn_limit);
-		prelen = sizeof(struct mt792x_asar_dyn);
-		break;
-	case 2:
-		enable = ((struct mt792x_asar_dyn_v2 *)*table)->enable;
-		sarlen = sizeof(struct mt792x_asar_dyn_limit_v2);
-		prelen = sizeof(struct mt792x_asar_dyn_v2);
-		break;
-	default:
+	if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_dyn),
+			     sizeof(struct mt792x_asar_dyn_limit),
+			     offsetof(struct mt792x_asar_dyn, nr_tbl),
+			     MT792x_ASAR_MIN_DYN, MT792x_ASAR_MAX_DYN))
+		*used = 1;
+	else if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_dyn_v2),
+				  sizeof(struct mt792x_asar_dyn_limit_v2),
+				  offsetof(struct mt792x_asar_dyn_v2, nr_tbl),
+				  MT792x_ASAR_MIN_DYN, MT792x_ASAR_MAX_DYN))
+		*used = 2;
+	else
 		return -EINVAL;
-	}
 
-	tblcnt = (len - prelen) / sarlen;
-	if (!enable ||
-	    tblcnt > MT792x_ASAR_MAX_DYN || tblcnt < MT792x_ASAR_MIN_DYN)
+	if (!t[offsetof(struct mt792x_asar_dyn, enable)])
 		return -EINVAL;
 
+	if (version && *used != version)
+		dev_info(dev->mt76.dev,
+			 "MTDS is v%u, MTCL says v%u; using v%u\n",
+			 *used, version, *used);
+
 	return 0;
 }
 
 /* MTGS : Geo SAR Power Table */
 static int
-mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version)
+mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version,
+			   u8 *used)
 {
-	int len, ret, sarlen, prelen, tblcnt;
+	int len, ret;
+	u8 *t;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTGS, table, &len);
 	if (ret)
 		return ret;
 
+	t = *table;
+
 	/* Table content validation */
-	switch (version) {
-	case 1:
-		sarlen = sizeof(struct mt792x_asar_geo_limit);
-		prelen = sizeof(struct mt792x_asar_geo);
-		break;
-	case 2:
-		sarlen = sizeof(struct mt792x_asar_geo_limit_v2);
-		prelen = sizeof(struct mt792x_asar_geo_v2);
-		break;
-	default:
+	if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_geo),
+			     sizeof(struct mt792x_asar_geo_limit),
+			     offsetof(struct mt792x_asar_geo, nr_tbl),
+			     MT792x_ASAR_MIN_GEO, MT792x_ASAR_MAX_GEO))
+		*used = 1;
+	else if (mt792x_asar_fits(t, len, sizeof(struct mt792x_asar_geo_v2),
+				  sizeof(struct mt792x_asar_geo_limit_v2),
+				  offsetof(struct mt792x_asar_geo_v2, nr_tbl),
+				  MT792x_ASAR_MIN_GEO, MT792x_ASAR_MAX_GEO))
+		*used = 2;
+	else
 		return -EINVAL;
-	}
 
-	tblcnt = (len - prelen) / sarlen;
-	if (tblcnt > MT792x_ASAR_MAX_GEO || tblcnt < MT792x_ASAR_MIN_GEO)
-		return -EINVAL;
+	if (version && *used != version)
+		dev_info(dev->mt76.dev,
+			 "MTGS is v%u, MTCL says v%u; using v%u\n",
+			 *used, version, *used);
 
 	return 0;
 }
@@ -205,14 +235,16 @@ int mt792x_init_acpi_sar(struct mt792x_dev *dev)
 		asar->countrylist = NULL;
 	}
 
-	ret = mt792x_asar_acpi_read_mtds(dev, (u8 **)&asar->dyn, asar->ver);
+	ret = mt792x_asar_acpi_read_mtds(dev, (u8 **)&asar->dyn, asar->ver,
+					 &asar->dyn_ver);
 	if (ret) {
 		devm_kfree(dev->mt76.dev, asar->dyn);
 		asar->dyn = NULL;
 	}
 
 	/* MTGS is optional */
-	ret = mt792x_asar_acpi_read_mtgs(dev, (u8 **)&asar->geo, asar->ver);
+	ret = mt792x_asar_acpi_read_mtgs(dev, (u8 **)&asar->geo, asar->ver,
+					 &asar->geo_ver);
 	if (ret) {
 		devm_kfree(dev->mt76.dev, asar->geo);
 		asar->geo = NULL;
@@ -254,7 +286,7 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
 		break;
 	}
 
-	if (asar->ver == 1) {
+	if (asar->geo_ver == 1) {
 		band_pwr = &asar->geo->tbl[idx].band[0];
 		max = ARRAY_SIZE(asar->geo->tbl[idx].band);
 	} else {
@@ -297,7 +329,7 @@ mt792x_asar_range_pwr(struct mt792x_phy *phy,
 	if (!capa)
 		return 127;
 
-	if (asar->ver == 1) {
+	if (asar->dyn_ver == 1) {
 		limit = &asar->dyn->tbl[0].frp[0];
 		max = ARRAY_SIZE(asar->dyn->tbl[0].frp);
 	} else {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
index 474033073831..1d42f24b05f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h
@@ -105,6 +105,8 @@ struct mt792x_asar_fg {
 
 struct mt792x_acpi_sar {
 	u8 ver;
+	u8 dyn_ver;
+	u8 geo_ver;
 	union {
 		struct mt792x_asar_dyn *dyn;
 		struct mt792x_asar_dyn_v2 *dyn_v2;
-- 
2.55.0

