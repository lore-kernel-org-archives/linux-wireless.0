Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195544FC8F4
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860352; cv=none; b=JQsfaFEvc8EiNZcD/FR7bMxnGZoIF4ojor3VExP5FtmWPJnTVJLZAntGMzVDH98SAhOLz+6U2dbY6gkhcjcasLuoKF2ak36T3mZkWIAGZ44sz61C7XLycbxOHT1QmznmH6eRobVeeyfhdEvQZKfXTZ+auZhutvH0mkVamDdkows=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860352; c=relaxed/simple;
	bh=qrqXw+BwjIJFKdstGQAN4+oyo/cF1qAWVyQbjsOTyHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPta3xNEDxHoW1hYiErptIWAqArgI70CkxhDXkWfMqcyqmclwvvj4S3fpLtwoEsK1ycuzmf5zr7cOhvFU5t/CkEkxTG1beLtCCd72l8cLCR5oRp9ESdCt42J28XIauqOmoIJf/7GP5XbKEIVUFbeKZde5MPNcCQzAJzDWC0hHVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0fl67bf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0fl67bf"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d8f265cbe6so33930935ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 02:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860350; x=1789465150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FircOyEpe4b2jldkLo347QbktMO+xUZbOtLdp+AOv2c=;
        b=A0fl67bfCdb8WZ24ftVcEl4uZ7ST41cjOZwfZ+0DB+qGiRLox+6+udWjE74NHxRliM
         eHs2+J50YuVR/bQIEQ2TsDBsdnWPL6jBGFAvbTZbuJyPnKtAQSLDOSCc4G9czgp6WFPH
         L9QMn/pqzghJKOtcIKSo+DPeUTeJcMTvm6Yx5AaUc2XuPgMxYiitZ1dOrStfieHw4ZtM
         wZ7B4hlPsxn3VS8gj5nPc2TIs6T9CPK8Z9GjhLDzqiOf5AQTeQkqsJ0lKIPS08C86BbL
         VxuwHJX9gvPahQihOWLNbhljSWTWBD8ZD8fpnGGIaVAK11xBvfwvWOKmAvDX35ghJ5GO
         2SuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860350; x=1789465150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FircOyEpe4b2jldkLo347QbktMO+xUZbOtLdp+AOv2c=;
        b=DmIQVgxjDtVvxlELh8XMH7lSn7r6a8Lbnbyz/kNNFB32H8jWLNGRe38pXA7rBzm4kE
         ngfgV+4hT0y+utles7rWPfJOBdXsXiJ49/dgAGUqdcuELmpRRLMbrpwZcj0E1fp/FJa+
         nspFz9FZr4ZjLUtJXFtK/qvQBkHNc9CJ8YpBVjJn4zaS3TENq4ZFwkS2ALGtNEBkcgdY
         Bug3Y5ZYkRWejkKCQatllMj6aKvtibmtNOuF9cbZ01wQlSnEqfz2mh5qO/RpqBZLt/6P
         hlZYxEEMXdeLr+VOCiiN2CBtn/pdI3tKZMoVR2R67xWK2PSFStYY1FuMGSdrcTpJD0Nq
         rO+g==
X-Gm-Message-State: AFuF++nCQ8AqjC3hKVoOx6BpdfveBeTwxr97HbbdHuY5tH+ibmwW8dwp
	nCRhMCjRbmZpF4j2+bzM16j6l+TuKOLvK8yY9W4S2auF0Qym4tkJHs+uEHTFoszMwu0=
