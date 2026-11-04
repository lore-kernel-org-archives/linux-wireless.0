Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754657;
	b=bBr7Q3qvWTCfBeFRCn3YHGW7MwPuW6FfQ1bGBO01IGWpydO6RetBlc+u/f5HKioH/QZF
	 qW9F2E6nUP74ycQfPV8+71NQmQk6mNfwXzBeM7lce0/wr41xjECwWwuayU2NzuC9Q8+64
	 9six+gqeFdSqoFlTNOZzuP9E4HmAvw94QdmBeorpzpRRmrESKMEx3cRaal5ejGOcfeavI
	 mcgsCpN9megfe+BJmYhvPaYb9CRMsoTp9ldO9s5TPQStMBdsjioqrqfdeMMbWMLHLz2Q0
	 dwUgzoCank9Fx3DYpxkJ1NQy8Rp9/0R9YAcLab6O1xZBYWs39lU8ibrKtOLSHPIlQ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754657;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Zy0g99KSmpxnlulEZdJjfjKVXSjdwjfhmOrhoS8xvt4=;
	b=Lx1auLSX6Nn/FHPXeRVG4AIjJ0yUnWwgx7jNuRPL6Pc5j0m+P63nHlqsytmstruX3PzJ
	 U5kcmwmImK7rWeSwMpZ3WTVg2VHTh+mhykrNZGb5mayN4QfCVhZlZ0Xr7P31xU4P2Ixut
	 dXtg6Wy/BkRF8ELwlJHXIuCKfmntLSvxLk4ND+DfiEDTJ+LI1SdLePaS5FxfCvRnLKX+B
	 +Nq5DcWwm0bbtYmSIIK/n4hqzB8gMvROqha24wxlDcECpltsfuI7DdZp6wLBxyM3jayO4
	 En1j2aHTecBW4tenhi1EJK/qvET/lln9WT49f0tsAMuCgQDVYpBMkxRCda+AGWUu3XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OD2NxHmX;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Ju/uNI3C";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0633606D830
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0633606D830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OD2NxHmX;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ju/uNI3C
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RO44809361
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Zy0g99KSmpxnlulEZdJjfjKVXSjdwjfhmOrhoS8xvt4=; b=OD2NxHmXppY4J5T2
	pgBa6YaPRWsHESBxxDfHJxPlqHq9bn+ujulj0tHxJqJTSWlRHlhcxzytI6WCPoLv
	kG+HeToYntjasRh7yeEovTsBas8lmTfCJ186Y2Ly8apiUj4Kq9KstS3Scedrc6T4
	naMuWRY/qthwcuH3U1WwIqTRGq+CgRDwSMEPFcytV/FNYcL+CjSozVy2zf1bPwmc
	im4TGkK0aqOqBe5TsKb6CTxPKRm22e7REg/IoD3jlQc92F2QxV1vqPRZ28xFsEox
	llacpS9piLmn5nwYmzL3tX5snjpJZPvn7FHYGCGT3RtAo+jqbunuLw0G4EfRof1n
	mCfRKA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqkgp9vr6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:55 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3552883bd19so564022eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754655; x=1794359455; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zy0g99KSmpxnlulEZdJjfjKVXSjdwjfhmOrhoS8xvt4=;
        b=Ju/uNI3CtIgZh4+itVyboUThOvH6DkssuxNrq+xSpTaaFI2/hauxDPxhwB9ToNcIQc
         +0DxhGUqQvjFjDw0NrDHkMJ7BMdSxSOvYAYnKLOacSub85jQlBGBMbOCg9xtXu8PRyyT
         dQnLRRW/D+Oxzabp5HZHvBUAOpFxrdLipariwk0UgdqTlLmI9hKbwLsD3loEpcm2NnBg
         ZLTDHTqf0l3+FQ88fJy7JqZZ3eXLxCOVWBNzByBJ2Pujhq2yDhgof+QyNtcGvZd94RLk
         Lrf/rSEGgb8Nq+G0i/FmL+20h4v0a/dPnSGq6v4UYqpa6je7jMpyB/Qw4AA6pIO7qzMB
         mu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754655; x=1794359455;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zy0g99KSmpxnlulEZdJjfjKVXSjdwjfhmOrhoS8xvt4=;
        b=RsvahW/1a+UCZasYxufPHN8vvZx+Al0sDJNh+WapOPH7qXbhkqXZacnW3G/Zcaumje
         KpVVeWFmqDZ/qE/uiIBA7jPIYlj2bpDQfnI7MrM719BuO20NiT2Nx1fRz1O0IWcll3An
         FmGCGNCWbUa/q/ZmEwSq5fZB4xVMfUzmOSC4LzMz7LkChbcJj2EOMpjz+SEcSvHkTQpC
         YQBM4kSkICex8/4uHCU9Fvq+d7cvEbu1Pmg2CXqtTH//h/PEgfW6DzVsqzb76l5lVFSI
         1mftXCTSt0UdKwjS7cEhojqzuSgf5+jshuVBI2RTeu5mcNlS9+zVPuyuIJTLefIxf5r0
         HSIw==
