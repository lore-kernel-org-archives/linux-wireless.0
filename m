Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4A1C5D59
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022689; cv=none; b=f7AlFrgLnA53UMkLm3Tcrj7FOUXK6G7CUzkQkDfGrYq+R+m0G4dxu7+VbBJRxvM6gpj8ipb+ux/Z5o4/2MiANe+00J2sQL8s36wvQ93YHVKcOcKzsKvoKhh6rpuzN+nnOZy9WujrnwgRmzH//stHezHSSZSL8Dp5KMrtAjTAqDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022689; c=relaxed/simple;
	bh=zkIyrD0LtcKmokmX7wJVEdwobsTHp2ekxdppZlTjbV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PFZHFzHMpcdq62PcZF4S5hYtUA32XyFCAFnUovQTdfZ6BtqeeD3O4E1yJRctmYrpd8N7gkn+nHGO2T4Z/lPGuCDZvTiDaPMOUQYg+TQcdY4QJWeJT3iAGVTRvrg40Oy/9qhcK0qKgjP9O0XOsOg6sGA0mFeY/njdkSeT+aYY16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bh0ANqBL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZU9mughy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bh0ANqBL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZU9mughy"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ne7W1625703
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=NA8MWFLnRkH
	6OIWjAyG2+978gj5PqzR5yRejjiikDww=; b=bh0ANqBL6VcwqnCj8q3n2peGe+I
	O0njxveBVJO86GtupCXtMynjMEuIQgKSDdwXnWc2XxbDqeOEdtzW2a9i1QEdqGfk
	THAGY1wsyesWPiYtpfRxF88wKRMxYDaOiVJZwIg0fzyQbyN2PqbnfE70kyCx4hXE
	E2Tw7ogF8mbTqlmv6hZh+C2WYj6g+vYiPVBf+WMPk9TKaePZDKjyJ/E9XhNvbjE7
	hei+EkOoCdWcvXINwqA+4EZXyrCqUbdm1pe8c8Zkc0LaCwUN3QeQUDkvbNxERFdM
	V4jz4gE5NZV5a9c9yIOBrNhzJp9PXrH08SHw3Jp96qtAoZwTFb5sStpeq2g==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvntnhjmd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:24:44 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8488ac68185so5416683b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022683; x=1786627483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=ZU9mughyK70ktlEzQ30P2LKufSUSkFWmTBs99aJfqcjE8NY1eOfioou4AhNMghIXIg
         qSgBpxxhdyzsdOZToE/EVXLuxYwABRYN12LGXtyO8RlkwQtUB/gDDonQromGzPhXDD3i
         vyAj96XIUHZ/kWbqlyqJb30uxLscshHoDx9g9W18vyne4iXiRfbkOarOUVxTT1CLIJEV
         eylXOsO9ehEcLj1XCNLiVvh/Wt/bTUkBdFNJV9DEXdd5/ro0FBB7S5flrmKPS2cvvSu8
         4yapDjk2AaJZyc3fhcPZotklYosvQ2efGPVmhomF+Z5ihgebE9EYlLSuoughZr2BeFX5
         OjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022683; x=1786627483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=kiYS3/rXG1kndu4Zcq2p8PyZhQA4kk97stuOeKJyOzKKhYc/80GooFLZAmYviKzfIp
         SZHdry0n/AqJ4gK27Td2wDJ9Q4rGg5+qV+aT3Sd6V1PIMN0rqPLhGZWRRFPGUQBC6A1p
         FUp15v72hI2ZkO40fUJQJuOHWZdHjyjSDZS3H6FYC8G8g/ugt8Ca2B1yFwT7vlGwZzEr
         NhztGmJEbVYs2rrCDdKp0fI7nQB5C+brC2tmHuEGjbU6vYTwiYSh/+hZ/Jszajt49qKK
         yDwaDN3o9wb3ZyyC1Z/wuchMCSVv1IWGCf2KAx8ocAC0f5VEbYITRK+R1jkXi9DdlX0W
         g4gw==
X-Gm-Message-State: AOJu0YzoPu9OhNWWNx7IQGG1OR4+nL9JjSR9jZpikQ9grCJoaPnKkPFV
	zt05g9lQBQxoo2O1YaWUDcdXw0LvALMGnImX3jeFfBTLKtrqU4syRqI5E3c7qF0pB0jnlMZUrKT
	hdoPek7hMelauVn2NIvV3ulz6GLy3vRKm62JttbgUL4CAEyU5wsn2TOOKcnvOabsj6zdtUN553X
	HnQw==
