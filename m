Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CCD36212F
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784703854; cv=none; b=oNYDbM8CuPDB9GYlB8rEgOCJk2PkyLCXt/VTJCvRN3rQNUvwRK/pJWZz90k5P4U7rEnd7NxjP1/x0Et9Y1bLpitowL5lDIfPvJ+B0/AM/2tITuN71Hjtgb6pjASlHDYzoyKHCxNGUSKzzedRVTZI1jogMAUl8niDM9yh70GtyXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784703854; c=relaxed/simple;
	bh=83gSPMppkIBdi3KJ54tc7FfH3R8OAWjFNfADpRQix+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ld713TkTA/6jGQ1tnaECUFnmP+G+xnRbXG5SlA+vXc+HJm18GEPQUPmRp+6z2EQ0c5c9LPbA2LFsnd3oTUeg2ByeHEXUestkMIvRUm9scnqEDfIEiQ4nj53BqmzYGpx2dqFj5LgYuDIoodQEzMq4iTevIew9caDD10BoJtPS+Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j+6fGdUR; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j+6fGdUR"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so9830859a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 00:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784703852; x=1785308652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8bdrG0QFqxIH5pXZGRRRAY6FI2BH/CW3w4wZSetZqPY=;
        b=j+6fGdUR1EN4QVfODYrerrWAbqdRQv4lFE9+D97va8hANJgoJQPOaNdWs2fmll13U5
         Jjwbshxw6fcG8d9jxYbJkLrmmthJql19Adko6/985sHwIs0qxZwp+4EKvnk5BPyPxLWp
         RL3kjdvIWYVYQswbDAXT4/8yXqsHc8G3prfZWrcLhg58imQe4aZa2ZZ1IoHPJ99uvWhP
         y4nm0woGxB9wX0EB0S9LAkyj681bM3wGs0gBZ6+b5eV0IdUInmYZvbbNYyMeyGXba+3e
         /gykE+aLzBuVINhq8+OjN7MUgwuJd6I+szQg+D14SCmpbDVMDm1y6+0eQ9j4DHNmjLTV
         XOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784703852; x=1785308652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8bdrG0QFqxIH5pXZGRRRAY6FI2BH/CW3w4wZSetZqPY=;
        b=ROu2cQSuyIXkONB2KQ35ksWvxGopjIZROxnpNR3UaGdb9gT5VB27GVStBfyIoxNuQM
         hBkknZ0wxciciUZTcCCMFf3XL/ti1kdlpIzP4Ak6AsTc0fOqTVDdotU/0bnHk690OQlJ
         NDW+yWhJsykBYZE31/OaYG+lzKSBcNPFGHK2Uh53PFOplxfDApUoHFuYvH8E3wpZr5RX
         t67QGvoGgvK6q0Yq3BxqbieN0libFIzNanzDxJf8cPTX21PzY0HIoW7goKsLB1yJRYSn
         Vunu+HNZ43lJXFGwE7jmm1L6t+SUwdjtXub7Y1fVypGy45HGUol2ylWdNIsW5tC6dywK
         8GYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq19pfy5gBDMNATZoot2fU9BsxhAZmRgxytjjVYMTLR0mWfjwAP0+d5Me5ziDP8igvjVLxtF1n6Y2LgLyWtbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVsr5M8FujoEBKzyVwU9jfhWeESVzcfgbbfDjNkRy+QzWhLe0+
	THHJ/jTQEAgZdJGoy8d6NxYWKN53fyr33+iQzJr4N1jzD+7hS9onOpPLb0LIdE27vN4=
