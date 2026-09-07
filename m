Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAA53E49E4
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813204; cv=none; b=kZU+M4cg/Zs6iJ7ZREv//HG4Fpl0WZ7a4oD/gNWeax7m9VJ08foG7ExNrFP0cEv2Z6c58GTQEiMvFOloMiC4yWU/08phuVSRsIx71Z4qPdNbWaiL3RV1UOw0POxvZDyBy4DrqRkSiHGpF8PZd6deoGo87SSYIvJoeqFCVLlh5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813204; c=relaxed/simple;
	bh=NrgThq6Y8uHhb3wAckmPMV55GlSGJaL3Mt7emHZURDY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CiTnYZrdXxwPxAj3zLpJIuM9sPhmtLQL1wbdYIlcAOdW524CzXFGYhYPuiB+YAhzqP+3ZsBqR77qExd1YjOwF52f6mYA6+smW6uTMxIStuFsTsDF4WmX+wNz0Rg/cikrK4ADmsaKeqCfYcLE1xlCB3rn9y4dnxZkb5FaTu36SsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mETh+2A6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eCtq1oI8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mETh+2A6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eCtq1oI8"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687HWK7G564883
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=; b=mETh+2A6Qi98H/cg
	JRlQd70yksouhVax3yQo4tKoAwbR1WgnoT1BAqTR2QGBq4/hdb5nIomQqD7IeAQI
	XDcrhGLS5Gu7X1H6/Yr9dewIfTsKabZ4t2jBfqGpabXYSiI4zDBgokDbQ9g2sPC5
	B8BFBqERcR3HUp2voKAxB1Eq79Zj8r3kpsVmaHtiko2B1tpKGXbr7cax8lSei9fW
	gv9MPruNUWrnR6v7LkgjIzFQn6xwBfefw+oJudvaS/tcTKpndavCt9yaaqcL8l3L
	y2LppiikVjbdz5Ni5DBDEfONJh8kUQhTojGIEkxaNQ/gDcC++21GV7PnsDPdDlMK
	pDIuYA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gj1rrgfrh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:22 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc435388657so1833012a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813196; x=1789417996; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=;
        b=eCtq1oI8oUTrjnlqvS30f4sw7IMCU5jNQKndbClgFH4eTotkq/6uEuWvxu08CYyEeh
         huxoUMxrD+hsLru4as6Q/nDXpGw+Gfim4/DPEoO2XVPYKhlsfnRw87aaXHCUqXkWwDws
         vGUImRmDFCkqU/oXOza6iNqvzxXuphmyFc/Lp/G4GKNxhI2oPh9jdO9jQjlhJYHwEUI9
         YS3PiIeJPqoFVY/4jWshrrJQIXA40gipBqPrKyStEcNAdQUsd6rvPBH4majFJTbNbbG6
         tNXWLnt3wTUUbWOfCDaUzYCnkZBUAgOUMrKVQbSO1kQRO6kzg7gzLGitVsOv/iYMAow+
         ef5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813196; x=1789417996;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=;
        b=UuAV4ZrU+7pHfVv44AFu/CHmBxtdMl1WtRafaBVzWcFNZYI2C0gTDrB9K45Tfjxw9u
         lE1RiYK61M36UxELAf9DRcBAYyE/R7gJPeuCC3NDa0995R+vlHb/sc6z9piaT9KdjAQU
         fPfG5bCj31vztgE0AAjHd+lvgw4ORY/mxtfUh+5/gPRc6x/JDUZX4a3F4KAiXvJd/ZfA
         9BWg2kQlKtLAcCjZF7Dn3pWoxkb+d3NbaHKNR/8Q6RYNTBjaujNwZgW9xKkUYHLfejk7
         41K1BjA4RjEJxuyz6xk5BeShLM+Ox+wUnozZpbKC4XtcX0kad7Zbxg6mGEbSrWg0x35f
         tKJg==
