Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281707;
	b=hhLFbOo2fJfIYgkup3Jzw0+LpmTsH2Qzb5z0Iilz4jKTuFeyNqLihG9HaGviP4Ah4Mdf
	 56Z0wYkTeP5GagdJkNtQyc9Uzd9j2Crb1ZzekdAoz3aRljyKpTDUTg2FF7Zsz4G1Dizpt
	 Vdb5shTM3DP76B7lT55r4auJV/IhQjZeMXxi0Ud4wbdZgqH+cCyKFxfaRcG0/m4WWEzFp
	 JenA/wF+VFWu0dHi/z7ExoYz7v+bZ+CTggdJLm/fZOL0OzD/t5Usr90B0+NWkiKyabniQ
	 H3hDM46PPhfyBZVxWeOihgIKhn/mEY9btKAJPaP3PRCUXYq6EDzlWyAtuzJ5JaO3AIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281707;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
	b=rp/vDldE79ldqCRX6tb/4swPt0FRgUa4R1ztT0ObbwcZE6FLhxRi/BVDkdIkFY56xwu5
	 9n5FeDLzJWxItRTl7yAo2yAE7Qf6DA8CyL+O6xar3eC/+bFgiebmZROXVFuwRRIRHuhnd
	 QM0ZO/sEwIxoEEMRXRaUnUlZgPZyjZWV+Jxrh3hQ8KM9Cp7+d5UHMBeWBlHFfskyu0xpy
	 BO2OvqVKRkZ6/X8bodEvpH+gb8enDtSVpY7MR4XJEY0dM1K1QG7w4sz5ZBD2AHkzXexm8
	 zNmyujBL2SSQCdgsOhp1N9DhTAfXN/Vu1Ead7S27F8pBnSjaJ2aO8ye6NeDWqPpSUXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HhTREIr8;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44660A2607
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC44660A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HhTREIr8
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06b436dffso1034828b3a.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281706; x=1793886506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
        b=HhTREIr8mD8HexfkXfhsJ3dUR1fgAZql4RRmXxStX2wicdNLRR8zgJSbXBMijsPlMz
         Iv1AKbhB17T86wqVUtO8j4dQFRT8H1KftE4kdXcWJ/YiuKV4JAcmbjmU4JEY0CCqFCh7
         iG2L499C3H2e87+OberCHzIzzlpAMthfV2lKaVAmkFyT4277PilZsTgcftf5G+v1oHcs
         fQYDV/z7YzVWWwQFIg9wEU5+KxFjyjt6C1xTPybK2+RgxrA3hf5qVYRReELBDMHnWZJT
         p5dOFtKdkBP18c3iOvlrKjW86PA0R2kpr0+0+27w6BhTIY7Ssuwk+q0MGKUHobyVdnED
         KmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281706; x=1793886506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
        b=NWOpMzJqbCGVoJLwkYJ4B2qFkJjy/4NIfz6Tj7hLl8CDaWRWAz7kEtIjt5Lth1GiXD
         7xREBlrxkOQhGAlyY8mb5jqPwE+k0HiVztb8LJLRpCFaZSVhzwqZQsjJCh06QOkA5ZHY
         Z6gRIJYkSPR+KifV3fnTbioLcaFx4SWMvu69hrMx/Q1tKPCW6+ZYV7PCulxRkyVEzYTL
         f3lGwVN/XA+DtWv1A9WGEOCR8pqynzfIFzINdAiry20kNiMW6SZb8Ld2LOkhOSeTeZyC
         xVel3Vcg9663lTDuCa/EuOOJ6fnKLzjEp5WHQV57fI4ANCDTHd2zPzywb7zcxOfwVMjf
         4Rfg==
X-Gm-Message-State: AFq9FYIrVYGGW1RYAzBJMbcaJbTQXmRUV4uG69ZpS22LM0vpy63sD/0o
	Bmm7+EPxmaQJLDqaoe3ICZedevkUaprA7bRcamehcam2XiGbHSv/4grV
X-Gm-Gg: AYBFou0+es0q9n0LQBtLf2AdRpvv1C+Q7Rkmtrf06xkMGSO3fuBZzrXB0YZ9htcndkz
	5mGDE6b1kFP+mOqWNECP9TvVuf4ury4JAtIDNCfidsgAvpjLlCIPF8vtCbZtmeKuYUOa4W5BtDT
	00qSLh3zF+T2djaxUuMkLLQwn+1sn+fwO423YHXKP/shUvn7D0n3sFhNsuarBo6kRMAslgpFzLh
	1PjHvgB3c4QPyVozagKMEGJZtsrSPfH8rmOkqIDdc9Fg5J7tl6N2hM7ZY4mHDtuTgD8Khig2x1M
	yKJwLAimT5Qy58xQEIQsgRBksiOthqH3EJApLBAenzOljjJw/HzSwfcfTjuZjZhvUd5w1ISgYbH
	q0BpCfaP6Jbf50MgqUG+eKuoIRfxusBsSQ6f2zSNjBFaIrmm/EoW29yFKRdEVpgOK0pUCt2dQpL
	C6vwGd80kX9pYpL+XUuzFhlEa7AcXc+V86u1zzDnEVsW9+L3dGpvrsrsFwzXI2xfN6H/SdaFMob
	dV1Y2Y7hZi2YDHS3aUJrTB0nK/NO+HbHBcLiojkYn0O8nbZMjDaWjShPvITcUzBQB44LzsA9Krf
	QZYx0YDFdDnFuKAAzG66NpLsfMAMiRohPVUwW6gXKqnuPgPSCjQ8B3d2Nt4jI/VeKRaA/iASCym
	o9+nc9qhl
