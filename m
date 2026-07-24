Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47024332EA2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883116; cv=none; b=bHWOeejycK+ji5/OpW1dIT+Xdyrv6jgeQ1QcnuKqnNz3amIp0qT2MgsvQWWuFTKChbJOiEiJrBTmmNlU9lflXppU/Ap/0qQKnA84bp7MOK06LWeEkZ0F4Mm9RcNBYrJaMPb5q3FW0CtPUPUmIwGk31Jf0gNcYTfpzpZkkFzZ+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883116; c=relaxed/simple;
	bh=GItInJdCLDlnK07j27I2CmiaJumEdsxk+Jomp0xlpGY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jkhiVCDUTco34uZQVDvOo7v1LP57OTJ+34W+1GSoYIJ1A//+4yvRRhCPcglnCF2xDm4nsx58KxlViiQzPQ30ay8zow6GTc33ZY4U4pJAWC19YKJdiDnjpKcgYkRa7HY+Jj+MM7GkQb+wJUOnLYygS3pSIM3Dy8mfIL8XAj98DuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IoLtEupJ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IoLtEupJ"
X-UUID: e73e4a10873c11f1b1788b6acf885367-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=bqCu3XbxSgPpATVjIcDE5cbl5QlWnkiGM1cLYPhR9hs=;
	b=IoLtEupJfCrYRKG3vu/FLbcFA7U1WsnHH5iOFwkxRhau6/w/y/y+8th40hk6NkEZ6YBaR+x6gYc3qR2cF37ts2AN+UTKvsEM0xs6pLcJiOsXKzoRTLuUojQ94VRF93aZNhDCF5WfwwavIwp5KJDczZzsOVc8YzZxvWlTDdEJ+dM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:5d0dc4aa-5e42-4f8d-a634-78df975c3cbc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:6b2dc67c-2130-4989-abc2-c441a2406941,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99|1
	00|102|154,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e73e4a10873c11f1b1788b6acf885367-20260724
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1738987104; Fri, 24 Jul 2026 16:51:47 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:51:46 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:51:46 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: connac3: use __le32 for mt7925_regd_rule fields
Date: Fri, 24 Jul 2026 16:51:44 +0800
Message-ID: <20260724085144.3156287-1-jb.tsai@mediatek.com>
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

The mt7925_regd_rule structure is parsed directly from the firmware
regulatory event, whose fields are little-endian. Declaring start_freq,
end_freq, max_bw, eirp and flags as u32 misrepresents this wire format
and triggers sparse endianness warnings on big-endian aware builds.

Change these fields to __le32 to reflect the firmware byte order.

Fixes: 4ce639ea518f ("wifi: mt76: mt7925: add regulatory wiphy self manager support")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/regd.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regd.h b/drivers/net/wireless/mediatek/mt76/mt7925/regd.h
index 2feacf42dc22..373992558974 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regd.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regd.h
@@ -13,11 +13,11 @@ struct mt7925_regd_rule_header {
 };
 
 struct mt7925_regd_rule {
-	u32 start_freq;
-	u32 end_freq;
-	u32 max_bw;
-	u32 eirp;
-	u32 flags;
+	__le32 start_freq;
+	__le32 end_freq;
+	__le32 max_bw;
+	__le32 eirp;
+	__le32 flags;
 	u8 rsv[12];
 };
 
-- 
2.18.0

