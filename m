Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BA24A441D
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 18:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880345; cv=none; b=Gzo7eprhzipo1K0IAVQnk6jfuABEP3QxCQ11HInAqMzs2XWXJKleKhgiuDjLwOPrazWU06t6AB5bCI6J4ENlYvEq7jNJW/gDovcOsh4nIMxWwpF7TQbRvkXzlGYLMztQDq216ZrvnebEmVDstNyGAITTADEl/jm83gegLicZ674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880345; c=relaxed/simple;
	bh=nCDRU72fQOMhTad157rSB6/1ns7EC6CJYlfxPDRmfOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fDUZ6MUDnaKzR4+G5x/jVL3tVZqgeXqQggt78/frQNRPlIbuwWJbteGfTHNtkE0stu3c3Bc+2IO6vPXY2rVe5bPIJydeCAuuq13rsdpFzAFSV1aOAZpgmoVkqBh0VcnOOj9c1rn88PgZzOWhjoHA8ASLpznY3CwBDd8NO00J6mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgxCwUQF; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgxCwUQF"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8a7411012b1so67698927b3.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 11:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790880337; x=1791485137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LEuPwFxcSXPt6vU49ypeUwJ6niYWnQ/MOBnEtBhOy/c=;
        b=SgxCwUQF31s1YjW2UqtfeP1Lcj3I63ms0YmLNi0EjZ+2L41ALd/1zH0ZNHj7DcQQkl
         zhS/0VfK19p6V89gfu7PljgP3RfnfocM+h4ithyr1jLKuX+tcdOgzLKc7pf1SrVGCQav
         D9U0ctd5TmYuKUC0Csv4DFI8Cl5Vp3YLAG94zDj8BxfNGKWaWqYiARvAWTFauTTPE2AM
         HHlk/oLQMsUsQPC/KJnXy2FgRAx2LfOVPIFDBCy/B4XDhvqVjMjkonZcMth2G+aYTYJ2
         KGpGNbHJX16fkYvuf1DgWgcEWBBJ+30q9scL6mnYJOrjLgAWJHrIw3Hg/Mm5e3CnC7to
         Xx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790880337; x=1791485137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LEuPwFxcSXPt6vU49ypeUwJ6niYWnQ/MOBnEtBhOy/c=;
        b=yNy0nb3r6pjxhpeiw2z1qvbq9m1PU53vnDguFsxlTx2NuEJBoz6+nqASdAFWgBD+Zb
         TJLWPyJzFYMAPTEBK8YEk10Qa7I2b2tca8YLA3gI2uP0Q9dXVMYDDDAKyKeyFt0NYUJg
         DKnbIDeBbdaJfIoTJ24g5MMZGH0/VIk2LHVJFYIQYv0IxxsR9roZwz1h913FmwNckLlq
         9KtbBRxplfapEfSxPE9pvIH/+MEEUOCm6+IMOaamRNAU6SBf9+FHpNSaDIgnSfdB8++8
         MRJ65wEXFrd5thzn5p0cEeLo+vbEjM9nfVTQwcwzvBK7x1tT8nNiUQuHa6t6U48HEJAa
         w/tQ==
X-Gm-Message-State: AFq9FYJ1vVC4IvzOz0UE8PJWFFwD5jEhy64y9CgxdvwiXlJXlqeWETA0
	ATeUVedZAViwREeDNVITIXqlecrUqMrlGj58ZrkQMN5EXLgUfOewz30YR6UOSg==
X-Gm-Gg: AYBFou35M/BX7DkFZ8qaG+8Vyq6H/GsTq1GS+tloiR2/LJnddcYHtHZ2vdYzDD+fixG
	ZGUN0coZu8fi4/hzvi+t7NN/Br9x0fl0d2knNJ0KhjnQ1cy48fPfhyagkC3xcnmwAbjbQ9CKSsD
	iZUdDB5Z3buFcR4+Wn9hBB5Y+6LPNhHiv/FGbOuLsqBNiFmk95D8vwio7Xi1eoB4K0hmD/Ewu5C
	iwwR7lxD724velnOL4Qpn6gmTDlYgEgb2qJjOTmH6cjIWsGQhNrZ50MI24aBuce7syqPrcigPxY
	0RfzIirlQJslKw2UB8jyn/yBwQfRjsc/UMENSencVvOgIm52HZ4AFuG3QIWhiKX6SmxusO5F9iG
	e//mgdeiOE69oRpX//LM1XU0dQQrIJBEkVUmwpyGMAAp4uZc1X9Klovr+/bcCwRLtb/Js88T7D9
	3RFAw4G58E6OUj0LXWCjlVwJH8lVbmlQI7MVQlKEP/MsKbhJjHM55BSogE1KKKpr1AqRf3EHPKD
	rafgEeyPRXbfu9U39C7hTatM9HQikR9dFxGwY8hOw==
