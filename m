Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1B748094F
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339214; cv=none; b=VvpDu3zVuhFRZ3oP2THd2Yot5cbzAgHvJJLyM03JWHIeLzNVunWGdewFsf044qq+HFl0cxjdV2cm4VoFHS6ZONK6trIKmW47WIKq4a2Tatbfv7I2WIABYybRxenLei5R1zHNpEFB3J5RS6zL+36hQ/Ldh1iqqmsDmsnNIDeGF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339214; c=relaxed/simple;
	bh=jml3lvp+3CFd4TeoXSIhb+oy6y5WDw8fujp8rNYu/b4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KL1c4DrHhL6BS4GUriy6PkwRlnpL/SBi6l8PFZGsSHv+Mao/+DnN6eTq3wJKP8BHjnfIcxjpgALPWS2HAZhtjlu4jpdAUx4EfWW81XJ4U1BQ02//jSC0MsEoVnVQMeRs8/1ELRIfjKv7PtBwrbsrdubR2dxOW0HS+Djm7hXjAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ov4uWTSt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AJi0ppqH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ov4uWTSt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AJi0ppqH"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4Yn5A208802
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sOlAzcduDBu879TeeEcD66AvOyeFfNZAYLZI8TH4zSg=; b=ov4uWTSt84Ug3x/y
	/P+fvewHfdNate1hWb877D9DKQVgLwf3KTma8SU03Dae1fzuFRNts6Ig3js0J/Qh
	y/ca9GTaaKKjM62B1Ock9/AYGKogtO6Klrn9FicA1PbuvLrtnpMwk4TZGKy6ffGV
	kTsQ6HBI2LSe+Pz5SCvgcn7pic/nwWT1iLxIny+bThdDXt+kuY7euhgkWL5wv+TS
	HxYLVDKiVh3sBQCpf3mqnZExu+JiZMeE9xK5ByEfbcTDkj+YsK0HlkCxcZ3fkqBA
	11NN0uedK0Bgi8o/yh0UmszrUTox2PuEDNwR398Qs0JHFdkoAU0XlgKnpgFg02i/
	25PUYg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw898uerx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:52 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so2264841a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339212; x=1790944012; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sOlAzcduDBu879TeeEcD66AvOyeFfNZAYLZI8TH4zSg=;
        b=AJi0ppqHsgnQOZc5GMSwOE0K0bDI238Zb6dT0Ny35e8DXSAFAeX45QUApIFGQy5Zv2
         FwXXMcsBaTNQiSd2Nf87b18PCvxNGuY1Yvc8gSZ3AF1qcIsfLecVXO8Iz9QKSXzEb7Vi
         xRbwatLoGeS5wD5+RGlGwJNehWevtKsk8mrPEWb26NI0LOjXHF5gWi1FYR9tkyAXzJCB
         yJonVRlvp6prR8RBSOl8hmJgWrefvDV6jkwI+IMmXyT4YMlS09jEubfnAXL2+xowlylF
         BOOfKkLKWQCI6JEhZt+x/MG4X5Z6KMC7xGxwS4ILvDdf/MSjdpu5ZSOursF21ed6xHMx
         jO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339212; x=1790944012;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sOlAzcduDBu879TeeEcD66AvOyeFfNZAYLZI8TH4zSg=;
        b=XupHnXx2MeHAjgfCVm8yW8Y2IviF7REyMVyIIJYPA64KiaaCjcXQM6BR+zRjAU6lg4
         TQ+biW2mr3DJ1rh09LU3PV8iFVuK0Bb2hEIBSNFNV2BgfinOXwVHyipz8sobgOSXpvAU
         Tt8esai8oBLiY6fUlGBgjIKXSRbL69GcF+I7g/dlYX7xpFq+U7jWiE+bX1VAbo86jR2b
         RGmwxDZ7czZLpPeWAt+nMfkWNsSRoPCmqciZfcWtF6zj/yNv5VaOSVNMOepWYLnpo/Hw
         Tm6ohfUCY25lCiFuOKZhKD0qsRciHxYAEfEWP9fus2GbdO7tU8dm+kn/HStguF4gZK2d
         5f3A==
X-Forwarded-Encrypted: i=1; AKwUvBwoiBsEGneb/17UK4FipKM3vyRUZq1wLGhydDzdJiOKJQdzZXX7ZjFQmd9jJF2CYu5nWOoP1ekkipdv5PkPsw==@vger.kernel.org
X-Gm-Message-State: AFuF++mj15zhl5eZX0Tqp2DPftvKAMyF7W5lVhr7D7TeHmFUZn7Tu7lS
	b5c7mvqJbVnQ9DDrvA2RL531fpzt2oyUi71Oi9tvYgRFl5ueN/KREEFfKv+Pzk3n0VpSNYMPw99
	PkMc76xdDk8R5sRcLxmML6EL+KUwb21PdQ1JKxN1rghrui84M+m3vfH0Iz4MURzQpSuLkeN3EUu
	Zr4fp8uus=
