Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C4532720C
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339222; cv=none; b=Rmth7TPJqpQ9V/PLWwZdBwEdzo5Bz/Os84AIj/d2M0K4MwapCJ+2ry8d5U92l3pelull3H9IDaHlIjc7w40QYYAJSC88+OsMTNE5O/3ZDAWaF5CtSJc9jvk0ZWmc3NrWYLxSnR0E2oD0jPfxVD5YMlD0851+ij8cIuHNXf+XVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339222; c=relaxed/simple;
	bh=92m/AGutZDokLi66FDq/i9Vv+leO8LbFn+ZC1sw7EXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Mbozee6EMWHmqFeYdpyKHBFKeVc+xMkwPOOIOmPvamCpoq3gP1IEFuW/r2jc2gfICvXPyeAWOHy7LIPnKkKi0eVm3Anwu1tyNbaGwCZ13Eg84jDIOpRb5CpGO6YEjixg81JlTPSERq9wZ+77Fd3Nvy0/4+ciO32dSrBy2ctWYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SOk3bgHT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eVHeYqdZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SOk3bgHT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eVHeYqdZ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P5JFaO757087
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WpzxKoiiTSBU1nVnLV1eocr7wH5M9Q65NcNAme4XRV4=; b=SOk3bgHTOvq3AGco
	jdnOqFQbtyN/OzJT9RN0V4ZsSQYNpIfxBHw9NJzsyBZjLP5sXHFV2T0rpDMMWWKm
	Np4ak25VSuq2x/r/FfU9OEyUS3bKATHclClDbKwgrFlK4SRk+0OoopDwikFo9zXV
	HRU+EVr/KN+7afBYn4tGzoQh19PdjQeCNU0R1ZlS6o7Fn2iNWMSLoQ5xHJzP/AHM
	oiqjTpcvZ21Yzc4iiRQNLCjp/zi3S+bMl931Q2sQ7y/YLRvHJEbTQQAe4re3as/q
	U2EXVZP+0TN+OLAJcRnweNV+9OZZ59tk1BfVI0eXua6D5RqazkbSTwDNK1TL3+Q/
	XJQG4g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq099vu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:59 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so1004448a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339218; x=1790944018; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WpzxKoiiTSBU1nVnLV1eocr7wH5M9Q65NcNAme4XRV4=;
        b=eVHeYqdZY0qn41RDMHwS0lJEH1Jdz3HRt7jxs9nNI7iNd8h7ofWIv1Tn6JMlnYbQIw
         yMt7UnSZ2+7fTbFqMm9tIKs+E2NrIXE49Qj15WT2kgM9aEBXhQyYeYf/NLb76J5dlWgv
         nFUSoQJBAqT92Tt/BCudbwk+Dn0RGw4mRokVoSJ6oELjt/aCYdLDeRtFpkEwduFWmQMa
         gUZUhJtrSvUpnFPH0ZKH41wXEB1L69FWPOUIKvO4vNlGgH4qrt16ybyBgMu3IWMMuBsT
         uqt2tXQu+15+3v4cdMyfZjAgMJCU/SScq6uQQNvlGCeOzie1IKcMsDaabW/E84yDL/Xm
         MYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339218; x=1790944018;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WpzxKoiiTSBU1nVnLV1eocr7wH5M9Q65NcNAme4XRV4=;
        b=0VXJ1N8fmOBy963gjnl2YNlNlWPYsaj9shNWqgqIKD8fFvmm7K/CRx+g/IfJmSOqw7
         JKKIB4O0XYiKNa8HiOKvgQbsIXr63Esw1wFM2k1+RvD0yMfEmYwrE84wcMUj01aap2CI
         NOhq3WMzxfskPeDH453hunaafwnfh7pt1f6a97nvTCXHOFH6/Gy7UBDT5BteAJV6nH0D
         s/l7gNqotjM8r+aAAF7aTw1ouCwWEWsbCZ+2Syam78vfTSiE0nI1LjL6ttCjGzjnimm9
         ZgVzXyDaaJpvWc+kxpdtsTfhEirN7YGQkQgRdJhYYDyNQdZWo5VPZJ6Kv0NAIiLipT9N
         6JrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxC80uG2B3b0VXIA6MrvoF3JlToxC03OQbZQt/5wveYYjpdGlMQiilDXASHcAEH56nV7rTU/frls/cVfFMjKQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mdDJ5GD/Q8/xN9XzHI820R7QqxPCZ2imH22rPWXcsdcRY8Ts7k
	6RAI5EQmkSq3EHHjGC2eNiILryKPzqAsu6FS3SMOfwh30v4oriMBBR0/0CQwHZUIlv1719lA5sB
	g2l+PMZ5quolmGnRiVmXPp9jWDNk2zSagJG5LZ1O9s05cYu8fuKPIekGI6td1sCKqbu4dCOYvXg
	OQIA==
X-Gm-Gg: AYBFou2/dB/FD3haO9WNvcfk57vUYN2AeHUIEuAT0alOO+YLw5ffK5t091Eb/wKFLZi
	YGfgqSez3V9HliwuCiftcgIjyYzIP60Q4HqOfbNH3UOUEAmw3MSc4Rj/MwlH2vEDJflrHz/VhHc
	QNEyOnQv98Ya1p3fKj46Df+fnuYYMP6Lnt1a/zYIl3C3/UT44QlkOaBpiK5MNfteDERmoDByJUX
	rStpDNWEiC9kw4jD54aU494k5pz1UByJYK1JkuB1BB3uFmq1sMVSEuXzIQkv/aHnaf31wPDinau
	Nq8Cn79UnhXGUe19q4PEQ6PT39RvEL2psnClKeqjJefMtTNKZ3+tcDqJwjtXZhSJV82IRrgEfCh
	bi21XQeduvuXqB595x/EarIyS7meJAp0NGJS4UCSEMiVaJWhIqPE=
