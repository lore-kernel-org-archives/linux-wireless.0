Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755701;
	b=Zwsost2KUmROdZwADpalAGlYwTqGbn/3Gvdqump7EkSmmYg+ppLIeg2Hgm9IkwX1Oi5+
	 zJlNYJmQM2MF2en28GmM7PKN4o1bkC26xnTMvHN1jZsoNKLVi3ztGq2jgKCBDxnbgsm9k
	 XEb88pBWsTCDeKDL45WKiYwh0obILQzNFfhp/t0zDMqMmKmW5EmYBvrDVmfSpEvltpl8W
	 WAh7bL4kgBUP8yb08h/wAPJQUg7UYtS36SE0tOoHhNnSM1e6OZJUsFfH1JxhPC/V1Y9pw
	 H4RKAl1TqkLBLdSvW7J7hcOlDuihConOZkSAr1q3Q4Tfx7e3OKas6p6aKlYgwJegOrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eVhlzTlhCRz5bs9/dPtNKEcoCLfDKttsltoX2lx+z80=;
	b=w21mUB4OB4h37AluzLhZX4kOHRxOWakxZbhFp1/Qa+M/2IgSwwCg+oVXXytidl0cLhz+
	 RQP8zuZNknnSONPeIZ32issW9PNAqKWlPg5KuMxy7PxaM1LnB4lUIdYvvpVjBBoB5rx/a
	 o6D4OnDSTajEaFtcDPkmUyM5EtsJ0W0LeKYltdK+uoFXci/MsMiZb/PUWjvGpDz7ZwBLU
	 PAp9TLrZNv9M2HlU4batgwt+bJ3vMcbeJrGbux0jFyozqWoLyHsh6QVpW7lEBjDYQ5pB6
	 5XR5cAAXRVbT6kqOE7q5ipTH/HPqqbHNQB0lGyMpOAFjbztBPJONA22VJBx/dRhp8EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=njFu5fuY;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F3F606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9F3F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=njFu5fuY
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdab938dc83so78845a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755700; x=1794360500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eVhlzTlhCRz5bs9/dPtNKEcoCLfDKttsltoX2lx+z80=;
        b=njFu5fuYFFD5EQ4o9cwZXEOzJMO213rGZVRJBiB6fWF9ktRqmi51j8dbnTzthXBiQ/
         BLnHhKKH0nF0LeQ3NsoB5MW9q/Gafm/LgxpBEhTsF50lMadg2NxfBSb0s7LSkCm6gdiu
         8o/zDAXLPRlGnU8xxkUx7PIQARQd6yojKS0Pgsyv/JE4UKwVaj8feThclMlQ7WOBTIP8
         ULoVMFS2pLadx7T9ZfSa/3hVTTsCzNhUTStrJsWJyzxEKV1JVtP57CmTHVwo5Z+S7pHx
         aptDrK3cpMRYISRg9RMZ0VwTDsPQitw4/peb4MNZGkiPx9IQqZ/vjN8H14U4Dl70qL9i
         uNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755700; x=1794360500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eVhlzTlhCRz5bs9/dPtNKEcoCLfDKttsltoX2lx+z80=;
        b=MrF0tFK3vZHgKgVGgK35HYP3P/S9Vkiy9Uyb9RhrN2YondLueLR1O8ytQCtPEhWP2L
         JsptL9dRVEeRCvN9psb9f8RmuBP5hwxGNXs8agJjO6MOcI+5ZKXa87Z1kE+ht/YC9ZPn
         3DL4Zf8S03kC1Fqp2IF/lsmRxRKoZVXdVZWr+AvYFknyV/Ao65qpNM0GzIuNtOBKglnC
         pgUEh4ftTjJekieeQ4tkO9RF0z6fYZRAZBFg417V1M0puQe69osXKvE1wPPin9hBAuW9
         y4giSFBxtJneR+8v5SCGFBEv9Eut2oeq4azxKtBAcREkktTifggdqiiq6fZ4aagFc0/7
         QcDA==
