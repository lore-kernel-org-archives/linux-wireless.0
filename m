Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3B380FF7
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809447; cv=none; b=KI/UbLuI7jLCADVIZEPky3cNV8y2WeeKvPIj3uhZyKoaqDMv84kUtyzByxO8+I/3rNoiT028USQ+LbHfj/4Ei/N/KGpWqxN63zpM9m9ECW2rTkTGCB0BFjJpTijyCDjrnIUYIt/YI1uawW4sZsAUUdDgsJ1YCSZopoqz3zLgleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809447; c=relaxed/simple;
	bh=8crAIJoAuebtxqfOKD4HdNTnWC72FJap0At4o/ON4fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CYt+qdnIM8ycs3gIsZFeljdpbm4d2kduNDvqESAF8AZPb0QD/gS1zceuPvTIzJjGpzl80f9Ksa7Ofw2UijOKsfJeMD8lNKPwzmGgF35sazJ7a0K2qODx7cvm9/l6oWGB+oaJsUhvWO2BIGW4JiFjC8RBT3XQoDvYz0HFP0KOy2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=K2Vd0dkY; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="K2Vd0dkY"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-396b3d0df94so207345a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809445; x=1788414245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5f3VYghEXPHEvB4XRiI3gdc+opvSBjO+Y9ffMajf6nY=;
        b=K2Vd0dkYfYtKvloZmkjck0ynsXdhMW7M1+OzGBVMccqZrUhXZO5upwJFPxN31x0X/x
         mdM/XmmBawtz6pQny+bGQqMEM5MjY1+a7Sjiuke6xxY6PtT52A5fBbOGyEB5NwbEDcli
         9hpB1s+B/79hhanistZXnlhPITunziCiA0NhwSx6XduBviDxjaBGSeO8pYrxr2Yz0jNl
         43fbdV+ujcldC5SebFHpEolrI+B4EHhvM0h1slqu7bihPAdnL90HPXISeXIHR3EiS2+W
         5DQlqdvLcY3fK24Zsf0AvpgzExk5EMKceUHBK7he/QsGhvtl/tdjpSdCb3jHbFyJ5XZM
         309Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809445; x=1788414245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5f3VYghEXPHEvB4XRiI3gdc+opvSBjO+Y9ffMajf6nY=;
        b=YCoSX25n6FWqopBxnL80/olzl9qRQ0iBUIKaCHOXEuMHUvYJXxNYH08lgMmqXUZaS3
         ywIrzGGT9VhRskueuKCHTbPDoiuJPrR2tPqCrjC2NfGjFaSHemxGsdN4P9phA1ei3r/s
         TvXrkq5qxAskWxda63WQ6QeQO03B60qIT84C1FAKI7buC0KGhOka4FTf1UqZk2kULzFG
         p1cZ/eFZr4JydjzaQUktONd5cIIk+vWKkqSOMi0juQkFq8ZixA6zRe7h+NdO755OtvT4
         dMg6eFVLe0bsSsY2H4L42iM5X0i6HZCmS5qOtwNqKcCJ4y6TeRKarouumq+Tz41/IGWu
         JDng==
X-Gm-Message-State: AFuF++lTHOnqZaX6go364WYvVgFM7gcVRvji7zS/MnH1qBfasHPNdwuw
	1FbyUzLICvSBC/6pLMYLvyrlRGRlK1WzGlTDjQunz2tMkiKAXsc6ox+PlaSKKOKF/Hy8q7ngAl6
	cjTDz8ZM=
X-Gm-Gg: AR+sD10c5gQN0vQef5p5WzGb77IDbYcxhPcNLWiXrzsX7MrQOKjNH5nnITOGJOH3FAf
	lb+jMFEBClDYbK2sd5K/Yptr/GTd9zHBu9NuYwd/IIb7RW2mviJKiQWEwAQHJk+yhDfUfan5WwX
	dbxITf9Zh71SbbY6r86UIcQ49N5JCeVptnec3dSwTwskfEKePso+gJFXCWBuHNu9glct1w+YOQ6
	pn2WPBVlVJLii056u2Y5cqaLtM5+rbISCgV8KMxfMoKsgV7zZBkdtIsmmqeVF7zsgbPZfqpG76z
	0n7jJynMkiUrpUiyJPo5IIiM6III25ObGJCNFaZfl7nNr62egqEJaJIjJE4SRNkdvIjfJyxrDW+
	h+ggSn1/oEWqtfvVTzELQW6sIajlMgM1Fh2gLovowd3OlcM4kVIKjikKeI+i5Se65cA9fGqN8DT
	GOgvZk5oa3csokbMcoGdlGBezx+LFSvw5VqsnnQgkUoPD+HqFnszTb/FYcDCsc6pMzYv9oQXgMC
	DC1oy30FxqLsrq/zLBVTuRA3ylWI+d13GTre/t/cpTt2RUSisqKG6YqQ/DzjDbG7RYylgzwJI6x
