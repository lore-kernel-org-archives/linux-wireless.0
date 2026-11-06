Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793933294;
	b=gh5cSOdgtQnKgWaKXBAPIf1egMQl+3H+4gsE7Xx3ArZlcvUGvCvt0fBhObuER8tvSNou
	 AffE4hl8kzN6wutZWLJuxqX+NsdPTo4LXSwt9Qb4b2e1RuduT34fImWKvMD4yP5rhmM8e
	 dOLMfPy2vvzcwPtZkJxvscDqavqXeyU5m5VKJlSdx9ouBy+pspAZ+Wz2YqwU6xAQMO7mY
	 FD5V/vuUzSMMTIMCfcbMZvAYUbK4sUdCgWc1+RhLOiS6gwwaKyRu3u9S3yTijXWdL7DSC
	 bPbCZKH8u8iH0yO2YjcLf5qjmVCHGEEVr8CS7NLgUnyXWW9bOgTLlWu/5kwrxp3uZPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793933294;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0UaxTG5x25gmRjc6KZfHadcJjXgPqxLqtyLeTH1tBMo=;
	b=rrfTkTtRwdLQS/yjMY7ilMkbdMfVJRg6KTykTOEJ2oK9/MrgLHdlYIC11cZQb+jEMe9F
	 fEPliQN28Zf99u3bwjjuDb+dWW+UiXkBE0fZKSxlDKyWsbCoQDBRAHQ4rWSYw6t5pca/D
	 pM3dd0w4BgoEUmQKVSkdj760h4+mlBgsVBrwmDuhi/EKJ54/5c1NRyqLoGT8yRLzbMBY9
	 h+f8MbafknPH/UP3MNJEQwuiZtJUaNt1Z0yKS4X6vC8QqGdZ855ndNwW0xARtsyTSAGni
	 19+TBgu/5anw7AWLcygJyT9Qi8f+034Z02aU3SB6JqJ0fS5Ro+auLimWQYVL/nfwC4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dEaRpNx1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958C606A31B;
	Fri,  6 Nov 2026 02:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dEaRpNx1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793933293;
	b=uQs9iv7cvDd0HHy6i3BusgHnZ4bH9xTHWJ8CM3piV/pLPYPWK4Y8holKK+xDf1cBYD/g
	 OLkrpiyelcwzeNgsW/khjUcfdyBsczcKsV3iL//pN47xgk5Uxq7ozcLnpwKGDd93igPvW
	 OLWZxkjdKdzzh7ZsFpck+67TX28qio62eykwG+unig/OUMORCVL5pdmPhd/UDgzkyrMGd
	 B9/0nJcbKCs+wS3uQT1d7sc5nbmhJqgUnxrJ852COLzfGyoxb9cdtLFlu7xZL2HNWKUaR
	 kZhvuW01NGq3N9CtR8m6YUdwhAXJ4ZArhhkSknLu4cYaNBajVyi06BeWyfcoGiuUjgw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793933293;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0UaxTG5x25gmRjc6KZfHadcJjXgPqxLqtyLeTH1tBMo=;
	b=OUQoi2nnTu2A2U3UMhAgIn406JQC7nzp0OY5hDNSCe0ATTPlY23fiyBZFESCemQPTdNY
	 X95yi5c6u4K7cNfM/l0EZj4ZS8NBIgWhQ8RLknR2Wvom0FySjMeiNJ8eEowKsJ79nynLE
	 /MxIivopNGAZUu+H+mqcpp12EpsX85s1BKyRKple8C5X05w0KSE0scU2h6SbBZDnegAqM
	 dauqiQ34fj3lyuySBJZRauhlHtzzvm8k959Ok4GY5VgWyldsBeTFTwdl2O//T4Xrd3JTT
	 agrYV421lBePE6j4m7ZseRY3zzAsqk5Pqp0BS6Oo2Sr9ZoXjyCLQ1LYSahXht3a6DqA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C99811F0089F;
	Fri,  6 Nov 2026 02:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793933293;
	bh=0UaxTG5x25gmRjc6KZfHadcJjXgPqxLqtyLeTH1tBMo=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=dEaRpNx16Z9GiFUKj+kDvv4bXGPG1PD+vMpUefteWq8CKcUjOvQBBQ9oPX/ZniTps
	 PmwsBgjSCEde8hgm6dAGxDOv2A7RC+NFnyILXwK+/jHzDS0U0iovDrDyAiIVirAvzh
	 4JKa6rtlPiZHbxk5CxzfxxZjk9DYaLg6P7YnOkWupCm6K5w0OGRzRc1wqun3/rgnK6
	 tPhr/CInY2O8uYaomiVZ9CI76gV4gLM0QHwKQDes2+pczy8RsVZmF0Nwr3ysbRBJp5
	 FnMXjAWcNxUcDDIK9Hf8MsiGsG7GousSSwAaDG9ke4wo0Vn63pDRrAihEP2nxTmRbU
	 omwbO+vWzKQaw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 45C5545B53;
	Fri,  6 Nov 2026 02:48:12 +0000 (UTC)
