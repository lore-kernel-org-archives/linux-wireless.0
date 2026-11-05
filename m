Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793902346;
	b=lmcjs8gBv5U692vd/rW5bf/L0M4cOZDQXhQs39pdOzDrw3F6L5e8TILOpM/Ff0CZAx62
	 fss7DewhdlcRQZrXL9BmhI2TlkJdFy9HjQXReMGuYYa4Hdswxt0uwBitzN5hwyrxdqC9r
	 k2WmAeay7/0mC5rTTHR+wiTdlBru2yGmJ3grd7P08sL7eW4J9foyNWXYLD9FHXGVPLLe5
	 z0cI69Ays7uMB9sK+YG0JTNOI61wf/L+yDHiqwT7NsQK32ZKwb4j7GK+g4yrZi8Yqo819
	 c84jiiJ28mdmCwS0PNY0YaapNXxvJ5QNRN5GoMp1YN+bDdyT2ZxRbnzcmeKRkt/T2wQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902346;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RBmIUHu80SKW/VRZZOQILzfNjSh0opGCQpCY4Xr/Iro=;
	b=36zYLaNWqYq8URMUs0jYFlHCec1UDxVOe7DF16cGpd8rQZS7TRMfMzk0YBL0x+MgkIvk
	 QV+/zLvD6nEHDF8sHc04BKd3xuuvIRXpxWCFLqkQoml3wzqJGVLIgdipsT8SI7RbvjQ1c
	 1GZhZUV+5l8AKxceH8uiVNNdkSQgrUcCIXhiHSRMuV4Cv/SA+GnEWnCloe20kmSqrILKl
	 vrBB3MKwMopAjL6CeQB+6eDlEo6zz2+kOLIBEq1/lYNndcOS1tTTgD4jlu4+QeqO7i0FN
	 tGKLQD/4c9/jXNcRGGx9j9JHepdKmAjIoWG9EMklH/QF1ZEnn6fjERk2jlitAsQhCAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=emGD02vN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF50606A328;
	Thu,  5 Nov 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=emGD02vN
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793902346;
	b=kpIdHWFLN3BaiGkRhCD0ULSGc4ACkhLVLRmOP7nHivfUTm1SZfNzDjmW4zJx4AG71+Wx
	 cIF+BbxaxhxOxMTWPlMTuufLAZRacOyw1t9vONxLxg4Av9GIpFXtSaVEdKalGc5Z5jYQf
	 u4ZhGWDqoHx+foc0syKuCPhfSlwfoT+O78YWDaYZFAk+TD+AzPE6N/gSmvI43JeAwsa4v
	 y5f6rXx2KlhxFrq8v9UM1osDwLKivAMiFj8GoItFqsLr3XGCMwqS/j0vcXBZnxNJUpZCo
	 L03epXk+SR15pbvAVbITmRXRMAPBRlAJTQMqBUwz8eA27TMJAIYGntmBYtu+ASSIBmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793902346;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RBmIUHu80SKW/VRZZOQILzfNjSh0opGCQpCY4Xr/Iro=;
	b=Gq+hJZgu6kmk6ZrcmXnHJXSdK4sw5AAaDcBJpv2YBOV9WdGIQXrSjV143Au689YRH2qf
	 h0ZsbMJ3Aflm3SSgLBBvEUJnIZa+3uauO4IPZWBoWXETiZLsNy1+Ey4xsX8ZOVPVwpv8v
	 Hpg6ERrnq4o8trcUloazOAgpD2sk7noexK9wRu/K5dpucNIk8fLLOJ7g3p13hZ3A8TmKP
	 lN9ML2Ckbc4Lh0ZX1Qyq2wKvGEmPRdNd+E2XU7xgtnRAtGomVtsBwCUTfAtDFxleGlrZN
	 gykovnEM05ZxADLAk54x4E0Abw3E8eAedrvn66WIGjK2zeXAg9/73qrk5pLTfTPvnfQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5596F1F00A02;
	Thu,  5 Nov 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902346;
	bh=RBmIUHu80SKW/VRZZOQILzfNjSh0opGCQpCY4Xr/Iro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=emGD02vNyJCJzMnOiHyU/utHrxC8U1zW81e6NyQwwo707uthChZ7oN7HOReNfOEMQ
	 qox7ko5uygsPSWunmnseSvz+Yp7znq+HLqVY30PR0kZzmfz6CUi7KjUYL+KvwzT7so
	 wmU3MO1uOCN9FvALHbeiWxDU2/2byoJI8DxLugS8DJvmIX27Lg3z02jg2JX/pEa/24
	 MmhSK7AJCQaugefeNBfRk6RIDyf+lRe7RG2nOC0nHgbUZ5LVDXE/v6O3hGCxw6UbKJ
	 /5Gt62GYfBCTZPGoB/nzxl/yTORFVmxKiS6Vazu9zCmOcCU5MoRuJ++MHZCP6fOoow
	 T8S5yuIeUboHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDFA4473C8;
	Thu,  5 Nov 2026 18:12:24 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Thu, 05 Nov 2026 12:12:23 -0600
Subject: [PATCH 2/2] wifi: ath12k: don't leave a monitor link started when
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
Message-Id: <20261105-ath-monitor-unassign-v1-2-277f0fbadb91@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793902344; l=1783;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=yJliLnA52UPk6OOcZziqgLXylvHUHFJud+o6Dahzovo=;
 b=RtI+6f08VIMKSgrwalriN0ZtZkc2Iu2Qe8TRHTrgj/6k40N7JIbH5s21SSzcD4HAbUzPEHa4p
 VaHljDdHCQgAdHgfZS9xoqenVGZJOZd07I55M5njTRLZWP7jChamzqJ
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath12k_mac_op_unassign_vif_chanctx() returns early, with
arvif->is_started still set, when ath12k_mac_monitor_stop() fails.
mac80211 can't fail an unassignment and considers the channel context
released, so the link's next assignment hits WARN_ON(arvif->is_started)
in ath12k_mac_op_assign_vif_chanctx() and fails with -EBUSY. A firmware
crash during a monitor channel change is enough: the vdev stop times
out.

ath11k has the same flow and shows the warning that way on a QCN9074.

Fall through to the common path, which clears is_started.
ath12k_mac_monitor_stop() already warns on failure.

Compile-tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9fd3841f71b71..7d04f16f99e37 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -12422,13 +12422,11 @@ ath12k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 	WARN_ON(!arvif->is_started);
 
-	if (ahvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
-		ret = ath12k_mac_monitor_stop(ar);
-		if (ret)
-			return;
-
-		arvif->is_started = false;
-	}
+	/* mac80211 can't fail an unassignment, so the link counts as stopped
+	 * below even if the monitor stop fails (that warns on its own).
+	 */
+	if (ahvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
+		ath12k_mac_monitor_stop(ar);
 
 	if (ahvif->vdev_type != WMI_VDEV_TYPE_STA &&
 	    ahvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {

-- 
2.43.0