X-Forwarded-Encrypted: i=1; AKwUvBwRIzn4FUMHA107aHZvruQCLYNFtVMwQuWBaZI6JaYzyNioHI55L6eH0werqbNfMZ9Ajhl7ASdIe1H0WfNHkg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+GijGxXE1lEoBNSyrBS6pOj5vQHI5LJDZ1bMqLYlgDNFBX20sf
	cNw51IO8yfMDeL04u3InLXb/GGlESKfeoWsatoWKXxCkHUFSYrOngEdmjifLSRQAB5UA51yeitF
	60XcPTqMibFaEibJwyl3tW7aCGuJbOOQ+eKI9kRKAU6WQPO9i8/z1fuJ73weRGRWrTvAg6Q==
X-Gm-Gg: AYBFou0O1bd7YOJfDlnDfVd8QrdA0nsDwPLB/fl/oBrgIwLaC9ynBec2sD9lTH/1k+o
	wjLlhe16DEHOebE0wLj3M6UwKkpoQxXVhRxJlZ9AqQku+EZABtt2+0u86k0pTf+aySmq16veKCf
	Pn3LnrI0ppC45Ksp3mbOGlixrwPoBiwhHm3zRBSuR8yqZwHtKXsNNYFMOuXvT6rE0tYkKrpGV+Y
	ZQLE2Ea1MnRvm5M4zQR/YJGa9d1AbEEr5tYhMmgOuxAcHbXqIbmd8CYXlxe+HmrfJjXGUtujMKP
	vlZoQzR71Dm49cBc1+zODI9QkP7rd4QBgcybtvmjpjawbbbXFeuXFUpoobKa35kd9FTVDn/lD3d
	L7btSGYSnTq7lS3eaqfhgItH46BWf3AaaCcO150rq9a7ImIIzupY39zreumMtU/ORp8nVmvMjkR
	ISGJPYk9tJg0XM7/rKHWYOeeOkEOyUKLLMTxi/
X-Received: by 2002:a05:693c:6316:b0:369:fbc1:89c2 with SMTP id 5a478bee46e88-36a4235f4cemr20929526eec.8.1793754654347;
        Tue, 03 Nov 2026 17:10:54 -0800 (PST)
X-Received: by 2002:a05:693c:6316:b0:369:fbc1:89c2 with SMTP id 5a478bee46e88-36a4235f4cemr20929465eec.8.1793754653339;
        Tue, 03 Nov 2026 17:10:53 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:52 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:50 -0800
Subject: [PATCH ath-next v3 07/13] wifi: ath12k: ng: process REO status
 ring
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-7-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX9iVDsHWfjC9K
 GPrY6HfmRzc5VYqOHGZcFt7VeTtsCVHg/uEpq+4p4G/Ct+xM3xOyShI05Y/rR/nbOojq614iq5C
 lgP2UCRcJ/g0R/EU/YaRL3vIMMUq7uhFeg1RsWEDVACP8OlXiFZ8bADlAwzy70gGbWeyDkeEdCd
 LFrpZVCc6uobgMEh0P91Wa2R67CNdT6GX4680wkCCBvtSQGH5cb2fbuaskGpidJJuU87wDPW2AW
 vPfno0M4tQ96OrsDWx52cewMsBwSmSoRyJeVN6g0fbBDCvfeP/V2AyWmq7h53p4EInjgIZLtwoj
 qlDyOQOfERTa8krQwXPnTnAh128kWIvrYChaAumwGJMlgLLQWV86hSx55fRLwHD39J9fepFaFWN
 Sl0tQ5RyyHUEUWS/hLeqSqRyr0ZB+Sf+r+glp3MJkhWp/EQ7mAisSDOZcegKSafAhXoYQvhLSQt
 dvYXT82ieFHWiY3W30w==
X-Proofpoint-GUID: 6uoTzuMgwHzj4qSR9XGxFX9OTJEGH3No
X-Authority-Analysis: v=2.4 cv=Yoya1IYX c=1 sm=1 tr=0 ts=6aea861f cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=52ctRNkheENBddPFvzkA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX37NGAvyZd78E
 sn/F5Ml+3825mIh3Myq7Gkza5YDd5IDLpSp2D5gKOPx8bSwKiu1YQD8QR3xGnr7A73gyKM0jj3k
 Mcuxi6+turLKky2Qpk75uv+BglEgkdU=
X-Proofpoint-ORIG-GUID: 6uoTzuMgwHzj4qSR9XGxFX9OTJEGH3No
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040004

Wi-Fi 8 can submit REO commands with completion callbacks, but its NAPI
service path does not drain the REO status ring. Commands that request a
status therefore cannot deliver their decoded response to the pending
command context.

Service the REO status ring from the Wi-Fi 8 datapath, decode each
supported status TLV, match it to the pending command number, and pass the
complete status payload to the registered callback. Keep a queue-stats
command pending when a 1K bitmap page follows, then release its context
after processing the second page.

This commit only connects the generic command and status framework. It
does not add a command client or change Wi-Fi 7 status processing.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi8/dp.c    |  8 +++
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c | 93 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h |  1 +
 3 files changed, 102 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp.c b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
