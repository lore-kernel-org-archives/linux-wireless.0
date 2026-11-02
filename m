Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793646499;
	b=eMvqsGoi89cdLslae9NygBews1K11eC1H9/UwcWvmY9Rg3A+GKozvfAn4kxy3tACDd7+
	 xHImW7EVuFbuBF0I/UFb2JZPaDXxWWbrMRI9rUpHC7q7mjrV0kqtebQ9XXLIg/GdcWq4H
	 5tDlQSO4ak+H1wxo+xG5T94sniodn9kk8NbuE4Vp+RCktYgHmhk2RJ/d6hiv4lxnz7vXC
	 ZoRz615unbr2Cojr9kCqSUgzWO9dpRepI5ULYXnqzpCkqs7Dr7ga/3HqTBxZAk2qe7XLF
	 WZRioi0Zw1NMAngbEz9MgVNMDXweTt5AGuP1RxllXjuQ1c4nvJIEL/+p7wWart+UgzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646499;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hy0oPK5x/QkI8yqeUndJIQC9ebEkYHogcz870Uc7RMg=;
	b=wZ4nmQe8JBZcNbem/mXZZFIdZ0TQllrThfrb14NqU77NFIoy6vtMYUY8LFCwI0QEUPT3
	 6jmEbjSURWWlnEalAf5gIscgGCdyb9XhoJjJCPjHCnXmPbeZET0/mNqdXY+2VOb+gitfD
	 7Wsmbdy+cvM7Nq8EKWc6XGayhIXGckCL07OoaptV9p5C/kaeCHeTIRf8nfbGM78jhUD5A
	 7CgvIayWnltmhodXv9ufyic4/n9eBZq4WEBvJ607th3NwXkRroo4F5OmOJJOc79MehlNb
	 bWGLz5xi2GGo6rXIK5Ya+Zr1vTSuWTxNT2WDSh8UUcfsWhoCWEtmINb8jyB9+wlu1lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=CmLpgdxd;
	arc=none smtp.remote-ip=91.218.175.239
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E81606A332
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 19:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81E81606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=CmLpgdxd
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QX/N0pi5EXSkCjh+fydbWA1avkaaXFymjQBf/Df4PlI=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793646496; v=1; x=1794251296;
 b=CmLpgdxdVfvDfgxKM+mCR0S61bi0YtF2di81In1Q4JViL42ak59/J1YS4FVMJaNNPQjbTCXS
 1GcN5oWgtL4BXQpgNhfq+EgwBnmzuhxJZaOGuEoTwqJRT2EjFsczy21uEw9SWmXsf7Y6v6WFL/G
 9AKQnqk3RY//9RAFMmRz/z9u7thqSCbuDZVf0SyJ0b159nflizlhBYo8RLB5xjEBfTdeu8VMIAx
 WTumwQNi/z9PzTJKuZq3InDrmhUYfXkXyl9wUo/ndaxkHDLzIzlMwWFuuD2mt7KmfsCAVkLE380
 uuZiLMBI1O/X0oAlQLfsI473Ttz6GulORMzwaTTDH/3qQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 37af8cb3d0c59ae7;
	Mon, 02 Nov 2026 19:08:16 +0000
X-Mizu-Trace-ID: 37af8cb3d0c59ae7
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sven Besser <sven.besser@sql-ag.de>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt7925: add the common scan IEs back to probe requests
Date: Mon,  2 Nov 2026 12:08:11 -0700
Message-ID: <20261102190811.7498-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <FRVP281MB5672AE5BBD61EF0802D42370A0942@FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM>
References: <FRVP281MB5672AE5BBD61EF0802D42370A0942@FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wi-Fi Direct search can no longer find devices in Listen state, such as
Miracast sinks. The probe requests lack the P2P IE, which mac80211 puts
in the common IEs, and only the per-band IEs are sent to the firmware.

Add the common IEs to each band of a normal scan, as long as the band
still fits in one byte of length: the firmware ignores the high byte.
Leave scheduled scans alone, since the firmware can time out on them
when their IEs grow.

