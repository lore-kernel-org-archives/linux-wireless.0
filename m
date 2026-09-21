Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD5434408
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790014623; cv=none; b=Dy0SdxGpVFOCQTKzJMbqk2gng86SstLPeadOP3RzkQaRfY/fWX+C38EUPF8AKWP98qZZXiKaV2ut7qs0wI7KCdcsN9ZCwzSKuEm6Ub5L4LWm1TOroOeOpAPc9wvonfgkZuBtUSr5cXyg/xV/rK1km04vZtK4OdAe4+eWWxQbUHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790014623; c=relaxed/simple;
	bh=FdC/oxJN5BIlLDL9YRHCYzZFEg5WvrOGwndhX9T9ajA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pKoKoOujKbGxEoqW9r+xXSGRalyJqZUOylZPD9rNHyeQ+dJGZmVSYNmuUNRV0pDXZumtvAiN0MH7aSCX54vua8TummaIKfDhzDgIP2LQIvzO6Q6ZQBBDAuqvbL24XKIXrnAU7TEQ14LfKpcGx/OswFJ4rn27VPbegGCi2+2ra9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jasonrussell.io; spf=pass smtp.mailfrom=jasonrussell.io; dkim=pass (2048-bit key) header.d=jasonrussell.io header.i=@jasonrussell.io header.b=Lbda2OLA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y48shPNT; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jasonrussell.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jasonrussell.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jasonrussell.io header.i=@jasonrussell.io header.b="Lbda2OLA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y48shPNT"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 319637A00AD;
	Mon, 21 Sep 2026 14:17:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 21 Sep 2026 14:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jasonrussell.io;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1790014620; x=1790101020; bh=XBru9skSse
	WyN5jfflW/TOCldD0d3wGrT1j2W8gW8H8=; b=Lbda2OLAp97bftx2LbgCWjx6aW
	f3aXLhZoM7rAQBPi9ANx4At11O1p230U5S8n04G67DC6kHwGC3ow055lsjYMVfQJ
	Q8mIUqUJaiAC0p+NBMcn38yHxhCXG/xzSbWO5MCLaNNUsie4SecIgFUVSPv4qpKr
	MTuCcmAUX34eQ139bXB/oWir1p7y5w3qehlTrydA+ycx/Re7HlsvL2zLV4wbOAuY
	v3ZgbMd/Tjs1xmfo2c/rFXt7y/rRr7dBaz+smVTSGO65Z91GzRbxUo1h7eNbg4RS
	FVpEMCNpORv80/afYbEyhb1oqzJRbK2i93wK3hfief2N+tgaOvWLRlu/1otA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790014620; x=1790101020; bh=XBru9skSseWyN5jfflW/TOCldD0d3wGrT1j
	2W8gW8H8=; b=Y48shPNTvoza5QwIln7WHW15VHr79QCEDp/zNgiyjsV5vdIyR0H
	nSFXqr2xJBbkYsqHl7PJZLlTYhfdOS7zl9WQYY1penyiBojHne/5AI6WlwBeJjQV
	gE9DzK71ZfF1A2+Z0w8bDTWHaOdtDNlATkBwGQrSXntvfwYWeY1nqnJPbNXGD8bV
	/1INjDwUjchJIzZA6UCLCKZvwqUq4rIB7lnGurYIi+sJKGJpwblRiwOPch4SrBGw
	3pZOAtVKpQIcLNCW/miMLMJMhXolHbJMV1uvymQKqok/h13mjHF67ebTkQYuXkEX
	EpSX/K4WY6nt7nR4YA4X3Shw4Bt61Gkpwnw==
X-ME-Sender: <xms:m3SxaozOWYppQqveuGu3lhF3EUq7VcygV0GTm0J2DhJTyHyoNB4ezg>
    <xme:m3SxajR6DczxA-C2Zqb9tTYOhVHT6fEpyP5mq7uiwULROKxmpx_Q3eje135yBzw2D
    rzzvPC-VVnYQTId0uA4gzwdIl_wA7MFdcIDDfCJtBadz4gzXx5X8mA>