X-Received: by 2002:a17:90b:3b4b:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-3966d8b6295mr25420486a91.14.1787809444705;
        Wed, 26 Aug 2026 22:44:04 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8e118fasm12046923c88.0.2026.08.26.22.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:44:04 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless] wifi: mac80211: include TIM bitmap control for buffered S1G mcast traffic
Date: Thu, 27 Aug 2026 15:43:02 +1000
Message-ID: <20260827054302.254124-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently when building the S1G TIM element, we only build the bitmap
control if we have buffered unicast traffic. Since AID 0 sits within
the bitmap control if we have buffered multicast traffic with no
buffered unicast traffic the bitmap control won't be emitted and
dozing stations will be unaware of buffered multicast.

To fix, only exclude the bitmap control byte when we don't have
both buffered unicast and multicast traffic.

Fixes: ee6360945483 ("wifi: mac80211: support block bitmap S1G TIM encoding")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/tx.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a1e2c9e1565..3896c7b2c4e5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5089,10 +5089,18 @@ static void ieee80211_beacon_add_tim_pvb(struct ps_data *ps,
  */
 static void ieee80211_s1g_beacon_add_tim_pvb(struct ps_data *ps,
 					     struct sk_buff *skb,
-					     bool mcast_traffic)
+					     bool mcast_traffic,
+					     bool ucast_traffic)
 {
 	int blk;
 
+	/*
+	 * if no unicast and multicast traffic don't emit a bitmap control
+	 * or pvb
+	 */
+	if (!mcast_traffic && !ucast_traffic)
+		return;
+
 	/*
 	 * Emit a bitmap control block with a page slice number of 31 and a
 	 * page index of 0 which indicates as per IEEE80211-2024 9.4.2.5.1
@@ -5101,6 +5109,10 @@ static void ieee80211_s1g_beacon_add_tim_pvb(struct ps_data *ps,
 	 */
 	skb_put_u8(skb, mcast_traffic | (31 << 1));
 
+	/* If there's no unicast traffic we don't need to include a PVB. */
+	if (!ucast_traffic)
+		return;
+
 	/* Emit an encoded block for each non-zero sub-block */
 	for (blk = 0; blk < IEEE80211_MAX_SUPPORTED_S1G_TIM_BLOCKS; blk++) {
 		u8 blk_bmap = 0;
@@ -5182,25 +5194,16 @@ static void __ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 
 	ps->dtim_bc_mc = mcast_traffic;
 
-	if (have_bits) {
-		if (s1g)
-			ieee80211_s1g_beacon_add_tim_pvb(ps, skb,
-							 mcast_traffic);
-		else
-			ieee80211_beacon_add_tim_pvb(ps, skb, mcast_traffic);
+	if (s1g) {
+		ieee80211_s1g_beacon_add_tim_pvb(ps, skb, mcast_traffic,
+						 have_bits);
+	} else if (have_bits) {
+		ieee80211_beacon_add_tim_pvb(ps, skb, mcast_traffic);
 	} else {
-		/*
-		 * If there is no buffered unicast traffic for an S1G
-		 * interface, we can exclude the bitmap control. This is in
-		 * contrast to other phy types as they do include the bitmap
-		 * control and pvb even when there is no buffered traffic.
-		 */
-		if (!s1g) {
-			/* Bitmap control */
-			skb_put_u8(skb, mcast_traffic);
-			/* Part Virt Bitmap */
-			skb_put_u8(skb, 0);
-		}
+		/* Bitmap control */
+		skb_put_u8(skb, mcast_traffic);
+		/* Part Virt Bitmap */
+		skb_put_u8(skb, 0);
 	}
 
 	tim->datalen = skb_tail_pointer(skb) - tim->data;
-- 
2.43.0

