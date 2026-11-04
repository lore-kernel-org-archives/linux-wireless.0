Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754651;
	b=aj7ZGJaD/y8s9U8k5sHF+tlU3YMyUv0PjV4w5jw+d8jXio/BUopaNMDROZo7iSUf+CA4
	 jAN2tGnEkZAF4uWRakKuG2Td7roEFNM4CwJy/+CId2enTZdTdjCYCr1IBWbRnp2KH0Qcp
	 NJ9RRPWSm/Rs+WVLEjBWH8T0Mk1b2I2vmgEE5SQ+VX2CMCtvLMDRI1V2fnsslJX7gdhDh
	 HIdFh/JXb9PHuQ/S+aAo43xGu/pSRsP9kMhK3EFR7aN9BXcWK54O8Gy+SisKw9KrTZt9z
	 9YOacunCyj6w0ty3ODZBrY+xFyINpVlEywmmS7xeaxK7JSAm2DoijTuqSPBUBLrfQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754651;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=/HLPSqdPonoZLpjtJ92NjKP9o3jym9B5SLjHmtR8iYE=;
	b=AWcahZiC+8Rc6L6+QDWmih5B0FmuVGlghYN7vOmBTK1ehXXe1zTRgT252bNu33MQuoqC
	 OjOH99lP8ZptbohJQELZQzDyOaFt0Y2QL2cPYK9eYOD4yMQqvjEqUu+FB0sSgFE98A5na
	 8unUkbdc6gAOllCTfZB6fkh5J/zV8V0RDis2Oo5JYYKLdYq0gI5COH/Oq3BCFTWOjO+DI
	 Hrg74j/fUFbw5iicL3Bg8vYBwhwpyyB4bsce+7tKFSj0eoMBE9umlOkANQdYI9Epr8gcS
	 ROgOWOkOxbW26GYTsSTvvZ8lCMUMn823fQFnKFNtsqR388oGtyQD57b3Be76NzTZGsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h5VmK670;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kcChGI9r;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7076606A338
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7076606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h5VmK670;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kcChGI9r
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RCvo3335229
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/HLPSqdPonoZLpjtJ92NjKP9o3jym9B5SLjHmtR8iYE=; b=h5VmK670wLpQh8EC
	SEWVbC0UpDtVuI5Z7Uv53Cv0aWGz5bacr8LsyONBuJXNZSB7DjLomBLHAUgLY5QF
	XT/0MVlsKPh/fkMyWEtOZKS5fLj+4SKP/kUr3dcz1kNdlFKlEkwmuuti6zTcFZ+S
	2/z7faaPxed/pIhH5JBhkGk6lnKAGAbkqoqUd54brtm0pMRVoAPJTDl4KDngQW2l
	NhW7ryxmxICT2I8CJIXaDuAlw4/kTg2l1aEgOMC89G0rg0EdcphlM1aXu4/VAFTj
	lomp9yu3odcLH3DwJPrcbZpPZIZhKuGJWc+jFjJ4AuthBKhYyhC7lBtq21rrLvJK
	Kvvqig==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqmjbsf95-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:49 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so283648eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754648; x=1794359448; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/HLPSqdPonoZLpjtJ92NjKP9o3jym9B5SLjHmtR8iYE=;
        b=kcChGI9r5IfcSDaymjlWV2dnj4SvwqQyjs3d8GRJ/9QU5zt3CmbG6TpRhGKw630jAS
         A55mhBPZmeb0w8EQzjJy8J1bIq/Yd4Q0oPgvRSZetzq9/BnRzWLsVHWwiKhJDWwt0kM0
         KERdoYAesi2Q7Mae+U12CcTi5AO5kdnJ9SoyXLSapY+v4GPt5ZpNkOqGqTNTjbl4hMNX
         Y/MK4A9Hq+h87Or27F8K6xoi3P1/gSzv/NXIx3WUN6wH2D9u661MvIHUqlj5kFIG+klM
         ZoDCRMd8f+gSVmnKeMwHO6AbWGUrGM/yiKXTQSxdNNwIYdW3ljVL9i2G9ooZwerNlE0d
         7GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754648; x=1794359448;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/HLPSqdPonoZLpjtJ92NjKP9o3jym9B5SLjHmtR8iYE=;
        b=TjGzzonb3yX9nfa8UUNBEYfUlnmKTrD+p5TBb2NihlVKx1ydPm4X82n8vwO0rN8U1w
         XvTKWEFM3O6Apw3crYPxxq9WDw/mULLbSkOe1D+VYuTrefSTJbX/9XygVwevfXBj4bWQ
         Iw4lOng/wMWl4XB2+OWPVlD1hmySI+rIv7oCb2/qYEEKM+Rj7qWBLbyyA1H2TXNKcL8c
         bUABcrZ8AU0/xN0OCg93OxcWXFuEbZH1WincL4QWzmPraduHqvA/oiV8uGi4HgrVj++l
         52fHWL2iHWDEsq417krqmMyJC3X0Bq+erV6Ll3qi8yrXcLJHSXtBBf8wB/J7PkjrAwlU
         T/7g==
X-Forwarded-Encrypted: i=1; AKwUvByyd7VXr610oegxVPORmJw6aGZV4gbkfAWj2pRIOQrNF5d2LcGJH1Ea8RI3EgQWPcyrS6qQCfsxMelStVRvcQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8NMXjFYWxAueCwf2GENZiGYXMd4TACQb9sNKvf0b5+Q8Pljsq8
	DgAZyh4Qkkll6leQoI0oh2E3DOPyEUhdUiDZgJ4aeh98OdQP81ygoMfxHlH5vnMhI+eliTcF1M+
	0kFBfHz2VLJLytqKW1Iv3A5ydhaYq92MXQnvjbIRs7IV3ln1PWpVu8Xau3sp9tAG7gwaHvQ==
X-Gm-Gg: AYBFou2Et40jYzLFFrBpISATClqOFmEXLT52HzRfhrijthHQxAkKOYwdosViCuQEWVN
	8nQMeJ03OkORCURuqqqmbm+kcIzqN66DeKNuRQJ8Ap2FHIG8Hi55mxPGAqlaN8NhzO4OxAMSV3L
	1gsDEmGhaleLluanL46HHzZdQgRWA2mIN531Ctk2jwzFQ/Of1yP0yQjiHDtjvYXoxE9AuqlcO0G
	gYKg1eT9vzPDNLkQVOSepKyFby4/t7Au5xaKCXJqW0LwuD35MU9l2dG0i+RzT/Ev8fM7t5k9/xU
	HalqZVhhMSuMTrIUkcLA9FFr1fWYusMbLgycK9Ddbd15yvzYEQiEh4HCswZNN7+2CVLu1krBozS
	NjbgapebhvLuYskHR3rcyqnlgA0kkwiW7NNC4I9aEsT1e16nL6Pd6LfDlH3jKjFGNLbdDKPe9Aq
	apH21C/8bT+5h+t327fjaUlmsOJZAkf4XsXzLW
X-Received: by 2002:a05:7300:f281:b0:369:f64e:7feb with SMTP id 5a478bee46e88-36a4220128dmr21909637eec.2.1793754647883;
        Tue, 03 Nov 2026 17:10:47 -0800 (PST)
X-Received: by 2002:a05:7300:f281:b0:369:f64e:7feb with SMTP id 5a478bee46e88-36a4220128dmr21909574eec.2.1793754646889;
        Tue, 03 Nov 2026 17:10:46 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:46 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:44 -0800
