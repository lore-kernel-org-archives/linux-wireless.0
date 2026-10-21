Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573800;
	b=FKBB/jDZkM7Ma0qJeToBVccHLi3zxyNEladXfPR5UzeBChlF1j9DPVKZH3J4xUrbSYKx
	 sQ+/TKnaNJ/siH75mlFmHU89H5lfb1qBRTzFMCUAIc0D9FZOLNe5JFMxxpn/Av82QlyIF
	 raOre3Hfu+MIccLbvrUp1bM4bJ0GfhkECRI4HKCGqizr0W9px+ULaigI5qZJqHJZLBCer
	 erOCp+2L+FSQNNG/ZZOVU8YxTWXdL3nCbNgDRNkrlnguCXQYHgJHwByMSshrjRtRwjN/E
	 MnJhwQz70DR8YYNQ8j1VxYO5EvniUXICR1vnss3lolQ5hc277Mgo/9YZq+fbN+pajsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573800;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=dwTE3Pos3BZVgDma/NRRNIPIbpecC6fQW8FK8gZC6j0=;
	b=dzS5WUYRaqXqJaCR+v6GZ/91Xi1nP2aIVFhRE7GYv1FGzJyd/zSoD+NxPCxRwnd5UQFV
	 gvUEukywDTtyGCalh4OKbbCeUAGx5FX9bXIttLOsPxg8xstFbKG2hyORxn5os3J7ho+R1
	 NkSOe7JxrF/xbQEC39ksxXDRvSSJMv6l48L1gH7VjmTB8oFfvbsfuEFn/shJG4DTCFQbD
	 5VU810k4Kk5gMcuoXrfmE/yXuJASCE6Tq5YzYdhIIYIkFJuyPbIN6KsTJR3JS3khmpg0D
	 IYKGRh0waGxvTJZuDpdH4nRCN3dJ45aGEAAB4NPJlKJdlgosOFnl5cqCmKEUfyMDG0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Z0w6X48f;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="C/YrJyFP";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB4A606A33F
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCB4A606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Z0w6X48f;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=C/YrJyFP
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jLGX2848643
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dwTE3Pos3BZVgDma/NRRNIPIbpecC6fQW8FK8gZC6j0=; b=Z0w6X48f1DaZ6K3R
	ZLB+y/BGasTuyoYb0wgOk29GTDbvjE+HgFQS4/BIr696zV5nIwCUMRVYv+VOHJhM
	PA+vBU+MrWxykKTCXfpT9lT98cl7OA202DXveWEEM6ChcvqbrEJFCzfa/VaU5/3n
	4zFBRuiRYuIVIT9JayPA/plFY4CtwpWLOfW8Op9Xt8aGKJbmtjgcO4m/Wa1a9AP/
	KeUbcadm1YQj2L3YPQqnWnYYbYDP3vUKKGJ2r0ZVMEkITzn822qqzk4BiwqBvmlX
	Ka1n/DAKnlbyGJy44+FsinoQRN6VMmUa22YT92bfoYGupRjNYl1JaDzGyDn12PJL
	1JolBg==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heeb9ayp5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:58 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f8281066c4so569028b6e.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573798; x=1793178598; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dwTE3Pos3BZVgDma/NRRNIPIbpecC6fQW8FK8gZC6j0=;
        b=C/YrJyFPyk+kOBnUe5BbPgDzzus0dpYy3YZOlJoQ/5/hapzYjDrZM39KRdgpCzasdw
         OsImrxWo4akgmKH9ogaKL9vAbZGVcJsLj5OMeH5xT6/6+uJZT/Gd375BRm8t80c2DoX/
         za13sy51wYZbIIMm/fQQ7g06k6IdyXDJbnuWqU3JKLoxmn1CacWXR85If0+3Kk7G0QJp
         jjOsySAwnS22p1uEPLi+mxz/Yq7oC8JwNGlVrN7p1QvxV7NjbPnH8YtXtbEQlrt8WsOi
         g0CRfW26pNLk/h1K2qBcNTdETw5Hlpe0be7rnmSLbeo0RB+lR3vTJdSXabrDw5UYogY+
         +vUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573798; x=1793178598;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dwTE3Pos3BZVgDma/NRRNIPIbpecC6fQW8FK8gZC6j0=;
        b=m7CfbW3bhiJErSlG4kK7u6NQqYJU1FqSqxP2sqbrI13GirzwVAjfBinC0na3o5jPw6
         Wz/xjEqH3lcjwNR+l559TZOEwBM3kJotCjvybs0TqZFnrw++L0AC8zfLf506l/aNgPCy
         ilyl7BUArmdX89kL9vmj2hDcriWwyxmcgRe3w5d1Cxtq8FIOPfe8fRdKCOlE5psvcz38
         W1rriZ98dDy2J9+pfjkxmzWMvgF9uL2kP7wAiSv+macImI0h3K+RNQN1fjGqBY84kcLv
         C6rtXVXfTmL3jcIwRrSG7ioJy3j/X+SgdXKr0qrYJ7kYrHgE1Pamiph9wT5MqwPWM/6a
         FGXA==
