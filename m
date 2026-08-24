Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68253442B0B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581483; cv=none; b=fnoBZnsuL1OMKMZKZaB4LEjUi42JimYiy0pPQUWxFCe7SEr8j7wURj6OSvxEFUrtnu/zpP5n92ZJP2KCKyg3eEJyZteNGw8dcTuSuhvAoDltbv0zd4h6YASLOqjCBBc5ZVPdFlyDEyytqHSGGLxLTHsxCGUItJ1dLQGRAXY3LlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581483; c=relaxed/simple;
	bh=MF+DnDe8aJ5XgnKcnXq453XIc1OVOO6nS7wXuWcPd2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cUja8iTTMeGUtPU6Crm4oe71RhxweRodu/qKpKp+R0By3f1LZeQ7ZBx41Cx9KvKLfhtq8k/rGdQCyAM8mZ16s+tpNAouBAYFBMcoFHOqkOiK5zpzfmNy1+iPwnVz6LTF+jCgbvg3Lz0mbtgaAdm9JH8+iTvBnA/jc2IOM69MjEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=vPC0fqbd; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="vPC0fqbd"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso6117365a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581479; x=1788186279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FN5xO+nm/QJGSgJgixTP6QEXB8xMuOkSacPYjfD8cDQ=;
        b=vPC0fqbdwmgyt7MFmH9inNcVZgwJSZiO2FIrNtaY/Fyg+ZVRhvYg9berUGwmCWAcY1
         h5SIZg3w1fNvb/QaPugZwILX+vEzOiSg17DFhGOHjLdxMWkCXDDSJBVmIEvZ3ycugN7c
         ago+71QLjatfPF6045DFvFuYWo7Hyk7ryimYDLS5XHJ0V8hBPLkQAs2zMxjhtheOu9wj
         vr6Sz9Xb2JUP1rpiMbBWqJ7cUnMqej0ndaGSuFJf5HZ37wTNA467mddjhyLfpjJz6DAY
         z4Ej6GkzVZTgQSF/+tgSKW9zwpQvgjb3fwe3Z+MhNMKhY7vTNDcHEgSSCdx89Ww+MfgJ
         pdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581479; x=1788186279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FN5xO+nm/QJGSgJgixTP6QEXB8xMuOkSacPYjfD8cDQ=;
        b=VB/rZAwXFZ724+BN1ko/A8xkbUMcv8Lvoqk9a4dUgZ0Nhjom1uq9zEzHsA9zGddSXz
         +GrZnEE6/QAkzA3kf9QGGSrHjF8QSdzoPRx8BxV7GTDvywrSlvOKBOeaC3tigcl03wVG
         8vt9E/g5WwKWRbHht35AiFHC8dJBK6dVIq09j+SFMSAW8Eaique0Am272dZrmOt32bgE
         Jt19Rs+CmIWJwzO7cQn06JeL/4TZ34d9H0rnhTpNCh6z0z4txvbgnoYXQBN+y+F9y6Uk
         LCcCoqEInIRI1cL7B19SeOg4dgz/DeI51POfww0w54WVDcCQWV7XDx3utwisfwlpgx4v
         7BxA==
X-Gm-Message-State: AFuF++lmQ+ZH0mdotf1b3GqA9BkbLxvt9nPI2ZvRI5TQx7Rqut+ZM9ww
	hM6Subgn067xoh9cTp92AZsHYz9LPLDWWWT6FlZ7TQDOr3EhYJkUhTBNWQ5+WHY0aw==
X-Gm-Gg: AR+sD13F1gnXRD2KOZLUiWneFCcDU5AbVeV6PJ1DvN/BuvSmGWGEUTjriuSIhJgTnMO
	RIwSbYuQflJ30zDBfQPPLz1zClxJrzTwYdpbPCQTsiablbqYNrpTjK1gXSTr2+EBZkQFG9sw9fi
	oBuYd3fgp+aKLcnu6BO8xyVqgtK2u+jMa3VWbR87G5356fKUWBznezabxp9WDpHIJfAxo0yAYlP
	9zax9TQL+tQKAH0PNC5IkQfdp1Xv3VRWYaHxcaLkaEyOx7ohxCn1GEWfonTzbDGarlqf3XnOxbs
	wS5dZEgNSv5jnGU0HRnUpE5x3Bjkreif69O0K1hE5M8Dq6BBDVKX0yHMcUV/UcJiIwFhWu5uS70
	BUntr5znUTrNfzwMH4JY6LHyBx8hfT3mStz1rLZba72DkAYnK1SFg6hjeaNQwrY7qqmpFDiiPgM
	igVXrV1AuPAZHXIdzHbizoq4B+GLmPOv6TDNNBUA4aOTQsGYeeMUZ1b6+BOikpHwCw8aIJTF41W
	GCn1fiPsbFWWcubfZc2Jmo3RVWMmg20M0Rfq2TQKyo5wcu3ZRl33RfoGy2UpEKnmE0S09fkoA5L
	qGMLQg/OPylhY9g0uBOGetGZ59Z2l7B8pflui1CW/Dy/27GNt15PcyyVcJpQwff4i7ewnHnU1jD
	pDUhXfPt3fRK14a9/kOqosIZw8wYd4Di0WjLOV5dpG3r3QnVz+lvFxsobfqm1s/o6SDWJ9kbN