X-Forwarded-Encrypted: i=1; AKwUvBzjA3KJ/w4qSatt3IAJLPZT8Da9k920WrRoTHprOQ56LTVAUAjrALG3OSE5hwq/XzTy45+ohtTf1HBiXXzz8w==@vger.kernel.org
X-Gm-Message-State: AFuF++nR8bXLyJA5A0iWr7v1odiVa08wHt3UR9E1Oa2hBFMiIUT0peJj
	nCMUhW72VfAoFsZrZO0fe5FtuRp/IWhBaKy3Shu/2vT03FAd6ZXpMmRg2ujlogmQ1mSIAjep16T
	c+xw5MSwXxyY2ge6R6LnYt5Eb2Tr8sRqlteDTsYrAVLv+CJ/Wp5hv/nHE9ZYcEdNK+T3gq5wPEf
	DL
X-Gm-Gg: AYBFou2ZmW7Zq8GxxHRIfd5MBqfVEk0MHkKCTmpxmkRcYxUJ9Mn7yvUiKkRNtM0MtzN
	MlXQP/kbRSy/K1vjOqdHkUc+US3ahTHHe/rBa4ACJpaMH/XvofsiJcf+0TRk5Zo44UNE13gvZ4/
	8Vnb7rGkfLgTG7XQy5SlbC+zSZRFlRqQ5Dj7RIeSrGVc02096CswgK9ceDXRjNxpuAYMphEq2cI
	7lYBksireLX1NU6w8w9KhJjRfiITJi1NayWfJnFEZulu1AWcTeM1nN50ZOj3Slg1B7D1OIuiDB/
	vyf/x3Wtxix8SxD7zwob+3g8RXRnlZPfsV3zHum3CC6EBKzoArh2ZrF/Iz2PcqVDUVgiPKHToxW
	M8MvLEY921CDOEdCrzMP/8lcIBE2yMdHAnaUFs5lwolcLI9rPcm+YM1DL4/Zm5cTqdNPeqHBsOJ
	0sTBFr7kpt1izDd0jFAhRvRw==
X-Received: by 2002:a05:6300:6710:b0:3d8:1f68:59ac with SMTP id adf61e73a8af0-3da3a15bfc3mr39225027637.23.1788813196040;
        Mon, 07 Sep 2026 13:33:16 -0700 (PDT)
X-Received: by 2002:a05:6300:6710:b0:3d8:1f68:59ac with SMTP id adf61e73a8af0-3da3a15bfc3mr39224968637.23.1788813195589;
        Mon, 07 Sep 2026 13:33:15 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:15 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:10 +0530
Subject: [PATCH wireless-next 01/18] net: skbuff: Add SKB extension support
 to wireless drivers
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-1-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX2rlB1dvUr/gb
 SotrQ18+ZgTmrRvG+wajtZE4E2UdVIJaEflaPKcSR5g7QM9g3jcFHTZiMWx21lMVZcoAYFoIiXt
 ZxdaS7QcJijfyVJbG5/q4CP94GDB5aQ=
X-Proofpoint-GUID: ow_KYEU2rfEBzJ9d2PRbqecisuSHIakb
X-Authority-Analysis: v=2.4 cv=NsjhtcdJ c=1 sm=1 tr=0 ts=6a9f1f92 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=axc-8nxta6ncDHcsNdkA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfXw/rUkwbGx/uq
 VKeRQLwD2UBPQtIFBA6qxLP72qrm9v0lRI85tBtXsyvIxNoVPwvnuH+suUIbJinygp2noKiENfu
 1wLht9ckHqCpI2ScgN9nTev8MNWx8W07rqWyI3dttGIF4+e2Li56t/UuG71KSD9ehun89PLC1Ey
 E6yJ3uk3aG9JCuv/7N2SoSCgms8f2xRkNxzJD9d64ZDc8WvVPHUoLJjjmoTS4KPACaz1gf68oWN
 UPBkm5phGrpA2UkA5QTA4Y4Q3IFQnwc4wjG7mfN+YqVRt/BUYEetkYO83IWGykjdZNc+kU7h4fZ
 mreZ5QFgqFmKyHb1EWzB8BSxtiB4JVqbmJIVNsZ7ZKms49q0+4Nr9sLhjC6HCJu3x/J62ggMQNK
 v3KJELE30GCmSTADt4mhJ6EaZ3OAI3HX880xC0Z5lQvvmzToBR7Z4NNJsEBN+F45Xw3BWZCXzyd
 7Av/x1QOsOfTfLJXPzQ==
