Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C03AFD12
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529829; cv=none; b=nm7V7uPOPQepjtds0JhMWvhgc/nNSDJwZ0zVvDOh6HdOQyPLhPgZoVx5eBfvERMSbsD3rnqClXBUzPRaD7edBmhSSqTKrtsCeuIwwnQIGqYky/u53cPG9HL1zuylZdc7xJ7m978d2U2+iWk3X0fUsH6K+KSw6zP97q8GEC5OkOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529829; c=relaxed/simple;
	bh=Rj+ZkhKxkDGfpSccmuXcadOEU2KYD5e3q/T2Y9uymLU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kLZ+8zEcczwu+cNns3vmJHp5lZqnp0AZnzHxVQL/t8+sEilH72S/vxCPxsiyTpjbUop2n86I+a29pM9myooFwwX/f+9m/rPBeZLYVEIPN4BmCX0l3+PlR3HAU2ginTxCXhAQ7PEt0mQhaNmU4qqd8wCXt5J1fY5qC/3zfI1gHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oHmaijl6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Azn0PPwI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oHmaijl6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Azn0PPwI"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6Riwn1713664
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8wYSefXJspKu/F33bCo7jnk3E3ZSEwxIqexvka0grbs=; b=oHmaijl6FucFRQ0b
	0Ja/5vbGpbW+8uffe2aejYSzcaOEGqqBX5Dy+TBg239bETUZLDvu0XUYea4Nuv4S
	FxAXS4R6bGs9vvhXGsfgv2RYDWrHejtnMm3QVRNlobkYS3uQeJ6X4I/FIkGJ7E73
	XiyJIjBAEIdEODOoR4UkRv2rDtINZTf2ikrzwuOd4iSc+rg6j1uaHO0L0cQXyYXj
	E9cMqWzYdm1T4wSXgSyl9uv6lpSFWU2WzeRuu5kbSnyT1QQNfE0mn2Jx1IeedksM
	s12UHadCsgKNhr2XlFI1mywBX9sC6u6UQ4U2LTdV7qskLH1e1eBJ5J0mnCnDkBLZ
	FHiVsg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2dc4u0v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:43 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8486ffba174so16249638b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529823; x=1785134623; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8wYSefXJspKu/F33bCo7jnk3E3ZSEwxIqexvka0grbs=;
        b=Azn0PPwILHbPJR4dEz/7YH5ONwUXKXNLMR2HQnkfa46Vy5qDcX1XlLXuTaka+sRuvA
         Y1qfF+vpO6dqxwTYfBvFoNTiPbcUy7/Y+sVMiCYLmvQ4+ny6cUB4JGnk4rOlW9svv3jz
         RPy0hTN+qyBMKuv2P1ZLFuiM1G910vzilSw8QYTkfYOdJzA5ul3NJ0VpGvHxYKpdYewp
         QRFv2+MNEZFGZyxzZMhbcAcsfQvfbMi6VHHzQY7h3bnsX5m1LktH1wnpvrByJpiAVKxY
         hIUPHNhEk2RxLuaO6e3++UY94Bt2o2TJPadbSz2eMTrKqOCWz5wn4p+PWtNWpFEWkkrd
         ncgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529823; x=1785134623;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8wYSefXJspKu/F33bCo7jnk3E3ZSEwxIqexvka0grbs=;
        b=ECKhIHPsJtotYGLxaoe9coQ/Ys7DGHkHT4MJI2raZ93N6vrV2aUZslZwEvuzzohwy5
         P5FCSv7/Q5JLb9XR6DWpx9F2Pu6CEeoB/PQoHaL46F9nthcg7Up6vv9nIt4CS88UhfDL
         88fbfeuuK1UGoVPgM9Fhls21LWrmaH7I+Dyg4vJlofwIjMqALjKvZxkw7Rs09hfexPTP
         HvHLDhPBaipX2XgF/OmIo9etixO14H0pGfFImFcl1E5QOWRBqBr0ggePy/WfeNF0RmYy
         fUS6mcBbbyI6zAZGZSjRPAbfBfAfdo5ZrEfsZjDMBmLKcziW5DsRIqFAdxX9TYB5i5g/
         eurw==
