Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC87B3EB7F4
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 23:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982648; cv=none; b=fi/JwdEgTS67CgbhuLd6zQ+gGgbzVJO2++nU7w8GLIIA2rnWjIpPHLoJxQbZDEDCQzAP9Azjzap1WoJtYnESyEFR8MSSpLUiHB9Ocz9vUSF+9fe4jQrNvjzz1CQtp5GiNJMOQl7+KZe6FBWt1Sz3QaJDD3nxyLJBtswnG3govg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982648; c=relaxed/simple;
	bh=hPnGfVE/ERhFq2pn4wQsxIv0Cq0Ccgf6d+h71VG44k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFugC64MvZhSVpGDaMbwjqG1+uE55ERKgqUOSvBochMJb9ENHbA201t5s8vacH1XMO+lRG7II9ZcA3pNu9L9FRgoVrs84YKx2IzttyXsAooWjPVtU8hCnk0HXlu8ZEyjjlgDEIi4c1a2pW5hhoNcGF1S1IzQRXrniFR+EzbsAZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfgPwjHH; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfgPwjHH"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b059eae96so326980f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 16:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790982645; x=1791587445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lioJcKUCBYULewz3rYkxIVZrrHZaGImjRN4lkx+YRX0=;
        b=MfgPwjHHF2B7ArXvMea39d1iDFosj4mu5c3wZJXAtaAIKmjQqXIBfqNoOhNlboVawZ
         AUTUPTygcnbal9Myo2f3tAeORtTDsmCyiCskk62O8NrB+7lM5k4WOCvOFb0dpORUowyq
         ytdcuoDML9TykaB24q1dGjaZwNtJlE63+yFi7Na/LU125vxalHzeWSEGIft520pf5pvU
         cOw2sL9R5ydArloHuV1ii2qRQzQoJiAAxboPePHRtLJ0abtu4yOF2WRLIUr5rWbJfPEv
         TWFbXdT9hgHL+Wv7sOIz3FIjaFJmFvA6XOjdYTIsHV4U/NCInDeo/5g+Lry/TLP3Y6dA
         Noiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790982645; x=1791587445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lioJcKUCBYULewz3rYkxIVZrrHZaGImjRN4lkx+YRX0=;
        b=o5doZ/W6b6aAfAwrlJ0v9sNwJZH/jiUoTGTD2gvBwO9VcNKM9rR5VcVRfUu+HQGpEE
         gN2cc3FRq/e/MTn69ldJwPhStuvG7eVqi/pul9oE9SclTY6DeYlY5hJgykcBMvGiOvMV
         p58fGAz1Lnc8aPxPUzlAJvTd8rF4mClj/ZsA9X+BFaa//QzvC4JnOZTieAxqQqfyLU/Y
         cM6CxgBj9XA+gVCJxoP1mo5PzikyF8qVyh6R1SljuYO0WPwIv4nFGLcFU8JP7FGoj2NR
         BKqKZgahEXrFvG0X+LB/Fo44luSsnB+JU6EH5qybYseDGH5qyjMi2M9uwgzh/V8CN1dj
         JtZw==
X-Gm-Message-State: AFq9FYIixBf9JomzGz8hhSSa3f3lO/vdfaRoRKI/yTE3gTuJU6+bFEj4
	te54DZL4wEyDpXtszs8P1iS6V/EoERamTdYVZCi3kIf0UkiCpLcB9yIX
X-Gm-Gg: AYBFou0b10DEoibSQVA7Lfy/h/nLJJVCr4FOgHhb+EuGyXVWzLgQMtOik3OydjTT06A
	TibvgXK8E+ZNPgmODueCvBsYSp/ySYXKUYLlCkkZFL8qpERU2FxwqhISpxlpVbM/5peqMAR5Q2E
	9xn5T2ztgAuqT9X1eTN+690otRSperggRNsJ95/WXBv4jWM0+tEOrd3mmZfNm1dSvBVL6hpmSCZ
	CNo2TXdT7+9raSVJu88mwN6pQ8r1TELtOdtlFcr90Lcie9qGW/PZOFohlvkOkVFrTQDXsAi/QCL
	4TnMyd/8oo22DdnrfgI5G8u/mXI1lz4SsGZBPdC87j7VnuPfYZ00PD5uQXmYanfOH8qLSmX6ehS
	AeXj2GM9N357V1dwEoy3/0qfILfZJo9PSqq64tfbWUUrmZ6sOAY5q8lo5NldT4FjByhfefDj5ZR
	76HOUzhC0xP62ErlPjnswxizZmePQENT0/CqckZ39/0kcsv2YNAr3zgbcl5cp9RCnbn5HWTbyQb
	8YFZo5cKYMc4cvp1sKa8/9Bs1KthWdRs2BdScUPWy0DJIzbZfewAqbt3Z7zfHUiekP8dZZHloWc
	luF/Og1gTdJfhz8hjqd+C+VVPaxMWyLB
X-Received: by 2002:a5d:5f8e:0:b0:487:bcc:2c08 with SMTP id ffacd0b85a97d-48b1271cd1dmr7264130f8f.14.1790982644873;
        Fri, 02 Oct 2026 16:10:44 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fab11sm8372266f8f.16.2026.10.02.16.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:10:44 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Subject: [PATCH rtw-next 1/2] wifi: rtw88: pci: wake the TX queues when the rings are reset
