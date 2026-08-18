Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC03371CE3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787017503; cv=none; b=LjbM0biUzTLTJEvPpaRbLFh9wKiSJi3HvTJVAxvpw0jKeUhgO8RRAymW0mClrg4uZNKWtcj3msPSsAQg+0ciHefY12m3VnNvfIVLpDwIViT4EDmhS69R3afJl9khbpdhbLY9qWzY/S8utW2DiGGGJA4B/D9Bgtjl4OHi5SVkf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787017503; c=relaxed/simple;
	bh=GtPXsxDoUkjaOR2RTZQX6o+OD2LZMLKYO8L9Lzm+L4Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mv0uS7c9fHRqf7KYEgebAXyGoGSz3/35d6WOX9JHOtSmrwCh1mTpo+idplX3p111b9hyHors9ZaQwsRTRrDUdKTOAta7aFoCFMT8e8Eq9sOGphPQCZ8nLNpO+8DddUpfHLYFVpmXenrZSSBjjOkuklpCEhHm32CIZYk8Yppslc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ictfL4zR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RQIk5U//; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ictfL4zR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RQIk5U//"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HLkPHO3531738
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 01:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DZJPMdAf2aJ2i7TTToYX/9
	lIGOVh0S21MWfOzc2u+io=; b=ictfL4zRsc9ou3M6rkZBu/OXHJ7M16xWUrB6gA
	Xdlgf0396pdRMQYfe35AOYqiofX7E5ZaDeHFE39mPqumMoOlUWoJuUBRz+JodSV0
	QSkYZL5NI6CLo/CHpcWf1WgKSnSl04CngbmBMRj8s0NVVdxkbQOyH0jpujhjXVJv
	erEvjsS7KQ4CW3X8uts7HBFVwIXmG1ll3GHN9weO5xJybkSH8sPSEH0Mw3pKr496
	PnanBArV75f5MALEHw4+A29CWm30js4fEtEWFZxiTQYdTIcW2EcJIhOTo3BNT0z4
	a0q+GW++ZiKAsTzy3x/dpHlcWJVRNXL/a51hTQtu8o1zX9wA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4615hujb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 01:45:00 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848d21bbb55so6446261b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 18:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787017500; x=1787622300; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DZJPMdAf2aJ2i7TTToYX/9lIGOVh0S21MWfOzc2u+io=;
        b=RQIk5U//5BpHBmFYleIgm4ngZEprbB2nV1ra+LNa2i5CqRtkRytKl594vpnWjzV7kD
         +Vm3V7m3FQ28C8GuUvvrpSmAEmXGUv+HJ0OAoXiXpIrb0x+sRims/EVF5hCq9GnCmA31
         Gv0IrVLaPrO72+H5roSuNYz2NF50LlrwR7Z2QrLhcUSWzETZJmD3VtmGKz2Eh8o7etao
         KAzb8vRqmTnENVltYWp3rxZb3X0cxcjKnoPOYEbom21F7MPEagleBvA6+iSsz0VQoCrB
         a6Lg1lBMqQg/pD1IyQ5HAxctsxKheUuN8nXTJRrA1VCVb2+Car0s/gqrWnl6aa2DbZVa
         eaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787017500; x=1787622300;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DZJPMdAf2aJ2i7TTToYX/9lIGOVh0S21MWfOzc2u+io=;
        b=hruFsBLmGO4Yp0J9eu/dZMqZ90/j7yGLA1wnn4tubGERuylxbaTTeKmp2u4x7I1loc
         Da2kLA5DE/EWFQ1G7C+9r2nyp8XEQu80ZlO6qb4egI6M/v4ekeVjxTn8tjB5FqQwCbz9
         jR5BpNywGwBhtsPEj+pnhbePp8ZQu45WJt+UB65rKQAJXenS786VHid/P8EI53J+mzGa
         +IzB8ZH1Ca8XCMPLC/InMMw2uQGnORs7ftWOxorgh5VVlA+uYBRNmw5PdKDfyJrzC8pf
         KjOYTxKri3UtJ9y6XW+02bgPYITtV+ZJNnAWNZTbMknBD1f0DK7E3Tqr0kXPUEyE+Ilg
         ac2A==
X-Gm-Message-State: AOJu0Yw0PvaJqjtp04j8BBMOYFLqEywTE6bEcJxXYVNl1LEp2xlRG+0e
	Szdrr+HkIuhf/DpH/E1ue6GHX5e6No3DK1ict33z8kzU4FTNIV66NUrEWbpW1kFPD8wuHsDTdle
	PAq7tdZgMAO90QIBOQtDgAzra4I8UYXfmq/BlYh9AOMEAb3kOr8ba9zzYgNF6ArmzgNXVkA==
X-Gm-Gg: AR+sD13IoxJNpqlGh1cxMs2GL21b2f8SbRklfBCOFlwsxSXAC8MWTUNDx70ZPOD+yhn
	5jdXHLl9IxuIojdUCL0QIRtbqtLPO302d8qBVjX6JbgvuS/bAMXxxZB2zsEP+8IEPQdLDZHyme2
	TO8L9/eXNHp8lYabXKekQAizA7dOk93IO6J88egB2Ir4KDp8H9YmqaKboGF6o4Py7GObPNNSBAY
	JzoI2Uo0Nrq6CtbE5vAK1bilplfl8tgGN0+EIva6LxgfAtPGYJFHfTWHnUWVtFDh1sR30wQZeZx
	qvLx6okp/IxdCSli52+Jc8S9lzFZnpovlXvZXPrNZxB4iaMbXwVgk95LifeoKHGYXkSJvzmsx0t
	/VwRnaHZzdMR5bhdOvfzp7EOacxbknRarw+bNvzvgSRHGU23VDzFsqg==
