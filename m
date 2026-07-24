Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D61381E96
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897301; cv=none; b=dU5k139cxDhV0nRoX6YSw+bboZvtpGbegxBAHPNcpjQncUt+PrxXC5exiS6z9b+wwRj4sN1uOEJzc/sI/6vo9xf0pGZdJ8iqr0NCbrQe1CSnJV0f/I32cJ+u1jN8tmlXTTj6R3ALl+JWHePLhoZlQdw2W34EMlK9yeNbN7l88zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897301; c=relaxed/simple;
	bh=A59sqtvpw0NZRB2u3RtO0mIlSyMBq5rPYAb5TVHSglA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWAdL8Nh97mxYxBdaqy7Cres31cyvJOs+ri6auf8qeq4kxerHLHgKjouAD2OCFDGF6JzvwJIqu3yr+ScgEQrmdFGfZT2/pOhnhWTWb66MGV1immSkjJtkyHWGE6bOJsESgUZuIxA8qJeAhpJb65AbVqSp7clhDkxcoqFsD56Ftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=WtMSGGfY; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WtMSGGfY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Eu4XntqvCzlKN+6KUwBItlEVSEPxqbbk89SFG6Be5lE=; b=WtMSGGfY5FnyMM7Ph2rvcth9Nu
	9+DlW4r1UMOdE5nHqzPp7EJ3v+7I2pn/TtGN7Ot4RVCBOpo3+c0UFeIGj1yhBMIZzJQ4xc3brQRaR
	hSk/uVBdGxlcEXADBc6VYHug5NHJWVNUpxqRfa3P/zOiALHA0LMu7ZzYvTs1JDwpapRA=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK5-006LeO-2e
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 13/29] wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar
Date: Fri, 24 Jul 2026 12:47:57 +0000
Message-ID: <20260724124813.3961474-13-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

Add the missing rdd idx check (< 0) in
mt7996_mcu_rdd_background_enable(). mt7996_get_rdd_idx() returns -1
for phys without 5 GHz support, and the negative index was passed to
the RDD MCU command unchecked.

Fixes: 1529e335f93d ("wifi: mt76: mt7996: rework radar HWRDD idx")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 1b334cbf6d72..09fcddb8e21d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4016,6 +4016,9 @@ int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
 	struct mt7996_dev *dev = phy->dev;
 	int err, region, rdd_idx = mt7996_get_rdd_idx(phy, true);
 
+	if (rdd_idx < 0)
+		return -EINVAL;
+
 	if (!chandef) { /* disable offchain */
 		err = mt7996_mcu_rdd_cmd(dev, RDD_STOP, rdd_idx, 0);
 		if (err)
-- 
2.53.0