X-Proofpoint-ORIG-GUID: ow_KYEU2rfEBzJ9d2PRbqecisuSHIakb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16, defines Seamless
Mobility Domain (SMD) BSS Transition, in which a station roams between
two AP MLDs within an SMD across two phases: Preparation and Execution.
During these phases, the receiving AP driver processes a query frame and
must carry the station's roaming context - per-TID sequence numbers in
downlink (DL) and uplink (UL) directions, packet number in DL and
per-TID packet numbers in UL, and per-TID BlockAck session parameters in
DL and UL, plus a variable-length driver context - up through mac80211
and nl80211 to userspace, which uses it to complete the transition.

This context does not fit in skb->cb (48 bytes). Carrying it separately,
outside the SKB, breaks when the SKB is cloned through the RX path because
the context lifetime is no longer tied to the frame; the driver would need
independent state correlated with the SKB at nl80211 encode time, adding
error-prone lifecycle management. SKB extensions avoid these problems: they
are reference-counted, copy-on-write safe, and freed automatically with the
SKB.

Add a new skbuff_wireless.h with a typed union structured to accommodate
future wireless extension types, carrying the SMD roaming context as its
first payload.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/skbuff.h          |  3 +++
 include/linux/skbuff_wireless.h | 55 +++++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c               | 55 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 421f6fc45451..fb686024e97d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5061,6 +5061,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_CAN)
 	SKB_EXT_CAN,
+#endif
+#if IS_ENABLED(CONFIG_WIRELESS)
+	SKB_EXT_WIRELESS,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/linux/skbuff_wireless.h b/include/linux/skbuff_wireless.h
new file mode 100644
index 000000000000..2cb04bff061c
--- /dev/null
+++ b/include/linux/skbuff_wireless.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * IEEE 802.11 WLAN skb_ext definitions
+ *
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#ifndef LINUX_SKB_WIRELESS_H
+#define LINUX_SKB_WIRELESS_H
+
+#include <linux/types.h>
+#include <linux/refcount.h>
+
+/**
+ * enum wireless_skb_ext_type - type of data in wireless_skb_ext
+ * @WIRELESS_SKB_EXT_INVALID: uninitialized state
+ * @WIRELESS_SKB_EXT_UHR_SMD: payload is @uhr_smd_ctx
+ */
+enum wireless_skb_ext_type {
+	WIRELESS_SKB_EXT_INVALID,
+	WIRELESS_SKB_EXT_UHR_SMD,
+};
+
+/**
+ * struct wireless_skb_ext_smd_ctx - UHR SMD roaming context container in
+ *	SKB extensions
+ * @refcnt: reference count; one count per distinct skb_ext block that holds
+ *	this pointer. Plain skb_clone() shares the same skb_ext block and
+ *	does not increment this counter. Only skb_ext_maybe_cow() increments
+ *	this counter, when a COW produces a second independent ext block copy.
+ * @smd_ctx: pointer to the IEEE P802.11bn UHR SMD roaming context;
+ *	must be a kmalloc-ed buffer, freed together with this container.
+ */
+struct wireless_skb_ext_smd_ctx {
+	refcount_t refcnt;
+	void *smd_ctx;
+};
+
+/**
+ * struct wireless_skb_ext - SKB extension data for wireless module use
+ *
+ * Carried as an skb extension (SKB_EXT_WIRELESS). The union is reserved
+ * for future wireless extension types; only one member is active per skb.
+ *
+ * @type: type of data
+ * @uhr_smd_ctx: pointer to the UHR SMD context container
+ */
+struct wireless_skb_ext {
+	enum wireless_skb_ext_type type;
+	union {
+		struct wireless_skb_ext_smd_ctx *uhr_smd_ctx;
+	};
+};
+
+#endif /* LINUX_SKB_WIRELESS_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ab195b99c853..f28ab7c3c888 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -93,6 +93,10 @@
 #include <linux/indirect_call_wrapper.h>
 #include <linux/textsearch.h>
 
