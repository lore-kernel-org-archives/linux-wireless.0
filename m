Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EF3B14D9;
	Sun,  4 Oct 2026 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112827; cv=none; b=khSLkGVPunOr4Lvrr7qX4aPAtCbVssEnhFPCrMrOZ7DU+m7dHbqxhLlzyUu2FEfDxklygTtRj+Bh1ubM/JgI7hLN6eEz4AYfVZy7D5WLvk+yBTCdtbY9Dnm9Mkrpryu26ULlWrlWIUY5SLMDjJXw7AqFETzPgW/Vy4x0nu5X+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112827; c=relaxed/simple;
	bh=Nc4Mqn0knuQ4dLr4JgIjllgRDHkYIAMCKbpZC+AmqwE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D0KLupZaQm99XDwMv/ayYxMLcjBUxC2T4tZ+nt7ZaQX4TB1gML3F4sypCyCeK9WC5f9s7A6yxT1FjuLdjKIG8KcSgCZMY3KW5PH5KF5D+Rz7OY4TGf7Cu9pZFyUCKZC6ub8FToMZENEYJQACKJ/MaNiobUcDq+DUf5xSY2Z3ncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=D2rO67wu; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="D2rO67wu"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 54D991BAB7;
	Sun, 04 Oct 2026 14:20:24 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=8C7L5pliSom0lO9g3nHV
	GPCRYQtR384zHPRAUX1iNhg=; b=D2rO67wuovxSXjyQmoeUMuhrb9zc/FLGCqlp
	T32SGpKyQKR5/8SyY2SUc3cOX+fTzaATV96YTlFt9JTrCaQ+RI8pbDPs1xfaVNLy
	u0e1Eg7DtIJbosrQVS1Fn/z0nZl7t+YhAOjC8nEOpWhKxXVe3aUdWPzci+i0R6hT
	rbnzMBLVkdMqMCL2fp8qZMNASI2vkak78rkmQvDu/KAFYCVRi2Nc/0ue7RftepgU
	gEX1DDcvsiGd3zLDdKUopULfMsM9Ui6G1xCKLHRIricB/gke6QfLsUsa8eJM5K5M
	Ji2RS27Jv7WRpCOSiKCH173Vdx5bmgvGPW8ljDeuevMxX5rMPQ==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 8EF551BAB6;
	Sun, 04 Oct 2026 14:20:23 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:20:23 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 2/5] wifi: ath11k: count down channel switch announcements in mac80211
Date: Sun, 4 Oct 2026 14:18:04 +0300
Message-ID: <8d40acb1fc26b8f18b0cffcbb17b408f0746f529.1791111135.git.me@andrei-z.com>
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

ath11k handled the CSA switch count event only once the count reached
zero, to finish the switch, and did not ask the firmware for an event at
any other count. mac80211's countdown therefore never moved: Probe
Response frames, which mac80211 fills from it, and every beacon template
uploaded during the switch carried the initial Channel Switch Count,
although IEEE Std 802.11-2024, 9.4.2.17 has it give the number of TBTTs
left until the switch.

Request an event for every count in the beacon template command and
decrement mac80211's countdown on each one that matches the expected
count; a beacon that failed to go out repeats the previous count, which
is then skipped. This is how ath12k handles the same event.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/core.h |  2 ++
 drivers/net/wireless/ath/ath11k/wmi.c  | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923e..0b10dac706 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -395,6 +395,8 @@ struct ath11k_vif {
 
 	bool is_started;
 	bool is_up;
+	/* CSA countdown value the firmware is expected to report next */
+	u8 current_cntdown_counter;
 	bool ftm_responder;
 	bool spectral_enabled;
 	bool ps;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795ed..b7944f98a6 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1806,6 +1806,9 @@ int ath11k_wmi_bcn_tmpl(struct ath11k *ar, u32 vdev_id,
 	if (vif->bss_conf.csa_active) {
 		cmd->csa_switch_count_offset = offs->cntdwn_counter_offs[0];
 		cmd->ext_csa_switch_count_offset = offs->cntdwn_counter_offs[1];
+		/* a switch count event for every count, not just the last */
+		cmd->csa_event_bitmap = 0xffffffff;
+		arvif->current_cntdown_counter = bcn->data[offs->cntdwn_counter_offs[0]];
 	}
 
 	cmd->buf_len = bcn->len;
@@ -8385,10 +8388,6 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
 	struct ath11k_vif *arvif;
 	int i;
 
-	/* Finish CSA once the switch count becomes NULL */
-	if (ev->current_switch_count)
-		return;
-
 	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
 		ath11k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
 			    num_vdevs, vdev_ids_len);
@@ -8405,8 +8404,22 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
 			continue;
 		}
 
-		if (arvif->is_up && arvif->vif->bss_conf.csa_active)
+		if (!arvif->is_up || !arvif->vif->bss_conf.csa_active)
+			continue;
+
+		if (!ev->current_switch_count) {
 			ieee80211_csa_finish(arvif->vif, 0);
+			arvif->current_cntdown_counter = 0;
+		} else if (ev->current_switch_count > 1) {
+			/* A beacon that failed to go out repeats the previous
+			 * count; mac80211 counts down once per beacon sent.
+			 */
+			if (ev->current_switch_count != arvif->current_cntdown_counter)
+				continue;
+
+			arvif->current_cntdown_counter =
+				ieee80211_beacon_update_cntdwn(arvif->vif, 0);
+		}
 	}
 	rcu_read_unlock();
 }
-- 
2.47.3