X-Gm-Message-State: AOJu0Yw4d7ykscT9iuKLHkZyFq+BlNJCHqonmFaOCRGOiFg5Us1vf8sh
	BDh7VZhe20iyHKHQ9Z3m49UY5B0b1FK5bGiJkroJGb7K+SM7dHIJO163zmpwTHS8P0vho9Q7rjB
	Z0+J0Uqgsk8idTxHSkHSeRTdmFyiWHWBzDEwNoTn2zrLftXMf8vRKjvleRKnugr/ZAchuXg==
X-Gm-Gg: AfdE7cmtENx3JXb584qdGNIs7l/tgC6g5oC7wwn1P8jGLDz8WOCKJg8WQOVvELZR4Ot
	Zu1QyR1amzForsBljD2jdv/fYXlEQ4BFqkGbNiHUfLuwx306gVPIr5zp00N1Fm32dNCuGr9+A40
	IixFh2VwkFbcSkoBT1WdPep7bDYDXp/EhNEBXuteODZyd8nO3hMx7J4GtSROVqXiOjJNJU1dPaq
	w0qjgnaDOlXHJ4RVcy/hK9/c0YZujTfLfe57BlBdQ8yrJMCDAS+GuSUi1DPUzGmvT2bUAMA/ULt
	oO2xhxxktJnSXdPFdG2pHEMwwvQrzTI8cwfLhS9OV74tUTa8R83T5CR4jPhLE3H2zPi2/hRhsKM
	a3TsOXyANUforbteNvlHtmoT9msdfoftrnjqNejKcn1Dsu6MvR49QDQ==
X-Received: by 2002:a05:6a00:a88f:b0:847:9151:3409 with SMTP id d2e1a72fcca58-84c294fb467mr13402964b3a.55.1784529822725;
        Sun, 19 Jul 2026 23:43:42 -0700 (PDT)
X-Received: by 2002:a05:6a00:a88f:b0:847:9151:3409 with SMTP id d2e1a72fcca58-84c294fb467mr13402939b3a.55.1784529822079;
        Sun, 19 Jul 2026 23:43:42 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:40 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:26 +0800
Subject: [PATCH ath-current v2 5/8] wifi: ath12k: introduce
 host_alloc_ml_id hardware parameter
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-5-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX/JXo8fd/lRgo
 CMNIPTOxjDSwf5nDmYRFCNcoseVXZy9An1ndoMz63UJWTR0nzFxsuq2vfIHdlGWTarQfdkGPO/N
 mlN3lyjsBF0uXq0Y8sdwFw9Z0X9+3hw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX2OxdUeM8B03J
 xcX3V/IQ0Ljl8OnVb7ZontURSDdO5vQwbHmfNLLAk9NliBaszMd//xWJUAkfd9mITlpHJkShTM9
 zGfIgu5/q76t6t2XpKQ3oHcw+KhNz8g7MdDXYQH4EDCxNEe7hgXaK8FkSoVPNc5goCpsFvxABT5
 GosuPNfR8aWoRiy+s3fA99iF7vVE1zWDBaoTvm7MmCMKQPNJxe1U5O7QUYKlYbKy2JRSHb6Ue1b
 m7b6DYe0RuFdt6YA9Dcr9FWRgAtFi9EKMzZRbNG+3Dcs2R5SnWom4dsLdDVjch2aR20xzm0716m
 aeac1Bjoo/C3VKl1dkhinvTzFVTA0Y6LRHU5lWFyEL78HGIkAv7KYXUzUcWCHhDO6k9AdYB3eiY
 gl9/D0VvsvTb9BQUfyfeHaTb4M88egNTtap7p9xu9Ogao7mQs/ESOxRGR2pR5eNeYkL9kbj1H21
 gizHZ1hxHUaxCQoMwKQ==
X-Proofpoint-ORIG-GUID: cad63vLeOYqHonr31BZ80dWLHJP_sYjO
X-Proofpoint-GUID: cad63vLeOYqHonr31BZ80dWLHJP_sYjO
X-Authority-Analysis: v=2.4 cv=FOQrAeos c=1 sm=1 tr=0 ts=6a5dc39f cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2Mqij7SlxvU2Fhucnr4A:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200072

