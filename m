Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F233EB10
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 04:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830478; cv=none; b=d2Vk3TCt0kiQNcBcgvMBsaYK+SKMiWygxWNTdvtOWwv86GE3R0+dGY9tb0NigDUmShGJSI8cgXbuINlJATuAY8tO+HTgkr2SX2njAEHVmuQ8H5gBbBUEoKRDllWlCv0uaG18jMlpJLCuVk5CdLbhr65rqhqp8cwqwOlvE1LBqf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830478; c=relaxed/simple;
	bh=6q9QmzOFtceiT0vvB2p1QXKt8A23U50oKIYANTrX/q8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BLUDmP3gGvJjG3UTabKiGV4eGjLghGXvug0E8c1kfvSPfbl10mhOLtOh5rK3RcpTKpeERYYHuJxD5Py1gwSVkZ1PLfsJVZjmvBGcaar54y0SIhuL2PVZ/bVgpja8i/FY6pliyBhAfyloPTPlylWxxUq7HAP/rJLCR4RLMCdghCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SYRiPtgr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZRSnZ5ln; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SYRiPtgr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZRSnZ5ln"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6913gBNK1510265
	for <linux-wireless@vger.kernel.org>; Thu, 1 Oct 2026 04:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=4c7jfFqxmhLr9o+XB64iUPxfI/4uYoeDsuw
	6aJpSHSc=; b=SYRiPtgr3DOIzNyjk2TNaXDYR2QhlwDtyJmAkgFJSB8wMJtoT4H
	BY5KE7JPpCt1LMg8h68qX8qVYyBtbZhUfomAUzMDlO9u+FG89UXPp1v6BkKWhJ4Z
	HdBlbK4Gzfzb1Qlkevmhcx+913LnBo0lmJ7D4m4PhjjB1Kp9cWokbso5KRfokUOy
	n8irGuJwuAHSN/bphObJSm+7egnZOp7bg87790RpuwNlhvwmd1bzITaY7gkcruDG
	FGeyLszxd/qUfH9BacKSPdErcq/slbrCsS6l0ryqmm6KGgYqOncwOzvP9/AC3t2m
	o/Bx/t7VVoWMsZV4qVqM69K8GDJHBgxJWiA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h10bkc6p4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 04:54:36 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so7259205a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790830475; x=1791435275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4c7jfFqxmhLr9o+XB64iUPxfI/4uYoeDsuw6aJpSHSc=;
        b=ZRSnZ5lnNQnp5aXGCU8If1F1qaGQ1BNdSt3d5XQ3V/7nUhqhm9wl/DlqkWDKWkq+Yp
         L05GQWuqAnQNhUWALxR7pZlvswP/IFUxs1aIYRE+kz1jhZ1h5sqmQ4EljmLWc8ZR9akE
         N2FFuJm7CMcVHryJ6cclaL3RoVc/Yt/LgpHMUD5MaanBvgkmOAUtUFfpUTGeN4TjYg0v
         McpL4NpvxxbgJmseHBhKy7BXQt67PZuaaSEcy25yL7xZlb1Fjs1bK5KLTequ9YCgkWU7
         XSAieHoyTLeDc1RTmWUEvwAOQFBHZ/3CI26SkdtrCYvHYdaSj00ncEY14OQUM08MsdEO
         d9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790830475; x=1791435275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4c7jfFqxmhLr9o+XB64iUPxfI/4uYoeDsuw6aJpSHSc=;
        b=U3mvTqRXOR0fm5Z5Ih7HqRmwlODQ7FIh/XE4RO1wy3ZHXZifI832vmMNRShZQ80R/A
         PIkEmZaHmQO30zbYESk8baUNa/mgqyJ1C2JspX9nR8zEnrFZEfUwMUCB3NJIs0YeRQMO
         xVr45APp91SbzysFqnEBB0iJkI+uT2zKAyDquWxET7bRYFywK5IuuFT0jU+OPBczIWSi
         RvSEgk73YPNkWRMHyTQkNYl02Ny0vZoQRB/lmn2Ejv3KXQ/8aoOJwLmS7iAw/6CTIGkX
         3B/8xT3QyImqrt5SJW6Mrzwrqt4HcHfJ+gTmADgU/t/b0cdQnWgJmWha20OMs+8Q2WT1
         4NBg==
