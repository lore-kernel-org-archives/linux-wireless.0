Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755693;
	b=I78kr8Ib/Hs90gwYhVlTUBaV6P3tk7CULNC/aqDmQ17zEAjs+hiZY02L2xH0GEG9dagG
	 N8W9poXIQ7SPMC0zBU7IjqbtuJkMPx9+s3HKAoF3KiHaakMtzhig2mKufRt4EZvxdRixa
	 gCAX9ytZ2j5HObjRudJTjovz0tt2IYrAniS+U4xxAmYZ4B9auX0DjobenW+qCZfefa2Tk
	 CwhM2mK9EfZrtnoRVM2G9cgT6LLgJnx+ABthFEb9wK8zZ3fNkiOYfWv+s2s1IZwW6BKFG
	 QiSALXRuuDIEWgcJ6ItFT4tgJhNxRi1aJDLJcacCRKQOtAVbV02x8cThDqP33YUKhmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755693;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wifFC+wyOJMovxE3828WxrmMus0wAd2rUXYnI1zZtmM=;
	b=qHdHrtfxt2y/xvuRKJJmTlAv94XCA/Wu4WfSI5SE3vAzP0kiQDEs29UTMzu3iiDmC3q/
	 GsypeJn2TfkhuMxjwAg7SN5/gZrI+vn0E8IyCnj4zRhb6vd4DCu98OLEu4qrzzwy8yt41
	 qL41Z091EKRLNGfmaBPqQ2YW+EolP4KQujqMJ9VZD49S4fN8RZ8s727k6GxzRGhL2eMX0
	 I/LQsnK7ZTSPtHsEq3z7St59yIXV/mLizhgTuKsaKVVeAlWB8znXFBKzqP+NgjlJb2IUG
	 oe0HHj9VmKcYh1dbBF1YvKooMfm7iUHjjzdXi/2LGNyFphQkmKwD9wAo+lvDZVq+rYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HhVi2Qbo;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60FF606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B60FF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HhVi2Qbo
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc758830601so134691a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755692; x=1794360492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wifFC+wyOJMovxE3828WxrmMus0wAd2rUXYnI1zZtmM=;
        b=HhVi2QbohIdASlM4gPVE8id2XJUl2lSdxD7ixBSDyOiNJQ5KKH175xoCvYc6xXpkbU
         LFGEv1xibyj7afSXfHL7a9VDLz1TknfuEX78n2vlGsZgMVN4CuPIllCnkNxbMjboFqIF
         ja94BgHm6O1W0LL+o/w5P6oVB/0nZnUWIZzZhPMg9TfLHdd2ID+8cutlX+ajlqPSXFY6
         QsH0XqrdJf4471vvxo9peZyrEeEPthBAktXn0cvgF1TgLEM3mZzVZ6NwXnawD6wwFxIG
         RNz/GgUAKx0bPMLaDTYpmMWo1gaI7EYiV+918vkLG0zmEU7jJKhGZ9IOVmCv/pg91exf
         mE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755692; x=1794360492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wifFC+wyOJMovxE3828WxrmMus0wAd2rUXYnI1zZtmM=;
        b=O3CEntd8HYoZ3vuHwoja4Crfuer/NSV14m+oH1zrnSznViX/Mcp3xyu7KIUMjkciuY
         hWkOK0s6JqGkcL1ctbFS2/N+eORdKjLjQqtfts0lIzgG0g6LXbapqNGN/kALIhJ1MGe6
         1qKZeg2Im73fU3UJZ6CVf+Mq329PIwRo4IXJ51TEH2bRXJgMjccvRW2iYOHwa7VephdW
         cD7cmAIvkiu7Hh4Xh3q8BjMvfJ4ciSY5IwK5bTAF55VPKtxmTdakUrW9IawKrPwRfl7k
         pLUjMszadpVFFz48IyR12cNomXGNM5PzhPSexXovNxrhXoskar7IDPyNXSAd5VpY6roH
         pTNw==
