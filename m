Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803C51FCD3
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547998; cv=none; b=Hhg/ylLxiRm0z3RAJJj6sP3wULHIT9vNfQLqwWn/udwGCqnOqqn88PxKZ1MZWhTaZDigh1/uRFNk/pejHic9cboYDMgGgEJTGW7Q1ajei7oxSyPLsj9TyWG94AoC1hhvy/AtkrtVR6xxa/0CacM+qLUE+jYbrkT9gDkceLFYtoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547998; c=relaxed/simple;
	bh=EZdaHNjU+TIXVe4GCjTzp2mJ0V1U6rUpYJ8v6fB/t8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHhzx17ow1jVrgPbeH86yomZQAEau/diDE6wUf4Y+IxukCdriGD5Fghy+KDk1/GbIvfil0C1SLaKsc5OV1RR4diNST+UEFJUTsm7CLcPYIdDEav0tmTHvqq7UuVuSevkE73rXzU2EvT5kDz8lzFa+DTbYd5tRsSw+KTNybR10G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOdXFWcu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOdXFWcu"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso12710865e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547994; x=1789152794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K8YmC3OILkqrRt2yACBkxysDZXA8U3Xzaub87X9aEHc=;
        b=aOdXFWcu1MQKzgnUQmcUQ/Ft1eQzast+KzSNf3hA8X0VGH/tVODP7J0t2bK1OGhYo1
         a22pNeqhE3/NNDSTLwcnMYMp+Va9TNE9Yi4YUgTkmIrnEeT3FN4vCsTgvvCnnO8tgh1l
         nFsV3VlY2+b0iQSo7BFn2Mc6z4bX2txV0z7I0nsr9+Lhppmbe84zseZ0JZePHOvvVdCm
         XhEA34U2gIKfOKRcujSGwoinSCW6y8QjnKJbnM4W13AKEmSQWVz+Cau0DVCvTwcaNy1l
         5S9NnRHhH4CXXMid1hZHq9QYkJTuu3V/OTQK7vNvCTcHzcMacaHDr9yVu6z0ZIVJqip1
         8jJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547994; x=1789152794;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K8YmC3OILkqrRt2yACBkxysDZXA8U3Xzaub87X9aEHc=;
        b=UKbrhuvQECRGlKfq/5JRRbI++/8pBTxzBGI+WnDuzRSe/9j3GmCeMvMb0v22HEXhvB
         t2b4mfWraAKidpTqGL/SkZn+Vcf2pactxewjrP/gzjAWcsPCTlSyQbisgosMn0kg0j+4
         X5AvnvQt3ISRGyqYHw9hF7SwetL8CqcRA/VDSd2PXtVQC/bMjvxh/KBtgTnAzvDRLv9B
         MS5phhVD51L1kXzQn7fyOe5LIyqphkGHtfsM7bCBl5T5l8f5Boy6Whu6wx/qHuASmtK1
         qvzSn5DNMMeiWHNS4LzdDiI17vOPTWGVsfHowt/A3mmDw4E9SGz7Zz/q6M5z0Z3fMkCK
         CjZw==
X-Forwarded-Encrypted: i=1; AKwUvBwULSFrTL6RtRO7d+lsXulPZUofRzjp9vfAgSZXwcbGlp7FXiA2LidjQeqYBUOXOv6iZBYoFf4McY6hhpzkYw==@vger.kernel.org
X-Gm-Message-State: AFuF++lcwZBWbywqufkD5NUz2pPtcrX4/sbP8OqAFkkNR5S0uk8Npuv9
	eF8OgpZC2Xd7YafiARZf16JhdjMljGarwYw+cNTOnUMbcbvlqQ4fBNBvLPKc
X-Gm-Gg: AYBFou1Qx3hcoWmZ/p3TyDn+Wf5c/rQVn/a74n+jwrIIQW67HdQOpp21p7K5L+YxxTm
	NBZ/avSYwnOr65m6FPjN2vo9Vpo9gwNk4tHCORF5a+zY8UF1apujTBGCZkWpdd9Y3gXnV2HMhLf
	ZeDxaiL3wXmD071gjuAZVWDM21L3JE6V+y8Yg1BH2l4Zzi6lJ4riD2NkUOA4+XBawJWew3FDdia
	XPCAUKFs1bA4yiDJIjQ0gL3RNKYNkLjn41eDLlxKhOldHQxV088Bf8nG6AeiJE6hEZvxFTAszVU
	yugi1vdzM9rVzBSz4QF8938jkbjVXMLAaznbAgaGNxo1yBuGAsByjdpqD11rSzg0s2p8DL0JiD7
	KTIGb9K9DHL6qjAEsdmn+UzRdFf+ee6RzMRt6rGsR9sfNuoI+QZREUQ33T59qgT+O14lOTBPxAc
	zZ6L++/GsMnG8Ly7YKSW8v+XXGg2menwad/d6Qz5bfZMPqyN08AxyDsyER2TWb6wgtQ9qFk5jrf
	z/sWwPI729dlrysixvpxCUGX5Qv7IkGH8ijQzkr7hmjzqKhc9qan9NO1u6ff4lSP+I/Z3V8JFBE
	Ux68
X-Received: by 2002:a05:600c:4e4c:b0:499:621a:2ec2 with SMTP id 5b1f17b1804b1-49cf8206e4dmr84668845e9.3.1788547994177;
        Fri, 04 Sep 2026 11:53:14 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:13 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] wifi: ath9k: batch the read-modify-writes of a channel change
Date: Fri,  4 Sep 2026 21:52:52 +0300
Message-ID: <20260904185253.809209-5-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
References: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ar5008_hw_set_delta_slope() and ath9k_hw_start_nfcal() each issue a run
of read-modify-writes with no register read in between. Both run on
every channel change, and on the USB devices each REG_RMW is a separate
WMI command.

Wrap both runs in ENABLE_REG_RMW_BUFFER() and REG_RMW_BUFFER_FLUSH() so
the USB transport sends each run as one command. PCI does not install
the buffer callbacks, so the macros do nothing there and the writes are
issued as before. The same holds for USB devices with firmware older
than 1.4, which have no WMI_REG_RMW_CMDID. ar5008_hw_set_delta_slope()
is the AR5008 and AR9002 callback; AR9003 has its own and is not
touched.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 ++
 drivers/net/wireless/ath/ath9k/calib.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 7a45f5f62826..af05dcf95a61 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -868,6 +868,7 @@ static void ar5008_hw_set_delta_slope(struct ath_hw *ah,
 	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
 				      &ds_coef_exp);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
 		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
 	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
@@ -882,6 +883,7 @@ static void ar5008_hw_set_delta_slope(struct ath_hw *ah,
 		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
 	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
 		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 static bool ar5008_hw_rfbus_req(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index b4ab85bd7895..73c63ab32d53 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -224,6 +224,7 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 	if (ah->caldata)
 		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL(ah),
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
 
@@ -235,6 +236,7 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
 
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL(ah), AR_PHY_AGC_CONTROL_NF);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
-- 
2.55.0

