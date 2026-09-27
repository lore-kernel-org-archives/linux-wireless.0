Received: from mail-yx2-f31.google.com (mail-yx2-f31.google.com [74.125.224.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9C83C141A
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543073; cv=none; b=HSSCpHI93bBbs/9Xn1PP2qaabetRkDNky9aQvN4zGKm39f7dQgmF9r19bjHKs4Is+urLIUR1QA2k1arIKA2XO06tIVs7VdGDkki2j0JkY8+mOu9bWRrEFTCVn+RGQcO8d7UszudnN7V5lq6O2aPs4MCe9jXUNersSlaCXlcKzdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543073; c=relaxed/simple;
	bh=VpfNrNF3piagZjPyEFHaXrA5vNMje+J3jSem5M36oNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNfCkEZp9UeOXfJJrAhRUuA5V0m8yYcm7vxcFqJqECYn9Cuwcp6c6Q/se+HcJ68qt3gJ0lt7eXj6/CsiqXqGQuCrD7DQz3yRuj0lIMtV5njYKrXajnTcHy+VkB9ZVg37vNsMgJaK9g8aFAYcLVWUGPo+nfBJLEYLhRV+cDC5FiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f31.google.com with SMTP id 00721157ae682-8659af7454eso26110157b3.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543071; x=1791147871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O6iyXs7a1DTzg1r/NsGNyMzWMeL+NXKIZqvuGpnvJ04=;
        b=ZshU420AFnXI+Om1lh6ZgipXbX/R3vGvv0oFS3fy2yrWacPq/zsCktYI7H+A92hLpq
         Y7AnzbBvHRTrWW+v1htGW8iIjrFrdteUeAO/v6hjWtMwB2eIFpy5eRtFLzCNIWPo/Qcw
         IfsyGfRtcuMj0R227Gs6i8RJYVdyLSy26RqJbExilcYbHOHsIbvhXhVQUkfc7Raxjp8K
         Gbok5P2YD9U5Tca8bi/yD66sWa1yNlX/djOGY/22x46QefpXwDGZC3JPOlj1cmPU2a3r
         lM2Rdrk0PgxYEKy7/nq3UHXKZ7MBnr9U/xlBL4b2NEsgiN9WfiIbp+u3hjNcFHYT370k
         33Zw==
X-Gm-Message-State: AFq9FYLFnTJOqz/8ocADOUSqenawFKeHiBI+rl0VLVA01ZUw6/5Eb0Ul
	2jfdyUWDYE8uiG/n9q4+ic+Kj6f9ZR3iaQzjAj8tV6zsQpJh20hUJTBr
X-Gm-Gg: AYBFou1NCYGmp2BpqVhW7gj4GKOo6PTH+I2Ci9Ge6IDro4Q9Gd41OMlrOmhFZxDHgD7
	AMAZ5oSdadz19u+uWnRseKU1qCbUJiGpb6nPWBe4UdFoQMSjedcH8+ShSPtMgDvXtu8oXsxR6H8
	VLIqbovyQbyIPSjLflug03USIb389izn3v4oRhA0+5GGxHM/mMW653QoqvNQbQx7sFJnDADH0u8
	QOfg9NrXHdNmmkHb0cSL4rtg1/Vas5LzScq17aXYAbWfXu51AKjelDcuAiRzGQzx1bjwn02krjQ
	sPVCnyxQ52t6HaTy6xWKZaf5cxYF5R7XMhVd/SA0pwL3JO4CS/p+bJPd0O/ZcUSz3wFliu4t1Vo
	5KjMKleDXdLOIHT+PII7wT43iFx1pEt1MhYCEryoSD6zSsx+fZhyT2/sSWm77R3pG4QjXIs8/wr
	jRlhh6U15C4uyfLtpHVMxGixzPYnoHjc0O9eR5kUob25C5ujVO+SfW/sQonj9bCnZZrI7TBXQ2a
	FbCSi6Dv7SuidzmgzmoDcaUpCf7nFjTNpAEYf+E8Xt/MnkKK4Z1AEo32fQmpqwVEYTWAA==
X-Received: by 2002:a05:690c:698a:b0:8a8:4d6:22be with SMTP id 00721157ae682-8a804d62da0mr47981787b3.15.1790543071036;
        Sun, 27 Sep 2026 14:04:31 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:30 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 22/23] wifi: mt76: mt7925: bound the lifetime of NAN unicast management frames
Date: Sun, 27 Sep 2026 16:03:04 -0500
Message-ID: <20260927210306.737669-23-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

A NAN unicast management frame sent to a peer that has disappeared never
comes back to the host. The frame sits on the gated DW-WTBL queue, the
gate opens at every discovery window and the hardware retransmits, but
the retry budget is re-armed each time the queue is released, so it
never runs out and no TX status is ever generated. The host keeps the
skb in its status table indefinitely, the supplicant waits for a TX
status that does not arrive, and every later management frame on that
queue lines up behind the dead one. In practice a single lost peer stalls
all further NAN handshakes on the interface.

Set MAX_TX_TIME in the TXD for these frames so the hardware bounds them
in time rather than in attempts. When the limit expires the frame is
dropped with the lifetime-expired bit set, the host sees a no-ACK
status, and the queue drains. Forty-six units of 64 TU is about 3 s, six
discovery windows, which is beyond the 2 s NDP handshake deadline so a
frame that still has a chance to be delivered is never cut short.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    | 12 +++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index f19d0451f373..75d2081b0920 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -815,8 +815,18 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		struct ieee80211_hdr *nan_hdr = (struct ieee80211_hdr *)skb->data;
 
 		if (ieee80211_is_mgmt(nan_hdr->frame_control) &&
-		    !is_multicast_ether_addr(nan_hdr->addr1))
+		    !is_multicast_ether_addr(nan_hdr->addr1)) {
 			val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, 31);
+
+			/* The retry budget alone never finalises a frame whose
+			 * peer has gone: the DW-WTBL gate re-arms it every DW,
+			 * so firmware holds the frame indefinitely and the host
+			 * never gets a TX status. Bound it in time instead -
+			 * about six DWs, beyond the 2 s handshake deadline.
+			 */
+			txwi[2] |= cpu_to_le32(FIELD_PREP(MT_TXD2_MAX_TX_TIME,
+							  NAN_MGMT_MAX_TX_TIME));
+		}
 	}
 
 	if (key)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 33782d9ba9ed..bc335740638b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -26,6 +26,9 @@
 #define MT7925_SKU_MAX_DELTA_IDX	MT7925_SKU_RATE_NUM
 #define MT7925_SKU_TABLE_SIZE		(MT7925_SKU_RATE_NUM + 1)
 
+/* NAN unicast mgmt TXD MAX_TX_TIME, units of 64 TU: 46 is about 3 s */
+#define NAN_MGMT_MAX_TX_TIME		46
+
 #define MCU_UNI_EVENT_ROC  0x27
 
 #define HIF_TRAFFIC_IDLE 0x2
-- 
2.43.0

