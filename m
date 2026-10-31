Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465517;
	b=IRwyryZFXldVbcryLKh9esiLYpQsayfmm+aMcIO8wapLcELiCk6nsKQgwtWdbd7XudDQ
	 wVT8fhauBfn5ou1mZPBaIM6QGVgwWc8AYpJtZHWsgG3HO8ILbQxR/Z8UlF7YZ0J7G0ghW
	 ZSEV3Fh8GTW40nSTLfxKLILi5+bLGdq3UTCJaHIMsZCBZZ7DXzuxJi5RGAkXwoa9tKFL8
	 J46S4muIgTtq2M7wjtsh/GIjNSghQql4aI/fApahfPTLCjKn5UJm+l9BVr5UmySBgULBZ
	 +8RGHDnRppS+7ZZe92dCHb/zV1nvZrDdXDXxHbNkQUuWFxhgWDOMmnIcS/gJl++pgVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465517;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GitDobwZL0W8Zsadin8rZjJ/xvgEFcF52lsbZdjI7sA=;
	b=CjnPYFLm6COYUTlq145mFahJKNkA4CanU+2GwV092qc0aqtSvGjxmeOrfD/g5wicKNKS
	 qVzLw9MNIqqvb4/6DRiL1c6kcAaumrxcuMBorvbDRB3ZkbKPFDkhT2BAyQ7d9fyb3+yoy
	 GH011MOuz20zwmygWQ8vg05UZfyelevYV+r3/FaaftzJB4Qi4M0wiClDNoJIFBhuEJogb
	 MjA6LIglQlOyGPY55cYZ13xpNVvJMD2v29PJ8nl4t/JM8FC3gQq3kmFJeSTPw9MQeX5Gs
	 jeQpce6u/mhiV954Dmgi9tGIKsXWq7MCc4c74FFenMGRCEYPtxlBnq9u4Sif56K518w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oHGHtWKh;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0D8606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:51:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC0D8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oHGHtWKh
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1adbf62dd31so1637976c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465516; x=1794070316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GitDobwZL0W8Zsadin8rZjJ/xvgEFcF52lsbZdjI7sA=;
        b=oHGHtWKha9ZR3IPWowNiKAr1S1NaKAlAfIV8JIJMaovhcel/5h5ItAvHv/ayf6zyLo
         wRIOSVXSCFa7/PTIG0v5gG222xox5ZK7OKibxHcuHeiD67A5hrQGSGTgfdRPL214/L6M
         77+5SXOGPLU9TxKRO+WjrSe22pZ0S2gaCvDEaCxspfxg7ZYkCqTyJoKhnP+dCOrzoxQE
         uZxgxA95W3heyonaF5yUKb4M+5KHUcxgjxwseVq93gbaXvl+cV7Qm5IekZFrVI1KydIX
         Js9PLXEoUarTLTmwyrRbPGYkEuqskZybKl8DtaKesGeiBSJTx+DILdbXLs1PEmESGG7v
         aXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465516; x=1794070316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GitDobwZL0W8Zsadin8rZjJ/xvgEFcF52lsbZdjI7sA=;
        b=JiBTO0/YAKse38DCuVIo9M3oDaiRnf9HbvKCYzbNzEr2nSZYJA2dHpkY0dm4CvEtuf
         BEwnJfZp3+f71S7KL12cyuayXPCZh7prfB/40XdhC4JcQ57vyqX/4Xfrh5umNrAZBfsc
         hIowf2k7ibeDZJto/EDtRNblteFEVVcjLY85lqxJKiklU6rwZa5bGFZZdVreTb76tJl0
         WI/xE3yzZmXMpOUEuBjNGw9SDE2t3mZ5noSZ75BwOjAnt8HpJmX/AJhG6EMpHz6lEEAO
         bx7blSN3V+jNuXZg4mVtKitPTs7kLqAJNIgnuRykLFJunR6aobLQ27W0vwoO3ZhtDYD1
         bRYw==
X-Gm-Message-State: AFq9FYLuPRVTbwnzLHYY0s6RM8Pk8tqMdJen9yW6QrnK7plDBO1UKWPE
	NgxLY3Uqo74v501jjxE/Z4phKka4160Bbls76JOxZrstT5T0yERldxCg+O1NwTek