From: kvnshroom via B4 Relay <devnull+kvnshroom.gmail.com@kernel.org>
Date: Fri, 06 Nov 2026 03:47:00 +0100
Subject: [PATCH] wifi: mt76: mt76x0: select the VGA gain from the RSSI
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-mt76x0-rssi-agc-v1-1-9d2f3ad74096@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwMz3dwSc7MKA92i4uJM3cT0ZF3TVPNEC2MzS/PEpGQloK6CotS0zAq
 widGxtbUAHa7S42EAAAA=
X-Change-ID: 20261106-mt76x0-rssi-agc-5e7a83697abc
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 kvnshroom <kvnshroom@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793933291; l=4777;
 i=kvnshroom@gmail.com; s=20261106; h=from:subject:message-id;
 bh=GOUrR0SBzLl91iB01un4+ocyPS/13W2NZJubzZQmBUM=;
 b=u5iZ31sHOf1LNUdzPgpZzqWvjRaA3mYJPtptQvXyoEbww3yQIV9dtYYK4psF31FL6ZasMU6zF
 GhVWAqLvr/uDC+3Y+jAiie91KB5QWbRnMie1jQfhRTWOQRdUG1Duqk1
X-Developer-Key: i=kvnshroom@gmail.com; a=ed25519;
 pk=8lajK9/tD4YlPR/MOkqpgUU4drxTtsOnUfM8foTue/4=
X-Endpoint-Received: by B4 Relay for kvnshroom@gmail.com/20261106 with
 auth_id=1426
X-Original-From: kvnshroom <kvnshroom@gmail.com>
Reply-To: kvnshroom@gmail.com
Content-Transfer-Encoding: 7bit

From: kvnshroom <kvnshroom@gmail.com>

Since commit e1534fef1ae4 ("wifi: mt76: feed the station RSSI average
from the chain signals") mt76x0 gets the real station RSSI for its gain
control. On an MT7610U (ASUS USB-AC51, 5 GHz, 80 MHz, about -60 dBm)
this makes the false CCA based VGA loop worse: with low_gain 2 the gain
moves between 44 and 56 and stays at 56 most of the time, the false CCA
counter reads 30k-50k per calibration interval and the receiver is
overdriven.

Fixed gain (BBP AGC8 bits 14:8) against the false CCA counter, with a
ping to the AP every 200 ms during a download at the 50 Mbit/s line
rate:

  gain   false CCA   ping p95 / max     download
  24-48  0.9k-4k     2.5-3.8 / 5-27 ms  51 Mbit/s
  50     8k-11k      3.2-4.5 / 25-40 ms 51 Mbit/s
  56     46k-59k     164-299 / 400 ms   39-43 Mbit/s

The MediaTek Windows driver (netr28ux.sys 5.1.38) does not use the
false CCA counter on MT7610/MT7650. It selects the gain from the RSSI
in three steps, at -60 and -70 dBm. Do the same: reduce the calibrated
initial gain by 42, 26 or 2 depending on the RSSI, with 2 dB of
hysteresis between the steps. On this adapter the initial gain is 66,
which gives the 24/40/64 used by that driver. MT7630 keeps the current
behaviour.

Same setup, 60 s per run, two runs each:

             gain       false CCA  ping p95 / max     loss  download
  CCA loop   mostly 56  30k-50k    1.1-1.8 s / 3.4 s  0-9%  18-39 Mbit/s
  RSSI steps 40         ~300       3 ms / 8-15 ms     0%    46-51 Mbit/s

Not tested: weak signal (below -70 dBm), 2.4 GHz and MT7610E/MT7650E.

The Windows driver was analysed with Ghidra. The analysis, this change
and the changelog were prepared with the help of an AI coding assistant
(Claude); I reviewed and tested the result on my hardware.

Signed-off-by: kvnshroom <kvnshroom@gmail.com>
---
Tested on an ASUS USB-AC51 (MT7610U) with Linux 7.3 and e1534fef1ae4
backported. I can run more tests, for example with a weaker signal or
on 2.4 GHz, if that helps.
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 64 +++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ec554a059..d052d8619 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1064,6 +1064,64 @@ static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 		mt76x02_phy_dfs_adjust_agc(dev);
 }
 
