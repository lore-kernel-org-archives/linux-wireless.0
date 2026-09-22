Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBF14EFFB3
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114921; cv=none; b=u9H6Ut/q+bFr/YXwIjLFyv+qhEoK5lDvgDSWyQfr0EbmNp5jnwgvLWK1qjaNmEzVDAFGDbuHLMpT22GRARVA2fSMfmeaecdTrxnRf2uYfYAmWOLMYmpOn2gFX8yvMMpmjD5vSS/7Yky7BjBqT7otJtqL0xk1rYZ7AYuXksCwSdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114921; c=relaxed/simple;
	bh=dWLdwJb8d9camCoMsbYnnFHB9HZwJBPNxGr8zbzzxJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z3QoOy0xJCN5a3BU/LuyvxtFC0iVd5lb+jMhP3McSit0epNrM0HV0nKZ+1YB68zKPHBEv5dSb//Ks2qrqIolgsbkyURBcCsalHeOTFIYduxyaiem37s0De+HN+STcMTuLtWjgyJVE37XtSkC5M11eKbcWLJKiTzXvOdtVt1Qjbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RrlCuqHB; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RrlCuqHB"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-7a03fe69236so150747137.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790114910; x=1790719710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HH7Mx1ASGQGZXIkAoii0TJeZ9j5LKy/zgHlKkIF1avg=;
        b=RrlCuqHBpQDsJ3mhwqCsnUHASIbcb1bzTAGxICMTner549N4mtHQMopHUc3eKbEQRk
         aHTtE9EAo1A04gfleY/PJLnFQyr60NsVilq2CYhIKFh+rDKPspYGjbApEvevRslb7Uwo
         bYhulDpC4xCKr6IsgHJLMwbyI7Gn9/2hPrRHmGw+6/0V3u8L817QI0zfcODnPoLb792w
         XK4DGYG5yD8isHlICS2IA5UdsGi0NFOE1C1LzMmYkmXqQhxD0lSc2EFQebwT+Q37MkDU
         JWPZU7Cs3ICpk5eGqgn7D0bQrt3HiaL/2zLUyj7B+7mNulUFwAU2nEJrN/wHrSqACt7k
         6f4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790114910; x=1790719710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HH7Mx1ASGQGZXIkAoii0TJeZ9j5LKy/zgHlKkIF1avg=;
        b=qO/TcZoVCc1zYJT/ZSTOsjKVYoRa4QReaU+pyPlwEIr6vJ/7qNsCXsaMbGDQxkb3lh
         I/l6+7fDo2ork5ANd4hjrIjQhURzMbH2aGUEPhBC4WUgwNtPRt4Pu27lMk+xBDfM0a90
         urfNlhxRcVnVQVZ91hufhlqJ8rouPqnpIxkMg5VBrcz9yP5nmOAJ1/8451LroLNleRv7
         kwoKICkSzAOQ0HtNLwxXNgnvNMXqYRbyBVaS43iwzRs2naExZzRLYpT7awv8OfC8VT9w
         6ZHMSO7hurhqEETnlfKGynFQbsi4UzcY1qRdVtq76ayyLNnQGQhTEXwI1U0GMAC+jfrp
         d7Xw==
X-Gm-Message-State: AFuF++n6VF9+x7xKIgLiybW0dCmml1kyyenJRmHU8hDTMzvATHM8XqWm
	06fursw/Ku5tHODZf1uHcz41QYtaUj86hOCpJ4UnxatsriNEoU2yHnDPx6iK8myv
X-Gm-Gg: AYBFou3F2d0B/RullKTS9XOQ3YNpJ7L+MLDhNjIz+MRFKgGzriNvKEiZH7wbDOnxn4D
	wzV4xzOdHI5t8HSevhLpsj8mTF74uC/lS6IvZ92xERBgzUnL4Hc7KwuUumvzrhWiAuugznrSyHC
	gm6e+6qvWd+GjEmhNjPbz4/v3/QdR8EyXRXS0Eq8aOhru8ssQDyavM4IMdo45so0Tptj6ViWaEN
	pAD4vbIDjLZ13k4YqGNkb5rIRWNoHb4z+ejIkGtpdcs6SCduS92U1C8h36C448PYvndqrY63I1g
	a4VrHFXS4nhOsYnrmPkDSc4/2Wx9ggNV38rz4d2DQtw6lFR93f97ljkmNYndKShH1enfHIMh5DW
	G+eCyNiOrdW45Kg1FOcLo7jMoXHXeBK+iMHpi0Oa9sWEpSHHScPVIpdS+MFTlZUGPGY3voMOmAH
	2UaPFewqK6rtRxfIcsgZCvQcf4k/2WDujp5ucwzywjiyeOXTjBa6ByYVOJ9uhD5LmmrVmdAMfie
	Vc4atzDkAEP81hDQrlrBQF+ja1JVteT8drDNakz6jL14kbUCUwlsl5X35OHu2eeesKzXc7QuQ==
