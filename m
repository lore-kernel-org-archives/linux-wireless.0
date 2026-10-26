Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993043;
	b=WyUVih6bfpklDnUULtC/Dmc9K9q7vZ7cy5vAo3tODnX9wtgqkx/RV48G5wqAF7VvnLI3
	 T/N8BYG9aqp9UfGYtAvSO2qePY8v9UNWPz+kOm97jQky/67NvbHd2LPWE3tF5r4e+dSWf
	 nrir7Oh7HsuxqTHckGgxww3SXv4Bdz1VDvRbeceYAXNQe6DzxXYoz95wIQZeZqv4madn2
	 zl425cyEJIoqD/nWCLFJstiCs8Xbv70BJMRTnPwcVSDHDMtiULpzNBgaSCFFTurapRLBc
	 nOZHO4xNBMa1yIIRWaTh9u3Jz8ZFpDpV5iqQD03UfKWAEpciY5aCZhIL8enbgjBDzJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZTaBGOKPSVOoy0RZ3YHBJw6ahpIeIXPfnYZWqJHFJMY=;
	b=f4uoUEUAl92ctZMQLw6Z0oZBt/Yr28GQjx60JYLPDO5O85UYM/FEOH1K4AvduCsRAVRP
	 p4BcaGo62JmupuRFRVgdWTKO0MvF6B2s6rEqSbZEYFKFBiX1b4xMSKPmjClNQpbOOm4El
	 jAM8p5WMprjUUWPACafPMoKin0cxHwsHGUmTiMoJyWraAfOc7HOI48ttcoNcD+1kcDXAH
	 dIR9Yn0O4ECfNQeDs7QQXLxFEAOfahbK0q/mKfs9UstyTPJnNs0OtgtoYE4sapSoMLrHD
	 guH+oRO9BaeXTHADfpNLoKXsyv4D79iPn9u5htsIlwUzsacLTAi6FSV2Mg1GaP3o7fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=arR4P0H6;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC23D60A2606
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC23D60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=arR4P0H6
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-881269371acso1401055b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993042; x=1793597842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTaBGOKPSVOoy0RZ3YHBJw6ahpIeIXPfnYZWqJHFJMY=;
        b=arR4P0H6CdRaEXnINz3VbHrvr6YyZY/h4MbMAl71rkr1gs6zyRFbBDUtQfblbw09PR
         R5t5lASOIHLkYsy8J0eEWEN+43gdvoU+GB0Yno5rLBftuR6So0nXwCE76zNTYlmP0h2D
         +aX7IZvlD73OIolbT4iWulChF+66gVHEVBDBuXbFlfgp++zTSwIgCPtLcpyfz6QxxcDS
         cb8BOA+I6wn5cthUok6XNQ2QMAS+gt37Kbl4CB/6SsEiC979E93eLx3Cdv5X2aQVxU2Q
         /VQYscFuHk7Z0r0CutgG1RXYtCWJnB3+2FmQ7z2UZKODw0VdYZ/D8/ApsLHHU3xy1iDs
         6PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993042; x=1793597842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZTaBGOKPSVOoy0RZ3YHBJw6ahpIeIXPfnYZWqJHFJMY=;
        b=GNy7dXkEUXiQhgxvlr9TuF1w8BET3lF36cCrh/aIugjJLgSIrKcqJv0rJAEnKuIKTc
         dnpw/lbxpynuiP+o0uGHZq9r8xwG+oKPQjooXc5KVOkWIlSH0+dEeLFHhU6yBtjSI+9A
         oXQpW5zmbpVcsywkChKZJJOlDDvqtvYBKwss/tye2rRYlg/OF30ZMqXNJMFkzJvE1ipX
         QiLIqqZW8gFVEiHIElatLgP3xeKF3metmNrFY1agHXmNJ7zO404bRFU1u6CPAEszlU2e
         Oq/6ZPyUrqjgw9UBY/x/QwPO3hmZIuwVdQCCKPKP1olII/tOza6IY4CCSFfPlHw8X7pS
         V3lA==
X-Gm-Message-State: AFq9FYJ2MAFlIHwO81WpuzqgSqsCBx0dBmQ/q2WhjWqCezFtsCVy5k30
	sVcdGw+ARSJ1WMFOmJFhxKH8MaqpU+2fKH18A+/7Ufa9p7leRJxTz21iTx/UL2V+Kw0aJA==
