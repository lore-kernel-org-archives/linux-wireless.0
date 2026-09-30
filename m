Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23E46AF2F
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 22:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790808759; cv=none; b=LWNWN6P1eq6H1UcxkDVgF26fkK2Mcak7Pt5q/wpQpivX0061saZEnTwaweY9FMfHjQoUxCCEoEEQail0Q3EsLGugvynLXCM6xSf8mhHPN933ez2qRfy3dwk6IBli2i5JMiL1PzPhzwUEzEPNSqdrEYlL0VDr/Gb1vRK77Jx6Ubw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790808759; c=relaxed/simple;
	bh=uLd4SDI8mcMrk1niHVwEFhzNyvAhma1OM3HOiPXmZxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jY/piPFC6KMhqOxWe2ZlgbXvwUoA4JIenxQGMhSAPp5VK/vfDuFBgtJo3iijwwDVw5Ph++R2VTxkdHYA3xiFXG69AldDbQH6+qQ6PNIMKrlbTrZ4rUR99IBdeTuTriOJW42K90jLpmcLC39K5sN+KOB0yIijCZiaXzYatkjxZsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=F/sDlV+o; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="F/sDlV+o"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uLd4SDI8mcMrk1niHVwEFhzNyvAhma1OM3HOiPXmZxU=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790808749; v=1; x=1791413549;
 b=F/sDlV+opP9hGCB+2cArmMWmEEDIeu8F141EI+AYAScbd9tkE7IvFAsN2ZT/HNQaVZmJaLzm
 AAEF4agESINubglG60fNIzn2KvTNwzn70SQvaWVT8OsQlzkQxUwfkNADAfTa1CDaTB1Mw3rWLaJ
 jssbxJa9z6mFsJtzCQusbCHkjksGgg4+kLvHIyCPphtpAh3D3aB5EHaXqemaX3K3pXrDLuaCn3f
 f+OjseGsabfSZfa4h2TB1pZFGpMyYDH2vJXr/KddGHeT9pHnFm5YXub/QshpLeMOChqfOF9PMb0
 TgNt6TSRA4wGtVM3A+zn4+L5EeXA3ihhGmvJwZfEQVAfQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fae8c6ae68c24c26;
	Wed, 30 Sep 2026 22:52:27 +0000
X-Mizu-Trace-ID: fae8c6ae68c24c26
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Chris <hoopyfrood42@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: move the channel survey when the channel changes
Date: Wed, 30 Sep 2026 15:52:24 -0700
Message-ID: <20260930225224.2280198-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7921 and mt7925 report every survey counter against one channel and
never mark the one in use. Both use channel contexts, so the code that
moves the survey never runs.

Move it when a context is assigned or changed, after booking the time
spent on the old channel.

Tested on MT7922 over PCIe, MT7921AU and MT7925 over USB.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Reported-by: Chris <hoopyfrood42@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com/

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c   | 17 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h       |  2 ++
 .../net/wireless/mediatek/mt76/mt7921/main.c    |  1 +
 .../net/wireless/mediatek/mt76/mt7925/main.c    |  2 ++
 .../net/wireless/mediatek/mt76/mt792x_core.c    |  1 +
 5 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index cda5c5d51aab..e2e567ca968e 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1045,6 +1045,23 @@ void mt76_update_survey(struct mt76_phy *phy)
 }
 EXPORT_SYMBOL_GPL(mt76_update_survey);
 
+/* For drivers that retune without __mt76_set_channel(): book the time spent
+ * on the old channel before moving the survey to the new one.
+ */
+void mt76_set_survey_channel(struct mt76_phy *phy,
+			     struct cfg80211_chan_def *chandef)
+{
+	if (!chandef->chan)
+		return;
+
+	mt76_update_survey(phy);
+
+	phy->chandef = *chandef;
+	phy->main_chandef = *chandef;
+	phy->chan_state = mt76_channel_state(phy, chandef->chan);
+}
+EXPORT_SYMBOL_GPL(mt76_set_survey_channel);
+
 int __mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		       bool offchannel)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb7c0..2cbe9884ab46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1548,6 +1548,8 @@ void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 int mt76_update_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
+void mt76_set_survey_channel(struct mt76_phy *phy,
+			     struct cfg80211_chan_def *chandef);
 void mt76_update_survey_active_time(struct mt76_phy *phy, ktime_t time);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index ef5081549d0e..9774934cc3fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1414,6 +1414,7 @@ mt7921_change_chanctx(struct ieee80211_hw *hw,
 	} else {
 		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->bss_conf.mt76, ctx);
 	}
+	mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
 	mt792x_mutex_release(phy->dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 4264c392527e..8fd29ad05162 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2053,6 +2053,7 @@ mt7925_change_chanctx(struct ieee80211_hw *hw,
 						      link_conf, ctx);
 		}
 	}
+	mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
 
 	mt792x_mutex_release(phy->dev);
 }
@@ -2389,6 +2390,7 @@ static int mt7925_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	mconf->mt76.ctx = ctx;
 	mctx->bss_conf = mconf;
+	mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 0ad33f74c228..6a0d5b2c2d59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -472,6 +472,7 @@ int mt792x_assign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 	mvif->bss_conf.mt76.ctx = ctx;
 	mctx->bss_conf = &mvif->bss_conf;
+	mt76_set_survey_channel(&dev->mphy, &ctx->def);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
