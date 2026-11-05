Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871645;
	b=dmB6bB2U4KyH13WU21bdIUW42WwOxgat8AqH/9G0jnZrllbN6y8iLKhLcH1WMydCIn7a
	 KRpQLDQcT1DxUkMjlzYK+YsW+oV+7VzBOJNjTb6o4uNC8ssMwEzMGdhc8WWlvOU9hj0g7
	 5B8wd+TikI2fBRNFSypCf8w+EH81RqoKNuyBtIm0kuXWLTpK5VSKgwC0vNrP4bfnmao8E
	 Wizz0y4ow2HfjIAo9BnZGcUIo6EM80Qvq//SvZ/j5Ua9Ym2zx+b2xYm/CxDsvLCt3Gsq7
	 fmI4jUh1ExOFeNZfGCSNqO9MMmiw8968TauzrvnDNG0nGHEY9O22d43ke+h93a+EVnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DgIsZOa8myUk0DSS9x0Mg2lk7zq4tXrdVlCTBQiXyUE=;
	b=c5B+JaTqPZJNs8qXfaYfCzNjHDXJo0bB0y/dc/kazVHHkJAFgvgY8+6QXrGsl1PQSHSA
	 OLfCrzaoM5H0y8QMdVhPro/hfHNsMA/jKel0J2sL7XBVLRUVR5R2aP8hauMC/pmCg5ZPM
	 zli+oVRgfwQP3M873mwMPHYTYqUsY2xBsY/UxSzBT9Tbj/RYSX9SZnc8jbKgXjYBpmiWl
	 71mkhe8bvKgnywM2UVSQiXGBVVFR1Wfmzebnov59kwOsu+DF+B+tNsgD6TEYgwcjqDBng
	 EjaRga45Nh61V8f92baT/LKHuRXpAPEqiDMxKzjX7EhZ5ZDzd6rZzEWf9qerlRggoxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PIpVx20v;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998C8606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 09:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 998C8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PIpVx20v
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b2382bf051so230814b3a.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793871644; x=1794476444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DgIsZOa8myUk0DSS9x0Mg2lk7zq4tXrdVlCTBQiXyUE=;
        b=PIpVx20vgc+cNtqpCgvjXVL+/3LX5uF9sVP5XuuOSzUvcg6vhu/mbCfaVdZvjiLGKl
         NfaR1iAkdHMEpxwy8lQ3jnLSESwQ22a+5wj0DIytB5hA6xIuTRwi/kPc9NUo7aj/5Gc0
         5cIc6/bYc4H9lFpMKEwv+890w+An3lAPtmCV7M0re5aWcjAg3/p1IsglI7gdnCJ3Kx4I
         EHl3BNe19L2nSCdybHg7JvSTEB4TfdmRz6th137mO+ZRNiprNJ9kv3eFfkWSoZf18zio
         f7JmcaxiBpjsFfuLjO13HjOaSNXpdAzlGukmiBxOHtrrPUwGQAKPja1+eQ0BL3kUZCCm
         UKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793871644; x=1794476444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DgIsZOa8myUk0DSS9x0Mg2lk7zq4tXrdVlCTBQiXyUE=;
        b=NdaMtkO/qaldi1QP2QbcU46gTlr4PgMnk47Xgp1MikfNJRfios7Br+v+x+Khuq/vK/
         L9foUzU5NHfDMiJY+RzL5Oua9usmyvE/LT8J+BI5eA+lfjLcoGhss+/AXx4N8b7sbaUb
         LIKW8rjTLHXqz69sJTT5Og4FbbuQRnRQddApqsIKkxOHPEMTJ/st+t3t1Xc+9lNLxWvV
         xxexcITgjgG8Rqx4OgexkEIP7tqdA15fHZezMbDxc/lprKz3V7n5YnjNFws+TNR9x0xP
         anrWG0Fxu93QFwvqEDrZNGQWX8WhPi9PBGrUSEUqkYYXfC/wduGKtlwpxWobjlpNc7+S
         /qmg==
X-Forwarded-Encrypted: i=1; AKwUvBx+Wq5SqH7VK1I9qewan9Fw+vMZ6uc4OKfginVYJ7h0qCzOQy9Drk7T/Uc25ycK0uXvr5FQ9Tsc2A5WX91r9g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Luy1YHIVREapCk5nbOFb/j5EYswcKEtsp+PuKTXR9e9pe/JgS
	0PaOCen5ybVOTqEpHHf/UHUO5QtnKJ1LNze7MeWT+EVrDGp9e/trrYJgN7uOaNULtbg=
