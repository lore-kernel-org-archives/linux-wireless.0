Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1FA478859
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018204; cv=none; b=MIo6qPGlQmFBy1PLMspJ5p/g8as647YK4a/zewnOoOvVGjAO4ce4NbJ5ZOQbCjyPFHJ1s8PQawic3Wqa44fTtPW3LojTYKkkC/avgBiqwvjniGCfqOwN+UVePbSeCmqJwsGZLrTIt7p+7pgSGz1SUJ4B7iR9uB5MErCHswFZS2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018204; c=relaxed/simple;
	bh=dmLcNqpwaTTw3J4bPmH0ozGrdD2cE5lZcumPOk/buMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MU32qYQJAu8p5+HCk3NM+B2VLHfBTTx8rgEUpHk299ebMsNCJqjWcBho1zD6ZCrjYdC2ysOUkF1ojAWiYE9ar/kCqDfwsz3MALS6N+Nu1DThQi861S6lD7jh2wangVLryj5XJc3yS/hB4qtuI6oSLXyj3uMuD/kti/IYz7WTglQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JF2Yfd86; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T2MawAgu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JF2Yfd86";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T2MawAgu"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nfvd865623
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=8D0xqCaj1qh
	JnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=; b=JF2Yfd862DEkF/WYRf1efAxJ9CX
	ORF4lmwhbZ6rw/7+rb9kP3TUOKF58CaXowZjTmoUi7RvRdO0wKTwpD4r6X+qxlvb
	Hd140p5Y0wlx2t7wgia9al1T/jT5mvFfMVB0US52p/X49QJz+qi5Ded+Mly1j0To
	cQSxSXczjsO8PdHkHQwW3Abva1CEHuDt0UqbKWZu4RA9Ecs4uQbWptlGS9tuebQU
	BhPGkIGRIUlSeDlwZJi7Vq3ty7koWcZ8JVlJBMwEus6UtotB6AzUcKcWCZGu9q3b
	7+2Ot6ngLXN858VpH0FVz+5AxlYTnvatgCTleP2rntfBGMBHDswZKJ1p1lw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv9f5c4x2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:10:02 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so2317117a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018201; x=1786623001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=T2MawAguOAGIWNkBBBZEpITdnm/+dbDoZiEmGNdmLuF/+nv5RxXgA4ptbcY/wtJmGj
         wMQrVE6xDeVXTjgg9r8iYJGnuV8XgfXbOGwuvgzkJa5YaiIgZG3aspkjLyr//d1wv8Tz
         pdyeUe8jcF8c7CocVzJyaXMo0jrD7SP6FqBFBH4mtuDv+iDd/6ejjUL+4Mozdn3jQeJN
         hv83iqU3QxlAyBrh4X4mMgyE3G4Wm4JUwTMttVd3AZdVwjrm7W45PRTqH4cNw0XFut4H
         vtZl+OSQlrDegFYy5J1/myzJdtz0N2RnD76eQgWSOpzn2AubqO7F6kk/oWYssHEcVXsh
         oNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018201; x=1786623001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=nznm03Va8ee34ZIH0t2DlLMJ4Caw3y6YnbO6QvQXEevPonBBWPu6xV4wyybUox3GTF
         56iiikeUGt4VnegkNkq3R0CRGa9m0YYjSQg4n5K4ktNAzom5vfedfVAj1ntS5Jif1g/8
         fdLC/0rNabI8V0k34mKUo3a9k2/FlsPG/40B57KiaAXutT2TBAg3EMzp5aBLYNtC7RAp
         eMON4aqEyXy+E2Ycpd4RCACfdTJqEGvSWtFlvUYwW+KXNbQQRXmeKNP2nwoAMoS32rmb
         xbqhddqfirYOiUHZpcm6NxrxwpYsQr106LeVYshglfZSf9/e4G9GQOoeZfs4Z0iwLYzP
         feSw==
X-Gm-Message-State: AOJu0YwOErdNlDbbzgjn5qQeaOFCHe2rJ+0SUTcwdwre9yNbSidGeUSJ
	C/Q/8vKuZ+v/qxZ0TmBV8u0y3BK2H0oiDTTDjZ1TFwK98aBbmH6ntjmF4LUiix73ZAf+9XQJFTd
	fFgQ4dtf0y8NfBJ2njMv0NL7+YLnMl4hY4umf3x5uZPd6ZecYpN9Ps/nKNXIEbxyzfs5Lb2Rrdx
	mMKQ==
X-Gm-Gg: AR+sD13KlyRt0VWh0po0oJJJBOzH2QHMZbNbgNDO8cgKEtYNkpN5PErZw4lyyLei+ZA
	R73poDtX9J7MN/cMEP8guppT9YEfUlomYMoAjmh8hkMFDiarlh6WsBJJlXiBdubXfxI96rtd45g
	1y5mqvYexqksOgXC055XMVdti8EupzjMTU+9UoxAsvbVpHhioKWk6rqyC2b7e+2fYnAsC2ElqaB
	4s/ucI0iwP5p7m9Lhq249U2sJIgOGUoKUphnUhmo1pxYfJVQf5iDJxmJF1gR4RZFcf42szSg9Oi
	mFY+65eHaYhrpPigjICNPcQZ18VgO4HVvwNyS9mDL6Hy/Kdy25BJ9PRg90oauLlV1T2aQKp21Cm
	r9sIk84zC/tRefmrm6S5A1Bj1utYtnDC4pWZCTSwOlZrAUXPxUUwU