X-Forwarded-Encrypted: i=1; AKwUvBy43ReWI912DsZG+aWNY9b7IHcpPwZOUTxgbJx3B6znPiCWhnNGZA61PGoAiwD+BtcYI+wvzClaNTg3D2Qinw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKVUPUcFSOGizDdYpZXG32Lmr19o7Qe9zbXE627PeUDOXNe1ZYn
	vQGhcVg4aLDnaG2N4n5dlbp67HrNMrvdLmRtNbnG0xpmmV4fT5JyjfQxxiL6l1BtpWcKUZ+OBST
	p4LQWWcaEt32pdh9os6+nR0TjH048EfuH8SwPmsha8nVs9Dv2hK+so7KBETbUF8bqqksHADqeXb
	mB3hZF
X-Gm-Gg: AYBFou3BZMNVLYcRDllfVzbrRNYQDWjIvGNpKn/E39n2IW49HiZEEgQR21jws3ENqfk
	G0g9I9ecsW2HUBS76Do20kQKODfOY5rV77NiD0Qx9kHixskK8b9UF4n6WFKHJZ8q4zVzX2cEy4v
	2ODiN99nKLkukpQJ9TxjLpClGPOb39N3DWuYDzar8hPnhfWFc1K4jTMk6t72slDjG0OXg9cPgCR
	gRh0RZiujlINRemssTyLF+5d0s8hJJCQEDchgbV8AchufqHiAWJNrROh9Vt7NXl/MCxPX5JN1AM
	SJkKwuX2Bch5VzcTaDwUvxVPjm00U/JL7CAC1OHs0aD6xenFsbXPNFnld4Tvrck+blZ9Tg8xkoB
	kcENRgrchE45ke+w5YFHEK8R4AvVflO7S7ttXVzNWrdPVZt9CbA==
X-Received: by 2002:a05:6808:4fde:b0:4e8:721f:2824 with SMTP id 5614622812f47-5535fbb3a8cmr813202b6e.60.1792573798054;
        Wed, 21 Oct 2026 02:09:58 -0700 (PDT)
X-Received: by 2002:a05:6808:4fde:b0:4e8:721f:2824 with SMTP id 5614622812f47-5535fbb3a8cmr813190b6e.60.1792573797599;
        Wed, 21 Oct 2026 02:09:57 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:09:57 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:31 -0700
Subject: [PATCH ath-next v2 3/8] wifi: ath10k: also wake remaining blocked
 waiters
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
Message-Id: <20261021-10k-sdio-crash-v2-3-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=3231;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=/2dOtNID5u69agznXn4uIB8KW+SaBAax+d/DHi8fIRM=;
 b=q1K/zTxgVqrUOksIWnOs9Obafn/YPuh3uBgZ80D1tHOrVOA9s7YRi9bWvwAo3BjcqkkXtGX7O
 seYqGVjUcmqBNSFpIB32g2C1UotH5rbbmzcd5b0Bx0vY24OSJGzW6gP
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX+3HN4lx9HnHD
 U+Vtk5EqCxDrBexVQk89xQMCe/7YOZHrT/5oq9l2JyMvmBuby+TM6fsxmXWxIE0pilt4EhqWyTw
 KhpJHMP33OFhDSYac++ok1RxhBFfmCg=
