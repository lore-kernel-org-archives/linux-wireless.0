Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=CGbV9WN8Ef8mKe3WOIEVX1SfvE9v/Lwtw89KNt0FNRk15iM/3xkg1hTtMyBEdfCe75G1
	 SG8SsLO/4mKDmJL/rmELgjXRnQhkY16ZusjxdJS52/ucCOlj5DPCHajApM9XxRvOTsq36
	 jTltweYtmBSApoHsmCuOA5sDWRwcVIQojgz12gX+ab/mS+SBmYnC4DELwJtatRIIQM4Bi
	 hZ8brmfTnzKq5xIJiODLc73vSmwDVMrouVIpST+fyGdXK5LTrwgCXZBkPng2G3sIgzCy9
	 3/hPX0vH3Q9tcNlROLVPK100uWCKBtDKkRPMSUewEASZhnMIo7VHJAzYWk2ayzabmPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1vO4JVoHMs5AHc8AlhlE7E4N4vY0ZRvMLWEduiKPzBM=;
	b=x6yXivC6ZZ4a14XkRc2MQIULm56nOQrehFVMeAQdh6CFRhKpRB/icVywrAS+bnA0iy/a
	 6p4l2BL3/m44Gl0Ri6II2y9VlL1wUZXuQOZj8V48nK4bBnBa21T4tHwj9Gh8UVLcxqNGN
	 Kpq9gvWwIzuYxZNfYhf+AI2a0+dbXwD1Xp4NlBVd7cE75802ksgH6retRwK3P+g6ok7zU
	 vX8jSZKc7cHlEjEKRa41x1rIkuAgRuE7EPCP8h4BfBKvGlyCIZdsQDkux1w3YgostNNIC
	 hS7GOsBbXsQuYnZH1Ijp2/RG7nGqMGF2Jgdewvwsinl0sVpzze34VR+h0osJBk5AHfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=dcAGHSoa;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A639606A329
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A639606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=dcAGHSoa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1vO4JVoHMs5AHc8AlhlE7E4N4vY0ZRvMLWEduiKPzBM=; b=dcAGHSoaAnqGHUnoCH40dJgjLl
	tLJoThlrYzGfO9iJXx2o1bMMBgA1BYd38RUahunuJ4w7gMa2FffsujdptRulKG8CphDuQzYWUPwfT
	GDtU35W5EY8pNjB2ElTjALgNagxZ1PvqQ6HxLdVTZ9DaU7TC5ykWXblvgAyd3KMOMOqE=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2Q-009vQq-2m
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 11/11] wifi: mt76: mt792x: use mt76_connac2_fw_check()
Date: Sat, 24 Oct 2026 09:19:27 +0200
Message-ID: <20261024071927.2279668-11-nbd@nbd.name>
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

mt792x_get_offload_capability() and mt7921_load_clc() open-code the
checks of the firmware region table that mt76_connac2_fw_check() now
provides. Use the helper instead.

mt7921_load_clc() now checks every region, not only the regions in front
of the CLC region.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 19 ++-------------
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 23 +++----------------
 2 files changed, 5 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 9b2fa1db7642..a0caa77339ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -442,7 +442,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
 	const struct firmware *fw;
-	size_t clc_len, fw_data_len, len, offset = 0;
+	size_t clc_len, len, offset = 0;
 	int ret, i;
 	u8 *clc_base = NULL, hw_encap = 0;
 
@@ -462,33 +462,18 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(mdev->dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
-	if (hdr->n_region > (fw->size - sizeof(*hdr)) / sizeof(*region)) {
-		dev_err(mdev->dev, "Invalid firmware region table\n");
-		ret = -EINVAL;
-		goto out;
-	}
-	fw_data_len = fw->size - sizeof(*hdr) -
-		      hdr->n_region * sizeof(*region);
-
 	for (i = 0; i < hdr->n_region; i++) {
 		region = (const void *)((const u8 *)hdr -
 					(hdr->n_region - i) * sizeof(*region));
 		len = le32_to_cpu(region->len);
 
-		/* check if we have valid buffer size */
-		if (len > fw_data_len - offset) {
-			dev_err(mdev->dev, "Invalid firmware region\n");
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if ((region->feature_set & FW_FEATURE_NON_DL) &&
 		    region->type == FW_TYPE_CLC) {
 			clc_base = (u8 *)(fw->data + offset);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 0eee9c7a2bfd..dbea3c2e626f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -866,38 +866,21 @@ mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 	const u8 *data, *end, *fw_end;
 	const struct firmware *fw;
 	u8 offload_caps = 0;
-	size_t offset = 0;
-	int ret, i;
+	size_t offset;
+	int ret;
 
 	ret = request_firmware(&fw, fw_wm, dev);
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr))
+	if (mt76_connac2_fw_check(fw, &offset))
 		goto invalid;
 
 	data = fw->data;
 	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
-	if (hdr->n_region > (fw->size - sizeof(*hdr)) /
-			    sizeof(struct mt76_connac2_fw_region))
-		goto invalid;
-
 	fw_end = (const u8 *)hdr -
 		 hdr->n_region * sizeof(struct mt76_connac2_fw_region);
 
-	for (i = 0; i < hdr->n_region; i++) {
-		const struct mt76_connac2_fw_region *region;
-		u32 region_len;
-
-		region = (const void *)((const u8 *)hdr -
-					(hdr->n_region - i) * sizeof(*region));
-		region_len = le32_to_cpu(region->len);
-		if (region_len > fw_end - fw->data - offset)
-			goto invalid;
-
-		offset += region_len;
-	}
-
 	if (fw_end - fw->data - offset < 16 + sizeof(*rel_info))
 		goto invalid;
 
-- 
2.47.3

