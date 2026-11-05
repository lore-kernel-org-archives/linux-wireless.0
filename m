Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863502;
	b=HTg0ERI3ar0S65DiBxBBAOC182z5odYvdq1rJ+9QKA9WjcdWx+Ef5rNv/nB2xPSD34cW
	 YLar0mhtdhUosFMmADKpp5jWom8o61v8b3ztMvqIAc6It7tIR02E4Rw0jk2btlSy3cd2k
	 M7QDAtC/hqJhAVoEs6dmCOnX3d+2B5xh+w4Aj2uOR37CldbKcTcuhqFqemhSJG73k8JLk
	 cQQux2sTlgbh4TybFcPNSCn2cidTb3s1oRQrHwUaoFrJxG9fZCKnFfh8jBeWfXBK/rw6Y
	 4RoEKc+i1K4iIbRtu0Bsx23txZszDxfwSEMIctnMg3R0PDdVxe0LAV+zvMqlwKFTfSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863502;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=izv+cg0PeIJZ43wpA1dya6oPFW2BfC/SjBkpRPYT1r4=;
	b=GA4iZqLHVksScEZXPCbU73ulPe0oKOxf+q1ggfGNIXtitq4cSEc52C0P7M5bHYK8/cJe
	 cj2pioJuXLi+oz+4u7mnBBchpeDri+xRkBJy6NzGHUuI6zFDWNo7kK9oJGkopFaJuwQyT
	 V5l9/rTM1J+iIJENpTllhSubkdvTNZfUBc0pPSJa938ihFrVZCsD+R0wiQH4JrddoJZdD
	 ZS3iky6ULmkBdeYOeRDcfk6+N89ADc18CmOsbEMdwlkBdzzO6FYjiJvBWnDOmoKQLREFY
	 +zokWnPg9Rz0zMCSqkYUHgUMJHiygBlNDdD+lEwEPcdYBQxFeZNg7ahZ9ncIQUHZ1rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="DuLjBcK/";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97454606A33A
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=DuLjBcK/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=izv+cg0PeIJZ43wpA1dya6oPFW2BfC/SjBkpRPYT1r4=;
	t=1793863501; x=1795073101; b=DuLjBcK/0ZWCBKIc3wuFWZtNKfY7Kep3eLHYBTEPaZ0OItL
	4YV9W3lt3E3sSKgNltVoGATM58s1bm7ZGGQRWTaoGcrt7r/rwpNXi5gLihcActLrnpzJmm5iYT8+W
	XbPHCqcWT7MwImpTEojXb9hGV1JBWA8x2JOk4Wps/eQPUwIlb0eOhT82FMAft5NTYhZI/L5SCkeEq
	1O8rG1KpDOJM3VqKT+kf5KbtUAbrfhaxNDJhL7eV/mPErWrdUWKiv4YiRKsrXpY8DgJ6mHqlCe17L
	BfnPVFWgoT7bP47KBhf9YhsLojfT85wp0h7V6D/rvgDXxl/YHybYhmxSlHDqchvA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqD-00000007Ped-2p5X;
	Thu, 05 Nov 2026 08:24:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH wireless-next v2 3/6] wifi: ath11k: register regulatory before wiphy
Date: Thu,  5 Nov 2026 08:23:51 +0100
Message-ID: <20261105072451.1710800-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105072451.1710800-8-johannes@sipsolutions.net>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This order is going to become required, since userspace
can query the regulatory in the window between the two
registrations.

Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d..04acd526a3ab 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10649,6 +10649,13 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	    ab->hw_params.bios_sar_capa)
 		ar->hw->wiphy->sar_capa = ab->hw_params.bios_sar_capa;
 
+	/* Apply the regd received during initialization. */
+	ret = ath11k_regd_update(ar);
+	if (ret) {
+		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
+		goto err_free_if_combs;
+	}
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath11k_err(ar->ab, "ieee80211 registration failed: %d\n", ret);
@@ -10663,13 +10670,6 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		 */
 		ar->hw->wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MONITOR);
 
-	/* Apply the regd received during initialization */
-	ret = ath11k_regd_update(ar);
-	if (ret) {
-		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
-		goto err_unregister_hw;
-	}
-
 	if (ab->hw_params.current_cc_support && ab->new_alpha2[0]) {
 		memcpy(&ar->alpha2, ab->new_alpha2, 2);
 		ret = ath11k_reg_set_cc(ar);
-- 
2.56.0

