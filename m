Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BA53033D6
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169690; cv=none; b=oCRMXVBECceAL3hdh+YFdYpyqqGu9c1QUlYfek3psSjvj/vMm1Mv8XL40CDi7jDIL1cMGwltE+j+vuO0nHiSLnQUZmThHnXtW44Uo/7KrTY2KHuIM6bgBadU+PG8FvAw6/YNdF/OvIGGCZIGaKGQymP0XhksHRuI34pdBsIvmxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169690; c=relaxed/simple;
	bh=gYsmuybHRI+6EnLiBgwJy2PGYKU4hMABq/B305KTV1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VDW1ayYSrPey5KCeWfINIBkVOD8pjpNBRp2RR8yRp95u5Ae44BFOXUC47BbjH4EGQQawwOOl1p7IQEZ1gvAV9lLSURBE0gjdFk9fkzhXhqsNd6FXPEX6LnLARtlCVAbv6BaVy9xrUcCbQ7JP/nl41I9cF8CZKpu3AhGnHI2kDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJVEU70Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJVEU70Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785169687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lCYT1Xihnl2MEFF4EmXT3VpRMBqw9OFUfd1mdz2BxHs=;
	b=gJVEU70Y+Y9kynfWhLg9KSYFqsvslKnzk5aa+lp5hZObrx09mpk7VNPbNXA3FONSlXI8FX
	l2YL3OhtCPk2pVqWKq5T9DufTnLAYf6uaCWIemmsfszCLVarXzSavoOzu45prkGIK796rD
	Sv/epRBRCXMNaVFcSwY3MyYz/9Z6JYw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-290-aMQfWe6_NvipD4KRy9ov0Q-1; Mon,
 27 Jul 2026 12:28:03 -0400
X-MC-Unique: aMQfWe6_NvipD4KRy9ov0Q-1
X-Mimecast-MFC-AGG-ID: aMQfWe6_NvipD4KRy9ov0Q_1785169681
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 593741800758;
	Mon, 27 Jul 2026 16:28:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3246C42B;
	Mon, 27 Jul 2026 16:27:57 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 0/5] wifi: ath12k: fixes to improve MLO station stability
Date: Mon, 27 Jul 2026 18:27:43 +0200
Message-ID: <20260727162748.963275-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

This series improves firmware crash recovery and connection stability
for MLO (Wi-Fi 7) stations on ath12k. Both work correctly for non-MLO
(Wi-Fi 6) stations, where the driver handles the full teardown and
reconnect cycle without issues and maintains stable connections. This
series brings MLO to the same level.

Without these fixes, a firmware crash during an active MLO connection
results in kernel warnings, NULL pointer dereferences, 20+ second
recovery delays, and periodic disconnections both after recovery and
during normal operation under heavy traffic.

Patches 1-3 fix firmware crash recovery:

Patch 1 moves the RECOVERY flag clear to reconfig_complete and adds
        CRASH_FLUSH guards to prevent operations on dead firmware.
Patch 2 prevents scans during recovery to avoid NULL dereferences.
Patch 3 fixes ML peer ID desync between host and firmware by syncing
        the peer ID from firmware's actual value.

Patches 4-5 fix MLO beacon miss handling:

Patch 4 fixes beacon_iter to iterate all MLO links instead of only
        deflink for BSSID matching and connection_loss_work
        cancellation.
Patch 5 complements patch 4 by skipping connection_loss_work for MLO
        entirely, since its cancellation mechanism is unreliable and
        the mac80211 probe triggered by ieee80211_beacon_loss() is
        sufficient to detect real AP unreachability, as done by other
        MLO-capable drivers such as mt76 and rtw89.

Tested on WCN7850 with MLO (Wi-Fi 7).
Firmware crashes were observed to occur spontaneously during normal
MLO operation with intense traffic testing, though rarely.
The debugfs simulate_fw_crash interface was used for systematic testing
and reproduction during active MLO connections with traffic.

Note: I will have limited availability from mid-August to
mid-September. I will address any review feedback before then
or promptly after returning.

Jose Ignacio Tornos Martinez (5):
  wifi: ath12k: fix MLO station firmware crash recovery
  wifi: ath12k: prevent scan during firmware recovery
  wifi: ath12k: fix MLO dp_peer ID desync with firmware
  wifi: ath12k: fix MLO beacon handling using per-link addressing
  wifi: ath12k: skip connection_loss_work for MLO beacon miss

