Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214656AD4
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791958965; cv=none; b=AWthMXXeql5+38fw1bGJztWC+QXFiHCg4IA0HZOkUJwn4rdstqoz8TcpW5e9zkjvgW4ptyFXFMo0y2kv6shOTeteGg8qUpASwKIv4szD7ns1VFiGzJHJ1/aDgjQGpRtrnbMkfUM3YBZadHgfyqleium12q8Ob5qIidOtuID6xmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791958965; c=relaxed/simple;
	bh=do92hy/gYZbdz5nneCsyDYR1q7QVkrDjd6qDQep//8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udWW+BUBDBuQ/GCv6nHRgNenOlU+s0/CWr33ExLxSJUPbUv6vZSXUTxdcF4rX/GsY8Z7wlbUbd23F5nkABsAB/GEzetRPOl782y6AV6+9geshdsAz96a/BuEAdyMyIDTMFhVJhDqk8qYqI+wYuemnE1kyN+I5+Aq7nVp0HWTjgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUBsaLay; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUBsaLay"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e94a057d9eso2447978e0c.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 23:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791958963; x=1792563763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bNeVzBoSGqY6hcBV8+qLl98g4CfL7+apV6kO7AyiGhc=;
        b=dUBsaLayT3Y1T0b5xzUIlLwPec5GTQv2pnG/hKNlj2MAWb/EOZzfvKPiA0PxjemR+Y
         aiGDykSl2GImGC6v7Y2hb5UChQMq63Wu9IQ+4eo9HkJoyAEeSn12vBDfhOzwQMynW920
         1TY3dZ/6gw9huD06Kd4vb9gfvuAgkPYyxFMlwUULmTHmBfDWCVDFCd0mfSc5qCKnRIij
         5UVX5jFpw3NJ90J6Wx7A9y4I7DgiSHcVJtr5L6hWKZ0MeMPsxZLOJi+DQunsTf6sUXl9
         2b+lyjKfn/r4Id+kkFrFABStI0sVmHJdZkuzGCtgMYQscP/sK4OuvyUizUbUXgYmUmKM
         LhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791958963; x=1792563763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bNeVzBoSGqY6hcBV8+qLl98g4CfL7+apV6kO7AyiGhc=;
        b=LbqaBcT6QUMI28GtekgKzZO1oqlO0FFiaJB88K0NGZrp6sNE9aBel+DAikX1PBphXi
         0da1/VfAwDcubFys27jPwtxC9mTkjMXWdyEQOkFjhN6biskq7bxGgYn4sIez9TCxAWK9
         NDFKxg76Pv0YVNmqcB9qyqu6B4WzuOKd3+P1o7+wIQ58kzzsX3uk+4OWZ6VrQRa6mdw7
         zsizVLYQ01n59V6nCPOnzuSiX4pDanXn5l0tduNdur4wbhhQMgJllYVUj4dNRj1ADr+G
         DP8j1WtndKvxYt1xZHx/nrsfW4bQUtocu076Vnmyhqv1/5tr9Q541it3HlYG3I2b3P38
         13yg==
X-Forwarded-Encrypted: i=1; AKwUvBw3rF+V05ePXeB+UDidhB0GN79FL6at8JQMaEKhFYlrnplnyg4mkK4S20pDYDY5aVCtCPjgALs9IKMxF8sPXg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL2ZcikBDDZtInZmxiAaysIgM6svAdqCojgVQp6uyzQ9cPnUiuA
	enDXh9uwWrXHK4+RTFLa/NsKVZJx+mO9T186U+S6IdaAJwxJQzVRlFyO
X-Gm-Gg: AYBFou1/xLt37o3BD3DzVE7zBPtN2+PRFTWbHAs8tUm0Kqtv9HlHAHMPxDzL+eBddp2
	tyLHEtJxxVDJUs3icNynaittKu+EBZiw77VDyxzEi43EwjEWL2oSAI3bRC3OCdf1WXJV/K2+OIq
	qQ3W4tQ5XhR5080UDv+ngAQR8EgaPLFfh/Z77Z95WcMcL+5aryXaocHoY68N1va8zLZUr54sGK1
	aNHkMTzNmkV7wy7yKtQLvEHYyPQbyJrTqFyIrHT1ONgIzwglG7wfnX5MXY7BKUOtHLIW8xtRHmb
	uEZ6nFsYgdehRCB2JPOgG0nGCpOYHR9eTwSRA5U00UbVo4dB8X7kTPo61R09mqQohXYnvitf3cx
	KIFyqtWKR+O2BT+EKbXu7OcvrwZNWUeB7L2MKc4uCAfr120w2SS5EhY2xrLhDO3ZxoVTDJD8d2u
	m5SiM7Bd/vapkJidLsMu3rJdIa36GKzpDnBYyV8vmn7KxD5E3x0h2uFwHzSI6XqFEmQKYEAa05n
	BM6V96BkJXSlCcZdapRIjAilFF1zsj/fP+/aYrRIMKR
