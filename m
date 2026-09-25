Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E44734E2
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339213; cv=none; b=JtQgkK0J3ogH7g3feQznnkWcqx7rY2c1P3bAFaaweoUd+wvjYgSUMFF85Ajj7Ky0KEcnNoqPM3c+C8oGb0ZqOeWUZJygB90LrLcKlP/dOv+yOrMsd488B9WjayCkh8Gb8deKRECX0m/Z3O1VPK+DffplECcqpT9YVUklqIsgeLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339213; c=relaxed/simple;
	bh=RzW/p1ndCnG4xw5cbLHXdb9gMlByeF2ujNXNuZyRqmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=if4E9GbTiAVFRNHNHrkvUq+c68LC4cdAPP2HqzezYRlB5uVlmh8bsAcwbP00mW9qvN2JiM10+i/NVzEH4Mz72KY3A1fe+xm9d+qzKfcA3PtN+mcsLpONygGgdBSJ8L5HSni5HG3gY0Nu+DKfKpMmO17Ex9Z22vcaeGsUrEVSy7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fAPzS/FI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N43IHR5k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fAPzS/FI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N43IHR5k"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P5JEAW3627536
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ARXBIQ4IcLEk8R6N619MGU53xX+R5Ms3rIhcUp0hkYE=; b=fAPzS/FI5yCoPXcA
	AAfvb19Cv7XD6v0ZlYNyGvmyOEsncT0FOfq061nuHxdbzUNkuRCsTOg25BMvqbDB
	4nfwScYLQguFWijLT5P8q6OT8owCSYn8X+q3fK5FQSWdTuG+ctRym0G6T9Dxqdjn
	LJ3dvS+JtSbheR/09v1GUGmcZnkHvR/9/U5a0Md10o8wnSOu2VkFl6U2xE9CRSBc
	xwCduZSLD/5A2RFGXIaq6II1g2y448mrkV84QbNeButAavth33v59Akj0hln7iPG
	kOyy+nwRzipc/CKGqdSxqfRJKwwylxxQppQW4J2Yrl6uCWx2LaunQjM5vflZKKsa
	lVjf0A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq39a86-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:51 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e087a17dfso1206004a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339210; x=1790944010; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ARXBIQ4IcLEk8R6N619MGU53xX+R5Ms3rIhcUp0hkYE=;
        b=N43IHR5k7QowlbRZf0J4AQyc/NRTxsYKKaq5WZhHoiFuZtpP2xA/II5q0BGMcuUlHB
         VJq6gO/3/MQZSZdFV+i2o/6k0dGTQqfEDM38nx3ft67a84GmObYwNLTAHtRkCelK8AN4
         IJEwypDc3ei1WDqCbl1RIlj62N1HtTQKQ584fMhfywwAuOLPBwPQKdytBwiSEKLWbGxs
         W/PtkLNllA+u1hKnMwSoSBeVQmFDQAg7IZuUYl+K4mx4uK8+x5QaZVNAXQaP3E9SzmA3
         p8MNtYxu02yez3DZoCeaHLR2rpk3iRrRvBKSbzdJpBh6/5C4cj2LkcrASwj2XBpj0rHU
         vlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339210; x=1790944010;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARXBIQ4IcLEk8R6N619MGU53xX+R5Ms3rIhcUp0hkYE=;
        b=ekogzmA42OOPXqORBy7q5w3FSDrgB2Pd3aQkOk2bQ9UV8K73bIyxYFozNs5ys7SLUp
         tw0iCMz5tK0p/lMYp9XZjvZStAYV+TNmfYrvDX2EmUwbjI/Psq3II1PQbcrkUSRhZSDQ
         jIY8wepfKm9+MM+wLibm6b73mMkWdVOVOmwL6jLdIPPigtxWEyEcpYOMzPh+8ZVktUEj
         5YwmBe2L6+Y9sOFNAxBy5Oc78uadqMJ4Lw2PWe68srDuEvm3AC0UR52/b1G7LB+8wggw
         DM7Xh1PGbDWAhkSGmuQ7vuoAhrjQ/ll7Ayi3isUc8eNNVW79CQ0JrWBxqC4eH0V35I72
         UIRg==
X-Forwarded-Encrypted: i=1; AKwUvBxRt/FEKZ4H9/gEfYHQUCOxBZwd39Ns3zzMqTovfqLxxkNlbGNar92XwOSQsFrpIa7Nr5OufBg9005xPbNdLw==@vger.kernel.org
X-Gm-Message-State: AFuF++mc+3LsFBjy9bGmUmDzPAPH5pbApWik0VgmtZfm5TD+SPfI1kh0
	6M6Wjo9j88Fa58YkA5xcNeo9QyfnEWU/k8zagUvPLCajIyW7g+ZHKVvgo+BDvtsKUpSaU+55Gcn
	8BWTjqmxhWyDqqZiwPolpXL4bx5poYDamov75dB9cIajUbJ1TYO6q3ICqQf/NyqdvJ10uQ2VYOv
	jNng==
