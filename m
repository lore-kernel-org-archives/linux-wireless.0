Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754674;
	b=FAWd2A0rA1v3F6v/vHXke1B+gcBpQ0qxFFnNkG8pW+rQBCLkpu7rwlFUCxoqYud1q101
	 I/FsJSPN+wKGjUfJXTfYrdlBNAS1xmCGB2Q3ltFCMIG6wZpCSAT4XURMmcscc6iIjLI4H
	 Fhyepst7ahtyyWIDuI/u7/tB2v/bviLn61Phtw9YeJHk2ol3EIbY4kqgnNaC4gajTUgd2
	 A9LC3n1htgvhkatH31Waim5WFDyYNkztmdpf/QkNYp1XGLlEqV9X/xqwwVHgBwhCGqY1J
	 sIE4HXoCeVTzUtUSu+CY60zwbYCybAi3LtHNIQaxKxPNdiJyNhpv757q+zZjeornDVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754674;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=P6T+znYJFX63fZP+5bBevFaZYq1NjxngereBvySOQ7o=;
	b=x9hh5PkowqpLoC126+S3CTtGEISra5GEE2jxDlXV20j/M+Fm1cqR5TY1aalWN9sstgEX
	 XdyFgzpk2U/ekrODUxb/QYQOz3EDIr46+uzqaD6A6y/SrdXiyBJQ0MpS3og3lnzZS6EfF
	 RaLLChh0H5KubWaI33BzsQC0Xc3EofQlhka1pYmBjkjcGXEQpTPI2Be5SqQ8JEI+Ja6Yc
	 HyWJQTGBgqmzN74K4M7qgWrJsVrN9qdLUMNVYwq50T7T3+nG83K/BRXKAjfSy9oWl/Qsc
	 1cwqrQYQJNiOo0kG7Is4hwG4+zgEF0DcOt4UHa4BNqBYF7fOS5fiLSwufD30Y+yibnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dnQ8tkCs;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SMYr9Rsm;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B524606D809
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:11:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B524606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dnQ8tkCs;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SMYr9Rsm
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RMEO222172
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P6T+znYJFX63fZP+5bBevFaZYq1NjxngereBvySOQ7o=; b=dnQ8tkCsDqT7CwL2
	FvjyCHEDCwMUYsegh6FGYu/AWaW/yIyurgL8pjNt94d9jQxpfSZaEPtwBFIO8nQn
	QY6osp9vo1+++wcaa8FUI9nGtxeHq+5iyCuMjoq2WyxvakNhLRAf/+Je5lVjYczc
	l14AU2k5L/xqQudzsPX3B6HugVydHD4UMZrGmcWdCD78A9nuKR4lx6NNwPLdP5jp
	e8dBiqOCHYIoEnPJKr05ROeP7pJHdJN4c49hDw3C74DWcxtK41YlJxJpWmeuLjtO
	0waonw4iq/JUVDCQUKUvCVBnG87t+q9mMyTvzPhOTZpstG+cSFgPp624b9oFgp6Q
	BHGN8Q==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqjubj23x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:59 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a223755e4so520431eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754658; x=1794359458; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P6T+znYJFX63fZP+5bBevFaZYq1NjxngereBvySOQ7o=;
        b=SMYr9RsmAyvTUQN5chPGol0BA0R5CO9xI4w9Mos4Jn4z3EHN/HR6Pqs2hjHqTrJN3R
         9jv9OwQToEs3wfKKJnn+gZLmkuEjXdAbuAWetfFEHQtvVjcOWFQ7wp0oop9K+mLfjYa+
         MXpLM9LX4wugvTErEjvMM2NFiNP13eGFFg1QlbwUW7Siv1bi5xWEZnGT4/rLhgE8yLun
         AJwq2fAf+SswuXWWON595kPoFVH6M/oceJnZoQaogHODLMBbl7qdbtOvLGeBCzCmn56k
         DRuuP47ISmTtk2R+FWjRnPUrrfzTtxWVftGt226+l9qhPf84g6+oPTVS4NnQKp0mfkx5
         A8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754658; x=1794359458;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6T+znYJFX63fZP+5bBevFaZYq1NjxngereBvySOQ7o=;
        b=SGmG5nei+CAS59Mdo4LWS7n3qqID9kxXzrEH47IL90Ydpweyg71/Dr0LGwgqwqcSr/
         PGsWORiOnI6MoFkv/og1eSNM4GegF3PczhmBBqQynOmXKJFx2Z5IlnKdEqgBMhni+oxO
         8mtOoOMtNng25TWJ9zyI8eyDduWOmC6OYaZr1r5kjiFMBj6Si06IHbXqtjTMcDHTSIVb
         KX8EMF4rQL7EkeDPy8Y9tQ4G+Ffn3Te/yOnBLt7uTVLJptmnixIYC+cj4mbUha6R2hOK
         3vSvWyCiV4PuXvi2wQFrs9GEZwyl//O0koVFurtoAL9B66OgNyWWMAa+J8KrOmMXY9W7
         PKdg==