Fixes: 9f8f4a51f3c1 ("wifi: mt76: mt7925: fix incorrect scan probe IE handling for hw_scan")
Reported-by: Sven Besser <sven.besser@sql-ag.de>
Closes: https://lore.kernel.org/linux-wireless/FRVP281MB5672AE5BBD61EF0802D42370A0942@FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM/
Suggested-by: Sven Besser <sven.besser@sql-ag.de>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Tested with wpa_supplicant: one radio searching, a peer listening on
channel 6, and a third radio capturing the search probes.

                                probes with    peer
                                the P2P IE     found
  MT7925U, wireless-next        0 of 162       no
    with this patch             98 of 98       yes
    9f8f4a51f3c1 reverted       19 of 19       yes
  MT7927, 7.3.1, out-of-tree    0 of 231       no
    with this patch             228 of 228     yes

A Miracast-style search, with a Wi-Fi Display subelement and the longest
allowed device name, stays under the limit and finds the peer on both.
Without the two limits, longer probes went out cut short and scheduled
scans sometimes reset the chip. Plain scans and joins are unchanged. Not
tested on mt7928.

Sven, thanks for tracking this down.

 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 50f5f57b740e..b614653debd1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3259,10 +3259,10 @@ EXPORT_SYMBOL_GPL(mt7925_mcu_set_dbdc);
 static void
 mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 			     struct sk_buff *skb,
-			     struct ieee80211_scan_ies *scan_ies)
+			     struct ieee80211_scan_ies *scan_ies, bool common)
 {
 	u32 max_len = sizeof(struct scan_ie_tlv) + MT76_CONNAC_SCAN_IE_LEN;
-	u32 ies_len, alloc_len;
+	u32 ies_len, common_len, alloc_len;
 	struct scan_ie_tlv *ie;
 	enum nl80211_band i;
 	struct tlv *tlv;
@@ -3278,6 +3278,15 @@ mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 		if (!ies || !ies_len)
 			continue;
 
+		/* The vendor IEs (P2P, WPS, WFD, ...) are in common_ies. The
+		 * firmware keeps only the low byte of a band's IE length, so
+		 * add them only where the band stays within 255 bytes.
+		 */
+		common_len = 0;
+		if (common && ies_len + scan_ies->common_ie_len <= U8_MAX)
+			common_len = scan_ies->common_ie_len;
+		ies_len += common_len;
+
 		if (is_mt7928(mdev))
 			alloc_len = ALIGN(sizeof(*ie) + ies_len, 4);
 		else
@@ -3290,7 +3299,9 @@ mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 					      alloc_len);
 		ie = (struct scan_ie_tlv *)tlv;
 
-		memcpy(ie->ies, ies, ies_len);
+		memcpy(ie->ies, ies, ies_len - common_len);
+		memcpy(ie->ies + ies_len - common_len, scan_ies->common_ies,
+		       common_len);
 		ie->ies_len = cpu_to_le16(ies_len);
 
 		switch (i) {
@@ -3428,7 +3439,7 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	}
 
 	/* Append scan probe IEs as the last tlv */
-	mt7925_mcu_build_scan_ie_tlv(mdev, skb, &scan_req->ies);
+	mt7925_mcu_build_scan_ie_tlv(mdev, skb, &scan_req->ies, true);
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
 				    true);
@@ -3530,8 +3541,10 @@ int mt7925_mcu_sched_scan_req(struct mt76_phy *phy,
 	}
 	chan_info->channel_type = sreq->n_channels ? 4 : 0;
 
-	/* Append scan probe IEs as the last tlv */
-	mt7925_mcu_build_scan_ie_tlv(mdev, skb, ies);
+	/* Append scan probe IEs as the last tlv. A scheduled scan keeps the
+	 * band IEs alone: the firmware stops answering it with more.
+	 */
+	mt7925_mcu_build_scan_ie_tlv(mdev, skb, ies, false);
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
 				     true);
-- 
2.56.0

