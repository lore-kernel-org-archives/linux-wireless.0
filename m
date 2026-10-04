Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68EB40B109;
	Sun,  4 Oct 2026 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791113023; cv=none; b=Y4nn6MrsRISmO/hG6g0gqhvslkJmM/idq7w/qxmUi0dqKVcMclbJQcKA8s5tmevh/UemfrebYs/DwctOy9xQvbkNmSIA1ZfjHE6oZ7MtAgCv2UwaNQDWm5ZfvJlwYyypFgCKwvWUlPCOIaJ8pMGBY1h0AE1Lra1Ww2ixia3VGf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791113023; c=relaxed/simple;
	bh=qLb7tA3vBiEFPLz0uKYk2DzyBBEVt6rm03PcH/Tx9xs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgxBxAwLqbMu/t/hxaicz+c2V1F1k5jOngTXg1LDrGBc8ZsoYbM6T0Ck0XKJjr57dZWOnR8DWqJvVql8pJ1YL0EaLIjoujtR+za9/jjaImkOSSi2rqY31+cjEHO9RBBMQcnJ3StpOHSs5kjSvDds0PMUfNyuE4DerxT5hlIdE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=aCemBFGz; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="aCemBFGz"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id E19631BBB3;
	Sun, 04 Oct 2026 14:23:39 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=HjmGNy9+5i4EYioG2mjT
	Wb6R3JieWsNYIsTGT1wtIFc=; b=aCemBFGzygvc5Fa/LiedRKYKC+lCGqnlWK9z
	ABJ9N1fXLLE3kpeGYteWsy29mzwuPyrZZufB4CgQTZF8zW8L0l5univeLLCOtlre
	W5Awcs6msANvuvgeHo974/7CoTpCwzpsNR+UwpsW642dGP0CnKxxVUvGIFvfAEPU
	cs2lifheN/c7YVJTwaBo9ZF0sgcBdYTAs7uX7rJgXQ0LVRLG8HimZ5unUxnQ4nJJ
	W9K2UZBIRkC/Fz2DRO+CRayERPahhRcjoK7RLWD5wcsVNDtM8AHTlQjv2enMObTy
	ZF8YWY8eEVIci85+wdC8zF/eVG2zL4B6l9RmufMVK1nNWtMksg==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 375831BAC2;
	Sun, 04 Oct 2026 14:23:39 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:23:38 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 5/5] wifi: ath11k: map DSCP to TID as cfg80211 does by default
Date: Sun, 4 Oct 2026 14:18:07 +0300
Message-ID: <23e008aae70cc20169686c84f61139237fa1eb6e.1791111135.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.2.git.me@andrei-z.com>
References: <cover.1791111135.2.git.me@andrei-z.com>
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

Where the hardware classifies frames by their DSCP, it takes the TID
from the DSCP-TID tables ath11k programs, all of them with the DSCP's
class selector bits. cfg80211, which classifies the frames mac80211
queues, follows RFC 8325 section 4 instead (commit 6fdb8b8781d5
("wifi: cfg80211: Update the default DSCP-to-UP mapping")), as does
Wi-Fi QoS Management. The two disagree for AF1x and CS2 (UP 0, not 1
and 2), AF2x (UP 3, best effort, not 2, background), CS3 and AF3x (UP 4,
not 3), VA and EF (UP 6, voice, not 5, video) and CS6 (UP 7, not 6).

Program the tables with cfg80211's default mapping.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/hal_tx.c | 30 ++++++++++++------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hal_tx.c b/drivers/net/wireless/ath/ath11k/hal_tx.c
index b7e9b1cdd7..c42d9d4f53 100644
--- a/drivers/net/wireless/ath/ath11k/hal_tx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_tx.c
@@ -11,26 +11,26 @@
 
 #define DSCP_TID_MAP_TBL_ENTRY_SIZE 64
 
-/* dscp_tid_map - Default DSCP-TID mapping
+/* dscp_tid_map - Default DSCP-TID mapping, the one cfg80211_classify8021d()
+ * uses without a QoS map: the DSCP's class selector bits, except where RFC 8325
+ * section 4 maps the DiffServ service class differently.
  *
- * DSCP        TID
- * 000000      0
- * 001000      1
- * 010000      2
- * 011000      3
- * 100000      4
- * 101000      5
- * 110000      6
- * 111000      7
+ * DSCP              TID
+ * AF11-13, CS2      0
+ * AF21-23           3
+ * CS3, AF31-33      4
+ * VA, EF            6
+ * CS6               7
+ * any other         DSCP >> 3
  */
 static const u8 dscp_tid_map[DSCP_TID_MAP_TBL_ENTRY_SIZE] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
-	1, 1, 1, 1, 1, 1, 1, 1,
-	2, 2, 2, 2, 2, 2, 2, 2,
-	3, 3, 3, 3, 3, 3, 3, 3,
+	1, 1, 0, 1, 0, 1, 0, 1,
+	0, 2, 3, 2, 3, 2, 3, 2,
+	4, 3, 4, 3, 4, 3, 4, 3,
 	4, 4, 4, 4, 4, 4, 4, 4,
-	5, 5, 5, 5, 5, 5, 5, 5,
-	6, 6, 6, 6, 6, 6, 6, 6,
+	5, 5, 5, 5, 6, 5, 6, 5,
+	7, 6, 6, 6, 6, 6, 6, 6,
 	7, 7, 7, 7, 7, 7, 7, 7,
 };
 
-- 
2.47.3