X-Received: by 2002:aa7:8887:0:b0:881:be70:448e with SMTP id d2e1a72fcca58-8a6e82b22c2mr4390140b3a.53.1793281706005;
        Thu, 29 Oct 2026 06:48:26 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:25 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 2/8] wifi: rt2800: calibrate the crystal of RT3593 with the beacons
Date: Thu, 29 Oct 2026 21:47:43 +0800
Message-ID: <20261029134752.1299130-3-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

On a Netgear WNDA4100 (RT3593), as the adapter warms up, the
frequency offset drifts enough to affect the link quality.
In certain cases it can cause the link speed to drop
to 1Mbit/s or below.

Add a frequency calibration step function to RT3593 to use
the frequency offset obtained from the beacon frames of the AP
for tuning.

Test results:
   before after
TX 27.7   28.5
RX 31.6   69.7

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 101 ++++++++++++++++++
 .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
 .../net/wireless/ralink/rt2x00/rt2800usb.c    |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |   6 ++
 .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
 .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
 7 files changed, 124 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 8930589b4967d..b9f6de3a462e3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -3163,6 +3163,7 @@ enum rt2800_eeprom_word {
  */
 #define RXWI_W3_SNR0			FIELD32(0x000000ff)
 #define RXWI_W3_SNR1			FIELD32(0x0000ff00)
+#define RXWI_W3_FOFFSET			FIELD32(0xff000000)
 
 /*
  * Macros for converting txpower from EEPROM to mac80211 value
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b62475..e7b6edf485099 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -897,6 +897,28 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
 	return (int)max(rssi0, rssi2);
 }
 
+static void rt2800_rx_freq_offset(struct queue_entry *entry,
+				  struct rxdone_entry_desc *rxdesc)
+{
+	struct rt2800_drv_data *drv_data = entry->queue->rt2x00dev->drv_data;
+	__le32 *rxwi = (__le32 *) entry->skb->data;
+	struct ieee80211_hdr *hdr =
+	    (void *)(entry->skb->data + entry->queue->winfo_size);
+	u32 word;
+
+	if (!(rxdesc->dev_flags & RXDONE_MY_BSS) ||
+	    (rxdesc->flags & RX_FLAG_FAILED_FCS_CRC) ||
+	    !ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	word = rt2x00_desc_read(rxwi, 3);
+
+	spin_lock_bh(&drv_data->bcn_lock);
+	drv_data->bcn_freq_offset = rt2x00_get_field32(word, RXWI_W3_FOFFSET);
+	drv_data->bcn_rate_mode = rxdesc->rate_mode;
+	spin_unlock_bh(&drv_data->bcn_lock);
+}
+
 void rt2800_process_rxwi(struct queue_entry *entry,
 			 struct rxdone_entry_desc *rxdesc)
 {
@@ -935,6 +957,14 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 	 * Convert descriptor AGC value to RSSI value.
 	 */
 	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
+
+	/*
+	 * The frequency offset of the beacons is used for the frequency
+	 * calibration.
+	 */
+	if (rt2x00_rt(entry->queue->rt2x00dev, RT3593))
+		rt2800_rx_freq_offset(entry, rxdesc);
+
 	/*
 	 * Remove RXWI descriptor from start of the buffer.
 	 */
@@ -2443,6 +2473,7 @@ static inline bool rt2800_clk_is_20mhz(struct rt2x00_dev *rt2x00dev)
 }
 
 #define FREQ_OFFSET_BOUND	0x5f
+#define FREQ_OFFSET_INVALID	-128
 
 static void rt2800_freq_cal_mode1(struct rt2x00_dev *rt2x00dev)
 {
@@ -5633,6 +5664,73 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_vco_calibration);
 