X-Gm-Gg: AYBFou1lBadcx2HD71sh0s36s5C1kaeZU8fwQn8XuFbE6+KGqXYi/fNGOAiG7VYAFRJ
	isfp691pGfQi8Os7oFJLN8edV5I5cw2jKOk7Rg9IN2NbuKfz14T3sWQJRAY2fhLziF/Gnj9i4yq
	QVNpQEJcKlgS5X3uzQy0tH4+A1wHwPfVDTFg+o0d8VHTRqAZwZxSBKHdlNIkvrXrmc2WFYOoNS9
	HoPpLtS/nOba2e8IVxN06RTBMPASraJcjo9xc16yK+lGayqfMW1SWGcjDLmRfB3PKsNvSgQPQCY
	7jgsbRgnAnDSq9wmzW3YH8LGV/iQReZYXBe64UaIIxZH69wjOEUHPikNWa6hl7ACIa5yRvW1AKA
	1QK9FBmByO/bIIHTUvBLbXQVO8KZCYp2Q/+voDi0M8xIuO/7X3XK9sEm63l2aaMvOQBN4felUlz
	Apqlu+7SEyy295lDYE1VVXYIcZMj+ghBAhg2nmTxqt1YuQVHPOYv8KcsX0V9rqUGsRdoPq0gUXK
	IkHAL51ESfFFujxQ1TwDStZqlkpffCVGlwuzibu0rSMywbEMOJrBC9UwuJg/7ihIsM0M6S2i6ze
	Ng==
X-Received: by 2002:a17:902:f642:b0:2d9:3be4:7e31 with SMTP id d9443c01a7336-2db12508aa9mr427344645ad.5.1788860350295;
        Tue, 08 Sep 2026 02:39:10 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9f9sm54848085ad.32.2026.09.08.02.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:39:09 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-mmc@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next 3/4] wifi: nxpwifi: Add support for SDIO-based IW610
Date: Tue,  8 Sep 2026 17:37:57 +0800
Message-Id: <20260908093758.596444-4-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093758.596444-1-chunfan.chen@gmail.com>
References: <20260908093758.596444-1-chunfan.chen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

Add the IW610 SDIO device ID to the supported device table. This
enables driver probing, interface initialization, and firmware
download for the NXP IW610 wireless chipset.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/sdio.c | 16 ++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sdio.c b/drivers/net/wireless/nxp/nxpwifi/sdio.c
index 8ef0f6eb49e2..f4de494bf2f2 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sdio.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sdio.c
@@ -96,6 +96,19 @@ static const struct nxpwifi_sdio_device nxpwifi_sdio_iw61x = {
 	.can_ext_scan = true,
 };
 
+static const struct nxpwifi_sdio_device nxpwifi_sdio_iw610 = {
+	.firmware = IW610_SDIO_FW_NAME,
+	.reg = &nxpwifi_reg_iw61x,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = NXPWIFI_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = NXPWIFI_MP_AGGR_BSIZE_MAX,
+	.mp_rx_agg_buf_size = NXPWIFI_MP_AGGR_BSIZE_MAX,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_ext_scan = true,
+};
+
 static struct memory_type_mapping generic_mem_type_map[] = {
 	{"DUMP", NULL, 0, 0xDD},
 };
@@ -458,6 +471,8 @@ static void nxpwifi_sdio_coredump(struct device *dev)
 static const struct sdio_device_id nxpwifi_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW61X),
 		.driver_data = (unsigned long)&nxpwifi_sdio_iw61x},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW610),
+		.driver_data = (unsigned long)&nxpwifi_sdio_iw610},
 	{},
 };
 
@@ -2326,3 +2341,4 @@ MODULE_DESCRIPTION("NXP WiFi SDIO Driver version " SDIO_VERSION);
 MODULE_VERSION(SDIO_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(IW61X_SDIO_FW_NAME);
+MODULE_FIRMWARE(IW610_SDIO_FW_NAME);
diff --git a/drivers/net/wireless/nxp/nxpwifi/sdio.h b/drivers/net/wireless/nxp/nxpwifi/sdio.h
index de5c884a5b14..e9881448fe2f 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sdio.h
+++ b/drivers/net/wireless/nxp/nxpwifi/sdio.h
@@ -11,6 +11,7 @@
 #include "main.h"
 
 #define IW61X_SDIO_FW_NAME     "nxp/sd_w61x_v1.bin.se"
+#define IW610_SDIO_FW_NAME     "nxp/sd_iw610.bin.se"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
-- 
2.34.1

