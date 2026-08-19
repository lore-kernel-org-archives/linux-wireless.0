Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EE23D1A8F
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122491; cv=none; b=is7m1pUDzbuvbv27XSMQ73uAitFzMGPyI6QZLdg5ZlMAaR/4fszKFJ86/FPr2EI+dDCDk2n/VnVt4OQEgMtCE7AT5sui0fwwVNnrJIDyRabwZS544osJnXRwNWo3pdg1FszX5drts+UX+f2Mn4BNG6w8WPezgd4d56VHqCic4gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122491; c=relaxed/simple;
	bh=2KT9tWxlapHPdQR6ZIN3nsihW4V/zp6reGtkOR+EVsE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOQSHAia2hayloTEbwpIvY/h5WTgIIaSc/iW+/14rJvCBnwSMy2FkyxT99iemSvwH+D8hQVPmwZvJUtROaW2k9RCVvshp9OIAQ2wsHfobHaIU4zM3OpWq2LnMd5fQaVk0Natyo1D34gaxN+gwa7Rw77Lf8ri/44VcKjE10teK3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bCXi+7K/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RIMFOvF7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bCXi+7K/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RIMFOvF7"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6ZI7o3240498
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=00vTssWP0t9
	RJVIz8IG1sSHR8GlvwrSrPqBWNOXoPM4=; b=bCXi+7K/3enqEw4XId+yVdFxkL3
	Aum/cp1nFnyLUJfj4YV1pq0cVlxp/a+WiGXTq5L7+hqGhYfe7y0ohblU16t0otIa
	rsxY5ifL3MQeZ4m5gMFP3LAn/2YHq6bqzjrkTwQUC4By9T2aLR+iGWWyt8z+9leE
	o4mxbKP3mM6oiSjmHX/vCdQlG2X/AF20YDgZsx68mTIhMnAGbCDNZ+mPMiLiu5+7
	L74Jiv7f5pwXSgMxo6VYSRtpwlY3GgMItcMbpV5zp95vOa3+amFof3Ie6mb6e8po
	btJXZ3YMhfilu6WRjehc/Oa26N/Qf2Z0JZWlqUtGn7xw/BXA78XfCeD03eg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm9smc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:49 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-381250979d5so882738a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 23:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787122489; x=1787727289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=00vTssWP0t9RJVIz8IG1sSHR8GlvwrSrPqBWNOXoPM4=;
        b=RIMFOvF74WITsMx1V4lKFj+u/IdTWXq5meJrYEQFWfXBllpy9G4NH9iEL1cWXTbjxV
         mmJ8Kt5BaE4YwQHaHqqmuQbm8+NnhYO4tgwG+XmMf09IkkdiGkonmuDqa5f16s4+Ks6N
         wRc5/fXg4iAzQ/BznbtBOw1TcWpebrdvw9UAhuk5G20b3IqDRVWiFbJz5CKpeKiM9EbT
         bZkANqpcWU3Vy7kQc30AH5NoO4xcw0j0UxE/7y8AhMHyYrzrHgaQsBkuzSJl1l3kN36E
         GBmcrOSz0h9imYT7gFsf7fKbQccNotlm3D7+5W8EQHaYpWvNDidhNmU5Jujr56qtHwZt
         aB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122489; x=1787727289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=00vTssWP0t9RJVIz8IG1sSHR8GlvwrSrPqBWNOXoPM4=;
        b=mFNnEiK+66bSlbqeTCqijHZ2+GWi5J0HW0glRf5d3cZPWTDkc3NM2ZGh1VvhCBzld8
         D5k/AtaMTwhallP3dX4UAfXaiZAZl0YO111GVs5TSgDlQwLLigpLgPtMPiooo08/6Q0a
         r3OHc61nXIpI9s12rvXuMVTlPBpfezmBmWXmfuQiYTW8B8g9aOEGJlMmh/vDYpyheL/3
         RlLXYF8ejoXxYe6H7Tv3dYlnMDohjxtV7aXEnA72KfVUkhWGtPxcQrr+Bn6QtROiYcNn
         T8M3J+Y41AAZehqFR6duXMLvcM1zOohrgW8x1gfbtSMrsgpRNhO33pTu56+iomXF58sj
         jraw==
X-Gm-Message-State: AOJu0Yz2ghMd7Lt/3CTTNtVVMgQ4zLOKflU+M8ptO6caeFtNZXdRYwhf
	W7WAHi4e5rrCMKSMA80lzb18aG8VElqYyooXmX2PcMRKg1nvr4V1EjPTb15uJL+N6fHSK+YDini
	k1Lp5b5PIh/R5fYs7eDi5Y9MH4kiioj0m/2aHNQdbHAlD+PKNk3bVh3raLPXUvSPUEVfaLw==
X-Gm-Gg: AR+sD12FGB3yI/rTFKqF37Oh4qR3RaOeg/8Tv7/eQMSKT1ybxDn24K47AlmbANxcKLp
	5TnjpSWJOmQK8XYi6hX6QAN3+TBWFdkfNItN+/DQ4miuZtwcjb4Kbp9IfDWgeXd6FhH3BK0LMSG
	2sBLhqlNgo6RU5K/zivqYwQhxn+W/Q94UKbBofrizPQw5fnBCavXNZEzJCCDEm0MslDLv3ns0b/
	zF6uYdCKb2SPexMy6vvYmbQp69XWD/dOWkyq5ojx3bsIo6zDUaAn3pyFHpkwRsFpEDbl9G1y3wA
	Huj9DprmfE1Lf/LA4WoIdPYwiNOBZgFt6JG3Ld97f6KNfj+xay6C4oVGx7TVr6GllA79jtmQRUg
	9c+Kf6gKJP7nLMl/sYpmmB6ejL7E+v0Z17XrGOmEwxe3VFHr+9z+/Y21H0eq3hn5xnMR/kiuA68
	rphyCZbZ3dPfl6pwHAn+YM8+4=
