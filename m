Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF975921EC
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887408; cv=none; b=hu4MpESRCth32xxB6795KhFwTU2ccMis6SpxeQo5imjhLmsT5X3KoBjAvtaCbC2OMQDM7g7WcAfaueJat0NOO2sqO+nHMqJOepXq1+XDYvPOseC0xb0Q/2i3gZ5OJx8DWyCx46zPkujH8bUAtw77zQbiqK21OoatlpeW8XHEr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887408; c=relaxed/simple;
	bh=NrgThq6Y8uHhb3wAckmPMV55GlSGJaL3Mt7emHZURDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ky8MixiRnxVC1Jm1Bv5pPb8+zjB7NPmiXjc4Qlzg1LjUuO7sL0JoUr5m1lh36FEQESiBYPsGzNDgS4lWD2G6VAlhOZtgBuOIUT0UR0JBiA/X8y81OTEYeuW8pYdGsiz0ZDFRVBcAerC223pcwEG2SjItq2q4uxhEOImi9Mh3jtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mbM6R92I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fgjDTlAx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mbM6R92I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fgjDTlAx"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdXYJ2769571
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=; b=mbM6R92IpOK5evsc
	mB1MtHjS76EOxfKfaWUgzbwllqe2qK8te+UJKcgClQbZu4hrivXX+gGxCBivQ8XT
	U7fdyMtVAqyUpvS4s6nVmPRu5ER2Bs5BY8KTtxM3YA7zgUG8eywFmeYQy+sRQCj0
	8ztVB2KG7i6Rg5k05cqwxbF6uGohb5f8j21/kOJrcEQZgN9LVICO+/6HTltnYOBF
	09kgPHZvdcYbrLulrRBmlfpzispybVSYWfd89Pgq/CWUrH30gZglneMcgCqymuzn
	mCfjt8SQO0pksuQ3Flbi9qXwwk7DfWxulqpX/Wz7irN4+wejdKw1GMMMmnFBXbik
	2f2Oww==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjjvuh92n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:05 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8663802b58fso2026719b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887404; x=1789492204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=;
        b=fgjDTlAxTpb94Gre70BDBVeim08n9s1hD15RfS8DUC6IUS6nX1KEyWH6jm3++6Gc36
         AA7HEXuJndZDoahkbmfwVTDgPcNH2ftpzQb7mbnvbAKyf+Z/8RliiLnthMLUcZsTRVqC
         AburXl8y0+vsmSnvrlwR0D4iCPqZLyR1AEuQHV9E+GwIG31a4UwsTyhn1jUl2QDhc5qY
         lGzH4lAcc8r4pRl72fxOq9uxbYWFJNPVwWsWABpzwJhGM2WIjZ0Fe7bnLaBOArhA0/5c
         en6A/I5Xj+pcmEWiumAnWcoRTYZm6lQzia8plNY/w7fFkDGIhyKAa+OIRUr1o0xxuZd1
         WMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887404; x=1789492204;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZdtDE9nITufoadjKmxDFYIwfAzWlsnkOtcwwliJ40E=;
        b=VEYlLUOS65Whch+0KAwJ9RH9XhnLcMnYh/xX2+fGHBfkSvAVnHnMGXiSHHqkN7P3Vm
         AD85+LrDsFpYTWzEj3DeM/JOunJOcX5agU9Adg6CzFC79pxo05nqKh7LExndn78aXXEj
         GF9xAAnqoduXNTf7B8kD8rVT2447v6I0cURGvS+37mvUYW02UYpqFA3Y9zUfEUToEF/t
         LBbbqhYsqfLE2TNl9G0iKo7S/E86LGQ5BJnRTG6fL+J/UvB7F7VOzLawt3uMmOvd3n72
         F3yrq3hipsNTI28Y2pxSHGZXb4GhRVasyRofBGMRRalwB9jLyj6oQCBaUzEZj29GXynp
         K8bA==