Subject: [PATCH ath-next v3 01/13] wifi: ath12k: ng: add REO command and
 status support
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-1-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-GUID: EK7K5hH112PznPp78ARBRaTnLRQcqvyn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX7tNPZmIPoaK3
 oKOGFSicv46l3VdTg8Go4ROkKatTMMAHUcPtkP+avYA7nygrWhbHA30bnd6+tR7v4W8WYetUZrU
 qyd4+u+otYNwfXr1oSxE7R3lPMOg7p5AN4DTLvo0RhaVlYvnQYFcpGiIrOd5KuPmCR0sRV79ECM
 6k15Y8fVHTATSeqZY1G//tHO5L5asNTMPdjHIVRxJdDn3SDcuL1/Vg6C6+lpiA/P6bGdjYtW3Xj
 HLLKFJ4EFMoJVoYcMscKDPHfMSlKY0gLtAvQy3jXyE6nYusMLylStFjtu2m7lMxUD81A80WtubT
 Ez9bft2AN5A0zxcUgXpoUPRzE5B+1EIfYtoiaRNHuJ8YXehX0pscJwkN5RENC9hupZ4bh0E5Fxn
 n9hS6hk4gFoVS4j/Enf/fd5C08UsWbO/UOfA8/FXkCi31EpXmJ3VB8YHW9f2Ycv2275qXjso/ql
 +R3G3OH+NpKqn0hWOYA==
X-Proofpoint-ORIG-GUID: EK7K5hH112PznPp78ARBRaTnLRQcqvyn
X-Authority-Analysis: v=2.4 cv=NMhAaE6g c=1 sm=1 tr=0 ts=6aea8619 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=kO-QZii637Rb70QJV90A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX1VH3zbxNqfSf
 NnS6h5YLo2b5m6d2ZdirP397jENAQW8eVWA8r8PSbfQiKIz1CSb8/pc8xZ4Ub4S3NHdLAzSjJ15
 d6KuzqSHCNzlbHrOGRuZXnU3S45Hhc4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040004

The Wi-Fi 8 datapath can initialize the REO command ring, but it lacks
the command encoders and status decoders needed by datapath clients to
inspect and update RX reorder queues.

Add descriptor definitions and HAL helpers for queue statistics, queue
and cache flush, cache unblock, timeout-list flush, descriptor-threshold
status, and RX queue update commands. Keep update selector bits separate
from their programmed values, use the corrected hardware field layout
for queue updates, and request queue writeback to DDR after updates.

Add the ASE cache invalidation command encoder as part of the same HAL
command support because later queue-address cache maintenance uses that
ring format on Wi-Fi 8.

