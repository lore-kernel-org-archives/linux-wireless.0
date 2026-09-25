Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB40349CE2
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339219; cv=none; b=cc6uVYfwRx0WP3nNklVUWB9Ihmwp8YIIyTNYKVdBmZnegSo95xSpU5cpfcft7Pn0/kyLtKFM/0CooPyKllYfURqjJUelH1ZPRYQinvcvBz4oA6koLE6fIcjg7LWZ5z4i98CPu/4nJU0bJG10EgFr37qoMbsKykaLjJBt35E18i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339219; c=relaxed/simple;
	bh=D1Wz1LJ/c+IKbSDH2qFigvS32qzF7ER1Q6u7mMpaClc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGBzLuECIeAFJqUaSbm3gKp4C0SJMLmFLnRRX2k4Sz0jhJd91axcXvpFMWzcIpzg/czwQ1QGu/m6fF2lsEQahaTTvJ9ukjBzE9U214cmAfigo1TVUK/IxZppgIc72vn1ouZxhMTk2VXHPPhM3QTe6ZSoz/d8+5nrQ7eMqN9ZGu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HkEajl5w; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=irDW3TiT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HkEajl5w";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="irDW3TiT"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YqMh1194213
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fD1++trc2gJkbJYyJK18gc6//mLeibLWqR2ndXWB/cs=; b=HkEajl5wHehpzUEA
	7M/ikHsgLakAHYeB/0PNUH+4WUSqIpPCpFFmOqvnujs9BbXMNTBDc1gpYzXMdEsf
	+IOzzPENlZK4wvx6xUvEO4elykJ2U1TdSba3snD2eC8q+WiJ9msmmXDSbRfkC6Na
	94opmcZva9nGqWURFXsR75+Bj3f8HtLINuvcgE2lXpPDX2xGXvgGGAL9p4u34m7a
	gpWnh3Yftx69CbqEdE9vQmLa0IPm8LXQ1VC9n22rtx/TEKIHYoVeu50LuznTQJvU
	XPDrt/OLwZMHpMVUwub+MgXLvkinnjKlinRcJKVw4qF1CB9HvPohYZVDxp+Wlpp5
	NVsnoA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw874kcpk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:56 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39e3c10ac70so1267799a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339216; x=1790944016; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fD1++trc2gJkbJYyJK18gc6//mLeibLWqR2ndXWB/cs=;
        b=irDW3TiTae+neY6KgJE3ZQMMouBjn10K/k/3DkdvHc5pRCknKfyW9rCqZ4EZMCdSKv
         QjJiRrxBNHeJiXVZRJWQ/NuzbGWTYCYNdi6yIQZkuQ/uKMF3CYTMd4VFssDLQl08MP2X
         JSE/TgZz5BNXWETExfIUELrjjPfJC+OxbBzRY8PTCvASF3pJzBMRzzTjpRJ3ZOYLDo8T
         lMqwmpLR6dhvPuqXCYYKxMVZEqiVorCYR+Da3SH9CD7LEzB0TrskjJ2kITD64OaiuNZ4
         TLcpEeDz/zatIfbT25dSbch1FwcURMgbB0kpvdkSxGlm91XoYrqxmkFWcWpfSDLYPapk
         +mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339216; x=1790944016;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fD1++trc2gJkbJYyJK18gc6//mLeibLWqR2ndXWB/cs=;
        b=qq4ty/ErtQhqCAFK5yb8AZN12cyfVWUIhlyQ9o0oywUNBpyXaDj8mEyGjnpsmNo0Jn
         ybb8iLwr4/bm71YkNhd72LZQS7Ug5WDgmWXfTFAosgqSGgsG1KIFWPPn6FsOBIobSen5
         GLwZR3eojbPKFqUhXPjPcHMlBluVDZ4KEXmjLo7vDVH/hWS3YCQcF6HusXIAoFI/qT4b
         Xe+2rNZ7Y5XuiOfZzWWRndFic7y+S6REBE++kk8qtU2TN7YsX92w8c7RSWCmu1ErbqTg
         KHDzsmozpDRHtbXYcvhkLvKNLyp/uVjZPNjtE/t9fXurH6+61K7wJDvB0U2QIPW7U7eE
         wDsQ==