X-Forwarded-Encrypted: i=1; AKwUvBxj8mbx5ZNk8q0hB9DLikjowebT4ugcUDeZTnOEk42/yOOEu4Fadm/Q1vuStm+FZ6zF4NLgKPGTomKTwCnEyw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9iKq3rwE3vE5UFz4qfZkGwixC0P1HvMvBWt8QUBnEhAApRkJAe
	JzFdBuH1D8URHTffJB8zjyuw4N6DyWHVfTmB5rq8RMuAOvV7MEzXgfP9pm620wDJo9Vqhcd1JRn
	3mW1VJbY=
X-Gm-Gg: AYBFou0qSN53iurVzkrFO1w7+ie7/Acfur4ZEqRXcPJZFASyYq7XDc3z4LnZMeYrkqj
	rsLNBc8jtFdIMQ7MkyGkcntFjc8Mpt4TREkTp6N18uJ/7eiJ/zGqae+TcZVr7jAcKP4grovqsi+
	eEB+AtytXht1Zy/xMR/06wDLhDvYWrnBRIBYSWccgzvBv4kHJMXeyTroxGZKx6f0TS7WeODfORq
	WMV1rNR3gpRE4fZaKKpesbjgfpjXB8Mw4U990knD1i2P4TvzTjNTbfmzd8gN8Vdzx4pxei7UzHR
	1gGdvetb30b/sa7aUoZthvG7I+nke5q4Gfv3OpJFwPrDyHRIRxz6xuuFL9SCZAP4ByRDx35R4Nc
	8Oq3wy5tIK4q3XPIw2fUB/u+A939/k6kDiQClW/PdU202uB1c+NTwKTblaq+mpzSzbyNqp3cTM/
	cAaFR+WvrugEILSzRd6ik+jfqj9ZtYSbuuWmH0NTgJGIKJZJbY0l2YAHF+mEGjYw2sznKIM5ipR
	lBn/0qQPl0tomS2DiOA/0ylZSsCED0FMVDgx4fY09SbzGs3pVezmqWWHSoP5GBPiYDuEW1T8vQC
	Xb5NQoezvZu1if0jW2s1lxMgngP467yU7R5vybP2rFcd8QC3yryLLoTEBRfgIgn9bQ2w1SE9dP3
	i5Y48ecntrjnfHaVx/e/B4tI8H7bpp//E1eFIBIaVA0LaHXk=
X-Received: by 2002:a17:90b:2803:b0:3ab:5758:3757 with SMTP id 98e67ed59e1d1-3ae897dda60mr11394000a91.61.1793755700357;
        Tue, 03 Nov 2026 17:28:20 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:19 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Sam Chapman <sam.chapman@morsemicro.com>
Subject: [PATCH wireless-next 4/7] wifi: mm81x: mmrc: widen attempts field to hold firmware retry counts
Date: Wed,  4 Nov 2026 12:27:53 +1100
Message-ID: <20261104012756.510424-5-lachlan.hodges@morsemicro.com>
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

From: Sam Chapman <sam.chapman@morsemicro.com>

The firmware reports up to 8 attempts per rate, but struct mmrc_rate's
3-bit attempts field stores 8 as 0, so mmrc_feedback() ends the chain
early and drops that rate's attempts and success. Widen the field to 4
bits.

Signed-off-by: Sam Chapman <sam.chapman@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.h b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
index f4a90a50e4bf..f6106384b1ea 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.h
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
@@ -68,7 +68,7 @@ enum mmrc_guard {
 };
 
 #define MMRC_RATE_TO_BITFIELD(x) ((x) & 0xF)
-#define MMRC_ATTEMPTS_TO_BITFIELD(x) ((x) & 0x7)
+#define MMRC_ATTEMPTS_TO_BITFIELD(x) ((x) & 0xF)
 #define MMRC_GUARD_TO_BITFIELD(x) ((x) & 0x1)
 #define MMRC_SS_TO_BITFIELD(x) ((x) & 0x3)
 #define MMRC_BW_TO_BITFIELD(x) ((x) & 0x7)
@@ -76,7 +76,7 @@ enum mmrc_guard {
 
 struct mmrc_rate {
 	u8 rate : 4;
-	u8 attempts : 3;
+	u8 attempts : 4;
 	u8 guard : 1;
 	u8 ss : 2;
 	u8 bw : 3;
-- 
2.43.0

