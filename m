Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786DE3AEF3F
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529830; cv=none; b=UYrGVJH2hPd4rGLyX0WlJqOy05TAKJsvX5IZ1c+0DE0rU7yHblNwbw4+TyvHeNL/3IsShMp4mgjVHEDt4nbaCvTsBpPl32Ka2C0eutdDNqvizJX3WjF71FWgtlsi48A0RsD3NPTTup3w3kqePbCawcDHWjyXjSbltI2gsAYRAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529830; c=relaxed/simple;
	bh=K5UaOAM4SpWrqsSOvbKzeBWP9A54e4c84fwHDDXood8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e3zuBGIxg/5b6PebHkEuOgIDTbE7lWEPLELc64U+mUVYXjo3i5eBKLcy1VuTiLszoGmODHTUA0QjV+L5K7uKbuLMHtcwTzn4gKu7CynOAeazMh6V7BCw5lNcXhO9MQMRCdoLfpsA+JVY6y3Dh9cKiMqFnKuaCUQoW54q6rNhc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aeCe45qy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WgaT9qoO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aeCe45qy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WgaT9qoO"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6RNZ72771253
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uOHSQiMKVR1IwBDP6bunGeFjzNHHpa4oZ3vKtcA1gOA=; b=aeCe45qysGX5X3sy
	TEVOhdiDYp1TDUcUFdd8hNxeumEu7fJP/YBFIat4ygTDHVUzt8ffgj47UHB2zHVB
	bRM3VVPnx/a4RqATXvYDCl+8f3kXCs9o6C3KQoXBFByxwqHY4dTtV/s1yZR0LdP4
	e2Tde42pSe2fP1OHilhFt0okEHwxxk6QnSuh88qsXQyxK7nmDlQaEA9Cul93uVxh
	VyiT5pIuZjpuZfMJc0K5uIf+04UvzcWRfXH067pWqGzuDpzmjTtLAzkGpIOJO6Dm
	77mMs91T9xslDw6ZSVraQqH7MqYfxY5EF9iMQ85452xc1VrrMU0C1DWdVXjP8EuT
	nkBw0A==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2aavsa0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:46 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso3765177b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529826; x=1785134626; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uOHSQiMKVR1IwBDP6bunGeFjzNHHpa4oZ3vKtcA1gOA=;
        b=WgaT9qoOAH6hwEb+asSkZpaCjczBNVkJKLzvnTml630cNx/dr4V5YBDDxpA2GZ1Mm5
         zvIL0gaK/Qk1J/Jm7a0O0S161SJo4WEkg9uja0c9hmmmwHEyBKMyGHMv9d64vzLs6j7d
         1YMrEDaHV7Vnpf8TEG8BrQ2AXvL84Arq0FHqmLew3dxqVsWhtwPPI0LhNmS7GnwHmWyp
         JxMQ0lD+kwCKWT+j+5sLm/h0QdqnkpxvDs2ml3CIwGAnyziIOdSRtRsvY++CQRfRL4a8
         NEa3A8+lG+IPN1vcYVHtoaGfrnCXlJExmIpQwB5fSNHQVAAWbznVPyB/UZ9XI/3HGPZi
         dkLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529826; x=1785134626;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOHSQiMKVR1IwBDP6bunGeFjzNHHpa4oZ3vKtcA1gOA=;
        b=NiMPKieLmS9FN8HkppUSQ5+uFGb+dksHCRDJImltLJH3PQwZRSncL2FEV7Ljx42cEw
         a/jhnQFRFazvgBIQJ3IYBO6aX/VGwaCrY046qXaFKd+9aUYm8x6dMl5J7RvQi4DcOHvG
         dqLlPNTE6wH4XoBjDykHeZoAzsUKkKGtY5IOY//p+ZX2aov3DtQB7jzH9r55DcK5AMax
         LC2DNWKIwEVDh+xGSOio/GlmEkXCE1nsj8L4WoqVSafkxd9MjtExZ9ur4dbRVIO4mrr2
         FUcKtSYCYErmdkLUX/nEYfEu6wg8YDc6TTob9Rn5wlnVO2zuV5LCOftX7DFC4ESkB8/N
         YUTQ==
