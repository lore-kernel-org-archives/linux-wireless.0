Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506A44A401
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339219; cv=none; b=Cwo6dL/TZRkFldOf1p6nDS/4HhOgBV8QJ//NmvgXqAAoCGM2njlRti3wpxJJh2BpDNNJgXbKnrfmsh7ef1YEE8Tc+Vrav9PvGt/vl+7CU2EjK8Y30lVvnURgJEQfv+a4n9Za4DmNod9ZUIFvCSuT6qLZKgQBpcKrYxhEr6jYy7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339219; c=relaxed/simple;
	bh=qDHwxjUD+8UZM/3Jp2H7I6rAdDHpUJZY86zTWrG1hNc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iVdFU3HBK/X3DrDE7oE1dlD7QVBsyok6QHALb4hQl128TTs2co+2UKjB24qG/fcGyb2CDllW09cs3yiyymzYR2dJ+JukHm95/xPLk13CtSlB3g5SO5T1F/l8C8ApZLUw+LXSy2SBr3xrfgk5fFopwtNmdIwVwGG+m8EyXwO3ufw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YPuF/NNh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bDNRReDn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YPuF/NNh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bDNRReDn"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YS542911644
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5w7q9ogn31YAk0QYJSlGxujKIiOMeqXwjSr/p/4Hy10=; b=YPuF/NNhJ1fqJwMZ
	roaklHfCelHPIvk9+11KTWRlpwrpPjwY3JiOtWf0HZQN8h6+8a9xiPVUhF5sPiPk
	Bgu6PxXJrDozIYd1AxnI+CVqKIpahbosNsmEq927NyLY9T1zTRS9WfdSeKAF9BGK
	ZxqmE6VvtwhZwZF5I00QRb/TJ+EDXfU9ujeWCeOP5YCq52oC5mUGtkqeNzCt3AHL
	WQ2Pk9Fbr2Wq8tDIHaKO1EyvXszJk8zlBrmSaecpfjwRUEOQ8bEKku9/DEK9FIk+
	0p4f/VnRHxmnHrHKbLOsRvn8aBaYO/6ONFL3cV8xQcqmyGz2MyivLxA69sMeHF4b
	nI96kg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwhm51fvr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:57 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39512608fb1so1436891a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339217; x=1790944017; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5w7q9ogn31YAk0QYJSlGxujKIiOMeqXwjSr/p/4Hy10=;
        b=bDNRReDnu5xTJxNZDl1qBvUs/ee5j4rdI2mCov4fqmNIYHl5nLcOYSqqdqwaoBjm2X
         Gv1OM3/qnnEyEP0WKB+9RtvaEffzxjyVyx6Mhz3WeFnW7GaCnVDSOteEOnRW9H8gWi3S
         rdb/gMguGbCi1ZjPG3FCEO7rqyUW12xIEN4RYSjqyaxJ0MW72Vyz+t8lO3wJAvARt53z
         1AZN9nFLtMxYxkYZuDK5a+BFd3TM14WOqER5TEdv7erdXielUyRDUUc6E2rbY670PfyI
         XXRhdUu6F9oMhPzgPOcngZe6hRrVZmopjmIB1T7W3ZYZujh+cv+4Pjluv9Q/0AYawkom
         VyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339217; x=1790944017;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5w7q9ogn31YAk0QYJSlGxujKIiOMeqXwjSr/p/4Hy10=;
        b=shODr44Ybtp3HG2eMokV65IqiLBDvSQFipqftObbpTDEZs/ncRTxaJof6Gnvafk1iF
         17NpK0Ezd5oGsF2VUB5Cly/fRITfYjnHvxcJ4dwG3cvJbqziucIIBcWSJjNmFqOGuZ4x
         5VnXuwQVDTE+jweak7PUp3RUqJrVXpi10NWOGRaOu9Y5EgGjcIgKXgdSaBM8gTugvjgl
         sdrys+6A5KEYOX2WMWrfJZDi2lBmZGeMBg51NJAsQO8PAxLqlGISdDUxGKPElw10HaqE
         JlRETjkqNQ6tEcQBWFyc+gk9LWfnGVbVJeJKnkfvhTvX3YtC6KZox1K3+lh/kWPOS/bU
         l7yQ==
X-Forwarded-Encrypted: i=1; AKwUvBywAiYP8sGauLMRVLvNegHRw49jYO1GBL2nV+h5+N/B8/P5HnAe19wAxAtf+nuJQ3r8WTvwzEyTL29fAhcFPw==@vger.kernel.org
X-Gm-Message-State: AFuF++n8tggNRJQkFi/RtGJD0mtBY0XQ5IhFVBpex7ulyGrzU062EXVq
	6fkJCfSpp2gqszXOGlpgtL3A/0ylgngiabOg6fKY9uwuK6dayh2/MuITRiGZEyjOL2XqCO2gNuc
	JhcFANt0SzR9R8YnUX0nHjpeAkcOT6Uk1jFmGyYax2LaP21OtQoJDn2I7EZpjl3a+4m44exW9sX
	4CJSPxUVo=
