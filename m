Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573799;
	b=c7rQu2DcyM1XCqqsDNdMYOCZlDOA04+16rhhl47YxXiHV1kJeA3BPJHI1f7oFKoLMr9W
	 gqk7JUhOuqKhT0Jm3cm/ADtnE+AF8GKgGGhCPQlZEx5d/Zmc2lmiwY1pL5ja4gkhJWrhS
	 d6x0N378J2QuC15GeBSN4MWK2OVvch6P7ESXHr4HoGUVFPclJ0Hh0sYW3gi1ow010wxKJ
	 6rNxxejprvKlQCT7bd46mKCX0J4yDet3bHtNNVD7HDlXJ/n86tjtYm/MgusBodPMUkmiL
	 zXh4hev9MQ/a0TPrAgGjZacijzPC2Wd6RkfibTmcAvxwSRDibVirHL+rwwxLmde5vzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573799;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=iaaDbUrXL1MbstCqkNh2A8z9QVuh0TfWXGm+u2WT+ns=;
	b=W1lJNl9r3lIplAQROLOrxu5WZq0TqKXcbhQbZdzRJ+YLJT9NS5tcmGpyk3q6wIYXpEC3
	 H9S1wHH3PoYKW1681oCtq0LuifylnHBdB7bpA5aLmkIchzL/KSb9JQ4meOpLpM9kj6wci
	 7qAduOzYxJJAgVl52G4o9aTli/lkAx8iQAuHdgPhJCMATRLG9P5wMo/6AvwxUdJ9rmLEm
	 fzvXJ9y98Ug+xzpHsq8Sxpz23aya5u3WjIOaGZ6ZR09TvxndguBT0HtgGirGfiAWkGo+7
	 8nyp8i5f3gbB6V9398r3vbmEQinkKfKPzKw1BaH4lUWK9KJyu0nPJld6xqlkxvanj8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SkKWLX19;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fLlaIr3p;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6797606A326
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6797606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SkKWLX19;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fLlaIr3p
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jAE23711677
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iaaDbUrXL1MbstCqkNh2A8z9QVuh0TfWXGm+u2WT+ns=; b=SkKWLX19cIhddEgn
	fLAsVbbwY9QW2dhcb1n1Is8orvDRl0Lo75zPH1FtnuKojKUWpYwtdC2Rb5GjInmp
	6wKnQLezsgsGa7uFK/6tNnOFVXq187qb6uU8V7IYrotA844EM1eMqfuxgxj7XH7/
	S1SygAJYGIYeuS+mFhxO47LHhNKNGedoZa1okJk6ANoHPddGCUqlotPpryK5FerN
	kStB2jYgUlQo3jFE+6Z+zOSBvhR7UC3ZFJBULlWUiatGVNAyXhmgQ4sKEqn3ap+l
	eCwmlfzgqxWKZ31arVGl0ztIx8Ohm56ws/Y5+UgrxCiEV4UMLB9BEvTlCJZI7VDG
	tMgN/w==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hed9v37r7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:57 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4d2f0f77124so588279b6e.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573797; x=1793178597; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iaaDbUrXL1MbstCqkNh2A8z9QVuh0TfWXGm+u2WT+ns=;
        b=fLlaIr3pmWKQBVua6BxPnL1OTfeg7MX94tcsvSMbqLC/YZpKBItlOS0eyuhjUCsr7N
         Um0krb7BEeRLIUUMabT8RTnKid/1n8aVJkGfD4LU/MFaIt9HYoIEYnO2P6ihG2sfnni3
         jKgxlfE84g+8gRSBHVYCTvRWbRKXRvYos3Un9xhu3M+YgD7bI1mAQ11jFd44afXsPltx
         AhnpNEeA5jxXYHbIUlaLOfTCtIZhLL9e2eU8Ak6lHPIN983aTMCTO5AroYRFQlb1onJt
         s0wzEFe+Z0uMss10wtgd+JGOySphVH8PDUv62lnEBtJJD3QvbaYgq6EyotfY0tL/pSoN
         MyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573797; x=1793178597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iaaDbUrXL1MbstCqkNh2A8z9QVuh0TfWXGm+u2WT+ns=;
        b=AfbmzkJ7kUC84eLn4vO3+5Hcbr/c6FSAEmL1Q7naiezgNONk00EZfjWvYp1Ls/7KmC
         ZxD34FzjMsl1mK3VI02mfLFwm88uQO07GYEDbiBMcUicwl8YGabTt4cZBpftXgdHKqWe
         f+2L6KoxeECp4Few4euaTC1/YIVJvs8kU7dN6caAYKu+FN57VXWYJtIDpEG4ub+Janyb
         qz1UR41tGC7eeGoMhdWjeDTWnXS2wCgDnFfEFreYXNmTNcgoifARasyouLvHPnDnSvZN
         aKZK2IJoZSvmnZIyRnygpoEeCDy2NX9Ilw6PLmFsUHWhsOrPxx7qsy6htbbk9DgMFTPG
         qxeQ==