X-Forwarded-Encrypted: i=1; AKwUvBxCovTl/8HWLtNFJGlcrsjSKbNbU/AaCqA16fo6rvYXBElE7xcy5GtopLeDgO4BN5PZ22YoXg9qexoObly+aQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+NsR6gElII042zkAUKFKft0mkyRgbA84MqhfJ2mCO0lHcsWkCg
	sGnD8SSgyFL5TcEkeJIdhTURHKqOGlR4V3G7NFrwOkj+YEdVmi+43eg9p17W7RjFdEzayGSWhwM
	VBx3wVnE=
X-Gm-Gg: AYBFou2rUqRYLFwH2C4+ivnKDqZEUpTAUKydQMrxsemKHlPQ6MolXTRPEgE0dNzu+Qy
	7tY4mGYqp4KuxP28LgZKg/3DDGwq/ljJLmY5pgzUJYGHdjXxIzWg5r+iC8gDuUS8wIlXQDYeyb0
	WVCQNk6ksK8g8F5AI/iztRg2wytyywSGisy0py1TFtNMIkU9FCRi4ry7pqnoic3V2cNZIZQI8AD
	HJ4TXmkaYk2gQKVLKFCPwoOGZeqSVrzujNvXqPFr66m+FNj2EeK4vK62/53xXETf+DdGUvuNfjc
	NASwmX8RfBFpegMcgyFhsXWldykWBXf/+rLLXethlj7q0Hs6E/vX9A+UZEP6+q195KF2EX+wqkt
	fK68kEkO9ADb/x+6GjB63pCDGQoctulBwrdiVl94sOWCp44bF/FGSwL2g8rTBBb3rCKaqNr1qqE
	itEFeK27v3q/+4G7MbS818oTiLD3rjpYy1MMbQ22XkMY9BNCs8XCmpHrkFH4imzLLAFZtzlu33o
	iTajRORlH7sjl4BOL2afeJCyQiCwsUPLIFLyn05mG/9drXL6cCzbLbgfsRBMgFhEt329NRwCvOc
	i92e9SLe5+xbd8ECcD4rrwYn46FJdS46D6B13o1iUf5cchWDxoIxv3I7rkdRoLOYFxk4iMv3X8s
	m+Ao4Rz5yqA917jKPqkII3+AyRXu+uWSk2yBdRWhaNkE1Mh0=
X-Received: by 2002:a05:6a21:7803:b0:3dd:a00a:170f with SMTP id adf61e73a8af0-3e928d57e4cmr10630286637.42.1793755692006;
        Tue, 03 Nov 2026 17:28:12 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:11 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 1/7] wifi: mm81x: don't rewrite MCS0 rate entries to MCS10
Date: Wed,  4 Nov 2026 12:27:50 +1100
Message-ID: <20261104012756.510424-2-lachlan.hodges@morsemicro.com>
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

mm81x_tx_h_apply_mcs10() rewrites 1MHz MCS0 entries or adds a new MCS10
entry at the end of the rate chain. At higher attenuations, MCS10
has an incredibily high success rate at the cost of very low
throughput.

Normally the rates are walked in order of throughput (i.e. MCS0 -> MCS9)
but MCS10 sits at the top above MCS9 with the lowest throughput. MMRC
allows a lower rate to replace the best rate based on probability of
success alone, assuming lower rates are walked first. As MCS10 is walked
last, its high probability lets it win regardless of expected
throughput. Over time, MCS10 becomes the first rate where higher MCS and
bandwidth rates such as MCS2@2MHz should be picked over it. This leads
to a significant throughput drop at higher attenuations as MCS10 is
favoured over rates that provide far more throughput.

To fix, remove the rewriting and addition of MCS10 entries. MCS10 is
incredibly slow and (almost) all frames must be fragmented since it
can only be used at 1MHz so in these conditions the link is almost
unusable. Not only that but MMRC was not designed for use with MCS10.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 90 ---------------------
 1 file changed, 90 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 6f1feb24fe6a..6df06b535319 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -26,12 +26,6 @@
 /* Calculate average RSSI for Rx status */
 #define CALC_AVG_RSSI(_avg, _sample) ((((_avg) * 9 + (_sample)) / 10))
 
-/*
- * When automatically trying MCS0 before MCS10, this is how many
- * MCS0 attempts to make
- */
-#define MCS0_BEFORE_MCS10_COUNT (1)
-
 /* Maximum TX power (default) */
 #define MAX_TX_POWER_MBM (2200)
 