X-Proofpoint-GUID: a1xM3T5ExLuTr6W-el7C88-zscRRbEAd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX7QJ2eo//MXYd
 kcZBTDWtKo1KVYVNiSCUW+OOgxuKLzggQdMO5oG5gwNIJc2bYfc0JDARUTpQurQLc8HI9ywh2Yj
 /DkmadKtnFiWhLodjZBTLXfirirAS2MNsCYbASq+/L/oXOfmNDwilRqcJSNjcjJd8VzhFOJZ0Qc
 dX2E07Y5qvTdyRvE0L4MwbBsB9gSbOUg+0DLt5F3iKBY46F5dzYAYab5KYVVJELxYHcJrX0JT1z
 v4b8rkciLIjXNxbpT2pdezsNZ0jnn/jy4LpST487IV/hmWE9IBl2IFpQp0PcjKlwPnpSzJH1slJ
 joZSRo8fMvyG4VrRxXQK1Pt5eZFz0W5FVPQhebhzXK6Eu/58VeSXp5mRkkvrHhr/pLkxybTtJls
 LEX/TIFAI6sojbYp1YrwSx15I7ePSSU/eI/orXraVKejO9pehow1HVTrBXcxo8/w5+dCGVoQLbv
 eRPFaHI7ak5JqPObE6A==
X-Authority-Analysis: v=2.4 cv=R42WitRX c=1 sm=1 tr=0 ts=6ad88166 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=zeuzKm5edEikVQEUlRwA:9 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-ORIG-GUID: a1xM3T5ExLuTr6W-el7C88-zscRRbEAd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

ath10k_core_wake_all_waiters() releases callers that would
otherwise remain blocked after the driver has given up on the
device.

However, peer_delete_done, target_suspend, wow.wakeup_completed,
peer_stats_info_complete and wmi.radar_confirm are not included
in that list. Callers waiting on any of them continue sleeping
until their individual timeouts expire, even though no further
progress can be made. The WoW and suspend waiters are on the
suspend/resume path, where these extra timeouts consume the
watchdog budget.

Add these completions to ath10k_core_wake_all_waiters() so
blocked callers are released immediately instead of waiting
for unnecessary timeout delays.

peer_delete_done is the only one of these that is never
reinitialized before its waiters run. A completion left over
from a wake during recovery would make the next peer delete
wait return immediately, so reinit it before each peer delete
command is sent.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 5 +++++
 drivers/net/wireless/ath/ath10k/mac.c  | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 93140f1ffb7b..677e582b87e4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2500,7 +2500,12 @@ static void ath10k_core_wake_all_waiters(struct ath10k *ar)
 	complete(&ar->install_key_done);
 	complete(&ar->vdev_setup_done);
 	complete(&ar->vdev_delete_done);
+	complete(&ar->peer_delete_done);
+	complete(&ar->target_suspend);
+	complete(&ar->wow.wakeup_completed);
+	complete(&ar->peer_stats_info_complete);
 	complete(&ar->thermal.wmi_sync);
+	complete(&ar->wmi.radar_confirm);
 	complete(&ar->bss_survey_done);
 	wake_up(&ar->htt.empty_tx_wq);
 	wake_up(&ar->wmi.tx_credits_wq);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8e604697d6c2..45a3082d5a64 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -843,6 +843,7 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	reinit_completion(&ar->peer_delete_done);
 	ret = ath10k_wmi_peer_delete(ar, vdev_id, addr);
 	if (ret)
 		return ret;
@@ -5890,6 +5891,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 err_peer_delete:
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
 	    arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
+		reinit_completion(&ar->peer_delete_done);
 		ath10k_wmi_peer_delete(ar, arvif->vdev_id, vif->addr);
 		ath10k_wait_for_peer_delete_done(ar, arvif->vdev_id,
 						 vif->addr);
@@ -5952,6 +5954,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
 	    arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
+		reinit_completion(&ar->peer_delete_done);
 		ret = ath10k_wmi_peer_delete(arvif->ar, arvif->vdev_id,
 					     vif->addr);
 		if (ret)

-- 
2.34.1