+/*
+ * MT7610/MT7650: select the VGA gain from the RSSI only. The gain is
+ * reduced from the calibrated initial value by a fixed amount per RSSI
+ * step, with some hysteresis between the steps. The false CCA counter is
+ * not used, since on these chips it drives the gain into a range where
+ * the receiver is overdriven.
+ */
+#define MT76X0_RSSI_GAIN_STRONG		-60
+#define MT76X0_RSSI_GAIN_MEDIUM		-70
+#define MT76X0_RSSI_GAIN_HYST		2
+
+static int mt76x0_phy_rssi_gain_step(int rssi, int prev)
+{
+	int strong = MT76X0_RSSI_GAIN_STRONG;
+	int medium = MT76X0_RSSI_GAIN_MEDIUM;
+
+	if (prev == 2)
+		strong -= MT76X0_RSSI_GAIN_HYST;
+	else if (prev >= 0)
+		strong += MT76X0_RSSI_GAIN_HYST;
+	if (prev >= 1)
+		medium -= MT76X0_RSSI_GAIN_HYST;
+	else if (prev == 0)
+		medium += MT76X0_RSSI_GAIN_HYST;
+
+	if (rssi > strong)
+		return 2;
+	if (rssi > medium)
+		return 1;
+	return 0;
+}
+
+static void mt76x0_phy_update_rssi_gain(struct mt76x02_dev *dev)
+{
+	static const u8 gain_adjust[] = { 2, 26, 42 };
+	int step;
+	u8 adjust;
+
+	/* keep the counter visible in debugfs and clear it */
+	dev->cal.false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS,
+				       mt76_rr(dev, MT_RX_STAT_1));
+
+	if (!dev->cal.avg_rssi_all)
+		step = 1;
+	else
+		step = mt76x0_phy_rssi_gain_step(dev->cal.avg_rssi_all,
+						 dev->cal.low_gain);
+
+	adjust = min_t(u8, gain_adjust[step], dev->cal.agc_gain_init[0]);
+	if (step == dev->cal.low_gain && adjust == dev->cal.agc_gain_adjust)
+		return;
+
+	dev->cal.low_gain = step;
+	dev->cal.agc_gain_adjust = adjust;
+	dev->cal.agc_gain_cur[0] = dev->cal.agc_gain_init[0];
+	mt76x0_phy_set_gain_val(dev);
+}
+
 static void
 mt76x0_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
@@ -1072,6 +1130,12 @@ mt76x0_phy_update_channel_gain(struct mt76x02_dev *dev)
 	int low_gain;
 
 	dev->cal.avg_rssi_all = mt76_get_min_avg_rssi(&dev->mt76, 0);
+
+	if (!is_mt7630(dev)) {
+		mt76x0_phy_update_rssi_gain(dev);
+		return;
+	}
+
 	if (!dev->cal.avg_rssi_all)
 		dev->cal.avg_rssi_all = -75;
 

---
base-commit: b8e5b0ae8ff47240366d38e5d12c65f878724316
change-id: 20261106-mt76x0-rssi-agc-5e7a83697abc

Best regards,
-- 
kvnshroom <kvnshroom@gmail.com>


