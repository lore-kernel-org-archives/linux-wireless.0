Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F0D46D2D9
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811322; cv=none; b=E1Kr3j9Ok5UshaT6HBmdsNHYIhZ2EcetKOSaUZgv1y2XpTNiNYLVJ7KaN5+9IUArPDC8uEogR2zASjGAaMAeMSKdRyIFC7+phQgSW/iRgqMyNAFv0sl31b2RGa8XestHvMGeLyn2+b6jM20XEaZSZFpiRciqFMnJ8kw+LumQlpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811322; c=relaxed/simple;
	bh=odwxuOekoc+zO9h/zdCy8yph10DtYb0tXzVbi97s394=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lDUEN2QvMSHnu5hA6A/YQINr8TG0kYYeMmev4A+xleytn6nmxNiZ0jWf/6LxyOlV5OTI1HdR+7TlSnVz57K1pmr6G0+AvJW0GOThsdX5QnDk9qYjOREn2JK72Jz9zpbja0Q11UbtyfcXdBEdLLUEFtKpKebvtDuplh309nwsSKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BZ4FSeCO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HX5YLoLj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BZ4FSeCO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HX5YLoLj"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NC68Nk3833498
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=tMcOCwt1ZvE
	9PJStXmqvrv1ScY/szDISa8XqOWErWi8=; b=BZ4FSeCOYcpJ763vhRrwrlDB0p3
	TlQSwQLFgI0kK7qwyInyFwylOachrZhvvfqPq4vO7jJi+2dMHlBGD37Ok2ozSpPo
	ZQzYq1zBoV0Pag7nk55LrlaGyZWbrZWp9ro9YfFaHj0RUlqI58Owl+KXwsKCrhcQ
	mwLQrVAOkQqAG0d7cSc6Kqip6ILSHQ9mlcMF4lC4rm0r3+j2BRDP4VnK/SVvZxg2
	ONveYph0/frneJ/1FtEpz9Vqv8MPas2+CYcA+u1bNWdZP2Z+gkESk2WlmnfB3fPc
	JSPel/Epog4xMjJuDrbiDu6f61rKqDRmUpz/4mYnrZn9FokW5jkvL3m4KYQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkjnu86ah-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:19 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccafc5e82cso10852455ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811319; x=1785416119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tMcOCwt1ZvE9PJStXmqvrv1ScY/szDISa8XqOWErWi8=;
        b=HX5YLoLjkO3QcS1CRw3m64mhQ1JUxVySUtuUo+iJca3ErOhsOPrKBNsVVIxT0XSQYg
         jrIap8G4N7q6Frn5UyNn5NMc+6mxi6MgtqS9WunQQlz+jyDASqMLZrTqYkOtzMULiacA
         80xXNG6dl3B//yBfZYhKB7rmKEDAOZSjC3uZoX4/7Y7aP5c8dm5vg48sNuhUo2jA54ls
         Nh+DSHhUqIciXWsguIO21M/79QPzzmL/At6nyihEuKzAeW5YVFyIQkPK7oNt6c6nHC+Q
         nZHLkTXgqNgR+QpCe9yilg0vs6OQ6DI0/Wi3cXuVGlQLqvKufhRJTvH8hiOgSDFM+Gkc
         Gu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811319; x=1785416119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMcOCwt1ZvE9PJStXmqvrv1ScY/szDISa8XqOWErWi8=;
        b=cy4MqR+DhNAgDFdNMa7Gn9VI1wwI5EON0nxmdiCf2TkVTIftt/ZIdDKfTYw6RAKQBb
         C8PZrmCKFlFjsrlhfaELAp9JcuZKLlDXbj0+euq/LD1dz9k+SGNiqynXfOcd0Yt0PuTL
         ejqPnyoyl9IM8wXOIiS8NQMpsXdHpARnAk2ueqFbdNv/U+Hyi4PyMulQ0GkSG6fksUCQ
         IMX0UKxx0Vh4kVewD/eXFAvxyS6NwCg9Ng1A9YlBQPiXFZnh/+UilGBg/WYlUdtKmFtY
         EZ/jK0cNtDBQZg6pHA6BOT62N1ci8bvaJJkzI1iwHUnRaWHUawcrgFS6itTtLrTZMGXU
         0GNQ==
X-Gm-Message-State: AOJu0YzYlnjDuvkm+p97xPuBkUgKxg+zVIHTiyGjgyUJMUouNjFANxmq
	x+e3sy8lONbbQdWlkcXeNNYZlwacMlNKTVSZiUig1dd9KN6TFjxDqp6dcF4YrimxUDbIzycdGzX
	4KVkOk6tc8Zgi4if+tf40d664/Kyo+EJBj5EjZGYmXG7Eu6UOmfNAeV3eHxPyj5hXqyVXiQ==
