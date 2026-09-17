Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8EE46D085
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789629431; cv=none; b=F+ce9w1tZgKo2lMTeNvyBrof7Cz8RKfXLNAyMUt7CP1eG2Zq4ErniOilC+bRg0hR3ghu3Eh3bAGzr1SZ4sYVHCcQ6IVCJX0hNEfBkk+KFKgvZB9VgUeThHCWHqI2CUMj9NvKNg+ds0iHQCd55I0YeUXkLc6Bb6HAh0dPqcK4xMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789629431; c=relaxed/simple;
	bh=psMZRwkOfr0bnXRHKcURRMVFhIPKVSfM6YNHBR7Q0j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hn4Q/XrlK2KqNQNl2xj+5xN+1V0QzCo/sKkcGhElw3fxxUT3IH9EjbiV3PPCEtLNj7bYSMljkUx2LB3o8uzsH5SF+VnSBmwRKKHygBkYSK1K3OovMjSezPen7Rf4ZKowKvhqB3wRhKlFf47+ffDnNizu9zgFn/1CqTCVhebbLxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKKNJcye; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKKNJcye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789629427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VhU95cDMBIXQvMna+tKy46BOvuCr3e2931Pn9vAkduA=;
	b=UKKNJcyeJoqjQ7vhRo0XcB5zVCk2o36B2NI7+Wvkq8n/UTOKNnksLwAoWHe179x+lPpBEX
	JshvObcuwJebYvMNaN18uSyY+ORuflUdKH+19oABQa22oVWQpgqUz4bbAsNsi2hzyr8U86
	OjuKvVehlnSjJar5IH7bm9YtXUjSMbI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-AUHHK_xEM-uUnwU6D4tLMA-1; Thu,
 17 Sep 2026 03:17:04 -0400
X-MC-Unique: AUHHK_xEM-uUnwU6D4tLMA-1
X-Mimecast-MFC-AGG-ID: AUHHK_xEM-uUnwU6D4tLMA_1789629422
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E17E184B3A8;
	Thu, 17 Sep 2026 07:17:02 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C799427;
	Thu, 17 Sep 2026 07:16:58 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org,
	mani@kernel.org
Cc: jjohnson@kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v14 0/2] PCI: Add device-specific reset for Qualcomm devices
Date: Thu, 17 Sep 2026 09:16:49 +0200
Message-ID: <20260917071651.14174-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Some Qualcomm PCIe devices (WCN6855, WCN7850 WLAN; SDX62/SDX65 modems)
lack working reset methods for VFIO passthrough scenarios. These devices
have no FLR capability, advertise NoSoftRst+ (blocking PM reset), and have
broken bus reset (addressed by quirk_no_bus_reset, merged for v7.2).

VFIO attempts to reset devices on every reassignment:
- For the listed modems, without a proper reset capability, these devices
never successfully initialize even on first VM assignment.
- For the listed WLAN devices, without a working reset method, the attempt
fails. On clean VM shutdown, the guest driver properly deinitializes the
device via .shutdown/.remove callbacks, leaving it in a usable state despite
the failed reset. However, on unclean VM termination (crash, force-off), the
guest driver callbacks are not triggered, the device remains in an undefined
state (DMA active, interrupts enabled, etc.), and without a working reset it
cannot be reused.

Add device-specific reset methods using BAR-space hardware reset registers
that exist in these devices:

  Patch 1: SDX62/SDX65 modem reset via MHI SoC reset
  Patch 2: WCN6855/WCN7850 WLAN reset via SoC global reset

These are true hardware reset mechanisms (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios.

Testing shows stable operation over 100+ VM crash/reset cycles. Device-
specific reset is position #1 in the reset hierarchy, so these devices
will use hardware reset as their primary reset method.

Jose Ignacio Tornos Martinez (2):
  PCI: Add device-specific reset for Qualcomm SDX62/SDX65 modems
  PCI: Add device-specific reset for Qualcomm WCN6855/WCN7850 WLAN

 drivers/pci/quirks.c | 116 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

---
v14: Address Bjorn Helgaas feedback:
  - Split WLAN and modem resets into two separate patches
  - Clarify commit message for WLAN devices: VFIO resets on every
    reassignment, clean shutdown leaves device in usable state via
    driver callbacks, but unclean termination is where the lack of reset
    is critical
  - No code changes from v13, only patch split and commit message
    clarification (Mani's Reviewed-by retained)
v13: https://lore.kernel.org/all/20260915223634.GA878346@bhelgaas/

--
2.54.0

