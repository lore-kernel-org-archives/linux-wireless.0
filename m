Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07310439338
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010887; cv=none; b=rdSIXj4UZ6N/vPKMgmcSdRJf2wPPnLf5K18kJVceKIHZh+1qtTEC4lLamtDZZnnsi1GO+ABXrCtA1jLtVH+TFi6uC+sCEs0LDPmvUs7qthRak/wk5Ywpmw6A1E2tIqtgbwueTF0oOX/856ITbDGqduAamWpDFKO1u2yH8CRx2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010887; c=relaxed/simple;
	bh=5R0o7JFdqMZT0nInBj+pnct0Yrk2mbMMG3WHPWsgUGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8gx9TPZ/iFvXhtpSWUqVINdbrIT+dtRtH49ChLZb7jnyQaK/GIOKZeXoG/I7PKqNguyDRaJP1WZgnfAEyphhtdZzxY2t77xtpt20AQWlwSfqhN2x3tTSh+tAF6xHoeyMa8dYF+vvajBEpqm7hgL7XTgQHSBjRmvrJKsCOtfriM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AsS5Q0U2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KvwKx442; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AsS5Q0U2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KvwKx442"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ncnc1308825
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=f+ExpY11XrG
	NkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=; b=AsS5Q0U2JLPQ3Li5tl+qfX/o/hl
	OLCc+10iGdtHDEPAkosrGc69qmZ+UK3tbQK6rxfw4A+wWGpG52hiJvMl8gjukMmj
	Sg9u0cAp+2j2dKKH4+EJr7Ow5H5Wlje2xuC+Ehxddbc1ocEiMUBUi15iClRauAsM
	TG8fWmvlO/iQiWLQg5VMMtOPp0FkCypvYGKV807UWaPzStgGl6VWzWbGxI108D9I
	ghPByWF4eqHIH8gYr/4N6m2hQVZNqWimanWNhFYnxJ1KW+GvnBXXnLzMX60aiHjh
	MpS5UVHZr07p65/t/SsvTWSwL04PX4iaDIJ4cn/Eh5SKYmgh24VTzJiKiHw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvp728k0n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:52 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc5faecf01so38956435ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010872; x=1786615672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+ExpY11XrGNkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=;
        b=KvwKx4428uY50giJMvrffbB3KkRjqmQ/SK9Eb7AY1/DQC/YMqiVBZGf7hYQe/iRfdS
         ypUUwvmRboylMl3slOHdxFnCK4P222KlFPZ/dOLbusZgH/4fb0vtNG9dOPeveRP1XrI2
         GsPYYr8j8wDFdKWbByM0uOZj+hYvBwKbmrOnKN4zVwm5uinUUCKsTc4pTTnc92CbD8AX
         itCzvhJbsA9QZQVQNwq1PiNgOJcqt7rCnJAT9G3xmypbio45VdLMhTEId5GUI5QqfgAX
         OoDDeQSNn+e/16NjX1dLEDi68GJPxHl7CzjdEIh0VnHMnOWqHmuypZ/j+HGvplWVwNWs
         voGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010872; x=1786615672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+ExpY11XrGNkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=;
        b=hRnWVry6izkZXcleOvSU2xYD17xFDEUPYEBOjkLRliO/rz8VcGtZFaZf5EIbhTBAeD
         0A0TqSzdiBxjGf3BdxXFAdufNjdGVOy/lBIMOLhy10IjwGAHibLm8D5+KbIBsDZ8FxwV
         9iH4ED2f+dnHqNX+WpMFsJJ2X/5UhjqA3wdnJGprmcEXEoLqL8ZbhncnQYnCHQA5fqt8
         6VR3K0FuvqzPlod26ocbAYF5HsPctAiYQ1uvLqe9DcqmuyOn904dYGtPFaS4M6BH0dgW
         b7q+bzGMS3fZLiIb8nkGTz2+ppt2+Fr+XFR+/22YgIqCLmZ8884tyjzFflsOsb6brGr7
         snew==
X-Gm-Message-State: AOJu0YxDANuHwwXsFobRH7KmsOBismrTMbadB9J8ldSX4guonBba05hr
	gCMmd4QTfa5i8NcOa5ta3J/B+iYmq3s0RIl6LKvghh2xTULroaGPLrpWWYgGRdQafgRa1BHhPqc
	R/TwmMGen7VeEi6EH/1J7fnvtbBD7WoD+qf1BetvpKfgdGatmT+pZ3XEXi+6IoNG2auzSdA==