X-Forwarded-Encrypted: i=1; AKwUvBwFczWie1Gl/JvziiA8FwQ4erNB84Ado6c/a6fSWF+AetwVmw02T9BdDIshj+ph1PugJeaZ5ls54LoIteEWvA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/rNSYg4ypRfIAL7XMmJHrmuzbcdVBq2Ze3fwvpC0WpUi0JcA1N
	JDBGjczk3X/gPSUqBhsfAEUuSy/mi/vy2gFHaFgyAh1ioWKcFxWtslj8s3QMx91nBBPuzi+Aovf
	FpLYIoyH7CRlSb1OUqVifqplMLZ2sogZMZKFvjjcfrLnD5SprRLT7iBnZ0aagc/+UoGKcYw==
X-Gm-Gg: AYBFou1jgMt/CG0mkCX80k5yAxOS6aEatOkBU3YhILDncXOd2aiYKPS1O0+69rKWW4I
	QEep8wQ7RZ9mqRYnels54ViGgO9PsRCSoxMPegINIEm8sMmjbXXgILqFkO5a/3sIeAHCbXt59RP
	jgP0MKna8KvJHwXttx9PajUqCJpmMfP3k1H2WEXpMi7kgbaxC836XBQ4j2LyLVgDOol0PE2TioZ
	zcmiXM6CgLKEihxoJppm+ILIHdc1pz6sQnxwEWzqOuQ0Pp0ycI6evl3foWOCT46jRFH4781rkdb
	Lih58HYLSDvZAyPShFx7xns/sWSPRaAiPwGkKHVmf6kBqMJGorRoWmqI77pNS+XbTncu2RvMwXx
	cmQzwzP09yt6sf+n3mSJtMapvBk9EBMdP9JSg3ZLXfLluwWu7lEcK9xFP7aGgZYcUxx7OMvn0Qu
	QOXmAdPhz2a8AzrVf16T7GHret7QSljzJYxqiX
X-Received: by 2002:a05:7300:c39f:b0:366:6644:2839 with SMTP id 5a478bee46e88-36a42203e90mr22284503eec.3.1793754658316;
        Tue, 03 Nov 2026 17:10:58 -0800 (PST)
X-Received: by 2002:a05:7300:c39f:b0:366:6644:2839 with SMTP id 5a478bee46e88-36a42203e90mr22284457eec.3.1793754657522;
        Tue, 03 Nov 2026 17:10:57 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:57 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:54 -0800
Subject: [PATCH ath-next v3 11/13] wifi: ath12k: ng: add RX TID REO helpers
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-11-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXwfNOsuIIJUm0
 Vo5+TTRET7ZMHLkrMGfPp2HKVjCx7dFiNtDxWePFFBjJn0B+wqXr61gJ08fhdoQ0T/XhOkSO9O2
 6fIN31ZExHJkVY4s2oXQGlTxqgKvcFU=
