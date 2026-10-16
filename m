Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B362F260F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163807; cv=none; b=ErAC9HzqpW78l6BFHZLHuy646QPhYVkhWzjQ+gB5K66dwSWeE8a1FShUe7U6wyI4s71SOttPN7iqvo+8DU8hgkpmGW5yLtHmL1IMUS5qL023TXb3kWW8l04onQ00AMdtG/+ft3nLRV6ZOyTdND7dvnZteFwNh+2nys28YkzkOUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163807; c=relaxed/simple;
	bh=96QQoWOKZt7GEgyVt5nydIIXDM4rD4fgJi653Tdb360=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NJ7BF9WiTJMC5QOCDqeinjyWdHRZQfjjXzFFUjVGwAkjn/gwcT4mwaG6gvm0XR43hpRoYsiMO16NDvlRGrzX+yQ9yNOXVs+PsuDuM54OvDq+GwZ8cN9ZPH+9IF4fOCA1u3JdMNghVUWXO/NCePBCj0vSy+XwbiNCugLAxuDG5WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E81LUio3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kJ4qNgJD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E81LUio3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kJ4qNgJD"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5qFX1450473
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=pcD3DtXTyDsrYRo/20f6YN
	ybjB6dTu0tq31YCcIYp8M=; b=E81LUio3tzHZnxkDbdd7OveDJNZXLP3E+s7Dis
	Smzpeb10xEGzVNJkgbwLXe2Y9saoJmVHBMqEpGWGkq3H5017/PhM54+xBr3h/4wm
	BdjNCbq1pffrHETtZMiAvn4oADsohkT81E9c37b55KZmvqkx5d/NtAw/Rt+NGGrI
	uM7UAsJe9NQGnJjb9PvgMpePU5/ESnCA+zPmJlE9VvV6EKv7Z4vQDBtr1h2cqgeE
	s6hHJD4rbP7DMeArYAcHK50gN26RRi6ZXlK5rLs8GNOp0XD/yA2PgSPQPipjgLT1
	qry4FjWwJaWnatDM5rixrFRgPwZCeofWOqLOTxAlpGF1i4rA==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbhur1453-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:45 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5ea8f13da94so7881e0c.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792163804; x=1792768604; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pcD3DtXTyDsrYRo/20f6YNybjB6dTu0tq31YCcIYp8M=;
        b=kJ4qNgJDFaP0m1rFkSZ/dvatmwsg+zNmFBZuqEEHbvBOS/habw+dLbS+HavQy3ZCsA
         +vQgMeuY/0vHD9lMdPGgDdhqmZQv6fGZNUN6WT3fFGqpOmfylDuCPbhmdnzl6MQknuWC
         lsuTy1ycp+JagKkgMSUesAOBiNgPWW91NSL7ZZz8zai+Ap3y7A06CKFcuOdXJd5F4cr5
         YA+nsrvMNIcpLD1Ah6gB0kBnhulW/riWXnoycL+d24/hkhM5Mdzq1XTiH4eTPyZ2U4uo
         1XUGiy4N8jrkglro0P7o6BklhlH9r/TXqOHq8OWYmv2U+IicKmmTr2j5sZQYoV2HS51I
         4ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163804; x=1792768604;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pcD3DtXTyDsrYRo/20f6YNybjB6dTu0tq31YCcIYp8M=;
        b=hAfHaZ/0nDm1iTVYkszDtf8FkG+c8k6Q/69VXKRcgWOBhtzy4nrpuEsUlI2xvGb0gl
         HzRBbalOGTzDMevvm1n1dezouKAm1jOkUztDP5p0Ws2JGGDjdRV6gdkfLzQVl0dJu9KU
         PwSvS3GdVujHXUeholpiTJmLbzw8mTJh1a4+2VuVSm2G9r9+8ugG6L14190dMrFgMQaj
         332tmWTXQYWm5Ax130hylUw6qAI/vRSroy2S/+0pntwLLWRNHg1Zb08eB6XNXNTfpGsI
         TFU9414+48xeOdsMPxzE+vV4nLGfIZQvBbZvYtUjRn3EsPMGAal0ku8IHKnK6VJo9HYn
         wnAg==
X-Forwarded-Encrypted: i=1; AKwUvBzeCPBqJElJ7Uvq5BWRuKQsMbBlBVTh5lqk1skDG6b01H3LlwTeRtnY7wDxad4FsDcbh5zGONlKUS7YXLxQ0A==@vger.kernel.org
X-Gm-Message-State: AFq9FYLC3lK+i/frEZftppPXYIdTn8/uvrlKweHKAj7MB//NgGhU6f8G
	tOobJrjxr4Poka0wp9mnOchDmEVWF2MqQCyWmuEmNYH3nRAy4rdMbX68GlFBzLi/0IXqTRCv6wp
	OVK8CMCgh1eUcitTJ+kDW1fedWx/10Ldt0k3G8IbB6HIWnKZJEbXlI0hDY0CxSN0brHdnkw==
