Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792995706;
	b=ge1TCUI5m2QPmIsY64QIb9N74hlHtydEdS3jlnsomy0jDUZ71Q7KI/9+wDsz6kt/xoEe
	 097RVpg0Tu2qLjcbRPFN2f15ltph5uZ5QmSNI9t1PQZ0wdhky911zLKwLIhFhSdphWlIX
	 /H15xjwcF+ZYQwdti/NzkBbcIflfTQBql8AP7oGhLISYwMAvQ1czm/2TX0xDnpsky0ez7
	 fqolqmtSON1GqWNjjoIv8taaaBhrOi6V3RGLxzi+8ZJWBi2ReysHPAHlYETc/igjXXq9d
	 eL3E/t19fgAMGspQu0MBs7M+Q1oqGmTK7tUZumoRROK4Z/dnE9kw0l5elnNzhtNlLWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792995706;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xI9QPWI9zBXzdzGyS7IBz9+6uGX1iAwS1OSY9Qm/7V4=;
	b=gmXkaOIbPtODVwdu+Q/hGTrZ26qmQ+7JHVCXrsyn+5JyXHRSh/+PndwENGXYBDD+0NMX
	 j7kbDJEWiSomcG/WUaZ/ipUCmBIuktpczcItfk81s+BegUxb/hVZTkvKjhLFImsJlXbnJ
	 QqFoWudlZgMyoledVyTBdwBfC7Iw1n7lgivlVnmqQShwwPbWDYkOyQY25vwJEO5S5IfBk
	 wEu5hKU+nJNSBdgZK0jNUFOG9ccXmsi44bNBYug7AqJLu4Eqyg0NUK8IGxn/5wY4i2mM+
	 vONM18nl8StvnScKg4yY0dING1rHHUn7HbLp3jecCBv/kCeXUZevSC6mp0GiJTdcHIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KjLX2guo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y2HJlXo3;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF57606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BF57606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KjLX2guo;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y2HJlXo3
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4b1FX2206176
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=xI9QPWI9zBXzdzGyS7IBz9+6uGX1iAwS1OS
	Y9Qm/7V4=; b=KjLX2guoNevglTdZLaAYLOJdaAwc0z22gxmkaETY9od1VyrOpn1
	G97d3pxIGm3UI44IGPvhzG0uWqlZgIUk1rjYECsJEg8ntjkt13yyD1Jqm+fQrXhz
	cKIh8c3KhrDuUVhIN9Vs60DF6+H8KSILvZCbQT7ffwB9dPm9jeXroAvad3gnRbgl
	LE8XMHYDx3+sVdqYrn+omWFXuHvyIHWvU5papHzMrx8xHqsj8fSPM7d4rS3bVsnk
	klMCKnb3q86WY0zhGuSxWrgEhXQIe7eASkAEWLTjPaS+0w9fNUqsubvSN5feUjN/
	L6f5MrhoV+OrjgEU7AhGwOFqHpX0izfGeVg==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgmrun1gc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:21:45 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-147be78cd56so12207719c88.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 23:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792995704; x=1793600504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xI9QPWI9zBXzdzGyS7IBz9+6uGX1iAwS1OSY9Qm/7V4=;
        b=Y2HJlXo3CnRfDiPOmwLf+sJF2ruY9W8C3/vjkHYOL9+amo/qczt9jvEKmHvZilpBf9
         WytAOoOwOUozRYSvfbig/zPr9Nnutxt4/2jQNoKwB5vsYNFo0JfOSoK80RKGScpWGE9j
         aLUNr34edWFOxTH4PpGbUNzmMLVqvdgMBmqQk1qbg5yR8Qwifo0FpKl5nDfx5o19Tx1L
         Ik57VoluQSbBRTFnQhW5Lt9Lf/RNVk1ZPgedoqevKTzJO4ptdIonQpFS4aIM/Sj9vLq8
         SdGYKTsbzXYxmcuS/iadqQH4OvjJNFN2NCOiZLaiByeoTdAzgFeyDCJol6/Kma0VfnMd
         ybJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792995704; x=1793600504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xI9QPWI9zBXzdzGyS7IBz9+6uGX1iAwS1OSY9Qm/7V4=;
        b=CigsaTc5p/mp/WBB+G6wZp+ulS0xGvi1nWoEEF7lTVVeF6JypV3GgTlz33/wCYqKJw
         CWloNExjd7or0raKOMtyyfRI7t2yT88ECHOImgkXkeOs6YemiH0eMP5kl7wM3wAsfMch
         ylr9R5yTdEFvgKqj4uIyEn3KZLbArqcVuV3fmCKooIzns8EXtZUYSK92q82Zq/hhu1Q1
         V4Lm5QJajAOm9cf3JsTKaMTYZVIi9EpB1Sbov0wZmuTnUn/7rSl4P5sT/hxtFpj0v5OG
         W5h0fJmCXzzXXLCcZ4m78ivIeOfDrXiJtStpL0vcHdyunvRV3XLQXPh0VzKV39spBtbo
         vyOg==