X-Gm-Message-State: AFq9FYKKTf0GXHKDQtt/Zj+SbaVWYoO1lnW7lB0JqUBSZw4v1J7bpJCp
	SAvhrPtzIPRxwpiQyV/2z84RrUJZPDnTr7YR+tGzu2Cg6/dWaAEECPbLI8fEWldSKMGT/lfpmbf
	Hud2OAclom8kR6t3gj97aQ2jEZ/m5DZ/hioVJJGKhw63JGUMH66rIJTxec3EEn0zSU7Jb7Q==
X-Gm-Gg: AYBFou2ikPfwAAowcnCDVN86PEWwcS2+FwTmnhNLzEYajJfuMcnwQB1UGJ6azsIjX3x
	ZmND08aODWXWPtdN1nTgb3V9eE56hZb5VGde5Wewo90W/W55VOni9/UbJ5kCbDE/W5r0NLDYi+Q
	ik3/XM1/U9PLP6jQUF+swiu/Aw1RlGcfeISLeMx4uvRWpr7fv57c0VCjvw7b7ESTD8uLRDPQxsn
	cVdDT5asVNxUHg79w1U1HSkck6nmYPppRnjxlKOfldB9IpMX1AYh78luYdhVKWCF9LiFkRSrRzS
	yR39Kt2O1nCQM0onVn9G3WrUN+nJYIUWelkUBjNxDnXqwJhOc41cuv7guO3N74/qO7s9TH/v7r8
	uPHPNgyjQ0FKWfygsy6Xb8o6U2EdQeWc7cD3691cQw6ScJ+xgCf8zimYg3kJS9fQheLq4t9n7L9
	bcjTE+WMnxru9ZkRkf07M8Ew==
X-Received: by 2002:a17:90b:4fc1:b0:3a4:97ea:f0d6 with SMTP id 98e67ed59e1d1-3a4d18eeb70mr2887122a91.42.1790830474819;
        Wed, 30 Sep 2026 21:54:34 -0700 (PDT)
X-Received: by 2002:a17:90b:4fc1:b0:3a4:97ea:f0d6 with SMTP id 98e67ed59e1d1-3a4d18eeb70mr2887103a91.42.1790830474298;
        Wed, 30 Sep 2026 21:54:34 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f44f5299sm2332772a91.17.2026.09.30.21.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 21:54:32 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths
Date: Thu,  1 Oct 2026 10:24:23 +0530
Message-Id: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ndF3fzYMAJAM-cM2UO-25YdCupc8A6ad
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAxOSBTYWx0ZWRfXyT8KnvtV8DjU
 HjvnKJnc4JYcFcQJLwzUMvFH65K1AJbMUkEkjO2dJ7xh77Q//kn1jMdb3cQ+8EpNn7O2OCQP4FY
 eW9tCpVBolW5gWeILt+sHbGDCs/Vj+O048FGW89AICg3TLaQXFo9NcS6FcPM+bLHbVnruqFXCsB
 kLt5YjNKhJeZBTnE75wzaLOoZ+hS0cDV0vGfF9D9Ih6KTHo/JcUsMVY45PxXMVw4+DY46xviWIf
 1V1PwV+UihxCQIQ8NEvOnXVkPS6Y5NjbhQ4DOlu73NRCIBcpURDl1GjPmqwxirB9pq8mDFfpsCk
 RM/Ch/TNtu3wmz9DJcUqvE71r1FbCSeJ9UFdoNiDK2KMX5Z/XgHeH3mXQ46f9cI4MPAmpC16Rv6
 j7+NMAOx1xdftx/vRabjO3uPb7NPrQ7OoHRF2INyfZiqlytGqEj3atpotFGiowPuUkTIMd2cqfD
 ZaOXYzp0Ov361Xav8Tg==