@@ -1049,87 +1043,6 @@ int mm81x_mac_event_recv(struct mm81x *mors, struct sk_buff *skb)
 	return 0;
 }
 
-static void mm81x_tx_h_apply_mcs10(struct mm81x *mors,
-				   struct mm81x_skb_tx_info *tx_info)
-{
-	u8 i;
-	u8 j;
-	int mcs0_first_idx = -1;
-	int mcs0_last_idx = -1;
-
-	/* Find out where our first and last MCS0 entries are. */
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		enum dot11_bandwidth bw_idx = mm81x_ratecode_bw_index_get(
-			tx_info->rates[i].mm81x_ratecode);
-
-		if (bw_idx == DOT11_BANDWIDTH_1MHZ) {
-			mcs0_last_idx = i;
-			if (mcs0_first_idx == -1)
-				mcs0_first_idx = i;
-		}
-
-		/*
-		 * If the count is 0 then we are at the end of the table.
-		 * Break to allow us to reuse i indicating the end of the
-		 * table.
-		 */
-		if (tx_info->rates[i].count == 0)
-			break;
-	}
-
-	/* If there aren't any MCS0 (at 1MHz) entries we are done. */
-	if (mcs0_first_idx < 0)
-		return;
-
-	/*
-	 * If we are in MCS10_MODE_AUTO add MCS10 counts to the table if they
-	 * will fit. There should be three cases:
-	 *
-	 * - There is one MSC0 entry and the table is full -> do nothing
-	 * - There is one MSC0 entry and the table has space -> adjust MSC0
-	 *   down and add MCS 10
-	 * - There are multiple MCS0 entries -> replace entries after the first
-	 *   with MCS 10
-	 */
-	/* Case 3 - replace additional entries. */
-	if (mcs0_last_idx > mcs0_first_idx) {
-		for (j = mcs0_first_idx + 1; j < i; j++) {
-			enum dot11_bandwidth bw_idx =
-				mm81x_ratecode_bw_index_get(
-					tx_info->rates[j].mm81x_ratecode);
-			u8 mcs_index = mm81x_ratecode_mcs_index_get(
-				tx_info->rates[j].mm81x_ratecode);
-			if (mcs_index == 0 && bw_idx == DOT11_BANDWIDTH_1MHZ) {
-				mm81x_ratecode_mcs_index_set(
-					&tx_info->rates[j].mm81x_ratecode, 10);
-			}
-		}
-		/* Case 2 - add additional MCS10 entry. */
-	} else if (mcs0_last_idx == mcs0_first_idx &&
-		   i < (IEEE80211_TX_MAX_RATES)) {
-		int pre_mcs10_mcs0_count =
-			min_t(u8, tx_info->rates[mcs0_last_idx].count,
-			      MCS0_BEFORE_MCS10_COUNT);
-		int mcs10_count = tx_info->rates[mcs0_last_idx].count -
-				  pre_mcs10_mcs0_count;
-
-		/*
-		 * If there were less retries than our desired minimum MCS0 we
-		 * don't add MCS10 retries.
-		 */
-		if (mcs10_count > 0) {
-			/* Use the same flags for MCS10 as MCS0. */
-			tx_info->rates[i].mm81x_ratecode =
-				tx_info->rates[mcs0_last_idx].mm81x_ratecode;
-			mm81x_ratecode_mcs_index_set(
-				&tx_info->rates[i].mm81x_ratecode, 10);
-			tx_info->rates[mcs0_last_idx].count =
-				pre_mcs10_mcs0_count;
-			tx_info->rates[i].count = mcs10_count;
-		}
-	}
-}
-
 void mm81x_tx_h_check_aggr(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1205,9 +1118,6 @@ static void mm81x_tx_h_fill_info(struct mm81x *mors,
 				&tx_info->rates[i].mm81x_ratecode);
 	}
 
-	/* Apply change of MCS0 to MCS10 if required. */
-	mm81x_tx_h_apply_mcs10(mors, tx_info);
-
 	tx_info->flags |=
 		cpu_to_le32(MM81X_TX_CONF_FLAGS_VIF_ID_SET(mors_vif->id));
 
-- 
2.43.0