+void rt2800_freq_calibration(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	struct link *link = &rt2x00dev->link;
+	u8 activate_threshold, deactivate_threshold;
+	u8 freq_offset, rate_mode;
+	u16 eeprom;
+	s8 offset;
+
+	if (!rt2x00_rt(rt2x00dev, RT3593))
+		return;
+
+	if (!rt2x00dev->intf_associated) {
+		eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_FREQ);
+		rt2x00dev->freq_offset = rt2x00_get_field16(eeprom,
+							    EEPROM_FREQ_OFFSET);
+		link->freq_cal_adjusting = false;
+		return;
+	}
+
+	spin_lock_bh(&drv_data->bcn_lock);
+	offset = drv_data->bcn_freq_offset;
+	rate_mode = drv_data->bcn_rate_mode;
+	drv_data->bcn_freq_offset = FREQ_OFFSET_INVALID;
+	spin_unlock_bh(&drv_data->bcn_lock);
+
+	/* No beacons received */
+	if (offset == FREQ_OFFSET_INVALID)
+		return;
+
+	if (rate_mode == RATE_MODE_CCK) {
+		activate_threshold = 4;
+		deactivate_threshold = 2;
+	} else {
+		activate_threshold = 20;
+		deactivate_threshold = 10;
+	}
+
+	/* Hysteresis */
+	if (abs(offset) >= activate_threshold)
+		link->freq_cal_adjusting = true;
+	else if (abs(offset) <= deactivate_threshold)
+		link->freq_cal_adjusting = false;
+
+	if (!link->freq_cal_adjusting)
+		return;
+
+	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
+	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
+
+	if (offset > 0) {
+		if (freq_offset > 0)
+			freq_offset--;
+		else
+			link->freq_cal_adjusting = false;
+	} else {
+		if (freq_offset < FREQ_OFFSET_BOUND)
+			freq_offset++;
+		else
+			link->freq_cal_adjusting = false;
+	}
+
+	rt2x00dev->freq_offset = freq_offset;
+	rt2800_freq_cal_mode1(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2800_freq_calibration);
+
 static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 				      struct rt2x00lib_conf *libconf)
 {
@@ -12032,6 +12130,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	int retval;
 	u32 reg;
 
@@ -12105,6 +12204,8 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
 
+	spin_lock_init(&drv_data->bcn_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_probe_hw);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index a3c3a751f57e3..9a04a0fba113f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -45,6 +45,9 @@ struct rt2800_drv_data {
 	unsigned int ampdu_factor_cnt[4];
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
 	struct ieee80211_sta *wcid_to_sta[STA_IDS_SIZE];
+	spinlock_t bcn_lock; /* protects bcn_freq_offset, bcn_rate_mode */
+	s8 bcn_freq_offset;
+	u8 bcn_rate_mode;
 };
 
 struct rt2800_ops {
@@ -241,6 +244,7 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count);
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev);
 void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev);
+void rt2800_freq_calibration(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 15de3db124298..387c07e2251b7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -693,6 +693,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
 	.vco_calibration	= rt2800_vco_calibration,
+	.freq_calibration	= rt2800_freq_calibration,
 	.watchdog		= rt2800_watchdog,
 	.start_queue		= rt2800usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 7d313e86d3f20..a80508db32d9c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -319,6 +319,11 @@ struct link {
 	 */
 	struct ewma_rssi avg_rssi;
 
+	/*
+	 * Controls interval of frequency calibration
+	 */
+	bool freq_cal_adjusting;
+
 	/*
 	 * Work structure for scheduling periodic link tuning.
 	 */
@@ -559,6 +564,7 @@ struct rt2x00lib_ops {
 			    struct link_qual *qual, const u32 count);
 	void (*gain_calibration) (struct rt2x00_dev *rt2x00dev);
 	void (*vco_calibration) (struct rt2x00_dev *rt2x00dev);
+	void (*freq_calibration) (struct rt2x00_dev *rt2x00dev);
 
 	/*
 	 * Data queue handlers.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
index 2f1385baa7ae9..a6f516ebdb2db 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
@@ -22,6 +22,8 @@
 #define LINK_TUNE_INTERVAL	round_jiffies_relative(LINK_TUNE_SECONDS * HZ)
 #define AGC_SECONDS		4
 #define VCO_SECONDS		10
+#define FREQ_SECONDS		10
+#define FREQ_ADJUST_SECONDS	1
 
 /*
  * rt2x00_rate: Per rate device information
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
index fb23d409fba87..2dc4edc12834f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
@@ -343,6 +343,7 @@ static void rt2x00link_tuner(struct work_struct *work)
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, link.work.work);
 	struct link *link = &rt2x00dev->link;
+	unsigned int freq_interval;
 
 	/*
 	 * When the radio is shutting down we should
@@ -362,6 +363,14 @@ static void rt2x00link_tuner(struct work_struct *work)
 	    (link->count % (AGC_SECONDS / LINK_TUNE_SECONDS)) == 0)
 		rt2x00dev->ops->lib->gain_calibration(rt2x00dev);
 
+	freq_interval = link->freq_cal_adjusting ?
+			FREQ_ADJUST_SECONDS : FREQ_SECONDS;
+
+	/* VCO calibration should be done after frequency calibration */
+	if (rt2x00dev->ops->lib->freq_calibration &&
+	    (link->count % (freq_interval / LINK_TUNE_SECONDS)) == 0)
+		rt2x00dev->ops->lib->freq_calibration(rt2x00dev);
+
 	if (rt2x00dev->ops->lib->vco_calibration &&
 	    rt2x00_has_cap_vco_recalibration(rt2x00dev) &&
 	    (link->count % (VCO_SECONDS / LINK_TUNE_SECONDS)) == 0)
-- 
2.53.0

