Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50719378D8D;
	Fri,  2 Oct 2026 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790944127; cv=none; b=VEy35MicYc56X/rzrU6Ms5pcq6u5mIyPSojiK78Z+TwaSTc2NTpKO9Qu4LrReTcQh4csg+TTHV/OEnibzvEMzlXIBCsk+cNutuFqk8vAwB/bXStJFXymKEoDEGsteT67j78qd/cggjCAJ+Be5klWG1CvOzpZ70KSOdLMGCCaSVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790944127; c=relaxed/simple;
	bh=T32RCJPcmKUxupyxyWUnbI9LHj31Sj8cK6hf1Ws/qYY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hlwEpgduSBt6wIJIJ52cCGp4FFKWiIF0NCP+VZytyvenln/2ZlpZfJz68FxOYEV5Rx4xLalRupY7Myj03HnYgQbmKLxKCvnZe/Udam8BuN6tIgQXWmKymwyjAsbqS1D+F/ANgAcXbWFThY9P7RPVzF7Ph1q6RVn8FeTtxBD3Ql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=h9DX/AVQ; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="h9DX/AVQ"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id B127DB35C;
	Fri, 02 Oct 2026 15:19:22 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=CUSQwQ8vAjSojfF/giLhvIKYInkvHMUZuOWv7KAxxtE=; b=
	h9DX/AVQtCNoVfzwftVQCwuZRgsaw62AnCKRowXTBJnhF055xAYjh/JxAl6otQWn
	ySk5hnQ0+CGCOJhgLMAyfWCuxGEUblna5j+Mju0QtxfRIoAgnEskLyrcDP8Q0vKH
	EzsHsmEeP0ZJl9DgEPApJYvhEDR4tccbTy1Pb1nUsuxERcrToBKRgc1P3q/Xnk7i
	mFpQ2nC2t/H0/FV7+bUCTMJuLVf49DYq1ZJt13Bsis7U2tRLBovnscDJEw0/vhgc
	Rxp2GxsyjiKYvdMFEyjfH5DEIYDU+rEjFPGoi+/sqChq79fYB32iQI2i+RIO+Rtv
	chmucIWA1gzUlj7vWoJ36w==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 3F131B273;
	Fri, 02 Oct 2026 15:19:20 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 15:19:19 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wifi: ath11k: handle HTT PPDU ID format indication
Date: Fri, 2 Oct 2026 15:19:14 +0300
Message-ID: <20261002121914.994458-1-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Firmware from WLAN.HK 2.8 onwards sends HTT_T2H_PPDU_ID_FMT_IND (0x30)
once per radio at bring-up. It describes how the firmware packs a PPDU
ID: for each field (HW scheduler command id, ring, sequence index,
link, command type, TQM command, MAC id and CRC) whether it is present,
its width and its bit offset.

ath11k only ever compares PPDU IDs and never decodes them, so it has no
use for this layout, but the unknown message type ends up in the
default case and logs

  htt event 48 not handled

at warning level on every boot. Add the message type and dump the
message at the ATH11K_DBG_DP_HTT debug level instead.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
Found and fixed with an AI coding assistant (Claude Code), which also
drafted this changelog. Tested on a Ubiquiti UniFi U6 Enterprise
(IPQ5018 + 2x QCN9074) running 7.2.8 with the OpenWrt backports ath11k:
the warning is gone from both QCN9074 radios. On ath-next the patch is
compile-tested (W=1) only.

 drivers/net/wireless/ath/ath11k/dp.h    | 1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 84f66839f0c6..bace81c453e1 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -1033,6 +1033,7 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_PPDU_STATS_IND = 0x1d,
 	HTT_T2H_MSG_TYPE_EXT_STATS_CONF = 0x1c,
 	HTT_T2H_MSG_TYPE_BKPRESSURE_EVENT_IND = 0x24,
+	HTT_T2H_MSG_TYPE_PPDU_ID_FMT_IND = 0x30,
 };
 
 #define HTT_TARGET_VERSION_MAJOR 3
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b343a5..a22cf1b9f43a 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1747,6 +1747,11 @@ void ath11k_dp_htt_htc_t2h_msg_handler(struct ath11k_base *ab,
 	case HTT_T2H_MSG_TYPE_BKPRESSURE_EVENT_IND:
 		ath11k_htt_backpressure_event_handler(ab, skb);
 		break;
+	case HTT_T2H_MSG_TYPE_PPDU_ID_FMT_IND:
+		/* The bit layout of the firmware's PPDU IDs; ath11k only compares them. */
+		ath11k_dbg_dump(ab, ATH11K_DBG_DP_HTT, NULL, "htt ppdu id format: ",
+				skb->data, skb->len);
+		break;
 	default:
 		ath11k_warn(ab, "htt event %d not handled\n", type);
 		break;
-- 
2.47.3