X-Forwarded-Encrypted: i=1; AKwUvBwqpqyRFYGIjuIZ95Itytf8OXVf1LXficAqPSMeeLFubs2nba+Sz7sHEQKsCp0QsrnjDTftMaGSXS0XhUneLw==@vger.kernel.org
X-Gm-Message-State: AFuF++k7v5QEkn88bOrM1IYUAgbABGGzOZ97BnaCJEsT5ZbtpLVEhCXX
	gdYLUmiocRK7lOLm2Fzrnvl1XewaOKTso0Sxeu/rd1y4wtSjKy2fZ+CWm1UKxsxmUybuh+65Ntm
	fELpgHp6TiNEW1iCYkPTmPNYnp77MirxPF+SX+q2lrp54tWlp99JCx0Ubdk9CJCIhPt2s9H3gpd
	4eww==
X-Gm-Gg: AYBFou3xi475wV6yceBdJd1HfhRVklJDpi076/9RlINiUQfq8tGjPXBB/FOgyflfDXM
	/QegpCMG70yAMSvpxfwlXAmWnCzajk4qweQIJWDEVNJVvBC9Ku8vUuYotR7aUGitcFewVYOvfTS
	fJ5K/LVjOoK+5YzeR6FlkW0jpzubNaHrhxVcRkKWFhixKiZ6Ykav5Nz5CSOVjD8b8Q9ks9+8r/O
	2YxUucm4f3pLtuJum9xA1m7bf3nRjQ1Px8zzr8vzsMtePcze5HGfipelEu3UvlXfkKmw94M0gL4
	NlLLoq/ILyeuOxkufhbIxZF/XPmdmHLJxc4RaRqyBGSQWuwfnFwuMmKygffwDu/g6nIpK+4Mzhh
	CayfjO3NPzlwWod0XtDwru7+HKlIjFN3f3KHRQ+3M1qgazJkgwnQ=
X-Received: by 2002:a17:90b:440d:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-3a09860fe05mr4912195a91.0.1790339216192;
        Fri, 25 Sep 2026 05:26:56 -0700 (PDT)
X-Received: by 2002:a17:90b:440d:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-3a09860fe05mr4912175a91.0.1790339215564;
        Fri, 25 Sep 2026 05:26:55 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:52 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:35 -0700
Subject: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=5322;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=D1Wz1LJ/c+IKbSDH2qFigvS32qzF7ER1Q6u7mMpaClc=;
 b=qhH+cYo74F0ePP7ip6X/NzoZTP2k0vRseen5fwyq4ZdGTGnb2QwseiXKdt/8GGAurau2jwuL+
 1i+kvwmL5LECmXVtPWjib1Jt9hKnwKasYLyE3YovheMuXkBP2Mu7BvR
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-ORIG-GUID: CDxl-8Mfk071vjm-BxW4MFZC_lT0gYJI
X-Authority-Analysis: v=2.4 cv=MI71C8Zl c=1 sm=1 tr=0 ts=6ab66890 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=4f1K30pynMUHuLpjyDEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfXzNHsv+gge2Cu
 Te0/IB3+opEy7J0DNCrsUbLGGRqljbX1HaoQtaxM+GZ0kyISSb8W3rYGj4zZOzyYcWr4n6J8t76
 Mt9MCVPjQFGEPbCQG1gTfFy1CiyjDPeV1kyCNN4tPwT3RPPnr84fff7nTWNPAmL4zMwVwmXu3PX
 E1gDfHEw1szz6yVZuBJ6G5QR1I85lT7if1wq54qIvMEeolKeVIOtsYPG5Gwh7FmK6hRmlDTa/ww
 PCCVMi8/qXAREyIvgAmP09rrGDroOWysvfBSS5HNvtq99idTFQKHOIh0CMSWzwDM14Dhw7D4jZh
 CQVgmiMx3z4MaBeCBJdf5nweqBwvRF7eaJ5/Ec7d/r+3nsXdehnMlSQzUKVSTZF2BkNhnfI2wgD
 7D6uNYhIXwacS9nlUhIYChV9zb91d8Dp3/QZQ6ev2Bm3pj4wDc0CkCjyFv4vBb9OIxKu6k/icWC
 dDWlfPwHJh3EyU06/Dw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX+BZfLkvq8crT
 YPhmW9reL1vF/5Q0kt9mlSAcaMJCeemC6nlXvmLZK9nY6nWFTCgZsWcrTs+BxEGJ86RAyCUaz4t
 xXddhW68FXLI6/RR52PBnvgV60d3mZs=
