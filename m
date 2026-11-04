Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754660;
	b=thPWZN9vlJsZbSoXVyQ+Rv6+RCH1KegThh7F1MavmgoC2dHViQezu9/ZBcXoRF2EnazD
	 LYwNrVaHyokhVzZLi8Z1E4GiYu8kdxkf5Z7NVBynjEwITfYiGjfKkFvkWW0KTo0U8Ls1+
	 0JOMs3nUsCHX9ISMaI5wqNdjDFuXgvzA7Y82xN01hiAJd4I3aEMCyjuGokZAsCfGnn1Gp
	 0bLO3t781ejClDptGmCQnhWeJrq6wksGODZinABGgaqHregvjewGMQelt41BtEtPpGXEy
	 7UX4g178RsBYsVgJciC8FqSHmz5+IwMRih4+ZHAeMpeRNWOGWhYY3XT2OHYmdEoZHYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754660;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=1QDjf16KlN4Jc+gwC5yfBRZndY4SFSNVWAqyLtWUkj8=;
	b=l1CUIN+lE7S7OrN1T76TCwr56mGzY6ozLpsc69hLj/YY9yWfXDX+YsbCO/KfbEQqZe4Y
	 bnPKwDddqW3v65cYrYr9S/bcVAJJYr3HDycf2sjvtjVt5UG3HTI9bZY9TzwFdP6xqAcgo
	 oJEUQgm+tkoJg0n49VSdu5uZd5I2Sg6DM4tJgfHwlh8BGZ2y96+q3T0CSuiEeRZ/zUlmC
	 IHGO60N5g+UNZ/1RNvyw5AyUOTUFo8S2RS3ATKBoQ6WM11ObsBlLdw0nwrjRYLeqHaL7M
	 6F4CtfNItLTH4HHyll/bIFRqRpEgX25iWR97PCjUxFJ4pjApYRzozjHftTHnNdTphBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=F9jVdZha;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UAQH7e6O;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62E606D83E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F62E606D83E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=F9jVdZha;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UAQH7e6O
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RPob230657
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1QDjf16KlN4Jc+gwC5yfBRZndY4SFSNVWAqyLtWUkj8=; b=F9jVdZha4RDxyMQK
	IdeCxPBeSuSI4TQFl7X2FMDZQVKA+r6vWEDNNXbvkXK8L517TmKJLi/iOdWIC5On
	Mf/WBquVtCUaf6H+MuArhEBEV5OdIZo/Adbmct1+hL9z3caRV3RpDnoDtcEyot4h
	ItB7vPQ++TgmJKldmPhTQTMi3UD3ZjBq8U3lM9DXxArnXeQ9odauEVx0ESvM9kxd
	uMEimuEm2EWRvhHUONmTrf1MayB+DWTl+QpJ6s3xoRel62asQrtHLkQOA+VRe8el
	kZTv9mJsw4H75ujjFz6ij4U7FGiySs5PKf4EzickHPh3F/4+crC8TvALLatquQ3q
	cIGFdQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhypjdwh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:58 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3662e7a9299so547255eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754658; x=1794359458; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1QDjf16KlN4Jc+gwC5yfBRZndY4SFSNVWAqyLtWUkj8=;
        b=UAQH7e6OXwPhxxi6RMdDEC4DaJHauLIy/MWR363TWzbnVPKBrX/vAv9faQ9lysM2aB
         WFSV1Dcoko4r6CiSyEryka79UKiWnSaIebHS0b5KrrysXwgEIUqrNUOdEuaLhXCeBeYo
         DZHgtGOiwGnICD85zHioIRfJkIa8xKTKygC0AEqL+ILzmrtl7pniBtnnKGE2YFv6XWaj
         4cj1oTTKT9ovQirGl/+zbP7bZ3+HvR/QoLB2rEN+ggILVTZla7xlGdZ3ygmBerLgyBBK
         XVJAqkOqDwlTj289IBvCgNfzyWYMvVnJhu1ay/Z2pML828SAqZoS2NOiwrHl462R76nP
         7Hnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754658; x=1794359458;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1QDjf16KlN4Jc+gwC5yfBRZndY4SFSNVWAqyLtWUkj8=;
        b=euvcesMwcyh5zcUOtPZdrtXUcbn6rfKp2bGCyl8iA3+BYx+lbBYTw0ynuFkI8NW9oE
         ce9zuaO8YrBTXpZBw3H991AQ/JlEo1R/UG1baWRpp7LFhEuF/k5qptO9+0wAoni2rKd+
         um7Y1nUP6kAW7zLjTRQ9J8MRzPSlAWVsNBOlqrcuiRRAvNr7u6fUMj55wPiQ3RNs0rJ1
         xcgqE5/kOyCZV7tfnpu12DjoMvvwgGhZqvUJlmbxyILVq/Xmusj65cwmILXYszuI+Mvv
         cfJPGGsbLgBS4tAcyqQctyFsQE7n0oM8wAJqxgseYaFvNji+Z8zyNueOoKV29tNW4NiE
         xgqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiYjWUvEN4Nq1QmgGFJBIPnJLaG8xbneMVM2Nyk1Y5FYsGxjXjWSXVcoBl3y4ak2ZmtqOmVDlglH1EnB04Mg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/TFJccpQvSX7XBK6h3gnN1cJmFfkp1hmze/4VnFKgnN2W/1QJq
	Wv7yLVigotkCL6qetqRltFkGux49cugflU5dR8F/nbVteZK5q21swOps+YzDzGFAtnrqbCrYhee
	qUDNuBLQM+UkZ8fJyoBzVkEU3UW4GScNvSPX9wuGIXVsdXXZZadDFxXF+25XYvcPWGJ7UGg==
