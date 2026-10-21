Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604012;
	b=VLfcPwdywoO6qIQbVYXGKViiMqE5H+KhXFgjgHnUT+ShVMB4avqKF8Oal+xWdBHu2F30
	 NeH7KEjHz8eWvaOXEA7fY+XNtoWnya8BE0sFNkoUkem3wTWl7qztxmnJqqqDeIUCyYdpU
	 lsu2ixakwNM5jl/QovXNcphXG+HxRiFz00p2EOjm4G6au7j8cnqRZ/lSxGgzi0E0kwuit
	 AOcSWCqOtPwFs1GCb4hnPuWUEi4TrGk21YRgK/aAvzJH6R6r4h0FGvpwuPwN6Np6Z47ZC
	 h6cUEmpf64+JambgPvItfORRf3he/yZE3TvAGxlrDtjVZDHDxEnO/XVmnn5LAP1gMvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604012;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bsoM33BumXlLFCYishlw3tIJRcAwHH7QLQK9BwYg4sc=;
	b=UhUWwGVYh6Cottxiyxgp/b1IYF2W1/4jMa1QOZegLbAxiWTqjvwF8k1op16vO6CrDM05
	 7a6kWsQ6gu828hxrh6HOwxXkABAkLhdXnTbAK9yfA9apZZnI2dXnXAne2T8ddbo8PivIg
	 z4ZOLDkMmE/yDc53UNiIf7sX+lReRUEjZ/cq9Cgaqkc27aEP5Id5DLIeMBhn5g9HhNjy7
	 LpYF3t5WXKm/lmklI6vBbvRcmcAiX57HYxj4d4yENdlwjsLdzkty3ByE/Sl6QgB1s8M7M
	 X1EV8oMyhSVhW4xmBBLmutCfaNEsnxg1sP2Z3ZguYiJAihjVtRBSlWDRqaQvbESg4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T18J+on1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W0EbpRro;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B666606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B666606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T18J+on1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W0EbpRro
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LG4CJZ2149280
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=bsoM33BumXlLFCYishlw3tIJRcAwHH7QLQK
	9BwYg4sc=; b=T18J+on1sJFwwvrgkW1eQVjG9TmB9vk/PiyOV0BbgAxAAfCu+o8
	kRRCXYpaoqIVWcngP4oADnVP7t78N1LuFy4muJz5NLn3kZR53HZlYCYnYmN3audR
	R3GqckiVJC8d3bNFZGtzLeWh0WL8TE1HVWVercyCjUDwly6d7cL80AneAFCs8NSH
	XpZw+CBmIu0BdIc20ozYRatnSoBkOXVeGmH3v/+GKhZX0PRdHCUuLrtMC+C4QuBn
	5yB/za0ihR8HrIENxOesYUvlYCk31NQx4ZzmkjDOM349CaE/cfpLJIvUOgr6zkLp
	jA4MKxTN4oUdtAAgeYO2uQKA/VmxFVJnIbg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0ke0dur-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:33:31 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-359b81ad4e8so1657624eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792604010; x=1793208810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bsoM33BumXlLFCYishlw3tIJRcAwHH7QLQK9BwYg4sc=;
        b=W0EbpRroOz/S7j8PJVoCVyKbnhdXE3P1a9obUmogPnjGksYFQnG+nrB4J60k4DWQsp
         yKlgseETi2MzUFKtirqHvyfNT3XqxqiWOA5ANF65uRKmnRubU3D+mdRdeX+51/VuySxR
         J134ai4pFbfpEOk6PO0AZbdrs9abxM5PBdqOScEYQQfN0g1EZJrKgnT57ZSkQ3/ZgNNK
         9anHlR5FlaSxbzYmBLxw9/6mTkYEIewrUNfW36wbHrmF+6W8r1cotvp0LiopRZprp2Vj
         x/LzLaBj6/9DUyn09wLmwoqHvIO53IiSQz6Qb4jWm1eWJsla3KeUAlAPz9fUwffU3RNn
         hnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604010; x=1793208810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bsoM33BumXlLFCYishlw3tIJRcAwHH7QLQK9BwYg4sc=;
        b=UTuo5R1s/Q9rhqVOY6MKTxsVe7LjK/x4+a6HbWPUUMLKMFD3eyblqY7aNzhGZHMA53
         nOAIZ8Y5YkKLVNulZ2zhmSiXQQoYcKoAyIQ3K7PEBKhnJUg9lrTW/SM/uENrX6Ic475Z
         29OigXg+L3DMBSCrX5RVgD14eyJXxDM6IE6Fy7403j3dKH6kC3yiogy2VBGaMjJXSr80
         sZIKQ+gl1QmBQZ8NiXQ8NegrZ4yvyKQpTcEG6mTSGih04z6RnM8elBru5cdox9fkroyD
         zJr8v9n3g2xi7S9Cx0VBgR5vk3/JBzIuFQu+VEXb6ohuhrax4QzcotOryNJ9htL1EYCs
         5ySQ==
