Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639790;
	b=ImDeM+JcUeeqGZ2Zhbqp92tdfLf8o4bIBwO+ykCqXr1tUYKFswx90QX0RbiJTAUP1A50
	 6M2GDWuI3VBprscBH9JWCBcrjgWdAfSM5/tm/GPPed2xZ4WT5BattObiNU4lDv+NHsKgJ
	 uYjJ44ATKxjW4p4SR4pjwLU9xbxStfRG/xi9kHGM5SSweY4s860S824ksW/aFM/pdvm8p
	 ey/02aiBLNan9mMNTqmv0Jg6/Y65MtV2N8SjhzwnmGMUZiBy/6cqaZOaSSsv3AyBtqiZt
	 EnRJIJ7GlrE89jjB0KRaPqUn5KIaVDyybu3D9AHsxSWiussQUhwRzaGWWDXhLPh0ClQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0+IqcO9AhETeBZJKsJy+A603A0xPkBeTUx1oq9nUAqw=;
	b=jNCEeu/BLXgjGpodquxjZjY9GsxJupbvOGqbJX8RVNAvoPaf1s6KI6/C6VU7wlwzQ8sq
	 3ZOQ8KXHH94GM7zkR/l67WWp7++My75bCSvA9yNAk0hGc3NWSniZwbACHQBhZy0Oqoowy
	 APNcn5li7bvwvI8EIuIy6MuL94w09pW7wiqK4G+CHbBTrNBdhR3fC5JxjemSld+RLmFHs
	 xbu3bPu9VKBiKGtYUmCKznGob/MI3/LxNaFe73AeGmRup6Nb6gvXCQDDkAYrZefAcI2yn
	 kYun7MG+5HFUiJjqfxlCFto4DDoUkYqGdgEv1Zn2zqTekzasMmAcKUOts4CFSasdPNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MOIgfhKd;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9048606A931
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 17:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9048606A931
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MOIgfhKd
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso1840121f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 09:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793639788; x=1794244588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+IqcO9AhETeBZJKsJy+A603A0xPkBeTUx1oq9nUAqw=;
        b=MOIgfhKd7FD9tehJYzRDFvr+iT+JgR1wbDAOM3Le02gHisuS/0CyQ9ELsqIPZDrwZ1
         njjSOkzW0VntU4y4pdVJrm79Wswh0beleLwkQwc9HOJCSM6mB39X455gQip0wtrXPXJR
         nX9qbSY73MfwbeFZ+wg7A78KmVy3W3gQJM+4UTwxHRhwgP13Q9ruIw31wiSI676dQAWV
         87PVfgONLyLPwshqDs2F0GYYIw1+0MkuECWJHJy3WRAxPz55HWREQT0Vhm2jIUBC+DAJ
         4oxTdu8pDZN2z/3zAaBE+XdAZX3AeHXzwNnAF2mFIJK9rxAMK3nEUi8aw2RPjy3nb9JT
         YnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793639788; x=1794244588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+IqcO9AhETeBZJKsJy+A603A0xPkBeTUx1oq9nUAqw=;
        b=kS7hLXf2B+S0koDqlLTgxKO5Uj1qk2TYdHOZQSre86xCxzvW4yR23EdBuLBwgi+Ka7
         YMPc866JVk5H9FQObmSrbF4InIsqDYd8dF58QbRWyGymd9Epjj/eIS6HPHLRbuAH0aHt
         WlN1kjVeOJcLhs/FmInTZSgeWjuF5l6Pa3qajylBsXuVneezpqumRJ68MGjGQVUCopSE
         Mvbky8wvnytiB3WZsyEBrMS17F2LsjmgNFaaawepGvaKFLbFG0B6NYnfjLQ361MlK+WU
         nS0mkH3aVfDfdLuwlLNcZycnAskWZxOS4uyfoJc8L6XAuP+4AkMlzAuEqkHCheN/KiSu
         b9FA==
X-Gm-Message-State: APuU4Z9EX9bjsSXu6UO3jjj19kW/lWk/eSI1ta4rzkSsRqippJnP8tpw
	ut5vDBX0O1Dc9yS1wtppgotaJ8xVX78URnXkTsP2Mpmz2jSNGfYlZn0FinOzDei1m9aFFg==
