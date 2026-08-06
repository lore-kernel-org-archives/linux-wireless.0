Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962953446B0
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022698; cv=none; b=h5DRyWA4agTRQ1hWpAJ+kDTJROsMmjY0nj5Uu1NipzQCA4wajUpMT3sUDqFfaDq5F6ZXwh/6cMRJjF9a1l/FsdsYpNFAsBordsVeXK1dvqdyjVQWawSU5FX/d/9XjOaOjrTQNkt0VnrGEU2HePv2rDYycK7EiWr1TxsiTto73tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022698; c=relaxed/simple;
	bh=Nos9PmBDlRSlqKK9yIhV2JUoRxNyQBtaRS9UkHvyeUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bZ3NYJoSoT532cCsLHRrPBNyJCkcUTbDvYAwBz4LbneZG27uBxeOReoF8KS/lBuOMTDPQE3BnxhUYRhGVsFc2FnWQaXLBx1h2HchZHg5KhgsN94mvsZ6u2wxUrIFAzqxSQf+/FBBXdYIwyKf3g0Px0mUAloc4D4wvcweoqMwG38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bqmSn918; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aeUFf0Pq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bqmSn918";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aeUFf0Pq"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nc2T1580573
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WfGjm0JB1ke
	59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=; b=bqmSn918pIbcwrpARDOrGjjEf7t
	5ymkooCH+Jje6XgT1NToIMOvx0EDpXIdN/XmhYvce6kSZpR0UoLQd5VoIcUr5GFT
	wIyTECytMGUnseLIh/h9pzZXjWaadRKtcK7YeQBlLuioSJL5Ppib8PpfRkk3umYT
	J51DmxMbHJorB51ZIs86SnWhFbEI08mZliPAbp2inkqGfHpHmmSbaFywJeWogLOC
	4QgWVhHHU2beLauazruXjefA8vVTFXqJcW48grjQYM/FsF+zq6kLffO4dGQV0IQ8
	pjrhDa7ZyNt8icWAgf7ETEnBuaxWkgT1Y8ceazFgsG79vQGjjbJH5KlTSJg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjhvpu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:24:53 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e4ef9a74aso3819242b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022692; x=1786627492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=aeUFf0PqzfZy3nJYuDM7Pk01+3DJFsge5ewzuc5CIRRSc+Uroh17JTCmTR+T+R0xDY
         jCnumjmpbO5e14BMdtI4HAK0V2hoX0R4stGXl4zp1c0uDHZjjWE9ksvxgVawpQZ8Hrtg
         +g9XHLHPxjdtbV+TCaUxsmZgphiCh9SVOBo0iMPigyJlQEi3kas8z+/XwSto3qeQL3EG
         5jT85FGGcvUqdyQjtmpyWkoRhtA0z4mlHZTEOiBEdkw651+NppSRaR0LvawZktPJXhTN
         S89EKukBUdEr0+87jtkGMONkV54axXxidyOO/2LyI1hGzJOAr7+CD5SQMRcwixPuniPW
         ihbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022692; x=1786627492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=JbGAuv8fbQ7XkCaph1mfZ1N+IjuBnyrF6GmnRhJeOCrSYmlTExNyqM1CJ1ewIpKPSu
         9Cep/bu4yg0GbYVCdRVGR5qFdKVwoGX9+TLhbUfRtyM7N8slww7eYUKRfHJZupex6vQ7
         +M7w6L+UZ03Oi2ZM+/twDrUqVuRKWzomZgoAiIJs3KZStbroVTOMB3TJq80e2d+StaYD
         L16ap12lv3SVs6yXBjeXh34dlKHJWNwXhOU8s85tKagT4dEkGAP6KukBnr4rtGtMe2ZT
         fvbfRcEhYGkpEHTCwhCuxTjceviDTXPo/BGqSJlRXbTg67m/Q5C3uFyVCSzhbFKtWzzz
         h9Hg==
X-Gm-Message-State: AOJu0YwakQu7vDPPcG9KhJe7cVuoo8MBbK64T7wWOXLOky3d9n4g7UYg
	TBDjYk/wYVaif/KJ5B++ANDlhj9xF7jr6qS9IOfkDBYq/cFW+fwLn4NphzDQDHQGx6ayAJDelUD
	W+KFJ1ngXocP/iye+jQbqZupvV53ckHAt7xr5JL5aLIWGOsYk453KyQ65GezLXVrOGRLiqw==
