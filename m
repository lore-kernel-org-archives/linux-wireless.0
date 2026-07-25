Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50B392C32
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785003112; cv=none; b=bkSaxShxS98Mg6/zTBZNWPcxRUOq1Xzvu51qiE0o7OsfH0z32oH9k505jr2Hq/zDF0FpckteGW+2aIT79JQmWoKldeJB/f7wx1dvDHnZV/mYiIJAd3kXb6S+ScIzB7b91rLuXqkSaCCV6GQHOwTMozEfZ9nwjO+gGu1an3LMJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785003112; c=relaxed/simple;
	bh=C9zmnrENp6fcooDKzQPgxLmxCEBqdWSrUY4Kto1cU34=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P9q5DVAhGgSspbr1wiV2at91b1TQMKscrCKHt37BF7xBZ+sZZshDxgv7jD58ljKqs3odbvoneEKI62k6jZKwz85AG08bC1wHraEYeOgLSzFqXCdl5TjNNuMtabZuax2/MyOHrKIrex2LLcCXLRc++YEp5dLBjsuvojNbSh8z7N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ENQGeFAL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jbbMddrx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ENQGeFAL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jbbMddrx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PGxHE81978237
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IVw21EajYFGo2Uy1Ircyl9njPPqRM/2Kk9IHbzFuUK0=; b=ENQGeFAL2011Iyxw
	8Yejbsl9MRkeWW9zytVLZxxJazFmMedhWs17CQ0tV2XSzYWdfe/XZ9rzNM5uzWRf
	BfnJ3UVj2Rekdmsrk2E50XBLkL+ZeXSmjJCtcRtXsyPXX2s32b0OXgkOXoM0DkkD
	drohvWSRuR/LooQfkoj7UqMJBFPiKihTsHo9NMmiKX3FqIMnXx3gDVrV+2lIwGNC
	LtBdKP4HGVBgXvlIWGh6idZUZ5YRLY+bXD29f+EQo/99pDWUIr7/oOBAQwFqM59H
	O0hNH/I7/h3Tgdg8218Rr43BRYhJqtCKSvHOv+SlZ4B0MDO/6wl5cMhCz9nlPG7C
	7VH6jg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmpajh8yg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:50 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1622902a91.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785003110; x=1785607910; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IVw21EajYFGo2Uy1Ircyl9njPPqRM/2Kk9IHbzFuUK0=;
        b=jbbMddrxMK3EIr4Ztwsxiz7eRurSBjM0a8aXgvS47Aak36mpcBCBI/Hv487jk6dfK2
         W1ypcfzbYidVK3mmaRFKMd9WNUR9oPPuGv38+YC04TeCWvm+rPjozJDHqyNhXolA2Fhp
         UJAfh1THd8x4j84aNL4dveg7jWeKZEoSJwAZ6yIR+PzZFOGGCDweooYIu4EbvU6lTsHq
         M0j5JRuUygjhLI/upTbyGNSgRdARAckBva0HFw3SXBX7VgOhhM9t2vJHuv2krtzNNZYy
         0/r3ZcW/rR5Grau0tP7he4eWlpuloruZtPuqpxmVLOo1rMlZ5VDbj1+mEiEruuYIHvsM
         tpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003110; x=1785607910;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IVw21EajYFGo2Uy1Ircyl9njPPqRM/2Kk9IHbzFuUK0=;
        b=aXuR8PyBfBfRtePVEkAQS3RVPcHFZcjUKodjixZtXVXKFX4jKlqFByO0NjD6BM65Ww
         b5EutsxXmSHxKSxddcDfAvGjLX8HG0zmteSXkIwQBv2X5M9Yx5CWmah/wv0z+KwjbxvJ
         1gUOGC7pwUeSO66q+/8cpKAwcQ85HFb21Qp3+l4iMrRf3f6d0YlUqDPH4ih8YPBuNstL
         5PLM6xJ7w4i3+V/JUp6N43UW44/F0vpeIU8YxuelZ+BeYRbvlIgXytALJYltk4H+gHwj
         e4kxixpoCWJhO2ay8sjCgnwwqbRuYJ5OGAM/8rMFMt1r0myd9y5G+SUIc9z3z7YSTOOZ
         9JKw==
X-Gm-Message-State: AOJu0YzpOm+XFYsIPQLqW8puhbIdN04owIDfVenZjJf3MZCLOLzvZGmp
	lRK+cIzEfQol52G6xbTQSBRQc0fUEtw/+RGd8qTl/+kKXrpJi6lMRgy79cf6SScGkQM11HStGuG
	TgLnWc4oI5cH4e6eiDBGztAYOYEQzKfhmQzQeuBqQmaHP7waDxlVBxjE/WluJw/cizNwJ+Q==
