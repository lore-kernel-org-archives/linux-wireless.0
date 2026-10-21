Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577619;
	b=ld6k4jyOLCB669NRqtmYR7C3/83Inut5HyEeOt65ppHH4Q+rvZgFdekWXbvjG92FeqH4
	 kLEYbzTNNN1BcV1CMRKiyHbK0trHIOhALy0ojJEEoinFNqDZGtRXvmLH5KsNAWwlmtD5X
	 CEeNyBTIpZCsdOjPjWhvL6WlObb2Ra28iOO07dsQsNciAYwK7TM7gcLhmX6SNzdSjRNoy
	 j8sOlKx2fjHSnhdXtj4ShSJ4kd12hAt/oeguh5LbbKWgw/wz20mZ7T1ZMdIACqwqhE/Kx
	 VNf5TwFdWHweQWQRMYkD4CwEb+Z9cPd3AQ9VVULxN/kla0FNlOOh7FnZaJDiIrrLfgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XfVE0hbb4GW27nGRfsqE2etlUF0AV1nyBAOQ1sm5WW8=;
	b=q09Qz6ys836bGKxujEKVfGu4fw9U5ph9miJi7eUv98tVYq5OusJOwUaC6L+uc8ZjZSJo
	 uFZbdXtf6vIjGqebAbHPDQlB+w70cnj4ou8bD1YSBHAl6y5DN1lehRSnDX4M/xfipLV1X
	 52dSsVu16rZfE/qndTdTL7yvjPk/zvrHBHsUkUDRvQNUM6N7H1HTqT1mGyYI9YS4IzZlb
	 R2V4DJOp+lNFJCA1Ub3Vd2kBLOK43VVZu4ckp5L48i3LfDZN3yh/ZFOmdZhsHyyuQN2fR
	 UHCN2Ejm5RpCsB/yhtR/zFX9EzpRAtDxDZCZx6TNrA+SRi9MbLx/NiMN8I5nXzaNDfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qLbNoJH7;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155CC606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:13:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 155CC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qLbNoJH7
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so2996575e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792577617; x=1793182417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XfVE0hbb4GW27nGRfsqE2etlUF0AV1nyBAOQ1sm5WW8=;
        b=qLbNoJH761XEyD0OcimM+kAc5lJyrQkDumpg028gI3IwdNbDZSo5I1a0ILDMErwCg0
         vxAPb0Di9uhwg7MrKh022qYQ0Nybacr1eVOnRG/KchTRQU3OJ8G8PbpwkdkycJMfPen7
         spT0cbzYq21nQqKGoCxJqz1FnZ34x6oOYi3IQZLQSJvllTu4MduDc8JbCNsEmOQaNWAJ
         14Au1U2EpPX7bcRJMr9MK+UlrTjAx+Im7h0DEtOo1KuKTb3+cXOKG/1n6ENIqhSCkV53
         bWBzOMfvKjr3fSbXQFatRcqe0daN2lYEgxgucJItEAU/bj5r23cMZBt1llFMFxEkW5hU
         KKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792577617; x=1793182417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XfVE0hbb4GW27nGRfsqE2etlUF0AV1nyBAOQ1sm5WW8=;
        b=g820anpOl67OnpghaRQt0jrY5UZS6/De6JOjfUllJbaAkIdEKYGLXzWvGe9/XILAMF
         ysgl1ZhBLLkvjd+5IUczVs5jQ4zHnQ1P0oSgo7Nzq5FrbSFCIlx7PxxP7M4ryAV0Wkzu
         7t7oeSPjH/EWVZ2lkMq/m+7xtDRSf0IVrDVIDXyht2Pj2I2W+8cHrmMgsdRA4spCI4RJ
         2isnfxcXpjYkTT7DEqbEfo7ZCp0EN/9pG47DhhHFPpXU5fQ/MPO8fR2Wv2qQV8h+nzV3
         U3lGTMeJlKiC3xsjAgcKmYvsKMoC2Xj0RVLyNJ11rx8a/VwOJCYDCSxBIxAagWZE7gHA
         BTBA==
X-Gm-Message-State: AFq9FYLVf/yFn9KRkSjpTb7XvYEUAm6G/BwtUkRnK85rghOCnwSJUKHn
	plNxCV6l4aq+NqIHkX0oE9wYbLxaI0WZWN9xy0/YM3i8b9Q3/x+pWycA8u4lzA==
