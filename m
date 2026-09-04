Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6136EAAE
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 02:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488762; cv=none; b=sRjAqugVXsZcoi+tAqEOFTasUEZIyzsiTN5fKiByT4QehpyBCFFGK6OHa8Ayad0AZ8B/p7kq2L8OToQGXJ63i7vfllFprfSLy7jogNXaHKqc2wz5GRyWq2qRZFX9UPp14gAJxxW3YYvpz5Mj5FvilGqp/8FVJCwGOJ0toDC2nIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488762; c=relaxed/simple;
	bh=ugzVxAjTEnjShZeOxL+eJDmc/0g+rGyJoye29gd4s7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hVcGXK3tj2f68Dq4Ulu3yLgAzbgEZKgutdFgyFtk8WW7hgzq8GAY3xbEWopl4YXmRr4sUaBOAQ9T79aRv5HYW2TXFEE3TlZ0SwXE7gFmcbbztmRI6n1/UjhV4RRoD+ve4UHtmG1xd0Cp92l7ejjBeCOcO8R4Q94r6mX7fD2QjDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akHKFqVx; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akHKFqVx"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-853c947bfefso429716b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788488760; x=1789093560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4TQ9tB7GYsgLshxgrlgtnE3BzZ3XB27V3iJEzkjdXdY=;
        b=akHKFqVxm38FokxZII2lY0rBRmePK9veAULaR0XT1TIXQE64jcZ/s1kvqdQdDpaj0H
         9EVFhvRwqYda/r48J6M44D51uG1mUV7rmBSSttdd1nj7ttoXmu7gkSfPL8mVjb63Zk8r
         Gf8pDRPsNPKnDEusApcvBWiridNSvxa4bJwVptcLxSW8QBTo8x87CDMjCSpek+a4uLkY
         xS2NI1oOpCDAw7aDRG0nrZzgdhQQjgqEQFQ/Tag5WjBjtK7qC/VxDxATo4ugvVjnULvK
         ROIZuUh/V3h0BA7cBTIKC3f3+pvaaTvLtMqsHTuSaIhsmiFA/k6C3we+DLQ1z3sU9kwX
         Gs9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788488760; x=1789093560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4TQ9tB7GYsgLshxgrlgtnE3BzZ3XB27V3iJEzkjdXdY=;
        b=bt4dQU3gF0lvwCj2Qc0cEKmaJt8B9FkvFVrXHX7mXUxRP7F0GBCMPLDHUWWfGBJiYK
         /ZccawMbnhlpWaqaYbveEdl0TGC4KovlejpRwicqiOLZHEiDCm8LefadoMpTDVNtnmlU
         4uOiypTnZdyE759RGZbFo8HA3EtsH3FO4mnPtbqjTaQMocoX+dzZPPZvnCBak8dJfwfH
         Yf0s4V9vb2fUmF6oBvmCcIVZ+TKZxb6riEmURzT+31T7/v28TbU5MsNUx18dcODDnQD+
         6ihEIytd6JCF9+v3bBAFpSG3xaZiZsuutQF9jXo+py14DwWGk9y4eJ31qOrN7jNcCCU9
         KUaA==
X-Gm-Message-State: AFuF++npgCC8bReCOCh5n8S+MkKOjKtGukXky0qwRscl4QVikFKvMivG
	DQg/yO+yfMSB2usnSmZVdZMSx86e+ldpp2aZ2B4IkODoa4oGPx15iw1lEL3VvA==
