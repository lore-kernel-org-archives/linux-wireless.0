Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40315403AE1;
	Fri, 31 Jul 2026 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503679; cv=none; b=KvdoBHaAEVE37Co6+aZ5CnHEDl+wt76he17twaJgQ8puRt1+CNqWRRfP4cpEbg2mw1FxLpAQjesncE63415zAkymaMDSsQgkFB+wuktyyWr5KA1pya3aoSOZ3zHMdSzdM0+08KTNDkw+dm65148UYInMRHw+UcS02TP2x1qmHTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503679; c=relaxed/simple;
	bh=qKP87S/SY5oxMyhW9XRDxM1pjwRzoWaG45Vq2OhYi/g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XaX6VhkGDLydpRiwTxfET0zZginlcnX/BqHuW4KSzDQgZv4ZrVEIHLJH8xyF+KcwFSz20/pUm4sAwll339Y3J6nF/84hTpvUQHfrdERCe0nPcSap9ayLDWG5FaPI6G1MM26MqTMT2i0YWKy1uViuQVQsIEp0UcMnMtt8PGtl1Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c0ff22c08ce111f1aa26b74ffac11d73-20260731
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:aded6b5c-3c22-4da9-8893-f958090b16e4,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:4dd9054b96298054b1243f29e359b11a,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c0ff22c08ce111f1aa26b74ffac11d73-20260731
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1253282149; Fri, 31 Jul 2026 21:14:25 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH ath-next] wifi: ath12k: shut down RootPD after ready timeout
Date: Fri, 31 Jul 2026 21:14:21 +0800
Message-Id: <20260731131421.3764136-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rproc_boot() takes a power reference when it succeeds. If the RootPD
fails to signal that it is ready, ath12k returns without balancing that
reference. The remote processor can remain powered after probe fails,
and later boot and shutdown calls operate with an unbalanced power count.

Call rproc_shutdown() before returning the timeout error to balance the
successful rproc_boot().

This unwind is only safe once RootPD boot is serialized across UserPDs.
Before commit c6ab3b1dfa3e ("wifi: ath12k: Share RootPD state across
UserPDs to avoid duplicate operations"), another UserPD could observe a
running RootPD and skip rproc_boot(), so it held no matching power
reference, and shutting down from a timing-out probe could power off a
RootPD that UserPD still needed. Older trees therefore need more than
this one-line change.

Fixes: 10a355ba6238 ("wifi: ath12k: Power up root PD")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
Not tested on hardware; no IPQ5332 AHB device was available.  The change
was verified by code inspection and a W=1 build of the affected object.

 drivers/net/wireless/ath/ath12k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 0fc55c9169e1a..39956a97fe915 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -955,6 +955,7 @@ static int ath12k_ahb_boot_root_pd(struct ath12k_base *ab)
 						ATH12K_ROOTPD_READY_TIMEOUT);
 	if (!time_left) {
 		ath12k_err(ab, "RootPD ready wait timed out\n");
+		rproc_shutdown(g_rproc_info->tgt_rproc);
 		return -ETIMEDOUT;
 	}
 

base-commit: 8b8202b2e31367434a5079a6faee31588e5b4aa4
-- 
2.25.1