X-Received: by 2002:a05:6402:2382:b0:6a0:ffb0:273b with SMTP id 4fb4d7f45d1cf-6a42eebff97mr27740389a12.0.1787581479557;
        Mon, 24 Aug 2026 07:24:39 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e1d741asm8936995a12.27.2026.08.24.07.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:39 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH] wifi: mac80211: scale the airtime queue limit by the station's weight
Date: Mon, 24 Aug 2026 16:24:35 +0200
Message-ID: <20260824142435.1757391-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The airtime queue limit is the same for every station, so on a driver
that pushes a whole scheduling selection into the hardware, every station
is allowed the same airtime in flight and the deficit round robin can
only decide the order in which they reach that ceiling, not how much of
the medium each one gets. Setting NL80211_ATTR_AIRTIME_WEIGHT then has
no effect on the airtime a station receives.

Measured on an IPQ8074 access point with two stations on one radio, a 1x1
VHT80 client and a 2x2 HE160 client, both saturated from the access point
at once, BE aql_txq_limit at 500/1000 us, three interleaved runs per
weight with the association verified unchanged across every run. Without
this change the slow station takes 44.4, 43.9 and 44.0 per cent of the
medium at equal weights, 44.0, 43.5 and 44.4 at 1024:256, and 43.1, 43.4
and 42.8 at 256:1024. The weight moves the split by less than the spread
within one setting.

Scale the per-station limit by the station's weight. A station weighted
above the default is allowed proportionally more airtime in flight and
therefore takes proportionally more of the medium. A network that never
sets a weight is unaffected, since every station keeps the default.

The same pair then reads 42.1, 43.3 and 42.8 per cent at equal weights,
78.0, 78.9 and 77.2 at 1024:256, and 19.6, 18.3 and 20.0 at 256:1024: a
4:1 weight produces a 3.6:1 airtime ratio and 1:4 produces 4.2:1. It is
not free, and over the pair the aggregate is 557 Mbit/s at equal weights,
925 when the faster station is favoured and 337 when the slower one is.

The low limit is consulted without reference to the radio total, so the
scaled value is bounded by aql_threshold. Without that bound a weight of
65535 grants one station 1.3 seconds of standing airtime on the default
low limit, which no total accounts for. The bound reaches the high limit
as well, where it changes nothing: that check already requires the radio
total to sit below the same threshold.

The bound never reduces a limit below the value configured for it, so an
access point that raises aql_txq_limit above aql_threshold keeps what it
asked for at every weight, and scaling a weight up cannot scale a limit
down.

That bound is also the ceiling on what a weight can express. At the
default low limit of 5000 us it takes effect near a weight of 1229, so
ratios beyond roughly five to one do not resolve: a weight of 65535
against 256 asks for 256 to 1 and delivers 4.9 to 1.

This changes nothing where the limit does not bind. A station whose
pending airtime never approaches the limit is not held back by it at
either weight, mac80211 holds no backlog to arbitrate, and the share each
station gets is decided by the hardware's own scheduling.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
The measurements were taken on ath11k with the series "wifi: ath11k:
airtime queue limits, fairness and a driver TXQ scheduler", posted
separately to linux-wireless.

 net/mac80211/tx.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a1e2c9e1565..11350133d637 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4223,6 +4223,25 @@ EXPORT_SYMBOL(__ieee80211_schedule_txq);
 
 DEFINE_STATIC_KEY_FALSE(aql_disable);
 
+/* The airtime a station may keep in flight scales with its weight. The low
+ * limit is consulted unconditionally, so the scaled value is bounded by the
+ * radio-wide threshold rather than by the weight alone, and never below the
+ * limit that was configured.
+ */
+static u32 ieee80211_aql_sta_limit(struct ieee80211_local *local,
+				   struct sta_info *sta, u32 limit)
+{
+	u32 scaled;
+
+	if (sta->airtime_weight == IEEE80211_DEFAULT_AIRTIME_WEIGHT)
+		return limit;
+
+	scaled = mult_frac(limit, sta->airtime_weight,
+			   IEEE80211_DEFAULT_AIRTIME_WEIGHT);
+
+	return min(scaled, max(limit, local->aql_threshold));
+}
+
 bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 				 struct ieee80211_txq *txq)
 {
@@ -4244,13 +4263,15 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 
 	sta = container_of(txq->sta, struct sta_info, sta);
 	if (atomic_read(&sta->airtime[txq->ac].aql_tx_pending) <
-	    sta->airtime[txq->ac].aql_limit_low)
+	    ieee80211_aql_sta_limit(local, sta,
+				    sta->airtime[txq->ac].aql_limit_low))
 		return true;
 
 	if (atomic_read(&local->aql_total_pending_airtime) <
 	    local->aql_threshold &&
 	    atomic_read(&sta->airtime[txq->ac].aql_tx_pending) <
-	    sta->airtime[txq->ac].aql_limit_high)
+	    ieee80211_aql_sta_limit(local, sta,
+				    sta->airtime[txq->ac].aql_limit_high))
 		return true;
 
 	return false;
-- 
2.53.0

