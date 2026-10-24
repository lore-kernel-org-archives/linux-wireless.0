Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=X67fyYpu7oGEJLa1PbILIQfKrGtF9fekgY70dgSPo+VnnwMHErecudWz3kYmxgKKOjKz
	 w9enoZAyqAWy6D8lmvewFcgf6qhVfa9B0MwSK4s3W1Fq3z6kfeE3s6F3qGda63flJnwHw
	 9LH0hawTSq82vNf61ab+wr603MmPXWQcsPIuf1rBzqN6BQwIXdHCdtRfI8JJbmWL//acU
	 key45iI9wvYt0vjbVoc5Xcd+d0Y6hjl7eGLDLNkhF1N54wRvE6GnZAFUWLUGnsnYkijWw
	 xqFtlWsxeSCIKTuXiVCA4uNdujH1fc/tj4f4S6kLrZDluL8jsFeZooxCuMspV1ZZYsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bUMPBenu3wt3+V5MmLmKQH4MfOwGrLmd2+FEdGrEZBU=;
	b=CFVvfx3VRo/7DnfTcv1jpQydFtC/vFMvN1+LNmZzcq8J0xgvwaQbOIJWMe4dWpxORgc6
	 PF4MGm22kPzZf8jEyjOeppyhWI5xHouXO2xHupzTHAq0oFcJIbfyAM5flNq+NcaJ7Z0z6
	 kpUIGAYJ08GTpvtcgrgNuQ6uRZNBFtBS8DWKsozIYVb4/VWXTK1jQqgo/3JV3Ggxd7f00
	 lIiQrfVPeXmYXYm97oidJSAz54ZD+A6yCOz3TL6SNFio7/gxBRZBiPRe5lLEHwu4irPHZ
	 Jvyu8D11mBETr50rEO7qDER4mNlhVzIJzwjE0CwtUYvP4taW3m6TCnMl9AuzV2QhElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=SurNZ8d5;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E6A606A322
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E6A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=SurNZ8d5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bUMPBenu3wt3+V5MmLmKQH4MfOwGrLmd2+FEdGrEZBU=; b=SurNZ8d5wV0DOCqqTOqhi+c4Qz
	Ml7VpaQukUXu0QIycgViM9ocUteZsZ0Xas1y5MKF88XKPjht8C4skA3eIoucuB1rr6BZ+kBVPP9kB
	WCIdiN7DsudyAi9nXd2XGJlSv0wlTvTOLjqctNPIEkr3ikXPg0UODOcbCp5QvRLeipDg=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2Q-009vQq-15
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 08/11] wifi: mt76: mt7925: validate CLC firmware regions and records
Date: Sat, 24 Oct 2026 09:19:24 +0200
Message-ID: <20261024071927.2279668-8-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024071927.2279668-1-nbd@nbd.name>
References: <20261024071927.2279668-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7925_load_clc() does not bound the region table against the image
size, and its region check "offset + len > fw->size" uses int arithmetic
and ignores the region table and trailer. The CLC record loop also uses
each record length without a check. A malformed image causes reads past
the image, and a record length of zero makes the loop never end.

Reject an image that fails mt76_connac2_fw_check(), and reject CLC
records that are shorter than the record header or extend past the CLC
region, like mt7921_load_clc() does.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 2acb02add18f..50f5f57b740e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -911,9 +911,10 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	const struct mt7925_clc *clc;
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
+	size_t clc_len, len, offset = 0;
 	const struct firmware *fw;
 	u8 *clc_base = NULL, hw_encap = 0;
-	int ret, i, len, offset = 0;
+	int ret, i;
 
 	dev->phy.clc_chan_conf = 0xff;
 	dev->regd_user = false;
@@ -931,7 +932,7 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(mdev->dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
@@ -943,13 +944,6 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 					(hdr->n_region - i) * sizeof(*region));
 		len = le32_to_cpu(region->len);
 
-		/* check if we have valid buffer size */
-		if (offset + len > fw->size) {
-			dev_err(mdev->dev, "Invalid firmware region\n");
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if ((region->feature_set & FW_FEATURE_NON_DL) &&
 		    region->type == FW_TYPE_CLC) {
 			clc_base = (u8 *)(fw->data + offset);
@@ -961,8 +955,20 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (!clc_base)
 		goto out;
 
-	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
+	for (offset = 0; offset < len; offset += clc_len) {
+		if (len - offset < sizeof(*clc)) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
 		clc = (const struct mt7925_clc *)(clc_base + offset);
+		clc_len = le32_to_cpu(clc->len);
+		if (clc_len < sizeof(*clc) || clc_len > len - offset) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (clc->idx >= ARRAY_SIZE(phy->clc))
 			break;
@@ -978,7 +984,7 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 			continue;
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
-						  le32_to_cpu(clc->len),
+						  clc_len,
 						  GFP_KERNEL);
 
 		if (!phy->clc[clc->idx]) {
-- 
2.47.3