X-Proofpoint-GUID: CDxl-8Mfk071vjm-BxW4MFZC_lT0gYJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

Recovery timeout enforcement currently advances only when
new recovery triggers arrive.

In practice, the interval between triggers is not bounded.
Additional timeout handling, workqueue congestion, or other
recovery-related activities may delay subsequent triggers,
causing the effective recovery timeout to extend well beyond
the intended ATH10K_RECOVERY_DEADLINE_HZ limit.

If recovery becomes stuck and no further trigger is generated,
deadline enforcement may stop progressing entirely.

Convert recovery_check_work() into self-rearming delayed_work
so timeout monitoring follows its own timeline while recovery
is in progress, independent of future recovery triggers.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 20 ++++++++++++++------
 drivers/net/wireless/ath/ath10k/core.h |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c  |  5 ++++-
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 29ca34a643ed..93dc7332c759 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2522,7 +2522,8 @@ static void ath10k_core_enter_wedged(struct ath10k *ar)
 
 static void ath10k_core_recovery_check_work(struct work_struct *work)
 {
-	struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
+	struct ath10k *ar = container_of(work, struct ath10k,
+					 recovery_check_work.work);
 	unsigned long recovery_start = READ_ONCE(ar->recovery_start_jiffies);
 	int fail_count;
 
@@ -2536,8 +2537,11 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
 	if (!atomic_read(&ar->pending_recovery))
 		return;
 
-	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
+	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ)) {
+		queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
+				   ATH10K_RECOVERY_TIMEOUT_HZ);
 		return;
+	}
 
 	/* Record the continuous recovery fail count when recovery is late. */
 	fail_count = atomic_inc_return(&ar->fail_cont_count);
@@ -2547,7 +2551,12 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
 		ath10k_err(ar, "recovery timeout %ums, fail count %d, shutting down driver!",
 			   jiffies_to_msecs(jiffies - recovery_start), fail_count);
 		ath10k_core_enter_wedged(ar);
+		return;
 	}
+
+	/* Keep checking on our own even if no further trigger arrives. */
+	queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
+			   ATH10K_RECOVERY_TIMEOUT_HZ);
 }
 
 void ath10k_core_start_recovery(struct ath10k *ar)
@@ -2574,9 +2583,8 @@ void ath10k_core_start_recovery(struct ath10k *ar)
 	atomic_set(&ar->fail_cont_count, 0);
 	WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
 	queue_work(ar->workqueue, &ar->restart_work);
-
-	/* Start monitoring after publishing the recovery timestamp. */
-	queue_work(ar->workqueue_aux, &ar->recovery_check_work);
+	queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
+			   ATH10K_RECOVERY_TIMEOUT_HZ);
 }
 EXPORT_SYMBOL(ath10k_core_start_recovery);
 
@@ -3758,7 +3766,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	INIT_WORK(&ar->register_work, ath10k_core_register_work);
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
-	INIT_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_work);
+	INIT_DELAYED_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_work);
 	INIT_WORK(&ar->set_coverage_class_work,
 		  ath10k_core_set_coverage_class_work);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0319da3ec022..a1ded2cba103 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1213,7 +1213,7 @@ struct ath10k {
 
 	struct work_struct register_work;
 	struct work_struct restart_work;
-	struct work_struct recovery_check_work;
+	struct delayed_work recovery_check_work;
 	struct work_struct bundle_tx_work;
 	struct work_struct tx_complete_work;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8e604697d6c2..d10126351fce 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5427,7 +5427,7 @@ static void ath10k_stop(struct ieee80211_hw *hw, bool suspend)
 	cancel_work_sync(&ar->set_coverage_class_work);
 	cancel_delayed_work_sync(&ar->scan.timeout);
 	cancel_work_sync(&ar->restart_work);
-	cancel_work_sync(&ar->recovery_check_work);
+	cancel_delayed_work_sync(&ar->recovery_check_work);
 }
 
 static int ath10k_config_ps(struct ath10k *ar)
@@ -8175,6 +8175,9 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		atomic_set(&ar->fail_cont_count, 0);
 		atomic_set(&ar->pending_recovery, 0);
 
+		/* Stop the self-rearming monitor after recovery succeeds. */
+		cancel_delayed_work(&ar->recovery_check_work);
+
 		if (ar->hw_params.hw_restart_disconnect) {
 			list_for_each_entry(arvif, &ar->arvifs, list) {
 				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)

-- 
2.34.1