X-Received: by 2002:a17:90b:5251:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-3903c595143mr13898547a91.11.1786018201396;
        Thu, 06 Aug 2026 05:10:01 -0700 (PDT)
X-Received: by 2002:a17:90b:5251:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-3903c595143mr13898471a91.11.1786018200879;
        Thu, 06 Aug 2026 05:10:00 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:10:00 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Thu,  6 Aug 2026 17:39:25 +0530
Message-Id: <20260806120927.3607733-7-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CQ1FcjSFfNrukpjIepN_-uZH1s0H43Oz
X-Proofpoint-ORIG-GUID: CQ1FcjSFfNrukpjIepN_-uZH1s0H43Oz
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX61xBidXK+jV3
 a2s/FibjTI8m+lbVSTKn0LXtSyZqOSn2KI+8tKODsFs3Mn2NR4BO4f975dEiAQVHxXNAqgbJYi/
 o072J0Dxcyx4gs0diqt6JJszGGOeBn8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfXypd2e7IVxXDU
 8DKoZx3EAEhxyHPfovkxjxLntzA0dQkiDA3DwoEnxELXJZCXUSH8AWSr8RovuYz9lrav+U3Ye6a
 vwTwmrUpi4+9OBJK5PrSyXxBnoFH38avHceimnaoe4+UF8lZcHS6ZWSLDgC6KK1i4CVMdBpzNsl
 eUb7VHGjHuLu3hA0znVkmjKBSV1Mrr2+zmvneLHy0+0p3QcPA+dxsDg1ijWeKtbQMr3bqt4YpBp
 LahxAiU1xukH0u/jN8v4yP3Zlrmtbzy5tN6D92MbyWVAvjmsD2maZWrA9Z4c1BJgk6MtyrOB+TS
 p2Y/QwI7CWuh3eGYlZVYHRYTAv2dBeirfI59QNNTXKb3g0ndHtgFQsFaVPJdgcsY7Ak43aUbT/t
 VpKZzsrCjiXSA5KQefhCTCn1ZVqeWRrtOF193zGEQIKzyeIKFnVMtfqr3AHzWxpFgHSbvummcgm
 Zo486mhk1igAHlJKGDQ==
X-Authority-Analysis: v=2.4 cv=d4bFDxjE c=1 sm=1 tr=0 ts=6a74799a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=Ga8fF9AItmT7q7bL59kA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060095

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The device DP stats provide visibility into RX errors and drops but
lack a counter for successfully delivered packets. Without this, it is
difficult to correlate REO ring activity with actual stack delivery
during debugging or performance analysis.

Add sent_to_stack[DP_REO_DST_RING_MAX][ATH12K_MAX_DEVICES] to
ath12k_device_dp_stats to track successful deliveries per REO ring per
device. The counter is attributed to the ring owner's dp and indexed by
partner_dp->device_id, keeping it in the same debugfs file as reo_rx[]
for direct comparison in MLO configurations.

Increment the counter just before each MSDU is handed off to the stack
via ath12k_dp_rx_deliver_msdu(). Add a likely()/WARN_ON_ONCE() bounds
check on ring_id before indexing sent_to_stack[], consistent with all
other new stat arrays in this series.

Expose the per-ring per-device counts in the device_dp_stats debugfs
file under a new 'REO sent to stack' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/dp.h          |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index f9653fb7b038..216a1af22898 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,16 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");
+	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
+		for (j = 0; j < ab->ag->num_devices; j++)
+			len += scnprintf(buf + len, size - len,
+					 "\t%d:%u", j,
+					 device_stats->sent_to_stack[i][j]);
+		len += scnprintf(buf + len, size - len, "\n");
+	}
+
 	len += scnprintf(buf + len, size - len, "\nHAL REO errors:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 9b57b2170b60..5cfe2096c633 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -458,6 +458,7 @@ struct ath12k_device_dp_stats {
 	u32 tx_enqueued[DP_TCL_NUM_RING_MAX];
 	u32 tx_completed[DP_TCL_NUM_RING_MAX];
 	u32 reo_excep_msdu_buf_type;
+	u32 sent_to_stack[DP_REO_DST_RING_MAX][ATH12K_MAX_DEVICES];
 };
 
 struct ath12k_dp {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index b203513d63cc..60489cfd4e54 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -651,7 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			dev_kfree_skb_any(msdu);
 			continue;
 		}
-
+		if (likely(ring_id < DP_REO_DST_RING_MAX))
+			dp->device_stats.sent_to_stack[ring_id][partner_dp->device_id]++;
+		else
+			WARN_ON_ONCE(1);
 		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
 	}
 
-- 
2.34.1

