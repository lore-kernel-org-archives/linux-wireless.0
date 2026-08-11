Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFF430CE1
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 23:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786490934; cv=none; b=crmhWKXjUIawIhBo503UfrtGuQOeKTKG69jnfSDck3MfZH6YSrCbaQRCOFOF+Q5v6DML8jxFj8JAvzKeQQMs71+UD4xU3c8/TLegTMzaZO2u7STpKpGCbGHRH9HyQfl8Yr5+X5A/Tw19FloNi4XJoPLw6WK6Prd1SHXfy+ZZGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786490934; c=relaxed/simple;
	bh=/HBb3Y8kYA9jwhEFyK3Q3GkowZopT9VTQKrzRd+jeYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JR3ffhpLrgUheP2Tf+w28SsTscS5uvVQZBWElzjoHXPsd66e+SncOvjgjdX5S3IkXgGK4/Iy8VxgHAXCuVKwVX+ob0JkB5G3xGzN2G5AeKwIoxYqvLFENmHpMHw8cahAp8AU5EGAeQx3NmonjJY+NERQlYy1rfFcIQ/tTYwQraQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=W0MjgnFZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="W0MjgnFZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786490928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JM0R8IKUQr7cM/ajSLHBnZKnVzOicpi+oUAzf1nTyJc=;
	b=W0MjgnFZUXzZP3CEO3KFjhHA/Wp+RSY/Kcyu/yl7ebYzfLitpzU1Lwv6QA9C7+9ljIiVad
	pi5tcHomcLRSDFfzzFv5lQ1FrXhGOQ3p39eSwHxjDevHy+cPH7jbEn4SOGn7Lo67tAJUhS
	QWrKjLBThbNHwfEgcnzH3YBWDM0zH1QZe+wMbZfFdsJ3TPypkQwZFZfQ27bxzRQk1MdvYY
	1xcAAaz0I4Q51t/U8BbZFYAKuwPjnXknrmanLfkXlLqn3925wpf06OKtWeNotuLjIj834l
	yrafL6aLBoN2aNCsS8UaCmMH4+hOG1pvoQpEQPchiRSbDXt7E7Q+opzEjg9pKg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sagun Kayastha <sgn.kayastha@gmail.com>
Subject: [PATCH wireless] wifi: mt76: mt792x: validate ACPI SAR table length before parsing
Date: Tue, 11 Aug 2026 16:28:39 -0700
Message-ID: <20260811232839.515463-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Both SAR readers derive the entry count from the ACPI buffer length.
Nothing checks that the length is at least the header size, that it
divides evenly into whole entries, or that the count the table declares
in nr_tbl matches.  A malformed table whose length happens to land the
count inside the accepted range is parsed with the wrong layout and its
limits are applied to the radio.

mt792x_acpi_read() allocates exactly package.count bytes and only rejects
counts below 4, so a four byte table is possible.  The MTDS path already
reads ->enable at offset 4 before any length check, past the end of such
a buffer.

Take the length checks first, then read the header fields, then compare
the derived count against nr_tbl.

Seen on an ASUS ROG Zephyrus G15 GA503RM whose MTGS and MTDS are both
malformed.  The parser accepted them and applied a limit that clamped
every txpower_sku entry to tmac 4, about 2 dBm.  With them rejected,
txpower goes from 3.00 dBm to 23.00 dBm and txpower_sku spreads back
across OFDM/HT20/HT40/VHT80/VHT160.

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Link: https://github.com/morrownr/mt76/issues/62
Reported-by: Sagun Kayastha <sgn.kayastha@gmail.com>
Tested-by: Sagun Kayastha <sgn.kayastha@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 .../wireless/mediatek/mt76/mt792x_acpi_sar.c  | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd79..7e72c38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -114,6 +114,7 @@ mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version)
 {
 	int len, ret, sarlen, prelen, tblcnt;
 	bool enable;
+	u8 nr_tbl;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTDS, table, &len);
 	if (ret)
@@ -122,12 +123,10 @@ mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version)
 	/* Table content validation */
 	switch (version) {
 	case 1:
-		enable = ((struct mt792x_asar_dyn *)*table)->enable;
 		sarlen = sizeof(struct mt792x_asar_dyn_limit);
 		prelen = sizeof(struct mt792x_asar_dyn);
 		break;
 	case 2:
-		enable = ((struct mt792x_asar_dyn_v2 *)*table)->enable;
 		sarlen = sizeof(struct mt792x_asar_dyn_limit_v2);
 		prelen = sizeof(struct mt792x_asar_dyn_v2);
 		break;
@@ -135,8 +134,19 @@ mt792x_asar_acpi_read_mtds(struct mt792x_dev *dev, u8 **table, u8 version)
 		return -EINVAL;
 	}
 
+	if (len < prelen || (len - prelen) % sarlen)
+		return -EINVAL;
+
+	if (version == 1) {
+		enable = ((struct mt792x_asar_dyn *)*table)->enable;
+		nr_tbl = ((struct mt792x_asar_dyn *)*table)->nr_tbl;
+	} else {
+		enable = ((struct mt792x_asar_dyn_v2 *)*table)->enable;
+		nr_tbl = ((struct mt792x_asar_dyn_v2 *)*table)->nr_tbl;
+	}
+
 	tblcnt = (len - prelen) / sarlen;
-	if (!enable ||
+	if (!enable || tblcnt != nr_tbl ||
 	    tblcnt > MT792x_ASAR_MAX_DYN || tblcnt < MT792x_ASAR_MIN_DYN)
 		return -EINVAL;
 
@@ -148,6 +158,7 @@ static int
 mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version)
 {
 	int len, ret, sarlen, prelen, tblcnt;
+	u8 nr_tbl;
 
 	ret = mt792x_acpi_read(dev, MT792x_ACPI_MTGS, table, &len);
 	if (ret)
@@ -167,8 +178,17 @@ mt792x_asar_acpi_read_mtgs(struct mt792x_dev *dev, u8 **table, u8 version)
 		return -EINVAL;
 	}
 
+	if (len < prelen || (len - prelen) % sarlen)
+		return -EINVAL;
+
+	if (version == 1)
+		nr_tbl = ((struct mt792x_asar_geo *)*table)->nr_tbl;
+	else
+		nr_tbl = ((struct mt792x_asar_geo_v2 *)*table)->nr_tbl;
+
 	tblcnt = (len - prelen) / sarlen;
-	if (tblcnt > MT792x_ASAR_MAX_GEO || tblcnt < MT792x_ASAR_MIN_GEO)
+	if (tblcnt != nr_tbl ||
+	    tblcnt > MT792x_ASAR_MAX_GEO || tblcnt < MT792x_ASAR_MIN_GEO)
 		return -EINVAL;
 
 	return 0;
-- 
2.55.0

