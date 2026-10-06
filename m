Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0571F192E
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 03:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256474; cv=none; b=mFOEhBpPyX3FJA0RomtGDe513vmyowcntPkHqremHRCSBM5heFA5D1V0ESVb7QsPspDqsyijLkk6lAVLdu6jztdgbDGJwRlTvmgELFt+xLE3fSTA7VH9NvmH4NukOZJ2WdVVBsvMUusFbV3haxF8VIRGiiJbS4orZL9RdojS2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256474; c=relaxed/simple;
	bh=iNqFz5VVYLu8BOKksEYSpdAHzluhTXveXGhG/FJMs7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IjoeraGJ9tuhoEtDm+GQa2Hopkiores4dNzPa7OrZebepehMDbzdicaP5+tPXTdlGIkvxJC2sEL8sSzkR0ZV2Z73MIUHByrMG5PO320dGxWhlVfCNmz8pg4VtBdn4AfYOmesA/SBhRtomnfE5GimrWq0j4A5RFR8SjQzDjR3cwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=vDnxcwCM; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="vDnxcwCM"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iNqFz5VVYLu8BOKksEYSpdAHzluhTXveXGhG/FJMs7I=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791256469; v=1; x=1791861269;
 b=vDnxcwCM5nkwYZwdjbGKg/lffMGpz+Dy2QPvOHOQIiU0erkZFmGQZobci29FZHzrkVlFuM5Q
 y5NhwQ6O3PkrOzCUTJePwhUGk6icHSXLq6ApHu5TRvfdy9qDFDRf8k0hg3ivAXF6c3eM2wwRrjj
 Se01PWEqRqUii9CjCMB2mTRR9uPPmeNmVxvAInr30t3T4nfoL3WGvnM0lzCKEbEO1rcWd8aMD49
 0SHMroDbI1aqM5OgoJof2U+4Opi4wirioa+y5AHX2wCa83fC33CAcM4AwfOv/4QAualL9xVg9VL
 5X1RPkVPX+MfYXgiW3IjJG8RlBOtA2jNmyIHptlNxNCLw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0cbea5d174a8d1de;
	Tue, 06 Oct 2026 03:14:28 +0000
X-Mizu-Trace-ID: 0cbea5d174a8d1de
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
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Mark Junker <fubar-coder@live.de>
Subject: [PATCH wireless] wifi: mt76: mt7925: keep the join ROC until the station is authorized
Date: Mon,  5 Oct 2026 20:14:25 -0700
Message-ID: <20261006031425.20922-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

When a non-MLO station associates, mgd_complete_tx() aborts the join ROC
as soon as the association succeeds, which is right before the supplicant
sends message 2 of the 4-way handshake. With the abort that close to
message 2, the adapter acknowledges nothing the AP sends for the next
several ms: the AP sends message 3 and its seven retries within about
5 ms, none is acknowledged, and the handshake ends with reason 15
(4WAY_HANDSHAKE_TIMEOUT).

Keep the ROC after a successful (re)association on a non-MLD station
interface and release it when the station is authorized, on
disassociation, or when the station is removed. The ROC timer still ends
it if none of that happens. MLD interfaces keep the old behaviour: there
the ROC that is active at this point is the MLO ROC set up by
mt7925_mac_set_links(), and holding it makes mt7925_set_mlo_roc() fail
with -EBUSY in the link activation work, which leaves one link instead of
two.

Tested by a reporter on an MT7925U (USB) against a FRITZ!Box 5690 Pro on
a 6 GHz-only, non-MLO SSID, kernel 7.2.3, from traces and monitor
captures taken in separate runs:

                       handshakes   first M3 acked   abort before M2
  unpatched               8 of 84         0 of 83           84 of 84
  this patch             30 of 30        31 of 31            0 of 30

With the patch the AP sends message 3 once and the adapter acknowledges
it straight away; the ROC is released right after the station is
authorized. A 20 ms delay after the abort instead of this change gave
15 of 15, which points at the abort timing and not at the delay.

Tested here on an MT7925 and an MT7927 (PCIe), kernel 7.3.0-rc4: on a
non-MLO SSID neither build showed the failure (1 stalled handshake in 110
unpatched, none patched), so no effect could be measured there. On an MLO
connection the change is inert: 16 of 16 link activations succeeded in
two rounds per build, with two active links and the same ROC order as
before.

Not tested: other APs, other USB parts, MT7927 over USB, MLO connections
beyond the check above.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Reported-by: Mark Junker <fubar-coder@live.de>
Closes: https://github.com/morrownr/mt76/issues/106
Tested-by: Mark Junker <fubar-coder@live.de>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
This goes on top of the mt7921 version, which adds the flag both use:
https://lore.kernel.org/linux-wireless/20261005203846.239445-1-lucid_duck@justthetip.ca/

 .../net/wireless/mediatek/mt76/mt7925/main.c  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 5993b31e1aae..6b0a09e2f6cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1243,6 +1243,13 @@ int mt7925_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 {
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 	struct ieee80211_link_sta *link_sta = &sta->deflink;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	if (mvif->roc_join_held && !sta->tdls &&
+	    (ev == MT76_STA_EVENT_AUTHORIZE || ev == MT76_STA_EVENT_DISASSOC)) {
+		mvif->roc_join_held = false;
+		mt7925_abort_roc(mvif->phy, &mvif->bss_conf);
+	}
 
 	switch (ev) {
 	case MT76_STA_EVENT_ASSOC:
@@ -1438,6 +1445,7 @@ void mt7925_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 	}
 
@@ -2089,6 +2097,25 @@ static void mt7925_mgd_complete_tx(struct ieee80211_hw *hw,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	/* The AP starts the 4-way handshake as soon as the association
+	 * succeeds. Releasing the join ROC at this point makes the firmware
+	 * unresponsive for several ms right when message 3 arrives, so it
+	 * can be lost and the handshake times out. Keep the ROC until the
+	 * station is authorized; mt7925_mac_sta_event() releases it. If that
+	 * never happens, the ROC timer or the station removal does.
+	 *
+	 * Not for MLO: there the ROC active here is the MLO ROC set up by
+	 * mt7925_mac_set_links(), which has to be released before the link
+	 * activation work sets its own.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION && !ieee80211_vif_is_mld(vif) &&
+	    info->success &&
+	    (info->subtype == IEEE80211_STYPE_ASSOC_REQ ||
+	     info->subtype == IEEE80211_STYPE_REASSOC_REQ)) {
+		mvif->roc_join_held = true;
+		return;
+	}
+
 	mt7925_abort_roc(mvif->phy, &mvif->bss_conf);
 }
 
-- 
2.55.0

