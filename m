Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457019067C
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616653; cv=none; b=pXDZuqSIpEX5TCws4g2WHP12Q1eujzan7t4pmsxs8zX6NfV1dk5mBOo1vei4nRhf/Z/oEcVCNkzk/PIShLgFBDHH16IP1dixhnDw9LbgW4uz7gxysIVAEXXXgjNehHxD6YbuAMB4bbeDQkXrAELZcdD/3bkoINouI+XbdZJzB5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616653; c=relaxed/simple;
	bh=dafSNZQBM/JVHuxXi1rJGfdRoVka6CTtc6U8k13TUnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IKcw4TX00U0IIAPC3ps8hLyL3e3vrXrFkaQPObTLHnvQXUUy1VsD/hX45HqpGn8nXF8faJl4FmQXyUXMnK9/dOKOBNZT0aY2qoPzGZITLTJ++ud64VFBBwh0EuffDrISR58UYKl+VGRwO43njEAId9kj6xZRll2eYZqpPaUSv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c3BBDnVi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iM0tzxlB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c3BBDnVi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iM0tzxlB"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L6F4pZ4106897
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=sFIVIoHhy4S
	uLurz/T6U0m4+tj4haC5VQS95MPm+iZM=; b=c3BBDnVicRHgLK2UI7WrHCn1kW/
	2bB2Xc8vPUnhwAFfEEf+4yb/xIRsj6cbTKbYC4prBtsVEO/8qz4jnKSE6roVbdu9
	mzhif3NNd18WbdSzP1b2t6a3zD0ij4q/yI1Ara5DnawAzWdwC841QMY9pu0TbY+1
	Z4bQutNCNuUzmYywvWXVOfgWyZ1cHbjTsg7xH25fsD1Fjkyg4WC2e9IuhMXtWX/o
	T/nRhlWqmW8TLQXZ9UYOHsTignExfjmpLHvsQqFS//e5I9ia9cSoVLSv3PVu3qSY
	HeVXXwUHQjdInJT0fNv1zXDKJyvAjZRZJ2BDTRI4J/fiK52jEOPQhSaOVkw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhvqn9k8g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:51 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb835525b10so1845904a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 23:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784616650; x=1785221450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sFIVIoHhy4SuLurz/T6U0m4+tj4haC5VQS95MPm+iZM=;
        b=iM0tzxlBrSx16cKLaezog0bJd3+sje/ywO6fpjU93neGIHZhEXa+wPGqdkR37+1n+5
         yx63gETinIYkCLrSmooi7VqOExHGafoDO+ByX4JqOGt7vIrNLpwbflqNTlLYm5585EDT
         796Rgcs0tUOx2ryB0/OJz3aS9cNbna9I/DdiC2s/qL7wx04eANY4fWvG+2Y/X6uJFUAQ
         9dFVdaSgS0PFEoSpoWspDH+RwFne24i1l0ZEblZiUSF85/D4DbQ5pdIq3XXVFPwHwMnV
         VN15V9jIbNdCo3tXd99esYsf7d/JUEF6gbkAA5wTXmcpmd07q/KPEhvgTMpy9pL27cKM
         Jt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784616650; x=1785221450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sFIVIoHhy4SuLurz/T6U0m4+tj4haC5VQS95MPm+iZM=;
        b=R7eTwvnPP95gCu9DgmBifpC2cn5CsXjwOfdV8WiNa1dJWBrasg0p5zi25zQ7YQCqI3
         +SPfxhBNTgOJnaiVj5ebbEGgpjJPrbHgLWXAINOmQtSTEVE8UBeEUNnAlDJaDGfMHTFu
         p4P70K0oqChjj31Xwc0+m01koduduqLsfSDXScxih5rFEe8QeKHX0aNjNurC7BqlHP9K
         AkgeCp+FdktDTpcct5WUwUgxJO8yQ25rkJGErYnxLmeFsR++A8lfQM1FxCQBQgnmehS2
         +Q6CUMhrCHC1WJC56SzaTMh/sKvX5aqvHk0cQHOqx7X07/zo+cdiK8DZq5CJ1zVTBphc
         5gSw==