X-Gm-Message-State: AFq9FYJ0uPr3j+Tb+5KxK1BaYL9P7fmMPKyAljHyDpT+/kTJ1VyX8urr
	AUeFKoHE4cjFGTFaFO6P8De3ZL6DckzAFhS6zpRDDTh5/9udV9tZlvS2ZMymVPo3DLzh+ChH3PJ
	KMYNVLbrAZR3Yx0+Vc0JK3YjcVbACyaGo64j31Dl9Pot8V6B7QFwF8ZV8LTjOOq7o00Lm+g==
X-Gm-Gg: AYBFou06bBIXi4M3MGIqfMKFvwqZwH4WLeO3McESqaK+Oh9V+cPBk2DCvSUglt7tuzE
	8q3y9sSPB16BVizD4fQ0nFmjRoHIh4F6rw0ca27raUhSnbcPoRshdToDI84UsAJdfJSyiVvTnC0
	ITATjhY9MQMdp9cgdM+XRDYvyxu3diSj2ZL1IfJLKQSjrqSFlAU4TZq7E1R0I9GQBbpSou+XHtk
	a1gw0zbrURpFjjzGH22BYoiCE3LTUBNFg1k006MfmUPP78+vwITTm4WViet/FWkyNMEfTGq5BoD
	eUl0QX7sMh8UZ6qWYE0AbNJkfjHDu/KJhZhZHczvoLdfCXC2LPEIUh4rAQtXZktX99k+ihgLVI6
	x3gQZJKMvjXSCWHHxFDQnKCzlCzRcSHNmUNNXvjr56PYOI7fikLZHXlyc/135nYpLuqX5nSd7h4
	wP88QZTuZAye1NDaW/XV/AsXAUShi+
X-Received: by 2002:a05:7023:d0d:b0:149:1feb:6dae with SMTP id a92af1059eb24-190a6adcb4cmr4086692c88.39.1792604009805;
        Wed, 21 Oct 2026 10:33:29 -0700 (PDT)
X-Received: by 2002:a05:7023:d0d:b0:149:1feb:6dae with SMTP id a92af1059eb24-190a6adcb4cmr4086643c88.39.1792604009054;
        Wed, 21 Oct 2026 10:33:29 -0700 (PDT)
Received: from hu-mkenna-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a180ca2sm7026366c88.6.2026.10.21.10.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:33:28 -0700 (PDT)
From: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>,
        Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: move arsta grouping from rhashtable to per-radio hashtable
Date: Wed, 21 Oct 2026 23:03:18 +0530
Message-Id: <20261021173318.1935569-1-maharaja.kennadyrajan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-GUID: 2lu17iABc4IY0nhZAx9zef3V_lQ9pEHJ
X-Proofpoint-ORIG-GUID: 2lu17iABc4IY0nhZAx9zef3V_lQ9pEHJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2OSBTYWx0ZWRfX/NKta0J8dMsO
 VdAqVO3i7utfWJrLlh9fDTntQpsXmZYen8QhYp/V757DuO23tJb7HTDcSZK48nHtnwXH6xeAPcn
 Wnja9nbPbcwEBusElzUckwX8mZeIo98=
X-Authority-Analysis: v=2.4 cv=KOzPn1Fo c=1 sm=1 tr=0 ts=6ad8f76b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=3ugrZYfhNPPjgIFQr8AA:9 a=CyxTcHXcsLpUdS6k:21 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2OSBTYWx0ZWRfX2RumbywFa+0B
 u7TIMpwLF0rh1DTJdBt4IeeCaqRkaBsIi2eWk/s2RXV1wFPVdNFPGoPpXpEhAsKmAquzOTVe/ux
 MKa1X+8WaXlRYX87X5oAq8UiwItXiHgewPCUJeU9WpuGzNu7mKR5bBwfNu+QjVoypRXuqzOJRv8
 RLsg10GtuuVM7Lp/kHrTOF3jAdQ6NA4hY1hm3Ro+kUP+bA0LhqTOu7JOveDPPreYsjd0xpOu+ZI
 hgM/gR1lg1j99V5fjjIDUazWajwmm+9EqTmEu63jarRTXVdzAuN8PKH6w58N6wdmMiuLCgCG9X3
 Bj/9FiAad4C82q/TvfKEgK5dbpACPHivq0N45iERKPTQXsyXfKWViVVmihqJlSQl0G2pQ6YCrqQ
 0jImcOEU/ZDA1HLtc2T3rqwyJjVzTT6QsMqN9jMxiQFTnYydEQr6ckd8XYg0ycwI2i5KiZltpn5
 a3DGn0IuIq5+x50LSfw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210069

From: Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>

The link-station lookup table is a single rhashtable at the ath12k_base
level, keyed only by station address. Rhashtable does not allow duplicate
keys, so the same address cannot be represented on two radios at once;
a roam or split-PHY overlap where an address briefly exists on more than
one radio is instead handled by deleting the previous radio's entry
before inserting the new one. Because the table is keyed only by address
and shared device-wide, a lookup also cannot be scoped to a specific
radio: during that overlap window, or due to stale remnants, the single
entry present for an address can belong to a different radio than the
one being looked up, silently attaching the wrong radio's data to the
wrong arsta.

Move the lookup table down to the ath12k (per-radio) level, and switch its
backing structure from rhashtable to hlist, which is simpler to walk in
full for the iteration that some code paths already need. Each radio now
owns its own table, so a lookup is inherently scoped to that radio, and
the same address can occupy an entry on two different radios at once
without any delete-then-insert workaround.