index dee73473cea9..e89826f33206 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
@@ -498,6 +498,14 @@ static int ath12k_wifi8_dp_service_srng(struct ath12k_dp *dp,
 			goto done;
 	}
 
+	if (dp->hw_params->ring_mask->reo_status[grp_id]) {
+		work_done = ath12k_wifi8_dp_rx_process_reo_status(dp, budget);
+		budget -= work_done;
+		tot_work_done += work_done;
+		if (budget <= 0)
+			goto done;
+	}
+
 done:
 	return tot_work_done;
 }
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
index b75e65091995..632ce30fe459 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
@@ -2210,3 +2210,96 @@ int ath12k_wifi8_dp_rx_process_err(struct ath12k_dp *dp,
 
 	return total_msdu_reaped;
 }
+
+int ath12k_wifi8_dp_rx_process_reo_status(struct ath12k_dp *dp, int budget)
+{
+	struct ath12k_base *ab = dp->ab;
+	struct hal_tlv_64_hdr *hdr;
+	struct hal_srng *srng;
+	struct ath12k_dp_rx_reo_cmd *cmd, *tmp;
+	struct hal_reo_status reo_status;
+	int work_done = 0;
+	u16 tag;
+	bool found;
+	bool done;
+
+	srng = &ab->hal.srng_list[dp->reo_status_ring.ring_id];
+
+	spin_lock_bh(&srng->lock);
+	ath12k_hal_srng_access_begin(ab, srng);
+
+	while (work_done < budget &&
+	       (hdr = ath12k_hal_srng_dst_get_next_entry(ab, srng))) {
+		work_done++;
+		tag = le64_get_bits(hdr->tl, HAL_SRNG_TLV_HDR_TAG);
+		memset(&reo_status, 0, sizeof(reo_status));
+
+		reo_status.tag = tag;
+		switch (tag) {
+		case HAL_REO_GET_QUEUE_STATS_STATUS:
+			ath12k_wifi8_hal_reo_status_queue_stats(ab, hdr, &reo_status);
+			break;
+		case HAL_REO_GET_QUEUE_1K_STATS_STATUS:
+			ath12k_wifi8_hal_reo_status_queue_1k_stats(ab, hdr,
+								   &reo_status);
+			break;
+		case HAL_REO_FLUSH_QUEUE_STATUS:
+			ath12k_wifi8_hal_reo_flush_queue_status(ab, hdr, &reo_status);
+			break;
+		case HAL_REO_FLUSH_CACHE_STATUS:
+			ath12k_wifi8_hal_reo_flush_cache_status(ab, hdr, &reo_status);
+			break;
+		case HAL_REO_UNBLOCK_CACHE_STATUS:
+			ath12k_wifi8_hal_reo_unblk_cache_status(ab, hdr, &reo_status);
+			break;
+		case HAL_REO_FLUSH_TIMEOUT_LIST_STATUS:
+			ath12k_wifi8_hal_reo_flush_timeout_list_status(ab, hdr,
+								       &reo_status);
+			break;
+		case HAL_REO_DESCRIPTOR_THRESHOLD_REACHED_STATUS:
+			ath12k_wifi8_hal_reo_desc_thresh_reached_status(ab, hdr,
+									&reo_status);
+			break;
+		case HAL_REO_UPDATE_RX_REO_QUEUE_STATUS:
+			ath12k_wifi8_hal_reo_update_rx_reo_queue_status(ab, hdr,
+									&reo_status);
+			break;
+		default:
+			ath12k_warn(ab, "Unknown reo status type %d\n", tag);
+			continue;
+		}
+
+		found = false;
+		done = true;
+
+		spin_lock_bh(&dp->reo_cmd_lock);
+		list_for_each_entry_safe(cmd, tmp, &dp->reo_cmd_list, list) {
+			if (reo_status.uniform_hdr.cmd_num != cmd->cmd_num)
+				continue;
+
+			found = true;
+			if (tag == HAL_REO_GET_QUEUE_STATS_STATUS &&
+			    reo_status.u.queue_stats.to_follow_1k)
+				done = false;
+
+			if (done)
+				list_del(&cmd->list);
+
+			break;
+		}
+		spin_unlock_bh(&dp->reo_cmd_lock);
+
+		if (found) {
+			if (cmd->handler)
+				cmd->handler(dp, &cmd->u, &reo_status);
+
+			if (done)
+				kfree(cmd);
+		}
+	}
+
+	ath12k_hal_srng_access_end(ab, srng);
+	spin_unlock_bh(&srng->lock);
+
+	return work_done;
+}
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
index a05ab2f4495c..10940dd92a62 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
@@ -191,4 +191,5 @@ void ath12k_hal_extract_rx_spd_data_qcn9625(struct hal_rx_spd *rx_info,
 					    struct hal_rx_desc *rx_desc);
 int ath12k_wifi8_dp_rx_process_err(struct ath12k_dp *dp,
 				   struct napi_struct *napi, int budget);
+int ath12k_wifi8_dp_rx_process_reo_status(struct ath12k_dp *dp, int budget);
 #endif /* ATH12K_DP_RX_WIFI8_H */

-- 
2.43.0

