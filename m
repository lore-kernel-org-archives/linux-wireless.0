Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3DF43F8DE
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011226; cv=none; b=icaK2lVY/1xuVOjjbu8kgUfraGbLrF3FTlr4M6cBFvdnYFNTKXlHjnvM0DKju4sU30ATtnlffcQkdRcwR8a+G0FqCYgTjP/cuMVXLfNUYEEbxoMKNX2Wc6w+kprx28mPy5yQV4mmLReLhO3edaEbYJHm02Z0DxHq8Dm+T1w9KiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011226; c=relaxed/simple;
	bh=VaE/GaOeTYjOYYz6ZlZp8s0/hD1DmQr3PeS780bqjhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qLPDDl1v7zJIxQhxk47ZprouYmsb58D0Ob0eKMKyGSoXKH0u8Ot/sznubjyTSzjYre7QozSgGO2crFB6SMKtU089R5NAcUMymjSU2fd7e/Y4CD/qyz4R2mH2hzvqcdlinHWUntlyDQXMjJgRcWniOkYKjledE9mwNFyYUkjNEwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hZ8zuT9T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jU+xM+eT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hZ8zuT9T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jU+xM+eT"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nlRM2105033
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=5CFZb/EO3hy
	AZkE/aWu6orRYoFmRNJ2f+xhNAveYlT4=; b=hZ8zuT9TI//cOk3sgWzIrlylREx
	U9MNVsyb37aXVsQLvI6rp7D+mydZGzh9yizY6t8ndN6NWdGgOpwPJmJ1ZxmHiY3N
	GjehpJyVojbHQQF8n403Q5o+SWtDcoZ89r+cuos+lD/RqZ1InWDP7n0ANpX4pUBl
	oP+m9AdchihdRXGHfw5ufyTO3tAX0BCGuFeQm+Ni41BDyNjBB4m21jWxIvdPDEtT
	HLbPBabkKt5RAj1guxB3w/7rX2wVvsvZeI9RMXO43gFxb+fQumeoZgXg6lhIleE4
	AtEtPWAVbnFkCTRZWK4MTHcD8id6YpT85cqmaIulbLh3vx86/a6QadLOH5Q==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvq730atx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:13:44 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so4445148a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786011224; x=1786616024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5CFZb/EO3hyAZkE/aWu6orRYoFmRNJ2f+xhNAveYlT4=;
        b=jU+xM+eTSZKrq9qK1xYwC7lEhK0O8Ed9HcuAYXsQi5T7uv5+SgWc68xq/yeMHwv2Qc
         T6SvmwPt2/IeVRTqptQ84TPFl86mzub1GrLo+d4PJ+xTn3eUgt+DGvv5aVcVaUs8LhMe
         6y4xKvVYp7c0yOndjsQ0n1eQ7pkX5lH4q/0tICBUDWH9JkQXcE/uHPAax6q+O19qnBfV
         HdcaQ7yeyrp4Xqk1IwkTg5lBTd8m1EaSEfp0jLYSt8Gb5uXYChmVPKKrVMr1eFdpQizP
         ZRCQCN6xoc5AsUBGy/G/xBejg81J5xWhlZ97Wq0sBe4G+2ig1Oax2+k/dt6nZnDku1Dz
         91ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786011224; x=1786616024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5CFZb/EO3hyAZkE/aWu6orRYoFmRNJ2f+xhNAveYlT4=;
        b=sWm456SGdxppEx4HOHpulSwWpoDXq8mQU0kRKwVWZ46+aEY8zHdRtzUgDRhScbQw/W
         Jw5UBLyHAEGYwpSLaceTC8gEMWVW8FWkOijEzYF5hVL1a8SDQsU8WzzbT7uufZDPNiGe
         wSV/TKqb2Z7NZrmN/NkjZt2u5WxflirKuhDPdnO47RvLgOP/3aX85q1gNf8c5GKyBLOt
         srgUOKGJ7mjv2evxWbTaL+pF+BbSkJ1t0f52+GRykR2+61xU0olktlPjltIGX90n/KoV
         EcGrtsDeLGG9mjN4qPeI5y4/kl0qQvKxicD1or2WLqSxnqitq4GrbnfEWvsQdabfh+j9
         6/nw==
X-Forwarded-Encrypted: i=1; AHgh+RoKqLD2mZXqibpiguhtz6Dl9EEyivjrNyUhG+WOP2FrWpaBGv0DVP/cz+TnkAef3fro6XJxfTA+ABdU32w/vg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCntwbhgAYKD+h4/Wbs28rYmOUEhNNe1qDNX5fOtRiBJ36I26c
	mx1nvKWxEVzOal7FC3fsf1a23upDv2NzM1ZYBUi9sMFXG8IB9oN+1Clk8vMc5sro2gm9Fe/MV4N
	+Tu54ZH3nAoyifI7CX/sZXTdFYkeytyJMRAEISZ8ZS7oNA1GAChZH1AKNiWW8wfC1KYcgmA==
