Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A891F34DCCA
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2026 06:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773036465; cv=none; b=qlE5cOa7ayQQaAABNGiRa704r6k/0vRhKPIIq1QtpjgFyicGXVLreRE0kiuyKAz0u8/VPIjRM84GL19Va4kyucg4b9EgmiJzalnMD/v7DjRw2SdZgvR4OINhG3r1yqbLMHDez9mwWzSD1Yk6CYSyHrCNlXGYoci2J90cBEqzx2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773036465; c=relaxed/simple;
	bh=1AUQ9MaBqVTVxHSbuep2E4K4iUYtPqJWXl5L148uR8o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsKfYj09mW6pmtIQfm6nXWVR2FtaUI/8uWRJpavQyIEK67lBRoBIYrfRR9Xs6o3EcZyqgP2SoVdzEjiT2Qkwwh4yUvFMtJDWf8NqKb7PhzERJhmin7UA6JUvbBRO6JWasln7RAnxJUf7vYoL98tBKsI2lMAPtLAglfcMV01o8R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=R0Qz04Ga; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="R0Qz04Ga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v8M1kk3iTZeZs8oHtDVB3JVfniBLfipWdD/6XPnt6U8=; b=R0Qz04GaCgKmeEEqb2TGN8jaoy
	s+Bveo90QL+cOSI8PoHwZswx7T7PqDm2i2pvcR2p1LyaHcjwFxXvP7CIT5c6xcbpgpTc1eBflxbzV
	7sf3PpvO+URgQ3/1V97cMeTIYTcMva6ME6EpDD0uIU+luLziQpsm1v/cNcMVE498462I=;
Received: from p200300cadf236500000000000000085c.dip0.t-ipconnect.de ([2003:ca:df23:6500::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1vzTmC-00GH43-2i
	for linux-wireless@vger.kernel.org;
	Mon, 09 Mar 2026 07:07:36 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 06/11] wifi: mt76: optimize ROC for same-channel case
Date: Mon,  9 Mar 2026 06:07:25 +0000
Message-ID: <20260309060730.87840-6-nbd@nbd.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260309060730.87840-1-nbd@nbd.name>
References: <20260309060730.87840-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_remain_on_channel() always creates an HT20 chandef and goes
offchannel, even when the ROC channel matches the operating channel.
This unnecessarily narrows bandwidth and triggers beacon stop/restart.

When the ROC channel matches the current operating channel, preserve
the full chandef and skip the offchannel transition, matching the
optimization already present in the scan code.

Extract the shared same-channel detection into mt76_offchannel_chandef()
and use it in both ROC and scan paths.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76.h    | 12 ++++++++++++
 drivers/net/wireless/mediatek/mt76/scan.c    |  6 +-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 8d2e72c68c6b..f42f25101544 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -392,8 +392,8 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mlink->mvif->roc_phy = phy;
 	phy->roc_vif = vif;
 	phy->roc_link = mlink;
-	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-	ret = __mt76_set_channel(phy, &chandef, true);
+	ret = __mt76_set_channel(phy, &chandef,
+				 mt76_offchannel_chandef(phy, chan, &chandef));
 	if (ret) {
 		mlink->mvif->roc_phy = NULL;
 		phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index efb57a0d8965..fe1c50af460c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1793,6 +1793,18 @@ void mt76_queue_tx_complete(struct mt76_dev *dev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e);
 int __mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		       bool offchannel);
+
+static inline bool
+mt76_offchannel_chandef(struct mt76_phy *phy, struct ieee80211_channel *chan,
+			struct cfg80211_chan_def *chandef)
+{
+	cfg80211_chandef_create(chandef, chan, NL80211_CHAN_HT20);
+	if (phy->main_chandef.chan != chan)
+		return true;
+
+	*chandef = phy->main_chandef;
+	return false;
+}
 int mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		     bool offchannel);
 void mt76_scan_work(struct work_struct *work);
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 2b5f30cef795..5a67e9b8183a 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -139,11 +139,7 @@ void mt76_scan_work(struct work_struct *work)
 	}
 
 	dev->scan.chan = req->channels[dev->scan.chan_idx++];
-	cfg80211_chandef_create(&chandef, dev->scan.chan, NL80211_CHAN_HT20);
-	if (phy->main_chandef.chan == dev->scan.chan) {
-		chandef = phy->main_chandef;
-		offchannel = false;
-	}
+	offchannel = mt76_offchannel_chandef(phy, dev->scan.chan, &chandef);
 
 	mt76_set_channel(phy, &chandef, offchannel);
 
-- 
2.51.0

