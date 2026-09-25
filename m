Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38130E0EE
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313051; cv=none; b=tnfxZr1XEd5dTUcVzJbfe35C/OuieahHLJahq9vBvrjyByNGYnTKlgtLfUmmfnhDhdSnAtB8vBLn/5pCQhBQ346i4+P0DkmhgR8OujCe4TDaCOX1SHsC2fPGjlmpeksAcgyu4LVWblajDk0R6chAKeP1diJw0Ot68N+l/T6+dLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313051; c=relaxed/simple;
	bh=KJE40HfJnrPdZQ8ijiWJGT8suiXEM3MHrsoQDsVsO0c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O2e2fXOxN/gSnSiLm/BDi9uwRbGI+4X3Wo/dzbzhV3DlP2KGcjm2P7lZVgzzYkmBShn/plo1vAIrVXPfg7aZq/mSHWbbKfkrvNvqCcrKBMNIrriPm7SQ7/qYZUU68Wwjto8eBMW88xFhXvrb9y0IC/HSFPNhTxxA+bcuOoJ7nqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ln/1ShJr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TZAPcRLI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ln/1ShJr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TZAPcRLI"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YXvZ289462
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=VFcoXXVSkx8CQQaBN5Ddz12CZaRAt4PFWTs
	cMpo1XAg=; b=Ln/1ShJriqJLkH/9IPxrIaBZTZJq/1irE/dZQ5V+ewDCDTCaAbA
	p6I6GnSFrgncQXkuP58636qANipzXhdHzLkBtM08lYOXHzn9PpvEfeG4EbQo4UrG
	UU+w7wuGtxljMAqIcypge+OSYb6SHOeeqN2P4gqhm50gS38O4NZfC5JOCrwFPkGJ
	5vHiMaJxknNAoYdi2oXrWoPw8cc4Vj03ZfhscAIOmwEov7S4FPORDAexvjkpOoya
	9b6dO+T7vGZWlzmTDz7/WFomRAwNYQLhi0HAXHFVuLDSxKvhq54l9nDB61X9yRXT
	98ynBwsRZAlKrttC/OncjJPynoZqCFSQrRQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw881t4mu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:48 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1438492fb40so806844c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 22:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790313047; x=1790917847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VFcoXXVSkx8CQQaBN5Ddz12CZaRAt4PFWTscMpo1XAg=;
        b=TZAPcRLIzHRkHjnqDGFQLeOD+6HwN2vhxWCR8wLn66g0ARcbLVoDup2qATtZ+p75qa
         ykiH3h40Un4XRScflBf6HH36PY01c0p7dv9PPWF1GgoEsHTcLbWCAxBB8lTCe4njZJ9f
         BcDo0LwtZjGYsQkRlc2reBok2rLp18V/XM7mZ7YBHX3GYSknXy1BzrMHJd/hWNGZnFPs
         utjOq4JBfiJA1ct1XtdtqKQlubzmECjfoPf8Up2G8omTd4Mb/prJF3pvFVXJbYINYH+F
         5cjO4iZKrME5BZhAOb4iGPJAbIc/Xv9pvMpHacg0V2/velD1Lw7cfIMb580JOVAfUM23
         G+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790313047; x=1790917847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VFcoXXVSkx8CQQaBN5Ddz12CZaRAt4PFWTscMpo1XAg=;
        b=JSHyjp3cEDKtIV0wjvRU0QeF1/O/xdtTFuQ84w9TkbCE8Dcv0QBilTrj7FBqy4fFgj
         xBEj+LJzmU+ZcGuQK3fo6J4tzYXMEfTRYiHlKE1BCMiI9HFfRG77V+G8x0GgMPROz2bl
         dHJkVpN2DbJqJHRJ/LpVoJBCOqaGHkH4E5UDQia5robuPcHTpyeuxFdDXb1mT30UaBCC
         p5ALqFthWiuCbiEBogGdb3Prm34TQiWFTdzjdyMsV+SCcEGgSZBrcwJmnjC2hC2MwaRk
         Bn93gNGRYIAtQyNrwRzDIUIfkF3Wv6cS0PUvIySOULugNQyV2lVS3RSO5iwX8st4dkB+
         lnJA==
X-Gm-Message-State: AFuF++l3jeXyyp7wh/uY+7hSjyLyMZYqoBrXGYisCvMobuImGnDZQBa4
	5llHRzKxXk7oaXGGMnJ4Xh55ufnvg2T1h3jJ03oARlpiyOB9CwasaPtBEpJnoFb0/cIx/RUz8vT
	JKX3KWx6SZPbCarKzogWHiIjTDcEp/RfBpBQBE+7UtMvHwBKiiNchCNLQU+7APnO9StlhfA==