X-Received: by 2002:a17:90b:5748:b0:38e:5ac1:9517 with SMTP id 98e67ed59e1d1-3958125b7d2mr4589372a91.3.1787122488657;
        Tue, 18 Aug 2026 23:54:48 -0700 (PDT)
X-Received: by 2002:a17:90b:5748:b0:38e:5ac1:9517 with SMTP id 98e67ed59e1d1-3958125b7d2mr4589309a91.3.1787122488128;
        Tue, 18 Aug 2026 23:54:48 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb4ffcasm1526626a91.6.2026.08.18.23.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:54:47 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 2/2] wifi: ath12k: Free allocated external IRQs on request_irq() failure
Date: Wed, 19 Aug 2026 12:24:25 +0530
Message-Id: <20260819065425.2044186-3-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfX87aU0duhBZhQ
 3YeSPX4s5D1jDqGRn/NHb+ciDeBBXADsCBLTglLbJ43l7OZDs6EgXy0eaufdgFl/ptOe9O0OAuR
 ZW79pxHQnmM9fNBhHgZGJjXbRqtQkeb2D0GgsVaE+mbaDjDeQ9CKDTN5jNp39AZNQehEQOamwiZ
 C7TsI6bFolZAc8bJApqbcF7n/zpzuZVNSleXhxN2wXqgHp70LrP0oohz81ufQy3Q73Pytnh4veS
 LujgHM9TxUB+9ramzbYXBmnm0A2/H77nICXNgB7XZSGJrJ03oTRqbpvdtv1kyF8KAJLeae0En+R
 w2EM45u7jcojxg+cRWUELY/CzdMaSC2g29zZu8E93ZVgh5XAUZdrAinr8ohc4QDX7DhTWiX095g
 dP1CEVpS8g/N3d0HjPQtSjcf6ZkCpkgnDcCpCVoYCyrhnkax6nMLOpkSirbkglo+Qxcx9ui4ZRL
 Oj8VGWe9oNKCjl2uPeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfX+ut6SD+mgS5N
 ygnTBiYv9ZirsCrvXaTYNlaZ404B5P6HZ7zvadBBsVgWHpb/ko5PE/oGhht5SVUwlpx6MixjvvK
 YhW20weT4sdorfAEfkqBfP3dBf7ClY8=
X-Proofpoint-GUID: K_RsKhya7AI8UfjLgUty4Dx04eltPtwq
X-Proofpoint-ORIG-GUID: K_RsKhya7AI8UfjLgUty4Dx04eltPtwq
X-Authority-Analysis: v=2.4 cv=J+SaKgnS c=1 sm=1 tr=0 ts=6a855339 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=tecUyYAXEqPB-KyWC5QA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190050

When external IRQ configuration fails, the driver does not release all
IRQs that were successfully requested before the failure. This can leak
IRQ resources during probe failure.

Free previously requested external IRQs when external IRQ configuration
fails.

Also remove the NAPI instance with netif_napi_del() before freeing the
associated netdev to properly clean up the NAPI resources.

Store the IRQ number only after request_irq() succeeds to avoid recording
an IRQ that was not successfully requested.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/pci.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 9a78d2f69f94..9bb4a6191331 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -326,11 +326,11 @@ static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
 	}
 }
 
-static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
+static void ath12k_pci_free_ext_irq(struct ath12k_base *ab, int num_ext_irq_grp)
 {
 	int i, j;
 
-	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
+	for (i = 0; i < num_ext_irq_grp; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
 		for (j = 0; j < irq_grp->num_irq; j++)
@@ -344,7 +344,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 static void ath12k_pci_free_irq(struct ath12k_base *ab)
 {
 	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
-	ath12k_pci_free_ext_irq(ab);
+	ath12k_pci_free_ext_irq(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 }
 
 static void ath12k_pci_ce_irq_enable(struct ath12k_base *ab, u16 ce_id)
@@ -600,8 +600,6 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 
 			irq = ath12k_pci_get_msi_irq(ab->dev, vector);
 
-			ab->irq_num[irq_idx] = irq;
-
 			ath12k_dbg(ab, ATH12K_DBG_PCI,
 				   "irq:%d group:%d\n", irq, i);
 
@@ -612,22 +610,24 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 			if (ret) {
 				ath12k_err(ab, "failed request irq %d: %d\n",
 					   vector, ret);
-				goto fail_request;
+
+				for (n = 0; n < j; n++)
+					free_irq(ab->irq_num[irq_grp->irqs[n]], irq_grp);
+
+				netif_napi_del(&ab->ext_irq_grp[i].napi);
+				free_netdev(ab->ext_irq_grp[i].napi_ndev);
+				goto fail_allocate;
 			}
+
+			ab->irq_num[irq_idx] = irq;
 		}
 		ath12k_pci_ext_grp_disable(irq_grp);
 	}
 
 	return 0;
 
-fail_request:
-	/* i ->napi_ndev was properly allocated. Free it also */
-	i += 1;
 fail_allocate:
-	for (n = 0; n < i; n++) {
-		irq_grp = &ab->ext_irq_grp[n];
-		free_netdev(irq_grp->napi_ndev);
-	}
+	ath12k_pci_free_ext_irq(ab, i);
 	return ret;
 }
 
-- 
2.34.1