X-Gm-Gg: AYBFou1xiq6sBsiIPOA1xak7buLX+sFckb4a69fksl8uBPM5MOncmE653mFs0UMgk27
	vDZ2TAmiElQhuUMOCpMd5AHuKHkz+B0397xMZ+sDRx4o6eJ8CCXjr2ZDctAWC0VeRORFFuLdJpm
	AsA5L1uq0E+bYp/bdOQ3J6TUL4Oxd+lOGWbaS21UOLMQv9FZL5Aro7HjM/HvBbInkGQuYlrZVqA
	ZXl1ZOth7xnvuKS/5MJMviAwXh43eGnwGVEaKZIFOzDjisv+g0ImYyP2YsNPf5gJPmqPVgFYbvF
	akvS1tEl4oWUZai+37V8AkIJlG1YR0AeWJy33zxV3UfZGSelHj6sUmHXeHpkHPb46WBCwGiRQHW
	qJRodfJnxpwb9izel/lPJkp2XVJom0cAZBIshBfIUN6xTlQnMfSaFzPjT6ST9wcvdKcXu7UnKw1
	raDMHEI3wfr5bI5RAPOJLlwnMUM38B/DTyBI7HYE5+VvoFZiUqtslf6xSwSLV6TFm8Tlmdgm+0j
	yXTKFxhSwLdpDIV53rkG4qpMSDA8xQvtf8jsk3zQpJyRZQU3OpbcLpRRsShrDVB+55XCyHtt/hT
	U7rJkfn/8gFBG2Vj3AZ0PxtssEhWplyVPPWO9KU0ygfeVWogS+fetZsA6iQ0V3mKfiJmEkDwhEX
	vQw==
X-Received: by 2002:a05:600d:4446:20b0:4a1:dfd4:9429 with SMTP id 5b1f17b1804b1-4a1fdd3a206mr23422485e9.31.1792577617090;
        Wed, 21 Oct 2026 03:13:37 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2584afe1sm4869467f8f.56.2026.10.21.03.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 03:13:36 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com
Subject: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after restart_hw and interface up
Date: Wed, 21 Oct 2026 13:13:15 +0300
Message-ID: <20261021101315.1974894-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
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

When a TX ring fills, rtw_pci_tx_write() stops the mac80211 queue and
records it in ring->queue_stopped. The completion loop in
rtw_pci_tx_isr() is what clears them, and it needs a descriptor to
complete. If the device goes down first, rtw_pci_dma_release() rewinds
the indices and frees what was in flight, so nothing is left that
could. ieee80211_reconfig() does not help either: it wakes only
IEEE80211_QUEUE_STOP_REASON_SUSPEND, and an interface down/up does not
reach it at all. TX then stays dead although the device came back.

Reset that state where the device starts, which both
ieee80211_restart_hw() and an interface down/up reach through
rtw_core_start(). Wake only when a ring was recorded as stopped:
mac80211 keeps a single non-refcounted DRIVER stop per queue, so an
unconditional wake here would also release the stop that
rtw_hw_scan_start() takes before it reaches rtw_pci_start() from idle.

Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
---
v4:
 - reset the flags and wake from rtw_pci_start() instead of
   rtw_reconfig_complete(), so an interface down/up is covered as well
   (Ping-Ke Shih)
 - name restart_hw in the subject (Ping-Ke Shih)

v3: wake from rtw_reconfig_complete() on RECONFIG_TYPE_RESTART
v2: wake from rtw_pci_reset_trx_ring(), gated on ring->queue_stopped
v1: https://lore.kernel.org/linux-wireless/20261002231013.11792-1-abdurrahmankaradag19@gmail.com/

 drivers/net/wireless/realtek/rtw88/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f..fd84ace 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -571,12 +571,20 @@ static void rtw_pci_napi_stop(struct rtw_dev *rtwdev)
 static int rtw_pci_start(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	enum rtw_tx_queue_type queue;
+	bool wake = false;
 
 	rtw_pci_napi_start(rtwdev);
 
 	spin_lock_bh(&rtwpci->irq_lock);
 	rtwpci->running = true;
 	rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
+	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
+		wake |= rtwpci->tx_rings[queue].queue_stopped;
+		rtwpci->tx_rings[queue].queue_stopped = false;
+	}
+	if (wake)
+		ieee80211_wake_queues(rtwdev->hw);
 	spin_unlock_bh(&rtwpci->irq_lock);
 
 	return 0;
base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.56.0

