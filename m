Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754655;
	b=iB2bXfVY3NK5JI7/fxkxRKXZ8869/Fz5nFtEb9WGOXWYKPhPmmspObLiKXxVc723QRTc
	 PZsxD5iExj3DHq/noU+JSgCnqB8ZHJxXI71sGmD64tfhl1dsTnwVbTGxIX4NoHFQfvYt1
	 cQ6fZ3gwRaSfDETgCrdEqX33qh0YAaKaNB3U0NB6Ii9NiAZ2Gp8fBNlEHoN0rIGKXEZiJ
	 2lT1pfSmEo6b10bsUVguQJihD4jmyBEXQO/A5l00Ul8LGjxaMloe+VBJf6grmbf35Ibjj
	 veINYtZORvp/Yr+JJP87/Wvc8w0uazTxDWkWe1UJpDO+kPRwRQiXCKx8I/c74IO2ZEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754655;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mL14LNWehxCuNae9DlFtHdzgIir7uUJx/MZpih9Df48=;
	b=UVN4ZOlOZotl7ooaWaiyqseztOuo86qCf/xKm//1E52QG7E2ztTMIR83pVyDTq9oFgIE
	 DEUe3EdI2GwE6teA1bPUk1bnpDhGm31v0l9KNDMJP3l4QjqPD/MlJs77UybAZnQ/M5Adf
	 97UR6pMKGKM6xHynOOAN3VPciJQohXKlL214fndHZhgeE/K8GBPtX1B2EsqloTVV5gbeK
	 GG7IlQ9kXcXhJbnAxHWnPqOvLIaIaBjQLcynOe913b5MqbgCV4IFjYKJ00WLWpZ/oiLlJ
	 BFP+dKlLXPUeQuFXqVvuoWeqJT3ykJ5pOBsuqM7YhGfshwSRgMtZ2LU+pCDN4KiEi1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SJgNINCo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IyGF+xvv;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DD606D805
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D92DD606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SJgNINCo;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IyGF+xvv
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RL5U222113
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mL14LNWehxCuNae9DlFtHdzgIir7uUJx/MZpih9Df48=; b=SJgNINCozTDPpQNL
	a9SOujbC0xWVYYR2PXU1t/In1wFnzAu/LXIciLYTVh+kUhpZhq3aQalEjM6pYQCM
	GwD5P5qOwzocTpA6FVey5meSWz58SrQefh8vuh0jBOBxDDdUwNVqY6xIkLlWborv
	1ww1NF4GmyJZbc2qZqBunAGErS1PrGFomcV3KvtmCIDk55/n4aQcpiJNbJbz5GiD
	sPyV3v3jJIZq3Xi9A16vf4e3M7WMmPS1kIS9odnIKx7WqVhe0LUmKga2DQg42Jqj
	ndkNSUhRWi6vN7aO8Rba9MTqMqcfAtQKc90GrDm6ZuSYs/1dATVrgZ2YTKlnnP8E
	HvhDWA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqjubj233-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:53 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36a1e2485fdso261760eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754653; x=1794359453; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mL14LNWehxCuNae9DlFtHdzgIir7uUJx/MZpih9Df48=;
        b=IyGF+xvvP/dzPgdemwVPA7kY4dHzYYC/Y91m6rdhWSeR9ry/bf/p8twuPNs57ikILP
         4lqgbxWWJHiZualEftSeDzFmaUVXb2CdMvXLLG9J764/NrniJv/7BVRGWBM1/XhSGgaL
         Dr8NBudiinrDuMlWpZqldiGNw0gbz4kynj0xc6rq2wUzDVfu57BtsAPN8/W5HOd9/uF6
         8EIe0v/iXUcOg7gaEq+BT2WYIeexzzdFNytcMVHMJB02GoncpLQZ536mnCZW5QctHp2W
         /nubhFTdTp8mlPsPGrF99kU6o3yn0a6JAsqkDk8RmLvXvGE0cKYdZ6S3lXf7x3WWod5V
         7lLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754653; x=1794359453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mL14LNWehxCuNae9DlFtHdzgIir7uUJx/MZpih9Df48=;
        b=xJXqHKBGAgmNzzPSdffuZraXetg20C0CrKIszXc/Iwps97GV3xne2yMgmxat0b2zt8
         obMe8tB1xByb4HVxWMgC75L9nuX1DnaZkcz6pFM3TpjBjvhPRkRaD7w31LAarvdgRHPv
         iYjJuemGgtDbG25mCfGPGTK+FQxmGuONm5xu3TEE9LSI3id7I1FmBoaBzMBLpvZfQ5i4
         TeIJ/pxiFUZPcBzTmZhAZKF5Xnls84BxpVt5ViDT9F3vYoEFzOEpVv1un/j2vg6XTgzN
         gsUr8TF2nA7BoCsslEhKVnLnxl+9fGhqb5r2+7cnJZVULw26eCkfqAnMxWpmbzzOu7k4
         AlEw==