X-Gm-Gg: AR+sD12jk1Z89GK6ivKqsMcNuqAtIgsKCVah+20ed8dhSn4y9qgB79ZHCVO7JMXigWR
	G7dAECtp5Cpgo3oyM4gDfXJ11/Zq3bn46Pr9zDgFUr1+TR08KPEFDbZQ9igkEvhYDH/9yg0nK2c
	C/JpOUt5qruKfaT5kA0ATbHtcKlupVJ6QJAGQ6UW7Po5yKPFnfp6W2vg9kxJ/Eh226Ek2nb8Az3
	5Ew761418RYIUE39gcG/j/tLOvYRtEMPqEOcNqnvgeoBpdHBhIOfjj2qz5GuHkCHFyNunq8R/Ke
	0qTAhmrkr75bfI/C9tLtrIqhgg799pYMAja0zvzIqqcVBkbfbFbMi3/ThDi6XK9S0fMcaycRd1j
	IM5MSh763S+aIivi8IlpdDqNVuBjnmrWAVKyT1uLYWbl2fHDktK6m
X-Received: by 2002:a17:903:2312:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d0ca7fa497mr144437085ad.9.1786010872005;
        Thu, 06 Aug 2026 03:07:52 -0700 (PDT)
X-Received: by 2002:a17:903:2312:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d0ca7fa497mr144436505ad.9.1786010871464;
        Thu, 06 Aug 2026 03:07:51 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:50 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 8/8] wifi: ath12k: add WBM SW desc fallback counter
Date: Thu,  6 Aug 2026 15:37:02 +0530
Message-Id: <20260806100702.3479326-9-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: _LhY2WjmG-qoWHNhZZsEuCguqIzBQ-ws
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=6a745cf9 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=7LnAo4KMM85IVg6JStIA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfXxBfJm3BGzvsh
 y9uYS8bdLlyzTdH5vQqsw5cCaQh3ADFa4/e1QZT3xy3ANU//JlDCfSIWsUq/LCpXTtgtoBsmYnv
 S3bZ0RJa1EjA5fZ3yWmhCAWXxZhvuQlbqXXCE7ZfscS5hOLMUC2viuoD4IP1IGryK8+YJ1FAGvo
 vsT77FrQnGDjr+I7aXUwZyU+RcfxsxeQ0WXeW6+NvXC0UEN2fjld8zvw9VH1LpcdOU0VTF3qTCd
 7kBIQLjNzduV96W2urO4ZLk06JMaL19JElklE11RyI4uCMknl83SB56GiSYllL0BaMUt/oTdAkk
 7ygvMEqy77/grFy4/ad1NeEMh/Pml89RDJrimTayj+aLUnA0lCPe/wfklnr8vNapnEWr8Cmrx+f
 4TyL/0HUhauSwgu+E9RUG0mA/XR2mdm83Ig0ikJ+G7CbmZyzgOljSnywYdG1fP1RRhyPxFYVQPk
 nHu6I5SOn7Axkccfrfw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX18jQQZ3dsR2F
 qfOvqYMEn/1yxiRsOUd2OcWp9oi+Y4nRANX94IsrXSw2UKQtUpwm3zROAM8LQDroqFXcq7Yklqm
 b1Rrd1T5celJdCNWiYj/aPipk+XhKr8=
X-Proofpoint-GUID: _LhY2WjmG-qoWHNhZZsEuCguqIzBQ-ws
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

From: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>

When HW CC is not done, the WBM RX error path falls back to
cookie-based descriptor retrieval via ath12k_dp_get_rx_desc(). This
fallback path is taken before knowing whether the retrieval will
succeed, so it is not a drop event and should not be counted in the
drop[] array.

Add a dedicated sw_desc_fallback counter in
ath12k_device_dp_rx_wbm_err_stats to track how often the HW CC
fallback path is taken, distinct from actual packet drops. Expose
the counter in the device_dp_stats debugfs file as a separate line.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 4 ++++
 drivers/net/wireless/ath/ath12k/dp.h          | 1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index d4ea21aac21e..ed7045a2a380 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,10 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len,
+			 "\nWBM SW desc fallback (HW CC not done): %u\n",
+			 device_stats->wbm_err.sw_desc_fallback);
+
 	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
 		len += scnprintf(buf + len, size - len, "ring%d:", i);
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 5cfe2096c633..289aede6dabb 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -442,6 +442,7 @@ struct ath12k_device_dp_rx_wbm_err_stats {
 	u32 rxdma_error[HAL_REO_ENTR_RING_RXDMA_ECODE_MAX];
 	u32 reo_error[HAL_REO_DEST_RING_ERROR_CODE_MAX];
 	u32 drop[WBM_ERR_DROP_MAX];
+	u32 sw_desc_fallback;
 };
 
 struct ath12k_device_dp_stats {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 60489cfd4e54..d96d8301565c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1968,6 +1968,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 
 		/* retry manual desc retrieval if hw cc is not done */
 		if (!desc_info) {
+			dp->device_stats.wbm_err.sw_desc_fallback++;
 			desc_info = ath12k_dp_get_rx_desc(dp, err_info.cookie);
 			if (!desc_info) {
 				dp->device_stats.wbm_err.drop[WBM_ERR_GET_SW_DESC]++;
-- 
2.34.1

