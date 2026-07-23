Received: from e3i380.smtp2go.com (e3i380.smtp2go.com [158.120.85.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87533DAAD4
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=158.120.85.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794088; cv=none; b=QK1IbvnCCmrjkfPbr44R+G5lJ0w+NHNkDk8jUx3GDBJg/uG4rgGEPVAtyOpD2vqx5JwZRwDvklIlqPniGEUYJ53mtCSQj5zPtYLngfVUmxeN8ICWosqIKxFryymMyxWJdYgrtyZuTpbwBi8wMlBMorYEPam6U/F0jF+2DpunZmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794088; c=relaxed/simple;
	bh=NqZ186Tf4Io+hsVU7W4WYNfEnYHJt9s8fB3CEa8D3lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qG4Xf7Hlo2ttx4NBFTZOdtoKYxIod7ZVPNyGIopSRHUQsah1AH35I+KudQ/y6rdm8lRboQZmKXLpdLbsyLzWF0cV1kO49wfeVSVYmROZsHGk/7T5mnAEGGGrxEnd6XIiNq67kYWjSQRbkYyDIuLyuRliH9XKsb1yvVUX94yA6XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt; spf=pass smtp.mailfrom=em510616.triplefau.lt; dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b=KiWMnHMF; arc=none smtp.client-ip=158.120.85.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em510616.triplefau.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b="KiWMnHMF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triplefau.lt;
 i=@triplefau.lt; q=dns/txt; s=s510616; t=1784794078; h=from : subject
 : to : message-id : date;
 bh=rNpq27tB3nSmwYwX0wcczUDMon2N3d5uNtInLRxUpos=;
 b=KiWMnHMF51yF3Blc0yddghCjFk0LIEqNGoEwJmwTyWQxTULicBQ0JZAWc8TwFyW4ZSpZ2
 j1tShDEx9iuOX0U5wgTQXqy08gv14HiLfrOEBKGN467qXoYmwBol+hTNvj7mfTMiryhPgTA
 Ip+muYwoOpwE9Jm8WI1eQaprGnImVjsh89bX4unlQwE2RTqrh1d/YDR5Eq8prVFIydchu5I
 jOp5q8hfFUSm+WXWMMPtukQHPkjr87wDau9RVq3EfIp1+9Hm9CAYx+I1tx4r4CIIXsz7TYy
 l7bV4Te78z1fnZSmRXEk2bOYMmoHr60FF6sHK7dJFuaMPcBDyD5wH72dFRbw==
Received: from [10.12.239.196] (helo=localhost)
	by smtpcorp.com with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.99.4)
	(envelope-from <repk@triplefau.lt>)
	id 1wmoTE-4o5NDgrtH57-qbVX;
	Thu, 23 Jul 2026 08:07:56 +0000
From: Remi Pommarel <repk@triplefau.lt>
To: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] wifi: ath11k: Avoid adding the same peer twice to a pdev
Date: Thu, 23 Jul 2026 09:43:09 +0200
Message-ID: <1316ed692b84f1d956e4854d9e974569a3961795.1784792420.git.repk@triplefau.lt>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Feedback-ID: 510616m:510616apGKSTK:510616sUWJ1d39r3
X-smtpcorp-track: t9dQWDfZYSKE.-xEadgTFImF7.9QfAWw6Dt-g

Adding a peer that already exists on the same pdev, even if it belongs
to a different vdev, appears to trigger a firmware crash.

Some devices authenticate with multiple BSSs simultaneously to gather
more information about their wireless environment. When multiple BSSs
are hosted on the same PHY, the same station may be added as a peer
multiple times for the same pdev, which causes the ath11k firmware to
crash.

Prevent the same peer from being added more than once per pdev to avoid
this issue.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 drivers/net/wireless/ath/ath11k/peer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index b30a90698544..b7277e4b188b 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -386,7 +386,7 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 	spin_lock_bh(&ar->ab->base_lock);
 	peer = ath11k_peer_find_by_addr(ar->ab, param->peer_addr);
 	if (peer) {
-		if (peer->vdev_id == param->vdev_id) {
+		if (peer->pdev_idx == ar->pdev_idx) {
 			spin_unlock_bh(&ar->ab->base_lock);
 			mutex_unlock(&ar->ab->tbl_mtx_lock);
 			return -EINVAL;
-- 
2.52.0