X-Gm-Gg: AR+sD11NiqL20rOuFwZm6huARKYXu+mtWDfjXGh1MsGDoPkqDTlDcUvt0l6ZJDb+GfU
	MYWid2sCDA3oz0nvPzirvruuaMa1m5U81yWMlOzpOmp+soHZeIaCKohysy07tE6CQO/n5xBXD+c
	aEoi7AX800YPGw0TEOpgYdoVVRq3DwiO7YRX7w7cIAxekMwEh1Q8218wPFJmuDeW6Ol7ca+Kh1l
	zJ0BJfszjY/ekNaTJViz6Qn8ozS1VPyMyPKCwhbAMQGM7NZTPfEkuK2zNIuhS7PQWt+k+anjuUx
	cAmsNcTCfdPsEZdHEsCC7GaAQJgA0Gcjq3l111uB7NOXvhGKA6xChLdmWsxcQJNbvA5zt45bfKe
	Sw0Xh0ZuLYFN1+3ygVWspB3nrrpAWSY5Y6rcsVphhPkrgov1u4N+t
X-Received: by 2002:a17:902:e801:b0:2c9:8f4a:90b with SMTP id d9443c01a7336-2cfa6a54e47mr35342705ad.3.1784811319295;
        Thu, 23 Jul 2026 05:55:19 -0700 (PDT)
X-Received: by 2002:a17:902:e801:b0:2c9:8f4a:90b with SMTP id d9443c01a7336-2cfa6a54e47mr35342435ad.3.1784811318784;
        Thu, 23 Jul 2026 05:55:18 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:18 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Thu, 23 Jul 2026 18:24:46 +0530
Message-Id: <20260723125448.922361-7-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nwarKCD-ov4Nb5MZpruvolKsbAftCBeh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfXx0fTjh2LAeGJ
 pnNxzx2fQYX/Ug2Qt9B/jOOL07umS8mOVwmDD/vhUocikTq0i6QdlX8eVr+dC1xpDl+/SAgIUS+
 HIbAVgCaNsfQb0FLjBY84wdLgOG9AvdRZ48SNseHbB0IWB5HjORL18QM6raeSVSrqGR4lEEBcNK
 pYnpAIZCbSxbzSOgXv4C9yA7NMV02KazEIryhx9QiDkj1vkewMrc+/Y6XrSEJBBSMcICgTpg8Yi
 yV/qIrtWJIemd4exUw3Tst6bNoElohmubXCoZY8tlgQNOcsUJp5i5cOrmpOjHWJA3WlSJ+YRUSQ
 Fz7vK7l44tkRUDiK8FyKc32KmIItSTrUtRUdMewRcyoOkwGqCaNNUWZOjrFDKBN1/OAJJSr+W5p
 l8aYX7TPbbjqz0ffTCdSqYuEwqwq2bfcXAzEdOt8imWsAGiIUixg8+3kPtrP7rrfQXKZp088pO4
 0Y1bP0TmC/aJ/2Jpt2w==
X-Authority-Analysis: v=2.4 cv=Een4hvmC c=1 sm=1 tr=0 ts=6a620f37 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=p327RZGb0tc26PMrpC8A:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX4+YDzC7Yx1F4
 8uHErlQ4VKC6OnyVFRgo84sYoDV8DHlfYp2sZZs1WuiNZAKhpRo5NDNwku6JSgLiuSMyxs37g01
 eRfDIa4e7cTHVpucT89tcw5C2pT09s8=
X-Proofpoint-GUID: nwarKCD-ov4Nb5MZpruvolKsbAftCBeh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The device DP stats provide visibility into RX errors and drops but
lack a counter for successfully delivered packets. Without this, it is
difficult to correlate REO ring activity with actual stack delivery
during debugging or performance analysis.

Add sent_to_stack[DP_REO_DST_RING_MAX] to ath12k_device_dp_stats to
track successful deliveries per REO ring. A per-device dimension is not
needed because partner_dp is already resolved at the increment point,
so the counter is incremented directly in partner_dp->device_stats,
attributing it to the correct device without an extra index.

Increment the counter just before each MSDU is handed off to the stack
via ath12k_dp_rx_deliver_msdu(). Add a likely()/WARN_ON_ONCE() bounds
check on ring_id before indexing sent_to_stack[], consistent with all
other new stat arrays in this series.

Expose the per-ring counts in the device_dp_stats debugfs file under a
new 'REO sent to stack' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 5 +++++
 drivers/net/wireless/ath/ath12k/dp.h          | 1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 5020d9608535..9a8d07bfb848 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,11 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");
+	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
+		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
+				 i, device_stats->sent_to_stack[i]);
+
 	len += scnprintf(buf + len, size - len, "\nHAL REO errors:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 563aa24ea55a..298b65142a0e 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -457,6 +457,7 @@ struct ath12k_device_dp_stats {
 	u32 tx_enqueued[DP_TCL_NUM_RING_MAX];
 	u32 tx_completed[DP_TCL_NUM_RING_MAX];
 	u32 reo_excep_msdu_buf_type;
+	u32 sent_to_stack[DP_REO_DST_RING_MAX];
 };
 
 struct ath12k_dp {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index b203513d63cc..33c4c89eefb5 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -651,7 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			dev_kfree_skb_any(msdu);
 			continue;
 		}
-
+		if (likely(ring_id < DP_REO_DST_RING_MAX))
+			partner_dp->device_stats.sent_to_stack[ring_id]++;
+		else
+			WARN_ON_ONCE(1);
 		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
 	}
 
-- 
2.34.1