X-Received: by 2002:a05:6102:5711:b0:7a6:a59e:777e with SMTP id ada2fe7eead31-7ac1c78dc3cmr821363137.16.1790114909612;
        Tue, 22 Sep 2026 15:08:29 -0700 (PDT)
Received: from localhost.localdomain (host61.181-1-22.telecom.net.ar. [181.1.22.61])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-985169f579bsm1362564241.3.2026.09.22.15.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:08:29 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt7603: don't drop short frames looped back on PS entry
Date: Tue, 22 Sep 2026 19:08:14 -0300
Message-ID: <20260922220814.15070-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a station enters power save, mt7603 has the PSE redirect the frames
still queued for it back to the host, and mt7603_rx_loopback_skb() parks
them until the station wakes up.

The handler rejects every frame shorter than a four-address header
(sizeof(struct ieee80211_hdr), 30 bytes) before looking at it. A
BlockAck request is 20 bytes and a QoS-Null 26, so both are freed
without a trace. Since commit b473c0e47f04 ("wifi: mt76: mt7603: fix tx
queue of loopback packets"), a BAR would also be freed later as a frame
that is not a bufferable MMPDU, although mac80211 buffers BARs for a
sleeping station like any other unicast frame.

mac80211 queues the BAR with IEEE80211_TX_CTL_REQ_TX_STATUS, so it only
learns about the loss when the tx status times out, and the recipient
keeps waiting on its reorder window until then.

Check the length against the header length of the actual frame, and
park a BlockAck request on the queue of its TID, behind the data frames
it refers to.

Found on a TP-Link Archer XR500v (MT7603E) with a client whose Bluetooth
coexistence toggles PM every ~15 ms under load. To test the change on
its own, a temporary debugfs switch flipped between the old and the new
checks every 30 seconds during a bidirectional TCP test, with counters
on the loop-back path and on the tx status of BARs. With the old check,
all 92 BARs that came back were freed, and 91 of the 544 BARs queued in
those phases never got a tx status from the hardware. With this change,
all 129 BARs that came back were parked and sent again, and 11 of 411
got no tx status. Throughput was the same with both checks.

Fixes: e004b7006600 ("mt76: mt7603: notify mac80211 about buffered frames in ps queue")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
Testing: the numbers above come from mt76 as packaged by OpenWrt
(2026.07.01, 59676919) on kernel 6.18, with the temporary switch and
counters added (not part of this patch; samples straddling a switch left
out). Its mt7603_rx_loopback_skb() differs from wireless-next only in
where skb->priority is set. The change also runs on the same device as
part of a larger local series, including a 30 minute soak. Build-tested
on mt76.git at be5ce79105, whose mt7603/dma.c is identical to
wireless-next.

Tools: an AI coding assistant (Claude Opus 5.5 in Claude Code) wrote
the instrumentation, analyzed the captures, and drafted this fix and
changelog; the tests ran on my device.

 .../net/wireless/mediatek/mt76/mt7603/dma.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 477a9b7a8..491c8c937 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -34,7 +34,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	int idx;
 	u32 val;
 
-	if (skb->len < MT_TXD_SIZE + sizeof(struct ieee80211_hdr))
+	if (skb->len < MT_TXD_SIZE + 2)
 		goto free;
 
 	val = le32_to_cpu(txd[1]);
@@ -52,6 +52,9 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	sta = container_of(priv, struct ieee80211_sta, drv_priv);
 	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
 
+	if (skb->len < MT_TXD_SIZE + ieee80211_hdrlen(hdr->frame_control))
+		goto free;
+
 	hwq = wmm_queue_map[IEEE80211_AC_BE];
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		tid = *ieee80211_get_qos_ctl(hdr) &
@@ -62,6 +65,19 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	} else if (ieee80211_is_data(hdr->frame_control)) {
 		skb_set_queue_mapping(skb, IEEE80211_AC_BE);
 		hwq = wmm_queue_map[IEEE80211_AC_BE];
+	} else if (ieee80211_is_back_req(hdr->frame_control)) {
+		struct ieee80211_bar *bar = (struct ieee80211_bar *)hdr;
+
+		if (skb->len < MT_TXD_SIZE + sizeof(*bar))
+			goto free;
+
+		tid = (le16_to_cpu(bar->control) &
+		       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
+		      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
+		tid &= IEEE80211_QOS_CTL_TAG1D_MASK;
+		qid = tid_to_ac[tid];
+		hwq = wmm_queue_map[qid];
+		skb_set_queue_mapping(skb, qid);
 	} else {
 		skb_pull(skb, MT_TXD_SIZE);
 		if (!ieee80211_is_bufferable_mmpdu(skb))
-- 
2.47.3