X-Authority-Analysis: v=2.4 cv=MZn5KJ/f c=1 sm=1 tr=0 ts=6abde78c cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=2RwGnRjxY74BYPqWGSQA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAxOSBTYWx0ZWRfXwgeWntEpocyL
 Akuo1ol2+wYPEmEScqbnpVpRVD1yTR0yybh5qECu2sGZdoWDBLeby53Izdh2LqwfUJbIXZ3p74v
 2RMri7giYkhNODLxJtFQrqfxiptHMy8=
X-Proofpoint-ORIG-GUID: ndF3fzYMAJAM-cM2UO-25YdCupc8A6ad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010019

Currently, NAPI instances and their associated netdevs allocated for AHB
external IRQ groups are not released when external IRQ configuration
fails. They are also not freed when arch_init() fails after
ath12k_ahb_config_irq() succeeds during probe, or when the driver is
unloaded.

Fix this by adding a common cleanup helper to release the NAPI instances
and associated netdevs. Call it from the external IRQ configuration error
path, probe error path, and driver cleanup path.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
v2:
  -Remove unnecessary irq_grp->napi_ndev NULL check.
---
 drivers/net/wireless/ath/ath12k/ahb.c | 41 ++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 85360365aa4b..9b77632bd1bf 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -191,6 +191,26 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
 	}
 }
 
+static void ath12k_ahb_free_napi_for_group(struct ath12k_ext_irq_grp *irq_grp)
+{
+	netif_napi_del(&irq_grp->napi);
+	free_netdev(irq_grp->napi_ndev);
+	irq_grp->napi_ndev = NULL;
+}
+
+static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
+{
+	int i;
+
+	for (i = 0; i < num_ext_irq_grp; i++)
+		ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
+}
+
+static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
+{
+	ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
+}
+
 static void ath12k_ahb_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
 {
 	int i;
@@ -622,8 +642,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 		irq_grp->grp_id = i;
 
 		irq_grp->napi_ndev = alloc_netdev_dummy(0);
-		if (!irq_grp->napi_ndev)
-			return -ENOMEM;
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			goto free_napi_ndev;
+		}
 
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath12k_ahb_ext_grp_napi_poll);
@@ -675,12 +697,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 					       ath12k_ahb_ext_interrupt_handler,
 					       IRQF_TRIGGER_RISING,
 					       irq_name[irq_idx], irq_grp);
-			if (ret)
+			if (ret) {
 				ath12k_warn(ab, "failed request_irq for %d\n", irq);
+				ath12k_ahb_free_napi_for_group(irq_grp);
+				goto free_napi_ndev;
+			}
 		}
 	}
 
 	return 0;
+
+free_napi_ndev:
+	ath12k_ahb_free_napi(ab, i);
+	return ret;
 }
 
 static int ath12k_ahb_config_irq(struct ath12k_base *ab)
@@ -1353,7 +1382,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ret = ab_ahb->device_family_ops->arch_init(ab);
 	if (ret) {
 		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
-		goto err_rproc_deconfigure;
+		goto err_free_irq;
 	}
 
 	ret = ath12k_core_init(ab);
@@ -1367,6 +1396,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 err_deinit_arch:
 	ab_ahb->device_family_ops->arch_deinit(ab);
 
+err_free_irq:
+	ath12k_ahb_free_ext_napi(ab);
+
 err_rproc_deconfigure:
 	mutex_lock(&ath12k_rproc_info_lock);
 	ath12k_ahb_deconfigure_rproc(ab);
@@ -1409,6 +1441,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
+	ath12k_ahb_free_ext_napi(ab);
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);

base-commit: b64812cb6cec118f6c59a4ec2bd4848db17f6bb2
-- 
2.34.1

