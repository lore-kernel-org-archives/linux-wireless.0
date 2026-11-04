Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755698;
	b=zqncVYsoxAc3rh9YvIk58WMgLB+hCWxVMO5TY+FyWgHLH39lHG+WrmmkY7VTOipK0LKf
	 7UEZcl6L/TOAu79oWVidyOUl4+r3cJKiJHLWbH4BW8RbLgE6fer1lopjHiQMYvN5v6aaT
	 6j1/MKmG/V/ZfxRRSM8sa5giKqHoX52k+FU5mi3T0QrdgVE0tLoklt91aHW9QJouikIqE
	 PGQAJ2NJ/x+CNk8JBB7eReNPT5G0exMR7dF09r8zmADn58YAWbdHQU7e/sMFzDsCK8Xdc
	 jDc2K2MayB/4no8gM2/vwn97ToaFIgZ3w8RIqM76monSKqZTbLqubwOxYGB5Q5qP4TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkbMXVkZ3Y5eO0yM0h+yc4cmF9qGDNZtNTGdXOSbZDU=;
	b=JImRoNqr4WBoM6ExxIIH2r7IHatlJTa0iSmbH3blkL5t0XAVm/Z2cgu2xTxWG9OXBw/B
	 vqsvmq10KXMpf98q1KanIJrHQGiCTaKRHxsdk8BgQk5mqOMaEA73Visiu10lIRNBwmh4c
	 g0tygWXJtGJv+HQqsePhpais6EknC8ye/9esnRaKQ8KU339B4s7K0dU3RZIAuhfCksZNw
	 jHdRaW0lGDLVKfTkXkoMJWyyXw0mfFGm2Tz7w7fEziEbJb/KiUhlCQlRBF0gZKTHQ2rBp
	 /UbpwwulD5EyvYMeJFYD8JxRUFJggH2QqUnafbFCxp+7eWc/Fl9irrPkn+cpwp6b5vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C3tTwDdA;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8B606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5E8B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=C3tTwDdA
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e987a2ba0cso716035ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755697; x=1794360497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OkbMXVkZ3Y5eO0yM0h+yc4cmF9qGDNZtNTGdXOSbZDU=;
        b=C3tTwDdAQuS36JDfHF0HKKcrOff9GwOKIfH/3XseoPebeoxkK0LhYvosGgr5hkI215
         jWYikG6uujuJFLXjlAZsLlVd0haij4ZzF63s4U06Hqj15wk4lo8X8U16FuJByc5MWXoU
         fvUQJGJM8tFubmnGfVYWM/+r2fcHq7DuZ/DUwQAE8J9F694u8mrCHfBqAdGSWCumC3Sp
         5vE8pgMuXJInt4iiflc4YEARYBieDF+vBwR5LIrV6OgJ4dW6MiKU/qpGeEUJkx2ihju3
         AewCF+jY2pd30wX9jhjRWfK6/bqfLtsTpryLARJxb+1+kdYNfYtwKGBp6mBePZvAOQ/X
         NaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755697; x=1794360497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OkbMXVkZ3Y5eO0yM0h+yc4cmF9qGDNZtNTGdXOSbZDU=;
        b=aMkkw57UuVsPcehtEImNj3nZHpr7rOYL/qAZ4VZIcLWs4VCrZ3o1R18Tfy4wUsZc0O
         8N+O65WhA6M6HNqm49sIBWZdw4oNk2DAZKPQhZCSK7E6uf1owLq+ZGwBA1sqtJT09TpY
         Y/Jb8wisVFqqs7DwH7AyOcXXm0gI69mfRmfta3HUk/tZm2iSF1VOEGNqeUkByKhpPFPk
         hL5rrDjofmnBPirGIuCxbmCB/n3wPk64cWToDLw1VlT8cHi6z3xCtMduBnK4+s52+Plr
         CG7v2oQLphYDhjzIO+0ivTUSBNgIyFKaUx3OuXIEbxE6iqjVBRYm/Al+eNTW7vhJ/24Z
         Crbw==
X-Forwarded-Encrypted: i=1; AKwUvBzzgdJz6fr8pPeK89uUPOQOsgZigVBJMdvIWt24WlJPTtlKjtThVLbWTNqfsWY3GkryBLwpCyzwu5v0LC5VqQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+PVkYwUOT7QOhzJHN8Y2Bt+rCpV9CYv6pbtj2HVAyBRiCc5wR8
	TbmO9SdpBk5XMb5AM83HiprunG3rdgNuVx39zmXmZ7kyCGB7EYIjzbRyH+yIoYHPu3g=