X-Gm-Gg: AYBFou3I2TFBhBqFzgmEvC1qofAobwRxEBdeqi1iN+eyibYlPiWqqVNKuMq9vXZ5rvG
	Pp52yIR3tV4iUT65iGLN0IzuPTpIQPm2TrTKvSWzaL5Fsv7hBXAqZBOdbxla9LgP2/BssK15fSo
	XvsYAZTqNQRiI4S6QOII4aZ/4SWjjd9ah8iFkRkNr5pB+nudeQvNFJBwPmW3N7ye5Pp2HHVUvuw
	5Fq72N1w/1Gnezhl/asm77PeU3GPj4Iph8K9tnRhJGUktpB8CJ5e3hV+d9eiZkzpxo1mbyI+Y6s
	knHNINxTDRn1ha+yJmPKXRhBRe5PvEGB9F2kV/n9CFRGIg5BrnfYBmzIQmrhD4hoepFdH4cs4vZ
	JN61Y+Pk+zibGxoh6XFOuOsAxdylCackmUXlSjjNS1eQ1hRmtLlFUdWLrIH3Usl3DojpQQV01cV
	mQH5keigPEXXYMZUOKNezhJf1/nHie7lnaBJTQmjDWbt1znx2AUPaKNyDMo44ypI8W5JFepfKoz
	DHUiLVSYdSlzelE+n851YKDIfGwPftV1YaNbTnc1Xi0+S9DHn3xGDztX7k7yZ6H/SSK4ama3rz3
	YpxyNi3Cjs4gtOCR9eXqVfdzbU7lNfWm40ohD/e6EMI5LZA3
X-Received: by 2002:a05:6a00:138f:b0:851:80de:db56 with SMTP id d2e1a72fcca58-85ffe10a09amr8232438b3a.13.1788488759952;
        Thu, 03 Sep 2026 19:25:59 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8614f871fc6sm591487b3a.7.2026.09.03.19.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 19:25:59 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-devel] wifi: ath: split 5150-5350 regulatory rule
Date: Thu,  3 Sep 2026 19:25:57 -0700
Message-ID: <20260904022557.2679261-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow initiation in the 5150-5240 MHz portion of the world
regulatory rule while retaining NO_IR for 5260-5350 MHz, where
radar detection is required.

The previous single rule marked both ranges NO_IR and unnecessarily
restricted channels 36-48. Update the rule counts for the expanded
rule list.

Assisted-by: Codex:gpt-5.6-luna
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/regd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index f15e7bd690b5..b129af0eed88 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -43,7 +43,8 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 					 NL80211_RRF_NO_OFDM)
 
 /* We allow IBSS on these on a case by case basis by regulatory domain */
-#define ATH_5GHZ_5150_5350	REG_RULE(5150-10, 5350+10, 80, 0, 30,\
+#define ATH_5GHZ_5150_5350	REG_RULE(5150-10, 5240+10, 80, 0, 30, 0),\
+				REG_RULE(5260-10, 5350+10, 80, 0, 30,\
 					 NL80211_RRF_NO_IR)
 #define ATH_5GHZ_5470_5850	REG_RULE(5470-10, 5850+10, 80, 0, 30,\
 					 NL80211_RRF_NO_IR)
@@ -64,7 +65,7 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 /* Can be used for:
  * 0x60, 0x61, 0x62 */
 static const struct ieee80211_regdomain ath_world_regdom_60_61_62 = {
-	.n_reg_rules = 5,
+	.n_reg_rules = 6,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH_2GHZ_ALL,
@@ -74,7 +75,7 @@ static const struct ieee80211_regdomain ath_world_regdom_60_61_62 = {
 
 /* Can be used by 0x63 and 0x65 */
 static const struct ieee80211_regdomain ath_world_regdom_63_65 = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH_2GHZ_CH01_11,
@@ -85,7 +86,7 @@ static const struct ieee80211_regdomain ath_world_regdom_63_65 = {
 
 /* Can be used by 0x64 only */
 static const struct ieee80211_regdomain ath_world_regdom_64 = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH_2GHZ_CH01_11,
@@ -95,7 +96,7 @@ static const struct ieee80211_regdomain ath_world_regdom_64 = {
 
 /* Can be used by 0x66 and 0x69 */
 static const struct ieee80211_regdomain ath_world_regdom_66_69 = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH_2GHZ_CH01_11,
@@ -105,7 +106,7 @@ static const struct ieee80211_regdomain ath_world_regdom_66_69 = {
 
 /* Can be used by 0x67, 0x68, 0x6A and 0x6C */
 static const struct ieee80211_regdomain ath_world_regdom_67_68_6A_6C = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH_2GHZ_CH01_11,
-- 
2.55.0