X-Forwarded-Encrypted: i=1; AKwUvBx71Xf8tgvfavN4Jc2bHzJ3Y3kwNJZvN3wbBznsI3Tf8QLkYIQ7nigql3yIlYWg2Rgaxiiwg+M9gU6p06ZT9w==@vger.kernel.org
X-Gm-Message-State: AFq9FYJmOKfY18iMsk7Eq0hXd9IniAmq24eUgXHpV2dw0KEzbf/UWIrL
	oziNRpixVJSPyOrvLx7NO6yG/DcXkx5nS0nV3I8QW3N5b6ES10WxjjR5MJI5dBqGMk3LLaWCxEu
	GXdL79rn/zUxMLkdvtC9DYyjgn5t64hWgdRuUCTExuPKHPuSNgVG1LQgrFYTEVROCs+caAxbXF+
	UnanLE
X-Gm-Gg: AYBFou2wgFIKGdD25mGekonR+nfKEIHEWqIwRkc3rI1HmUL2tTs5sOoJCS0iglzbYhb
	SzlwjI6g+VvgPXMDw1FnoTOLwEsgHNqw/+pa7JmPxd4+A0VylzCvyh82l/5ftWsqJhU2gF1eIza
	pVpElQFGiA7J9y3ZIROrr/1IPaV90utBcvA+qsnaqmGTLUWoPcP5YnwJpepYoIWz3imxLHFBpPF
	YydZNluCpOkLL2yNiBLS1HDhpK6O4PcYoEVE0+nEH5of3cTPOhqgC+Lvpzyn13GbXFyLiSZMeYV
	YAfkqqUlL+MozRGvxvm/mnB2lUfyAsmlFzfR5o9wipBpHheMq/+Yfrqw2ZTzqyQFZsI/9ySLGJX
	Zk7o0yzM0K+thuowFoSykrtrub1n15vDAu265aWLlGZZdeuYSPg==
X-Received: by 2002:a05:6808:4fd4:b0:4d6:90f4:48b7 with SMTP id 5614622812f47-5535bea1b87mr999423b6e.57.1792573796685;
        Wed, 21 Oct 2026 02:09:56 -0700 (PDT)
X-Received: by 2002:a05:6808:4fd4:b0:4d6:90f4:48b7 with SMTP id 5614622812f47-5535bea1b87mr999408b6e.57.1792573796225;
        Wed, 21 Oct 2026 02:09:56 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:09:55 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:30 -0700
Subject: [PATCH ath-next v2 2/8] wifi: ath10k: wake blocked waiters when
 entering WEDGED state
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
Message-Id: <20261021-10k-sdio-crash-v2-2-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=4080;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=Rw4qE318zOpF8ysP1n4lo9aO3ThjAOMDbjwAMreJziE=;
 b=lFCaFDrXUXmpdeYacf2XKBTxSI51kI9OE8NosZ+FSVG//kfLs+xiNKWsYo7oYcVcergv/Reeo
 PkGPDDQU62aDax3cTLgX8OOS8RdLVG8Jff1NirnueNx8U2qUNVEdtat
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX/WLgOX8KRhah
 wqRaWxQN/8Y9phMYhus1CYPdc2hlNthVlpLLa9wMG8RdnfHFcoDbA1CC42DSyw3sWAPtc5epSvQ
 WbNSpgLaNeVI/EPbtLdUB8WjcsY4IWg=
X-Proofpoint-ORIG-GUID: KqZvB3Cx3AKnatBTiFRPN1DZPzcFDwyr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX2WCj89vY1d22
 xKKEWp6KNpHKL8258aKkpjiehICnkUcGiO+2fOmMItiDkvs/Vm7YAUXwI5nIgk2jfaO9WLlS4ED
 HfbzfxcaC66r8/W9RvHcbOycusipFP8j7JlZCXgUtabx/uKh+Z7luHJ79f9A0KblITFenwmX5Pd
 jpFIOVuy2F6QqgiixlgksQpsYK5QSwFceodwrIEP1AqpzTOeu/AoawPqm7nl1niIAlLddrPqaHy
 IbOpNX5BC38XwVJm4dUdJ9oaQ1/oJyjohymxwnTW6SaidrqppDtaf2BVCf0lC+ewH9WNp7nQ58I
 wNHJB3DdnM4vI1FeLNeQppATwPyEqis2RuqwY4MsMKOcoiJfnemyAGZRPoAruFuA7BYNGWaQhLn
 2GwsS55iOmGEJU1YGfOCOkW9cJJ1R3L94/6c7Oe/nKmYVEcNG9nmQ3rBNzSVvNc40Ayv970wUq/
 DZehsln8Dd6cE18Ct0Q==
