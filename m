Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465514;
	b=HU9MIog9QVHHwsWrCnTh6PTjrBjpNM6jIwNqAlBG7Arqzklm2lq3qhARriDOYB7Ti3KY
	 kOItvJdUoOhBTEuzvMdBD+cObept/JWqvBXAo2efXB+D/Jq8F8cjRwms4h6jwWUCEgfbQ
	 HFcdWMYpkDFo1HU3h9Q6DE+9UHVW9qK+V/YLe8DxNxHZD/mnvqYVPOLw2Ws3jXeNrMWJ5
	 7WiweqkOOXjn+QKpFumaapdwfcyHpyX3m/A3PouFMtK/FDh630p8dxu5YGXjFUA/ud4w0
	 V7SszvW/squayHCfVeh+n97ZHc5WO9APYL16SKa5SDXSwyKpQXWWhDAstwRpzCz6QSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
	b=uMKW/ubz9WJ4zjla2uwb7IM9tshBSNZNCvQdNvDKfdjVmjHuQU9nE4IYHakJkBbXbeRL
	 Odp0I4nJERarZtC9DvwSXVAnA8qS2MN0+Q1iIZp6IYeodzmvtGm9E2H7K+4DgOoGmSVjy
	 Cpq2Lp04W2BBWYIotIGIdWCx0nnV/HuFlVhU+a1/aWgoqCmHeEjSRct5mFbBNStCY4hWe
	 Ia96UjJxJ+ELV6C51GMu74ohJ1PMivSPzCMyK6CS421TlxTVD8JmOlec7k8t0vVHJklMw
	 4cE/9QYLtsFHoybf6hGR7pP/2OmdIF1c4Yrnbun1vlHYxFxKjdNoBoVK5M6Gz7AMDgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f2WYwhRm;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F69B606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F69B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f2WYwhRm
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15943c9c005so1233650c88.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465513; x=1794070313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
        b=f2WYwhRm8WJIr1kEgFwUQDsoM15t18zrEFPfBv0kQlCcEA2xeB2vYXcqrz5Cq/z9FB
         UKpLeOFvmYigA9JrzzIub+IngyudvH6avzY6AxC3CnabijZK4CxDiY8ex/kcos70e+DI
         R1tKyCxynAsRuNZBKxb7EXbKvmGtxvHuQkyFywb+Hugow6H8vUe0hxCKryDVV7bZk09N
         rGHYPirGtPATazZOdt2jMUUIL5g4jk0VxRggDSKCTUXPwn7wWoR3YQlDn3Zco9c9izZE
         FQA9AmLvdWiDsQFc4P30BZU08BYhKS9wNybjnRov4ozZjowlRdSV7I2nTmQtt+hzoJW/
         0/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465513; x=1794070313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9jTZWhLNN11fgmNB1+yFYY5HImFkbZwEDHpQ6o2qOMA=;
        b=wv6JSinophCVyJXnA7vgTdT3ovAkrXh6gMui/yFxn+gR6V8t9wZsqVrfX7RIIwI1Ko
         w/oL93kohCpAA0SfLKE2XZj3aB78xxTnJeiJosg0MijjOoQ6Xc8Dek9PyFIWWeYy4T22
         T7GRlogYtqleTRt8oPgK7i6Qrzu9qk97dJhuuu6IB+506BPqnReUyowzWvY0np2c9EQQ
         iWF+WYNC5n/ganf8CWgx5BbA9GnyfndoeaqJjcLnlOUc8k7bTLLSKTsWdUMS+Ib/eBVt
         SJCHW9Lr23NwZtNEcW8fALk51SADFVivTCRVs47ZMSRBM8xTx2LCXIGTPOWee1HTbeIg
         Blrg==
X-Gm-Message-State: AFq9FYLOq0x9mQ6inYs3u1YcSw1JYANcjDQC2K3NTe5LvGyZZLXOelE9
	NGBiAFsFJXs5aYjz2lDLslFJ1u16Wxis31sJRjPqHgQqsAsONDdcmD9LyExspBF1
X-Gm-Gg: AYBFou0k8nyUpYtd6SdDqQ2sUMHkAtUwDGNOjxCkBk0OHDUhd5Y+84S5vhhwBw5UX48
	U24Y3RjfdVo4v8Ui7iQq+lEDadSwENpu+7VdJL665IiCCvVjzB+NKL0YfgrwNnKTkVyU+5ATP1v
	Vms0P3Z76aUMDIcUfJzK3ibG8yzGmIDkPsy5i/qS9UamcKIJFlNF/5OvNfbYR0Y5QkjyG5KntTr
	quX3yhehrf7iHd3PMa2FzjrQDjHpjD7Gg+Nypa+fHOvBv9X5D3MVORp1bwoxzGIfGz+17gnx6ZE
	rvQgWM4wQH/1jhN3QiuV2yALWgXvv+zptZa+kpYlPFP8JtwINZZC3AMYLY/F+zHayUJ4oOGbVjD
	DoZPmx7P0CAXvK37CsM0TIMCXSdBKKzdByH00YCuedx3yzdXowUtxulHVHiMOslaEI1CBvRITz3
	25o5tpAlrNr7KhUWUrCciIKPLjUOYvik/gtfgWcTq3y6sp9PdkYD7hwWdddE2f0Z/CN++AYVUfw
	N1hjP51DqWV9PBx0PJvCKletkF5qV9+SqAcjBhnL4hqpajQ+wbFwynaAhxm2jl6mhj81FqM0VMO
	+XyDWynjENStOA5tjO6JmhUV+zWxGe6vBPz5A3bbDFrTYi3OvIy2cm+YxwLWJNFGJtoZolgmBH4
	FCxGVLE0rjojjAwUqU1QsBk1IODkqzA==
X-Received: by 2002:a05:7022:ea55:20b0:1a2:a5b1:884f with SMTP id a92af1059eb24-1ac5da7726bmr8165907c88.31.1793465513103;
        Sat, 31 Oct 2026 09:51:53 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:51:52 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 2/7] wifi: rt2800: calibrate the crystal of RT3593 with the beacons
Date: Sun,  1 Nov 2026 00:51:09 +0800
Message-ID: <20261031165117.2868671-3-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
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