Decode the corresponding status TLVs into one software status container.
This commit adds HAL primitives only; it does not submit commands or
service the REO status ring.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hal.h            |   1 +
 drivers/net/wireless/ath/ath12k/wifi8/hal.c      |   3 +-
 drivers/net/wireless/ath/ath12k/wifi8/hal.h      |  87 ++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h | 269 +++++++++--
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c   | 576 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h   |  75 ++-
 drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h   |   9 +
 7 files changed, 977 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 3a8e26738270..f175b5361080 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1138,6 +1138,7 @@ struct ath12k_hal_reo_cmd {
 	u8 blocking_idx;
 	u16 ba_window_size;
 	u8 pn_size;
+	u8 pn_127_48_info;
 };
 
 enum hal_pn_type {
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal.c b/drivers/net/wireless/ath/ath12k/wifi8/hal.c
index 1aa62c669cb2..036c04cbbf16 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal.c
@@ -584,8 +584,7 @@ void ath12k_wifi8_hal_reo_init_cmd_ring(struct ath12k_base *ab,
 	for (i = 0; i < params.num_entries; i++) {
 		tlv = (struct hal_tlv_64_hdr *)entry;
 		desc = (struct hal_reo_get_queue_stats *)tlv->value;
-		desc->cmd.info0 = le32_encode_bits(cmd_num++,
-						   HAL_REO_CMD_HDR_INFO0_CMD_NUMBER);
+		desc->cmd.reo_cmd_number = cpu_to_le16(cmd_num++);
 		entry += entry_size;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal.h b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
index 6fd99e52f1a9..d30ee1242122 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
@@ -896,6 +896,93 @@ enum ath12k_hal_tx_pkt_ctrl_config {
 	HAL_TX_PACKET_CONTROL_CONFIG_MEC_NOTIFY_TX_EXCEPTION,
 };
 
+struct hal_reo_status_queue_stats {
+	u16 ssn;
+	u16 curr_idx;
+	u32 pn[4];
+	u32 last_rx_queue_ts;
+	u32 last_rx_dequeue_ts;
+	u32 rx_bitmap[9];
+	u32 curr_mpdu_cnt;
+	u32 curr_msdu_cnt;
+	u16 fwd_due_to_bar_cnt;
+	u16 dup_cnt;
+	u32 frames_in_order_cnt;
+	u32 num_mpdu_processed_cnt;
+	u32 num_msdu_processed_cnt;
+	u32 total_num_processed_byte_cnt;
+	u32 late_rx_mpdu_cnt;
+	u32 reorder_hole_cnt;
+	u8 timeout_cnt;
+	u8 bar_rx_cnt;
+	u8 num_window_2k_jump_cnt;
+};
+
+struct hal_reo_status_flush_queue {
+	bool err_detected;
+};
+
+enum hal_reo_status_flush_cache_err_code {
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_SUCCESS,
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_IN_USE,
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_NOT_FOUND,
+};
+
+struct hal_reo_status_flush_cache {
+	bool err_detected;
+	enum hal_reo_status_flush_cache_err_code err_code;
+	bool cache_controller_flush_status_hit;
+	u8 cache_controller_flush_status_desc_type;
+	u8 cache_controller_flush_status_client_id;
+	u8 cache_controller_flush_status_err;
+	u8 cache_controller_flush_status_cnt;
+};
+
+enum hal_reo_status_unblock_cache_type {
+	HAL_REO_STATUS_UNBLOCK_BLOCKING_RESOURCE,
+	HAL_REO_STATUS_UNBLOCK_ENTIRE_CACHE_USAGE,
+};
+
+struct hal_reo_status_unblock_cache {
+	bool err_detected;
+	enum hal_reo_status_unblock_cache_type unblock_type;
+};
+
+struct hal_reo_status_flush_timeout_list {
+	bool err_detected;
+	bool list_empty;
+	u16 release_desc_cnt;
+	u16 fwd_buf_cnt;
+};
+
+enum hal_reo_threshold_idx {
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER0,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER1,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER2,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER_SUM,
+};
+
+struct hal_reo_status_desc_thresh_reached {
+	enum hal_reo_threshold_idx threshold_idx;
+	u32 link_desc_counter0;
+	u32 link_desc_counter1;
+	u32 link_desc_counter2;
+	u32 link_desc_counter_sum;
+};
+
+struct hal_reo_status {
+	struct hal_reo_status_header uniform_hdr;
+	u8 loop_cnt;
+	union {
+		struct hal_reo_status_queue_stats queue_stats;
+		struct hal_reo_status_flush_queue flush_queue;
+		struct hal_reo_status_flush_cache flush_cache;
+		struct hal_reo_status_unblock_cache unblock_cache;
+		struct hal_reo_status_flush_timeout_list timeout_list;
+		struct hal_reo_status_desc_thresh_reached desc_thresh_reached;
+	} u;
+};
+
 void ath12k_wifi8_hal_init(struct ath12k_base *ab);
 void ath12k_wifi8_hal_ce_dst_setup(struct ath12k_base *ab,
 				   struct hal_srng *srng, int ring_num);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
index 05ce2dbd39e5..691c9866522f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
@@ -413,18 +413,18 @@ struct hal_reo_entrance_ring {
 	__le32 info4;
 } __packed;
 
-#define HAL_REO_CMD_HDR_INFO0_CMD_NUMBER	GENMASK(15, 0)
-#define HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED	BIT(16)
+#define HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED	BIT(0)
 
 struct hal_reo_cmd_hdr {
-	__le32 info0;
+	__le16 reo_cmd_number;
+	__le16 info0;
 } __packed;
 
-#define HAL_REO_STATUS_HDR_INFO0_STATUS_NUM	GENMASK(15, 0)
-#define HAL_REO_STATUS_HDR_INFO0_EXEC_STATUS	GENMASK(27, 26)
+#define HAL_REO_STATUS_HDR_INFO0_EXEC_STATUS	GENMASK(11, 10)
 
 struct hal_reo_status_hdr {
-	__le32 info0;
+	__le16 reo_status_number;
+	__le16 info0;
 	__le32 timestamp;
 } __packed;
 
@@ -453,9 +453,9 @@ struct hal_reo_status_hdr {
 struct hal_reo_get_queue_stats {
 	struct hal_reo_cmd_hdr cmd;
 	__le32 queue_addr_lo;
-	__le32 info0;
-	__le32 rsvd0[6];
-	__le32 tlv64_pad;
+	__le16 info0;
+	__le16 rsvd0;
+	__le32 rsvd1[7];
 } __packed;
 
 /* hal_reo_get_queue_stats
@@ -494,17 +494,17 @@ struct hal_reo_get_queue_stats {
 
 #define HAL_REO_GET_Q_STATS_STATUS_INFO1_PN_127_48_INFO		GENMASK(1, 0)
 
-#define HAL_REO_GET_Q_STATS_STATUS_INFO3_CURRENT_MPDU_COUNT	GENMASK(6, 0)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO3_CURRENT_MSDU_COUNT	GENMASK(31, 7)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO4_WINDOW_JUMP_2K		GENMASK(3, 0)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO4_TIMEOUT_COUNT		GENMASK(9, 4)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO4_FWD_DUE_TO_BAR_COUNT	GENMASK(15, 10)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO5_FRAMES_IN_ORDER_COUNT	GENMASK(23, 0)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO5_BAR_RECEIVED_COUNT	GENMASK(31, 24)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO6_LATE_RCV_MPDU_COUNT	GENMASK(11, 0)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO6_HOLE_COUNT		GENMASK(27, 12)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO6_GET_Q_1K_SSTAT_FOLLOW	BIT(28)
-#define HAL_REO_GET_Q_STATS_STATUS_INFO7_LOOPING_COUNT		GENMASK(15, 12)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO2_CURRENT_MPDU_COUNT	GENMASK(6, 0)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO2_CURRENT_MSDU_COUNT	GENMASK(31, 7)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO3_WINDOW_JUMP_2K		GENMASK(3, 0)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO3_TIMEOUT_COUNT		GENMASK(9, 4)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO3_FWD_DUE_TO_BAR_COUNT	GENMASK(15, 10)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO4_FRAMES_IN_ORDER_COUNT	GENMASK(23, 0)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO4_BAR_RECEIVED_COUNT	GENMASK(31, 24)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO5_LATE_RCV_MPDU_COUNT	GENMASK(11, 0)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO5_HOLE_COUNT		GENMASK(27, 12)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO5_GET_Q_1K_SSTAT_FOLLOW	BIT(28)
+#define HAL_REO_GET_Q_STATS_STATUS_INFO6_LOOPING_COUNT		GENMASK(15, 12)
 
 struct hal_reo_get_queue_stats_status {
 	struct hal_reo_status_hdr hdr;
@@ -512,8 +512,7 @@ struct hal_reo_get_queue_stats_status {
 	__le32 pn_31_0;
 	__le16 pn_47_32;
 	__le16 info1;
-	__le32 info2;
-	__le32 rsvd0;
+	__le32 rsvd0[2];
 	__le32 last_rx_enqueue_timestamp;
 	__le32 last_rx_dequeue_timestamp;
 	__le32 rx_bitmap_31_0;
@@ -525,16 +524,205 @@ struct hal_reo_get_queue_stats_status {
 	__le32 rx_bitmap_223_192;
 	__le32 rx_bitmap_255_224;
 	__le32 rx_bitmap_287_256;
-	__le32 info3;
-	__le16 info4;
+	__le32 info2;
+	__le16 info3;
 	__le16 duplicate_count;
-	__le32 info5;
+	__le32 info4;
 	__le32 mpdu_frames_processed_count;
 	__le32 msdu_frames_processed_count;
 	__le32 total_processed_byte_count;
-	__le32 info6;
+	__le32 info5;
 	__le16 aging_drop_mpdu_count;
-	__le16 info7;
+	__le16 info6;
+} __packed;
+
+/* REO command TLV tags */
+#define HAL_REO_GET_QUEUE_STATS			313
+#define HAL_REO_FLUSH_QUEUE			314
+#define HAL_REO_FLUSH_CACHE			315
+#define HAL_REO_UNBLOCK_CACHE			316
+#define HAL_REO_GET_QUEUE_STATS_STATUS		317
+#define HAL_REO_FLUSH_QUEUE_STATUS		318
+#define HAL_REO_FLUSH_CACHE_STATUS		319
+#define HAL_REO_UNBLOCK_CACHE_STATUS		320
+#define HAL_REO_FLUSH_TIMEOUT_LIST		337
+#define HAL_REO_FLUSH_TIMEOUT_LIST_STATUS	338
+#define HAL_REO_DESCRIPTOR_THRESHOLD_REACHED_STATUS	339
+#define HAL_REO_UPDATE_RX_REO_QUEUE		371
+#define HAL_REO_UPDATE_RX_REO_QUEUE_STATUS	204
+
+#define HAL_REO_FLUSH_QUEUE_INFO0_DESC_ADDR_HI		GENMASK(7, 0)
+struct hal_reo_flush_queue {
+	struct hal_reo_cmd_hdr cmd;
+	__le32 desc_addr_lo;
+	__le16 info0;
+	__le16 rsvd0;
+	__le32 rsvd1[7];
+} __packed;
+
+#define HAL_REO_FLUSH_CACHE_INFO0_CACHE_ADDR_HI		GENMASK(7, 0)
+#define HAL_REO_FLUSH_CACHE_INFO0_FWD_ALL_MPDUS		BIT(8)
+#define HAL_REO_FLUSH_CACHE_INFO0_BLOCK_RESRC_IDX	GENMASK(11, 10)
+#define HAL_REO_FLUSH_CACHE_INFO0_FLUSH_WO_INVALIDATE	BIT(12)
+#define HAL_REO_FLUSH_CACHE_INFO0_BLOCK_CACHE_USAGE	BIT(13)
+#define HAL_REO_FLUSH_CACHE_INFO0_FLUSH_ALL		BIT(14)
+#define HAL_REO_FLUSH_CACHE_INFO0_FLUSH_QUEUE_1K_DESC	BIT(15)
+
+struct hal_reo_flush_cache {
+	struct hal_reo_cmd_hdr cmd;
+	__le32 cache_addr_lo;
+	__le16 info0;
+	__le16 rsvd0;
+	__le32 rsvd1[7];
+} __packed;
+
+enum hal_rx_reo_queue_pn_size {
+	HAL_RX_REO_QUEUE_PN_SIZE_24,
+	HAL_RX_REO_QUEUE_PN_SIZE_48,
+	HAL_RX_REO_QUEUE_PN_SIZE_128,
+};
+
+#define HAL_REO_UPD_RX_QUEUE_INFO0_QUEUE_ADDR_HI		GENMASK(7, 0)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_RX_QUEUE_NUM		BIT(8)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_VLD			BIT(9)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_ASSOC_LNK_DESC_CNT	BIT(10)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_DIS_DUP_DETECTION	BIT(11)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SOFT_REORDER_EN		BIT(12)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_AC			BIT(13)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_BAR			BIT(14)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_RETRY			BIT(15)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_CHECK_2K_MODE		BIT(16)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_OOR_MODE			BIT(17)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_BA_WINDOW_SIZE		BIT(18)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_CHECK			BIT(19)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_EVEN_PN			BIT(20)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_UNEVEN_PN		BIT(21)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_HANDLE_ENABLE		BIT(22)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_SIZE			BIT(23)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_IGNORE_AMPDU_FLG		BIT(24)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SVLD			BIT(25)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SSN			BIT(26)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SEQ_2K_ERR		BIT(27)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_ERR			BIT(28)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_VALID			BIT(29)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN			BIT(30)
+#define HAL_REO_UPD_RX_QUEUE_INFO0_CLR_STATS_COUNTERS		BIT(31)
+
+#define HAL_REO_UPD_RX_QUEUE_INFO1_VLD				BIT(0)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_ASSOC_LNK_DESC_COUNTER	GENMASK(2, 1)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_DIS_DUP_DETECTION		BIT(3)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_SOFT_REORDER_EN		BIT(4)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_LINK_LIST_TIMER_ID		GENMASK(8, 5)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_BAR				BIT(9)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_RETRY			BIT(10)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_CHECK_2K_MODE		BIT(11)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_OOR_MODE			BIT(12)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_PN_CHECK			BIT(13)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_EVEN_PN			BIT(14)
+#define HAL_REO_UPD_RX_QUEUE_INFO1_UNEVEN_PN			BIT(15)
+
+#define HAL_REO_UPD_RX_QUEUE_INFO2_PN_HANDLE_ENABLE		BIT(0)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_IGNORE_AMPDU_FLG		BIT(1)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_BA_WINDOW_SIZE		GENMASK(11, 2)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_PN_SIZE			GENMASK(13, 12)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_SVLD				BIT(14)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_SSN				GENMASK(26, 15)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_SEQ_2K_ERR			BIT(27)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_PN_ERR			BIT(28)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_PN_VALID			BIT(29)
+#define HAL_REO_UPD_RX_QUEUE_INFO2_FLUSH_FROM_CACHE		BIT(30)
+
+#define HAL_REO_UPD_RX_QUEUE_INFO3_PN_127_48_INFO		GENMASK(1, 0)
+
+struct hal_reo_update_rx_queue {
+	struct hal_reo_cmd_hdr cmd;
+	__le32 queue_addr_lo;
+	__le32 info0;
+	__le16 receive_queue_number;
+	__le16 info1;
+	__le32 info2;
+	__le32 pn_31_0;
+	__le16 pn_47_32;
+	__le16 info3;
+	__le32 rsvd0[3];
+} __packed;
+
+#define HAL_REO_UNBLOCK_CACHE_INFO0_UNBLK_CACHE		BIT(0)
+
+struct hal_reo_unblock_cache {
+	struct hal_reo_cmd_hdr cmd;
+	__le16 info0;
+	__le16 rsvd0;
+	__le32 rsvd1[8];
+} __packed;
+
+#define HAL_REO_STATUS_LOOP_CNT			GENMASK(31, 28)
+
+#define HAL_REO_FLUSH_QUEUE_INFO0_ERR_DETECTED	BIT(0)
+#define HAL_REO_FLUSH_QUEUE_INFO0_RSVD		GENMASK(31, 1)
+#define HAL_REO_FLUSH_QUEUE_INFO1_RSVD		GENMASK(27, 0)
+
+struct hal_reo_flush_queue_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 info0;
+	__le32 rsvd0[21];
+	__le32 info1;
+} __packed;
+
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_IS_ERR			BIT(0)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_BLOCK_ERR_CODE		GENMASK(2, 1)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_STATUS_HIT	BIT(8)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_DESC_TYPE	GENMASK(11, 9)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_CLIENT_ID	GENMASK(15, 12)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_ERR		GENMASK(17, 16)
+#define HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_COUNT		GENMASK(25, 18)
+
+struct hal_reo_flush_cache_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 info0;
+	__le32 rsvd0[21];
+	__le32 info1;
+} __packed;
+
+#define HAL_REO_UNBLOCK_CACHE_STATUS_INFO0_IS_ERR	BIT(0)
+#define HAL_REO_UNBLOCK_CACHE_STATUS_INFO0_TYPE		BIT(1)
+
+struct hal_reo_unblock_cache_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 info0;
+	__le32 rsvd0[21];
+	__le32 info1;
+} __packed;
+
+#define HAL_REO_FLUSH_TIMEOUT_STATUS_INFO0_IS_ERR		BIT(0)
+#define HAL_REO_FLUSH_TIMEOUT_STATUS_INFO0_LIST_EMPTY		BIT(1)
+
+#define HAL_REO_FLUSH_TIMEOUT_STATUS_INFO1_REL_DESC_COUNT	GENMASK(15, 0)
+#define HAL_REO_FLUSH_TIMEOUT_STATUS_INFO1_FWD_BUF_COUNT	GENMASK(31, 16)
+
+struct hal_reo_flush_timeout_list_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 info0;
+	__le32 info1;
+	__le32 rsvd0[20];
+	__le32 info2;
+} __packed;
+
+#define HAL_REO_DESC_THRESH_STATUS_INFO0_THRESH_INDEX		GENMASK(1, 0)
+#define HAL_REO_DESC_THRESH_STATUS_INFO1_LINK_DESC_COUNTER0	GENMASK(23, 0)
+#define HAL_REO_DESC_THRESH_STATUS_INFO2_LINK_DESC_COUNTER1	GENMASK(23, 0)
+#define HAL_REO_DESC_THRESH_STATUS_INFO3_LINK_DESC_COUNTER2	GENMASK(23, 0)
+#define HAL_REO_DESC_THRESH_STATUS_INFO4_LINK_DESC_COUNTER_SUM	GENMASK(25, 0)
+
+struct hal_reo_desc_thresh_reached_status {
+	struct hal_reo_status_hdr hdr;
+	__le32 info0;
+	__le32 info1;
+	__le32 info2;
+	__le32 info3;
+	__le32 info4;
+	__le32 rsvd0[17];
+	__le32 info5;
 } __packed;
 
 #define HAL_TCL_DATA_CMD_INFO0_BUF_OR_EXT_DESC_TYPE		BIT(1)
