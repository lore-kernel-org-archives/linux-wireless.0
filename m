Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F14A0148
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320387; cv=none; b=laBIp050+HQ458cCYvngd8731rXYpxfo4HIrwrR7msADotrCB92I2OjaaKGAzbg3UnD8RRmTLEE608CfKNf1nGG+cvRw/AgdQPTwG5O3rCvMXDXYCMhvRb0Ejp1N00cqzJoJKjEeF/jssuMJNafap7qLr5xjC09l03S4Ew8V9Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320387; c=relaxed/simple;
	bh=VAJQ3fQ3tOL2XxKxIepg10zGx3YOJpC/DzSwtGQCmFQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuVEU9ioHGI9Jx7UboU3xNuYXbVzKCZ6Z1MDRorkfH1OLeZCFChdZxhg7rQ57lXdPg/uRw6j5jx5pkjWsetfyK9nsAJ2Oiu7Nc4EdyZNESYWw3S0zjdooMe8eDwdoxkibkxEMyCIKbU0hkO81V0UiGP2CocZB1guXPPkQcjwzMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=i3s4Hpjr; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="i3s4Hpjr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oapb2A9K9S0Ug/B2alNUeBRDaUkUhIx+miQXFIyuTG0=; b=i3s4HpjrriLBfnJkfdvyLBOvai
	x7q6aYq1Xdig5PLF87jX7Fo7Q04j8PJJOOA1cNlIucTb++dsRdJZ3FAuKVJIMIrIZtmIitkzVLECb
	R1SlMYC3C9VR5yqk4FUtrOc2ulE5Qph7n7fRtxs3fYeanKbWEYcm+93UGnrMyLdlZFrw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-36
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 15/27] wifi: mt76: mt7996: keep a returning link when adding station links fails
Date: Tue,  6 Oct 2026 22:59:24 +0200
Message-ID: <20261006205936.669125-15-nbd@nbd.name>
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

mt7996_mac_sta_add_links() removes all links that it was asked to add,
with flush set, when one of them fails. A link that comes back after
a removal kept its msta_link and may still have a firmware entry. The
flush frees its msta_link and returns its WTBL index to wcid_mask, so a
later station can be given an index whose entry still belongs to this
station.

Flush only the links that this call created, and remove a returning
link again without flush.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 8e70a4061ed6..58a487549ddf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1355,6 +1355,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta, unsigned long new_links)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned long created = 0, returned = 0;
 	unsigned int link_id;
 	int err = 0;
 
@@ -1372,6 +1373,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				mt7996_sta_deflink_set(sta, link_id,
 						       msta_link->wcid.idx);
 			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
+			returned |= BIT(link_id);
 			continue;
 		}
 
@@ -1405,12 +1407,14 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			goto error_unlink;
 
 		mphy->num_sta++;
+		created |= BIT(link_id);
 	}
 
 	return 0;
 
 error_unlink:
-	mt7996_mac_sta_remove_links(dev, vif, sta, new_links, true);
+	mt7996_mac_sta_remove_links(dev, vif, sta, created, true);
+	mt7996_mac_sta_remove_links(dev, vif, sta, returned, false);
 
 	return err;
 }
-- 
2.47.3

