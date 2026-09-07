Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC7937BE84
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756540; cv=none; b=a6LvPQLlk2IrS9qAcIa1XnzoT5jwzqvnPaf4RtOUG/Lm9Uzov0VkG+yRS5jMWEGdGnLnbpWcYukaQaLF3e6WuePGCX68fecilqzLOIfSCxvTBevnGj9ac6zzV36A4vOWXrdU5V7S/lVM2smF45PWWQo6GTCvksr2qiIg59+Xt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756540; c=relaxed/simple;
	bh=kxb0B52TSs8B2v8yLzOhr0LRy0+va2v9cTpeFUS5mLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q70dJowrHDPMGijnxpd1QWoZD8P2cBOyaMCLZOZ922yTh/3Tz6YNxrMopZtG/E5Wrxp5RTee2I56Jbkjq27WvhEI00eK6eL7tHvv8hVd2zUC0DeEotMi0/LsMNUOIU5P63BFpI4/V9hReHsJFGkHqlIBxxW8FYU0fYKV4uXzBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmvVhLyg; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmvVhLyg"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d9004f39d3so38467715ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756538; x=1789361338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zbP1O1JK3wh+narhhXUGrCFpR2hK8gzImcIwObPTeik=;
        b=UmvVhLygGseoA4wuEMA6vadeCn4k6t3XwkHYt33qUkFXqYsBni0pUM7NcOicx/HjuT
         SoHrsVH760+jLZVhYVGcxONTykEq1wPuLNJ+kdEAnj6dtS6ZQxhPHdi20IdUCMfIOOH+
         m637vYTHf5Bqj/9nLlJC0E9RjG3Kb+ErtlkRiNaUIzmBD9b6Yzf8e1Hx4DKjTUuH3aIH
         vNnykFrnDNczCsx4+U3iG9JpwqAzTUY5Ol5N1DY3g+Ajg5h9FV2mnWVAN2v9gUQws0gL
         OiweKRVM1lnJgYxTI10ETqJpiy06J2SMQIGEdDJ4vBpuVXTHQitbCpHWQjoKsEgcFCO1
         J+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756538; x=1789361338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zbP1O1JK3wh+narhhXUGrCFpR2hK8gzImcIwObPTeik=;
        b=FN1u6sgORAeghH3TE/saka4WKTzaFNEHuIA18skY7xXJzmQ17LPg6Zi9vPclRMQhyL
         PQ+nw3YqsraSGGouVJuWAvjpFxN6F6U8J2Nu5AZod9LLBrrOXPkT08soSXQHFIw2rSj4
         /HgfK6juOOuN4uGrGXG6rX+fxV+OVb6EHZIBWR/EMV3GCTb0k9CrSpganG/Ssj3QDgeY
         zPQnbIhUd3FOaDjt0Ue91bOe0V2tSy/NaPrLstyBlCLM+rW9SOyU4E0zEODcsbBJd6Q5
         +evxxRIG1aD6xhXePtdGNMvwKaZT+uE54Migq+DyrSVqLjjlfehbxn0kqka78nCfafym
         3XQg==
X-Gm-Message-State: AFuF++neXQCX9piSXvH8V8/lju3/tROec9WuNYf3fcnukpEi4lQTVAcZ
	JKbeWI0gOBafjXfUf7bUS5Bd6eM7t/5CDu9hP1YuLWmUc2uh4zr4wv84
X-Gm-Gg: AYBFou1B7VfwX4zri2MJTu8NdlxG95dhYKnIcOLUT9qx1LbLr4T+Q2fx3+c9S6KIL6g
	9TvTZ42qDWYLPw8taHoG8w0wCp0XpYbFarC52Jpx2Zlsg1/GkHh8nXFrrXSs3IHdOgAQcKVevKm
	/aAImeZqjT/xQy6JjoCfgmn73NVfvv3YQNXMfwPf97YeV1tZGvlO13zfJ3aCqp1Nhdk3zQjfpex
	uJr0MyAg6mDlIubpAsQwDK1eOxT8V9HbObDofA9paEyg5KeYj2ygE/kROc2IC2hsYs9abSzkBZH
	8bfigGmZIWyEuCCkQo1uk2eLx8ulk1WP4OSxHEXypOTNqVZB5xfLJpL8JwfxvCDr5rZcA035VXE
	nl4+BiN3Y7mekx7IK2ThweqfNHe3r52lCMZt1XyJbcyceaFDDWLxeZ5XEReKdtV+vmiCLb6x5zo
	EYBpJnebx9JzjTSZm4dxVQQKkCtJnvJmYgbQ1LUCy4evV9tj6h2E7pPAhD9PK+wVxPD5rA6AcJV
	zVSvvsqX4wLpBActGEUYlHo
X-Received: by 2002:a17:902:d2ce:b0:2db:39da:90f2 with SMTP id d9443c01a7336-2db39da9312mr124170685ad.8.1788756538478;
        Sun, 06 Sep 2026 21:48:58 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa33e96sm23834001eec.12.2026.09.06.21.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:48:58 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] wifi: rtl8xxxu: fix typo "Tranceiver" in comment
Date: Mon,  7 Sep 2026 10:18:50 +0530
Message-ID: <20260907044851.9884-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907044851.9884-1-hemanth.selam@gmail.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "Tranceiver" to "Transceiver", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches a
comment, no code changes.

Split out of a single "wifi: realtek:" patch in v1, as Ping-Ke Shih asked.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/regs.h b/drivers/net/wireless/realtek/rtl8xxxu/regs.h
index eafaef1438b9..2131d07c5801 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/regs.h
@@ -982,7 +982,7 @@
 #define REG_NHM_TH3_TO_TH0_8723B	0x0898
 #define REG_NHM_TH7_TO_TH4_8723B	0x089c
 
-#define REG_FPGA0_XA_LSSI_READBACK	0x08a0	/* Tranceiver LSSI Readback */
+#define REG_FPGA0_XA_LSSI_READBACK	0x08a0	/* Transceiver LSSI Readback */
 #define REG_FPGA0_XB_LSSI_READBACK	0x08a4
 #define REG_FPGA0_PSD_REPORT		0x08b4
 #define REG_HSPI_XA_READBACK		0x08b8	/* Transceiver A HSPI read */
