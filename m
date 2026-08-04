Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6DA47140E
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865824; cv=none; b=ePpisoUKFitDqt+7bRuEvO7eER1G0MmjVTD0+9z73pNIdV2aJjy7SQNymBRKf0DZ1xCyiWy0flhoHoeZq9qhqVq3hEuinhkO4m2+54Wm44pnItLGvPLEwxjYviyRIoVksqbC1PSR5CNoGeVTPFHrww+ASvZWu+0U68g4Zuj54T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865824; c=relaxed/simple;
	bh=/V991US5seYZPgS78P/yp8f5WuaUZNAzVIjryE3saD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=guSzGSVt6k4NkrAliVe2XENSh+gNYGfZY7YiEMMP7nIAx8Zy+u2Kc6mWbpwK1IY3w5r0JNW8QG/5OJs5UDePBtGCPedC9PKGppAGAhvSVYP2sF1ERLh92FOwX9cWRbmoYMFc0GGI7GIxUZHcJxblCwto10ZEil0/AWtrqK7w5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c1uKya8Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1uKya8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785865814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=csMVXm96rnd27MaHDb/ezPMlPIqqVgNsyKE4NXILxO8=;
	b=c1uKya8Qbnwl9PbP1bYpgEvX7fxXG+i/RsktEdfAlJ+/snk5SyDij3qYQ99Z4c3KNxcvgD
	g49Eyc+4N2jmZDNN5tUbCt7awgzcsuY0m5lJqMBpaxQsTOo7DuIt7/MERhNIy/rTY3gYMq
	qjiVaZe1RJIYXefSPM76UrYWfE1dbJA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-e_-biiSVNmGu4_-NbZNWJg-1; Tue,
 04 Aug 2026 13:50:11 -0400
X-MC-Unique: e_-biiSVNmGu4_-NbZNWJg-1
X-Mimecast-MFC-AGG-ID: e_-biiSVNmGu4_-NbZNWJg_1785865809
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A414218004AD;
	Tue,  4 Aug 2026 17:50:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 80E58180044F;
	Tue,  4 Aug 2026 17:50:07 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 0/3] wifi: ath12k: fixes to improve MLO station stability
Date: Tue,  4 Aug 2026 19:49:58 +0200
Message-ID: <20260804175004.1761075-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This series improves firmware crash recovery and connection stability
for MLO (Wi-Fi 7) stations on ath12k. Both work correctly for non-MLO
(Wi-Fi 6) stations, where the driver handles the full teardown and
reconnect cycle without issues and maintains stable connections. This
series brings MLO to the same level.

Without these fixes, a firmware crash during an active MLO connection
results in kernel warnings, NULL pointer dereferences, 20+ second
recovery delays, and periodic disconnections both after recovery and
during normal operation under heavy traffic.

Patches 1-2 fix firmware crash recovery:

Patch 1 moves the RECOVERY flag clear to reconfig_complete and adds
        CRASH_FLUSH guards to prevent operations on dead firmware.
Patch 2 prevents scans during recovery to avoid NULL dereferences.

Patch 3 fixes MLO beacon miss handling:

Patch 3 skips connection_loss_work for MLO entirely, since its
        cancellation mechanism is unreliable and the mac80211 probe
        triggered by ieee80211_beacon_loss() is sufficient to detect
        real AP unreachability, as done by other MLO-capable drivers
        such as mt76 and rtw89.

Tested on WCN7850 with MLO (Wi-Fi 7).
Firmware crashes were observed to occur spontaneously during normal
MLO operation with intense traffic testing, though rarely.
The debugfs simulate_fw_crash interface was used for systematic testing
and reproduction during active MLO connections with traffic.

Note: I will have limited availability from mid-August to
mid-September. I will address any review feedback before then
or promptly after returning.

v2:
  - Rebased on ath/main (requested by Jeff Johnson).
  - Patch 1: rebase and address comments from Baochen Qiang:
    - Remove CRASH_FLUSH guards from HAL srng source ring helpers
    (ath12k_hal_srng_src_num_free, ath12k_hal_srng_src_get_next_entry,
    ath12k_hal_srng_access_end). They were a layering violation — the
    HAL should not know about device crash semantics. They were added
    as a precautionary measure to abort as soon as possible, but
    ath12k_wifi7_dp_tx() already has a CRASH_FLUSH check before any
    HAL call.
    - Fix radio[0] usage in change_vif_links, sta_state, and
    peer_mlo_link_peers_delete to use per-radio ab.
  - Patch 2: fix radio[0] usage
  - Drop v1 patch 3 (fix MLO dp_peer ID desync with firmware):
    already fixed by Baochen Qiang's ML peer ID series in ath.git
  - Drop v1 patch 4 (fix MLO beacon handling using per-link
    addressing): patch 3 (v1 patch 5) skips connection_loss_work for
    MLO entirely, making the per-link beacon matching and cancellation
    in v1 patch 4 unreachable (Baochen Qiang comment).
  - No modification for v1 patch 5, now v2 patch 3.
v1: https://lore.kernel.org/all/20260727162748.963275-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (3):
  wifi: ath12k: fix MLO station firmware crash recovery
  wifi: ath12k: prevent scan during firmware recovery
  wifi: ath12k: skip connection_loss_work for MLO beacon miss

