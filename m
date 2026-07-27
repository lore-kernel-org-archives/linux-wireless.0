Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574D641DE03
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=pXwChCBRZ2F0UKKTJ73nmwdtJ24Lv4oKJRJKWBxS+/vfzneUdFsW61nmkzC+5ph49UjYJe8IyVFXF1XBTl/HrvHAhEPSQIvNTUOgFuP3hGOw9FIaFp3XrLb2HvhdgS8BS29WJg9f3D9bfG/fTvABXdFwInpbisQTRFeUPKVKauE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=JkL4WmZAJJ2V/y/IwexcnEI+hXQHI3Y9CrLwqvcXlBk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGIZjVxj3hzgUWDgfuydJMX1QZ179CRoro0JG6HAnCZmSKymFA+Zwfyb4TyNUKqU5tPhbmJL/pdPH2B4oJYrLyliQ7kgkfrz8LgX/WT2oQtIkeZCi6OHJaDto15RsYI90fhWIrJpDl8pK13DeRxR74dQYOJvDI6kk099iMmcNPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ukYWeB/W; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ukYWeB/W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mGO5rxOPPP+9tfilXB/0tD7+s/EdlMCQppMO72vUVMw=; b=ukYWeB/WZ7WqKabOe8tMHKheq7
	0Qr5VO+iQCRVEuYTtY2jlsZPmAiu2yzR5VCxgVCxlp+mFJJH8ltyEL28sJw1dWBsi8IUHuKGQIwIm
	mzNDGcjTjbKdGVZFYIBFTe3qhgNhRS2yRDYnLWrxuPaaskAXGawwMH9NcAyE/0CjdPwk=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-1B
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 12/15] wifi: mt76: mt7996: reject iTWT setup requests from MLD stations
Date: Mon, 27 Jul 2026 15:04:31 +0000
Message-ID: <20260727150434.1778520-12-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Howard Hsu <howard-yh.hsu@mediatek.com>

The firmware does not support individual TWT agreements with non-AP MLDs,
and the driver only tracks TWT flow state on the default link, which may
not be the link the agreement was negotiated on. Reject TWT setup
requests from MLD stations instead of programming an unsupported
configuration.

Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 4794dacb3756..1cba381a78b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -3218,6 +3218,12 @@ void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
 	struct mt7996_twt_flow *flow;
 	u8 flowid, table_id, exp;
 
+	/* the firmware does not support iTWT agreements with MLD peers, and
+	 * driver TWT state is only tracked on the default link
+	 */
+	if (sta->mlo)
+		goto out;
+
 	if (mt7996_mac_check_twt_req(twt))
 		goto out;
 
-- 
2.53.0