X-Gm-Gg: AYBFou0zjWrl7SiPv6Ba6kVQdKv85jrVbcAUvKX89tS4R8mzNowHPQdMWJPJ9XAIlcw
	H1TGfP5YkdY6xGsI+ZHwPYSs3LmJP4ga1dD+UvqFpcf1q28zu8tmHv7jHV8EuAbP7BCoMw+60jB
	SrkNgNe30/QSg/nKdO1hcxgs/Q+Imham/w9xn+kZzjDT+mZo9G2iUVp3VjwGJdKTs9URmGUa3N9
	uGtImsCkkP4MJ7wycJeX9rEI+1FzlIxcYcSLMU3R0DfV5rckDz0igWsfgNfleQiumW02wEZvKh2
	YAgfg8Wk83B0mw9kBs6fpjxW78ceB4O2QegaSRZzi2rssIGhTHHiIF3fV2tx/vB7va8LYeyLnFi
	kM1xcSRyDug8rkqT6a9gPtM5fKiHjtbrPHSJRJ2sCgPEtkB5HMt3dwzreKRySzjrdCtkvpXnH/n
	9KTY+LWbqTmW5OIpFIW0hOyYYMXFcdTixWK/5smY6entpy2HOm1n0133xBxa1qv9/GGc8eVDswj
	xOinA41bJZWasjts9b8bi4Y1/pUouWuJOicBkT8gDz0nGu8Q53s7li15iwLFeKQMzJMP5YP6j2N
	dHWOU/L/GVUeC4rzStiHSjEmsr3iLSV+y0lTrpqXZmdvLb1rhirYqwajO4/W52U=
X-Received: by 2002:a05:6000:186c:b0:48e:7a19:7aad with SMTP id ffacd0b85a97d-48e7a197e64mr17551414f8f.6.1793639788299;
        Mon, 02 Nov 2026 09:16:28 -0800 (PST)
Received: from debian (ip-78-137-176-146.broadband.digiweb.ie. [78.137.176.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm23598760f8f.6.2026.11.02.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:16:27 -0800 (PST)
From: Pablo Mazzini <pmazzini@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pablo Mazzini <pmazzini@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 2/4] wifi: cw1200: describe the chips in a table
Date: Mon,  2 Nov 2026 17:16:01 +0000
Message-ID: <20261102171603.368298-3-pmazzini@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102171603.368298-1-pmazzini@gmail.com>
References: <20261102171603.368298-1-pmazzini@gmail.com>
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

Replace the firmware selection switch with a table keyed by the
silicon revision, so per-chip properties can be added in one place.
The SDD path becomes const to take the table's names.

No functional change.

Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
---
 drivers/net/wireless/st/cw1200/cw1200.h |  3 +-
 drivers/net/wireless/st/cw1200/fwio.c   | 67 +++++++++++++++----------
 drivers/net/wireless/st/cw1200/fwio.h   |  6 +++
 drivers/net/wireless/st/cw1200/main.c   |  2 +-
 4 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200.h b/drivers/net/wireless/st/cw1200/cw1200.h
index 48f808cdc1cb..8867b2c94c8d 100644
--- a/drivers/net/wireless/st/cw1200/cw1200.h
+++ b/drivers/net/wireless/st/cw1200/cw1200.h
@@ -117,10 +117,11 @@ struct cw1200_common {
 		CW1200_HW_REV_CUT22 = 22,
 		CW1X60_HW_REV       = 40,
 	} hw_revision;
+	const struct cw1200_chip	*chip;
 	int                             hw_refclk;
 	bool				hw_have_5ghz;
 	const struct firmware		*sdd;
-	char                            *sdd_path;
+	const char			*sdd_path;
 
 	struct cw1200_debug_priv	*debug;
 
diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
index 2a03dc533b6a..6601aec1f231 100644
--- a/drivers/net/wireless/st/cw1200/fwio.c
+++ b/drivers/net/wireless/st/cw1200/fwio.c
@@ -48,6 +48,41 @@ static int cw1200_get_hw_type(u32 config_reg_val, int *major_revision)
 	return hw_type;
 }
 