+#if IS_ENABLED(CONFIG_WIRELESS)
+#include <linux/skbuff_wireless.h>
+#endif
+
 #include "dev.h"
 #include "devmem.h"
 #include "net-sysfs.h"
@@ -5169,6 +5173,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_CAN)
 	[SKB_EXT_CAN] = SKB_EXT_CHUNKSIZEOF(struct can_skb_ext),
 #endif
+#if IS_ENABLED(CONFIG_WIRELESS)
+	[SKB_EXT_WIRELESS] = SKB_EXT_CHUNKSIZEOF(struct wireless_skb_ext),
+#endif
 };
 
 static __always_inline __no_profile unsigned int skb_ext_total_length(void)
@@ -7152,6 +7159,16 @@ static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
 		if (flow->key)
 			refcount_inc(&flow->key->refs);
 	}
+#endif
+#if IS_ENABLED(CONFIG_WIRELESS)
+	if (old_active & (1 << SKB_EXT_WIRELESS)) {
+		struct wireless_skb_ext *wifi =
+			skb_ext_get_ptr(old, SKB_EXT_WIRELESS);
+
+		if (wifi->type == WIRELESS_SKB_EXT_UHR_SMD &&
+		    wifi->uhr_smd_ctx)
+			refcount_inc(&wifi->uhr_smd_ctx->refcnt);
+	}
 #endif
 	__skb_ext_put(old);
 	return new;
@@ -7256,6 +7273,36 @@ static void skb_ext_put_mctp(struct mctp_flow *flow)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_WIRELESS)
+static void skb_ext_put_wireless(struct wireless_skb_ext *wifi)
+{
+	switch (wifi->type) {
+	case WIRELESS_SKB_EXT_UHR_SMD:
+		if (!wifi->uhr_smd_ctx)
+			break;
+
+		if (refcount_dec_and_test(&wifi->uhr_smd_ctx->refcnt)) {
+			kfree(wifi->uhr_smd_ctx->smd_ctx);
+			kfree(wifi->uhr_smd_ctx);
+		}
+
+		/*
+		 * __skb_ext_del clears active_extensions but not ext->offset[],
+		 * so __skb_ext_put will call skb_ext_put_wireless again;
+		 * mark NULL regardless to avoid double free in __skb_ext_put.
+		 */
+		wifi->uhr_smd_ctx = NULL;
+		break;
+	case WIRELESS_SKB_EXT_INVALID:
+		/* data not yet set */
+		break;
+	default:
+		WARN_ONCE(1, "unknown wireless skb extension type=%u\n",
+			  wifi->type);
+	}
+}
+#endif
+
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id)
 {
 	struct skb_ext *ext = skb->extensions;
@@ -7278,6 +7325,10 @@ void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id)
 	if (id == SKB_EXT_MCTP)
 		skb_ext_put_mctp(skb_ext_get_ptr(ext, SKB_EXT_MCTP));
 #endif
+#if IS_ENABLED(CONFIG_WIRELESS)
+	if (id == SKB_EXT_WIRELESS)
+		skb_ext_put_wireless(skb_ext_get_ptr(ext, SKB_EXT_WIRELESS));
+#endif
 }
 EXPORT_SYMBOL(__skb_ext_del);
 
@@ -7300,6 +7351,10 @@ void __skb_ext_put(struct skb_ext *ext)
 	if (__skb_ext_exist(ext, SKB_EXT_MCTP))
 		skb_ext_put_mctp(skb_ext_get_ptr(ext, SKB_EXT_MCTP));
 #endif
+#if IS_ENABLED(CONFIG_WIRELESS)
+	if (__skb_ext_exist(ext, SKB_EXT_WIRELESS))
+		skb_ext_put_wireless(skb_ext_get_ptr(ext, SKB_EXT_WIRELESS));
+#endif
 
 	kmem_cache_free(skbuff_ext_cache, ext);
 }

-- 
2.34.1