X-Gm-Gg: AR+sD13BhaGW7QZNBEKud1N9e+igQ8xE0euK78qNQLVwwFVzams+TRVgV+eCcNmRsB3
	Mq/Jfw4ZoWnq6V2jcfWD7jphmzbEs/cert5PFiq2MHHd3AE95+GDakBi+HJhFiHN6wXJ04DLI1X
	17oO6r+XY24/yKtbWmRyOrAhBVvRKBcYVed9FZg0BrL3HjfNGwJ7BFhrVT8NAyHEXupyT3blmZp
	GuxSTevNKCh3hgt8xmyuhJjS9HQauOsyWx6alUCX4IPpSB5804imISJXhC5DjNdRNxWHPcL54f8
	AJB6e3tLrkfgzurOKJ2RdtrgwuW3tveg/7v4eWhIWPANPvMdsFGyn/0xFcqfpH9DXovAdzVQHV9
	KQbt43gituyo4H1JBrF6D7DwTlosOcNqv4aHFU34XOewah0qPd+yQ
X-Received: by 2002:a05:6a00:a90e:b0:842:614e:cc94 with SMTP id d2e1a72fcca58-84f2e0555b3mr17026920b3a.26.1786022683542;
        Thu, 06 Aug 2026 06:24:43 -0700 (PDT)
X-Received: by 2002:a05:6a00:a90e:b0:842:614e:cc94 with SMTP id d2e1a72fcca58-84f2e0555b3mr17026859b3a.26.1786022683137;
        Thu, 06 Aug 2026 06:24:43 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:24:42 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Thu,  6 Aug 2026 18:54:21 +0530
Message-Id: <20260806132427.3704828-3-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX1TxAPmttSzkb
 1vyX/BXKdCJTH9JeNFQma9op39VSNFynZCg+iGfryPXDsQ0E2YII+1aQMMIE4r3JH22WH9ihIPH
 w40Cuo/oIJPck/bxwYXXkPDpE27hgBmkm9idQSh0QZXavQBhHECIXiFGXSs7zZHoV/ifUvGRl2n
 PGEy9S/AQnUiWJOGdGI6kQsoWZpY+nijhyKKZVLIo4PWouCXk8GXRbjenx5LDzNiPHUFDOi7Cvq
 gbaKHVvBG6qXP05X9ZQAdwKO7CFh2ZduMYT9rNvG3U6qdBZjb3Iz6wTgwfb/BZuD9EV8SmUhgoW
 /qU0ZxxBoNB0ZU3sD8PASR4vBVW8uPq3DzKqh7mGuU3fKSmdAPu4nKBGL0sMwJLZ4rc9ngMHRFI
 qHaFyzNaOaQ4KMqFkcs1CIRAHSnynKFxd/31JB0ra3f8slRDCQeGBhFYlqMHpZtDxOkyY/B9mYK
 KI+jmT9etOKdYcghARg==
X-Proofpoint-ORIG-GUID: K751CoSu6XaT0Qz-IfZdkK422F8gGrB8
X-Proofpoint-GUID: K751CoSu6XaT0Qz-IfZdkK422F8gGrB8
X-Authority-Analysis: v=2.4 cv=LpKiDHdc c=1 sm=1 tr=0 ts=6a748b1c cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX9FW1vM7Wb03L
 qxf+XD0Y9yqqAJ/KPk1lSpc9y04+ParjdSUFKj0JzXN7Qk+qRvDJKWZS9yj/dh8Kp5eG5u1Dmve
 ImwsH6SuL7qAG1JB8eZkh2hcJZkk1GA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060105

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The variable wbm_status in ath12k_dp_tx_process_htt_tx_complete()
holds a value from the HTT TX WBM completion status field, not a
generic WBM status. Rename it to htt_status to accurately reflect
the field origin and improve code clarity.

Also fix ts.acked assignment inside the HAL_WBM_REL_HTT_TX_COMP_STATUS_OK
case to use true directly since the condition is always true within
that case branch.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 632230e77802..d46a3d14f018 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -575,21 +575,21 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 {
 	struct htt_tx_wbm_completion *status_desc;
 	struct ath12k_dp_htt_wbm_tx_status ts = {};
-	enum hal_wbm_htt_tx_comp_status wbm_status;
+	enum hal_wbm_htt_tx_comp_status htt_status;
 	u16 peer_id;
 
 	status_desc = desc;
 
-	wbm_status = le32_get_bits(status_desc->info0,
+	htt_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	if (likely(wbm_status < MAX_FW_TX_STATUS))
-		dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(htt_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[htt_status]++;
 	else
 		WARN_ON_ONCE(1);
 
-	switch (wbm_status) {
+	switch (htt_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
-		ts.acked = (wbm_status == HAL_WBM_REL_HTT_TX_COMP_STATUS_OK);
+		ts.acked = true;
 		ts.ack_rssi = le32_get_bits(status_desc->info2,
 					    HTT_TX_WBM_COMP_INFO2_ACK_RSSI);
 
@@ -611,7 +611,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 		 */
 		break;
 	default:
-		ath12k_warn(dp->ab, "Unknown htt wbm tx status %d\n", wbm_status);
+		ath12k_warn(dp->ab, "Unknown htt tx status %d\n", htt_status);
 		break;
 	}
 }
-- 
2.34.1