X-Gm-Gg: AYBFou2NsY632Cn7zQb4oV3UuZSosqXa6mwxCgUFZLNSjqPOIb0bVONfk0WCnGG28Jm
	ujKWmlVM7ay9GVyX3v0eGe/Ld2SBFBnAffCkP2YWMIMazdKKDvtNnXBKDBtvvcop5UPf4ikFcWg
	oiAqaUO3uOwsnxCEm13w7laZRbnhNQXFtNeEHu3t9Jn7eO9e/0m9j8cjnK0nC2gSk7pDrBIB0Kv
	7ZLk2H99sjnLSgN9eT5J/mqvbwhelPlFHYDwb8hSGVO1vivRYdgECniYLEKBfYnZyAKbgIDjQVD
	g86YrOMhKtXFrOqpoJeNklgXejVpanC9Am9UfW5/8WNYWOhGQ9onYHN5miV7S+IB7Ny6XAbopJd
	9+bYm+rh0h+cYcT9YSljqRP/JhRxy1ePKmfUlLZe6hDWI9CCj/5g=
X-Received: by 2002:a17:90b:1c02:b0:3a0:94ec:74e0 with SMTP id 98e67ed59e1d1-3a09929094cmr5081604a91.60.1790339217167;
        Fri, 25 Sep 2026 05:26:57 -0700 (PDT)
X-Received: by 2002:a17:90b:1c02:b0:3a0:94ec:74e0 with SMTP id 98e67ed59e1d1-3a09929094cmr5081590a91.60.1790339216691;
        Fri, 25 Sep 2026 05:26:56 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:56 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:36 -0700
Subject: [PATCH ath-next 6/8] wifi: ath10k: hard-block the radio when
 entering WEDGED state
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-6-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=1566;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=qDHwxjUD+8UZM/3Jp2H7I6rAdDHpUJZY86zTWrG1hNc=;
 b=FA5KhqslqB+mtpYpggXB0lgfb7PumDyJ5eQqa1r4RvGGUxcZW5AJBY08RVU6GUpxycajNolW9
 g5LwklyF3D+A3jbpLRlUFYrU3mmQAlZgwLgobk9h1sq1Mx4CaPkmkK4
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-GUID: t0c11kPewIhP8npK1p8az58XA1imphTR
X-Authority-Analysis: v=2.4 cv=QYnzLcbv c=1 sm=1 tr=0 ts=6ab66891 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=F3v9Kh8TxewD1bH5_NUA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX7JP4YSW/AXPD
 Dwhqdl6uDGqMwKcI9HYC57GBVh3jeHWqqJsfa5iqdFP2AtXWV41g6uPxik1xMa5yIXC2GMGQtr+
 7Ey6qHKbru1mbHvAQ3bwWHqgElqEEt8X+7shbbDokW4wF3V9yD9q/81r+jP4SdaPP8KnEHsGt9D
 XtMX1AoBchEa9xrwY7d4TqT5YcoMx9dPkDfgPa1R8UdEDnG82oFqqWMNZ0maDmpjDB1RwjFoSwY
 ubk4DI8ggMsZD6xDoIrtC3Nmlt6oo8pUev59fZH9soST0sSOROxIwxPRFaRnps7E/K5d2FGnzzA
 10BxoERgkB+ZC0QibTkc7yn7rJ7DIbyTXP25Wk10sOduDI1m7/3TrePFMsL+x6xLLQeDOov+lW3
 QjLw4OQWCWu4gGXJKlB7Yvm15mcJMw8l0zg43yG0oHVVJEdhveNu/kf81JXPzeFXucDmEXDT5yv
 mxcnK+WIFN9kHID2A0Q==
X-Proofpoint-ORIG-GUID: t0c11kPewIhP8npK1p8az58XA1imphTR
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX1qQKM5YkZFoc
 soB42AbV9HrIRg5y4pANawDit8ctRTuskdeGvG3f5VPbqdeBb68D9N1gCyB6aq+hwtjz2zNFgay
 Ej0q9gU5aGVCy/XYN9fUN/srhR1SsA8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

Once ath10k reaches ATH10K_STATE_WEDGED, the device can no
longer recover and remains unusable until the driver is
reloaded.

Userspace daemons may continue issuing scan and connect
requests, which the driver can only reject individually.

Mark the radio as hardware-blocked through rfkill when
entering the WEDGED state so userspace stops retrying
operations against a device that can no longer operate.

Both WEDGED transitions already route through
ath10k_core_enter_wedged(), so adding the call there is
enough to cover them consistently.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 93dc7332c759..0a87a577b3f8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2518,6 +2518,14 @@ static void ath10k_core_enter_wedged(struct ath10k *ar)
 
 	ieee80211_stop_queues(ar->hw);
 	ath10k_core_wake_all_waiters(ar);
+
+	/*
+	 * Signal the radio as hard-blocked so userspace (e.g.
+	 * wpa_supplicant, NetworkManager) stops looping scan and connect
+	 * requests at a device the driver has already given up on. The
+	 * state is cleared only when the driver is reloaded.
+	 */
+	wiphy_rfkill_set_hw_state(ar->hw->wiphy, true);
 }
 
 static void ath10k_core_recovery_check_work(struct work_struct *work)

-- 
2.34.1