X-Authority-Analysis: v=2.4 cv=I6zw19gg c=1 sm=1 tr=0 ts=6ad88165 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=6QK6Bl5UZFK8huMW9Y4A:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-GUID: KqZvB3Cx3AKnatBTiFRPN1DZPzcFDwyr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

Commit c256a94d1b1b ("wifi: ath10k: shutdown driver when
hardware is unreliable") added a fail-count based transition
to ATH10K_STATE_WEDGED after repeated recovery failures.

When recovery starts, ath10k_core_restart() sets
ATH10K_FLAG_CRASH_FLUSH and wakes waiters already blocked at
the time the failure is detected. However, additional waits
may be created later while the recovery attempt is still in
progress.

If recovery ultimately fails and the device transitions to
ATH10K_STATE_WEDGED, those later waiters continue sleeping
until their individual timeouts expire even though no further
progress is possible.

On suspend/resume, these extra wait timeouts consume watchdog
budget. Crash logs show cases where one or two such timeouts
are enough to cause the suspend watchdog to fire before the
driver finishes shutting down.

Apply the same CRASH_FLUSH, queue-stop and waiter wakeup
handling when entering ATH10K_STATE_WEDGED so blocked callers
fail immediately once the driver gives up.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 43 +++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 07beefa06c4c..93140f1ffb7b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2491,6 +2491,32 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_core_wake_all_waiters(struct ath10k *ar)
+{
+	complete(&ar->scan.started);
+	complete(&ar->scan.completed);
+	complete(&ar->scan.on_channel);
+	complete(&ar->offchan_tx_completed);
+	complete(&ar->install_key_done);
+	complete(&ar->vdev_setup_done);
+	complete(&ar->vdev_delete_done);
+	complete(&ar->thermal.wmi_sync);
+	complete(&ar->bss_survey_done);
+	wake_up(&ar->htt.empty_tx_wq);
+	wake_up(&ar->wmi.tx_credits_wq);
+	wake_up(&ar->peer_mapping_wq);
+}
+
+static void ath10k_core_enter_wedged(struct ath10k *ar)
+{
+	ar->state = ATH10K_STATE_WEDGED;
+
+	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
+
+	ieee80211_stop_queues(ar->hw);
+	ath10k_core_wake_all_waiters(ar);
+}
+
 static void ath10k_core_recovery_check_work(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
@@ -2516,7 +2542,7 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
 	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
 		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
 			   fail_count);
-		ar->state = ATH10K_STATE_WEDGED;
+		ath10k_core_enter_wedged(ar);
 	}
 }
 
@@ -2585,18 +2611,7 @@ static void ath10k_core_restart(struct work_struct *work)
 
 	ieee80211_stop_queues(ar->hw);
 	ath10k_drain_tx(ar);
-	complete(&ar->scan.started);
-	complete(&ar->scan.completed);
-	complete(&ar->scan.on_channel);
-	complete(&ar->offchan_tx_completed);
-	complete(&ar->install_key_done);
-	complete(&ar->vdev_setup_done);
-	complete(&ar->vdev_delete_done);
-	complete(&ar->thermal.wmi_sync);
-	complete(&ar->bss_survey_done);
-	wake_up(&ar->htt.empty_tx_wq);
-	wake_up(&ar->wmi.tx_credits_wq);
-	wake_up(&ar->peer_mapping_wq);
+	ath10k_core_wake_all_waiters(ar);
 
 	/* TODO: We can have one instance of cancelling coverage_class_work by
 	 * moving it to ath10k_halt(), so that both stop() and restart() would
@@ -2624,7 +2639,7 @@ static void ath10k_core_restart(struct work_struct *work)
 		/* hw restart might be requested from multiple places */
 		break;
 	case ATH10K_STATE_RESTARTED:
-		ar->state = ATH10K_STATE_WEDGED;
+		ath10k_core_enter_wedged(ar);
 		fallthrough;
 	case ATH10K_STATE_WEDGED:
 		ath10k_warn(ar, "device is wedged, will not restart\n");

-- 
2.34.1