X-Gm-Gg: AYBFou0o7zdQKPlqJgjQT0i7CBAnzOqU7QpljCYOfZmwLpTTtG4ajtqbZo+74/+TOWa
	WHhxwBauT00VUMOkHmUthKcA3ub5yWROnu6LUgT9sXh4kVPEsnpafD62yCmEJckv+McahigXZRB
	DNehASLqcLtI1TyThCh72aRGo/OSLCiRDIaxoVeWi1uZGrOptzWKwhXsOdVPYSHHK9hmN6BRThi
	OT9XtHWcwy8Ui23ncPIS0BdSgvy2i3jtD1ExPecnGyJJ4XurQTq1gNe4fNjhImt8xTCvpWzxIXd
	aEGIpxMK9XTL2O98IedpvNaWjpF/d5whPmnVCoLlVwi4zj4tzARSkZZhibWs2AxoBcE6fJJVxyO
	gYfmxh/UcBCNoSwTIbsqz5FMc7YqSyshcJejuPQ3vHcmgOgwbOWA=
X-Received: by 2002:a17:90b:164c:b0:39e:6d82:dca with SMTP id 98e67ed59e1d1-3a098df465emr4661907a91.30.1790339211603;
        Fri, 25 Sep 2026 05:26:51 -0700 (PDT)
X-Received: by 2002:a17:90b:164c:b0:39e:6d82:dca with SMTP id 98e67ed59e1d1-3a098df465emr4661895a91.30.1790339211057;
        Fri, 25 Sep 2026 05:26:51 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:49 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:33 -0700
Subject: [PATCH ath-next 3/8] wifi: ath10k: also wake peer_delete_done and
 target_suspend waiters
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-3-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=1336;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=jml3lvp+3CFd4TeoXSIhb+oy6y5WDw8fujp8rNYu/b4=;
 b=JCvplzKOMxUzqU7rrdllwJoBAblVwHyStRqSsUlQSNPQZEx42wEqH/YLM0PQJMF3NWUBJr+QR
 FQua3CsmqSeCW3V18yytwyqhOYpH9C9nQXZSDkbgRnp/Q0G7v9xVpwp
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX5Q/7WIjhHzPL
 4iWElYinC5/bKwq9oXk/5aQMn0BpvETmvxddSPmafAeGj6Q8/MrtBBZp6ZYlMY5Kxkya9c1Ps30
 ojTD36GNakF2dDNtVpRrCcdGyl6UjQvDQf6LVElbdzClI0dDmBV0xSJhW4LyUgX74QloKszIaLa
 Z4LZxTkE9KGwz2nO93x00pHk2VNzBWOU3jpgamFmWmvn1jZMJ1lKjGaZAA6K1euUnlIbwC1ncmh
 SHGdDx11VaK4XRnHcwAb1Gprk4xl+d+S2he5mYV4j0XIVN6wfrwvmTwIxuhQ2O1bf3L9t/ItAZi
 WI98UmuQqyxDFstTAZc47bOMlA5dUGwsHE6lrBx+lJM/KnZAZZEPipmzY15J7aSAeOXcLhVFFpY
 KsKhntcettRyHHFJjHEUEbHg2gvg2re5Y5l/nyIUsfwoj1cPvpf4V5cl2Z0nz+dGfzFMX0/TgCj
 cwBnQqa41IKioQdoSCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX9VqHuiyowqXL
 VE1fDgG4OwSGYkSJFy3sGaI6Dl/D2ynb9jBC1Q+EJrAzigUd1ecMpqX3M/Bosw6qVju4kXPbTQe
 RQarkI54q9BvAgO8MAqkcWPLq+hAIMU=
X-Proofpoint-GUID: lgUyZFIoSEgoX5Li27KFLP2OgJZfkdQ0
X-Proofpoint-ORIG-GUID: lgUyZFIoSEgoX5Li27KFLP2OgJZfkdQ0
X-Authority-Analysis: v=2.4 cv=EJWTQFZC c=1 sm=1 tr=0 ts=6ab6688c cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=Jce_KJAP8yvPnwnb0b0A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250049

ath10k_core_wake_all_waiters() releases callers that would
otherwise remain blocked after the driver has given up on the
device.

However, peer_delete_done and target_suspend are not included
in that list. Callers waiting on either completion therefore
continue sleeping until their individual timeouts expire,
even though no further progress can be made.

Add both completions to ath10k_core_wake_all_waiters() so
blocked callers are released immediately instead of waiting
for unnecessary timeout delays.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index be516dc32c1d..f2e457a0fcbe 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2500,6 +2500,8 @@ static void ath10k_core_wake_all_waiters(struct ath10k *ar)
 	complete(&ar->install_key_done);
 	complete(&ar->vdev_setup_done);
 	complete(&ar->vdev_delete_done);
+	complete(&ar->peer_delete_done);
+	complete(&ar->target_suspend);
 	complete(&ar->thermal.wmi_sync);
 	complete(&ar->bss_survey_done);
 	wake_up(&ar->htt.empty_tx_wq);

-- 
2.34.1