X-Gm-Gg: AR+sD11vmwjJHl4KPNR15AiSjR3I1RXHj/H11Ru/AAADUzIgEBmZZbxlBBuWWGdvOqd
	HAAfiz1spSaBS3s7gQRTWqcdprEETIf9fjT4Ds93hNvHukhXin+D5TP0DluV5ndj+AISBU16oRh
	dwKOYO0af+Way0Spqh9Qhhd3zvlkszMw9VS3Ej7CVpD6D9dHIbzydii4L8CSGDaxFB5cBDuUMez
	uAdSSJDh3feW7BYXLhUSbM5OsMNRJ4NUX+1Z69JMbw5rcS55WDwZwBm24aGgxW8IoSod4xpVSjp
	ZoeqLTYXr7Ql+iws/e/e3wRD0ur2BxPvvdaoMzuSCSakPe4UkLtLwgZmWLiVGdShdjRFRK6QeIZ
	Mp8gJwOhSegTBnoe73sf3h0Sqy8YCCcqcZnfSh1v/JQxNki0est92
X-Received: by 2002:a05:6a00:6c9f:b0:842:6004:3fda with SMTP id d2e1a72fcca58-84f2dff6433mr18414168b3a.25.1786022692157;
        Thu, 06 Aug 2026 06:24:52 -0700 (PDT)
X-Received: by 2002:a05:6a00:6c9f:b0:842:6004:3fda with SMTP id d2e1a72fcca58-84f2dff6433mr18414091b3a.25.1786022691577;
        Thu, 06 Aug 2026 06:24:51 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:24:51 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Thu,  6 Aug 2026 18:54:23 +0530
Message-Id: <20260806132427.3704828-5-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a748b25 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: _XUUYhhV4ELUj2AqWkG4BZXJivVV5Gr9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfXzVhNFtJyy3d7
 Q6H3d4SoQDLFse/oLjoVai69neSAWMif43rmVh1appA50Zbt5dCl63E9afrIQrvsiSWVofAmhiA
 /F562CxHtoOLG3F/7MiNOY53kdbaU70=
X-Proofpoint-GUID: _XUUYhhV4ELUj2AqWkG4BZXJivVV5Gr9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX7/VaIqhVSNJA
 L0Hc6Ac7rOzp+a5RU0ZrgkLiEMflQo79b7cO9bowf8JL10AZVhjHvNqSEixWGpN5DWMmpIwj8I6
 SkD+Hs4mgqi76CsAd7RjxBtpY/AM3KGnL3+bjt9+uq5lF8MuQ4xrwuzuop7qfem88p5z02edGxv
 kKDSgE09Snu8/8Lw6HFqTs+a81Nvtb1yYH4wiy7t4aa+GwY/Nmy/Wre8CiilTM1KJW8KTo+f0Fj
 1TfXJo6m6WIDg7Z0rW1wCMhoKMSQ8VBx2YLdQOazZBqevUD1At+nNgwYMSy8P7OhVFbgw1dE3vt
 efLAdlzt8RsePqDajkGJcB+qoSQih4Y1r6y9v7AS/2ue3kZh5OcfbOrK72XXOVdRznpv64Ogoud
 Q73JLhl2tMPsDSjBv2HnEaqHcfMCX8RUttBe6V5j5me13kuFEieNmWu9HssIYe5tA0GUVma6YmB
 oy36uyOXXciAfhdJr9A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060105

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

There is no way to reset device DP stats counters without reloading
the driver, making it difficult to isolate issues to a specific time
window during debugging.

Add a write handler to the device_dp_stats debugfs file so that
writing 'reset' clears all device DP stats counters. Change the file
mode from 0400 to 0600 to allow write access. Use strcmp() with
newline stripping to match the input, consistent with the existing
pattern in debugfs.c. Return -EINVAL on unrecognised input.

No lock is taken around the memset since the counters are updated
locklessly in the datapath; taking dp_lock would be misleading as it
does not protect device_stats updates.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 35 ++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index ec49692107a8..0e446a666f4c 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1220,8 +1220,41 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	return ret;
 }
 
+static ssize_t
+ath12k_debugfs_write_device_dp_stats(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath12k_base *ab = file->private_data;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_device_dp_stats *device_stats = &dp->device_stats;
+	char buf[20] = {};
+	int ret;
+
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		return -EFAULT;
+
+	/* drop the possible '\n' from the end */
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+
+	if (!strcmp(buf, "reset")) {
+		memset(device_stats, 0, sizeof(*device_stats));
+		return count;
+	}
+
+	ath12k_warn(ab, "unsupported command: %s\n", buf);
+
+	return -EINVAL;
+}
+
 static const struct file_operations fops_device_dp_stats = {
 	.read = ath12k_debugfs_dump_device_dp_stats,
+	.write = ath12k_debugfs_write_device_dp_stats,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1232,7 +1265,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
+	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
 			    &fops_device_dp_stats);
 }
 
-- 
2.34.1