Different ath12k devices diverge on who allocates MLD peer id:
WCN7850/QCC2072 have the firmware allocate it and notify the host via
HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP event; While others let the host allocate
it and pass it down through WMI_PEER_ASSOC_CMDID with
ATH12K_WMI_FLAG_MLO_PEER_ID_VALID set.

Currently ath12k host allocates this ID and sends it to firmware by
default for all devices. This breaks WCN7850/QCC2072, because the host
maintained ID may be different from the firmware-allocated one.
Consequently data path may fail to find the dp peer and drop some received
packets. From user point of view, this results in bugs reported in [1] or
the 4-way handshake timeout issue.

Add host_alloc_ml_id flag to struct ath12k_hw_params (and a copy on struct
ath12k_hw for hot-path access) so subsequent patches can branch on it. Set
true for QCN9274/IPQ5332/IPQ5424, false for WCN7850/QCC2072. The flag will
be consumed by subsequent patches.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221039 # 1
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h     |  1 +
 drivers/net/wireless/ath/ath12k/hw.h       |  2 ++
 drivers/net/wireless/ath/ath12k/mac.c      | 18 +++++++++++++++++-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 12 ++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index fc5127b5c1a3..1f56474efbea 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -793,6 +793,7 @@ struct ath12k_hw {
 	enum ath12k_hw_state state;
 	bool regd_updated;
 	bool use_6ghz_regd;
+	bool host_alloc_ml_id;
 
 	u8 num_radio;
 
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index d135b2936378..8091501cf742 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -232,6 +232,8 @@ struct ath12k_hw_params {
 		u32 max_client_dbs;
 		u32 max_client_dbs_sbs;
 	} client;
+
+	bool host_alloc_ml_id;
 };
 
 struct ath12k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 7d0d7d5fbf53..1ae21618afb6 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15382,8 +15382,9 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 	int mac_id, device_id, total_radio, num_hw;
 	struct ath12k_base *ab;
 	struct ath12k_hw *ah;
-	int ret, i, j;
+	bool conf = false;
 	u8 radio_per_hw;
+	int ret, i, j;
 
 	total_radio = 0;
 	for (i = 0; i < ag->num_devices; i++) {
@@ -15423,6 +15424,20 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 			}
 
 			ab = ag->ab[device_id];
+
+			/*
+			 * the assumption is all devices within an ah
+			 * share the same host_alloc_ml_id configuration
+			 */
+			if (j == 0) {
+				conf = ab->hw_params->host_alloc_ml_id;
+			} else if (conf != ab->hw_params->host_alloc_ml_id) {
+				ath12k_warn(ab, "inconsistent ML ID config within ah, device 0 uses %s allocated ID, while device %u doesn't\n",
+					    conf ? "host" : "firmware", device_id);
+				ret = -EINVAL;
+				goto err;
+			}
+
 			pdev_map[j].ab = ab;
 			pdev_map[j].pdev_idx = mac_id;
 			mac_id++;
@@ -15447,6 +15462,7 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 		}
 
 		ah->dev = ab->dev;
+		ah->host_alloc_ml_id = conf;
 
 		ag->ah[i] = ah;
 		ag->num_hw++;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index e5bf9d218104..0c277f51d99c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -439,6 +439,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = true,
 	},
 	{
 		.name = "wcn7850 hw2.0",
@@ -530,6 +532,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = false,
 	},
 	{
 		.name = "qcn9274 hw2.0",
@@ -617,6 +621,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = true,
 	},
 	{
 		.name = "ipq5332 hw1.0",
@@ -697,6 +703,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = true,
 	},
 	{
 		.name = "qcc2072 hw1.0",
@@ -789,6 +797,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = false,
 	},
 	{
 		.name = "ipq5424 hw1.0",
@@ -873,6 +883,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs = 128,
 			.max_client_dbs_sbs = 128,
 		},
+
+		.host_alloc_ml_id = true,
 	},
 };
 

-- 
2.25.1