Update ath12k_peer_sta_kickout_event(), ath12k_wmi_tlv_fw_stats_data_parse()
and ath12k_wmi_tlv_rssi_chain_parse() to use the new per-radio arsta lookup
helpers accordingly.

The datapath's link-peer table (struct ath12k_dp_link_peer, in dp_peer.c) has
the same device-level rhashtable design and delete-then-insert workaround; it
is unaffected by this change and remains out of scope here.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>
Co-developed-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c |   9 --
 drivers/net/wireless/ath/ath12k/core.h |  21 ++--
 drivers/net/wireless/ath/ath12k/mac.c  | 122 ++++++++++-----------
 drivers/net/wireless/ath/ath12k/peer.c | 144 +++++++++++--------------
 drivers/net/wireless/ath/ath12k/peer.h |  11 +-
 drivers/net/wireless/ath/ath12k/wmi.c  | 112 ++++++++++++-------
 6 files changed, 213 insertions(+), 206 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 25987bc58556..2309ccae5338 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -716,8 +716,6 @@ void ath12k_core_to_group_ref_put(struct ath12k_base *ab)
 
 static void ath12k_core_stop(struct ath12k_base *ab)
 {
-	ath12k_link_sta_rhash_tbl_destroy(ab);
-
 	ath12k_core_to_group_ref_put(ab);
 
 	if (!test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)) {
@@ -1016,12 +1014,6 @@ static int ath12k_core_start(struct ath12k_base *ab)
 	/* Indicate the core start in the appropriate group */
 	ath12k_core_to_group_ref_get(ab);
 
-	ret = ath12k_link_sta_rhash_tbl_init(ab);
-	if (ret) {
-		ath12k_warn(ab, "failed to init peer addr rhash table %d\n", ret);
-		goto err_reo_cleanup;
-	}
-
 	return 0;
 
 err_reo_cleanup:
@@ -1425,7 +1417,6 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
 	int ret, total_vdev;
 
 	mutex_lock(&ab->core_lock);
-	ath12k_link_sta_rhash_tbl_destroy(ab);
 	ath12k_thermal_unregister(ab);
 	ath12k_dp_pdev_free(ab);
 	ath12k_ce_cleanup_pipes(ab);
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 99d71dab7c04..bde3b4985023 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -17,7 +17,7 @@
 #include <linux/of_reserved_mem.h>
 #include <linux/average.h>
 #include <linux/of.h>
-#include <linux/rhashtable.h>
+#include <linux/hashtable.h>
 #include "qmi.h"
 #include "htc.h"
 #include "wmi.h"
@@ -510,8 +510,8 @@ struct ath12k_link_sta {
 	 /* for firmware use only */
 	u8 link_idx;
 
-	/* peer addr based rhashtable list pointer */
-	struct rhash_head rhash_addr;
+	/* node for ar->arsta_hlist, the peer addr keyed hash table */
+	struct hlist_node hash_node;
 };
 
 struct ath12k_sta {
@@ -658,11 +658,21 @@ struct ath12k {
 	/* protects the radio specific data like debug stats, ppdu_stats_info stats,
 	 * vdev_stop_status info, scan data, ath12k_sta info, ath12k_link_vif info,
 	 * channel context data, test mode data, regd_channel_update_queue,
-	 * peer_delete_waits.
+	 * peer_delete_waits, arsta hash table (arsta_hlist/arsta_hash_bits).
 	 */
 	spinlock_t data_lock;
 
 	struct list_head arvifs;
+
+	/* per-radio hash buckets for station address lookup */
+	struct hlist_head *arsta_hlist;
+
+	/*
+	 * Number of bits used to size arsta_hlist (arsta_hlist has
+	 * BIT(arsta_hash_bits) buckets).
+	 */
+	u8 arsta_hash_bits;
+
 	/* should never be NULL; needed for regular htt rx */
 	struct ieee80211_channel *rx_channel;
 
@@ -1149,9 +1159,6 @@ struct ath12k_base {
 	 */
 	const struct ieee80211_ops *ath12k_ops;
 
-	struct rhashtable *rhead_sta_addr;
-	struct rhashtable_params rhash_sta_addr_param;
-
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..d21b0b50853e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1185,35 +1185,6 @@ static int ath12k_mac_set_kickout(struct ath12k_link_vif *arvif)
 	return 0;
 }
 
-static void ath12k_mac_link_sta_rhash_cleanup(void *data, struct ieee80211_sta *sta)
-{
-	u8 link_id;
-	unsigned long links_map;
-	struct ath12k_sta *ahsta;
-	struct ath12k *ar = data;
-	struct ath12k_link_sta *arsta;
-	struct ath12k_link_vif *arvif;
-	struct ath12k_base *ab = ar->ab;
-
-	ahsta = ath12k_sta_to_ahsta(sta);
-	links_map = ahsta->links_map;
-
-	rcu_read_lock();
-	for_each_set_bit(link_id, &links_map, IEEE80211_MLD_MAX_NUM_LINKS) {
-		arsta = rcu_dereference(ahsta->link[link_id]);
-		if (!arsta)
-			continue;
-		arvif = arsta->arvif;
-		if (!(arvif->ar == ar))
-			continue;
-
-		spin_lock_bh(&ab->base_lock);
-		ath12k_link_sta_rhash_delete(ab, arsta);
-		spin_unlock_bh(&ab->base_lock);
-	}
-	rcu_read_unlock();
-}
-
 void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 {
 	struct ath12k_dp_link_peer *peer, *tmp;
@@ -1262,9 +1233,10 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 	ar->num_peers = 0;
 	ar->num_stations = 0;
 
-	/* Cleanup rhash table maintained for arsta by iterating over sta */
-	ieee80211_iterate_stations_mtx(ar->ah->hw, ath12k_mac_link_sta_rhash_cleanup,
-				       ar);
+	/* Cleanup address hash maintained for arsta on this radio */
+	spin_lock_bh(&ar->data_lock);
+	ath12k_link_sta_hlist_flush(ar);
+	spin_unlock_bh(&ar->data_lock);
 
 	/* Delete all the self dp_peers on asserted radio */
 	list_for_each_entry_safe_reverse(arvif, tmp_vif, &ar->arvifs, list) {
@@ -7101,7 +7073,6 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
 	struct ieee80211_sta *sta = ath12k_ahsta_to_sta(arsta->ahsta);
 	struct ath12k_vif *ahvif = arvif->ahvif;
 	int ret = 0;
-	struct ath12k_link_sta *temp_arsta;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -7130,14 +7101,9 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
 
 	ath12k_mac_station_post_remove(ar, arvif, arsta);
 
-	spin_lock_bh(&ar->ab->base_lock);
-
-	/* To handle roaming and split phy scenario */
-	temp_arsta = ath12k_link_sta_find_by_addr(ar->ab, arsta->addr);
-	if (temp_arsta && temp_arsta->arvif->ar == ar)
-		ath12k_link_sta_rhash_delete(ar->ab, arsta);
-
-	spin_unlock_bh(&ar->ab->base_lock);
+	spin_lock_bh(&ar->data_lock);
+	ath12k_link_sta_hlist_delete(ar, arsta);
+	spin_unlock_bh(&ar->data_lock);
 
 	if (sta->valid_links)
 		ath12k_mac_free_unassign_link_sta(ahvif->ah,
@@ -7155,7 +7121,6 @@ static int ath12k_mac_station_add(struct ath12k *ar,
 	struct ieee80211_sta *sta = ath12k_ahsta_to_sta(arsta->ahsta);
 	struct ath12k_wmi_peer_create_arg peer_param = {};
 	int ret;
-	struct ath12k_link_sta *temp_arsta;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -7166,22 +7131,11 @@ static int ath12k_mac_station_add(struct ath12k *ar,
 		goto exit;
 	}
 
-	spin_lock_bh(&ab->base_lock);
-
-	/*
-	 * In case of Split PHY and roaming scenario, pdev idx
-	 * might differ but both the pdev will share same rhash
-	 * table. In that case update the rhash table if link_sta is
-	 * already present
-	 */
-	temp_arsta = ath12k_link_sta_find_by_addr(ab, arsta->addr);
-	if (temp_arsta && temp_arsta->arvif->ar != ar)
-		ath12k_link_sta_rhash_delete(ab, temp_arsta);
-
-	ret = ath12k_link_sta_rhash_add(ab, arsta);
-	spin_unlock_bh(&ab->base_lock);
+	spin_lock_bh(&ar->data_lock);
+	ret = ath12k_link_sta_hlist_add(ar, arsta);
+	spin_unlock_bh(&ar->data_lock);
 	if (ret) {
-		ath12k_warn(ab, "Failed to add arsta: %pM to hash table, ret: %d",
+		ath12k_warn(ab, "failed to add %pM to hash table %d\n",
 			    arsta->addr, ret);
 		goto dec_num_station;
 	}
@@ -7233,9 +7187,9 @@ static int ath12k_mac_station_add(struct ath12k *ar,
 
 free_peer:
 	ath12k_peer_delete(ar, arvif->vdev_id, arsta->addr);
-	spin_lock_bh(&ab->base_lock);
-	ath12k_link_sta_rhash_delete(ab, arsta);
-	spin_unlock_bh(&ab->base_lock);
+	spin_lock_bh(&ar->data_lock);
+	ath12k_link_sta_hlist_delete(ar, arsta);
+	spin_unlock_bh(&ar->data_lock);
 dec_num_station:
 	ath12k_mac_dec_num_stations(arvif, arsta);
 exit:
@@ -7263,6 +7217,7 @@ static int ath12k_mac_assign_link_sta(struct ath12k_hw *ah,
 		return -EINVAL;
 
 	memset(arsta, 0, sizeof(*arsta));
+	INIT_HLIST_NODE(&arsta->hash_node);
 
 	link_sta = wiphy_dereference(ah->hw->wiphy, sta->link[link_id]);
 	if (!link_sta)
@@ -7321,9 +7276,9 @@ static void ath12k_mac_ml_station_remove(struct ath12k_vif *ahvif,
 
 		ath12k_mac_station_post_remove(ar, arvif, arsta);
 
-		spin_lock_bh(&ar->ab->base_lock);
-		ath12k_link_sta_rhash_delete(ar->ab, arsta);
-		spin_unlock_bh(&ar->ab->base_lock);
+		spin_lock_bh(&ar->data_lock);
+		ath12k_link_sta_hlist_delete(ar, arsta);
+		spin_unlock_bh(&ar->data_lock);
 
 		ath12k_mac_free_unassign_link_sta(ah, ahsta, link_id);
 	}
@@ -15183,11 +15138,12 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	return ret;
 }
 
-static void ath12k_mac_setup(struct ath12k *ar)
+static int ath12k_mac_setup(struct ath12k *ar)
 {
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_pdev *pdev = ar->pdev;
 	u8 pdev_idx = ar->pdev_idx;
+	int ret;
 
 	ar->lmac_id = ath12k_hw_get_mac_from_pdev_id(ab->hw_params, pdev_idx);
 
@@ -15205,8 +15161,14 @@ static void ath12k_mac_setup(struct ath12k *ar)
 	ar->vdev_id_11d_scan = ATH12K_11D_INVALID_VDEV_ID;
 
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->dp.ppdu_list_lock);
 	INIT_LIST_HEAD(&ar->arvifs);
+	ret = ath12k_link_sta_hlist_allocate(ar);
+	if (ret) {
+		ath12k_err(ab, "failed to allocate arsta hash table: %d\n",
+			   ret);
+		return ret;
+	}
+	spin_lock_init(&ar->dp.ppdu_list_lock);
 	INIT_LIST_HEAD(&ar->dp.ppdu_stats_info);
 	INIT_LIST_HEAD(&ar->peer_delete_waits);
 
@@ -15239,6 +15201,8 @@ static void ath12k_mac_setup(struct ath12k *ar)
 	ar->monitor_vdev_id = -1;
 	ar->monitor_vdev_created = false;
 	ar->monitor_started = false;
+
+	return 0;
 }
 
 static int __ath12k_mac_mlo_setup(struct ath12k *ar)
@@ -15447,7 +15411,7 @@ static struct ath12k_hw *ath12k_mac_hw_allocate(struct ath12k_hw_group *ag,
 	struct ath12k_base *ab;
 	struct ath12k_pdev *pdev;
 	struct ath12k_hw *ah;
-	int i;
+	int i, ret;
 	u8 pdev_idx;
 
 	hw = ieee80211_alloc_hw(struct_size(ah, radio, num_pdev_map),
@@ -15483,11 +15447,28 @@ static struct ath12k_hw *ath12k_mac_hw_allocate(struct ath12k_hw_group *ag,
 		ag->hw_links[ar->hw_link_id].device_id = ab->device_id;
 		ag->hw_links[ar->hw_link_id].pdev_idx = pdev_idx;
 
-		ath12k_mac_setup(ar);
+		ret = ath12k_mac_setup(ar);
+		if (ret) {
+			pdev->ar = NULL;
+			goto err_cleanup_arsta;
+		}
 		ath12k_dp_pdev_pre_alloc(ar);
 	}
 
 	return ah;
+
+err_cleanup_arsta:
+	while (i-- > 0) {
+		ar = ath12k_ah_to_ar(ah, i);
+		pdev = ar->pdev;
+
+		ath12k_link_sta_hlist_destroy(ar);
+
+		pdev->ar = NULL;
+	}
+
+	ieee80211_free_hw(hw);
+	return NULL;
 }
 
 void ath12k_mac_destroy(struct ath12k_hw_group *ag)
@@ -15506,6 +15487,13 @@ void ath12k_mac_destroy(struct ath12k_hw_group *ag)
 			pdev = &ab->pdevs[j];
 			if (!pdev->ar)
 				continue;
+
+			spin_lock_bh(&pdev->ar->data_lock);
+			ath12k_link_sta_hlist_flush(pdev->ar);
+			spin_unlock_bh(&pdev->ar->data_lock);
+
+			ath12k_link_sta_hlist_destroy(pdev->ar);
+
 			pdev->ar = NULL;
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
index 80edebf0e364..2be9b8dd4c23 100644
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -454,121 +454,103 @@ int ath12k_peer_mlo_link_peers_delete(struct ath12k_vif *ahvif, struct ath12k_st
 	return err_ret;
 }
 
-static int ath12k_link_sta_rhash_insert(struct ath12k_base *ab,
-					struct ath12k_link_sta *arsta)
+static u64 ath12k_link_sta_hash_key(const u8 *addr)
 {
-	struct ath12k_link_sta *tmp;
-
-	lockdep_assert_held(&ab->base_lock);
-
-	tmp = rhashtable_lookup_get_insert_fast(ab->rhead_sta_addr, &arsta->rhash_addr,
-						ab->rhash_sta_addr_param);
-	if (!tmp)
-		return 0;
-	else if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-	else
-		return -EEXIST;
+	return ether_addr_to_u64(addr);
 }
 
-static int ath12k_link_sta_rhash_remove(struct ath12k_base *ab,
-					struct ath12k_link_sta *arsta)
+static u32 ath12k_link_sta_hash_idx(struct ath12k *ar, const u8 *addr)
 {
-	int ret;
-
-	lockdep_assert_held(&ab->base_lock);
+	u64 key = ath12k_link_sta_hash_key(addr);
 
-	ret = rhashtable_remove_fast(ab->rhead_sta_addr, &arsta->rhash_addr,
-				     ab->rhash_sta_addr_param);
-	if (ret && ret != -ENOENT)
-		return ret;
-
-	return 0;
+	return hash_min(key, ar->arsta_hash_bits);
 }
 
-int ath12k_link_sta_rhash_add(struct ath12k_base *ab,
+int ath12k_link_sta_hlist_add(struct ath12k *ar,
 			      struct ath12k_link_sta *arsta)
 {
-	int ret;
+	struct ath12k_link_sta *tmp;
+	struct hlist_head *bucket;
 
-	lockdep_assert_held(&ab->base_lock);
+	lockdep_assert_held(&ar->data_lock);
 
-	ret = ath12k_link_sta_rhash_insert(ab, arsta);
-	if (ret)
-		ath12k_warn(ab, "failed to add arsta %pM in rhash_addr ret %d\n",
-			    arsta->addr, ret);
+	bucket = &ar->arsta_hlist[ath12k_link_sta_hash_idx(ar, arsta->addr)];
+	hlist_for_each_entry(tmp, bucket, hash_node) {
+		if (ether_addr_equal(tmp->addr, arsta->addr)) {
+			ath12k_warn(ar->ab, "arsta %pM already present in hash table\n",
+				    arsta->addr);
+			return -EEXIST;
+		}
+	}
 
-	return ret;
+	hlist_add_head(&arsta->hash_node, bucket);
+	return 0;
 }
 
-void ath12k_link_sta_rhash_delete(struct ath12k_base *ab,
+void ath12k_link_sta_hlist_delete(struct ath12k *ar,
 				  struct ath12k_link_sta *arsta)
 {
-	/*
-	 * Return type of this function is void since there is nothing to be
-	 * done in failure case
-	 */
-	int ret;
-
-	lockdep_assert_held(&ab->base_lock);
+	lockdep_assert_held(&ar->data_lock);
 
-	ret = ath12k_link_sta_rhash_remove(ab, arsta);
-	if (ret)
-		ath12k_warn(ab,
-			    "failed to remove arsta %pM in rhash_addr ret %d\n",
-			    arsta->addr, ret);
+	hlist_del_init(&arsta->hash_node);
 }
 
-int ath12k_link_sta_rhash_tbl_init(struct ath12k_base *ab)
+int ath12k_link_sta_hlist_allocate(struct ath12k *ar)
 {
-	struct rhashtable_params *param;
-	struct rhashtable *rhash_addr_tbl;
-	int ret;
-
-	rhash_addr_tbl = kzalloc_obj(*ab->rhead_sta_addr);
-	if (!rhash_addr_tbl)
-		return -ENOMEM;
+	struct hlist_head *arsta_hlist;
+	u32 sta_max, buckets;
+	u8 hash_bits;
 
-	param = &ab->rhash_sta_addr_param;
+	sta_max = ath12k_core_get_max_station_per_radio(ar->ab);
+	hash_bits = order_base_2(sta_max);
 
-	param->key_offset = offsetof(struct ath12k_link_sta, addr);
-	param->head_offset = offsetof(struct ath12k_link_sta, rhash_addr);
-	param->key_len = sizeof_field(struct ath12k_link_sta, addr);
-	param->automatic_shrinking = true;
-	param->nelem_hint = ab->num_radios * ath12k_core_get_max_peers_per_radio(ab);
+	buckets = BIT(hash_bits);
+	arsta_hlist = kcalloc(buckets, sizeof(*arsta_hlist), GFP_KERNEL);
+	if (!arsta_hlist)
+		return -ENOMEM;
 
-	ret = rhashtable_init(rhash_addr_tbl, param);
-	if (ret) {
-		ath12k_warn(ab, "failed to init peer addr rhash table %d\n",
-			    ret);
-		goto err_free;
-	}
+	__hash_init(arsta_hlist, buckets);
 
-	ab->rhead_sta_addr = rhash_addr_tbl;
+	ar->arsta_hash_bits = hash_bits;
+	ar->arsta_hlist = arsta_hlist;
 
 	return 0;
+}
 
-err_free:
-	kfree(rhash_addr_tbl);
+void ath12k_link_sta_hlist_flush(struct ath12k *ar)
+{
+	struct ath12k_link_sta *arsta;
+	struct hlist_node *tmp;
+	u32 bkt;
 
-	return ret;
+	lockdep_assert_held(&ar->data_lock);
+
+	for (bkt = 0; bkt < BIT(ar->arsta_hash_bits); bkt++) {
+		hlist_for_each_entry_safe(arsta, tmp, &ar->arsta_hlist[bkt], hash_node)
+			hlist_del_init(&arsta->hash_node);
+	}
 }
 
-void ath12k_link_sta_rhash_tbl_destroy(struct ath12k_base *ab)
+void ath12k_link_sta_hlist_destroy(struct ath12k *ar)
 {
-	if (!ab->rhead_sta_addr)
-		return;
-
-	rhashtable_destroy(ab->rhead_sta_addr);
-	kfree(ab->rhead_sta_addr);
-	ab->rhead_sta_addr = NULL;
+	kfree(ar->arsta_hlist);
+	ar->arsta_hlist = NULL;
+	ar->arsta_hash_bits = 0;
 }
 
-struct ath12k_link_sta *ath12k_link_sta_find_by_addr(struct ath12k_base *ab,
+struct ath12k_link_sta *ath12k_link_sta_find_by_addr(struct ath12k *ar,
 						     const u8 *addr)
 {
-	lockdep_assert_held(&ab->base_lock);
+	struct ath12k_link_sta *arsta;
+	struct hlist_head *bucket;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	bucket = &ar->arsta_hlist[ath12k_link_sta_hash_idx(ar, addr)];
+	hlist_for_each_entry(arsta, bucket, hash_node) {
+		if (ether_addr_equal(arsta->addr, addr))
+			return arsta;
+	}
 
-	return rhashtable_lookup_fast(ab->rhead_sta_addr, addr,
-				      ab->rhash_sta_addr_param);
+	return NULL;
 }
diff --git a/drivers/net/wireless/ath/ath12k/peer.h b/drivers/net/wireless/ath/ath12k/peer.h
index 3f4ac17b9aa6..d56ef3cc2b31 100644
--- a/drivers/net/wireless/ath/ath12k/peer.h
+++ b/drivers/net/wireless/ath/ath12k/peer.h
@@ -29,11 +29,12 @@ int ath12k_wait_for_peer_delete_done(struct ath12k *ar,
 int ath12k_peer_mlo_link_peers_delete(struct ath12k_vif *ahvif, struct ath12k_sta *ahsta);
 struct ath12k_ml_peer *ath12k_peer_ml_find(struct ath12k_hw *ah,
 					   const u8 *addr);
-int ath12k_link_sta_rhash_tbl_init(struct ath12k_base *ab);
-void ath12k_link_sta_rhash_tbl_destroy(struct ath12k_base *ab);
-void ath12k_link_sta_rhash_delete(struct ath12k_base *ab, struct ath12k_link_sta *arsta);
-int ath12k_link_sta_rhash_add(struct ath12k_base *ab, struct ath12k_link_sta *arsta);
-struct ath12k_link_sta *ath12k_link_sta_find_by_addr(struct ath12k_base *ab,
+int ath12k_link_sta_hlist_allocate(struct ath12k *ar);
+void ath12k_link_sta_hlist_flush(struct ath12k *ar);
+void ath12k_link_sta_hlist_destroy(struct ath12k *ar);
+void ath12k_link_sta_hlist_delete(struct ath12k *ar, struct ath12k_link_sta *arsta);
+int ath12k_link_sta_hlist_add(struct ath12k *ar, struct ath12k_link_sta *arsta);
+struct ath12k_link_sta *ath12k_link_sta_find_by_addr(struct ath12k *ar,
 						     const u8 *addr);
 u16 ath12k_peer_ml_alloc(struct ath12k_hw *ah);
 void ath12k_peer_ml_free(struct ath12k_hw *ah, struct ath12k_sta *ahsta);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 75b259990c79..c13832643aac 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7582,10 +7582,12 @@ static void ath12k_peer_sta_kickout_event(struct ath12k_base *ab, struct sk_buff
 {
 	struct wmi_peer_sta_kickout_arg arg = {};
 	struct ath12k_link_vif *arvif;
-	struct ieee80211_sta *sta;
-	struct ath12k_sta *ahsta;
 	struct ath12k_link_sta *arsta;
+	struct ieee80211_sta *sta;
+	struct ath12k_pdev *pdev;
 	struct ath12k *ar;
+	bool found = false;
+	int i;
 
 	if (ath12k_pull_peer_sta_kickout_ev(ab, skb, &arg) != 0) {
 		ath12k_warn(ab, "failed to extract peer sta kickout event");
@@ -7594,44 +7596,80 @@ static void ath12k_peer_sta_kickout_event(struct ath12k_base *ab, struct sk_buff
 
 	rcu_read_lock();
 
-	spin_lock_bh(&ab->base_lock);
+	/*
+	 * The same address can be present on more than one radio during a
+	 * roam/split-PHY overlap window, and the event carries no radio
+	 * identifier to disambiguate. Since the firmware could mean either
+	 * one, process every radio with a match instead of just the first.
+	 */
+	for (i = 0; i < ab->num_radios; i++) {
+		pdev = rcu_dereference(ab->pdevs_active[i]);
+		if (!pdev || !pdev->ar)
+			continue;
 
-	arsta = ath12k_link_sta_find_by_addr(ab, arg.mac_addr);
+		ar = pdev->ar;
 
-	if (!arsta) {
-		ath12k_warn(ab, "arsta not found %pM\n",
-			    arg.mac_addr);
-		goto exit;
-	}
+		spin_lock_bh(&ar->data_lock);
+		arsta = ath12k_link_sta_find_by_addr(ar, arg.mac_addr);
+		if (!arsta) {
+			spin_unlock_bh(&ar->data_lock);
+			ath12k_dbg(ab, ATH12K_DBG_WMI,
+				   "arsta %pM not found on radio %d in peer sta kickout event\n",
+				   arg.mac_addr, i);
+			continue;
+		}
 
-	arvif = arsta->arvif;
-	if (!arvif) {
-		ath12k_warn(ab, "invalid arvif in peer sta kickout ev for STA %pM",
-			    arg.mac_addr);
-		goto exit;
-	}
+		arvif = arsta->arvif;
+		if (!arvif) {
+			spin_unlock_bh(&ar->data_lock);
+			ath12k_warn(ab, "invalid arvif in peer sta kickout ev for STA %pM\n",
+				    arg.mac_addr);
+			continue;
+		}
 
-	ar = arvif->ar;
-	ahsta = arsta->ahsta;
-	sta = ath12k_ahsta_to_sta(ahsta);
+		sta = ath12k_ahsta_to_sta(arsta->ahsta);
+		spin_unlock_bh(&ar->data_lock);
 
-	ath12k_dbg(ab, ATH12K_DBG_WMI,
-		   "peer sta kickout event %pM reason: %d rssi: %d\n",
-		   arg.mac_addr, arg.reason, arg.rssi);
+		/*
+		 * arvif and sta remain valid for the duration of this
+		 * rcu_read_lock() section: every teardown path nulls the
+		 * pointer via rcu_assign_pointer() and calls synchronize_rcu()
+		 * before freeing arvif/arsta, so that grace period cannot
+		 * complete while this section is still active.
+		 */
+		found = true;
 
-	switch (arg.reason) {
-	case WMI_PEER_STA_KICKOUT_REASON_INACTIVITY:
-		if (arvif->ahvif->vif->type == NL80211_IFTYPE_STATION) {
-			ath12k_mac_handle_beacon_miss(ar, arvif);
-			break;
+		/*
+		 * A STA roaming between radios of the same AP can be present
+		 * in more than one radio's arsta table during the handover
+		 * window, and the firmware event carries no radio identifier.
+		 * Only the radio on which the STA is currently authorized
+		 * owns it; skip the stale radio(s) to avoid handling the same
+		 * kickout twice.
+		 */
+		if (arvif->ahvif->vif->type == NL80211_IFTYPE_AP &&
+		    arsta->ahsta->state != IEEE80211_STA_AUTHORIZED)
+			continue;
+
+		ath12k_dbg(ab, ATH12K_DBG_WMI,
+			   "peer sta kickout event %pM reason %d rssi %d\n",
+			   arg.mac_addr, arg.reason, arg.rssi);
+
+		switch (arg.reason) {
+		case WMI_PEER_STA_KICKOUT_REASON_INACTIVITY:
+			if (arvif->ahvif->vif->type == NL80211_IFTYPE_STATION) {
+				ath12k_mac_handle_beacon_miss(ar, arvif);
+				break;
+			}
+			fallthrough;
+		default:
+			ieee80211_report_low_ack(sta, 10);
 		}
-		fallthrough;
-	default:
-		ieee80211_report_low_ack(sta, 10);
 	}
 
-exit:
-	spin_unlock_bh(&ab->base_lock);
+	if (!found)
+		ath12k_warn(ab, "failed to find arsta %pM\n", arg.mac_addr);
+
 	rcu_read_unlock();
 }
 
@@ -8443,8 +8481,8 @@ static int ath12k_wmi_tlv_fw_stats_data_parse(struct ath12k_base *ab,
 
 		arvif = ath12k_mac_get_arvif(ar, le32_to_cpu(src->vdev_id));
 		if (arvif) {
-			spin_lock_bh(&ab->base_lock);
-			arsta = ath12k_link_sta_find_by_addr(ab, arvif->bssid);
+			spin_lock_bh(&ar->data_lock);
+			arsta = ath12k_link_sta_find_by_addr(ar, arvif->bssid);
 			if (arsta) {
 				arsta->rssi_beacon = le32_to_cpu(src->beacon_snr);
 				ath12k_dbg(ab, ATH12K_DBG_WMI,
@@ -8455,7 +8493,7 @@ static int ath12k_wmi_tlv_fw_stats_data_parse(struct ath12k_base *ab,
 					    "not found link sta with bssid %pM for vdev stat\n",
 					    arvif->bssid);
 			}
-			spin_unlock_bh(&ab->base_lock);
+			spin_unlock_bh(&ar->data_lock);
 		}
 
 		data += sizeof(*src);
@@ -8561,11 +8599,11 @@ static int ath12k_wmi_tlv_rssi_chain_parse(struct ath12k_base *ab,
 		   "stats bssid %pM vif %p\n",
 		   arvif->bssid, arvif->ahvif->vif);
 
-	guard(spinlock_bh)(&ab->base_lock);
-	arsta = ath12k_link_sta_find_by_addr(ab, arvif->bssid);
+	guard(spinlock_bh)(&ar->data_lock);
+	arsta = ath12k_link_sta_find_by_addr(ar, arvif->bssid);
 	if (!arsta) {
 		ath12k_warn(ab,
-			    "not found link sta with bssid %pM for rssi chain\n",
+			    "failed to find link sta with bssid %pM for rssi chain\n",
 			    arvif->bssid);
 		return -EPROTO;
 	}

base-commit: fab2e70afb13485ea4b198b204af33dd15b8132c
-- 
2.34.1