X-Forwarded-Encrypted: i=1; AKwUvBxFMj+AXdBb7RMKdZW+bSKYYItC8EZ2zSIqqlQszF5sr6QNNqEGlKRMWf88r/DxwUrCkYc+YnnOogiQ9kTQdg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9xvjrEvgjJTMmeiOur23OtuPsCE56aysD4jgcMky9/EfZi1TQq
	EixKE2HTArYjgilMfJgt0aLIfqgbQypFnyzyi9lIW1lRF4yhinHgN1tJ6jbIToDmrP2hY6M+D+P
	d/pfjZyIe7iXN9bv56xF0XoZ1u33dpDmyCowODo3Ct6gwnGPjQnG61qtHxDmw/Cais7Wssw==
X-Gm-Gg: AYBFou3TowQe4afeRoSloXkOLtMGlRvAXsj4scO0v3h+FJo87gm5PXt/Wdt7ndTN/7r
	dFBX2I+5labk7gEQ60B6TAsftBsZJUAtJq8KscBsQkuCTPSU5nRDU+Y3YpOx1TY/JWjHXvaWKaw
	2fGO100QvIzEfG98rvvOTOm8zHWDkw/shxy4dJgJ/lv0LyfGQC+h1GvtmjUraA37ySrnfYlCUqM
	KHV6jdHVIpnIrSkLL7NtdHmd6RXvkjGE/y0g9KAMYrhqsmU+vQcfcQXwmGV3/6zasieTKW/EK9f
	D3c+qExSXhisXfV53QXqTzsCWVk/P2DQ7QSkXr8ze+T511kNX7fxgBYP6rLQVwCsBV21M+Xan/J
	KH5oq1rizSnOFCc+Bo80l7zMchf0Nw6FLAwTfe/T1db+/mPV9jNM0KqQHbTRJstDGHgb7PdHd7u
	ZjkW0fdkAIENdwzKHsBAPfc7mKRcnfc+KOY6yr
X-Received: by 2002:a05:7300:4719:b0:368:6f29:f26c with SMTP id 5a478bee46e88-36a4221aa0dmr20176235eec.4.1793754652816;
        Tue, 03 Nov 2026 17:10:52 -0800 (PST)
X-Received: by 2002:a05:7300:4719:b0:368:6f29:f26c with SMTP id 5a478bee46e88-36a4221aa0dmr20176178eec.4.1793754652061;
        Tue, 03 Nov 2026 17:10:52 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:51 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:49 -0800
Subject: [PATCH ath-next v3 06/13] wifi: ath12k: ng: parse 1K REO queue
 statistics
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-reo-cmd-b4-posting-v3-6-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX3NXBsqEavEdr
 HqsPm78bL/muv4G5f3459k8xDK0rLXqErRT5JU7cxH1TtrucgmfTF0iA6FQ+uJ1rc1H3VTrTlxn
 mvQCISZp/dYruZsz48fj7y/QddM/RZ8=