X-ME-Received: <xmr:m3SxavXNYSsjuQcbW9Hoz_DYBVUVi5I2AOSkGmg4Mzc34cbIjHgBbkdOwJd_V6hCSh7scSi73GHzOvhC_O3099QT7uVCjBRUINlj>
X-ME-Proxy-Cause: dmFkZTGVC8vVnpGw0Or/5uSakVqo6bQQB7+rjqZHc1iOfGWUrczIRbedPtP04/iTBtbgrM
    WSpf+lJFgb6b6nGlTRMoA0wMDvNs8AjnRI8RkL0IpTNFvT0RrpR8DVrEP9Ub5e+fvPRBux
    r3WUyozGTAFg/NxXT57q+HXjjpmO/b4DYOFTcF0XDjVDyDNhv9NwJ2rmPD5noubdXVQIwK
    kSklXzyDR8fM4NCButvbyy+ghfpURa6XJLwXaw3zIwDn4dZtQBzTSuDZrtYtlnbCMlfKy3
    41jyIumfsCzOTpY00Y5IQTQjI5jAylZo6Et2q1p3m4qBPGW6QsEODZXU27MYdQ0k6lE7Cl
    esuZ+czyVBxtxhpcdIU3wyqADyy3UBenIp5ZFPGwjkj0TUR+vWTRVtHztjCYutBhMTALh6
    dZmC4vyv1FKBEbahrZcD+KBFhm+c/OHBLYjUSTG9OmKwUfiLN7Kzp4Sl9ul8akTOb+mmoq
    bb6kkMWfvM2I1olEELz9CjN/nAxRuvx4UBHU9rjrlf3LElyZQn6mZF46gseDP4FBuEsFBK
    PA+Gxp0MkjQ0BLJiVegpNH/hnehpHQRnb8fuMC8K/GwBsysYKk+6h6vCFxm1ZzxvuiUKEV
    aM6XawFnIMS+sZXPXevUonNclZdoYggKUEX5+tuRJPa4/ndSJdApK/Ez0upw
X-ME-Proxy: <xmx:m3SxalbdqoTXg5SIybW8FC-YqcgKDm9f-Xkupr5KFm-fpiqAK1In8g>
    <xmx:m3Sxal23JEyYDBnMBN0vxnXt_1i6MAdQPYBCZZo86657KRWNrBJ21A>
    <xmx:m3SxanjusWZzQPZW3mB3Brhop-0s0VDzJHp4MkG6QeB8WndxQ-_PgQ>
    <xmx:m3SxapZsjQSPm4EE8PLNI_TsXvqWyM6sWbwXr1tHPiIRmIiWv-_0NA>
    <xmx:nHSxavii1XKowJm-KFelL2Qh0iLC9U_tr9_xQlLhcAg8UBTuutDxlijj>
Feedback-ID: idb6946d0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Sep 2026 14:16:58 -0400 (EDT)
From: Jason Russell <me@jasonrussell.io>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
	Jason Russell <me@jasonrussell.io>
Subject: [PATCH] wifi: mt76: mt7915: ignore backwards channel MIB counters
Date: Mon, 21 Sep 2026 20:16:56 +0200
Message-ID: <20260921181656.51668-1-me@jasonrussell.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7915_mcu_get_chan_mib_info() adds GET_MIB_INFO airtime with a bare
unsigned subtract. The counters are not monotonic. On an MT7981
(Zyxel NWA50AX Pro, OpenWrt 25.12.5, ~3 days up) 5 GHz tx survey
time read 18446743827918618 ms, which is 2^64/1000 minus 245790934 ms.
That is one wrapped subtract of a counter that stepped backwards by
~2.458e11 us. Later samples were sane (5 GHz tx +5192 ms and 2.4 GHz
busy +8299 ms over ~99 s) and only added to the wrapped total.

mac80211 exports the total as survey time in milliseconds (div by
1000). hostapd_single_channel_get_survey() updates BSS Load only when
channel_time is both newer and greater than channel_time_busy, so
utilization freezes at the last value from before the wrap.