X-Gm-Message-State: AFq9FYIy4XBQkSBu7233bLV4vtIyV4vCYNsAVfXcgJ/kjXxGQBn53XnX
	yRIt9ORzFrNbxnVMCZbcA8rX+axqLyu8JvlgpsMa33uUW6Kl0E0oYX3YQhYvbDrbjzFywKGcRME
	rJTcupP0IbMy08KghgBVuJj1lWFHrN6VFvtRwlB/Gt9QTjroggnUZJXl2sTJ2H6vULtuGzg==
X-Gm-Gg: AYBFou1s7jQqcoA3iq+h/ZYyMJ2wu8u8bkKZF0wj0EoJ2SDt5YheGApiEDuaGR1FpLn
	B4C4+WVVh3psSX4GLeTiB93w6WZCKZcvyZT/gn9oFTJkkxQM+Qb3OTXrYqATLuQzazS6ELuMu6k
	c5FeCtRcvtDkI6UqfrBP6FCYRRENVdCEv9+1c6LB25wHFSFK44vMLOkFa0FEpFod3I4Jev6pqJV
	d4oxVCCJLCDvDJM/ryrQ6fqNTSHOC6H83hAgtYcTs0+qHVlaJ7jl9AVk6lAGyM1/WpuRC0j+d35
	2Kg2jZZePfmHYL34Q3FRuTR+Hv/TIChenge6UYhcZW6IBNLrVfyZ2I1sCBYWItSYcmUKmyEX9Rz
	ANgbd9urtH/MLxGLzYNJ/UBMMZCSXpqfAlLC+mVdaqtUdy+yjtsOSWpeWbyQiUU/mIRqFgOhOt5
	15aDSZk2j/wZpQJA==
X-Received: by 2002:a05:7022:23a9:b0:158:1ed2:cb58 with SMTP id a92af1059eb24-1993fe81364mr13634014c88.39.1792995703886;
        Sun, 25 Oct 2026 23:21:43 -0700 (PDT)
X-Received: by 2002:a05:7022:23a9:b0:158:1ed2:cb58 with SMTP id a92af1059eb24-1993fe81364mr13633967c88.39.1792995703155;
        Sun, 25 Oct 2026 23:21:43 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0f81ea9sm25564897c88.11.2026.10.25.23.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 23:21:42 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: add hash table for peer lookup in struct ath12k_dp_hw