X-Authority-Analysis: v=2.4 cv=JeUpPkKV c=1 sm=1 tr=0 ts=6aea8623 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=kM6TWAs1cUZVOPE9P6AA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: Il-NtESTS4hE8KoHwdrOI2kXeEyUoy1f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXz7o+mwXll+7r
 efGhD1ENTWVYw2YpZxDbIZnFFzoO++wjRfQC8n2RQFvy+rlGxJPDCx3FQzJ/JZgdrQIGd3LEo0x
 sWdB7ITgWyHC/6sf0H1wtlKvl3NFS/Hyzrj76Y+1INlXX8s/CB39K0borqPV/r6DuqL7ax79AUc
 JjxjMvF4GVb5juo+8l8OFlKmo89ctAZ+V3cshAO/qLsBjHuQb/L1LCcjcQFqXEzZrZ4BAMR2uIz
 /wjaK4uzRTMwN6QcTNbAiAxYm7S+1GfPSr3mWPvBNkPFtdEoU/DN7y6kN5PbSswJLRN5Z71Pb5N
 YBBxSNMj5JtvU5Z5X0+0J9zlBhCtrzYFvmbVZC9kGAYlvkzcQrUUbWaLD0YMnt2LbaGpLMwVmHb
 bogF6UHSikWWcteu0/OihnOZtFhlRyaiJn8V17jLoFVAkBUWBiU3zUaKDTLQ9S7L9yQ1oWO080b
 hol8kRvubCxczTaeEuA==
X-Proofpoint-ORIG-GUID: Il-NtESTS4hE8KoHwdrOI2kXeEyUoy1f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

The common RX TID path routes queue setup, update, flush and teardown
through architecture hooks. Wi-Fi 8 needs matching helpers before those
hooks can be enabled for QCN9625.

Add helpers for queue update, qref programming, PN configuration, flush
handling and fragment cleanup. Keep the helpers disconnected until the
final wiring patch so intermediate commits do not expose a partial RX TID
implementation.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c | 288 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h |  31 +++
 2 files changed, 315 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
index 14117430c43b..0b8a9d32e125 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
@@ -283,6 +283,287 @@ int ath12k_wifi8_dp_reo_cmd_send_highprio_n(struct ath12k_base *ab,
 						   dp_descs, n);
 }
 
