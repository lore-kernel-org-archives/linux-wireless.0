Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA4046C4CD
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757076; cv=none; b=DMVnBwSMYyZBp7q1kum0Qbpw9PhHZDAnXhAABu+Yc2ZRRfZzuIkV8XfRgi28OSy7OnRHTQCtVEH32Xj2w9pmMZ1k0WdDcd7LNvHlQ3LyqOf97LSvdOAgWsctozKdqFZuXscmfx09Sr+3eEeeUAjypNVi0V6GxKXEzuXGKSBYNDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757076; c=relaxed/simple;
	bh=TAG+U5fuuSU2pGxEBN/ACuEXxbfeox/WbeHrEqnnaDQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dzwDQsjQQk6AlVKwcPxqHiwmSufIySKY9G23bpIL0gxFUwRRH3XA0gVHZLiojkM0pK6idbRifxyTDKpE4egqsUkYUC773KF1fXUYeCd9V9QWfQiEn4MyBSCJ0DcGzNjzdUeri7iHRgLFGeszPGbWWfwXFMjPTxg6oSWUN8NWXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oex4Ql7K; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oex4Ql7K"
X-UUID: 471df39ebca911f1b1788b6acf885367-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=rrFVenRda4f6shdQ7huUXas9ap2EQjTLxRuQkX7ZbYc=;
	b=oex4Ql7KpnVr/PEFX9RoUF37SA71fTi85RqHqyIhmzIHXATzfMLep7H0LTyn7+WwwMzA83jDOT7Lq2cVkDil+DLwsftuP+2xZRpMOYGAgYuhqtrqmTnlCZkZCx9OWFkvnlHaI97oy3aBE5cRfYyjKmOvSQY2LqfsFb/zE6vTge8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:4244168c-59b8-4a82-9890-914f23f64323,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:a081ab79-69b8-4eeb-9f08-b9b80d2b4ee3,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 471df39ebca911f1b1788b6acf885367-20260930
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 780482948; Wed, 30 Sep 2026 16:31:05 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 16:31:04 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 30 Sep 2026 16:31:04 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH v2] wifi: mt76: connac2: fill TXD spe_idx for connac2 fixed-rate frames
Date: Wed, 30 Sep 2026 16:31:02 +0800
Message-ID: <20260930083103.1284937-1-jb.tsai@mediatek.com>
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

On connac2 chipsets - MT7920, MT7921 and MT7922 - the spe_idx of
fixed-rate frames was never programmed, so every management frame -
auth and assoc req included - went out 1SS 1T on WF0 instead of 1SS 2T
duplicate, giving up ~3dB of array gain during connection setup, which
is exactly when the link budget is worst.

mt76_connac2_mac_write_txwi() takes the MT_TXD2_FIX_RATE path for any
non-data frame, but the block filling MT_TXD7_SPE_IDX was guarded by
!is_connac2(), leaving the field at 0. As spe_idx 0 also encodes "WF0"
the hardware happily transmitted on a single path. Drop the guard so
connac2 fills the index like the other generations do.

Do not set MT_TXD6_SPE_ID_IDX along with it: on connac2 that bit points
the hardware at the WTBL instead of the TXD, and the WTBL spe_idx is
still 0 while connecting, so setting it puts the frames back on WF0.
This matches connac3, where SPE_IXD_SELECT_TXD is 0 and
SPE_IXD_SELECT_BMC_WTBL is 1, and is the opposite of what the falcon
firmware macro name HAL_MAC_TX_DESC_SET_FR_SPE_IDX_SPE_BY_TXD suggests.

Guard the duplicate fallback with hweight8() as well: ant_to_spe[] maps
a single-antenna mask to 0 too, so without the check a user asking for
one antenna would still get spe_idx 24 and duplicate onto both paths.

Verified on MT7922: TXD DW7 spe_idx now reads 0x18 and the in-chip
sniffer reports spe_idx 0x18 in the TXV of auth and assoc req, where it
previously reported 0x0. MT7920 and MT7921 share the same connac2 TXD
path and are fixed by the same change.

Fixes: 00dd59264dcb ("wifi: mt76: connac: use is_connac2() to replace is_mt7921() checks")

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

---
v2: remove Bora-id commit message

---
 .../wireless/mediatek/mt76/mt76_connac_mac.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index de38ba9a4a26..9b40bac2b036 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -600,6 +600,7 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 							vif ? &vif->bss_conf : NULL,
 							beacon, multicast);
 		u32 val = MT_TXD6_FIXED_BW;
+		u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
 
 		/* hardware won't add HTC for mgmt/ctrl frame */
 		txwi[2] |= cpu_to_le32(MT_TXD2_HTC_VLD);
@@ -608,13 +609,18 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		txwi[6] |= cpu_to_le32(val);
 		txwi[3] |= cpu_to_le32(MT_TXD3_BA_DISABLE);
 
-		if (!is_connac2(dev)) {
-			u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
-
-			if (!spe_idx)
-				spe_idx = 24 + phy_idx;
-			txwi[7] |= cpu_to_le32(FIELD_PREP(MT_TXD7_SPE_IDX, spe_idx));
-		}
+		/* Fixed-rate frames (all mgmt, so auth/assoc req too) otherwise
+		 * carry spe_idx 0 and TX 1SS 1T on WF0. Fill spe_idx like the
+		 * other connac generations do, but do NOT touch
+		 * MT_TXD6_SPE_ID_IDX: on connac2 setting it points HW at the
+		 * WTBL and the index below is ignored.
+		 *
+		 * spe_idx 0 is also a valid single-path index (WF0), so only
+		 * take the duplicate fallback when a second path exists.
+		 */
+		if (!spe_idx && hweight8(mphy->antenna_mask) > 1)
+			spe_idx = 24 + phy_idx;
+		txwi[7] |= cpu_to_le32(FIELD_PREP(MT_TXD7_SPE_IDX, spe_idx));
 
 		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
-- 
2.18.0

