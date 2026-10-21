Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573805;
	b=pWvMzW1WrZeqbTsnblu0e6ndKI6R/WSt26UuSSdiyQ+c+QXWBeZNx6VBWvnpBIf1uOv4
	 9g+yB+gx92rW4u+4s1xnxxyIdT959C7VahZC58GbcHFklm+fGsqm2U25pwisocP7YRyB7
	 OOkXFEyXHyvUvggCEpwd6psgrhbNNHyJ2NiZok90mCTlmzPOkqAYWUTb8B7jQSvSmN/UL
	 pBMh5CAxr9lgBy9MHqNTU1iNgG8BVUCNGeceHBaT6/7hmol3QkWYTWUTzW1GfBK6aWcSd
	 4TltwYsKPtum3pT+5zFGqKObjWO9uYIz6J0zLLYgBuyRjGht07vcdQ5UVt/Ri6AsQ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573805;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=SPVcsUgfs7OUGvpBli68749xFmB+62PrtmbrcnsPIas=;
	b=PZWNvV8QYQoCRl4gxydgSaw59z5Ps286ExHvtN2fTfdh6sclfFtSy9+iTg9zvl37EJ5q
	 jT1gjFGTRIVVjVkCuLw4c7O9YhhnWGe46uv1ruR3Pj85/Z4NplWvqGbXBZnrCK5eyIC3F
	 l+CbhazsWEzqDKr7mf9PcCKr3/dNYr7guFY6QyZ6jNCf0rY2cyCzh9sEKtmAnosuzy0sD
	 G07Tf22juTgSSP3BkjFt5VNZ24Xj9H9jgvBlm9Rxve68MmU8GU9JlUD+p92KdbodSwk1m
	 APQj38MATzbWiXZvhOLv4LlvcPFvrLLs4YkkJ7Ryt9IUcR/jmB9AMKXCoQ3ooLOy+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cOnlt0h1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SjGCBp9N;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1D60A263C
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11B1D60A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cOnlt0h1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SjGCBp9N
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jL9Y3929522
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SPVcsUgfs7OUGvpBli68749xFmB+62PrtmbrcnsPIas=; b=cOnlt0h1d7kKb+W1
	IVQvBkgrSep25aqhcWG+aMMBO51uTK9AsxijMqx3H4MdBqzjAI6yAkQYLYDSjaIb
	WPNjD2t6iuIV3/unJ+pwALGAKJrwfZYkc1IAAvHArTRrReYvvfN8zUlQM36KF/WN
	ioZE7efeAA/CX6CH6jkfUzI+W9Gh8KGXzw9xxYVBwvDWregJfULg/r1aI91XZF90
	5Tpo8ew8xl6cfFXZSmR0akxHcdLa8ep4/UK2fzAErLsa9EPkn/jnPlJ6ClqlnHOV
	xGsXYKPGYeiSnNm6YnNNK+S1/oHrquHVtE6rLdxfycLRPkzSWY75m6q7c8+cXq/P
	0tgD7w==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4he7h2crkd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:04 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-82169fb66c3so1174518a34.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573803; x=1793178603; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPVcsUgfs7OUGvpBli68749xFmB+62PrtmbrcnsPIas=;
        b=SjGCBp9NxNGg07jlCyB1YmTZ52oN7eU1NjENN0zyiPYG++iM2SEnXFIJHf1NhLS/3y
         DcFVhh86APrRgJfcIYZMOQt1S5SQzFzzJWwnbawudD/hUkkpeuip8J9TsnlmeHE8YetD
         jNkaWPehz3i+UT8OvybQCZJJQX+KxfE8DlsTss5X678nPNqfwCKbxwxaCEGUQGrZjGjw
         1eTlA/B6njawXz4IcIgZaZpKPNXXIzGyHpMfgdn2PudU8ogBV9xBr2zUKSNlZWoob13k
         x8LlCHl5/40B3+KTgUc3Wfij3qnFtMW7XCb676boInFwN2yVuEO6xyPBUTXDNt0oIue6
         q1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573803; x=1793178603;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SPVcsUgfs7OUGvpBli68749xFmB+62PrtmbrcnsPIas=;
        b=bflgUEKorHQNM1vVSdyTbC1T+zwL7PyPY4Ori1gwjHI1EGPw/CO/vQECk7G7G6EBic
         SgjHBFUYZCuLvEcIwF/z535UrrLsmAZhKm3waGBWfVeW1kiGX2uGm18djTkz+4aqSMPo
         nVxFvxhDpTc2Tt3sZa2tG/saYoVYP+1S8KU/v14yi4UpW26yHddaWBSulwsVsbYebZoZ
         fYnGz5VnDIIUi2eUIwh2+UK3XPX7usDSJOsOnlynLGxH0GP1eIm3sdBaNpUQGo2QPuFN
         iYXgRwiIj4fpelwH7WcIEP+pzLyt3IYfQ6nQut/Cv6ALu0ul51rvVfm328u+AjxyuzpW
         klEA==