X-Gm-Message-State: AOJu0YzTbymtwv+U5VRNzu0CpKVEUv45hSzIRAQG4vnNTHRFtGycB/jK
	nUwcP4pAvkvSosQWLYnsVKE08Qx7qA5LTFzXajMljT8lc5fqQqYwdR9WHeuNTSAncipgWuv4dFB
	s7hA8LArtMMzxqAUBCVCVlS+n8kLA9qPx8zo7kcNlL7xYHnv/Md9/EGubLMprHiDlC1woMTzicQ
	7O9g==
X-Gm-Gg: AfdE7clyL47udvEhwvlPu+cwksaYcvAPmx/aOiN+RVsC5I4zr9EH3NK7GFdcwshJAEo
	qY5NGIhaUyWbGaHRA1seJS7ogeypoC9xMDUpMRlFMJO8VsrKHtBqmbnJ/sjgr/cn4ln51bYb0Am
	8JFdfelsd/eiQxFWFuoC1uuPZlj/fD2KgEaGwrh1zbB9WAzqujxil2gspzU6OS5T/olBkMUk326
	LShfc6ScBKtiqH5ZPQyzcmzmW3ujzzFvB3em5wMA8UVZPfc+H7rbI5maZXYRfJtVRGQgDYTaxzE
	LM2XdsadRsQrvVNJPB9XdqFQHuiN5zPQnOEwsfwV7/nysp4qNPiIoOAIZgl5H4pc0uLbD+sQjCY
	FjM3PcP27avqyNW0x0ru899Fmk4oeW7Dh7bOxRQ5QwSEesRm2Lu5KCQ2oSmS21sot5YeBDP69Jc
	qpupWwe6PqtUhILCIuzmxuhjQ=
X-Received: by 2002:a05:6a00:4515:b0:847:711f:49ab with SMTP id d2e1a72fcca58-84c292ab55fmr17156849b3a.22.1784616650411;
        Mon, 20 Jul 2026 23:50:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:4515:b0:847:711f:49ab with SMTP id d2e1a72fcca58-84c292ab55fmr17156824b3a.22.1784616649894;
        Mon, 20 Jul 2026 23:50:49 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9ef6dsm6902392b3a.57.2026.07.20.23.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:50:48 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 2/2] wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate operations
Date: Tue, 21 Jul 2026 12:20:38 +0530
Message-Id: <20260721065038.126046-3-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfXwNPp6WUEGDHm
 UNTgK8psnBqZdcEnliKQiUv71IAVoQRh+xwjZr3xdC1DFY0tTZ+2kf4Ht7W1e9H74AYa/BvFLbs
 3iwlKAkI84s1lhdqhM03Pr42Ixm9RV8TWMLfc0omJqV0QhA12XCRIdMdXeLPwhFf7udCpyBMMaa
 r8zkBEMvEV701fY8dl1pT5ex2NlTu+9OwBwv6F/V/8JCtzkzCs/iNQOFoyUEJRx0SUwjZBbl3FY
 WTfRHBM/5hDKKpsDJxYc5e28QfoHnacAmbwgUM6+YZzulg/jDUsljAAzV9urDmxNc8q09beydbp
 GMVtFwnjn6aydrE8va4s6YSQQmMn+L1ZBs5CPLcvSuk50PpuswRYj7nQqu8xMj3+J0JfjISrcP4
 OdQ7/uAESQW2/mSSqCkX3nXkpOn6ckpHbNVOTssIAQFQQpZ8JNxi3Cvnv0ABNI0FncIDT8a8yUK
 0Kpggi3LqB8zD4KLS2A==
X-Proofpoint-ORIG-GUID: eaMGB76OzaLTI3vJtni6NPWN7dpqt4XW
X-Proofpoint-GUID: eaMGB76OzaLTI3vJtni6NPWN7dpqt4XW
X-Authority-Analysis: v=2.4 cv=M5F97Sws c=1 sm=1 tr=0 ts=6a5f16cb cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=EQc74pWQCqrD_IxNvOgA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfX0MAvQ92GoVrL
 sDoUE423i0QwF102qDNuXzYiD6ZEuRWp+zIr6RcQ8T465LUpGFjI06iqSovQyiIBJ0PCMoNUegc
 nfJ6eI/vy3ELvgxa67isIGE6BHnxr+E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210069