X-Authority-Analysis: v=2.4 cv=JeUpPkKV c=1 sm=1 tr=0 ts=6aea861d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=jlw-gz1d5bKLCbeaqcMA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: 42sGKQPW7aUvomR8mUrhSO5dhhPbL470
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX2ulm0g9s7Tht
 c6bnKIbrgNv2+hYPbgjyGDV2XQIT0UOwY/gvRn4tXcBH2h0946ZN3TtMUSf6HYGyQEJu+3Zi80u
 kIWDFgkxR0GJ0oBFIWD7FnSh506vIfP98SIAPEwYPgwPqsn647Zbt004vqDaJirF5d/BzjxRy9n
 DlZnNbWrSGinvEPev9gDVPJEGnWG5bobRx1n+J2pkxG9xtdH7LzF8umqYgmaifKR18EPwy6MN3D
 lnORbvKbbMPLj/QCROuBAz1WkH7o6I55IFKGcbcVF+bJAGQQAOE0qXLv9okGHBsDmd0sTyYPV9P
 +1VnGFJmBaW7Fitk11imwKSGxc1353zDmjZJgrEzRXHNKDZneE7E/AzJlGgjVMuVYMrLA/TRcuF
 wDbcHlKZwUv1VsmVKjajP3TnzVH8+71dc013WLtxVw8spn0SWYOrcU56BIaLzKQtCQmUOIn3Mzp
 TwpM/rjyZCm2vps2wdA==
X-Proofpoint-ORIG-GUID: 42sGKQPW7aUvomR8mUrhSO5dhhPbL470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

A normal REO queue-statistics status contains the first 288 bits of the
reorder bitmap. For a receive queue with a larger BlockAck window, the
hardware sets a follow-up flag and returns bits 288 through 1023 in a
second status TLV.

Define the 1K queue-statistics status descriptor and decode its 23
additional bitmap words. Extend the common queue status with the PN
encoding, follow-up indication, and wider counters, and store the TLV tag
so a follow-on datapath patch can distinguish both responses for one
command number.