X-Forwarded-Encrypted: i=1; AKwUvByZGHBduMjqyvE4haOznde8hBrKYH1IDJacjUWqFoxJL2fSxV8va7PuirfwmQeV4+mHssg5mkGHbh7Cco3tKA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKLxEMNZC6ysNRppHGrzVy/5L6gqH/OPQVkfcn4bUJERQ4FssZ8
	Kzp9KRLpjZ3Asq3ANP03ArGBEsP56YhAYJq8g8F3I9hSDBuqkpmLAm0+Dq9SVTNFbqHlKtq3QAy
	Ntw2m28fsnZtHOjTyY9V1d58wmCnWjnMJa4UUthwxcvBgHcbaBzPQcgBvHDLtxBG38tWKQLNxrq
	hgqIT+
X-Gm-Gg: AYBFou04wGyUyPO4noEgHx4WrccOv3EAZDzyu0/RRY5IlXOCgG22LTQNZjWRTYJVihW
	CTaI2XzrcJZLFhgor7wUlIkaFrnMtT9wp/JBtPuPr32UxiUe30loa47cL97yPBGVLfTCRzQi6to
	3Mnt1X1mFpTjtkztqBlovtSZMD+L+NyHiMAA/CLiyjJ3zfsklbVbxWs3SVm0qyUXQKF/ZbtYNdv
	sV6dfFbDZd7rhOp3PggpFbCBuAsJ9kqg0CKEIigi7zkUZ2GaZQo8R7o8KGamHUHDb6OUpv7LDWY
	rQtZVxprM0O6muzWuiSnR9nVbJlo9QGo3Zb/dYwqnqOHB1OTwZVH1xcmQuHvP01QJSOzjnguba3
	1c3y/1jbyuSiwKXduv5s75bj5g3z7R5QCjMCe8kUgYyLASCT4Cw==
X-Received: by 2002:a05:6808:6d82:b0:4d5:295c:a82f with SMTP id 5614622812f47-55364d258b5mr732742b6e.60.1792573803451;
        Wed, 21 Oct 2026 02:10:03 -0700 (PDT)
X-Received: by 2002:a05:6808:6d82:b0:4d5:295c:a82f with SMTP id 5614622812f47-55364d258b5mr732726b6e.60.1792573803034;
        Wed, 21 Oct 2026 02:10:03 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:10:02 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:34 -0700
Subject: [PATCH ath-next v2 6/8] wifi: ath10k: hard-block the radio when
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
Message-Id: <20261021-10k-sdio-crash-v2-6-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=1618;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=6wQOkQ2hXX9hGjM/vuhKeWn72iJTqSx+IKksWMLSs/U=;
 b=CzZ+VAhpbP/IGkAFZ+AV9iboiPWbMFmvSs0lxqlueWoldNAu9/IyQgofM5dHnMG1CA7F2H6Ef
 oqaTgWyEYL4C9tb7TByplY7sck+Azv17w+IK5C7cpGpPVqKpHwsggGn
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-GUID: zH7QLrST8nHGuA9G5obVDYqhyOJh1jdS
X-Proofpoint-ORIG-GUID: zH7QLrST8nHGuA9G5obVDYqhyOJh1jdS
X-Authority-Analysis: v=2.4 cv=EuJHPicA c=1 sm=1 tr=0 ts=6ad8816c cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=F3v9Kh8TxewD1bH5_NUA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX8wjLrGukYzwn
 z4JF5rPTeAuJO9kMDE7hLvUNJokwQLh75aZR2kCKaAvIE1yITN7+HY9ObxYrSFT+Mza3N1O479i
 lXKKIRbn3JGqW15otJcDPwmIAc8yZqA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX5TlPPvt3Z+iX
 sJ4yYMQwtl/kdHaMx4urrz1GgyqShju9Zidt+Nlor/8rNeafOLTUSQWXnENSHHvAh5/DoHbhA/n
 0ll0SnXom/OLQ1LwdUtcAvDbAnyvXo/2NprdGtAmv0VYl4OXZBc35PCwImlfdeiNhPdTGdkayDP
 yMZPtwXJS7QmUw3xtlnrrKhTuwMC7txexSnuGCdWDF6HBvsRqwgPOTg/THrvud8k6O/suyxFkTZ
 jbsHXbyzsiLn2ZDkczeMCHm5oMpM3pWBWqRTTY+Xy/uZBHVMGpZcM1tzE14jvicTHlM82y2vaH6
 GEMWrhCZdEfFlt90Thym++FY62EQjcYdJuOgn03vL+NUWadIQVT4HPrVpJRPtU4HW1zWp6ooJVV
 YFavkc1Vg9NrD57OOv0SSNTRgVrL54qjH49Tmu6E2MAzGuh2eqDnLvLt4vXQ3wQ3OWq8CiWCgwX
 ra3VytGgW/t1aaROE5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

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
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6b6b80242cd1..66585cfa6d96 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2521,6 +2521,14 @@ static void ath10k_core_enter_wedged(struct ath10k *ar)
 
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

