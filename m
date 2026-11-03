Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726767;
	b=hlJIRbGf7h1bI/JiywWpoeZ+tkL0UIknfGSTLzpNavYK2BGuqOCsmUQy0pe41WKZ/Tdf
	 01tbvJhSP1uSQJslSHKNc7FAqqm51/u8t9AlEvsdSO2SI7pI9gxeBMbyinRJA3D+uf+7B
	 jMKf1XBHnA8gapDNoh1P+BokIJdojuOhV7ViZK2/1t+gAETfSsoEwIWTo0CsY3E+p7vVf
	 A1Sqb4T5RjVSBrsPA7tZbe1Kc9T/TjbBUxtAd8IpmEEidNnHPm0/KdvshZ5SJUBAQQCRQ
	 DuU8Kk9q5CfCG26Afg0qpFlOBiy9Y9Wac+/TMHjxhq+qq3H16hNQXsv4jO4Gwzruu1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726767;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qwa/XM4zZaFwBwMlrXOoTLw077/bwjKnjbAnCI5aKj8=;
	b=HrlCr1qqZnPXnh1VKWb1UVUJZenETh5r1dNuL18+8u8wLdMzByp9WZFDiTZb7Ka98a42
	 rQ2vW7mebDHZRoVt/bxRNFzXAk+PFDivXkZ60BQmxuORU43bH2oRDudCgmQ2B0e6j60dI
	 TljjdqdulES7mzgYRWQYOFjl4SRbdOXNi7VwGCnooo/TRyKIb6YvJz3wFY8zsEW34nQKp
	 5oSZLEeKv2WfHlKcalOxNT+CrDGv3ip+opjoy+Qo39MA4C0Lc58iXajLBBEsvNpU7vvt5
	 Ul+b5Wr4ij0bOe2OqJKUkMmdbnsdoemSRGkYXLMZM5glSB5iNRoHt8B2qfIVyd+ev0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=m0j9ktfG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IgTmw59o;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADCC606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 17:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ADCC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=m0j9ktfG;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IgTmw59o
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3HPTCp3161488
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 17:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=qwa/XM4zZaFwBwMlrXOoTL
	w077/bwjKnjbAnCI5aKj8=; b=m0j9ktfGMfOtof9Tvwlao/5KfySXAHgqIqti7g
	VTg3YX3cbbBjmTbx4l3p1Mbef7LFOPaNyTQT1tYn++WU6F7l2RZGO0TWfY8rLF0M
	v8E3JvALZ+4+AJJL+zfqA6GR5LvS2aaINs/xnJQxF27kKiS8gHBnv6qmFlgZ8gal
	K1+F7WPi4ndocq9VZOxLkkrI7r7S1Fv/UFZvcDIwET7BhlMPVDphfaBHC7punqow
	NHY0BKWrTw5dLa8TWC6LqLRu3sqsFbfJFZkX0e9jnVc8QzK2C6RHswGU5SdZew4O
	faMJ3Vh4Nob36Q561ujujPSfVwgy+lrEktdxXLDUOjQYoNzw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bgwma-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:26:05 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso5087398eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793726764; x=1794331564; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qwa/XM4zZaFwBwMlrXOoTLw077/bwjKnjbAnCI5aKj8=;
        b=IgTmw59oIwQs1mPltg8zflJPDaiqOqc++yNOlSWggxgedSzdxOYa83Jj9vG/BW7YfR
         LReAYen7KORwkftMOrJbhQiSdQs+boKDGM13TK/9UCwyu7ZvVxeXv/Zu864DDTr6n28r
         KIxoUU1TCWHNKcq75dSroU95Ht5vOS6WbriQKdts9oz3STmNf9IL9zhjk09pFuvN5jq1
         eKMEaXV8qko+LYh0XETQ/roxJQ+Ok8o29t53jyBeOm+EybRBAS8CzR2Vk1qKv95MshI4
         dqBbjE5Br9ORxf/+OcOwof6CwSoD/5SZRV0ijXCTwozElhg8oBUjg9EeCED3vam1LgKv
         LRjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793726764; x=1794331564;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qwa/XM4zZaFwBwMlrXOoTLw077/bwjKnjbAnCI5aKj8=;
        b=FmI4SoZWhRlFTYOlfV4hBj1LSFlLykRpCw+fXAuxMwJRS18buOWbnRsITWBtlcowLe
         7AZZ6defToe4yFG64BeCM2DWFN1DrJWRnVam00PoneGNALaHtZKMHrT/jKsFi/9Q3MfN
         s113SPAJFrSwzglGqOvtf/20OJRBSDsE1AWxv2eIsj6/eIIB5he/KhZ9WE3whriu9i4k
         cckNNu9m7UanqYqlaTTBlU0lyueiQE6asFzqa7ACMDEthgAdwjtube0LSID8ffoUXJx4
         f+zGw1yzTFLcObTf+bnsL6AUl9wlN2TnJFyPgZYhW1ZgRYvbNYlWAGXEXIg07RdCFHeu
         jTaA==
X-Gm-Message-State: APuU4Z846Vsch+SvKm40/fvGG5KogShnP4Ap2PjopkCkHDzw7CslrqAg
	0TKAXzPJlFmLLCZlXm6bvAR22iWDI+yAjzEIlBwqEs86CLdNqLMSA8rR0p9twCNVTYxdbWz4l56
	Vi0FO0g8iHCMgPdHRKVlk6gtwDpYia6jUmnQk41pXQF0AXiGwWMKz1XgFfGXRg3Hg3iJ41A==