X-Gm-Gg: AR+sD13pmz4VmnQ7mdKPJjc3RH5/1tU7rCfIC0YZPP5uJl0JHhCi0D6dPhbFvGmg1YR
	GRa1foLRyF+HgNKxTfPLLE8xEAGJU5ucdHS812j9aFtPnYCwChNotmfPFVWeEP+nFLMao9zrpgI
	Dx7NEkTXYNjTnQV+rWECTsYb7tofGjx5XoBTeWyCIlWyxh87hhd+9UX4OpLLyD7PsZ8ZkbRkDhN
	j3jl4Vb864EerM8VYEZ7uwO8bNIR9fDwmUT39J2h3C8lVtRm848DANJzBmU2pZl3YJks6CQzgIK
	P9Lqiql5FWFcmTbm+3BA19A9OHwNyJpfj/yOPQfD9AoumlMd4dT/s/j++35kuPABn6caBpYRrMt
	1yLjg1ZdEoQQ2uOVbQsncUbyI+xmiHcFPVkVOZOIoMJiV5x3mGcRUfYc=
X-Received: by 2002:a17:90b:5347:b0:387:e0db:bc34 with SMTP id 98e67ed59e1d1-38f298b386cmr2763301a91.42.1785003110195;
        Sat, 25 Jul 2026 11:11:50 -0700 (PDT)
X-Received: by 2002:a17:90b:5347:b0:387:e0db:bc34 with SMTP id 98e67ed59e1d1-38f298b386cmr2763285a91.42.1785003109777;
        Sat, 25 Jul 2026 11:11:49 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm64692635c88.2.2026.07.25.11.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 11:11:49 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Sat, 25 Jul 2026 11:11:45 -0700
Subject: [PATCH ath-next 1/2] wifi: ath12k: move firmware_mode enum to
 qmi.h
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260725-consolidate-firmware_mode-v1-1-aedff0ce0ba5@oss.qualcomm.com>
References: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
In-Reply-To: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Td3V98zhFQRhljUT_clWTkVkXG6tRwWB
X-Authority-Analysis: v=2.4 cv=A8Bc+aWG c=1 sm=1 tr=0 ts=6a64fc66 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=7UZE0HBkOswYJVh0bkIA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: Td3V98zhFQRhljUT_clWTkVkXG6tRwWB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfX8+u8wswNbCWE
 CnHH4NOCdrs6TbQrHLRQ6k5eif7u5o/ryzH3imHiEJxsZuCaAgU8G7PeFW5Zkx1430cC61ShHrF
 NZcUMr1r+0FWn+t/L345g6/7lfRQA/pxTSnQsSkUOu/uS1pepUl515xVCSgwc59ifeWcV8qjhax
 lbixTCqq2xb0gVK1TWmH+S/LuiLFladBBdRNCCjfFSBBGUbY+1D/1ckNdQXWQa2ctT5Hblh7qlp
 nUtDSqPIXmlFJtwq6R0jNwNcUm16UVVDDE2pX2h9hjPhjBIvSdZWbVfGN0jDMfa7Sl/fzf83OOH
 dw2hcjNsJowmgq9L/NkXjNOMfR3ADaUth807KfoFM6ghOZwvKBzkecVWNGYrWIplYHB06KLmKAa
 quE2KpU5eu5EPSb88jowrNtKKKQylviJaku0BqqABuig191bSMy76X7ZXnr6iaCUyVw50xbcf8b
 utU0ypJ+UW1upw9nyGA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfXyZVU9hGyWFxV
 Ufjof1LadfNGex9qu3Y+gMcUP7+7bltMsre9ev/HIrJU0O4v8gXKrYbMFQ9SLK21ZWX3AftAZzU
 SwRwGoo9ieQmMM66iXpB4nxQjlRryBk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250173

The enum ath12k_firmware_mode defines values that are part of the QMI
ABI, so it belongs in qmi.h rather than core.h. Consolidate it there
along with ATH12K_FIRMWARE_MODE_OFF, which is currently a bare macro.
Rename the enum to ath12k_qmi_firmware_mode to align with the naming
convention of the other enums in qmi.h, and place it with the other
ath12k_qmi_* enums.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c |  3 ++-
 drivers/net/wireless/ath/ath12k/core.h | 10 +---------
 drivers/net/wireless/ath/ath12k/pci.c  |  1 +
 drivers/net/wireless/ath/ath12k/qmi.c  |  4 ++--
 drivers/net/wireless/ath/ath12k/qmi.h  | 14 ++++++++++++--
 5 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a9112760185f..a052a77828f3 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -23,6 +23,7 @@
 #include "wow.h"
 #include "dp_cmn.h"
 #include "peer.h"