X-Gm-Gg: AYBFou1KUNzGy8tncYE3ezHQyTBUbQAd9pO6DNr/lj5WItqNulTexXKcPWMUahpIFpK
	6dkaxx2ssNI+CneaIKtYNft5xywF44NidhOUsKZxPvkPor7TljKhsJjalEotLvFXxZJqoDEz1BN
	l7jQIfOGbhuBM3Yg51dZyLkFuqX4LVfp7HjNiAfjcbrdbcAjNnrKJP/eMjtKT9h0P2e4hV4bfRs
	o+2j2AqlgfEyutTFHhFbwVrZp6LE/vX4/AQ9FHqatKsj8P1RyoophZxP9fRA0H5Tt2jLPj1mYvA
	7WSDW7KhFoBTIm9f+JVkGSHREbBu6tMdi+NvjOp3A8ddNYzxxbUA1jYU90a6nOyOQmLGNHkv/aL
	60SAVX6nGjMF5clhG7hvZNb5eUiBTbDi2+IM5CjRVb5Ky8ffz24pJtOABzGOOsL1gvlRMNlRAGk
	7lyOIyFbCpwQYHhg==
X-Received: by 2002:a05:7022:b90b:b0:143:271a:308 with SMTP id a92af1059eb24-145040eaa94mr4239844c88.46.1790313045481;
        Thu, 24 Sep 2026 22:10:45 -0700 (PDT)
X-Received: by 2002:a05:7022:b90b:b0:143:271a:308 with SMTP id a92af1059eb24-145040eaa94mr4239819c88.46.1790313044741;
        Thu, 24 Sep 2026 22:10:44 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c505sm2955163c88.5.2026.09.24.22.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:10:43 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/2] wifi: ath12k: remove duplicated STA state from link peers
Date: Fri, 25 Sep 2026 10:40:34 +0530
Message-Id: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=TptzFzXh c=1 sm=1 tr=0 ts=6ab60258 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=UqWUxUh_XSH1bq3hZJ4A:9
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfXxaa26P1f95Ip
 ImqI1bsO5ZJijV1/X3D4KgjnkE5XXSXju7CW/N/QeSMZnaKwimrJJAEtHKTw32dxG99InET1E9w
 tdn/T0jAyQ8mFKUXZBOe1UTTiU1qbd37ck5UkyvXb31CXrTf0GN3EpXKhxZSTUlI+JjAcCU9/pe
 kCbesrv0FTUG4xI+frqcP3Qe48IGIVloeefnsnfSZMeuQ09fzEame7VBD72iiPfpUBnJxJxK/DT
 00jGCqHsqKRzzTQUfuDykpl1h7FwCp5xm1GakOiM+VCHR31ogJfttlJROvWB8it4OTQTsHRBCfE
 I45apBtj4P4UBnVP8v5cG2WKpEKnjlFyw36gJY3DfX8LcdEmMp1oHiDs3uh6HWiFaO5YuT1vC5M
 acNp/zSCsLm+IzFZEuoQCKQZFUUsogJoGCdK8JxHOZPQ9qYoEk2qbZBbatsLtDvI48ZmH5th4/M
 BuvQulxAFM8B4scJElg==
X-Proofpoint-ORIG-GUID: 4rl1Wb1_CuPoAw7SAtwB0aqOCOUBwCxS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfX3EL+3FMyr9D6
 IxoPV86B+6hOFxJOlvTwI0rRHHj8xoRQumxUsV+x251I0JWpALeVR8PU/tSNaQY6ObJpL+/5Ej2
 QLyTTJyIEI3FLcTOw7Ddjo+TdyAP/fw=
X-Proofpoint-GUID: 4rl1Wb1_CuPoAw7SAtwB0aqOCOUBwCxS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250020

ath12k_dp_link_peer currently carries state that is not inherently
link-specific. Both the station pointer and authorization state are
shared across the links belonging to the same logical peer or station,
yet are stored separately in each link peer.

This series moves ownership of these fields to structures matching their
actual scope:

  * Store the station pointer only in ath12k_dp_peer.
  * Store authorization state only in ath12k_sta.

Doing so eliminates duplicated state, reduces bookkeeping required when
the state changes, and makes the ownership model clearer.

Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
updates users to retrieve it through ath12k_dp_peer.

Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
updates authorization handling accordingly.

---
Changes in v2:
- Rebased the changes
---
Aishwarya R (2):
  wifi: ath12k: store station pointer only in dp_peer
  wifi: ath12k: move is_authorized flag to ath12k_sta

 drivers/net/wireless/ath/ath12k/core.h        |  2 +
 drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
 drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
 drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
 drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
 drivers/net/wireless/ath/ath12k/peer.c        |  2 -
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
 9 files changed, 35 insertions(+), 83 deletions(-)

base-commit: 414f2b40f7b0244ea3ec1f7411d194a6d9c89c33
-- 
2.34.1