Date: Sat,  3 Oct 2026 02:10:12 +0300
Message-ID: <20261002231013.11792-2-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a queue stopped by the PCI TX ring-full path, ring->queue_stopped
is normally cleared and the stop reason released only from the
completion loop in rtw_pci_tx_isr(). When the rings are reset the
pending descriptors are dropped and their skbs are freed directly by
rtw_pci_free_tx_ring_skbs(), so that loop never runs for them. The flag
and the stop reason both survive the reset, and because the ring is now
empty no completion will ever arrive to clear them. Any queue stopped
that way stays stopped.

This makes ieee80211_restart_hw() unable to recover a device that
stopped a queue before the restart, which is the opposite of what the
recovery is for.

Reproduced on an RTL8821CE by pausing TX in hardware, which freezes the
read index while the driver keeps submitting, the same shape the chip
shows when it wedges on its own:

    # echo "522 f 1" > /sys/kernel/debug/ieee80211/phy0/rtw88/write_reg
    # ... push traffic until the ring fills ...
    BE 0x3a8: 0x0081007f, avail_desc() 1, BE queue stop reason 0x1

    # (call rtw_fw_recovery() from a debug build)
    firmware crash, start reset and recover
    ieee80211 phy1: Hardware restart was requested
    wlan0: associated

    REG_TXPAUSE 0x00, BE 0x3a8: 0x00000000, ring empty
    BE queue stop reason 0x1, 100% packet loss, no recovery in 90 s

The station reassociated twice during those 90 s, so the link was fine;
only the queue was still stopped. With this patch the same sequence
clears the stop reason and traffic returns within 2 s.

Record the queue mappings this path stops and release them both from
the completion loop and when the reset empties the ring. It has to be a
set rather than one value: the stop runs after every submission that
leaves fewer than two descriptors, rtw_pci_tx_write_data() still
accepts a frame while one is left, and rtw_tx_queue_mapping() places
management frames on the MGMT ring and multicast on HI0 whatever their
skb queue mapping is, so one ring can stop two different queues before
it is emptied. Keeping only the last one would leave the other stopped
for good.

Recording the mappings also limits the wake to the queues this
ring-full path actually stopped, instead of waking every mac80211
queue.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 45 ++++++++++++++++++++----
 drivers/net/wireless/realtek/rtw88/pci.h |  1 +
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f..ff751bf 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -473,9 +473,41 @@ static void rtw_pci_reset_buf_desc(struct rtw_dev *rtwdev)
 				BIT_CLR_H2CQ_HOST_IDX | BIT_CLR_H2CQ_HW_IDX);
 }
 
+static void rtw_pci_wake_stopped_queues(struct rtw_dev *rtwdev,
+					struct rtw_pci_tx_ring *ring)
+{
+	unsigned long q;
+
+	for_each_set_bit(q, &ring->stopped_queues, rtwdev->hw->queues)
+		ieee80211_wake_queue(rtwdev->hw, q);
+
+	ring->stopped_queues = 0;
+	ring->queue_stopped = false;
+}
+
 static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct rtw_pci_tx_ring *ring;
+	enum rtw_tx_queue_type queue;
+
 	rtw_pci_reset_buf_desc(rtwdev);
+
+	/*
+	 * The rings are empty again, so nothing is left whose completion
+	 * could reach the wake in rtw_pci_tx_isr(). Release the queues this
+	 * path stopped - the stop reasons it set are cleared nowhere else,
+	 * and over an empty ring no completion will ever arrive to clear
+	 * them.
+	 */
+	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
+		ring = &rtwpci->tx_rings[queue];
+
+		if (!ring->queue_stopped)
+			continue;
+
+		rtw_pci_wake_stopped_queues(rtwdev, ring);
+	}
 }
 
 static void rtw_pci_enable_interrupt(struct rtw_dev *rtwdev,
@@ -930,7 +962,10 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
 	ring = &rtwpci->tx_rings[queue];
 	spin_lock_bh(&rtwpci->irq_lock);
 	if (avail_desc(ring->r.wp, ring->r.rp, ring->r.len) < 2) {
-		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
+		u16 q_map = skb_get_queue_mapping(skb);
+
+		ieee80211_stop_queue(rtwdev->hw, q_map);
+		set_bit(q_map, &ring->stopped_queues);
 		ring->queue_stopped = true;
 	}
 	spin_unlock_bh(&rtwpci->irq_lock);
@@ -949,7 +984,6 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	u32 count;
 	u32 bd_idx_addr;
 	u32 bd_idx, cur_rp, rp_idx;
-	u16 q_map;
 
 	ring = &rtwpci->tx_rings[hw_queue];
 
@@ -981,11 +1015,8 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		}
 
 		if (ring->queue_stopped &&
-		    avail_desc(ring->r.wp, rp_idx, ring->r.len) > 4) {
-			q_map = skb_get_queue_mapping(skb);
-			ieee80211_wake_queue(hw, q_map);
-			ring->queue_stopped = false;
-		}
+		    avail_desc(ring->r.wp, rp_idx, ring->r.len) > 4)
+			rtw_pci_wake_stopped_queues(rtwdev, ring);
 
 		if (++rp_idx >= ring->r.len)
 			rp_idx = 0;
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 8ffdea1..04630d1 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -188,6 +188,7 @@ struct rtw_pci_tx_ring {
 	struct rtw_pci_ring r;
 	struct sk_buff_head queue;
 	bool queue_stopped;
+	unsigned long stopped_queues;
 };
 
 struct rtw_pci_rx_buffer_desc {
-- 
2.55.0

