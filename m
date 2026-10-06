Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECECD470117
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=qT6mWOWMORAbCySyRsU8xRxPyAnOxf+VF1FkkOMsPL36xlXLWYaW3ybzCk49xdMVOsD/8z9vaO6gkhS2o60MpeNlIRrH77Fh1fvmxteR8UPAkupXKTvNGqCHY9jN6q6ddjVHj8ApkN+lVPWWj+TUqduyXLRFhkeY82pl5Y9OfOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=p/J6Zcoz5LIuN08+n8h68z8/7sVwI8CEF65uWDsu5g4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvqVuMpI2MkZs2LYzFUSz6Bas3dTvh7vSg9kO4OeKbeylIGQQTplAh8oXZccCsRfITDTgUYmrttZOQl0VvsJ09NK5fRr0DwMsvu/WtnStLGOzLeEaE2xowa9BPo77s/b2YtBkJCn2ajp/ifNjVoPYicfjzQYD482o7onHDZ96Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=oqKu8H1/; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oqKu8H1/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2ii2ZhNfVz+NzMtY5svPiDhkx72CDMll/GNLX2PJngo=; b=oqKu8H1/9GvMc2PJ7UsTi4OP7v
	Pimh4JqySEQ8qSIOY/eoGw22PDX+nLFCUVlp/0C8S/TghIKiwvc0PyXntLkmZFBVQC0UPpVZ0ifUi
	+IwOh1P2BJKB43XQcGTlfFB2VMOkyXoAebp3QNLvpdKtEhvxOcNk7iaGaQN0iGiiOVGk=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-0w
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 11/27] wifi: mt76: mt7996: free the WTBL index if a link allocation fails
Date: Tue,  6 Oct 2026 22:59:20 +0200
Message-ID: <20261006205936.669125-11-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_sta_init_link() takes a WTBL index from wcid_mask before it
allocates the msta_link of a link other than the first one. If that
allocation fails, the function returns -ENOMEM and the index stays set
in wcid_mask, so no later station can use it.

Return the index to wcid_mask on that error.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3c27cc02d527..5207def2fd36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1159,8 +1159,10 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
-		if (!msta_link)
+		if (!msta_link) {
+			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
+		}
 
 		if (msta->seclink_id == msta->deflink_id &&
 		    (sta->valid_links & ~BIT(msta->deflink_id)))
-- 
2.47.3

