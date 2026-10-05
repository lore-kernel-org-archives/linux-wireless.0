Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B603390600
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791232735; cv=none; b=KfKm90Kfsy2w1MK3TzDt6CwVqYTFx6r+GvCQPNmv/ceEYu7obY2QXDY9veIOowN9YjdUr/hwtT7viwAf2dk6NgDf4nPnS7a7R87P0L6gk9ZfjZWOU3K3qD65UfEuwCNs3Bit1mSgykjzmOfpYK/OKLI93f/EZZ11JjRsVpLNeB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791232735; c=relaxed/simple;
	bh=YrYyR/6BX+th5kqG38wmrgA+/1vrNlDI2jJdQhFFI3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EKE8xyM+xG9Udr9w23+4MG++/ykmB5JNJIt0u7+Xl4CTOwSMy+4uUS05keIOzO70tDeRQCUwM4w4P4WrN2gM4LBq4fBoSlxBg5JI5NCXsma82CDE5ST4ZFlhFM4iQj7AK6nfCjU6JfvUvQrNN4Vi0Va4daCyMN+rZrAkhuFPEiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=DvE0DMbm; arc=none smtp.client-ip=95.215.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="DvE0DMbm"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YrYyR/6BX+th5kqG38wmrgA+/1vrNlDI2jJdQhFFI3w=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791232729; v=1; x=1791837529;
 b=DvE0DMbmUyYPAkBFz0mJ6mSEb8FoLLrSgc9o5+pphOeXczzfnRv8aqNVlUBKhGdNpfk98qN8
 b+pNk/fth+D6G0Mt7cO1THxrVBJocVnms6hUsUEAwsP81HhP/qL0NqyuxM0aXu+WQj3UCeU69Uq
 sLKoCkh0/+SdGCgPrLExC2XUUn5haC6MYD44hG75/xrdCYHIuGsq+ZpUx7TJQzgMBy5F+DuUFma
 DoFHeGLPiiFqfkvhyMp9iWoX/IKAht1K/ScmWu2uLSo+lGf9FXgDux51Ua3Edw3l+u5XaDmpcue
 sB7S0ggUnhcPJqrrboUQ1zUekcqQX1GM2CYy5/4/1aXAg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fcdd8944095dfdfa;
	Mon, 05 Oct 2026 20:38:48 +0000
X-Mizu-Trace-ID: fcdd8944095dfdfa
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>
Subject: [PATCH wireless] wifi: mt76: mt7921: keep the join ROC until the station is authorized
Date: Mon,  5 Oct 2026 13:38:46 -0700
Message-ID: <20261005203846.239445-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

When an association succeeds mac80211 calls mgd_complete_tx(), and
mt7921 aborts the join ROC there. The AP starts the 4-way handshake
right away, so the abort lands where message 3 arrives. On an MT7922
this loses message 3 often enough to matter: the supplicant sends
message 2 (acked), never receives message 3, and the connection ends
with reason 15 (4WAY_HANDSHAKE_TIMEOUT) after about 3.3 s. The mt7925
capture in the linked issue shows the same ordering: abort, message 2
out, then message 3 retried by the AP several times without an answer.

Keep the ROC after a successful (re)association on a station interface
and release it when the station is authorized, on disassociation, or
when the station is removed. The ROC timer still ends it if none of
that happens. The state lives in a flag in struct mt792x_vif so that an
unrelated ROC, for example a user remain-on-channel, is never aborted
by the authorize hook.

Tested on an MT7922 (PCIe), kernel 7.3.0-rc4, WPA3-SAE AP, two rounds
of 20 disconnect/reconnect cycles per build in the same boot, unpatched
and patched in ABAB order:

  unpatched   34 of 73 association attempts: M1 rx, M2 tx acked,
              no M3, reason 15
  patched      0 of 40

Delaying the abort by 20 ms before it made no difference (8 of 29),
and delaying 20 ms after it removed the failures (0 of 20), so what
matters is where the abort lands relative to the handshake. The
firmware behaviour after the abort is inferred from these outcomes, not
observed directly.

Not tested: MT7921 and other connac2 parts, USB and SDIO, APs other
than the one above, open or WPA2 networks, scheduled scan, suspend and
resume.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Link: https://github.com/morrownr/mt76/issues/106
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 21 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 68a059504e83..828b5b5df343 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -865,6 +865,12 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (sta->aid > MT7921_MAX_AID)
 		return -ENOENT;
 
+	if (mvif->roc_join_held && !sta->tdls &&
+	    (ev == MT76_STA_EVENT_AUTHORIZE || ev == MT76_STA_EVENT_DISASSOC)) {
+		mvif->roc_join_held = false;
+		mt7921_abort_roc(mvif->phy, mvif);
+	}
+
 	if (ev != MT76_STA_EVENT_ASSOC)
 	    return 0;
 
@@ -906,6 +912,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
@@ -1447,6 +1454,20 @@ static void mt7921_mgd_complete_tx(struct ieee80211_hw *hw,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	/* The AP starts the 4-way handshake as soon as the association
+	 * succeeds. Releasing the join ROC at this point makes the firmware
+	 * unresponsive for several ms right when message 3 arrives, so it
+	 * can be lost and the handshake times out. Keep the ROC until the
+	 * station is authorized; mt7921_mac_sta_event() releases it. If that
+	 * never happens, the ROC timer or the station removal does.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION && info->success &&
+	    (info->subtype == IEEE80211_STYPE_ASSOC_REQ ||
+	     info->subtype == IEEE80211_STYPE_REASSOC_REQ)) {
+		mvif->roc_join_held = true;
+		return;
+	}
+
 	mt7921_abort_roc(mvif->phy, mvif);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9efc251cb745..d4bbfaeb54b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -191,6 +191,7 @@ struct mt792x_vif {
 	struct mt792x_sta *wep_sta;
 
 	struct mt792x_phy *phy;
+	bool roc_join_held; /* join ROC kept until the STA is authorized */
 	u16 valid_links;
 	u8 deflink_id;
 	enum mt792x_mlo_pm_state mlo_pm_state;
-- 
2.55.0