X-Gm-Gg: AYBFou2KAE8FgNgWmWPakzcud5DprOeL678rxzoLIiE1G4f08c1ZnzBKSNCG4T1qI1p
	YKwDiQYLDif4hRZVmAFbvE+5hWxf2e2JGnkA+1qx0qy+5iAc2j8CTLamHU6fzODmb3WVR+/h8kA
	nonfRncW16XN6zTMJBovz3sSBxLbOHdXZYBZeChDbsZvAQSZevJYtMPIcy9trsKITyqiwaJZJbH
	5uCyRxbTaq21DM9R/oo5L2HHQx6mSXkte4vkrEZUHoEtVFL4p3H7PUiX30L+hDlPzZoOlUIlW7V
	7aVIpS0rttGNyEkHFmccoTAA/CEc1J2gjVfS/ZVMlWdFuBh2M3wNy8tw9FnB9B3ToKY1KrkhFIY
	OvsEx7CTmsuX0hLiw0ghbZf2FFt6oqbRQtk10wdwTcCJXK+QIPbN4dtS2dWwWdUdsfWDgX8WAtL
	5TdexuMtk9jTNKh/MEPbe9avxxQp4t/ADZdIVfal4ZO7EpfCrnNLSli2D3UF88N0Dz206F8bE/A
	nM=
X-Received: by 2002:a05:7022:4b:b0:1a3:dbb2:478a with SMTP id a92af1059eb24-1ac5c92de5dmr25556491c88.27.1793726764116;
        Tue, 03 Nov 2026 09:26:04 -0800 (PST)
X-Received: by 2002:a05:7022:4b:b0:1a3:dbb2:478a with SMTP id a92af1059eb24-1ac5c92de5dmr25556431c88.27.1793726763302;
        Tue, 03 Nov 2026 09:26:03 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c272sm357310c88.8.2026.11.03.09.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 09:26:03 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
Date: Tue, 03 Nov 2026 22:55:59 +0530
Message-Id: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIACcZ6moC/yWMWwqDMBAAryL73YBrsIZepZQQk62uYCx5lIB49
 8b6OQwzO0QKTBEezQ6Bvhx58xXw1oCdjZ9IsKsMXdvdEVspVqmNd9rkorPdHAkl5TAqhdj3Fmr
 2CfTm8l8+waRZeCoJXpeJeVzIpvMIx/EDdWPSH34AAAA=
X-Change-ID: 20261103-m3_and_aux_ucode-8337b881155c
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfX7/CJHDHl+xzV
 ESlJAuhYL6KvMii5UH6SWdaLR3XfyQYb/GQQ+uAVKTwgm1rxV/6OcmpOPSii01Xo6y8iqwmidyJ
 GLOo0UvFM1rGF3qiNdEWhDHIkA99kEc=
X-Authority-Analysis: v=2.4 cv=Xs1vqlF9 c=1 sm=1 tr=0 ts=6aea192d cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=xzHXWKMcZAd5FHHA1I4A:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: VM38ACPNVWwbu6kVLW43sBGO3PjeXMjb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfX1gjY+TMt64BI
 SKea/38u9EuZbw8GnMeKps6Ci7LPKI7+V1oT4CzsgyNdZPr9v36Mq7vNnqubbcn3UuXQJUxHpyU
 7/7AseMI0WeeaZ6IWVPzv7d7sWVy7svV3PC9bprU19a82oVSQHbMjWgW8+6ADVvAwx3FI43Pwg4
 IcAHPO7vSXLz6hJ+kgmD8NWLmnNrtzhCYy14QUSAgBvVnoNDBID156Cy0TjmtjFaJnZqCBqo4X3
 KU8jOLmVkehhvUjJI0fFcYzWC/xFD6Moh0fOt/yLHa3Ub4BgfUxXZhfqWrR9bUfUU0b3PwXOC8z
 /zymILU58P1MMZ5tdBe8o3c2n57nS7xUfK24d9AmAlqcgSphwuSmYIESR9rek8tlcFBwuAa7LqZ
 RNWgSGGOJ0hXWvAmjhxHCYtZwmmU9Kc8QhqodgzLE8nNluDKlaA+/b1eyWWOel6d7JFwtbPYuzn
 JSkHUo8cEcNUKb1G77g==
X-Proofpoint-GUID: VM38ACPNVWwbu6kVLW43sBGO3PjeXMjb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_04,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030069

ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
logic for freeing a DMA-coherent firmware memory region and loading
firmware into it. Factor the shared logic into common helpers.

Patch 1 is a preparatory, no-functional-change rename of
struct m3_mem_region to struct ath12k_fw_mem_region, since the type
is also used for the aux_uc region and the old name no longer
reflects its purpose.

Patch 2 refactors the shared free/load logic into
ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
rewires the m3 and aux_uc wrappers to use them.

---
Madhavan Ganesan (2):
      wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
      wifi: ath12k: refactor m3 and aux_uc firmware memory handling
 
 drivers/net/wireless/ath/ath12k/qmi.c | 163 +++++++++++-----------------------
 drivers/net/wireless/ath/ath12k/qmi.h |   6 +-
 2 files changed, 57 insertions(+), 112 deletions(-)
---
base-commit: a2da7677eb9a12e7860814b70a1f6f5b0e347d7d
change-id: 20261103-m3_and_aux_ucode-8337b881155c