X-Gm-Gg: AYBFou3dFaebd1hrJuw2WS4iV75Ro5Qfui07e7lwfYVht+kyQzBNNa+NsEsyv/CGBBm
	5aST0ntBO/vkyBn6Je944Lws+umrU+9vnAKpfeej5XPLpZCok+6+4F1QJbDlRRNcgXMaKUt2qAg
	AlhlqfV7X5K0zNCBR7B56+j+X6YUcEKmN8UmpqpZJ2kqgAg1Vb1JkLX+O3/NDKQFhRfmgh1JZJ2
	Aony9qLOdCjd6cHQxBl/czLCkhiUSpmeofI3QxyzXWWrzP6yoGfZOAi5g95gaYUYewmm7H6aZwd
	jzTaI7Pz231NddmJwf7BvNmeEUPhp71jcdTqLqe6TRgrFL2mrVS5G3iQX7IziXQTolTIAGrM3aV
	X+e4hMGIbmIEas2U0UZaHXO0jVMJP7nzbEuxvGJJcEIrGxPbPElCHZd6e9966VDxLBFhK4hxjaG
	ecu0KHFyBM+8m4W49MxhQnu7aCiQSoT9fix2KW1ov/96at9yhXbFtAlSgMSsYOOP5PQl9sE4hwt
	otUTAydKqbZlkOIKICN/ZQDvbtbkCCa0iJ9NgG7/a82SJk9HnJadW3Bv1U55VIGr95KHr3j1qGT
	sRppqiB4+ikmNRR195H1AXuH6arrtECfgNey7mwtZ+tqgySUtS02ZFjtsmSta7x0wr3LbeCF3AE
	4
X-Received: by 2002:a05:6a00:a909:b0:878:3538:8f7e with SMTP id d2e1a72fcca58-8a9bffd147emr15883021b3a.44.1793871643706;
        Thu, 05 Nov 2026 01:40:43 -0800 (PST)
Received: from mma-H9MHD44.lan ([60.227.235.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09a8c3030sm1799500b3a.16.2026.11.05.01.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:40:43 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH RESEND v2 wireless] wifi: mm81x: report non-1MHz frames on the 1MHz control freq
Date: Thu,  5 Nov 2026 20:40:31 +1100
Message-ID: <20261105094031.812015-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
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

With the recent changes to the Rx handling in mac80211 6d531b9af16e
("wifi: mac80211: rework RX packet handling") mac80211 is now stricter
when validating frames. Our firmware reports the overall center
frequency of the received frame when mac80211 really expects the
control channel even if the frame was received on a wider channel.

For frames _actually_ sent on a 1MHz channel (such as probe responses)
report the true frequency such that the APs channel can be determined.
For all other frames (i.e beacons sent on a 2MHz primary, data frames
sent on a 2/4/8 etc.) are then reported on the 1MHz control.
This enables 2MHz primarys to be used again.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 6f1feb24fe6a..cd0bb4d21acf 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -2005,6 +2005,23 @@ static void mm81x_rx_h_add_rt_s1g_tlv(struct sk_buff *skb,
 	rx_status->flag |= RX_FLAG_RADIOTAP_TLV_AT_END;
 }
 
+/*
+ * This is a hack to workaround how our firmware reports frequencies.
+ * For any 1MHz frames report them directly (i.e during scanning), else
+ * report the 1MHz control channel we are tuned to.
+ */
+static void mm81x_rx_h_fill_freq(struct mm81x *mors, u32 rx_khz,
+				 struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_channel *chan = mors->chandef.chan;
+
+	if (rx_status->bw != RATE_INFO_BW_1)
+		rx_khz = ieee80211_channel_to_khz(chan);
+
+	rx_status->freq = KHZ_TO_MHZ(rx_khz);
+	rx_status->freq_offset = (rx_khz % 1000) ? 1 : 0;
+}
+
 static void mm81x_rx_h_fill_status(struct mm81x *mors,
 				   struct mm81x_skb_rx_status *hdr_rx_status,
 				   struct ieee80211_rx_status *rx_status,
@@ -2018,11 +2035,10 @@ static void mm81x_rx_h_fill_status(struct mm81x *mors,
 	rx_status->signal = le16_to_cpu(hdr_rx_status->rssi);
 	rx_status->encoding = RX_ENC_S1G;
 	rx_status->band = NL80211_BAND_S1GHZ;
-	rx_status->freq = KHZ100_TO_MHZ(freq_100khz);
-	rx_status->freq_offset = (freq_100khz % 10) ? 1 : 0;
 	rx_status->nss = NSS_IDX_TO_NSS(mm81x_ratecode_nss_index_get(ratecode));
 	rx_status->rate_idx = mm81x_ratecode_mcs_index_get(ratecode);
 	rx_status->bw = mm81x_rx_h_rc_bw_to_rx_bw(ratecode);
+	mm81x_rx_h_fill_freq(mors, KHZ100_TO_KHZ(freq_100khz), rx_status);
 	rx_status->mactime = timestamp;
 	rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
 
-- 
2.43.0