X-Gm-Gg: AYBFou3vFO/jbO1q5S96znTdbEMP/FiCXwROCX1Azr86IzE7B63lla6Dc+Fqz0ot0pt
	CPdCB5yRHVHPAJmpedzYVvz4sm9lLprSKjDFt/3rxLE0QyzU/i1GQoZYnbK285MxPi3OyYb/ktZ
	JYH7ZaDSmJF41ylWb86mSTO6oZZC09oZ4jQsHkxGXIYvAFk5NpgU684HZXVSOCWGjhbD15/+lvd
	AY6G9H+vhHled7cOHPPibBbFfAiYM8HorD8RsKqIxHRNYv1HMu2Xq7U1o9buycKlYzST9sdhTKv
	v0oC1h3GusNSeGk7SNwtddEA40p58dwfNxvt/7eX8dge9DmiXMLQLe+xjfchBEtI6ktZeTZ3MK6
	KvZXG3Z8Lx9egBNb8dlec2DOwikDHxJUEH043gtoEx4W4bNkFr1hcIc0oS1VYuO/pAiNOYNiTiC
	1rMpYogj4keP5SRcBznULnkAsUxSfYOJpsMT4OCxiNobLS3bUCGN92YRn62f5gndIBFpCqFw1Es
	j1boDy/DTxbfzlb/+7q3NO+2qDkcVxAjZJGEXUW4ZXtS2ZdPE/ookuoQsEIyixhR8B4CvqPf0zs
	xFBa
X-Received: by 2002:a05:6a00:4092:b0:898:3e:3101 with SMTP id d2e1a72fcca58-8a366e6ee2cmr3141056b3a.31.1792993042332;
        Sun, 25 Oct 2026 22:37:22 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:22 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 09/17] wifi: brcm80211: move the USB bootloader definitions to a shared header
Date: Mon, 26 Oct 2026 13:36:15 +0800
Message-ID: <20261026053633.361454-10-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

The Broadcom USB bootloader downloads firmware the same way for other
USB chips than the FullMAC ones of brcmfmac.  Move its commands, states,
firmware header and response layouts from brcmfmac's usb.c to a header
in the shared include directory, so that other drivers can use them.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/usb.c         | 68 +---------------
 .../broadcom/brcm80211/include/brcm_usb_rdl.h | 77 +++++++++++++++++++
 2 files changed, 78 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/include/brcm_usb_rdl.h

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index b41949a9b..e48f06468 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -12,6 +12,7 @@
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
+#include <brcm_usb_rdl.h>
 #include "bus.h"
 #include "debug.h"
 #include "firmware.h"
@@ -26,8 +27,6 @@
 #define BRCMF_USB_RESET_GETVER_SPINWAIT	100	/* in unit of ms */
 #define BRCMF_USB_RESET_GETVER_LOOP_CNT	10
 
-#define BRCMF_POSTBOOT_ID		0xA123  /* ID to detect if dongle
-						   has boot up */
 #define BRCMF_USB_NRXQ			50
 #define BRCMF_USB_NTXQ			50
 
@@ -52,71 +51,6 @@ static const struct brcmf_firmware_mapping brcmf_usb_fwnames[] = {
 	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373)
 };
 
