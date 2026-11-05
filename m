Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793902348;
	b=nbodg1IrHPoM0zNGBadcXd7/GmpVwIv3xIv4AsjukBqICYZiZx9mNdd0JSjE8p0kqDIr
	 mAlAp9+xBmyaJyQ7NQ2DG2QofhPot27luMJ+hptIdo0sYtmEFRXknn28leloZQRoPtM3Z
	 bSRITUxuI2HYGqSZnMGThsIyb2pLKlbwlNMYYmtWYyV8nU3nrliKhEqDLint7Jaz6qUMG
	 GUXGNIkNOpCFS872/iQ4E2Rnz8/DALkrJyEciv93wjYpBZZ8AzvEsjqSWeODIAuHkVBJv
	 ZeddpCFI/ORqh7NGDPTItNkSUDyq9Qf619G3wWdszZ3seIVf691TFPA8qEfPe3KNH0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902348;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+VXh5wNmEMtDJf22hNJBMQBn0m2NV1zkl2tOQQX0J8U=;
	b=JOPYYS/BpkIwIo7BIPHIyEI4Eh8p84K+10KrDioZXSd10ugg7WXNJISJl7tf1mmC5Q0p
	 mitVfZ0GOjEVe4ylAL/skVXC09akcB7jNJPVFVcNVM10t3b6B5uRJ6k0UJLC2R6mBZL7M
	 WnL6Ab98N5Yy6KGbcQi9wzZV/WJGrnvLyh+9p092cjpzNjG+zQhVHfqsRhknUBjIQBrK7
	 fTdwmrPkrD6i+RzByk10IZ9fESxo4U9MfQK4PwyjJW44GkQYQIviznNNE70YRyA+IIlHY
	 esFwKGoqh7jhgfE+YZZ+Ul3JQRN/U/OGUZA5lDw90778X3r/bxk1KAb7WMLf4kYN5SQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRz82+d1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFFB606A337;
	Thu,  5 Nov 2026 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRz82+d1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793902347;
	b=jeQGh6vZ/wnXt951fWbVCPhuSCR/Hi6KyU4UFngqyo8SntalDxqNegI65ex46B4t2FLH
	 eHb8gT/luMxF/fCje63Ngr7I+LRmrA41l8ig0WEztDd1WhAHJ6kSYhpp0ffv42DWiOYHK
	 eBvXFh9Lo6QZLtgx7njq36WJGTUBgRe8mIlikjeqc1H7t45Amc1lqsP198HtTf0O+n7/i
	 G8cxoHYejaBL9CxojSvdKGVXwfWNIsqBfIpkuLvM0fZCGBy563rXqeQMOfktXofplfsli
	 jUDxdhVbcQPUK9+xlHRrvbWwjvnYlzXU8LcOvwM+s2vVxFXnyBRd4U69VrVFQRzCvyg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793902347;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+VXh5wNmEMtDJf22hNJBMQBn0m2NV1zkl2tOQQX0J8U=;
	b=sJBrddYaYR5CAjG58Oqxyu+oG99PXJzvLu9a3MYyOFinjd9i6/ydcBEd+VxO1MbJEWtC
	 TDz2bZmoI8R53S9uKP31LP5W2svsg8L4DniU+oo8njwepxKuHKREAb+rPTgelpDb47FXk
	 sFTAdhCZ+Znn9brdNJsdzs8vzv5ZHtz7VNwYzU9n9Xewu21DYLDYvXj1gBzw7qinlbBpk
	 xodgZDSCyTiBMG+pcZZgT+GK+6gKsUhyGSewHHLJmi4WSBZlOSO4iDU05FhNY117QvCpk
	 0ZNS8c1Wi0VK02YJY6mZpI++GyWOi8RhJxhoRHJWJ29n52SQYJmZMGdH3S8PMxEKHPw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 44BD61F00919;
	Thu,  5 Nov 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902347;
	bh=+VXh5wNmEMtDJf22hNJBMQBn0m2NV1zkl2tOQQX0J8U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fRz82+d1S0T995/t22eUM5vljIQ7eg7fPCSXqprJd49dY3UwSRutsEJO9qlzyiY2X
	 n1Bo7TedAAc3TlkKMNoDi+48hDHxorRr1UflsHgiel/Ab32wdK3O3eP3ueAcRv3ZsO
	 f4bq0bh/lL32uXlQYMoVGpbcwPmY3urHMLf9U8bPTd9thAN5xYi1oZkc0wODncK2oy
	 JtpHuA2rLOE3+9WSaHmTyiEYx9dbwJK+GBCzHRh2GqqJ+Cd4plxuqxA5833P4yJgBM
	 bo7LjnsZScYW8O4iG2Dy8A/4OECjeZAi7TSS24mG9514yN11W1x6m9GAFa4UpbKKMa
	 ptM/9iNOLNfkw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CD1F6473BD;
	Thu,  5 Nov 2026 18:12:24 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Thu, 05 Nov 2026 12:12:22 -0600