X-Gm-Gg: AYBFou0RAr4LWugIZDepxg0ZLRswmc1hHIpyxg86pdzUeMOQHtv2brMsZsON0sqjgsU
	Yqa+ZXSVQe8IUui3KLJVF8dQ0dq6KFRDw8YQDV635FyHkWH7q25lhoIluQP61mZZZFOlKiJ7slJ
	lKtbEzQtZeRSBWIlWMQkCSuHsdeUv/1B4TQCjOkbp9zoeN3XanEGspVm6cV+a6QvQg77YoOxEyC
	SAR5IIWYttbyqIvdPm00foX7UFjQYr6jgmAHCedqbTogWhy1UoH/sJyTTwxY3zGcC7xYt7G3SYR
	5OVPeUqY7NXuQwiZSAIXAIvLr0cewc2idRYsrc6GGJa0QlymXyd/l3eiGszgeECW26vUw9Q+myr
	eou6MEcGI+QF3+Q==
X-Received: by 2002:a05:6122:1815:b0:5c9:a60b:e5ce with SMTP id 71dfb90a1353d-5eaaa67b302mr181780e0c.17.1792163804398;
        Fri, 16 Oct 2026 08:16:44 -0700 (PDT)
X-Received: by 2002:a05:6122:1815:b0:5c9:a60b:e5ce with SMTP id 71dfb90a1353d-5eaaa67b302mr181704e0c.17.1792163803752;
        Fri, 16 Oct 2026 08:16:43 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca31234sm38702025e9.4.2026.10.16.08.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:16:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH ath-next 0/3] wifi: ath12k: rely on ieee80211_rx_list() to
 send rx packets to mac80211
Date: Fri, 16 Oct 2026 17:16:26 +0200
Message-Id: <20261016-ath12k-rx-avoid-realloc-v1-0-0ce6cd99dd5f@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqEMAxA0atI1gZMxSJeZXBRa9SgtEMqUhDvb
 nH5F+/fkFiFEwzVDcqXJImhBNUV+M2FlVHm0mAaY6khQnduZHbUjO6KMqOyO47o0freTy23hmw
 HRf+VF8nf+QcFYeB8wvg8LyFJr3lzAAAA
X-Change-ID: 20261011-ath12k-rx-avoid-realloc-6c8cb3e32165
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Cc: Wen Gong <quic_wgong@quicinc.com>, P Praneesh <quic_ppranees@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfXz7j3fOVbB2jS
 AxeLa4buRQUtIQzStjaHfWgljnQpz4njkfEprknxj9py7aTk08qRnzLyJQlQXLfdIF5ddEJ93j2
 9+1kjHzigu1iypqmIAuUQZAw5xJbBxiWMSO3n5IuCmLgqFohIF/yATd1mSyfx8t0Sc4UFF0m7QX
 x50gs2rjXPycUJgncurh8Chjz2k+qzpgXIdbDWYzB7g1hQJY7lAiTYRgIXIK1NZqT494si9wwgm
 VNex51PmykokTbjSttpGKsjL2dk/mf0HI8r6QKkIAl/FMycOP392r+Ykx4QSUYG3rPmL1bXw7BH
 Y8c/Kc6qi9Uqu5mg1RVNsQbw0PQMPtvgl2X8tERvjXMeR818K6elsJ3T3pIpH8dEE9tB8XLdJw2
 FeXyIXHyuTYc0lEOeNTmhRA/zzpSDZhrPmny6g7XpbZGDkJJBKGVRnuuFEt3RLUqip6rx/s1IhF
 WQs0oS9a6wmBq8C6L4Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX/rJISjPeuCtV
 zsdLAPKlp9nOD/gNLu8N0StqF5n70C2tJ0ZfBggQRoOQ4HWKwVTZe/5v+jIdtxccM6slxOTcR1n
 wbGQ1neldAr2ypgJY+AVDhlnGI8KVQU=
X-Authority-Analysis: v=2.4 cv=PqsG/AM3 c=1 sm=1 tr=0 ts=6ad23fdd cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=3acpehKfv55mO9VuUBgA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-ORIG-GUID: S7g_8DxLjGLGr5eC2AEon1OMrLeJh5yp
X-Proofpoint-GUID: S7g_8DxLjGLGr5eC2AEon1OMrLeJh5yp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 clxscore=1015 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160060

Rework the receive path to collect processed frames on a list and
deliver them to mac80211 as a batch with ieee80211_rx_list(), feeding
the result to napi_gro_receive() at the end of the NAPI poll.

---
Lorenzo Bianconi (3):
      wifi: ath12k: validate RX frame length before undecapsulation
      wifi: ath12k: rely on pskb_trim() to trim the received skb
      wifi: ath12k: use ieee80211_rx_list() to deliver packets to mac80211

 drivers/net/wireless/ath/ath12k/dp_rx.c       |  96 ++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h       |  10 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 281 +++++++++++++-------------
 3 files changed, 215 insertions(+), 172 deletions(-)
---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261011-ath12k-rx-avoid-realloc-6c8cb3e32165

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