+static const struct cw1200_chip cw1200_chips[] = {
+	{
+		.revision = CW1200_HW_REV_CUT10,
+		.firmware = FIRMWARE_CUT10,
+		.sdd = SDD_FILE_10,
+	}, {
+		.revision = CW1200_HW_REV_CUT11,
+		.firmware = FIRMWARE_CUT11,
+		.sdd = SDD_FILE_11,
+	}, {
+		.revision = CW1200_HW_REV_CUT20,
+		.firmware = FIRMWARE_CUT20,
+		.sdd = SDD_FILE_20,
+	}, {
+		.revision = CW1200_HW_REV_CUT22,
+		.firmware = FIRMWARE_CUT22,
+		.sdd = SDD_FILE_22,
+	}, {
+		.revision = CW1X60_HW_REV,
+		.firmware = FIRMWARE_CW1X60,
+		.sdd = SDD_FILE_CW1X60,
+	},
+};
+
+static const struct cw1200_chip *cw1200_find_chip(int revision)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cw1200_chips); i++)
+		if (cw1200_chips[i].revision == revision)
+			return &cw1200_chips[i];
+
+	return NULL;
+}
+
 static int cw1200_load_firmware_cw1200(struct cw1200_common *priv)
 {
 	int ret, block, num_blocks;
@@ -90,36 +125,14 @@ static int cw1200_load_firmware_cw1200(struct cw1200_common *priv)
 			goto exit; \
 	} while (0)
 
-	switch (priv->hw_revision) {
-	case CW1200_HW_REV_CUT10:
-		fw_path = FIRMWARE_CUT10;
-		if (!priv->sdd_path)
-			priv->sdd_path = SDD_FILE_10;
-		break;
-	case CW1200_HW_REV_CUT11:
-		fw_path = FIRMWARE_CUT11;
-		if (!priv->sdd_path)
-			priv->sdd_path = SDD_FILE_11;
-		break;
-	case CW1200_HW_REV_CUT20:
-		fw_path = FIRMWARE_CUT20;
-		if (!priv->sdd_path)
-			priv->sdd_path = SDD_FILE_20;
-		break;
-	case CW1200_HW_REV_CUT22:
-		fw_path = FIRMWARE_CUT22;
-		if (!priv->sdd_path)
-			priv->sdd_path = SDD_FILE_22;
-		break;
-	case CW1X60_HW_REV:
-		fw_path = FIRMWARE_CW1X60;
-		if (!priv->sdd_path)
-			priv->sdd_path = SDD_FILE_CW1X60;
-		break;
-	default:
+	priv->chip = cw1200_find_chip(priv->hw_revision);
+	if (!priv->chip) {
 		pr_err("Invalid silicon revision %d.\n", priv->hw_revision);
 		return -EINVAL;
 	}
+	fw_path = priv->chip->firmware;
+	if (!priv->sdd_path)
+		priv->sdd_path = priv->chip->sdd;
 
 	/* Initialize common registers */
 	APB_WRITE(DOWNLOAD_IMAGE_SIZE_REG, DOWNLOAD_ARE_YOU_HERE);
diff --git a/drivers/net/wireless/st/cw1200/fwio.h b/drivers/net/wireless/st/cw1200/fwio.h
index c287160a492e..e97cbcd54e57 100644
--- a/drivers/net/wireless/st/cw1200/fwio.h
+++ b/drivers/net/wireless/st/cw1200/fwio.h
@@ -26,6 +26,12 @@
 #define SDD_FILE_11		"sdd_11.bin"
 #define SDD_FILE_10		"sdd_10.bin"
 
+struct cw1200_chip {
+	int revision;
+	const char *firmware;
+	const char *sdd;
+};
+
 int cw1200_load_firmware(struct cw1200_common *priv);
 
 /* SDD definitions */
diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index 5d569eeb353f..793471acbfb6 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -541,7 +541,7 @@ int cw1200_core_probe(const struct hwbus_ops *hwbus_ops,
 	if (cw1200_refclk)
 		priv->hw_refclk = cw1200_refclk;
 
-	priv->sdd_path = (char *)sdd_path;
+	priv->sdd_path = sdd_path;
 	if (cw1200_sdd_path)
 		priv->sdd_path = cw1200_sdd_path;
 
-- 
2.52.0