@@ -683,6 +871,33 @@ struct hal_tqm_sync_cmd_status {
 	__le32 info20;
 };
 
+#define HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_0	BIT(0)
+#define HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_1	BIT(1)
+#define HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_2	BIT(2)
+#define HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_3	BIT(3)
+#define HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_4	BIT(4)
+
+#define HAL_ASE_CMD_RING_INFO1_MAC_ADDR_31_0	GENMASK(31, 0)
+#define HAL_ASE_CMD_RING_INFO2_MAC_ADDR_47_32	GENMASK(15, 0)
+#define HAL_ASE_CMD_RING_INFO2_IS_MCAST		BIT(16)
+#define HAL_ASE_CMD_RING_INFO2_IS_MEC		BIT(17)
+#define HAL_ASE_CMD_RING_INFO2_AD1_MATCH	BIT(18)
+#define HAL_ASE_CMD_RING_INFO2_LINK_ID		GENMASK(21, 19)
+#define HAL_ASE_CMD_RING_INFO2_GSE_CTRL		GENMASK(25, 22)
+#define HAL_ASE_CMD_RING_INFO2_SEARCH_INDEX_EN	BIT(26)
+#define HAL_ASE_CMD_RING_INFO2_CACHE_SET_NUM	GENMASK(31, 27)
+#define HAL_ASE_CMD_RING_CMD_METADATA_31_0	GENMASK(31, 0)
+#define HAL_ASE_CMD_RING_INFO3_SEARCH_INDEX	GENMASK(19, 0)
+
+struct hal_ase_cmd {
+	__le32 info0;
+	__le32 info1;
+	__le32 info2;
+	__le32 cmd_meta_data_31_0;
+	__le32 rsvd[3];
+	__le32 info3;
+} __packed;
+
 #define HAL_TCL_EXIT_BASE_INFO0_BUF_OR_EXT_DESC_TYPE		BIT(0)
 #define HAL_TCL_EXIT_BASE_INFO0_ENCAP_TYPE			GENMASK(2, 1)
 #define HAL_TCL_EXIT_BASE_INFO0_TID				GENMASK(14, 11)
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
index c75fdd22139a..80c2f1202233 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
@@ -202,3 +202,579 @@ void ath12k_wifi8_hal_reo_hw_setup(struct ath12k_base *ab)
 	ath12k_hif_write32(ab, reo_base + HAL_REO1_RXDMA_ERROR_DESTINATION_MAPPING_AP_IX3,
 			   val);
 }