X-Received: by 2002:a17:90b:39a8:b0:39e:6a81:f349 with SMTP id 98e67ed59e1d1-3a098bb60efmr5046497a91.35.1790339218368;
        Fri, 25 Sep 2026 05:26:58 -0700 (PDT)
X-Received: by 2002:a17:90b:39a8:b0:39e:6a81:f349 with SMTP id 98e67ed59e1d1-3a098bb60efmr5046479a91.35.1790339217715;
        Fri, 25 Sep 2026 05:26:57 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:57 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:37 -0700
Subject: [PATCH ath-next 7/8] wifi: ath10k: remove now-unused
 driver_recovery completion
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-7-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=3437;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=92m/AGutZDokLi66FDq/i9Vv+leO8LbFn+ZC1sw7EXs=;
 b=WyvI1CkVtPJkXd5WUOLF5z9g4g2vJfsVmiqtUIoEbJawoxga8TVyx+vgnJr6djTaxTXqypJ1n
 s/oUl4FQYAsBxA5kAlw+IuEZ2D27pCMzjjP2qIU69Mpwkz99lcAqyu5
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX0QKNdK0F5s92
 96DR85GLHrwKQ8BqwOUS9zHf6HvJZ9BLtfjrFV8QWZlkpR0y0P6ncT0Wzlvp4NcW2nvrNdaBNBb
 dNLwCIcJ16pepmYqvVe+EeCJpMPCB2E=
X-Proofpoint-GUID: NCJlKCkQGqinwiG6DHSHnHwo6XoKzPZ0
X-Proofpoint-ORIG-GUID: NCJlKCkQGqinwiG6DHSHnHwo6XoKzPZ0
X-Authority-Analysis: v=2.4 cv=LNPz05W9 c=1 sm=1 tr=0 ts=6ab66893 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=THAtv8xtLSZw0h4mMwsA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX8+VK2G4ET2Mv
 dzEtZK82wH0et5TJ8VltlKLOED1uqOdRwLeJClxNWe2SiP++vZNWmVV/nbn/wSeiky/8FqVhVBN
 pY8SuEQpUc/SWMVd78IoKo5HtrJyOpdlKKi0CQdJJnFEt3v6Xy06aXjA13WbmCIQtPau4ke96gP
 fGp2tSYrYyLV5NRdXgUEO4v4xyasvxkbLvvVcmpYAoMTRd+zsaUhaxIne9B1EGz8/maKiSIyz2c
 mlQ67Y3Ud5oXzAN+QKSLw0KO2uZ++3VnGrjJL/P2uWQVT8bzVjxCJoMXk6PFnbtfLhKAtfCUJ3h
 +CA59iavQitQq2yoXHmMePv+4mq7IhnO8Uax6kRaKIKXC4xcGK1UexsC9PeHoljYUBkWi4x3eyC
 yERw80mDpVm2KlT1H0x5OEoi8UvII90WaGkWy14ZEBWGYSPEYBzFozyFmyHANgBzgrY0/fquzrh
 1TJgtE2EfPtnpbBWA+g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

Previous patch removes the recovery monitor's dependency on
driver_recovery, leaving SNOC removal as the only
remaining user.

Replace the SNOC teardown synchronization with
cancel_work_sync() and cancel_delayed_work_sync(),
which already provide the required guarantee that
recovery work has stopped before resources are freed.

Remove the now-unused driver_recovery completion and
associated initialization and cleanup code.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 ---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 1 -
 drivers/net/wireless/ath/ath10k/snoc.c | 8 ++++----
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0a87a577b3f8..8c2ac2ec32d1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2626,8 +2626,6 @@ static void ath10k_core_restart(struct work_struct *work)
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
 	int ret;
 
-	reinit_completion(&ar->driver_recovery);
-
 	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	/* Place a barrier to make sure the compiler doesn't reorder
@@ -3725,7 +3723,6 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
 	init_completion(&ar->target_suspend);
-	init_completion(&ar->driver_recovery);
 	init_completion(&ar->wow.wakeup_completed);
 
 	init_completion(&ar->install_key_done);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a1ded2cba103..7c961308d7b9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1067,7 +1067,6 @@ struct ath10k {
 	} hif;
 
 	struct completion target_suspend;
-	struct completion driver_recovery;
 
 	const struct ath10k_hw_regs *regs;
 	const struct ath10k_hw_ce_regs *hw_ce_regs;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d10126351fce..9eb356786d3a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8171,7 +8171,6 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		ieee80211_wake_queues(ar->hw);
 
 		/* Clear recovery state. */
-		complete(&ar->driver_recovery);
 		atomic_set(&ar->fail_cont_count, 0);
 		atomic_set(&ar->pending_recovery, 0);
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8f171ab6f4de..1ec58ec1029b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1916,10 +1916,10 @@ static void ath10k_snoc_remove(struct platform_device *pdev)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
 
-	reinit_completion(&ar->driver_recovery);
-
-	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
-		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
+	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags)) {
+		cancel_work_sync(&ar->restart_work);
+		cancel_delayed_work_sync(&ar->recovery_check_work);
+	}
 
 	ath10k_snoc_free_resources(ar);
 }

-- 
2.34.1