Currently, each ath12k AHB device maintains its own RootPD-related
information. However, RootPD is shared across all UserPD devices, so
RootPD-related operations such as RootPD boot, and notifier registration,
should be performed only once during the first UserPD boot up.

Due to per-device RootPD information, the driver is unable to track
shared RootPD state across multiple UserPDs, which can result in these
operations being performed multiple times.

Fix this by introducing a new ath12k_ahb_rproc_info structure to hold
shared RootPD-related information such as notifier callbacks, boot
state, and number of userPD.

Allocate this structure during the first device probe in
ath12k_ahb_rproc_info_alloc() and reuse the same structure for all
subsequent device probes.

Also handle rproc deconfiguration correctly when multiple UserPDs share a
common RootPD. The RootPD provides shared firmware services and resources
for all UserPDs. Therefore, do not shut down the RootPD while any UserPD
remains powered on or is still in the boot process.

In addition, a UserPD can be powered down before its associated resources
are fully released. Defer g_rproc_info cleanup until all UserPD-related
state and resources have been cleaned up.

For intermediate UserPD removal, cleanup only per-device information
and remove the UserPD from the tracking array while keeping the RootPD
running for remaining active UserPDs.

Note: UserPD IDs start from 1, as ID 0 is used by RootPD, which is
completely handled by the remoteproc driver.

The multi-PD architecture on AHB platforms operates as follows:

                     +-----------------------------+
                     |   Q6 RootPD (rproc)         |
                     |   (Shared Resource)         |
                     |                             |
                     |  - Manages UserPD lifecycle |
                     |  - Provides SSR notifiers   |
                     +--------------+--------------+
                                    |
                                    | Manages
                                    |
              +---------------------+---------------------+
              |                     |                     |
         +----v----+           +----v----+          +----v----+
         | UserPD1 |           | UserPD2 |          | UserPD3 |
         |  ID=1   |           |  ID=2   |          |  ID=3   |
         | (Radio) |           | (Radio) |          | (Radio) |
         +---------+           +---------+          +---------+
              |                     |                     |
              |                     |                     |
         ath12k_ahb           ath12k_ahb           ath12k_ahb
         (device 1)           (device 2)           (device 3)
              |                     |                     |
              +---------------------+---------------------+
                                    |
                                    | All reference
                                    |
                          +---------v----------+
                          | ath12k_ahb_rproc_  |
                          | info (shared)      |
                          |                    |
                          | - tgt_rproc        |
                          | - notifiers        |
                          | - rootpd_ready     |
                          | - num_userpd       |
                          | - userpd[] array   |
                          +--------------------+

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 205 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath12k/ahb.h |  15 +-
 2 files changed, 177 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 14ee696960c7..0fc55c9169e1 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -25,6 +25,22 @@ static const char ath12k_userpd_irq[][9] = {"spawn",
 				     "ready",
 				     "stop-ack"};
 