X-Gm-Gg: AYBFou1q/+WW5sZVuu43jTjFib9EeuGnNI0vcfjb0LukYYcwZkNiEYblBYz8uFjn1Zo
	v3/sxdqgbs+J8bNagqS2ycGqAB+YQw+OhqnN/f3uJmEcVP284xzr3ZTEtEuXRAtvr45QcLYeq6l
	rBODivS5oFX3aX9N9q3GOeDi4QG6sSPTIXWVY0GZtdVYWp7wA3REvtcWCNCRENmpAboWmCmvG9y
	ZoZeysTMuBDfiQIQoNv772SG2+0SlPt2mqfOzVsiPBBt1Vk1J2Di/VI6hPIYFLx/m5v+xGndm2m
	YYPh73MHqidNRc0BpaHiYAJl03rRMIJFTppVVrOgcuBQcGN980U8yembcwS9uiD8uW6v7uYwQQD
	MR89e69DSsskVkpyotzTBy7y6Lj3tnX921bOiGdjwkFn5QX2Hdqs=
X-Received: by 2002:a17:90b:5748:b0:39d:f6a6:60d8 with SMTP id 98e67ed59e1d1-3a098ae1f1bmr4816710a91.3.1790339209979;
        Fri, 25 Sep 2026 05:26:49 -0700 (PDT)
X-Received: by 2002:a17:90b:5748:b0:39d:f6a6:60d8 with SMTP id 98e67ed59e1d1-3a098ae1f1bmr4816689a91.3.1790339209054;
        Fri, 25 Sep 2026 05:26:49 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:47 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:32 -0700
Subject: [PATCH ath-next 2/8] wifi: ath10k: wake blocked waiters when
 entering WEDGED state
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-2-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=4028;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=RzW/p1ndCnG4xw5cbLHXdb9gMlByeF2ujNXNuZyRqmo=;
 b=SWqpyGTw/9+NTpuoG0PIV5tk3Ow4hCGYqAP5Mnq+OG+DpdFN90Q3+K0chTqDkaH3YbzVenn9a
 OL+8EAMYvMRBjTnwUs+mFS8C1tXsxjZYIdbkSoFvGsWS2J7ynqvV6zW
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX/aa/6A3phg9q
 KX4vDgMkLckoRTxYOHQJhXH2zuraR1z7qqxTpgro9n3rwmqO8JbPpfA9elAtgTb5t05TJWADsmp
 UFPCQXieAEb4r7o8jPQ67ik/CjLUeCY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX4DIRVSCXBSSV
 3CwVfr71rP2ZLxA9AybqY7l2Yk0ULV9CdU+OI/o7vQNOMJpIvaIuW9HmseJRPCiDhCWq+6D3eeO
 JAzHB7a02FGlkV0Rup/9rBRrkbgtyx0eMlSiRoqvjSeEgB6O4+dZXPOcV6k1VwLA0OUV5U/Q9jX
 +mYgFVvUV6WmDfDzxLnwaddpuM6UZKJKFNk3lYt8KJLDXpYprZtY9RRXa1YzgLlrlWcdVe+iIs5
 +NHziZaOKTpNyqiYL8Jyw9Gnu9cI+2+F0KXTdrV7kvqervMymdVzcS5jB33IDr76q3wkjmUXKPt
 I9kuZJCnjks8jgKU8W1yeR1cK0C1D6o0tg9HfrlprFCk5xff+EaVZoerrikyowligNAL13QxtYf
 tLHou7L/OI4N+IZ8ObHJ3DvUpvKK41n4qX3jWkKWxoA214akPC7nSaqRiPkeN4RUIB4U8qcRscd
 zgryNKZaswboNyiNEOQ==
X-Authority-Analysis: v=2.4 cv=VuO2kO2n c=1 sm=1 tr=0 ts=6ab6688b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=6QK6Bl5UZFK8huMW9Y4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: 6NsVjids1Lkao1qvBfFSv7VjOV99IRvR
X-Proofpoint-ORIG-GUID: 6NsVjids1Lkao1qvBfFSv7VjOV99IRvR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250049

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

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 43 +++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ad087e64db9f..be516dc32c1d 100644
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
 
@@ -2591,18 +2617,7 @@ static void ath10k_core_restart(struct work_struct *work)
 
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
@@ -2630,7 +2645,7 @@ static void ath10k_core_restart(struct work_struct *work)
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