mt7915_mac_sta_poll() already records a zero delta when a per-STA
airtime counter does not advance, and keeps the new value as the
baseline. Do the same for the four channel accumulators. A counter
that does not go backwards still contributes cur - prev.

Not clamped to the ktime since survey_time. mt76_update_survey()
advances that stamp even when GET_MIB_INFO fails, the command's
timeout is 2*HZ, and a failure does not move state_ts. The next good
sample is then a real multi-second delta, and a clamp would drop it.

Closes: https://github.com/openwrt/mt76/issues/1135
Assisted-by: Grok (xAI)
Signed-off-by: Jason Russell <me@jasonrussell.io>
---
 mt7915/mcu.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/mt7915/mcu.c b/mt7915/mcu.c
index 1235662..8d22387 100644
--- a/mt7915/mcu.c
+++ b/mt7915/mcu.c
@@ -3192,6 +3192,26 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy)
 	return 0;
 }
 
+/*
+ * GET_MIB_INFO airtime counters are not monotonic. A bare unsigned
+ * subtract wraps to ~2^64 when one steps backwards, and chan_state
+ * keeps that value because later samples are sane and only add to it.
+ * mt7915_mac_sta_poll() already records a zero delta when a per-STA
+ * counter does not advance, then keeps the new value as the baseline.
+ * Same here. Do not clamp to the ktime since survey_time: that stamp
+ * moves on in mt76_update_survey() even when this command fails, and
+ * GET_MIB_INFO is allowed 2*HZ, so the next good delta can be a real
+ * multi-second step.
+ */
+static u64
+mt7915_mib_delta(u64 cur, u64 prev)
+{
+	if (cur < prev)
+		return 0;
+
+	return cur - prev;
+}
+
 int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch)
 {
 	struct mt76_channel_state *state = phy->mt76->chan_state;
@@ -3201,7 +3221,7 @@ int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch)
 	struct sk_buff *skb;
 	static const u32 *offs;
 	int i, ret, len, offs_cc;
-	u64 cc_tx;
+	u64 cc_tx, cc_rx, cc_bss_rx, cc_busy;
 
 	/* strict order */
 	if (is_mt7915(&dev->mt76)) {
@@ -3248,20 +3268,22 @@ int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch)
 		cc_tx = __res_u64(1);
 	}
 
-	if (chan_switch)
-		goto out;
+	cc_bss_rx = __res_u64(2);
+	cc_rx = cc_bss_rx + __res_u64(3);
+	cc_busy = __res_u64(0) + cc_tx + cc_rx;
 
-	state->cc_tx += cc_tx - state_ts->cc_tx;
-	state->cc_bss_rx += __res_u64(2) - state_ts->cc_bss_rx;
-	state->cc_rx += __res_u64(2) + __res_u64(3) - state_ts->cc_rx;
-	state->cc_busy += __res_u64(0) + cc_tx + __res_u64(2) + __res_u64(3) -
-			  state_ts->cc_busy;
+	if (!chan_switch) {
+		state->cc_tx += mt7915_mib_delta(cc_tx, state_ts->cc_tx);
+		state->cc_bss_rx += mt7915_mib_delta(cc_bss_rx,
+						     state_ts->cc_bss_rx);
+		state->cc_rx += mt7915_mib_delta(cc_rx, state_ts->cc_rx);
+		state->cc_busy += mt7915_mib_delta(cc_busy, state_ts->cc_busy);
+	}
 
-out:
 	state_ts->cc_tx = cc_tx;
-	state_ts->cc_bss_rx = __res_u64(2);
-	state_ts->cc_rx = __res_u64(2) + __res_u64(3);
-	state_ts->cc_busy = __res_u64(0) + cc_tx + __res_u64(2) + __res_u64(3);
+	state_ts->cc_bss_rx = cc_bss_rx;
+	state_ts->cc_rx = cc_rx;
+	state_ts->cc_busy = cc_busy;
 #undef __res_u64
 
 	dev_kfree_skb(skb);
-- 
2.54.0 (Apple Git-157)