X-Gm-Gg: AYBFou0pQUh7moY/aWZk/vPGMvQF9qvppzS6/huivw6lxEEuPmiJd3VtwWhN0jcjNUn
	5PEf3KEYy9+IMr4oXRzE3zqoqLnRylP5jFn9TiGHKJlg1zY5pR0ZLaO9PchBApLzvSZNnMuKwK9
	Xg9mqJai4AoQ07Oh6qLnz/q0Wle7/Hd/k/NMNv479o3wTevkeJdVJ+5AVb0wf+9n5pdnxnJQ++u
	hXeBr/RMvFHz1Ci61D9w5wZo+YCF9hzG1Z9kCzK0ToP+Oy943WKkICrrAmN6RwpwdoDtYoFDV6W
	3k4X3zcw0gUmRQg1UZSAQkYZyVvYga9i7stXi7why3aT6LeaYODK/jik60Tkk6P61Jid/J7r0yw
	R7xWtakqsweG09oPkwlpNQGsEiageX+LHi5hzKw81O09/O+sYpjHTsm/blXlVIEv8p1JOj07SsK
	4DdyYxmuVOuVpcjU1K9izSoKCZKAAd1T0oUzu/c6X9N2HAacskRgbXTErNYADmoT+xFLG1l34f2
	GXpbTeh/9FMSqNy4kGx/24MTG4c05MQks0yUs+Mm5Okdoc8zWnRj32yfN0ASRdOLHz6elai35aO
	PirVpJwXewTETKK3MAlpbgex8lVsxqonWcy9+UykWa1UoU2xEj1j3tb2KXJi82dVK6G5F3T/1y4
	nDRU+6QA=
X-Received: by 2002:a05:7022:68f:b0:169:3706:d61b with SMTP id a92af1059eb24-1ac5bbba040mr10869972c88.16.1793465515622;
        Sat, 31 Oct 2026 09:51:55 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:51:55 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 3/7] wifi: rt2800: make MCS 16 fall back to MCS 8 on devices with 3 TX chains
Date: Sun,  1 Nov 2026 00:51:10 +0800
Message-ID: <20261031165117.2868671-4-hjf3108@gmail.com>
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

MCS 15 has worse reliability than MCS 16, since 16 and above
are 3 stream rates, and 15 is the top of the 2 stream rates.
Falling back from MCS 16 to MCS 15 does not make sense, so
make the fallback to MCS 8 on all devices with 3 TX chains,
like the Ralink driver does.

The retry chain is now MCS 16 to MCS 8, skipping 7 MCS rates
in between. Reflect that in the retry calculation code. This
also fixes the retry count on RT3883, which already used this
fallback.

Test results:
   before after
TX 28.2   29.1
RX 70.4   70.2

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 10 +++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  5 +++++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 14 ++++++++++++--
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e7b6edf485099..5e1ee016624c6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1116,6 +1116,14 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 		 */
 		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
 		txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
+
+		/*
+		 * On devices with 3 TX chains MCS16 falls back to MCS8, so a
+		 * frame that was sent below MCS16 after a three stream rate
+		 * skipped MCS9 to MCS15.
+		 */
+		if (rt2x00_is_3t(rt2x00dev) && mcs >= 16 && real_mcs < 16)
+			txdesc.retry -= 7;
 	} else {
 		/*
 		 * Transmission failed. The number of retries is
@@ -6303,7 +6311,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
-	if (rt2x00_rt(rt2x00dev, RT3883)) {
+	if (rt2x00_is_3t(rt2x00dev)) {
 		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_0, 0x12111008);
 		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_1, 0x16151413);
 	}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index a80508db32d9c..f82dda0266f9b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1193,6 +1193,11 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
 	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
 }
 
+static inline bool rt2x00_is_3t(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00dev->default_ant.tx_chain_num == 3;
+}
+
 /* Helpers for capability flags */
 
 static inline bool
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4d94b7062f440..db33c1215de97 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -329,10 +329,10 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	 * lowest rate was used.
 	 */
 	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
-		tx_info->status.rates[i].idx = rate_idx - i;
+		tx_info->status.rates[i].idx = rate_idx;
 		tx_info->status.rates[i].flags = rate_flags;
 
-		if (rate_idx - i == 0) {
+		if (rate_idx == 0) {
 			/*
 			 * The lowest rate (index 0) was used until the
 			 * number of max retries was reached.
@@ -340,8 +340,18 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 			tx_info->status.rates[i].count = retry_rates - i;
 			i++;
 			break;
+		} else if (rate_idx == 16) {
+			/*
+			 * TX_FBK_CFG_3S_0 makes MCS16 fall back to MCS8 on
+			 * devices with 3 TX chains, the decrement below shifts
+			 * it back to 8.
+			 */
+			if (rt2x00_is_3t(rt2x00dev) &&
+			    (rate_flags & IEEE80211_TX_RC_MCS))
+				rate_idx = 9;
 		}
 		tx_info->status.rates[i].count = 1;
+		rate_idx--;
 	}
 	if (i < (IEEE80211_TX_MAX_RATES - 1))
 		tx_info->status.rates[i].idx = -1; /* terminate */
-- 
2.53.0

