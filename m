Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C63AAF69
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338794; cv=none; b=ojUzf7pJtaC4g9Nhr525VjgmztSTDu1f/3tfn2uNcBj+rZBBkrJou5kdYAc0HWRfKrrobFt0kRfvKvB8f3OUlmBRL6IXWzExRXyiMxnoAyIwUd8FNyATkRuoK7qZ0Jwg2D838vdIrfc/azkE0O6VBd7FvtZI5Sb4etubzIZgTBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338794; c=relaxed/simple;
	bh=rtsd5Eu05gTWl9eJA3CFTXLHvsxmuN60s29cbVTL3q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GJNNXiZQQ9vg3fQenplXIwg66RY6OGiFwSjL5+b4cWOwX1dZ6H7jW0U7T7Bf1ivkvFrSI5nRgO5dWHmfGf+/4kctZZ9EAkwdZp0lBn3UV3OuXVUuxR7Jwhf47qU1qJMGPZQRagxoSCN5mD05GPbVuO3r7ytHN0Y1CkF5/X3Rp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oBoQKMK9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d2LJFU/d; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oBoQKMK9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d2LJFU/d"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF32sj2397460
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=; b=oBoQKMK9ee9Ob5sR
	zUwfVCqHvn0fjGg5+CtDAbD6MBit2H5Hq/yMhiK9RC0aaOv+GvaTG3ky4d5VQhGs
	NsI4p9Xk9rNC7B30y5lrXU2cwzrMa5I1zd7ZcyEC6ZyLWt1hIeU62m4iXN7AlicZ
	eyju1C4ay2xFMpeF90Fpkq+44CuS6MDOcM07D+onU/mcA1z4+YE2+aFI0Nv4p7Ux
	5GO3NCJrpxJHnzYBZmEn2/QmMTCgefikJdWBv7okHcqI/WdffZ9zZUCNpDCuBL7a
	QM9YupFw6EwsvJ6XTQS5L3O7C18JuLb+Rm9gk1eQETb/KXnFyLy3nMCaNCeYhHzi
	KTPapA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqgr693vh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:30 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cd01a14e81so14974635ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785338790; x=1785943590; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=;
        b=d2LJFU/dybtixu9mHTtspG0S3WmN/WWzVbokjvyds8RCLkrEQAWxg6vh1HoxVeE7cq
         td+lHqRvaUDkxSwOQAKvNypVbvSl8gci1bLVBJTdpio9CDd78C66iEppg7Vm1IH1NwPK
         UQFS+TkdHxxQTyOXOvdygamTviv95eqbVwPPXIGGYgE6JFqNpnIAmlFVrYV1XfokY0IH
         Lzi7s2ZiEX7Lb2c1rqac+hHud0kzlgp4KOVrsAfZFoDn23uG6kEyhOixW5d4V5kVUvG2
         4HE3bWsw2LGMe2IkfoQRHlHMIMEryRZRdKMKBPG+6R8bXJQ6Us0YF86ZCDm+KYh/MipV
         j5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338790; x=1785943590;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=;
        b=Z8efEysXnq0UA90HD1/tIZjPtTrRTOgev0dKES+c5rALrPBwpULB7HORzO01EKc5uT
         i5irtWUoehJJcyHwR8U1yic0rsD2L+37YYWAlCBjo+iDlz364xRxjCx97vcDFnsGZHE6
         6+2Me92WutB7jhOIN3Xr4BYm5b4EYAYY9HjDbTrdnWCXKOXOJyajoZKIca3kKoPvRdFY
         wK0d/mijUbZ+Vb/7wyG28JKTtIfq/3ogLlyzZB8QMGcQO4GYjQFPDkQfMljnolUw/QCj
         aEyN7+oCSjZxucBCIp/1b3fN+DND05+K2FGAQuJs9e2RNCfjwu3hmb8EDbG5eYYu2ltm
         dGUg==
X-Forwarded-Encrypted: i=1; AHgh+RoCTnx6bsxkU5MOLga7MJ0nJ1IoQV0aaS4xaQJAGJhpFbLhS2pv6vXrSF5s2YOU4ljXRQYAijAzxMBpPnZHVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz217EjrnTpW5VwIHRx5BPHzR1acvY5o3p5kqi8j7iXxvZ6Q43Y
	nu+7yLlUwNf0nGtdAhkQZv291szSkR5VO5iJ8QvqgDfGi5/cwOXVs1lib1MQLkKYsIfP5Hw+LUl
	n9pgX5uxoKNm111Nhl2d/xy8I+uWvmoUsQTkAqeVWTE4ndHjX9YLM2ht1OdvRbvTYZao6Ew==
