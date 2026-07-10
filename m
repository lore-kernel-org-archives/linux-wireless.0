Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBB63C4154
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783698899; cv=none; b=pCsbLtwPQI7YnDHuvIwQIDm2rlAmROnPIitmmG1W+YNK3FJ5ILcXxMhqouyMgj/RnKNkxpU1CgC5mzbxbuQd2naHzKgAAp8UZfq//Qmo6I6X2Klyq+3xSQezLF8gWbBehvNXV8mICCeyxg3+virYPjDrbuo8v7H3ffWe+aD6uRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783698899; c=relaxed/simple;
	bh=PT2IfD69KHWtSfNcq3axdvI9lUVielXn1p9BUxgRi2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MqkBP5Qp6J6AVCi01Fi2py0iwv5QCJXPt0CemIX6JNemm88X74wA+TW1ZYqZUumD6OZ6Omm3B+VsOin2qFc+znHRf7SE6bXRlcUeUNLlHQpUnzdTcqYJOz4CqpoFzgcV5OPEK8dcDgf/dYGK3L2VRyjiFlLLAZVepIcRRuIDn+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGgUvZeV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGgUvZeV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783698897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bjiyv0lirhfy7+vrSMfYOoDKtgGzU0tRvcCRuYupkas=;
	b=BGgUvZeVPxLDIg7u38qmYapS1cyM+hC9yEpPTEz9vJkSlbwVxUe3S6gb9stAOEjLMpQtcS
	OZi5WEQaMi6a9y2zQf2BtEUgbUEW+SH+h4Tx+799f104GW1+WCnsiyjI2nirHRdmDcqlEz
	HEF9wayowkgDfIn3o0TukPGZhP46NIE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-HavAsTw3O3uLypCFXCWu5Q-1; Fri,
 10 Jul 2026 11:54:56 -0400
X-MC-Unique: HavAsTw3O3uLypCFXCWu5Q-1
X-Mimecast-MFC-AGG-ID: HavAsTw3O3uLypCFXCWu5Q_1783698895
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4308E1955EBC;
	Fri, 10 Jul 2026 15:54:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE9591800480;
	Fri, 10 Jul 2026 15:54:51 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 0/2] ath11k/ath12k: implement TX flow control
Date: Fri, 10 Jul 2026 17:54:41 +0200
Message-ID: <20260710155443.1761760-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This series implements custom wake_tx_queue operations for ath11k and
ath12k drivers to prevent hardware ring overflow issues under heavy
traffic.

Without proper flow control, both drivers experience -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
Additionally, ath12k can hang under sustained high throughput. These
issues are more commonly observed in VMs with PCIe passthrough but
also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
checking hardware ring space before dequeuing packets from mac80211.
Per-packet locking serializes ring access while allowing TX completions
to run, preventing deadlocks.

Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
and improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (2):
  wifi: ath11k: implement custom wake_tx_queue with flow control
  wifi: ath12k: implement custom wake_tx_queue with flow control

 drivers/net/wireless/ath/ath11k/dp.c       |  1 +
 drivers/net/wireless/ath/ath11k/dp.h       |  2 +
 drivers/net/wireless/ath/ath11k/mac.c      | 49 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.c       |  1 +
 drivers/net/wireless/ath/ath12k/dp.h       |  2 +
 drivers/net/wireless/ath/ath12k/hal.c      |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 50 +++++++++++++++++++++-
 7 files changed, 104 insertions(+), 2 deletions(-)

-- 
2.54.0