X-Gm-Gg: AYBFou0y50EU+ycNNguhuVRar/fPL1FdNfKPr5IkSnx5R57Nk8oxnRj5baqYgLrKKBk
	Y4CBsESdg8f3DeAQRXvjQtFzw1XM9sMaKgjlAPTC5I8IjulWriRXZ10lTnRcvVT9SZVrjnkwGYG
	LQxb2f9NfO0bGJPaznWubpG8dogjq2BVNWygvAvu8Dt9uaFFm6EwY4Vidme9i0f0wOuRMY/6Wbz
	YUHSyL0wPWfxZCMFp2wrS7DE3haznsfqNTybR8Vbxuko98/6fyQ2iGyAHz17X3KnyFbHjPOhP/B
	WZ8TKbbIxcsYwNeW8SQvlTSv3i613Mi9O5bYl2PKL/d35A7mXEtZa1G3ePlGSF7OC4YN8iRRnIs
	wLX/8+Q6EC+tl2UXFsT2vef3xjcJTBPp4NhMGdx4W/dxj2mg/T5KTV8AiV5xYHBOApT+kurLONF
	WX0JmfCNbeXzEMOtJj3xM2osdvTphvh2iybDML
X-Received: by 2002:a05:7301:e0cd:b0:35c:707b:acba with SMTP id 5a478bee46e88-36a4220406emr22485674eec.3.1793754657419;
        Tue, 03 Nov 2026 17:10:57 -0800 (PST)
X-Received: by 2002:a05:7301:e0cd:b0:35c:707b:acba with SMTP id 5a478bee46e88-36a4220406emr22485624eec.3.1793754656537;
        Tue, 03 Nov 2026 17:10:56 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:56 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:53 -0800
Subject: [PATCH ath-next v3 10/13] wifi: ath12k: ng: add REO qaddr cache
 clear support
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-10-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX7lfJ2atEg5Ih
 wcSCwhB/JYflrnctgYIoDFxzjB3UQ9AQ8b91jB7L12Qe5jIoPh30LO5UtwTDVRIr6/4iqoAxQS1
 qKWVnb8eEV7eS/KQ5oABrZ2eIRSl80k=
X-Proofpoint-ORIG-GUID: rm4FDI7LboefzTR5nZVcgolxeESVMYjt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX1ElqfV/47+Fd
 eZarge8iX6BVeN8keLJEWueuSVJeyuZW+ozjvMRUmSPstR3jdkNuFIY1PPMSQcp2NXB53JG/tud
 SD2mRGXx6W2NdMMtN4XrrGZ3MNXhXSeLLZK4GHsUT07QFrpXKCFsGNtljlcGsIFmsx+seAkAmUE
 3DnFlyW+3sgDPVpU9YqLzYCh494Fu3P7FpvLopwb9CPmBcdLqvu88/Kbh694detYJnAxA1+ffUo
 TZSXYqHIzxyY3zdmuUP77KNReuBTzP9Pg6rO8B5zqyZegXmw/QrixWXUSrGnCfAQF7eDtLAUrjn
 mxwEIpNz4Z0TxU74ICOGKYMIb5zQJn0WRoL4/gVlX6ACYljtDe3AVmnbYagNIz/Ws79zzGCn+rv
 oje9a+IimgBrvzSu2u37Zz6av8yd6X3c5193ItV1vEoFrrxurWzuicBnvnQ2BKL4RlzhgIRZy4v
 wtA4xSh9WAlmcoMAUfQ==