This commit only extends Wi-Fi 8 status representation and parsing. It
does not submit commands or change the Wi-Fi 7 descriptor path.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hal.h            | 15 +++++++++---
 drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h | 10 ++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c   | 30 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h   |  3 +++
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 9c0d1dfac8d3..6534e11a3378 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1173,6 +1173,9 @@ struct hal_reo_status_queue_stats {
 	u16 ssn;
 	u16 curr_idx;
 	u32 pn[4];
+	u8 pn_len;
+	u8 pn_127_48_info;
+	bool to_follow_1k;
 	u32 last_rx_queue_ts;
 	u32 last_rx_dequeue_ts;
 	u32 rx_bitmap[9];
@@ -1186,9 +1189,13 @@ struct hal_reo_status_queue_stats {
 	u32 total_num_processed_byte_cnt;
 	u32 late_rx_mpdu_cnt;
 	u32 reorder_hole_cnt;
-	u8 timeout_cnt;
-	u8 bar_rx_cnt;
-	u8 num_window_2k_jump_cnt;
+	u32 timeout_cnt;
+	u32 bar_rx_cnt;
+	u32 num_window_2k_jump_cnt;
+};
+
+struct hal_reo_status_queue_1k_stats {
+	u32 rx_bitmap[23];
 };
 
 struct hal_reo_status_flush_queue {
@@ -1246,8 +1253,10 @@ struct hal_reo_status_desc_thresh_reached {
 struct hal_reo_status {
 	struct hal_reo_status_header uniform_hdr;
 	u8 loop_cnt;
+	u16 tag;
 	union {
 		struct hal_reo_status_queue_stats queue_stats;
+		struct hal_reo_status_queue_1k_stats queue_1k_stats;
 		struct hal_reo_status_flush_queue flush_queue;
 		struct hal_reo_status_flush_cache flush_cache;
 		struct hal_reo_status_unblock_cache unblock_cache;
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
index 691c9866522f..e2947dd112ce 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
@@ -536,6 +536,15 @@ struct hal_reo_get_queue_stats_status {
 	__le16 info6;
 } __packed;
 
+#define HAL_REO_GET_Q_1K_STATS_STATUS_INFO0_LOOPING_COUNT	GENMASK(15, 12)
+
+struct hal_reo_get_queue_1k_stats_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 rx_bitmap1023_288[23];
+	__le16 rsvd0;
+	__le16 info0;
+} __packed;
+
 /* REO command TLV tags */
 #define HAL_REO_GET_QUEUE_STATS			313
 #define HAL_REO_FLUSH_QUEUE			314
@@ -549,6 +558,7 @@ struct hal_reo_get_queue_stats_status {
 #define HAL_REO_FLUSH_TIMEOUT_LIST_STATUS	338
 #define HAL_REO_DESCRIPTOR_THRESHOLD_REACHED_STATUS	339
 #define HAL_REO_UPDATE_RX_REO_QUEUE		371
+#define HAL_REO_GET_QUEUE_1K_STATS_STATUS	451
 #define HAL_REO_UPDATE_RX_REO_QUEUE_STATUS	204
 
 #define HAL_REO_FLUSH_QUEUE_INFO0_DESC_ADDR_HI		GENMASK(7, 0)
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
index 80c2f1202233..d78c178cc70d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
@@ -470,6 +470,29 @@ ath12k_wifi8_hal_reo_cmd_update_rx_queue(struct hal_tlv_64_hdr *tlv,
 	return le16_to_cpu(desc->cmd.reo_cmd_number);
 }
 
+void ath12k_wifi8_hal_reo_status_queue_1k_stats(struct ath12k_base *ab,
+						struct hal_tlv_64_hdr *tlv,
+						struct hal_reo_status *status)
+{
+	struct hal_reo_get_queue_1k_stats_status *desc =
+		(struct hal_reo_get_queue_1k_stats_status *)tlv->value;
+	u32 *dst = status->u.queue_1k_stats.rx_bitmap;
+	int i;
+
+	status->uniform_hdr.cmd_num = le16_to_cpu(desc->hdr.reo_status_number);
+	status->uniform_hdr.cmd_status =
+		le16_get_bits(desc->hdr.info0,
+			      HAL_REO_STATUS_HDR_INFO0_EXEC_STATUS);
+	status->uniform_hdr.timestamp = le32_to_cpu(desc->hdr.timestamp);
+
+	for (i = 0; i < ARRAY_SIZE(desc->rx_bitmap1023_288); i++)
+		dst[i] = le32_to_cpu(desc->rx_bitmap1023_288[i]);
+
+	status->loop_cnt =
+		le16_get_bits(desc->info0,
+			      HAL_REO_GET_Q_1K_STATS_STATUS_INFO0_LOOPING_COUNT);
+}
+
 static int ath12k_hal_reo_cmd_flush_queue(struct hal_tlv_64_hdr *tlv,
 					  struct ath12k_hal_reo_cmd *cmd)
 {
@@ -596,6 +619,13 @@ void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
 		le32_get_bits(desc->info0, HAL_REO_GET_Q_STATS_STATUS_INFO0_CURRENT_INDEX);
 	status->u.queue_stats.pn[0] = le32_to_cpu(desc->pn_31_0);
 	status->u.queue_stats.pn[1] = le16_to_cpu(desc->pn_47_32);
+	status->u.queue_stats.pn_127_48_info =
+		le16_get_bits(desc->info1, HAL_REO_GET_Q_STATS_STATUS_INFO1_PN_127_48_INFO);
+	status->u.queue_stats.to_follow_1k =
+		le32_get_bits(desc->info5,
+			      HAL_REO_GET_Q_STATS_STATUS_INFO5_GET_Q_1K_SSTAT_FOLLOW);
+	status->u.queue_stats.pn_len =
+		(status->u.queue_stats.pn_127_48_info == 0) ? 6 : 16;
 	status->u.queue_stats.last_rx_queue_ts =
 		le32_to_cpu(desc->last_rx_enqueue_timestamp);
 	status->u.queue_stats.last_rx_dequeue_ts =
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
index d61ca0823b5f..357839c7d9e3 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
@@ -112,6 +112,9 @@ void ath12k_wifi8_hal_reo_hw_setup(struct ath12k_base *ab);
 void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
 					     struct hal_tlv_64_hdr *tlv,
 					     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_status_queue_1k_stats(struct ath12k_base *ab,
+						struct hal_tlv_64_hdr *tlv,
+						struct hal_reo_status *status);
 void ath12k_wifi8_hal_reo_flush_queue_status(struct ath12k_base *ab,
 					     struct hal_tlv_64_hdr *tlv,
 					     struct hal_reo_status *status);

-- 
2.43.0