+
+int
+ath12k_wifi8_hal_invalidate_rx_cache_cmd_send(struct ath12k_base *ab,
+					      struct hal_srng *srng,
+					      struct ath12k_hal_rx_cmd_ring_param *param)
+{
+	struct hal_ase_cmd *ase_cmd;
+	int ret = 0;
+
+	spin_lock_bh(&srng->lock);
+
+	ath12k_hal_srng_access_begin(ab, srng);
+	ase_cmd = ath12k_hal_srng_src_get_next_entry(ab, srng);
+	if (!ase_cmd) {
+		ret = -ENOBUFS;
+		goto out;
+	}
+	memset(ase_cmd, 0x0, sizeof(*ase_cmd));
+
+	ase_cmd->info0 =
+		le32_encode_bits(!!(param->hw_link_bitmap & BIT(0)),
+				 HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_0) |
+		le32_encode_bits(!!(param->hw_link_bitmap & BIT(1)),
+				 HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_1) |
+		le32_encode_bits(!!(param->hw_link_bitmap & BIT(2)),
+				 HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_2) |
+		le32_encode_bits(!!(param->hw_link_bitmap & BIT(3)),
+				 HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_3) |
+		le32_encode_bits(!!(param->hw_link_bitmap & BIT(4)),
+				 HAL_ASE_CMD_RING_INFO0_CMD_TO_CHIP_4);
+	ase_cmd->info1 = le32_encode_bits(param->mac_addr_31_0,
+					  HAL_ASE_CMD_RING_INFO1_MAC_ADDR_31_0);
+	ase_cmd->info2 = le32_encode_bits(param->mac_addr_47_32,
+					  HAL_ASE_CMD_RING_INFO2_MAC_ADDR_47_32) |
+			 le32_encode_bits(param->is_mcast,
+					  HAL_ASE_CMD_RING_INFO2_IS_MCAST) |
+			 le32_encode_bits(param->is_mec,
+					  HAL_ASE_CMD_RING_INFO2_IS_MEC) |
+			 le32_encode_bits(param->ad1_match,
+					  HAL_ASE_CMD_RING_INFO2_AD1_MATCH) |
+			 le32_encode_bits(param->link_id,
+					  HAL_ASE_CMD_RING_INFO2_LINK_ID) |
+			 le32_encode_bits(param->cmd_num,
+					  HAL_ASE_CMD_RING_INFO2_GSE_CTRL);
+	ase_cmd->cmd_meta_data_31_0 = cpu_to_le32(param->meta_data_0);
+out:
+	ath12k_hal_srng_access_end(ab, srng);
+	spin_unlock_bh(&srng->lock);
+
+	return ret;
+}
+
+static int ath12k_wifi8_hal_reo_cmd_queue_stats(struct hal_tlv_64_hdr *tlv,
+						struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_reo_get_queue_stats *desc;
+
+	tlv->tl = le64_encode_bits(HAL_REO_GET_QUEUE_STATS, HAL_TLV_HDR_TAG) |
+		  le64_encode_bits(sizeof(*desc), HAL_TLV_HDR_LEN);
+
+	desc = (struct hal_reo_get_queue_stats *)tlv->value;
+	memset_startat(desc, 0, queue_addr_lo);
+
+	desc->cmd.info0 &= ~cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
+		desc->cmd.info0 |= cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	desc->queue_addr_lo = cpu_to_le32(cmd->addr_lo);
+	desc->info0 = le16_encode_bits(cmd->addr_hi,
+				       HAL_REO_GET_QUEUE_STATS_INFO0_QUEUE_ADDR_HI);
+	if (cmd->flag & HAL_REO_CMD_FLG_STATS_CLEAR)
+		desc->info0 |= cpu_to_le16(HAL_REO_GET_QUEUE_STATS_INFO0_CLEAR_STATS);
+
+	return le16_to_cpu(desc->cmd.reo_cmd_number);
+}
+
+static int ath12k_wifi8_hal_reo_cmd_flush_cache(struct ath12k_hal *hal,
+						struct hal_tlv_64_hdr *tlv,
+						struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_reo_flush_cache *desc;
+	u8 avail_slot = ffz(hal->avail_blk_resource);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_BLOCK_LATER) {
+		if (avail_slot >= HAL_MAX_AVAIL_BLK_RES)
+			return -ENOSPC;
+
+		hal->current_blk_index = avail_slot;
+	}
+
+	tlv->tl = le64_encode_bits(HAL_REO_FLUSH_CACHE, HAL_TLV_HDR_TAG) |
+		  le64_encode_bits(sizeof(*desc), HAL_TLV_HDR_LEN);
+
+	desc = (struct hal_reo_flush_cache *)tlv->value;
+	memset_startat(desc, 0, cache_addr_lo);
+
+	desc->cmd.info0 &= ~cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
+		desc->cmd.info0 |= cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	desc->cache_addr_lo = cpu_to_le32(cmd->addr_lo);
+	desc->info0 = le16_encode_bits(cmd->addr_hi,
+				       HAL_REO_FLUSH_CACHE_INFO0_CACHE_ADDR_HI);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_FWD_ALL_MPDUS)
+		desc->info0 |= cpu_to_le16(HAL_REO_FLUSH_CACHE_INFO0_FWD_ALL_MPDUS);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_BLOCK_LATER) {
+		desc->info0 |= cpu_to_le16(HAL_REO_FLUSH_CACHE_INFO0_BLOCK_CACHE_USAGE);
+		desc->info0 |=
+			le16_encode_bits(avail_slot,
+					 HAL_REO_FLUSH_CACHE_INFO0_BLOCK_RESRC_IDX);
+	}
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_NO_INVAL)
+		desc->info0 |= cpu_to_le16(HAL_REO_FLUSH_CACHE_INFO0_FLUSH_WO_INVALIDATE);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_ALL)
+		desc->info0 |= cpu_to_le16(HAL_REO_FLUSH_CACHE_INFO0_FLUSH_ALL);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC)
+		desc->info0 |= cpu_to_le16(HAL_REO_FLUSH_CACHE_INFO0_FLUSH_QUEUE_1K_DESC);
+
+	return le16_to_cpu(desc->cmd.reo_cmd_number);
+}
+
+static int
+ath12k_wifi8_hal_reo_cmd_update_rx_queue(struct hal_tlv_64_hdr *tlv,
+					 struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_reo_update_rx_queue *desc;
+
+	tlv->tl = le64_encode_bits(HAL_REO_UPDATE_RX_REO_QUEUE, HAL_TLV_HDR_TAG) |
+		  le64_encode_bits(sizeof(*desc), HAL_TLV_HDR_LEN);
+
+	desc = (struct hal_reo_update_rx_queue *)tlv->value;
+	memset_startat(desc, 0, queue_addr_lo);
+
+	desc->cmd.info0 &= ~cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
+		desc->cmd.info0 |= cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	desc->queue_addr_lo = cpu_to_le32(cmd->addr_lo);
+	desc->info0 =
+		le32_encode_bits(cmd->addr_hi,
+				 HAL_REO_UPD_RX_QUEUE_INFO0_QUEUE_ADDR_HI) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_RX_QUEUE_NUM),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_RX_QUEUE_NUM) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_VLD),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_VLD) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_ALDC),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_ASSOC_LNK_DESC_CNT) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_DIS_DUP_DETECTION),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_DIS_DUP_DETECTION) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_SOFT_REORDER_EN),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SOFT_REORDER_EN) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_AC),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_AC) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_BAR),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_BAR) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_RETRY),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_RETRY) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_CHECK_2K_MODE),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_CHECK_2K_MODE) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_OOR_MODE),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_OOR_MODE) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_BA_WINDOW_SIZE),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_BA_WINDOW_SIZE) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN_CHECK),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_CHECK) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_EVEN_PN),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_EVEN_PN) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_UNEVEN_PN),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_UNEVEN_PN) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN_HANDLE_ENABLE),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_HANDLE_ENABLE) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN_SIZE),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_SIZE) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_IGNORE_AMPDU_FLG),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_IGNORE_AMPDU_FLG) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_SVLD),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SVLD) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_SSN),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SSN) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_SEQ_2K_ERR),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_SEQ_2K_ERR) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN_ERR),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_ERR) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN_VALID),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN_VALID) |
+		le32_encode_bits(!!(cmd->upd0 & HAL_REO_CMD_UPD0_PN),
+				 HAL_REO_UPD_RX_QUEUE_INFO0_UPD_PN);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_STATS_CLEAR)
+		desc->info0 |= cpu_to_le32(HAL_REO_UPD_RX_QUEUE_INFO0_CLR_STATS_COUNTERS);
+
+	desc->receive_queue_number = cpu_to_le16(cmd->rx_queue_num);
+	desc->info1 =
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_VLD),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_VLD) |
+		le16_encode_bits(u32_get_bits(cmd->upd1, HAL_REO_CMD_UPD1_ALDC),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_ASSOC_LNK_DESC_COUNTER) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_DIS_DUP_DETECTION),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_DIS_DUP_DETECTION) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_SOFT_REORDER_EN),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_SOFT_REORDER_EN) |
+		le16_encode_bits(u32_get_bits(cmd->upd1, HAL_REO_CMD_UPD1_LL_TIMER_ID),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_LINK_LIST_TIMER_ID) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_BAR),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_BAR) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_CHECK_2K_MODE),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_CHECK_2K_MODE) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_RETRY),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_RETRY) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_OOR_MODE),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_OOR_MODE) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_PN_CHECK),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_PN_CHECK) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_EVEN_PN),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_EVEN_PN) |
+		le16_encode_bits(!!(cmd->upd1 & HAL_REO_CMD_UPD1_UNEVEN_PN),
+				 HAL_REO_UPD_RX_QUEUE_INFO1_UNEVEN_PN);
+
+	if (cmd->pn_size == 24)
+		cmd->pn_size = HAL_RX_REO_QUEUE_PN_SIZE_24;
+	else if (cmd->pn_size == 48)
+		cmd->pn_size = HAL_RX_REO_QUEUE_PN_SIZE_48;
+	else if (cmd->pn_size == 128)
+		cmd->pn_size = HAL_RX_REO_QUEUE_PN_SIZE_128;
+
+	if (cmd->ba_window_size < 1)
+		cmd->ba_window_size = 1;
+
+	if (cmd->ba_window_size == 1)
+		cmd->ba_window_size++;
+
+	desc->info2 =
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_PN_HANDLE_ENABLE),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_PN_HANDLE_ENABLE) |
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_IGNORE_AMPDU_FLG),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_IGNORE_AMPDU_FLG) |
+		le32_encode_bits(cmd->ba_window_size - 1,
+				 HAL_REO_UPD_RX_QUEUE_INFO2_BA_WINDOW_SIZE) |
+		le32_encode_bits(cmd->pn_size, HAL_REO_UPD_RX_QUEUE_INFO2_PN_SIZE) |
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_SVLD),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_SVLD) |
+		le32_encode_bits(u32_get_bits(cmd->upd2, HAL_REO_CMD_UPD2_SSN),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_SSN) |
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_SEQ_2K_ERR),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_SEQ_2K_ERR) |
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_PN_ERR),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_PN_ERR) |
+		le32_encode_bits(!!(cmd->upd2 & HAL_REO_CMD_UPD2_PN_VALID),
+				 HAL_REO_UPD_RX_QUEUE_INFO2_PN_VALID);
+
+	desc->info2 |= cpu_to_le32(HAL_REO_UPD_RX_QUEUE_INFO2_FLUSH_FROM_CACHE);
+
+	if (cmd->upd0 & HAL_REO_CMD_UPD0_PN) {
+		desc->pn_31_0 = cpu_to_le32(cmd->pn[0]);
+		desc->pn_47_32 = cpu_to_le16(cmd->pn[1]);
+		desc->info3 =
+			le16_encode_bits(cmd->pn_127_48_info,
+					 HAL_REO_UPD_RX_QUEUE_INFO3_PN_127_48_INFO);
+	}
+
+	return le16_to_cpu(desc->cmd.reo_cmd_number);
+}
+
+static int ath12k_hal_reo_cmd_flush_queue(struct hal_tlv_64_hdr *tlv,
+					  struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_reo_flush_queue *desc = (struct hal_reo_flush_queue *)tlv->value;
+
+	tlv->tl = u32_encode_bits(HAL_REO_FLUSH_QUEUE, HAL_TLV_HDR_TAG) |
+		  u32_encode_bits(sizeof(*desc), HAL_TLV_HDR_LEN);
+
+	memset_startat(desc, 0, desc_addr_lo);
+
+	desc->cmd.info0 &= ~cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
+		desc->cmd.info0 |= cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	desc->desc_addr_lo = cpu_to_le32(cmd->addr_lo);
+	desc->info0 = le16_encode_bits(cmd->addr_hi,
+				       HAL_REO_FLUSH_QUEUE_INFO0_DESC_ADDR_HI);
+
+	return le16_to_cpu(desc->cmd.reo_cmd_number);
+}
+
+static int ath12k_hal_reo_cmd_unblock_cache(struct hal_tlv_64_hdr *tlv,
+					    struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_reo_unblock_cache *desc =
+		(struct hal_reo_unblock_cache *)tlv->value;
+
+	tlv->tl = u32_encode_bits(HAL_REO_UNBLOCK_CACHE, HAL_TLV_HDR_TAG) |
+		u32_encode_bits(sizeof(*desc), HAL_TLV_HDR_LEN);
+
+	memset_startat(desc, 0, info0);
+
+	desc->cmd.info0 &= ~cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
+		desc->cmd.info0 |= cpu_to_le16(HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED);
+
+	desc->info0 = cpu_to_le16(HAL_REO_UNBLOCK_CACHE_INFO0_UNBLK_CACHE);
+
+	return le16_to_cpu(desc->cmd.reo_cmd_number);
+}
+
+int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
+				  enum hal_reo_cmd_type type,
+				  struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_tlv_64_hdr *reo_desc;
+	u32 saved_hp, saved_reap_hp;
+	int ret;
+
+	if (type == HAL_REO_CMD_FLUSH_TIMEOUT_LIST) {
+		ath12k_warn(ab, "Unsupported reo command %d\n", type);
+		return -EOPNOTSUPP;
+	}
+
+	if (type > HAL_REO_CMD_UPDATE_RX_QUEUE) {
+		ath12k_warn(ab, "Unknown reo command %d\n", type);
+		return -EINVAL;
+	}
+
+	spin_lock_bh(&srng->lock);
+
+	ath12k_hal_srng_access_begin(ab, srng);
+	saved_hp = srng->u.src_ring.hp;
+	saved_reap_hp = srng->u.src_ring.reap_hp;
+
+	reo_desc = ath12k_hal_srng_src_get_next_entry(ab, srng);
+	if (!reo_desc) {
+		ret = -ENOBUFS;
+		goto out;
+	}
+
+	switch (type) {
+	case HAL_REO_CMD_GET_QUEUE_STATS:
+		ret = ath12k_wifi8_hal_reo_cmd_queue_stats(reo_desc, cmd);
+		break;
+	case HAL_REO_CMD_FLUSH_CACHE:
+		ret = ath12k_wifi8_hal_reo_cmd_flush_cache(&ab->hal, reo_desc,
+							   cmd);
+		break;
+	case HAL_REO_CMD_UPDATE_RX_QUEUE:
+		ret = ath12k_wifi8_hal_reo_cmd_update_rx_queue(reo_desc, cmd);
+		break;
+	case HAL_REO_CMD_FLUSH_QUEUE:
+		ret = ath12k_hal_reo_cmd_flush_queue(reo_desc, cmd);
+		break;
+	case HAL_REO_CMD_UNBLOCK_CACHE:
+		ret = ath12k_hal_reo_cmd_unblock_cache(reo_desc, cmd);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	ath12k_hal_srng_access_end(ab, srng);
+	spin_unlock_bh(&srng->lock);
+
+	return ret;
+}
+
+static void ath12k_wifi8_hal_reo_status_hdr_parse(struct hal_reo_status_hdr *hdr,
+						  struct hal_reo_status *status)
+{
+	status->uniform_hdr.cmd_num = le16_to_cpu(hdr->reo_status_number);
+	status->uniform_hdr.cmd_status =
+		le16_get_bits(hdr->info0, HAL_REO_STATUS_HDR_INFO0_EXEC_STATUS);
+	status->uniform_hdr.timestamp = le32_to_cpu(hdr->timestamp);
+}
+
+void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status)
+{
+	struct hal_reo_get_queue_stats_status *desc =
+		(struct hal_reo_get_queue_stats_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+
+	status->u.queue_stats.ssn =
+		le32_get_bits(desc->info0, HAL_REO_GET_Q_STATS_STATUS_INFO0_SSN);
+	status->u.queue_stats.curr_idx =
+		le32_get_bits(desc->info0, HAL_REO_GET_Q_STATS_STATUS_INFO0_CURRENT_INDEX);
+	status->u.queue_stats.pn[0] = le32_to_cpu(desc->pn_31_0);
+	status->u.queue_stats.pn[1] = le16_to_cpu(desc->pn_47_32);
+	status->u.queue_stats.last_rx_queue_ts =
+		le32_to_cpu(desc->last_rx_enqueue_timestamp);
+	status->u.queue_stats.last_rx_dequeue_ts =
+		le32_to_cpu(desc->last_rx_dequeue_timestamp);
+	status->u.queue_stats.rx_bitmap[0] = le32_to_cpu(desc->rx_bitmap_31_0);
+	status->u.queue_stats.rx_bitmap[1] = le32_to_cpu(desc->rx_bitmap_63_32);
+	status->u.queue_stats.rx_bitmap[2] = le32_to_cpu(desc->rx_bitmap_95_64);
+	status->u.queue_stats.rx_bitmap[3] = le32_to_cpu(desc->rx_bitmap_127_96);
+	status->u.queue_stats.rx_bitmap[4] = le32_to_cpu(desc->rx_bitmap_159_128);
+	status->u.queue_stats.rx_bitmap[5] = le32_to_cpu(desc->rx_bitmap_191_160);
+	status->u.queue_stats.rx_bitmap[6] = le32_to_cpu(desc->rx_bitmap_223_192);
+	status->u.queue_stats.rx_bitmap[7] = le32_to_cpu(desc->rx_bitmap_255_224);
+	status->u.queue_stats.rx_bitmap[8] = le32_to_cpu(desc->rx_bitmap_287_256);
+	status->u.queue_stats.curr_mpdu_cnt =
+		le32_get_bits(desc->info2, HAL_REO_GET_Q_STATS_STATUS_INFO2_CURRENT_MPDU_COUNT);
+	status->u.queue_stats.curr_msdu_cnt =
+		le32_get_bits(desc->info2, HAL_REO_GET_Q_STATS_STATUS_INFO2_CURRENT_MSDU_COUNT);
+	status->u.queue_stats.timeout_cnt =
+		le16_get_bits(desc->info3, HAL_REO_GET_Q_STATS_STATUS_INFO3_TIMEOUT_COUNT);
+	status->u.queue_stats.fwd_due_to_bar_cnt =
+		le16_get_bits(desc->info3, HAL_REO_GET_Q_STATS_STATUS_INFO3_FWD_DUE_TO_BAR_COUNT);
+	status->u.queue_stats.dup_cnt = le16_to_cpu(desc->duplicate_count);
+	status->u.queue_stats.frames_in_order_cnt =
+		le32_get_bits(desc->info4, HAL_REO_GET_Q_STATS_STATUS_INFO4_FRAMES_IN_ORDER_COUNT);
+	status->u.queue_stats.bar_rx_cnt =
+		le32_get_bits(desc->info4, HAL_REO_GET_Q_STATS_STATUS_INFO4_BAR_RECEIVED_COUNT);
+	status->u.queue_stats.num_mpdu_processed_cnt =
+		le32_to_cpu(desc->mpdu_frames_processed_count);
+	status->u.queue_stats.num_msdu_processed_cnt =
+		le32_to_cpu(desc->msdu_frames_processed_count);
+	status->u.queue_stats.total_num_processed_byte_cnt =
+		le32_to_cpu(desc->total_processed_byte_count);
+	status->u.queue_stats.late_rx_mpdu_cnt =
+		le32_get_bits(desc->info5, HAL_REO_GET_Q_STATS_STATUS_INFO5_LATE_RCV_MPDU_COUNT);
+	status->u.queue_stats.reorder_hole_cnt =
+		le32_get_bits(desc->info5, HAL_REO_GET_Q_STATS_STATUS_INFO5_HOLE_COUNT);
+	status->u.queue_stats.num_window_2k_jump_cnt =
+		le16_get_bits(desc->info3, HAL_REO_GET_Q_STATS_STATUS_INFO3_WINDOW_JUMP_2K);
+	status->loop_cnt =
+		le16_get_bits(desc->info6,
+			      HAL_REO_GET_Q_STATS_STATUS_INFO6_LOOPING_COUNT);
+}
+
+void ath12k_wifi8_hal_reo_flush_queue_status(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status)
+{
+	struct hal_reo_flush_queue_status *desc =
+		(struct hal_reo_flush_queue_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+	status->u.flush_queue.err_detected =
+			le32_get_bits(desc->info0,
+				      HAL_REO_FLUSH_QUEUE_INFO0_ERR_DETECTED);
+}
+
+void
+ath12k_wifi8_hal_reo_flush_cache_status(struct ath12k_base *ab,
+					struct hal_tlv_64_hdr *tlv,
+					struct hal_reo_status *status)
+{
+	struct ath12k_hal *hal = &ab->hal;
+	struct hal_reo_flush_cache_status *desc =
+		(struct hal_reo_flush_cache_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+
+	status->u.flush_cache.err_detected =
+			le32_get_bits(desc->info0,
+				      HAL_REO_FLUSH_CACHE_STATUS_INFO0_IS_ERR);
+	status->u.flush_cache.err_code =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_BLOCK_ERR_CODE);
+	if (!status->u.flush_cache.err_code)
+		hal->avail_blk_resource |= BIT(hal->current_blk_index);
+
+	status->u.flush_cache.cache_controller_flush_status_hit =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_STATUS_HIT);
+
+	status->u.flush_cache.cache_controller_flush_status_desc_type =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_DESC_TYPE);
+	status->u.flush_cache.cache_controller_flush_status_client_id =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_CLIENT_ID);
+	status->u.flush_cache.cache_controller_flush_status_err =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_ERR);
+	status->u.flush_cache.cache_controller_flush_status_cnt =
+		le32_get_bits(desc->info0,
+			      HAL_REO_FLUSH_CACHE_STATUS_INFO0_FLUSH_COUNT);
+}
+
+void ath12k_wifi8_hal_reo_unblk_cache_status(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status)
+{
+	struct ath12k_hal *hal = &ab->hal;
+	struct hal_reo_unblock_cache_status *desc =
+		(struct hal_reo_unblock_cache_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+
+	status->u.unblock_cache.err_detected =
+			le32_get_bits(desc->info0,
+				      HAL_REO_UNBLOCK_CACHE_STATUS_INFO0_IS_ERR);
+	status->u.unblock_cache.unblock_type =
+			le32_get_bits(desc->info0,
+				      HAL_REO_UNBLOCK_CACHE_STATUS_INFO0_TYPE);
+
+	if (!status->u.unblock_cache.err_detected &&
+	    status->u.unblock_cache.unblock_type ==
+	    HAL_REO_STATUS_UNBLOCK_BLOCKING_RESOURCE)
+		hal->avail_blk_resource &= ~BIT(hal->current_blk_index);
+}
+
+void
+ath12k_wifi8_hal_reo_flush_timeout_list_status(struct ath12k_base *ab,
+					       struct hal_tlv_64_hdr *tlv,
+					       struct hal_reo_status *status)
+{
+	struct hal_reo_flush_timeout_list_status *desc =
+		(struct hal_reo_flush_timeout_list_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+
+	status->u.timeout_list.err_detected =
+			le32_get_bits(desc->info0,
+				      HAL_REO_FLUSH_TIMEOUT_STATUS_INFO0_IS_ERR);
+	status->u.timeout_list.list_empty =
+			le32_get_bits(desc->info0,
+				      HAL_REO_FLUSH_TIMEOUT_STATUS_INFO0_LIST_EMPTY);
+
+	status->u.timeout_list.release_desc_cnt =
+		le32_get_bits(desc->info1,
+			      HAL_REO_FLUSH_TIMEOUT_STATUS_INFO1_REL_DESC_COUNT);
+	status->u.timeout_list.fwd_buf_cnt =
+		le32_get_bits(desc->info1,
+			      HAL_REO_FLUSH_TIMEOUT_STATUS_INFO1_FWD_BUF_COUNT);
+}
+
+void
+ath12k_wifi8_hal_reo_desc_thresh_reached_status(struct ath12k_base *ab,
+						struct hal_tlv_64_hdr *tlv,
+						struct hal_reo_status *status)
+{
+	struct hal_reo_desc_thresh_reached_status *desc =
+		(struct hal_reo_desc_thresh_reached_status *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(&desc->hdr, status);
+
+	status->u.desc_thresh_reached.threshold_idx =
+		le32_get_bits(desc->info0,
+			      HAL_REO_DESC_THRESH_STATUS_INFO0_THRESH_INDEX);
+
+	status->u.desc_thresh_reached.link_desc_counter0 =
+		le32_get_bits(desc->info1,
+			      HAL_REO_DESC_THRESH_STATUS_INFO1_LINK_DESC_COUNTER0);
+
+	status->u.desc_thresh_reached.link_desc_counter1 =
+		le32_get_bits(desc->info2,
+			      HAL_REO_DESC_THRESH_STATUS_INFO2_LINK_DESC_COUNTER1);
+
+	status->u.desc_thresh_reached.link_desc_counter2 =
+		le32_get_bits(desc->info3,
+			      HAL_REO_DESC_THRESH_STATUS_INFO3_LINK_DESC_COUNTER2);
+
+	status->u.desc_thresh_reached.link_desc_counter_sum =
+		le32_get_bits(desc->info4,
+			      HAL_REO_DESC_THRESH_STATUS_INFO4_LINK_DESC_COUNTER_SUM);
+}
+
+void ath12k_wifi8_hal_reo_update_rx_reo_queue_status(struct ath12k_base *ab,
+						     struct hal_tlv_64_hdr *tlv,
+						     struct hal_reo_status *status)
+{
+	struct hal_reo_status_hdr *desc =
+		(struct hal_reo_status_hdr *)tlv->value;
+
+	ath12k_wifi8_hal_reo_status_hdr_parse(desc, status);
+}
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
index bb97652713a2..d61ca0823b5f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
@@ -48,22 +48,24 @@
 #define HAL_REO_CMD_UPD1_ALDC			GENMASK(18, 17)
 #define HAL_REO_CMD_UPD1_DIS_DUP_DETECTION	BIT(19)
 #define HAL_REO_CMD_UPD1_SOFT_REORDER_EN	BIT(20)
-#define HAL_REO_CMD_UPD1_AC			GENMASK(22, 21)
-#define HAL_REO_CMD_UPD1_BAR			BIT(23)
-#define HAL_REO_CMD_UPD1_RETRY			BIT(24)
-#define HAL_REO_CMD_UPD1_CHECK_2K_MODE		BIT(25)
-#define HAL_REO_CMD_UPD1_OOR_MODE		BIT(26)
-#define HAL_REO_CMD_UPD1_PN_CHECK		BIT(27)
-#define HAL_REO_CMD_UPD1_EVEN_PN		BIT(28)
-#define HAL_REO_CMD_UPD1_UNEVEN_PN		BIT(29)
-#define HAL_REO_CMD_UPD1_PN_HANDLE_ENABLE	BIT(30)
-#define HAL_REO_CMD_UPD1_IGNORE_AMPDU_FLG	BIT(31)
+#define HAL_REO_CMD_UPD1_LL_TIMER_ID		GENMASK(24, 21)
+#define HAL_REO_CMD_UPD1_BAR			BIT(25)
+#define HAL_REO_CMD_UPD1_RETRY			BIT(26)
+#define HAL_REO_CMD_UPD1_CHECK_2K_MODE		BIT(27)
+#define HAL_REO_CMD_UPD1_OOR_MODE		BIT(28)
+#define HAL_REO_CMD_UPD1_PN_CHECK		BIT(29)
+#define HAL_REO_CMD_UPD1_EVEN_PN		BIT(30)
+#define HAL_REO_CMD_UPD1_UNEVEN_PN		BIT(31)
 
 /* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO2_* fields */
-#define HAL_REO_CMD_UPD2_SVLD			BIT(10)
-#define HAL_REO_CMD_UPD2_SSN			GENMASK(22, 11)
-#define HAL_REO_CMD_UPD2_SEQ_2K_ERR		BIT(23)
-#define HAL_REO_CMD_UPD2_PN_ERR		BIT(24)
+#define HAL_REO_CMD_UPD2_PN_HANDLE_ENABLE	BIT(0)
+#define HAL_REO_CMD_UPD2_IGNORE_AMPDU_FLG	BIT(1)
+#define HAL_REO_CMD_UPD2_SVLD			BIT(14)
+#define HAL_REO_CMD_UPD2_SSN			GENMASK(26, 15)
+#define HAL_REO_CMD_UPD2_SEQ_2K_ERR		BIT(27)
+#define HAL_REO_CMD_UPD2_PN_ERR			BIT(28)
+#define HAL_REO_CMD_UPD2_PN_VALID		BIT(29)
+#define HAL_REO_CMD_UPD2_FLUSH_FROM_CACHE	BIT(30)
 
 #define HAL_RX_MPDU_ERR_FCS			BIT(0)
 #define HAL_RX_MPDU_ERR_DECRYPT		BIT(1)
@@ -82,5 +84,50 @@
 /* 8 buffers for max-size SG MPDU + 1 entry to confirm termination */
 #define HAL_REO_SG_TERMINATION_MIN_ENTRIES 9
 
+struct ath12k_hal_rx_cmd_ring_param {
+	u32 mac_addr_31_0;
+	u32 mac_addr_47_32:16,
+	    is_mcast:1,
+	    is_mec:1,
+	    ad1_match:1,
+	    link_id:3,
+	    reserved_0:10;
+	u32 meta_data_0;
+	u8 cmd_num:4,
+	   reserved:4;
+	u8 hw_link_bitmap;
+};
+
+struct hal_tlv_64_hdr;
+struct hal_reo_status;
+
+int
+ath12k_wifi8_hal_invalidate_rx_cache_cmd_send(struct ath12k_base *ab,
+					      struct hal_srng *srng,
+					      struct ath12k_hal_rx_cmd_ring_param *param);
+int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
+				  enum hal_reo_cmd_type type,
+				  struct ath12k_hal_reo_cmd *cmd);
 void ath12k_wifi8_hal_reo_hw_setup(struct ath12k_base *ab);
+void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_flush_queue_status(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_flush_cache_status(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_unblk_cache_status(struct ath12k_base *ab,
+					     struct hal_tlv_64_hdr *tlv,
+					     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_flush_timeout_list_status(struct ath12k_base *ab,
+						    struct hal_tlv_64_hdr *tlv,
+						    struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_desc_thresh_reached_status(struct ath12k_base *ab,
+						     struct hal_tlv_64_hdr *tlv,
+						     struct hal_reo_status *status);
+void ath12k_wifi8_hal_reo_update_rx_reo_queue_status(struct ath12k_base *ab,
+						     struct hal_tlv_64_hdr *tlv,
+						     struct hal_reo_status *status);
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h
index ae4e32448027..594b5c544fb6 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h
@@ -112,4 +112,13 @@ int ath12k_wifi8_hal_tx_sam_cmd_send(struct ath12k_base *ab,
 					     enum hal_tlv_tag_be type,
 					     int id, bool clear_all);
 
+int
+ath12k_wifi8_hal_invalidate_tx_cache_cmd_send(struct ath12k_base *ab,
+					      struct hal_srng *srng,
+					      struct ath12k_hal_tx_cmd_ring_param *param);
+int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
+				  enum hal_reo_cmd_type type,
+				  struct ath12k_hal_reo_cmd *cmd);
+void ath12k_wifi8_hal_tx_set_dscp_tid_map(struct ath12k_base *ab, int id);
+
 #endif /* ATH12K_HAL_TX_H */

-- 
2.43.0