X-Gm-Gg: AR+sD12k0eYJHnm9nfez0AK8a1gAVAc1qTy6z1bXHXtq8lq9LV3Ndje3FN/QuguzFBS
	gKcsQ67VKSQUMoQ8EHBmALdJ3VykktYkF+8Mo6jbQ7Y9W0etLi93HGaJ66ajWaOUCQmKf1qgJXX
	phbihIWWFwIjZMxYMj0Dl/GciIS+M9r2STRRkIKQ19MImyasstooh1X6rZARwt1HIVHnyO4DHKz
	54arEnWmj2qOg1cFEod9AT+8O0egRSmJdyDjvXXIkXBcr+uboWdr/Uy4/mJVUh3yJ8w1dWbFTJQ
	yzoKklT5lMK2yXJuAPVGE/MS1dJx5JXPHJxXw3BG9bKiEr4UwAp9FAR82pD4MZNZk2TFEXDvV4i
	5IYG8leHHcGi/UwVqwMETtiDsIYdhX9m3wSYqXDnx5r6TSeXS3mydH9D80bcAJsnfz16lj/CMqS
	dYvp/uGGSkHkLnQa/jFNMq7EgnZgpzznXeQU58lCXWBECjL6DBoCvRykbEMtT3OI3jxSTWw+4XS
	A1AE7oLcsyeu0hv/0IHBVY=
X-Received: by 2002:a17:90b:2e90:b0:368:ed26:15b2 with SMTP id 98e67ed59e1d1-38e4b43c408mr21798100a91.8.1784703851941;
        Wed, 22 Jul 2026 00:04:11 -0700 (PDT)
Received: from localhost.localdomain ([101.251.7.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130a8421sm3203259c88.10.2026.07.22.00.04.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jul 2026 00:04:11 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Subject: [PATCH] wifi: mt76: mt7925: validate CLC firmware records
Date: Wed, 22 Jul 2026 12:49:02 +0545
Message-ID: <20260722070402.45328-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CLC region is supplied by firmware, but the loader trusts the region
count and each record length. A malformed image can make the region table
pointer precede the firmware buffer, make the record loop fail to advance,
or index phy->clc past its end. Validate the table and record bounds
before dereferencing or copying.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 32 ++++++++++++++-----
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e94fa544ff20..76e30bf4ce0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -803,8 +803,9 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
 	const struct firmware *fw;
+	size_t clc_len, fw_data_len, len, offset = 0;
 	u8 *clc_base = NULL, hw_encap = 0;
-	int ret, i, len, offset = 0;
+	int ret, i;
 
 	dev->phy.clc_chan_conf = 0xff;
 	dev->regd_user = false;
@@ -829,13 +830,21 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	}
 
 	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
+	if (hdr->n_region > (fw->size - sizeof(*hdr)) / sizeof(*region)) {
+		dev_err(mdev->dev, "Invalid firmware region table\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	fw_data_len = fw->size - sizeof(*hdr) -
+		      hdr->n_region * sizeof(*region);
+
 	for (i = 0; i < hdr->n_region; i++) {
 		region = (const void *)((const u8 *)hdr -
 					(hdr->n_region - i) * sizeof(*region));
 		len = le32_to_cpu(region->len);
 
 		/* check if we have valid buffer size */
-		if (offset + len > fw->size) {
+		if (len > fw_data_len - offset) {
 			dev_err(mdev->dev, "Invalid firmware region\n");
 			ret = -EINVAL;
 			goto out;
@@ -852,11 +861,19 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (!clc_base)
 		goto out;
 
-	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
-		clc = (const struct mt7925_clc *)(clc_base + offset);
+	for (offset = 0; offset < len; offset += clc_len) {
+		if (len - offset < sizeof(*clc)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (clc->idx >= ARRAY_SIZE(phy->clc))
-			break;
+		clc = (const struct mt7925_clc *)(clc_base + offset);
+		clc_len = le32_to_cpu(clc->len);
+		if (clc_len < sizeof(*clc) || clc_len > len - offset ||
+		    clc->idx >= ARRAY_SIZE(phy->clc)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
@@ -869,8 +886,7 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 			continue;
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
-						  le32_to_cpu(clc->len),
-						  GFP_KERNEL);
+						  clc_len, GFP_KERNEL);
 
 		if (!phy->clc[clc->idx]) {
 			ret = -ENOMEM;
-- 
2.51.2