+static struct ath12k_reo_queue_ref *
+ath12k_wifi8_peer_rx_tid_qref(struct ath12k_dp *dp, u16 peer_id, u16 tid)
+{
+	struct ath12k_reo_q_addr_lut *lut = &dp->reoq_lut;
+
+	if (!lut->vaddr)
+		return NULL;
+
+	peer_id &= ~ATH12K_PEER_ML_ID_VALID;
+
+	return (struct ath12k_reo_queue_ref *)lut->vaddr +
+		peer_id * (IEEE80211_NUM_TIDS + 1) + tid;
+}
+
+void ath12k_wifi8_peer_rx_tid_qref_setup(struct ath12k_base *ab, u16 peer_id,
+					 u16 tid, dma_addr_t paddr)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_base *central_ab = central_dp->ab;
+	struct ath12k_reo_queue_ref *qref;
+
+	if (!central_ab->hw_params->reoq_lut_support)
+		return;
+
+	if ((peer_id & ~ATH12K_PEER_ML_ID_VALID) > DP_MAX_PEER_ID) {
+		ath12k_warn(central_ab, "peer id %d exceeds reo qref table\n",
+			    peer_id);
+		return;
+	}
+
+	qref = ath12k_wifi8_peer_rx_tid_qref(central_dp, peer_id, tid);
+	if (!qref) {
+		ath12k_warn(central_ab, "reo qref table is not setup\n");
+		return;
+	}
+
+	qref->info0 = u32_encode_bits(lower_32_bits(paddr),
+				      BUFFER_ADDR_INFO0_ADDR);
+	qref->info1 = u32_encode_bits(upper_32_bits(paddr),
+				      BUFFER_ADDR_INFO1_ADDR) |
+		      u32_encode_bits(tid, DP_REO_QREF_NUM);
+
+	ath12k_hal_reo_shared_qaddr_cache_clear(central_ab);
+}
+
+void ath12k_wifi8_peer_rx_tid_qref_reset(struct ath12k_base *ab, u16 peer_id,
+					 u16 tid)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_base *central_ab = central_dp->ab;
+	struct ath12k_reo_queue_ref *qref;
+
+	if (!central_ab->hw_params->reoq_lut_support)
+		return;
+
+	if ((peer_id & ~ATH12K_PEER_ML_ID_VALID) > DP_MAX_PEER_ID) {
+		ath12k_warn(central_ab, "peer id %d exceeds reo qref table\n",
+			    peer_id);
+		return;
+	}
+
+	qref = ath12k_wifi8_peer_rx_tid_qref(central_dp, peer_id, tid);
+	if (!qref) {
+		ath12k_warn(central_ab, "reo qref table is not setup\n");
+		return;
+	}
+
+	qref->info0 = u32_encode_bits(0, BUFFER_ADDR_INFO0_ADDR);
+	qref->info1 = u32_encode_bits(0, BUFFER_ADDR_INFO1_ADDR) |
+		      u32_encode_bits(tid, DP_REO_QREF_NUM);
+
+	ath12k_hal_reo_shared_qaddr_cache_clear(central_ab);
+}
+
+void ath12k_wifi8_dp_rx_peer_tid_delete(struct ath12k_base *ab,
+					struct ath12k_dp_link_peer *peer,
+					u8 tid)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+
+	if (!(peer->rx_tid_active_bitmask & BIT(tid)))
+		return;
+
+	ath12k_dp_mark_tid_as_inactive(dp, peer->peer_id, tid);
+	ath12k_dp_rx_process_reo_cmd_update_rx_queue_list(dp);
+}
+
+int ath12k_wifi8_peer_rx_tid_reo_update(struct ath12k_dp *dp,
+					struct ath12k_dp_link_peer *peer,
+					struct ath12k_dp_rx_tid *rx_tid,
+					u32 ba_win_sz, u16 ssn,
+					bool update_ssn)
+{
+	struct ath12k_dp_rx_tid_rxq rx_tid_rxq;
+	struct ath12k_hal_reo_cmd cmd = {};
+	struct ath12k_base *ab = dp->ab;
+	int ret;
+
+	ath12k_dp_init_rx_tid_rxq(&rx_tid_rxq, rx_tid,
+				  !!(peer->rx_tid_active_bitmask &
+				     BIT(rx_tid->tid)));
+
+	cmd.addr_lo = lower_32_bits(rx_tid_rxq.qbuf.paddr_aligned);
+	cmd.addr_hi = upper_32_bits(rx_tid_rxq.qbuf.paddr_aligned);
+	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS;
+	cmd.upd0 = HAL_REO_CMD_UPD0_BA_WINDOW_SIZE;
+	cmd.ba_window_size = ba_win_sz;
+
+	if (update_ssn) {
+		cmd.upd0 |= HAL_REO_CMD_UPD0_SSN;
+		cmd.upd2 = u32_encode_bits(ssn, HAL_REO_CMD_UPD2_SSN);
+	}
+
+	ret = ath12k_wifi8_dp_reo_cmd_send(ab, &rx_tid_rxq,
+					   sizeof(rx_tid_rxq),
+					   HAL_REO_CMD_UPDATE_RX_QUEUE,
+					   &cmd, NULL);
+	if (ret) {
+		ath12k_warn(ab, "failed to update rx tid queue, tid %d (%d)\n",
+			    rx_tid_rxq.tid, ret);
+		return ret;
+	}
+
+	rx_tid->ba_win_sz = ba_win_sz;
+
+	ath12k_dbg(ab, ATH12K_DBG_DP_RX,
+		   "rx tid queue update successful for tid: %u, peer_id: %d, peer: %pM, link_id: %u ba_win_sz: %u\n",
+		   rx_tid->tid, peer->peer_id, peer->addr, peer->link_id,
+		   rx_tid->ba_win_sz);
+
+	return 0;
+}
+
+int ath12k_wifi8_dp_reo_cache_flush(struct ath12k_base *ab,
+				    struct ath12k_dp_rx_tid_rxq *rx_tid)
+{
+	struct ath12k_hal_reo_cmd cmd = {};
+
+	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS |
+		   HAL_REO_CMD_FLG_FLUSH_FWD_ALL_MPDUS;
+
+	if (rx_tid->tid != HAL_DESC_REO_NON_QOS_TID)
+		cmd.flag |= HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC;
+
+	return ath12k_wifi8_dp_reo_cmd_send(ab, rx_tid, sizeof(*rx_tid),
+					    HAL_REO_CMD_FLUSH_CACHE, &cmd,
+					    ath12k_dp_reo_cmd_free);
+}
+
+int ath12k_wifi8_dp_rx_assign_reoq(struct ath12k_base *ab,
+				   struct ath12k_dp_peer *dp_peer,
+				   struct ath12k_dp_rx_tid *rx_tid,
+				   u16 ssn, enum hal_pn_type pn_type)
+{
+	u32 ba_win_sz = rx_tid->ba_win_sz;
+	struct ath12k_reoq_buf *buf;
+	void *vaddr, *vaddr_aligned;
+	dma_addr_t paddr_aligned;
+	u8 tid = rx_tid->tid;
+	u32 hw_desc_sz;
+	int ret;
+
+	buf = &dp_peer->reoq_bufs[tid];
+	if (!buf->vaddr) {
+		if (tid == HAL_DESC_REO_NON_QOS_TID)
+			hw_desc_sz = ath12k_wifi8_hal_reo_qdesc_size(ba_win_sz,
+								     tid);
+		else
+			hw_desc_sz = ath12k_wifi8_hal_reo_qdesc_size(DP_BA_WIN_SZ_MAX,
+								     tid);
+
+		vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1,
+				GFP_ATOMIC);
+		if (!vaddr)
+			return -ENOMEM;
+
+		vaddr_aligned = PTR_ALIGN(vaddr, HAL_LINK_DESC_ALIGN);
+
+		ath12k_wifi8_hal_reo_qdesc_setup(vaddr_aligned, tid,
+						 ba_win_sz, ssn, pn_type);
+
+		paddr_aligned = dma_map_single(ab->dev, vaddr_aligned,
+					       hw_desc_sz,
+					       DMA_BIDIRECTIONAL);
+		ret = dma_mapping_error(ab->dev, paddr_aligned);
+		if (ret) {
+			kfree(vaddr);
+			return ret;
+		}
+
+		buf->vaddr = vaddr;
+		buf->paddr_aligned = paddr_aligned;
+		buf->size = hw_desc_sz;
+	}
+
+	rx_tid->qbuf = *buf;
+
+	return 0;
+}
+
+int ath12k_wifi8_dp_rx_tid_delete_handler(struct ath12k_base *ab,
+					  struct ath12k_dp_rx_tid_rxq *rx_tid)
+{
+	struct ath12k_hal_reo_cmd cmd = {};
+
+	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS;
+	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
+	/* Keep the queue descriptor valid until the delete completion path
+	 * flushes it from the REO cache. Clearing VLD here can make the
+	 * subsequent flush-cache command fail.
+	 */
+	cmd.upd0 |= HAL_REO_CMD_UPD0_VLD;
+	cmd.upd1 |= HAL_REO_CMD_UPD1_VLD;
+
+	return ath12k_wifi8_dp_reo_cmd_send(ab, rx_tid, sizeof(*rx_tid),
+					    HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
+					    ath12k_dp_rx_tid_del_func);
+}
+
+void ath12k_wifi8_dp_rx_frags_cleanup(struct ath12k_dp_rx_tid *rx_tid,
+				      bool rel_link_desc)
+{
+	enum hal_wbm_rel_bm_act act = HAL_WBM_REL_BM_ACT_PUT_IN_IDLE;
+	struct ath12k_buffer_addr *buf_addr_info;
+	struct ath12k_dp *dp = rx_tid->dp;
+
+	lockdep_assert_held(&dp->dp_lock);
+
+	if (rx_tid->dst_ring_desc) {
+		if (rel_link_desc) {
+			buf_addr_info = &rx_tid->dst_ring_desc->buf_addr_info;
+			ath12k_wifi8_dp_rx_link_desc_return(dp, buf_addr_info,
+							    act);
+		}
+
+		kfree(rx_tid->dst_ring_desc);
+		rx_tid->dst_ring_desc = NULL;
+	}
+
+	rx_tid->cur_sn = 0;
+	rx_tid->last_frag_no = 0;
+	rx_tid->rx_frag_bitmap = 0;
+	__skb_queue_purge(&rx_tid->rx_frags);
+}
+
+void ath12k_wifi8_dp_setup_pn_check_reo_cmd(struct ath12k_hal_reo_cmd *cmd,
+					    struct ath12k_dp_rx_tid *rx_tid,
+					    u32 cipher,
+					    enum set_key_cmd key_cmd)
+{
+	cmd->flag = HAL_REO_CMD_FLG_NEED_STATUS;
+	cmd->upd0 = HAL_REO_CMD_UPD0_PN |
+		    HAL_REO_CMD_UPD0_PN_SIZE |
+		    HAL_REO_CMD_UPD0_PN_VALID |
+		    HAL_REO_CMD_UPD0_PN_CHECK |
+		    HAL_REO_CMD_UPD0_SVLD;
+
+	switch (cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		if (key_cmd == SET_KEY) {
+			cmd->upd1 |= HAL_REO_CMD_UPD1_PN_CHECK;
+			cmd->pn_size = 48;
+		}
+		break;
+	default:
+		break;
+	}
+
+	cmd->addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd->addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
+}
+
 /**
  * ath12k_wifi8_rx_spd_buf_alloc - allocate per-ring SPD scratch-pad arrays
  * @dp_hw_grp_wifi8: Wi-Fi 8 hardware-group private data
@@ -1318,10 +1599,9 @@ ath12k_wifi8_hal_rx_msdu_link_info_get(struct hal_wifi8_rx_msdu_link *link,
  * ath12k_wifi8_dp_rx_link_desc_return - return a link descriptor to the WBM
  * idle pool.
  */
