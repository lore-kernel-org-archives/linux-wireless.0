Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E3747F782
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367940; cv=none; b=mCkif+RDAn0W9DY1dMhbKr58u5vWOafqgL9l/SnKHpCp5+zK6wC2OwP8dGROd6ZWhzu1ZaDBz+oI602Ed1hfwKOwg+zoIYjJwBNspOyWULnke+vV55qIGXBTxrO/LRpG5GKPiPtt88M1znFFAwvfT0SoJVjv9xTjxiZdi44GSY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367940; c=relaxed/simple;
	bh=spsixaFG+hKROdXQF95G+ohS8MHPUdwO/nqxI1CUmEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=auKJIGwp8QVYz/2TNJok3TjoZ+l4hic2JqIKivpEFDCCVDxZ4DGWPCedJf0AANpqEOGev9+tkarxT7yUdEioezLXxwBkhyb/umZh3VBJjFc/IvaxyKSTZEfWQXvZ6e/R8/F1Nz7xpF73mEBh/mtxnwzxIBcft6odrVrbzihSH7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=aJ6Ld0BP; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="aJ6Ld0BP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367939; x=1819903939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=spsixaFG+hKROdXQF95G+ohS8MHPUdwO/nqxI1CUmEE=;
  b=aJ6Ld0BP//TrFrQxwLuFCVP83SGTP7F/ssUqqQV4AXI00WcbKWfeLbLB
   AQJ8Y7es+ItwWDvmBdLtO8VPxxsL7lX/rjMb+AM6YRivWtcHMMPGBPojv
   Aq/XlhdV8QF3CnrlGIbrnaxpvXesIZRcsry14Xism/HPWRNCfCtMKpQ6U
   k=;
X-CSE-ConnectionGUID: umruHtbxSFyDMcNAE3+dOQ==
X-CSE-MsgGUID: mxGLIZU7QLC4HvvR7/Z0wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="145161101"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="145161101"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:52:10 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:52:09 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:52:08 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 04/25] wifi: inffmac: add trxhdr.h
Date: Wed, 2 Sep 2026 16:50:35 +0000
Message-ID: <20260902165057.456447-5-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE814.infineon.com (172.23.29.40) To
 MUCSE827.infineon.com (172.23.29.20)

Definitions of the Metadata in the Device Firmware binary files.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/trxhdr.h    | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/trxhdr.h

diff --git a/drivers/net/wireless/infineon/inffmac/trxhdr.h b/drivers/net/wireless/infineon/inffmac/trxhdr.h
new file mode 100644
index 000000000000..edb2a2ee0443
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/trxhdr.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2020-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_TRXHDR_H
+#define INFF_TRXHDR_H
+
+/* Bootloader makes special use of trx header "offsets" array */
+enum {
+	TRX_OFFSET_SIGN_INFO_IDX		= 0,
+	TRX_OFFSET_DATA_FOR_SIGN1_IDX		= 1,
+	TRX_OFFSET_DATA_FOR_SIGN2_IDX		= 2,
+	TRX_OFFSET_ROOT_MODULUS_IDX		= 3,
+	TRX_OFFSET_ROOT_EXPONENT_IDX		= 67,
+	TRX_OFFSET_CONT_MODULUS_IDX		= 68,
+	TRX_OFFSET_CONT_EXPONENT_IDX		= 132,
+	TRX_OFFSET_HASH_FW_IDX			= 133,
+	TRX_OFFSET_FW_LEN_IDX			= 149,
+	TRX_OFFSET_TR_RST_IDX			= 150,
+	TRX_OFFSET_FW_VER_FOR_ANTIROOLBACK_IDX	= 151,
+	TRX_OFFSET_IV_IDX			= 152,
+	TRX_OFFSET_NONCE_IDX			= 160,
+	TRX_OFFSET_SIGN_INFO2_IDX		= 168,
+	TRX_OFFSET_MAX_IDX
+};
+
+#define TRX_MAGIC	0x30524448		/* "HDR0" */
+#define TRX_VERSION	4			/* Version 4 */
+#define TRX_MAX_OFFSET	TRX_OFFSET_MAX_IDX	/* Max number of file offsets */
+
+struct trx_header_le {
+	__le32 magic;		/* "HDR0" */
+	__le32 len;		/* Length of file including header */
+	__le32 crc32;		/* CRC from flag_version to end of file */
+	__le32 flag_version;	/* 0:15 flags, 16:31 version */
+	__le32 offsets[TRX_MAX_OFFSET];	/* Offsets of partitions */
+};
+
+#define TRX_VERSION5	5			/* Version 5 */
+
+struct trxv5_header_le {
+	__le32 magic;		/* "HDR0" */
+	__le32 len;			/* Length of file including header */
+	__le32 crc32;		/* 32-bit CRC from flag_version to end of file */
+	__le32 flag_version;	/* 0:15 flags, 16:31 version */
+	__le32 root_cert_start_offset;	/* Start Offset IDX for Root Certificate */
+	__le32 content_cert_start_offset;	/* Start Offset IDX for Content Certificate */
+	__le32 fw_entry;	/* Firmware Entry Point for CM mode */
+	__le32 reserved;
+};
+
+#endif /* INFF_TRXHDR_H */
-- 
2.43.0