+#include "qmi.h"
 
 unsigned int ath12k_debug_mask;
 module_param_named(debug_mask, ath12k_debug_mask, uint, 0644);
@@ -1188,7 +1189,7 @@ static int ath12k_core_hw_group_start(struct ath12k_hw_group *ag)
 }
 
 static int ath12k_core_start_firmware(struct ath12k_base *ab,
-				      enum ath12k_firmware_mode mode)
+				      enum ath12k_qmi_firmware_mode mode)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index f9fb1399e0b6..a43959ebf46f 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -160,14 +160,6 @@ enum ath12k_hw_rev {
 	ATH12K_HW_IPQ5424_HW10,
 };
 
-enum ath12k_firmware_mode {
-	/* the default mode, standard 802.11 functionality */
-	ATH12K_FIRMWARE_MODE_NORMAL,
-
-	/* factory tests etc */
-	ATH12K_FIRMWARE_MODE_FTM,
-};
-
 #define ATH12K_IRQ_NUM_MAX 57
 #define ATH12K_EXT_IRQ_NUM_MAX	16
 #define ATH12K_MAX_TCL_RING_NUM	3
@@ -1143,7 +1135,7 @@ struct ath12k_base {
 
 	struct ath12k_hw_group *ag;
 	struct ath12k_wsi_info wsi_info;
-	enum ath12k_firmware_mode fw_mode;
+	enum ath12k_qmi_firmware_mode fw_mode;
 	struct ath12k_ftm_event_obj ftm_event_obj;
 	bool hw_group_ref;
 
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index ad74140e0fa5..907d29b1020c 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -17,6 +17,7 @@
 #include "mhi.h"
 #include "debug.h"
 #include "hal.h"
+#include "qmi.h"
 
 #define ATH12K_PCI_BAR_NUM		0
 #define ATH12K_PCI_DMA_MASK		36
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index bb61c78e5c29..c466c3ae793a 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3431,7 +3431,7 @@ int ath12k_qmi_wlanfw_aux_uc_info_send(struct ath12k_base *ab)
 }
 
 static int ath12k_qmi_wlanfw_mode_send(struct ath12k_base *ab,
-				       u32 mode)
+				       enum ath12k_qmi_firmware_mode mode)
 {
 	struct qmi_wlanfw_wlan_mode_req_msg_v01 req = {};
 	struct qmi_wlanfw_wlan_mode_resp_msg_v01 resp = {};
@@ -3631,7 +3631,7 @@ void ath12k_qmi_firmware_stop(struct ath12k_base *ab)
 }
 
 int ath12k_qmi_firmware_start(struct ath12k_base *ab,
-			      u32 mode)
+			      enum ath12k_qmi_firmware_mode mode)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index cbe5be30053a..27b69847a15e 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -32,7 +32,6 @@
 #define QMI_WLFW_FW_READY_IND_V01		0x0038
 
 #define QMI_WLANFW_MAX_DATA_SIZE_V01		6144
-#define ATH12K_FIRMWARE_MODE_OFF		4
 
 #define ATH12K_BOARD_ID_DEFAULT	0xFF
 
@@ -602,6 +601,17 @@ enum ath12k_qmi_mem_mode {
 	ATH12K_QMI_MEMORY_MODE_LOW_512_M,
 };
 
+enum ath12k_qmi_firmware_mode {
+	/* the default mode, standard 802.11 functionality */
+	ATH12K_FIRMWARE_MODE_NORMAL,
+
+	/* factory tests etc */
+	ATH12K_FIRMWARE_MODE_FTM,
+
+	/* firmware offline */
+	ATH12K_FIRMWARE_MODE_OFF = 4,
+};
+
 static inline void ath12k_qmi_set_event_block(struct ath12k_qmi *qmi, bool block)
 {
 	lockdep_assert_held(&qmi->event_lock);
@@ -617,7 +627,7 @@ static inline bool ath12k_qmi_get_event_block(struct ath12k_qmi *qmi)
 }
 
 int ath12k_qmi_firmware_start(struct ath12k_base *ab,
-			      u32 mode);
+			      enum ath12k_qmi_firmware_mode mode);
 void ath12k_qmi_firmware_stop(struct ath12k_base *ab);
 void ath12k_qmi_deinit_service(struct ath12k_base *ab);
 int ath12k_qmi_init_service(struct ath12k_base *ab);

-- 
2.43.0