Date: Mon, 26 Oct 2026 11:51:31 +0530
Message-Id: <20261026062131.1589569-1-aishwarya.r@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyNSBTYWx0ZWRfX0P0ld7QNYmV4
 AAfYgOIshQhY6GyD6fC3O5V4RJBY5BYOem7gkmch2MjVDT0KKu2ejuuP/rhLR+B2EiYhAUYwzpp
 OGdWUOHFgOKvgy4Rm5j8hmEpx2lmSucmpWAHD6FDOxF0lvipb91+h394umT21Zy+BdA2b+YSl2W
 4t0OIGPgHmbLCX0y3rIKJF4I1couYUU1jP4ztMI8b9ggkH5RNjy+uTQC7Rlipua5AcOpuiSarqV
 mR0x3Jh9EIyQs+sqO/zCb8JmSCYYTfqJn8oAlaUahKCrcoI4XZgVp4pQZFJ6pa9HZWNTKYnrwZe
 7I7KjQoJg9pfcMnIP5cMTnSjJJB5vbktEf9DOaLQFrcS6f+3f5HfyFD/TYeX6yzX68+H8J5R0Z3
 Yunf4IhY/CL96oJUjW7MnuE4QloUKnQ5BIhHZ/6m13RzEbMTM7rWrJkxVG5xPBMBIvdwnUe8iO9
 x4kuG/Q/aXOFh6c7Nng==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyNSBTYWx0ZWRfX5Iil0/4VQUA/
 q7LBgSboWtdz965BbLDjY6u7LOvU0Sj62YjiDeRjLGHghhoWj+5IkZNkti6kX2RBG6Rrs1IkAkb
 I2+dEV0Z/24+Nv9IcEkr/N2tCco2xB8=
X-Proofpoint-ORIG-GUID: oHrU-wmCcZeSL5rFbbCgmgtRfp4pVPAw
X-Authority-Analysis: v=2.4 cv=e+aT2qp/ c=1 sm=1 tr=0 ts=6adef179 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=e0xTfCGfjV48Ql1BNNoA:9 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-GUID: oHrU-wmCcZeSL5rFbbCgmgtRfp4pVPAw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260025

Peer lookup by MAC address in struct ath12k_dp_hw is currently performed by
walking the dp_peers_list, resulting in O(n) lookup complexity. As the
driver supports up to 1536 clients, frequent lookups on critical paths
such as TX/RX processing, peer management, control operations and
debug/statistics handling can incur noticeable overhead in dense
deployment scenarios.

Replace the peer list with a generic kernel hash table for MAC address
based peer management and lookup, providing O(1) average-case lookup
performance. The hash table is implemented using DECLARE_HASHTABLE()
with 2048 buckets (2^11), derived from
order_base_2(ATH12K_MAX_DEVICES * ATH12K_MAX_CLIENTS), and uses jhash()
over the peer MAC address as the hash key.

The hash table is used both for address-based lookups and peer
traversal operations, eliminating the need for maintaining a separate
peer list.

The maximum single-radio client limit is defined as
ATH12K_MAX_CLIENTS and reused by the memory profile and hardware
params. This keeps the peer hash sizing aligned with the per-device
client limit and the maximum number of devices in a hardware group.

Key changes:
- Add peer_hash table to ath12k_dp_hw and initialize it during
  hardware allocation.
- Add hash_node to ath12k_dp_peer for hash table membership.
- Introduce helper APIs for hash computation, insertion, deletion and
  lookup.
- Convert MAC-address-based peer searches from list traversal to
  hash-table lookup.
- Replace peer list traversal with hash table iteration.

Peer creation inserts the peer into the hash table, while deletion
removes it from the hash table. Peer cleanup paths are updated to
iterate over the hash table and safely free peer objects.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Co-developed-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Signed-off-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/cmn_defs.h |  2 +
 drivers/net/wireless/ath/ath12k/core.c     |  2 +-
 drivers/net/wireless/ath/ath12k/dp_cmn.h   | 14 ++++++-
 drivers/net/wireless/ath/ath12k/dp_peer.c  | 47 ++++++++++++++++++----
 drivers/net/wireless/ath/ath12k/dp_peer.h  |  6 ++-
 drivers/net/wireless/ath/ath12k/mac.c      | 20 ++++-----
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 10 ++---
 7 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/cmn_defs.h b/drivers/net/wireless/ath/ath12k/cmn_defs.h