-static int
-ath12k_wifi8_dp_rx_link_desc_return(struct ath12k_dp *dp,
-				    struct ath12k_buffer_addr *buf_addr_info,
-				    enum hal_wbm_rel_bm_act action)
+int ath12k_wifi8_dp_rx_link_desc_return(struct ath12k_dp *dp,
+					struct ath12k_buffer_addr *buf_addr_info,
+					enum hal_wbm_rel_bm_act action)
 {
 	struct ath12k_base *ab = dp->ab;
 	struct hal_wbm_release_ring *desc;
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
index 2fb56776adb0..c5ee01e703a5 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
@@ -8,6 +8,7 @@
 #define ATH12K_DP_RX_WIFI8_H
 
 #include "../core.h"
+#include "../dp_rx.h"
 #include "hal_desc.h"
 
 struct ath12k_dp_hw_group_wifi8;
@@ -171,6 +172,36 @@ int ath12k_wifi8_dp_reo_cmd_send_highprio_n(struct ath12k_base *ab,
 					    struct ath12k_reo_cmd_entry *entries,
 					    struct ath12k_reo_dp_cmd_desc *dp_descs,
 					    int n);
+void ath12k_wifi8_dp_setup_pn_check_reo_cmd(struct ath12k_hal_reo_cmd *cmd,
+					    struct ath12k_dp_rx_tid *rx_tid,
+					    u32 cipher,
+					    enum set_key_cmd key_cmd);
+int ath12k_wifi8_dp_rx_assign_reoq(struct ath12k_base *ab,
+				   struct ath12k_dp_peer *dp_peer,
+				   struct ath12k_dp_rx_tid *rx_tid,
+				   u16 ssn, enum hal_pn_type pn_type);
+int ath12k_wifi8_dp_rx_link_desc_return(struct ath12k_dp *dp,
+					struct ath12k_buffer_addr *buf_addr_info,
+					enum hal_wbm_rel_bm_act action);
+void ath12k_wifi8_dp_rx_frags_cleanup(struct ath12k_dp_rx_tid *rx_tid,
+				      bool rel_link_desc);
+void ath12k_wifi8_peer_rx_tid_qref_setup(struct ath12k_base *ab,
+					 u16 peer_id, u16 tid,
+					 dma_addr_t paddr);
+void ath12k_wifi8_dp_rx_peer_tid_delete(struct ath12k_base *ab,
+					struct ath12k_dp_link_peer *peer,
+					u8 tid);
+int ath12k_wifi8_dp_reo_cache_flush(struct ath12k_base *ab,
+				    struct ath12k_dp_rx_tid_rxq *rx_tid);
+int ath12k_wifi8_peer_rx_tid_reo_update(struct ath12k_dp *dp,
+					struct ath12k_dp_link_peer *peer,
+					struct ath12k_dp_rx_tid *rx_tid,
+					u32 ba_win_sz, u16 ssn,
+					bool update_ssn);
+void ath12k_wifi8_peer_rx_tid_qref_reset(struct ath12k_base *ab,
+					 u16 peer_id, u16 tid);
+int ath12k_wifi8_dp_rx_tid_delete_handler(struct ath12k_base *ab,
+					  struct ath12k_dp_rx_tid_rxq *rx_tid);
 int ath12k_wifi8_dp_rx_ring_setup(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rx_ring_free(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rxdma_ring_sel_config_qcn9625(struct ath12k_base *ab);

-- 
2.43.0