X-Gm-Gg: AR+sD12xEbx047GF7fNtJeJpm8An945gSVSYsBz2n3CWpPxofGKIA701OZ+3nw7ysVy
	EZvfkyLdWXFuRPRRB51rjaCVXuZD0ogyOyaQNSqtHSuUFqw9qdWEl4yXD/FnRHPKq0EEzv45V+P
	5Zwfq5Upm/4CGbtw1OeYSk8Y5jXT0OKhGEcT0yUaK2yysYIzirb0/2wSUyYTye8SUiWf4NuGV2/
	YwrQA+xI3YXlReNpgqA3lp5BaFRI9n0wUpCEBrNwfNPK/7o0+uTpoiNIVhzeN+YB9Aqz2GHbsQW
	2hfTUiDKBYSchf+jyZJl99oaPAgHXbKeykYJ7jDS0uLibmgHLWfa/Qd9n3CJfSVgnJ1/Hx9vEh0
	/Z5b6UuZFF7yDP59vw9umd9V9OidCKLfSKl2Udu7UUKVa1zJHoYEEOvAkF+4=
X-Received: by 2002:a17:90a:c107:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-3903c53783cmr15514460a91.5.1786011223684;
        Thu, 06 Aug 2026 03:13:43 -0700 (PDT)
X-Received: by 2002:a17:90a:c107:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-3903c53783cmr15514389a91.5.1786011223163;
        Thu, 06 Aug 2026 03:13:43 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dc396dsm1257090a91.3.2026.08.06.03.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:13:42 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current v2 3/3] wifi: ath11k: unregister PM notifier on QMI init failure path
Date: Thu,  6 Aug 2026 18:13:31 +0800
Message-Id: <20260806101331.484063-4-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfXw9NkTUOJ7iV0
 x9GIYQz+toT5XHt7MM/44zWrdzEi/l+wOuihz9bd06HJeKQTsNfE2GuoREbvMN7OT4JXAfUYlOx
 DZ0E0czhWz2e9uJveacU3EbIeXBZxM7OeGxeCtyB82w3Ybgemj8+mBnv0QHSYRCKugtRJw3XSAd
 ukPmxkTsYv/2qFkJChghQoGvWUHLMyyjZqnxzwoiiBfEoWCLHEFzQcosI1NP5hmQDVm2FmO6pJc
 vhGIeGQtnpLj7dfTDBF58CU92QP50KbfPa16P/4rBiLSyb3tmKy5xPfaWfnudZDpI4H1fFt5pSU
 SMPLvL62n7bsHLqd37y0wP0UMdMknqi0WIAx1cxvMeYVabjLtn/oXEsu5JpaDeFUHhJxcUmg6YD
 rOPoBYunALcWGocN6FAORlVNfWIwbg26oVvE8ujFEUfnCQvgO0r7VIz+3q6gpFGxnvgVefwwg8+
 lu4vfaqKUz1s8By3EeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX7e8OtahkEJ17
 1rGuXBbaa5IQ7aTMDbM8F3QDAsm75qai82dmjJFzjTGDxqPr/CRfngUhx34umcucwks/Za7kXNq
 lCI3TQkRHaLzkyyANubPcA+SxOjzJc0=
X-Authority-Analysis: v=2.4 cv=EeH4hvmC c=1 sm=1 tr=0 ts=6a745e58 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=FJAr2BPrIL5JYYbaf3kA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: ZYUjTGHGKcGiaxQGVBIE-F3TFCSNx5vZ
X-Proofpoint-GUID: ZYUjTGHGKcGiaxQGVBIE-F3TFCSNx5vZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060080

ath11k_core_init() registers a PM notifier before the QMI server
becomes available. If the QMI server never arrives, the device remove()
path can take the early-exit path introduced for QMI initialization
failures, skipping ath11k_core_deinit().

As a result, the PM notifier remains registered after the ath11k base
object has been freed. A subsequent suspend or resume event may invoke
the stale notifier and trigger a use-after-free.

Fix this by explicitly unregistering the PM notifier in the QMI failure
cleanup path before releasing ath11k resources.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index c3ce5ea36e3c..ee3f493d2e44 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1302,6 +1302,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
+		ath11k_core_pm_notifier_unregister(ab);
 		goto qmi_fail;
 	}
 
-- 
2.34.1