index 20208ffea1c9..15c5e8d11afc 100644
--- a/drivers/net/wireless/ath/ath12k/cmn_defs.h
+++ b/drivers/net/wireless/ath/ath12k/cmn_defs.h
@@ -10,6 +10,8 @@
 
 #define MAX_RADIOS 2
 #define ATH12K_MAX_DEVICES 3
+#define ATH12K_MAX_CLIENTS 512
+
 #define ATH12K_GROUP_MAX_RADIO (ATH12K_MAX_DEVICES * MAX_RADIOS)
 
 #define ATH12K_SCAN_MAX_LINKS	ATH12K_GROUP_MAX_RADIO
diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 25987bc58556..5e4488d5f9ea 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -44,7 +44,7 @@ static const struct
 ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 [ATH12K_QMI_MEMORY_MODE_DEFAULT] = {
 		.num_vdevs = 17,
-		.max_client_single = 512,
+		.max_client_single = ATH12K_MAX_CLIENTS,
 		.max_client_dbs = 128,
 		.max_client_dbs_sbs = 128,
 		.dp_params = {
diff --git a/drivers/net/wireless/ath/ath12k/dp_cmn.h b/drivers/net/wireless/ath/ath12k/dp_cmn.h
index e17f044ff812..f720f9ecef5b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_cmn.h
+++ b/drivers/net/wireless/ath/ath12k/dp_cmn.h
@@ -7,6 +7,7 @@
 #define ATH12K_DP_CMN_H
 
 #include "cmn_defs.h"
+#include <linux/hashtable.h>
 
 struct ath12k_hw_group;
 
@@ -17,12 +18,21 @@ struct ath12k_hw_group;
  */
 #define MAX_DP_PEER_LIST_SIZE  16384
 
+/*
+ * The hash table supports ATH12K_MAX_DEVICES * ATH12K_MAX_CLIENTS clients;
+ * order_base_2() gives 2048 hash buckets.
+ */
+#define ATH12K_DP_PEER_HASH_BITS \
+	order_base_2(ATH12K_MAX_DEVICES * ATH12K_MAX_CLIENTS)
+
 struct ath12k_dp_hw {
 	struct ath12k_dp_peer __rcu *dp_peers[MAX_DP_PEER_LIST_SIZE];
 
-	/* Lock for protection of dp_peer_list and peers */
+	/* Lock for protection of dp_peers[] and peer_hash */
 	spinlock_t peer_lock;
-	struct list_head dp_peers_list;
+
+	/* Generic hash table for fast MAC address lookup */
+	DECLARE_HASHTABLE(peer_hash, ATH12K_DP_PEER_HASH_BITS);
 };
 
 struct ath12k_dp_hw_group {
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index bb5341b4251a..b2d38d7f8732 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -4,6 +4,7 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
+#include <linux/jhash.h>
 #include "core.h"
 #include "dp_peer.h"
 #include "debug.h"
@@ -345,30 +346,58 @@ void ath12k_dp_link_peer_rhash_delete(struct ath12k_dp *dp,
 			    peer->addr, peer->peer_id, ret);
 }
 
+static u32 ath12k_dp_peer_addr_hash(const u8 *addr)
+{
+	return jhash(addr, ETH_ALEN, 0);
+}
+
 struct ath12k_dp_peer *ath12k_dp_peer_find_by_addr(struct ath12k_dp_hw *dp_hw, u8 *addr)
 {
-	struct ath12k_dp_peer *peer;
+	struct ath12k_dp_peer *dp_peer;
+	u32 hash;
 
 	lockdep_assert_held(&dp_hw->peer_lock);
 
-	list_for_each_entry(peer, &dp_hw->dp_peers_list, list) {
-		if (ether_addr_equal(peer->addr, addr))
-			return peer;
+	hash = ath12k_dp_peer_addr_hash(addr);
+	hash_for_each_possible(dp_hw->peer_hash, dp_peer, hash_node, hash) {
+		if (ether_addr_equal(dp_peer->addr, addr))
+			return dp_peer;
 	}
 
 	return NULL;
 }
 EXPORT_SYMBOL(ath12k_dp_peer_find_by_addr);
 
+static void ath12k_dp_peer_hash_table_add(struct ath12k_dp_hw *dp_hw,
+					  struct ath12k_dp_peer *dp_peer)
+{
+	u32 hash;
+
+	lockdep_assert_held(&dp_hw->peer_lock);
+
+	hash = ath12k_dp_peer_addr_hash(dp_peer->addr);
+	hash_add(dp_hw->peer_hash, &dp_peer->hash_node, hash);
+}
+
+void ath12k_dp_peer_hash_table_delete(struct ath12k_dp_hw *dp_hw,
+				      struct ath12k_dp_peer *dp_peer)
+{
+	lockdep_assert_held(&dp_hw->peer_lock);
+
+	hash_del(&dp_peer->hash_node);
+}
+
 struct ath12k_dp_peer *ath12k_dp_peer_find_by_addr_and_sta(struct ath12k_dp_hw *dp_hw,
 							   u8 *addr,
 							   struct ieee80211_sta *sta)
 {
 	struct ath12k_dp_peer *dp_peer;
+	u32 hash;
 
 	lockdep_assert_held(&dp_hw->peer_lock);
 
-	list_for_each_entry(dp_peer, &dp_hw->dp_peers_list, list) {
+	hash = ath12k_dp_peer_addr_hash(addr);
+	hash_for_each_possible(dp_hw->peer_hash, dp_peer, hash_node, hash) {
 		if (ether_addr_equal(dp_peer->addr, addr) && (dp_peer->sta == sta))
 			return dp_peer;
 	}
@@ -382,10 +411,12 @@ static struct ath12k_dp_peer *ath12k_dp_peer_create_find(struct ath12k_dp_hw *dp
 							 bool mlo_peer)
 {
 	struct ath12k_dp_peer *dp_peer;
+	u32 hash;
 
 	lockdep_assert_held(&dp_hw->peer_lock);
 
-	list_for_each_entry(dp_peer, &dp_hw->dp_peers_list, list) {
+	hash = ath12k_dp_peer_addr_hash(addr);
+	hash_for_each_possible(dp_hw->peer_hash, dp_peer, hash_node, hash) {
 		if (ether_addr_equal(dp_peer->addr, addr)) {
 			if (!sta || mlo_peer || dp_peer->is_mlo ||
 			    dp_peer->sta == sta)
@@ -490,7 +521,7 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 
 	spin_lock_bh(&dp_hw->peer_lock);
 
-	list_add(&dp_peer->list, &dp_hw->dp_peers_list);
+	ath12k_dp_peer_hash_table_add(dp_hw, dp_peer);
 
 	/*
 	 * For an MLO client whose ML peer ID is allocated by the host, the
@@ -528,7 +559,7 @@ void ath12k_dp_peer_delete(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	    dp_peer->peer_id != ATH12K_MLO_PEER_ID_PENDING)
 		rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
 
-	list_del(&dp_peer->list);
+	ath12k_dp_peer_hash_table_delete(dp_hw, dp_peer);
 
 	spin_unlock_bh(&dp_hw->peer_lock);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index 3503840b0329..b204154dcec2 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -121,7 +121,6 @@ void ath12k_dp_link_peer_map_event(struct ath12k_base *ab, u8 vdev_id, u16 peer_
 				   u8 *mac_addr, u16 ast_hash, u16 hw_peer_id);
 
 struct ath12k_dp_peer {
-	struct list_head list;
 	bool is_mlo;
 	bool dp_setup_done;
 
@@ -146,6 +145,9 @@ struct ath12k_dp_peer {
 	struct ath12k_dp_rx_tid rx_tid[IEEE80211_NUM_TIDS + 1];
 
 	bool use_4addr;
+
+	/* Hash table node for MAC address lookup */
+	struct hlist_node hash_node;
 };
 
 struct ath12k_dp_link_peer *
@@ -183,4 +185,6 @@ ath12k_dp_link_peer_find_by_peerid(struct ath12k_pdev_dp *dp_pdev, u16 peer_id);
 void ath12k_dp_link_peer_free(struct ath12k_dp_link_peer *peer);
 int ath12k_dp_peer_fixup_peer_id(struct ath12k_base *ab, const u8 *peer_addr,
 				 u16 peer_id);
+void ath12k_dp_peer_hash_table_delete(struct ath12k_dp_hw *dp_hw,
+				      struct ath12k_dp_peer *dp_peer);
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..13c4dd3724fb 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1278,16 +1278,20 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 
 void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 {
-	struct list_head peers;
-	struct ath12k_dp_peer *dp_peer, *tmp;
 	struct ath12k_dp_hw *dp_hw = &ah->dp_hw;
+	struct ath12k_dp_peer *dp_peer;
+	struct hlist_head free_list;
+	struct hlist_node *tmp;
+	int bkt;
 
 	lockdep_assert_wiphy(ah->hw->wiphy);
 
-	INIT_LIST_HEAD(&peers);
+	INIT_HLIST_HEAD(&free_list);
 
 	spin_lock_bh(&dp_hw->peer_lock);
-	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
+	hash_for_each_safe(dp_hw->peer_hash, bkt, tmp, dp_peer, hash_node) {
+		ath12k_dp_peer_hash_table_delete(dp_hw, dp_peer);
+
 		if (dp_peer->is_mlo) {
 			if (dp_peer->peer_id != ATH12K_MLO_PEER_ID_PENDING)
 				rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id],
@@ -1295,17 +1299,15 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 			ath12k_peer_ml_free(ah, ath12k_sta_to_ahsta(dp_peer->sta));
 		}
 
-		list_move(&dp_peer->list, &peers);
+		hlist_add_head(&dp_peer->hash_node, &free_list);
 	}
 
 	spin_unlock_bh(&dp_hw->peer_lock);
 
 	synchronize_rcu();
 
-	list_for_each_entry_safe(dp_peer, tmp, &peers, list) {
-		list_del(&dp_peer->list);
+	hlist_for_each_entry_safe(dp_peer, tmp, &free_list, hash_node)
 		kfree(dp_peer);
-	}
 }
 
 static int ath12k_mac_vdev_setup_sync(struct ath12k *ar)
@@ -15464,7 +15466,7 @@ static struct ath12k_hw *ath12k_mac_hw_allocate(struct ath12k_hw_group *ag,
 
 	spin_lock_init(&ah->survey_lock);
 	spin_lock_init(&ah->dp_hw.peer_lock);
-	INIT_LIST_HEAD(&ah->dp_hw.dp_peers_list);
+	hash_init(ah->dp_hw.peer_hash);
 
 	for (i = 0; i < num_pdev_map; i++) {
 		ab = pdev_map[i].ab;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index b1c17cc197df..0f3722ec1027 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -441,7 +441,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.dp_primary_link_only = true,
 		.client = {
-			.max_client_single = 512,
+			.max_client_single = ATH12K_MAX_CLIENTS,
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
@@ -537,7 +537,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.dp_primary_link_only = false,
 		.client = {
-			.max_client_single = 512,
+			.max_client_single = ATH12K_MAX_CLIENTS,
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
@@ -629,7 +629,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.dp_primary_link_only = true,
 		.client = {
-			.max_client_single = 512,
+			.max_client_single = ATH12K_MAX_CLIENTS,
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
@@ -812,7 +812,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.dp_primary_link_only = false,
 		.client = {
-			.max_client_single = 512,
+			.max_client_single = ATH12K_MAX_CLIENTS,
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
@@ -901,7 +901,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.dp_primary_link_only = true,
 		.client = {
-			.max_client_single = 512,
+			.max_client_single = ATH12K_MAX_CLIENTS,
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},

base-commit: 3608e4190659fb871207b7db58667a373536094a
-- 
2.34.1