X-Received: by 2002:a05:690c:4:b0:8a3:5310:664 with SMTP id 00721157ae682-8ae39c0903bmr804627b3.41.1790880337475;
        Thu, 01 Oct 2026 11:45:37 -0700 (PDT)
Received: from chris (h106.25.184.173.dynamic.ip.windstream.net. [173.184.25.106])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8ae323ee0dcsm953887b3.17.2026.10.01.11.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 11:45:37 -0700 (PDT)
From: Chris Kelly <hoopyfrood42@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	deren.wu@mediatek.com,
	mingyen.hsieh@mediatek.com,
	lucid_duck@justthetip.ca,
	Chris Kelly <hoopyfrood42@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: mt76: connac3: check headroom before pushing EHT radiotap TLVs
Date: Thu,  1 Oct 2026 14:45:29 -0400
Message-ID: <20261001184529.502048-1-hoopyfrood42@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_connac3_mac_decode_eht_radiotap() pushes the EHT and U-SIG radiotap
TLVs, 64 bytes, in front of the frame without checking that the skb has
room for them. It may not: the rx skb is built over the buffer with
nothing reserved -- mt76u_build_rx_skb() with MT_DRV_RX_DMA_HDR on USB,
mt76_dma_rx_process() with a zero buf_offset on PCIe -- so the only
headroom is the RX descriptor that mt7925_mac_fill_rx() pulls. A
descriptor carrying the P-RXV (group 3) but no C-RXV (group 5) leaves 48
bytes: the EHT TLV takes all of them and the U-SIG push runs past
skb->head.

Seen once on an MT7925 USB adapter in monitor mode, hopping channels:

  skbuff: skb_under_panic: text:ffffffffc16f4a3c len:164 put:16 head:ffff8d4132ca3000 data:ffff8d4132ca2ff0 tail:0x94 end:0xec0 dev:<NULL>
  kernel BUG at net/core/skbuff.c:214!
  RIP: 0010:skb_panic+0x59/0x5b
  Call Trace:
   skb_push.cold+0x14/0x14
   mt76_connac3_mac_radiotap_push_tlv+0x1c/0x80 [mt76_connac_lib]
   mt76_connac3_mac_decode_eht_radiotap+0x7a/0x1d0 [mt76_connac_lib]
   mt7925_queue_rx_skb+0x686/0xde0 [mt7925_common]
   mt76u_process_rx_entry+0x2eb/0x330 [mt76_usb]
   mt76u_rx_worker+0xeb/0x2b0 [mt76_usb]

Leave the EHT fields out of the radiotap header when there is no room
for them; the frame is still delivered with the rest.

Fixes: 97d7ab9f51ec ("wifi: mt76: mt7925: add EHT radiotap support in monitor mode")
Cc: stable@vger.kernel.org
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Chris Kelly <hoopyfrood42@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
index 651fcd4..0ed8ee7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.c
@@ -210,6 +210,17 @@ void mt76_connac3_mac_decode_eht_radiotap(struct sk_buff *skb, __le32 *rxv,
 		      "Should push tlv at the top of mac hdr"))
 		return;
 
+	/* The TLVs are pushed in front of the frame, into its headroom. The
+	 * skb is built over the rx buffer with nothing reserved, on USB and
+	 * PCIe alike, so that headroom is only the RX descriptor just pulled:
+	 * 48 bytes with the P-RXV and no C-RXV, less than the 64 the EHT and
+	 * U-SIG TLVs take, and skb_push() past skb->head is a kernel BUG.
+	 * Leave the EHT fields out then.
+	 */
+	if (skb_headroom(skb) < 2 * sizeof(struct ieee80211_radiotap_tlv) +
+				sizeof(*eht) + sizeof(u32) + sizeof(*usig))
+		return;
+
 	eht = mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOTAP_EHT,
 						 sizeof(*eht) + sizeof(u32));
 	usig = mt76_connac3_mac_radiotap_push_tlv(skb, IEEE80211_RADIOTAP_EHT_USIG,
-- 
2.55.0.windows.3