X-Gm-Gg: AR+sD10KY9EZqQZSeSkHKPzV3QWU6NmIucsWTxfLtt04wW6pc9rXIzBLyFxhfdR5wCJ
	xSl1OPB10K2rRR7t7rTXnHyEpRLeQWUDhy+hRJysVDs/2UuQWggpaBmTnppzl0zFw0OPaNENn5z
	v0450bWmnlPXHDjUzUYF1+S3piNi8Xw93GI8cyObTVu6PpkSFD2DUBLoG1OSwnn4fOBo/msEudR
	zyzWXnROSSZyzslbb9Zf/7ypTnigV4Eq/zzlmTaMtBlAXRHWMD+Pn9Vc+uYefwUrYauZNbqMVu5
	ecQYMwftSlb9aRt0zy2VpjPsgxbPQ0z8Vl5jav9faJLJan/rgfRs5se5hoqA8mBvywXGJFDmohD
	nSaUE+8oRsIrLBHoTKpaOtG77Qvy0kMNK0JQl68SR0zTZsJCQwXUcpXA=
X-Received: by 2002:a17:903:3c6e:b0:2c9:d539:61e7 with SMTP id d9443c01a7336-2d015c4e34bmr81145145ad.19.1785338789595;
        Wed, 29 Jul 2026 08:26:29 -0700 (PDT)
X-Received: by 2002:a17:903:3c6e:b0:2c9:d539:61e7 with SMTP id d9443c01a7336-2d015c4e34bmr81144805ad.19.1785338789207;
        Wed, 29 Jul 2026 08:26:29 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d480c5sm18005300eec.25.2026.07.29.08.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:26:28 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:26:25 -0700
Subject: [PATCH ath-next 1/2] wifi: ath12k: fix stride mismatch in
 mac_phy_caps_parse()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-mac_phy_caps_parse-stride-mismatch-v1-1-077a1a0c50d8@oss.qualcomm.com>
References: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
In-Reply-To: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX3FObomesmWAs
 79NOyEp+b8fRvovLS5iBTcWve4I6oz0newOzYSN6OiNA6pBOmPJt9eJmxjBkdSZkOOVLdKggdz5
 yR/WXkGSYKF8J4+RRptTCA3E2sIu8JxJq4vuCE2QPLZpsRLUjCkXtfP0Exj2MFj965b7Imf01ir
 NJMmXpXjMRdORxzE/Oixj5N1dofgW/JVP/mT9cPI+WO6eEV8SvbLhV431AoQqasIc6l40DhSsE3
 IowxlngGcF/rNBvSmtSpftHs4NkxbkRmLjdjOcbDFp5cxZagY9222TtqSXLRtOPTaM8AvmVts4q
 hFi5cL8sHj/LY9P0xjGN8AJq28/1otdhvOVPcGlm8U1ZXT8pqqvydAfV1CMEsw9sxes5jfgih+J
 lMxhs4HCs5WQ6YYmFLSg8KN2/yIHNtD26Be6QFETbNRD+4q6MIjyhV1dkcfPFiRPXslQ+DT4WOi
 dFgrzBvKrspH7lqoA9g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX9UuwnS1CQW7l
 SPuoWEd/TOmxfiLoiGd1GDfbAe85/iUh7JUamm2i5CKarORHMTg8jYBNMIOR5oFl32VD1E2EEE6
 H3cAhkMPYd3WIZIA8ZER6LxpGKPsucU=
X-Authority-Analysis: v=2.4 cv=Cv2PtH4D c=1 sm=1 tr=0 ts=6a6a1ba6 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=TQlc2wDWUpY00yvoUuwA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: P8KdHP0izC1kkoeEsuJykotS-rw7IVKO
X-Proofpoint-GUID: P8KdHP0izC1kkoeEsuJykotS-rw7IVKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290124

Currently, in ath12k_wmi_mac_phy_caps_parse(), kzalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct ath12k_wmi_mac_phy_caps_params)). The
subsequent memcpy() destination advances by sizeof(full struct) per slot
via C pointer arithmetic, not by the clamped len. When firmware sends
short TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath12k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 672eae237ac6..d466baf5e90a 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4765,14 +4765,16 @@ static int ath12k_wmi_mac_phy_caps_parse(struct ath12k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kzalloc((svc_rdy_ext->tot_phy_id) * len,
-						    GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;

-- 
2.43.0