X-Proofpoint-GUID: rm4FDI7LboefzTR5nZVcgolxeESVMYjt
X-Authority-Analysis: v=2.4 cv=T94Z3PKQ c=1 sm=1 tr=0 ts=6aea8622 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=BFncArQEFM-slyMzr-AA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

Wi-Fi 8 RX TID setup updates the shared queue-address table. Once REO
queue LUT support is enabled, those updates must invalidate the hardware
qaddr cache or later lookups can use stale queue descriptors.

Register the Wi-Fi 8 cache-clear callback before qref updates are made
reachable so station add cannot call an unset HAL operation.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 .../net/wireless/ath/ath12k/wifi8/hal_qcn9625.c    |  1 +
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c     | 23 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h     |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_qcn9625.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_qcn9625.c
index 6235668e23cd..bb2f114d97ab 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_qcn9625.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_qcn9625.c
@@ -421,6 +421,7 @@ const struct hal_ops hal_qcn9625_ops = {
 	.tx_configure_bank_register = ath12k_wifi8_hal_tx_configure_bank_register,
 	.tx_set_dscp_tid_map = ath12k_wifi8_hal_tx_set_dscp_tid_map,
 	.reo_hw_setup = ath12k_wifi8_hal_reo_hw_setup,
+	.reo_shared_qaddr_cache_clear = ath12k_wifi8_hal_reo_shared_qaddr_cache_clear,
 	.extract_rx_desc_data = ath12k_hal_extract_rx_desc_data_qcn9625,
 	.rx_desc_get_dot11_hdr = ath12k_hal_rx_desc_get_dot11_hdr_qcn9625,
 	.rx_h_is_decrypted = ath12k_hal_rx_h_is_decrypted_qcn9625,
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
index ad00c182c2bd..d636f6ab60ff 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
@@ -907,6 +907,29 @@ void ath12k_wifi8_hal_reo_update_rx_reo_queue_status(struct ath12k_base *ab,
 	ath12k_wifi8_hal_reo_status_hdr_parse(desc, status);
 }
 
+void ath12k_wifi8_hal_reo_shared_qaddr_cache_clear(struct ath12k_base *ab)
+{
+	struct ath12k_hal *hal = &ab->hal;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	u32 val;
+
+	lockdep_assert_held(&dp->dp_lock);
+
+	if (!ab->hw_params->reoq_lut_support)
+		return;
+
+	val = ath12k_hif_read32(ab, HAL_SEQ_WCSS_UMAC_REO_REG +
+				HAL_REO1_QDESC_ADDR(hal));
+
+	val |= u32_encode_bits(1, HAL_REO_QDESC_ADDR_READ_CLEAR_QDESC_ARRAY);
+	ath12k_hif_write32(ab, HAL_SEQ_WCSS_UMAC_REO_REG +
+			   HAL_REO1_QDESC_ADDR(hal), val);
+
+	val &= ~HAL_REO_QDESC_ADDR_READ_CLEAR_QDESC_ARRAY;
+	ath12k_hif_write32(ab, HAL_SEQ_WCSS_UMAC_REO_REG +
+			   HAL_REO1_QDESC_ADDR(hal), val);
+}
+
 u32 ath12k_wifi8_hal_reo_qdesc_size(u32 ba_window_size, u8 tid)
 {
 	u32 num_ext_desc = ath12k_wifi8_hal_reo_num_ext_desc(ba_window_size);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
index 94732f82f614..26a24731cb06 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
@@ -129,6 +129,7 @@ int ath12k_wifi8_hal_reo_cmd_send_n(struct ath12k_base *ab,
 				    struct ath12k_reo_cmd_entry *entries,
 				    int n);
 void ath12k_wifi8_hal_reo_hw_setup(struct ath12k_base *ab);
+void ath12k_wifi8_hal_reo_shared_qaddr_cache_clear(struct ath12k_base *ab);
 void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
 					     struct hal_tlv_64_hdr *tlv,
 					     struct hal_reo_status *status);

-- 
2.43.0

