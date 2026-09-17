Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298C73E40EA
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789627724; cv=none; b=MQVS2XEZEVMaZC4lNyOUZFKf7Lp5sGbSCI76OnTEWXSdbcsAGwDWnypARYclJun2ueFUe9lo/IsNvUP9KI4t2uaFqrOgdAhhKObDdh+f+r9nk4Te0nF4qjTEsVfW6auQLT9wTA75P1CJ25iExEKTEaxIr6wfb6fnMZ18GfMph0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789627724; c=relaxed/simple;
	bh=3jIIF/WOU9H2yQV04mRQjY74nmF7dGtB9JYdYQvm+1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cO9ZlBCHQ7M5UnCroGHtiDvYfG3hezA78grBMhpN3LXn7dwHHVUfuK1714O6++gpfclkUMudwEgEV5euS3GfhmL7aW77oBwSfh8G6qyybpImV/sgBEZ11hrYmNS14YmtsOdOmhWI6e65frlb5L5Sm/xjd5Ag7+vehL3dxkGWrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8vKrf0F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8vKrf0F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789627722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=38XCC3pzzBeGcbj7BSYYe61HHKXklyzXx0gZrWcUPq4=;
	b=i8vKrf0FA+Oww7jZf2aSaZ/o+81HUPip+u0guErohTdPqjGglP/A8CrdK1zIzGYglVnt/x
	AqggsmWLoBGiew3kagSmWhhUmAu0pklXhIs32M1IL3P43VuJUhsuGhoYwtdjHeNXXLyNLN
	VDieqVk7vibeB7psWIJRNWyJxFf6wSk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-L0mNYR8MM02UZed6OsDEtA-1; Thu,
 17 Sep 2026 02:48:38 -0400
X-MC-Unique: L0mNYR8MM02UZed6OsDEtA-1
X-Mimecast-MFC-AGG-ID: L0mNYR8MM02UZed6OsDEtA_1789627717
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F405E18CD2FA;
	Thu, 17 Sep 2026 06:48:30 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B8AA23003EED;
	Thu, 17 Sep 2026 06:48:28 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
Date: Thu, 17 Sep 2026 08:48:21 +0200
Message-ID: <20260917064825.12747-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This series implements custom wake_tx_queue operations for ath11k and
ath12k drivers to prevent hardware ring overflow issues under heavy
traffic.

Without proper flow control, both drivers experience -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
Additionally, ath12k can hang under sustained high throughput. These
issues are more commonly observed in VMs with PCIe passthrough but
also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
adapted for ath11k/ath12k hardware ring architecture, checking
hardware ring space before dequeuing packets from mac80211.

Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
and improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (4):
  wifi: ath11k: use queue mapping for WCN6750 ring selection
  wifi: ath11k/ath12k: remove skb parameter from get_ring_selector
  wifi: ath11k: implement custom wake_tx_queue with flow control
  wifi: ath12k: implement custom wake_tx_queue with flow control

v7: No modification in patches 1 and 2
    Address comments from Jeff Johnson:
      Patch 3: Add the defensive pattern _bh in both spinlocks (ath11k)
      Patch 4: Add the defensive pattern _bh in both spinlocks (ath12k)
v6: https://lore.kernel.org/all/20260811172435.616200-1-jtornosm@redhat.com/
--
2.49.0