-#define TRX_MAGIC		0x30524448	/* "HDR0" */
-#define TRX_MAX_OFFSET		3		/* Max number of file offsets */
-#define TRX_UNCOMP_IMAGE	0x20		/* Trx holds uncompressed img */
-#define TRX_RDL_CHUNK		1500		/* size of each dl transfer */
-#define TRX_OFFSETS_DLFWLEN_IDX	0
-
-/* Control messages: bRequest values */
-#define DL_GETSTATE	0	/* returns the rdl_state_t struct */
-#define DL_CHECK_CRC	1	/* currently unused */
-#define DL_GO		2	/* execute downloaded image */
-#define DL_START	3	/* initialize dl state */
-#define DL_REBOOT	4	/* reboot the device in 2 seconds */
-#define DL_GETVER	5	/* returns the bootrom_id_t struct */
-#define DL_GO_PROTECTED	6	/* execute the downloaded code and set reset
-				 * event to occur in 2 seconds.  It is the
-				 * responsibility of the downloaded code to
-				 * clear this event
-				 */
-#define DL_EXEC		7	/* jump to a supplied address */
-#define DL_RESETCFG	8	/* To support single enum on dongle
-				 * - Not used by bootloader
-				 */
-#define DL_DEFER_RESP_OK 9	/* Potentially defer the response to setup
-				 * if resp unavailable
-				 */
-
-/* states */
-#define DL_WAITING	0	/* waiting to rx first pkt */
-#define DL_READY	1	/* hdr was good, waiting for more of the
-				 * compressed image
-				 */
-#define DL_BAD_HDR	2	/* hdr was corrupted */
-#define DL_BAD_CRC	3	/* compressed image was corrupted */
-#define DL_RUNNABLE	4	/* download was successful,waiting for go cmd */
-#define DL_START_FAIL	5	/* failed to initialize correctly */
-#define DL_NVRAM_TOOBIG	6	/* host specified nvram data exceeds DL_NVRAM
-				 * value
-				 */
-#define DL_IMAGE_TOOBIG	7	/* firmware image too big */
-
-
-struct trx_header_le {
-	__le32 magic;		/* "HDR0" */
-	__le32 len;		/* Length of file including header */
-	__le32 crc32;		/* CRC from flag_version to end of file */
-	__le32 flag_version;	/* 0:15 flags, 16:31 version */
-	__le32 offsets[TRX_MAX_OFFSET];	/* Offsets of partitions from start of
-					 * header
-					 */
-};
-
-struct rdl_state_le {
-	__le32 state;
-	__le32 bytes;
-};
-
-struct bootrom_id_le {
-	__le32 chip;		/* Chip id */
-	__le32 chiprev;		/* Chip rev */
-	__le32 ramsize;		/* Size of  RAM */
-	__le32 remapbase;	/* Current remap base address */
-	__le32 boardtype;	/* Type of board */
-	__le32 boardrev;	/* Board revision */
-};
-
 struct brcmf_usbdev_info {
 	struct brcmf_usbdev bus_pub; /* MUST BE FIRST */
 	spinlock_t qlock;
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_usb_rdl.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_usb_rdl.h
new file mode 100644
index 000000000..cf8492a55
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_usb_rdl.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ */
+
+#ifndef	_BRCM_USB_RDL_H_
+#define	_BRCM_USB_RDL_H_
+
+#include <linux/types.h>
+
+#define BRCMF_POSTBOOT_ID	0xA123  /* ID to detect if dongle has boot up */
+
+#define TRX_MAGIC		0x30524448	/* "HDR0" */
+#define TRX_MAX_OFFSET		3		/* Max number of file offsets */
+#define TRX_UNCOMP_IMAGE	0x20		/* Trx holds uncompressed img */
+#define TRX_RDL_CHUNK		1500		/* size of each dl transfer */
+#define TRX_OFFSETS_DLFWLEN_IDX	0
+
+/* Control messages: bRequest values */
+#define DL_GETSTATE	0	/* returns the rdl_state_t struct */
+#define DL_CHECK_CRC	1	/* currently unused */
+#define DL_GO		2	/* execute downloaded image */
+#define DL_START	3	/* initialize dl state */
+#define DL_REBOOT	4	/* reboot the device in 2 seconds */
+#define DL_GETVER	5	/* returns the bootrom_id_t struct */
+#define DL_GO_PROTECTED	6	/* execute the downloaded code and set reset
+				 * event to occur in 2 seconds.  It is the
+				 * responsibility of the downloaded code to
+				 * clear this event
+				 */
+#define DL_EXEC		7	/* jump to a supplied address */
+#define DL_RESETCFG	8	/* To support single enum on dongle
+				 * - Not used by bootloader
+				 */
+#define DL_DEFER_RESP_OK 9	/* Potentially defer the response to setup
+				 * if resp unavailable
+				 */
+
+/* states */
+#define DL_WAITING	0	/* waiting to rx first pkt */
+#define DL_READY	1	/* hdr was good, waiting for more of the
+				 * compressed image
+				 */
+#define DL_BAD_HDR	2	/* hdr was corrupted */
+#define DL_BAD_CRC	3	/* compressed image was corrupted */
+#define DL_RUNNABLE	4	/* download was successful,waiting for go cmd */
+#define DL_START_FAIL	5	/* failed to initialize correctly */
+#define DL_NVRAM_TOOBIG	6	/* host specified nvram data exceeds DL_NVRAM
+				 * value
+				 */
+#define DL_IMAGE_TOOBIG	7	/* firmware image too big */
+
+struct trx_header_le {
+	__le32 magic;		/* "HDR0" */
+	__le32 len;		/* Length of file including header */
+	__le32 crc32;		/* CRC from flag_version to end of file */
+	__le32 flag_version;	/* 0:15 flags, 16:31 version */
+	__le32 offsets[TRX_MAX_OFFSET];	/* Offsets of partitions from start of
+					 * header
+					 */
+};
+
+struct rdl_state_le {
+	__le32 state;
+	__le32 bytes;
+};
+
+struct bootrom_id_le {
+	__le32 chip;		/* Chip id */
+	__le32 chiprev;		/* Chip rev */
+	__le32 ramsize;		/* Size of  RAM */
+	__le32 remapbase;	/* Current remap base address */
+	__le32 boardtype;	/* Type of board */
+	__le32 boardrev;	/* Board revision */
+};
+
+#endif /* _BRCM_USB_RDL_H_ */
-- 
2.53.0