+/*
+ * Multi-UserPD Architecture:
+ *
+ * One Q6 RootPD (managed by separate rproc driver) supports multiple
+ * ath12k UserPDs. Each UserPD represents a WiFi radio instance.
+ *
+ * Lifecycle:
+ *  - RootPD boots when first UserPD probes
+ *  - All UserPDs share RootPD's SSR notifier
+ *
+ * Locking:
+ *  - ath12k_rproc_info_lock: Protects g_rproc_info allocation/free
+ */
+static struct ath12k_ahb_rproc_info *g_rproc_info;
+static DEFINE_MUTEX(ath12k_rproc_info_lock);
+
 static const char *irq_name[ATH12K_IRQ_NUM_MAX] = {
 	"misc-pulse1",
 	"misc-latch",
@@ -786,44 +802,85 @@ static int ath12k_ahb_config_rproc_irq(struct ath12k_base *ab)
 static int ath12k_ahb_root_pd_state_notifier(struct notifier_block *nb,
 					     const unsigned long event, void *data)
 {
-	struct ath12k_ahb *ab_ahb = container_of(nb, struct ath12k_ahb, root_pd_nb);
-	struct ath12k_base *ab = ab_ahb->ab;
+	struct ath12k_ahb_rproc_info *rproc_info =
+		container_of(nb, struct ath12k_ahb_rproc_info, root_pd_nb);
 
 	if (event == ATH12K_RPROC_AFTER_POWERUP) {
-		ath12k_dbg(ab, ATH12K_DBG_AHB, "Root PD is UP\n");
-		complete(&ab_ahb->rootpd_ready);
+		ath12k_generic_dbg(ATH12K_DBG_AHB, "Root PD is UP\n");
+		complete(&rproc_info->rootpd_ready);
 	}
 
 	return 0;
 }
 
-static int ath12k_ahb_register_rproc_notifier(struct ath12k_base *ab)
+static int ath12k_ahb_register_rproc_notifier(void)
 {
-	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	int ret;
+
+	lockdep_assert_held(&ath12k_rproc_info_lock);
 
-	ab_ahb->root_pd_nb.notifier_call = ath12k_ahb_root_pd_state_notifier;
-	init_completion(&ab_ahb->rootpd_ready);
+	if (g_rproc_info->root_pd_notifier)
+		return 0;
 
-	ab_ahb->root_pd_notifier = qcom_register_ssr_notifier(ab_ahb->tgt_rproc->name,
-							      &ab_ahb->root_pd_nb);
-	if (IS_ERR(ab_ahb->root_pd_notifier))
-		return PTR_ERR(ab_ahb->root_pd_notifier);
+	g_rproc_info->root_pd_nb.notifier_call = ath12k_ahb_root_pd_state_notifier;
+
+	g_rproc_info->root_pd_notifier =
+			qcom_register_ssr_notifier(g_rproc_info->tgt_rproc->name,
+						   &g_rproc_info->root_pd_nb);
+	if (IS_ERR(g_rproc_info->root_pd_notifier)) {
+		ret = PTR_ERR(g_rproc_info->root_pd_notifier);
+		g_rproc_info->root_pd_notifier = NULL;
+		return ret;
+	}
 
 	return 0;
 }
 
-static void ath12k_ahb_unregister_rproc_notifier(struct ath12k_base *ab)
+static void ath12k_ahb_unregister_rproc_notifier(void)
+{
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+
+	if (!g_rproc_info->root_pd_notifier)
+		return;
+
+	qcom_unregister_ssr_notifier(g_rproc_info->root_pd_notifier,
+				     &g_rproc_info->root_pd_nb);
+	g_rproc_info->root_pd_notifier = NULL;
+}
+
+static void ath12k_ahb_cleanup_userpd(struct ath12k_base *ab)
 {
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	struct ath12k_ahb_rproc_info *rproc_info = ab_ahb->rproc_info;
 
-	if (!ab_ahb->root_pd_notifier) {
-		ath12k_err(ab, "Rproc notifier not registered\n");
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+
+	if (!rproc_info)
 		return;
-	}
 
-	qcom_unregister_ssr_notifier(ab_ahb->root_pd_notifier,
-				     &ab_ahb->root_pd_nb);
-	ab_ahb->root_pd_notifier = NULL;
+	rproc_info->userpd[ab_ahb->userpd_id - 1] = NULL;
+	rproc_info->num_userpd--;
+	ab_ahb->rproc_info = NULL;
+}
+
+static struct ath12k_ahb_rproc_info *ath12k_ahb_rproc_info_alloc(struct ath12k_base *ab)
+{
+	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	struct ath12k_ahb_rproc_info *rproc_info;
+
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+
+	rproc_info = kzalloc_obj(*rproc_info, GFP_KERNEL);
+	if (!rproc_info)
+		return NULL;
+
+	rproc_info->rootpd_booted_by_driver = false;
+	rproc_info->userpd[ab_ahb->userpd_id - 1] = ab_ahb;
+	rproc_info->num_userpd = 1;
+	init_completion(&rproc_info->rootpd_ready);
+	ab_ahb->rproc_info = rproc_info;
+
+	return rproc_info;
 }
 
 static int ath12k_ahb_get_rproc(struct ath12k_base *ab)
@@ -832,37 +889,69 @@ static int ath12k_ahb_get_rproc(struct ath12k_base *ab)
 	struct device *dev = ab->dev;
 	struct device_node *np;
 	struct rproc *prproc;
+	int ret;
+
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+
+	if (ab_ahb->userpd_id > ATH12K_MAX_DEVICES)
+		return -ENOSPC;
+
+	if (g_rproc_info) {
+		if (g_rproc_info->num_userpd >= ATH12K_MAX_DEVICES) {
+			ath12k_err(ab, "Max UserPD limit reached\n");
+			return -ENOSPC;
+		}
+
+		g_rproc_info->userpd[ab_ahb->userpd_id - 1] = ab_ahb;
+		g_rproc_info->num_userpd++;
+		ab_ahb->rproc_info = g_rproc_info;
+		return 0;
+	}
+
+	g_rproc_info = ath12k_ahb_rproc_info_alloc(ab);
+	if (!g_rproc_info)
+		return -ENOMEM;
 
 	np = of_parse_phandle(dev->of_node, "qcom,rproc", 0);
 	if (!np) {
 		ath12k_err(ab, "failed to get q6_rproc handle\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err_free_rproc_info;
 	}
 
 	prproc = rproc_get_by_phandle(np->phandle);
 	of_node_put(np);
-	if (!prproc)
-		return dev_err_probe(&ab->pdev->dev, -EPROBE_DEFER,
-				     "failed to get rproc\n");
-
-	ab_ahb->tgt_rproc = prproc;
+	if (!prproc) {
+		ret = dev_err_probe(&ab->pdev->dev, -EPROBE_DEFER,
+				    "failed to get rproc\n");
+		goto err_free_rproc_info;
+	}
 
+	g_rproc_info->tgt_rproc = prproc;
 	return 0;
+
+err_free_rproc_info:
+	ab_ahb->rproc_info = NULL;
+	kfree(g_rproc_info);
+	g_rproc_info = NULL;
+	return ret;
 }
 
 static int ath12k_ahb_boot_root_pd(struct ath12k_base *ab)
 {
-	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 	unsigned long time_left;
 	int ret;
 
-	ret = rproc_boot(ab_ahb->tgt_rproc);
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+	reinit_completion(&g_rproc_info->rootpd_ready);
+
+	ret = rproc_boot(g_rproc_info->tgt_rproc);
 	if (ret < 0) {
 		ath12k_err(ab, "RootPD boot failed\n");
 		return ret;
 	}
 
-	time_left = wait_for_completion_timeout(&ab_ahb->rootpd_ready,
+	time_left = wait_for_completion_timeout(&g_rproc_info->rootpd_ready,
 						ATH12K_ROOTPD_READY_TIMEOUT);
 	if (!time_left) {
 		ath12k_err(ab, "RootPD ready wait timed out\n");
@@ -874,44 +963,74 @@ static int ath12k_ahb_boot_root_pd(struct ath12k_base *ab)
 
 static int ath12k_ahb_configure_rproc(struct ath12k_base *ab)
 {
-	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 	int ret;
 
+	mutex_lock(&ath12k_rproc_info_lock);
+
 	ret = ath12k_ahb_get_rproc(ab);
-	if (ret < 0)
+	if (ret < 0) {
+		mutex_unlock(&ath12k_rproc_info_lock);
 		return ret;
+	}
 
-	ret = ath12k_ahb_register_rproc_notifier(ab);
+	ret = ath12k_ahb_register_rproc_notifier();
 	if (ret < 0) {
 		ret = dev_err_probe(&ab->pdev->dev, ret,
 				    "failed to register rproc notifier\n");
-		goto err_put_rproc;
+		goto err_cleanup_userpd;
 	}
 
-	if (ab_ahb->tgt_rproc->state != RPROC_RUNNING) {
+	if (g_rproc_info->tgt_rproc->state != RPROC_RUNNING) {
 		ret = ath12k_ahb_boot_root_pd(ab);
 		if (ret < 0) {
 			ath12k_err(ab, "failed to boot the remote processor Q6\n");
 			goto err_unreg_notifier;
 		}
+		g_rproc_info->rootpd_booted_by_driver = true;
 	}
 
-	return ath12k_ahb_config_rproc_irq(ab);
+	mutex_unlock(&ath12k_rproc_info_lock);
+	return 0;
 
 err_unreg_notifier:
-	ath12k_ahb_unregister_rproc_notifier(ab);
+	ath12k_ahb_unregister_rproc_notifier();
+
+err_cleanup_userpd:
+	ath12k_ahb_cleanup_userpd(ab);
+
+	if (g_rproc_info && !g_rproc_info->num_userpd) {
+		rproc_put(g_rproc_info->tgt_rproc);
+		kfree(g_rproc_info);
+		g_rproc_info = NULL;
+	}
 
-err_put_rproc:
-	rproc_put(ab_ahb->tgt_rproc);
+	mutex_unlock(&ath12k_rproc_info_lock);
 	return ret;
 }
 
 static void ath12k_ahb_deconfigure_rproc(struct ath12k_base *ab)
 {
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	struct ath12k_ahb_rproc_info *rproc_info = ab_ahb->rproc_info;
+
+	lockdep_assert_held(&ath12k_rproc_info_lock);
+
+	if (!rproc_info || !g_rproc_info)
+		return;
 
-	ath12k_ahb_unregister_rproc_notifier(ab);
-	rproc_put(ab_ahb->tgt_rproc);
+	ath12k_ahb_cleanup_userpd(ab);
+
+	if (!g_rproc_info->num_userpd) {
+		ath12k_ahb_unregister_rproc_notifier();
+
+		if (g_rproc_info->rootpd_booted_by_driver &&
+		    g_rproc_info->tgt_rproc->state == RPROC_RUNNING)
+			rproc_shutdown(g_rproc_info->tgt_rproc);
+
+		rproc_put(g_rproc_info->tgt_rproc);
+		kfree(g_rproc_info);
+		g_rproc_info = NULL;
+	}
 }
 
 static int ath12k_ahb_resource_init(struct ath12k_base *ab)
@@ -1094,6 +1213,10 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_ce_free;
 
+	ret = ath12k_ahb_config_rproc_irq(ab);
+	if (ret)
+		goto err_rproc_deconfigure;
+
 	ret = ath12k_ahb_config_irq(ab);
 	if (ret) {
 		ath12k_err(ab, "failed to configure irq: %d\n", ret);
@@ -1121,7 +1244,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ab_ahb->device_family_ops->arch_deinit(ab);
 
 err_rproc_deconfigure:
+	mutex_lock(&ath12k_rproc_info_lock);
 	ath12k_ahb_deconfigure_rproc(ab);
+	mutex_unlock(&ath12k_rproc_info_lock);
 
 err_ce_free:
 	ath12k_ce_free_pipes(ab);
@@ -1163,7 +1288,9 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);
+	mutex_lock(&ath12k_rproc_info_lock);
 	ath12k_ahb_deconfigure_rproc(ab);
+	mutex_unlock(&ath12k_rproc_info_lock);
 	ab_ahb->device_family_ops->arch_deinit(ab);
 	ath12k_core_free(ab);
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/net/wireless/ath/ath12k/ahb.h b/drivers/net/wireless/ath/ath12k/ahb.h
index 037347ccd21b..cdb58b07338f 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.h
+++ b/drivers/net/wireless/ath/ath12k/ahb.h
@@ -69,13 +69,19 @@ struct ath12k_ahb_device_family_ops {
 	void (*arch_deinit)(struct ath12k_base *ab);
 };
 
-struct ath12k_ahb {
-	struct ath12k_base *ab;
+struct ath12k_ahb_rproc_info {
 	struct rproc *tgt_rproc;
-	struct clk *xo_clk;
-	struct completion rootpd_ready;
 	struct notifier_block root_pd_nb;
 	void *root_pd_notifier;
+	struct completion rootpd_ready;
+	u8 num_userpd;
+	bool rootpd_booted_by_driver;
+	struct ath12k_ahb *userpd[ATH12K_MAX_DEVICES];
+};
+
+struct ath12k_ahb {
+	struct ath12k_base *ab;
+	struct clk *xo_clk;
 	struct qcom_smem_state *spawn_state;
 	struct qcom_smem_state *stop_state;
 	struct completion userpd_spawned;
@@ -88,6 +94,7 @@ struct ath12k_ahb {
 	const struct ath12k_ahb_ops *ahb_ops;
 	const struct ath12k_ahb_device_family_ops *device_family_ops;
 	bool scm_auth_enabled;
+	struct ath12k_ahb_rproc_info *rproc_info;
 };
 
 struct ath12k_ahb_driver {
-- 
2.34.1

