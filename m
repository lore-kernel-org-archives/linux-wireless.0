Received: from mail-vs2-f33.google.com (mail-vs2-f33.google.com [74.125.227.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69130253B58
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 03:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220463; cv=none; b=qNZIT3mtkxsvrpspDFjN7cdrK+XQMtzBHLdWY0GTZPrmkfYNr4f2L5QdO5P2jLT5WNtKDYkkemynJd1mN3LwNLd2bW+9n3YUGApFAvQ1bxHFdlDOu22nHZ36wdx/TCwvnz/yKcQAho3FqnBZb2mc5lTKDq8JhLCpGhahYHXV0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220463; c=relaxed/simple;
	bh=kM6Puz/XpcLqcBqMsx/z2dN1zPM5xT8O+InMRQ90TBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MR1zPMBPyn3OldBGSlsA6EK3qzsz2G7aHnNIInKJja0GT5Hj+qwr227nSdLU4HfpCv3bQvPKFVyB0S2ydVFxiXSuGVBqclEq8xKCwpAKydPqpSJlCuRmuhSJ+ciMaLaRCU4OS5LciQijnO4YOfPC3mZDdda5opFSXMzXpiavhG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FE5xVPbF; arc=none smtp.client-ip=74.125.227.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FE5xVPbF"
Received: by mail-vs2-f33.google.com with SMTP id 71dfb90a1353d-5caec6d2983so412188e0c.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220461; x=1790825261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S4rkArTvjlD8DucpkVvcyw33LP877dBjJ3f1kqgDbC8=;
        b=FE5xVPbFqoGl7h/S2K75BZYzeGjsnIkjEQB8b5vr/Qz+wPAsf0x+grbnDgu74tj23C
         4XUbUbpTvs+nLWZZHSiID79BHJdnVc1oHdVmTXgU1ehSZvOZiRWgX/wLXCJziEBCBZTL
         rZ3LOqRaVcZ7wH9xdmIdtizVpTNLX5Isg8ZZsh9rjdwg0x4rYEipo/68evScBvjQGKzn
         ecNUraNRUNb/RX/xtntU4SwSELN8v67BxoKMCRG9MLfVe1rEzuxrfD26cu/0y9dCr9K5
         t1fyJ06tHAmVLGDZo3B5QNZHNPfOKVHaOsoBBDIk9klRUvQB/FEOV3hxZNAEUgUHn0Q4
         1pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220461; x=1790825261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4rkArTvjlD8DucpkVvcyw33LP877dBjJ3f1kqgDbC8=;
        b=s7/N1S/i2A6Fk65NBupWH7+hliL7SjmGniewrQlTD6KorOajucYUD4ypu+qTaaO10n
         oqzfgY+zV0KaYgoIoP3B6d2OzUF8r6cqhSm9rsemJguD0wXzFy7hdvKZD7Y7zAfk7X7q
         kz98CyWTjU9G1QiJ2yG4UxJZFUOe4T19vP5pZlUVc0Fl8q1YB8I6GPr7DdrU3M5rBVcn
         0BAuFbbrMQv6VIg4IsN3SJ30DoTupY72OzfV4yj9Tpsed54ULvfZbxxxEiV6ACu5y9dE
         9wSqIFADqIb3FNM9oyN3t0nVj2ju6AmMO+DmUAdTxvyccewvSe7nI3OMiY5CuI7OR0Z1
         7ePA==
X-Gm-Message-State: AFuF++kxJRJRcBCx3NcVtNWn0lraAlD5allnl93W0h12/5dVddk94Buo
	D5R//Lp8pr5QNSp57Im6kBuZ6X+56bTxXB9c+RhSGgodBFOnetPrK4z3VtFTPhmj
X-Gm-Gg: AYBFou2vb8eSuOgv2k0IgKUjYzSmXglRIQYn5uTMTf255KGpiBBXJrXngpaStlxNvpX
	ig+sWJ2AtHbltKr2wwmtxnJn2jpNvi2GGcqy9mIGaiguNraZxwGHs60oPLCgfHqj8tUrbQp7eUY
	4Vf0UQaXUPlTXz6MQToKeSujwrVj2xi+viix6bAN/GV+SM5vUQjNS9S8K3q/s1dKmKm5We6FRn1
	qRIa60/2A2HH/e0X8VTdMe92F/t8+STpcDkuPhxyPKqjpskF8atgCfWGEDDA6oDCofFs2AVeb97
	2ez4enc285lfKUSiChfvbkS8+fl/OA57xoIM1l8r2I6EZFGGdwxgKq4W706PBVKy8dxxG+eUiai
	N1uNAhUrW2sQ1R/4Cr/N1zuzzfVWkSB3A5bTu9mtzcVf6c0GCMhICbcOw8sSGGPIHnj2Fw7PBV5
	/01+EiQsz2k+q3kXfm00b9GXs4FQoGAfvVmZ/0W7UCl1Fkz36/SoYTwj8GSbVtpRfZKC7S4R6q5
	1gKdl6dQYm+Q855VzOBBT4enNnYWjJAXS+eXXEF2AoHg9c=
X-Received: by 2002:a05:6102:4191:b0:7a8:1817:276f with SMTP id ada2fe7eead31-7af1f61e9f8mr693993137.37.1790220461112;
        Wed, 23 Sep 2026 20:27:41 -0700 (PDT)
Received: from localhost.localdomain ([190.177.169.131])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7abf35bcb07sm6107028137.2.2026.09.23.20.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:27:40 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: feed the station RSSI average from the chain signals
Date: Thu, 24 Sep 2026 00:26:39 -0300
Message-ID: <20260924032639.28158-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_check_sta() adds status->signal of every received frame to the
station's RSSI average, wcid->rssi, which mt76_get_min_avg_rssi() reads
for the dynamic sensitivity of mt7603 and mt7615 and for the gain
control of mt76x0 and mt76x2.

Since commit 4550fb9e9810 ("mt76: improve signal strength reporting"),
drivers no longer set status->signal: mt76_rx_convert() computes it from
the chain values when the frame is handed to mac80211, after
mt76_check_sta() has run. Except on mt7921, which still sets it, the
average is fed zeros. mt76_get_min_avg_rssi() then returns 0, so mt7603
and mt7615 leave the sensitivity at its default, and mt76x0 and mt76x2
fall back to -75 dBm for their gain settings.

Compute the signal from the chain values in mt76_check_sta() as well,
as mt76_rx_convert() does. On mt7921, the average now follows the same
combined value that mac80211 gets instead of the strongest chain.

Tested on a TP-Link Archer XR500v with one client, switching between
the old and the new input every 30 seconds. On the MT7662E (mt76x2),
the average the AGC works with was -75 dBm, its fallback, with the old
input and -54 dBm with the new one, while iw reported -54 and -52 dBm
for the station, and the AGC mostly used its low_gain 2 setting instead
of 1. On the MT7603E, the station average was 0 with the old input and
-41 dBm with the new one, while iw reported -42 and -41 dBm. The mt7603
sensitivity still stayed at its default: a separate bug keeps it from
leaving 0.

Fixes: 4550fb9e9810 ("mt76: improve signal strength reporting")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
Testing: OpenWrt, kernel 6.18.41 with the mac80211 backport of 6.18.39,
openwrt/mt76 at be5ce79105 plus this change and the board's local
patches, with a temporary module parameter selecting the old or the new
input (not part of this patch). One client; the old-input samples of
each run come from the same minutes as the new ones.

Tools: an AI coding assistant (Claude Opus 5.5 in Claude Code) found the
cause, wrote the instrumentation and drafted this change and changelog;
the tests ran on my device.

 drivers/net/wireless/mediatek/mt76/mac80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index cda5c5d51..4231adb77 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1471,6 +1471,7 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 	struct ieee80211_hw *hw;
 	struct mt76_wcid *wcid = status->wcid;
 	u8 tidno = status->qos_ctl & IEEE80211_QOS_CTL_TID_MASK;
+	int signal;
 	bool ps;
 
 	hw = mt76_phy_hw(dev, status->phy_idx);
@@ -1488,8 +1489,10 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 
 	sta = container_of((void *)wcid, struct ieee80211_sta, drv_priv);
 
-	if (status->signal <= 0)
-		ewma_signal_add(&wcid->rssi, -status->signal);
+	/* status->signal is only set later, by mt76_rx_convert() */
+	signal = mt76_rx_signal(status->chains, status->chain_signal);
+	if (signal <= 0 && signal > -128)
+		ewma_signal_add(&wcid->rssi, -signal);
 
 	wcid->inactive_count = 0;
 
-- 
2.47.3