Subject: [PATCH 1/2] wifi: ath11k: don't leave a monitor vif started when
 its stop fails
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-ath-monitor-unassign-v1-1-277f0fbadb91@gmail.com>
References: <20261105-ath-monitor-unassign-v1-0-277f0fbadb91@gmail.com>
In-Reply-To: <20261105-ath-monitor-unassign-v1-0-277f0fbadb91@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>, 
 Jouni Malinen <quic_jouni@quicinc.com>, Kalle Valo <kvalo@kernel.org>, 
 P Praneesh <quic_ppranees@quicinc.com>, 
 Ramya Gnanasekar <quic_rgnanase@quicinc.com>, 
 Wen Gong <quic_wgong@quicinc.com>, 
 Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 ath12k@lists.infradead.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793902344; l=2565;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=1R7oAGbBN78/oVWlhCPSGL7JqxfEoXYdSJISg6BkmUs=;
 b=TPfNd1rwEb1IAORwzaVwKydgTWq9y85ofF0dnxUxsONH+KfMDevRtnzxDbtsB6PGwVN6ME/y0
 jYIA7dJ3kDFAneU9+97YW99sbcrvw1DOYHUKbEhDvc7OksKHkKLF0b/
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_mac_op_unassign_vif_chanctx() returns early, with
arvif->is_started still set, when ath11k_mac_monitor_stop() fails for a
monitor vif. mac80211 can't fail an unassignment and considers the
channel context released, so the vif's next assignment, e.g. the next
channel change of the monitor interface, hits WARN_ON(arvif->is_started)
in ath11k_mac_op_assign_vif_chanctx() and fails with -EBUSY.

A firmware crash during a monitor channel change does it. On a QCN9074
with a monitor interface that changes channel every few hundred
milliseconds, after simulate_fw_crash:

  failed to stop monitor vdev: -110
  failed to stop monitor during vif channel context unassignment: -110
  WARNING: CPU: 2 PID: 15367 at drivers/net/wireless/ath/ath11k/mac.c:8499 ath11k_mac_op_assign_vif_chanctx+0x304/0x3e0 [ath11k]
  Call trace:
   ath11k_mac_op_assign_vif_chanctx+0x304/0x3e0 [ath11k] (P)
   drv_assign_vif_chanctx+0xac/0x144 [mac80211]
   ieee80211_recalc_smps_chanctx+0x278/0x940 [mac80211]
   _ieee80211_link_use_channel+0x158/0x210 [mac80211]
   ieee80211_set_monitor_channel+0xa4/0x860 [mac80211]
   cfg80211_set_monitor_channel+0x3c/0x60 [cfg80211]
   nl80211_set_wiphy+0x2cc/0x7d8 [cfg80211]

Recovery resets the vif afterwards, but without a crash the vif would
refuse every later channel context, with a warning each time.

Clear is_started even when the stop fails, as the non-monitor path in
the same function does.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1

Fixes: 689a5e6fff75 ("ath11k: monitor mode clean up to use separate APIs")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d1..fc6c374c787fd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8514,12 +8514,10 @@ ath11k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
 		ret = ath11k_mac_monitor_stop(ar);
-		if (ret) {
+		if (ret)
+			/* continue: mac80211 has unassigned the context anyway */
 			ath11k_warn(ar->ab, "failed to stop monitor during vif channel context unassignment: %d",
 				    ret);
-			mutex_unlock(&ar->conf_mutex);
-			return;
-		}
 
 		arvif->is_started = false;
 		mutex_unlock(&ar->conf_mutex);

-- 
2.43.0