X-Received: by 2002:a05:6a00:3cd1:b0:848:411f:3969 with SMTP id d2e1a72fcca58-851b882e6bfmr4626397b3a.20.1787017500232;
        Mon, 17 Aug 2026 18:45:00 -0700 (PDT)
X-Received: by 2002:a05:6a00:3cd1:b0:848:411f:3969 with SMTP id d2e1a72fcca58-851b882e6bfmr4626353b3a.20.1787017499782;
        Mon, 17 Aug 2026 18:44:59 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc20dasm933240b3a.46.2026.08.17.18.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:44:59 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Tue, 18 Aug 2026 09:44:48 +0800
Subject: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAA+5g2oC/43NywrCMBAF0F+RrB3pJH0krvwPcTF51Aa10aSWi
 vTfDV25UHEzcLncM0+WXPQuse3qyaIbffKhzwHXK2Y66o8OvM2Z8YLXhUQEGjrkJ7hTC22IQGd
 /7J2FYQIqamlFqbEqJcv7a3StnxZ7z/IMejcN7JCbzqchxMfydMSl/8MfERAUWUtKFEZzvQspb
 W53OptwuWzyWfCR/w3yDIq2rI1FoZuGvoDiHRS/QJFBqZTUylR1U1YfwHmeXwj6tkJ1AQAA
X-Change-ID: 20260811-ath12k-uaf-for-aligned-tx-a068d34b1548
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 4-71t5gjZ2Y8Ka1vK4Fw5G1iMzXIxYsc
X-Proofpoint-ORIG-GUID: 4-71t5gjZ2Y8Ka1vK4Fw5G1iMzXIxYsc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDAxMCBTYWx0ZWRfX0zTfaiQ6H/cL
 HYAyYHYPEB7fBOSdseZaR2fYYbPiYw+sKw9eeQ5FN36I3gMgMMThnGp+yf129cbj2TQi9+hOHzD
 q2gm8NhXq5/8FVjaEtLbalE23BjpzGvDRF0AHECuJMksnEYJ6oaEyFLC07J3Nz2tOGiO+0EWWzk
 NqgSWPVL53T4v7ZF7mdTtMrm5cKpjXQfOwvnff8Mhx+GfvojKrL+q66MqMhB5pSqV5CeH8Aa+VF
 aMp9+yUOBEID71JAHxthJCK7RuDQbcOxH3bzmLwUvJKuudUqHy06B65hzQU9d5xlnaQGhTrY06v
 SHyqu/iYsxqEExzhD5uri2nR0uEGpycX4Sb5637TdjqEcFI00thy+qldOOX/Fv6p0gOWOFRBdCm
 NYy4gMzSuPJ07mqfE1cUWU5kzsHH0HULl2hhfD2Z6I2WrID90Rd4jQF0Dakzb7rNU1FFyuxlJgh
 0ZzIudD1lGLhkM3tIrg==
X-Authority-Analysis: v=2.4 cv=Ruf16imK c=1 sm=1 tr=0 ts=6a83b91c cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=FUV8liJ-HANJxdjaZr0A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDAxMCBTYWx0ZWRfX+B7Oam/5N0CE
 uZgn5yrvK1CMyLK0R0k9PxgXhB8dQ8tX2TT9Ej8fCIYcRa4H7GB7X+BAvuKqx574oyNL5aWB9Xp
 N1HxWwSaWDTiYL7nwHF1PyoF9IrG4js=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180010

ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
calling ath12k_dp_tx_align_payload(). That function may shift skb->data
in place (when headroom or tailroom is sufficient) or reallocate the
buffer entirely via skb_realloc_headroom(), freeing the original skb.
In either case hdr, eth, and skb_cb are left pointing into stale memory.

After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
skb_cb is written immediately after (storing DMA addresses), and eth is
re-read on every TCL ring retry via the tcl_ring_sel goto, so both
accesses are use-after-free or stale-pointer bugs depending on which
alignment path was taken.

Refresh eth (conditionally, to preserve the encap-mode distinction) and
skb_cb alongside hdr after ath12k_dp_tx_align_payload() returns, so all
three point into the live skb for all subsequent accesses.

Issue found during code review, compile tested only.

Fixes: 38055789d151 ("wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..6b8430260238 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -251,10 +251,15 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 			goto map;
 		}
 
-		/* hdr is pointing to a wrong place after alignment,
-		 * so refresh it for later use.
+		/*
+		 * The payload may have been shifted or even the entire buffer may have
+		 * been reallocated for alignment. In that case, hdr, eth and skb_cb
+		 * are stale pointers. Refresh them now for later dereference.
 		 */
 		hdr = (void *)skb->data;
+		if (eth)
+			eth = (struct ethhdr *)skb->data;
+		skb_cb = ATH12K_SKB_CB(skb);
 	}
 map:
 	ti.paddr = dma_map_single(dp->dev, skb->data, skb->len, DMA_TO_DEVICE);

---
base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
change-id: 20260811-ath12k-uaf-for-aligned-tx-a068d34b1548

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