X-Gm-Message-State: AOJu0YwuXllZQ6OWQlWwBNNve4omELs4omOJWjP8n+nD7l8h2aasIoJ2
	pGaazD56cEhJXLRKjJfQMghpPfLq91UDL3jJl4Ea0s8jj0mww43FWu3g8HDegKeL+wdmD7uKFJX
	9Wj6JoFN1xr1z1hmDWDQV0r9rqTJhcE9tizF0Ma5/0qIvaXVMPfaVv4nXc1orlP3Vuh7asg==
X-Gm-Gg: AfdE7clwRSc6mP7pL8ILU79j3JKzaJ3j1VpQ26PB5ZRNuRUPxs0L1dZIx4YzfGsS9/r
	weL0n65x94OIJmqms8Ilr37bMO6cq4A4EkodMP7j1O2k5aq2wcWn/Fcx+PHGxDL5imppRUMeU+p
	4CiJWSohwtN30hNmaRSAly0LFv5cXuqkzgO3zKLKi4ZHfbpG8I4Jc1AQ0k3VBaD40fOfGrxYt75
	dPio6DgXGDI2p0U8x7+3fYB4m6m5YMqh4UHFXz/LUTqGEjo0a07ECRqHTZ7/+RatMT8uiZ26ABl
	0NKgTk8Q1qvRJqQQmS58BSOpPSFtbssZFuqv6IRxUnVmfoYE1Tu7UkRw0+BHICwgnox6++OOexl
	3zZUsLv3KTM0bts0QItq/mMPd0So8peJStBuL/BJCaWkqIYhyKVYHTA==
X-Received: by 2002:a05:6a00:2394:b0:847:8bd0:1b96 with SMTP id d2e1a72fcca58-84c28aa6e58mr11631400b3a.23.1784529825645;
        Sun, 19 Jul 2026 23:43:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:2394:b0:847:8bd0:1b96 with SMTP id d2e1a72fcca58-84c28aa6e58mr11631382b3a.23.1784529825163;
        Sun, 19 Jul 2026 23:43:45 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:43 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:27 +0800
Subject: [PATCH ath-current v2 6/8] wifi: ath12k: do not advertise MLD peer
 ID for firmware-allocate devices
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-6-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: JrOHiUUP572mAo03pL_2KGQpNy1LTRPR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX2yZpYoVEA0Ux
 u+Irpa51+/Co0eiusWFkAvmEM0GZzIW34e9suyR+m2grIuVjQya5Uzst+sC9vMlmiP8o1R67jNs
 8rgjG8gCFjTh708HIiiBnJj9HDycWuc=
X-Authority-Analysis: v=2.4 cv=b9aCJNGx c=1 sm=1 tr=0 ts=6a5dc3a2 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=zO7lKvSgDLHZEP5-WbMA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: JrOHiUUP572mAo03pL_2KGQpNy1LTRPR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX3nUXa4eBaF2X
 ZRg+DwLSfB3WWz7Fv5FpjnkAZw+2cAOGka6BK6GW7CIbIGnGSA7bjEoJvmTSEJahaDmwUU+pKlh
 Kk9FKKgS5W+LcE4Cq5unMxLlNMVI1R9SdLDguJ0LJC4MzlCwtiu2eIatsQP9gpP8aSNo+aSlXH0
 6neFcTK7cpNCQ09HRBibEiYbkK0seUHRFXsk7lw5Bd2qzJZt5IwmCNyMU8Ee+yt9NM+EeBamyaU
 luMjZyeZoTRmpIoSHqCjrXJeLGszZhSEPVfQaV0S+XLEgwz33pRgh9IH7t6tpLrapnsSeeuzJmB
 +mBSzzVOfDYU13IJIi/dcIWGLGwtlLPL0Bynr0tE0wU0Slw/OYZ5zgAt47V0K1MLYH1fS0PZLqF
 uV8QXfDIEQNNeRBSr5GA0o1XaFlf/0UEWJxa05/zeTpB23PTKDuoekPQ28MGvdv80NrYe9C7A7G
 JT3bgXHXd0YP082ReOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200072