X-Forwarded-Encrypted: i=1; AKwUvBz/23sCX9pl+JxFgYEqXZmqCwftUP5MsQoj1pg1q/IxPX4Q6lM55+8jGvHqfo2td9RMUl33OX+lDGRybSem7Q==@vger.kernel.org
X-Gm-Message-State: AFuF++mWTqwVJGCsoEBQ5GhikTw0+BarsKrjNXlC4R7z4JimB1dn6tO8
	MigdpZKbXuvHCK871xQUkPKUfn2gBKxQRgHUGGxQkdy5C0d7+PjcVpdN6wBtMVz5Dd8If5ZC+8Y
	QWVpzoqNd/Akvtd6y4+wMaRBhHbKj8A3A/fU676GeTbqTfoNPFDH5VSHQbg75AqIX+MWAFHjJ5n
	1P
X-Gm-Gg: AYBFou3W3Ukbo64/9iluPSGKXAUUBCEO83gLACohhnx57X9jXU9rcwwjInyecHCPqoQ
	2WYHRFfcePWrBE4R+jZutMzLRUnC71nLGH93Xpx6hFvlKMFtoLJSCQK5jBS/AsV0g5ezI14Smh7
	vCihIwOHzJaldBDPe9/uDdYEM6ftCwgf2PKKYswmrFeeDv9GL/jCtMi7eS0r1qDxoMuLqE60Dy0
	tSjgUMDJdZqP2jDAZCmibsBqQODvp3eAdZw6pSnTFLU4N4jFiNWK4HQHYFWUPoaYlOPxKkDqhjr
	HgSc56WJBF3b/9fJE5q2R/Ug4CUAlMvjVuE4ACEn4ooKQ6exDWN0LYFLCPQAapKxMijoY50wiuq
	x787A1ByQzdAGygFJJzcag/3x2tP2iqdAuC7Kc78/fTiupmbYJEX1SIdPgXC3WHksx5xm0IGYNd
	vD9pRTw/+Wc0Q2YDdAOdfVWQ==
X-Received: by 2002:a05:6a21:7748:b0:3da:6bdd:2c74 with SMTP id adf61e73a8af0-3da6bdd6cfcmr27957440637.10.1788887404137;
        Tue, 08 Sep 2026 10:10:04 -0700 (PDT)
X-Received: by 2002:a05:6a21:7748:b0:3da:6bdd:2c74 with SMTP id adf61e73a8af0-3da6bdd6cfcmr27957381637.10.1788887403611;
        Tue, 08 Sep 2026 10:10:03 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:02 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 01/18] net: skbuff: Add SKB extension support to wireless drivers
Date: Tue,  8 Sep 2026 22:39:29 +0530
Message-Id: <20260908-smd-v1-1-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EAa6eFkFsZUznR_XxY0jF7HljIKdxmp4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX6JcmeruJj532
 pCO3vD06tL1DvTdYECWS88aFlLR1FCVPFV1INYTSy/zKOtdFaTzFgLYCWvk/etvvqppw4Zffuz6
 cmmsLEmvJdsgphY/zDzqOUjoTH2KaLw9xOUe+GUrLxV45aldCRjjXbKSfMFlsj6RP2q4+nB5SCI
 46SLHWdRCHaKkWUtCGPW8pSBYdnwBC289KUfh1zCCBbRrgunmpcAvy78A6qeW5OKV0dNBxmCPB4
 FyzDElX0T4ROZQ4j0tH0iceXsYTmspeNDxpklQ5nSkCnf16IbUH5jOSKm9XcGXlB28l/MQ+30j/
 ifMISTSP9IN8jnQ+BevECpR9bGeCdt1m25mUFVTf8atvez1oqg4jCikS2mXXQ6btDPvChxSoPhn
 qiUTEyfH2KftRCeTuwbgTGTIs7KNPLhJetAT0++krj+czEL547m6DwRjDykM/YpNogAS1/BA4WD
 EmRpvnvHTHLsgwoLeIA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX20zt93bZFxWF
 e9MAoLsPH6Hu4Wljx/nTaK4D7MgfKcoPTwNu5LDygphPm3zk25pPbQjRmpshnD1XCBWPuJ/8Iy6
 wUJVoxVFn7xvURinybEiN7FMhvLoxJs=
X-Proofpoint-ORIG-GUID: EAa6eFkFsZUznR_XxY0jF7HljIKdxmp4
X-Authority-Analysis: v=2.4 cv=X8hi7mTe c=1 sm=1 tr=0 ts=6aa0416d cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=axc-8nxta6ncDHcsNdkA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

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

