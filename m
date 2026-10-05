Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E27639150A
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233581; cv=none; b=ZWaZ94SumuBSuz8fUeXYbuM9AdLhUhpJH1y9W1QMtK7WMk5Q24mvULciPEfCk5vysEFNA92u4ULueuWQKIVMnBAm12YC2iNh67qr68hrwM5Tu/UUNnb0LhIntAM22Nto+GC/ADXxBV8obVQPhKWSIXngNsuHM1JRuLYSS4rUHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233581; c=relaxed/simple;
	bh=Wog0iRSGKClsxMyBudxgkKM7R3EtgCsLpg841Y7blQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t1XjfU/OnEk64SffKhIcxf5lScbPhb2IVjLocCQtD5qPvYLFp/lm3DRGjC7PInui44o7n/btDXwTWi3Dv7MRTgAtMRXSxd67afCfEbTDjRHIf1KRFTheqfkRPN2PJRMVxIphhbxwfGymA7J7hqu917ZRSS5iXslDRQ0xhklK408=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=GkRL9Ui9; arc=none smtp.client-ip=91.218.175.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="GkRL9Ui9"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Wog0iRSGKClsxMyBudxgkKM7R3EtgCsLpg841Y7blQ8=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791233573; v=1; x=1791838373;
 b=GkRL9Ui96MIsiaCYbto9pJY337hIOBGQ8CK4WxYoeOb6Y6aOXd3akhPcuNeVrfykmSqAm6MU
 stzLARhAYZyzBIdhFuQdWqi/TiwQipVfksJtSuX6+MT7CvwyZKewbaeR4xyFXJq8N9/1XcadJ9c
 SBW7kaUYO83gY/IpJZ8t0WJlcxnbDSBX7zTVNHnNdvn35FVtGBA8cU4oXKqwoEb6saoOGJbUBhR
 OBggB4SgdaSrmgCJZQlbkFUiQadFS75Y0ZxgN8UO9YQzq8QTzGnF5bFhoix+qM1SGtzp8jUkbD+
 /1M0zSEUpzEFmNW/pyvGQU+fCyHDOqGgO0jwDMPL5eOLQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 12bd7bdb79995992;
	Mon, 05 Oct 2026 20:52:43 +0000
X-Mizu-Trace-ID: 12bd7bdb79995992
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>
Subject: [PATCH wireless] wifi: mt76: mt76_connac: scan 6 GHz wildcard requests passively on connac2
Date: Mon,  5 Oct 2026 13:52:40 -0700
Message-ID: <20261005205240.241136-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

With WIPHY_FLAG_SPLIT_SCAN_6GHZ cfg80211 puts the 6 GHz channels in a
request of their own and lists the APs it wants to find there in
scan_6ghz_params. mt76_connac_mcu_hw_scan() does not read them, and the
connac2 scan command has no field for per-target data (only a single
bssid), so a wildcard request is sent as an active scan with an empty
SSID. On an MT7922 the firmware then listens for about 58 ms on a
single channel, shorter than a 102.4 ms beacon interval, and the AP used
for testing does not answer a broadcast probe request, so the beacon is
often missed. A scan of channel 37 (6135 MHz) found the AP in 9 to 17
of 30 attempts, and wpa_supplicant, which scans 6 GHz this way after
the legacy bands, ended up on 5 GHz in about four connections in ten.

Send the wildcard-only 6 GHz request as a passive scan (scan_type 0, no
probe requests). The single-channel window becomes about 119 ms. The
6 GHz stage is identified by sreq->scan_6ghz and not by counting
channels. Requests with a directed SSID stay active, legacy-band
requests are untouched, and mt7925 builds its own command from the RNR
targets and does not use this function.

Tested on an MT7922 (PCIe), kernel 7.3.0-rc4, one UniFi AP with a PSC
channel 37 BSS, same boot, random order, 30 scans per cell:

                             before    after
  wildcard 6135 MHz           9/30     30/30
  5320 + 6135 MHz            10/30     30/30
  explicit passive           30/30     30/30
  directed SSID              30/30     30/30
  5320 MHz only              30/30     30/30
  2.4 GHz channels           30/30     30/30

wpa_supplicant cold start picked 6 GHz in 18 of 30 attempts before and
in 30 of 30 after; the 6 GHz stage takes about 0.35 s longer. Sending
scan_type 1 with no probe requests behaves like the unmodified request,
while scan_type 0 with probe requests works, so the effect comes from
the scan type and the listen window, not from the probes.

Not tested: non-PSC channels, scheduled scan, other APs, MT7921 and
MT7902 parts. This does not fix the 4-way handshake timeout in #106.

Fixes: 0e5911bb7cc9 ("wifi: mt76: mt7921: fix non-PSC channel scan fail")
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2f925d22b9aa..d684fd306fee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1850,6 +1850,18 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	req->ssid_type_ext = n_ssids ? BIT(0) : 0;
 	req->ssids_num = n_ssids;
 
+	/* cfg80211 splits the 6 GHz channels into their own request and
+	 * describes the APs to look for in scan_6ghz_params, which this
+	 * command cannot carry. As an active wildcard scan the firmware only
+	 * listens for a short time per channel and often misses the beacon.
+	 * Scan the wildcard-only 6 GHz stage passively; directed scans stay
+	 * active.
+	 */
+	if (is_connac2(phy->dev) && sreq->scan_6ghz && !n_ssids) {
+		req->scan_type = 0;
+		req->probe_req_num = 0;
+	}
+
 	duration = is_connac2(phy->dev) ? 0 : MT76_CONNAC_SCAN_CHANNEL_TIME;
 	/* increase channel time for passive scan */
 	if (!sreq->n_ssids)
-- 
2.55.0