X-Gm-Gg: AYBFou3ydU/RWIXsrD3rvMF5R9LwEjWylAvE+0RhCZT8Trn0igZcZ1MqyDfT0waKcrr
	/LhrFnCuKym1dMvaA7qDNyH/2A9Np08ZaEs6TtsBfbD8FJM5uxj+9e2jTe/lNLRHnSX4FIMLV9w
	6XBwU/OYZcFX0wP4h9RbUv6iZ4iDSvPehndwcfyFBq2PvGW/JK/3Z1XTGqCHI+jn6ttusx6SJoY
	kALDiWzYiwR5t+7N0NVgpkMFyFuGRup6wwaFnMttQBi6VEC0t65MM+nB+64kF0iGxoz41WJwHpk
	aj/hlwFuRkMetUPxX2fbrb20P+FSBXVhcEPdbdmYbFWh9RwNAVKW0/jXD4V/15kYlbHKkRikd/B
	d2IuQYLw13OqDOlLkTydwBhWAh3COUaS9UpEI/hW3nFNeHCW9Lm2vYy5OWBT6HJ/0IWNop0cmjx
	+uff2OX+XgXUsolGEHyLDiTkibf4rrSB/58oW7h8rbNcQkRVctWPM9qdSp2cXDbUpZ37AOy1LYi
	Rm2ytfrbSpOwG0LXfPx+cFIqqGlY7bqgMYzBZ7gz+3q6cPsLRJ6H2qawGgliXHmgWk+KKyq2Omh
	6Mm7TVavsCRxHprzxs0wwuMzBmiaLE3/yMthkMgmcQHD+TBioD9Rk31lVQugI7UZnyh+EgRigbM
	0Bd0TPyW+qCTPDU3sPRx1LxtPNykd5KJiUUIyhmhhUugIC80=
X-Received: by 2002:a17:90b:2551:b0:3ac:9d26:5532 with SMTP id 98e67ed59e1d1-3ae8957cf94mr13250091a91.3.1793755697054;
        Tue, 03 Nov 2026 17:28:17 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:16 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Nev Young <neville.young@morsemicro.com>
Subject: [PATCH wireless-next 3/7] wifi: mm81x: mmrc: update evidence only for processed rates
Date: Wed,  4 Nov 2026 12:27:52 +1100
Message-ID: <20261104012756.510424-4-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012756.510424-1-lachlan.hodges@morsemicro.com>
References: <20261104012756.510424-1-lachlan.hodges@morsemicro.com>
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

From: Nev Young <neville.young@morsemicro.com>

When only one packet is sent at the sample rate, its stats are
processed but its evidence (a measure of whether the rate has recent
stats) stays at zero, because the evidence is updated before the
final decision on whether to process the stats for that rate. With
zero evidence the rate is skipped as a candidate for best rate, so
the rate never increases.

To fix, update the evidence only after deciding to process the stats
for a rate, so a sampled rate with valid stats is considered for best
rate.

Signed-off-by: Nev Young <neville.young@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 38 ++++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index 3f87b50ce391..bad4fec03d86 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -1067,6 +1067,13 @@ static void mmrc_process_variation(struct mmrc_table *tb, u16 current_success,
 	}
 }
 
+static bool enough_stats(struct mmrc_table *tb, u32 min_stats, u32 index,
+			 u32 attempts_for_stats)
+{
+	return attempts_for_stats >= min_stats ||
+	       (attempts_for_stats > 0 && tb->table[index].prob > 0);
+}
+
 void mmrc_update(struct mmrc_table *tb)
 {
 	u32 i;
@@ -1078,6 +1085,7 @@ void mmrc_update(struct mmrc_table *tb)
 	u32 success_for_stats;
 	u32 min_stats;
 	u32 throughput;
+	bool process_this_rate;
 	u32 evidence_sent;
 
 	tb->cycle_cnt++;
@@ -1111,19 +1119,6 @@ void mmrc_update(struct mmrc_table *tb)
 
 		scaled_ewma = scale * EWMA / 100;
 
-		/*
-		 * Only count new packets for evidence if we will process
-		 * them
-		 */
-		evidence_sent =
-			tb->table[i].sent >= min_stats ? tb->table[i].sent : 0;
-		tb->table[i].evidence = calc_ewma_average(
-			tb->table[i].evidence, evidence_sent * EVIDENCE_SCALE,
-			scaled_ewma);
-
-		if (tb->table[i].evidence > EVIDENCE_MAX)
-			tb->table[i].evidence = EVIDENCE_MAX;
-
 		/* Try to use statistics from acknowledged AMPDUs first */
 		attempts_for_stats = tb->table[i].back_mpdu_success +
 				     tb->table[i].back_mpdu_failure;
@@ -1142,8 +1137,21 @@ void mmrc_update(struct mmrc_table *tb)
 			success_for_stats = tb->table[i].sent_success;
 		}
 
-		if (attempts_for_stats >= min_stats ||
-		    (attempts_for_stats > 0 && tb->table[i].prob > 0)) {
+		process_this_rate =
+			enough_stats(tb, min_stats, i, attempts_for_stats);
+
+		/*
+		 * Only count new packets for evidence if we will process
+		 * them
+		 */
+		evidence_sent = process_this_rate ? tb->table[i].sent : 0;
+		tb->table[i].evidence = calc_ewma_average(
+			tb->table[i].evidence, evidence_sent * EVIDENCE_SCALE,
+			scaled_ewma);
+		if (tb->table[i].evidence > EVIDENCE_MAX)
+			tb->table[i].evidence = EVIDENCE_MAX;
+
+		if (process_this_rate) {
 			new_stats = 1;
 			this_success =
 				(100 * success_for_stats) / attempts_for_stats;
-- 
2.43.0