ath12k_peer_assoc_h_mlo() unconditionally sets ml->peer_id_valid and copies
ahsta->ml_peer_id (with the ATH12K_PEER_ML_ID_VALID bookkeeping bit masked
off) into the WMI_PEER_ASSOC_CMDID ML params, which causes
ath12k_wmi_send_peer_assoc_cmd() to set ATH12K_WMI_FLAG_MLO_PEER_ID_VALID.
This needs to be gated on chips where the firmware allocates the MLD peer
ID:

  - WCN7850/QCC2072 firmware always picks the ID itself and does not honor
    a host-supplied one, so the value would be silently ignored anyway;
  - QCC2072 firmware additionally crashes during MLO disconnect when
    ATH12K_WMI_FLAG_MLO_PEER_ID_VALID was set in the preceding peer assoc,
    so the bit must not be sent at all.

Branch on ah->host_alloc_ml_id:

  - When true (QCN9274 etc.), behavior is unchanged: peer_id_valid is set
    and the raw ahsta->ml_peer_id (without the VALID bit) is sent down.
  - When false (WCN7850, QCC2072), peer_id_valid stays unset and
    ml_peer_id is sent as 0. The firmware ignores both fields and reports
    the ID it allocated through HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP.

The early-return on ahsta->ml_peer_id == ATH12K_MLO_PEER_ID_INVALID only
applies on the host-alloc path, since on the firmware-alloc path the value
is ATH12K_MLO_PEER_ID_PENDING here, not INVALID.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 1ae21618afb6..485be2998180 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3529,11 +3529,16 @@ static void ath12k_peer_assoc_h_mlo(struct ath12k_link_sta *arsta,
 	struct ath12k_sta *ahsta = arsta->ahsta;
 	struct ath12k_link_sta *arsta_p;
 	struct ath12k_link_vif *arvif;
+	struct ath12k_hw *ah = arsta->arvif->ar->ah;
 	unsigned long links;
 	u8 link_id;
 	int i;
 
-	if (!sta->mlo || ahsta->ml_peer_id == ATH12K_MLO_PEER_ID_INVALID)
+	if (!sta->mlo)
+		return;
+
+	if (ah->host_alloc_ml_id &&
+	    ahsta->ml_peer_id == ATH12K_MLO_PEER_ID_INVALID)
 		return;
 
 	ml->enabled = true;
@@ -3541,16 +3546,25 @@ static void ath12k_peer_assoc_h_mlo(struct ath12k_link_sta *arsta,
 
 	/* For now considering the primary umac based on assoc link */
 	ml->primary_umac = arsta->is_assoc_link;
-	ml->peer_id_valid = true;
+	/*
+	 * Only chips that allocate the MLD peer ID on the host send a valid
+	 * ml_peer_id in WMI_PEER_ASSOC_CMDID. For chips where the firmware
+	 * picks the ID, leave peer_id_valid false to avoid unexpected issues.
+	 */
+	ml->peer_id_valid = ah->host_alloc_ml_id;
 	ml->logical_link_idx_valid = true;
 
 	ether_addr_copy(ml->mld_addr, sta->addr);
 	ml->logical_link_idx = arsta->link_idx;
 	/*
 	 * WMI_MLO_PEER_ASSOC_PARAMS expects the raw ML peer ID without
-	 * the host-side ATH12K_PEER_ML_ID_VALID bookkeeping bit.
+	 * the host-side ATH12K_PEER_ML_ID_VALID bookkeeping bit. For chips
+	 * where the firmware allocates the ID, the field is unused (the
+	 * firmware always allocates regardless of the value here); send 0
+	 * to make that intent explicit.
 	 */
-	ml->ml_peer_id = ahsta->ml_peer_id & ~ATH12K_PEER_ML_ID_VALID;
+	ml->ml_peer_id = ah->host_alloc_ml_id ?
+			 (ahsta->ml_peer_id & ~ATH12K_PEER_ML_ID_VALID) : 0;
 	ml->ieee_link_id = arsta->link_id;
 	ml->num_partner_links = 0;
 	ml->eml_cap = sta->eml_cap;

-- 
2.25.1