X-Received: by 2002:a05:6122:181e:b0:5de:655e:404e with SMTP id 71dfb90a1353d-5e91f4d2596mr5521407e0c.15.1791958962957;
        Tue, 13 Oct 2026 23:22:42 -0700 (PDT)
Received: from DESKTOP-1E7V4GR.lan ([190.177.140.173])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e93683455csm7783845e0c.13.2026.10.13.23.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 23:22:42 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: nbd@nbd.name
Cc: lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cristian Papa <pcristian292@gmail.com>
Subject: [PATCH] wifi: mt76: mt7603: discard power-save loopbacks after wakeup
Date: Wed, 14 Oct 2026 03:22:25 -0300
Message-ID: <20261014062225.9238-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A station wakeup drains its power-save queue once, while frames
redirected by the PSE can still be waiting on the MCU RX ring. Processing
those loopbacks after the wakeup queues them for an already awake station
and sets the driver's buffered indication again. The stale frames remain
queued until another service period or sleep/wake transition drains them.

Check ps_sleeping under ps_lock before buffering a loopback, and publish
the buffered indication under the same lock. The wakeup's state change
and queue drain use that lock too, so late frames cannot repopulate the
queue or leave a stale buffered indication after the wakeup.

Discard late frames rather than retransmitting their old sequence and
packet numbers after newer traffic or a wakeup BAR. This loses the late
frame; it does not recover delivery. Use the station's sleep state, not
the temporary hardware PS bypass used during U-APSD service periods.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
Based on Linux master 4056b3c9d3c92ea45955641dbafeb9b960e146ef.
The ps_sleeping field comes from mt76 commit 276db249c20a, corresponding
to Linux commit 636a883e2fee ("wifi: mt76: mt7603: restore hardware PS
buffering after a service period"). Older trees need that prerequisite.

Testing: extracted C functions from the unmodified base reproduce both a
late queue insertion and a buffered-notification race in a host harness.
The candidate passes these cases and controls for sleeping U-APSD clients,
frame formats, queue limit and malformed frames under ASan/UBSan. MMIO,
mac80211 services and locks are modeled. The changed source builds as a
MIPS object with W=1 and -Werror against Linux 6.18.44/backports 7.2.

Tested on MT7603E (TP-Link Archer XR500v, mt76 backported to Linux
6.18.44): a phone on the 2.4 GHz AP went through three 60 s screen-off/wake
cycles with a 1 Hz ping from the AP running throughout (about 8 minutes).
All 474 pings were answered, the phone never reassociated, and there were
no resets or kernel warnings. This exercises the power-save path under
traffic but does not demonstrate the late-loopback race itself, since no
counter records discarded late frames.

AI assistance: Codex reviewed the late-loopback path, proposed the change,
prepared the patch text, and implemented/ran host regression checks after
being asked to review pending power-save fixes and their upstream fit.

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -72,7 +72,6 @@
 	}
 
 	skb->priority = tid;
-	ieee80211_sta_set_buffered(sta, tid, true);
 
 	val = le32_to_cpu(txd[0]);
 	val &= ~(MT_TXD0_P_IDX | MT_TXD0_Q_IDX);
@@ -80,6 +79,13 @@
 	txd[0] = cpu_to_le32(val);
 
 	spin_lock_bh(&dev->ps_lock);
+	/* The wake-up may have drained psq before this loopback arrived. */
+	if (!msta->ps_sleeping) {
+		spin_unlock_bh(&dev->ps_lock);
+		goto free;
+	}
+
+	ieee80211_sta_set_buffered(sta, tid, true);
 	__skb_queue_tail(&msta->psq, skb);
 	if (skb_queue_len(&msta->psq) >= 64) {
 		skb = __skb_dequeue(&msta->psq);
