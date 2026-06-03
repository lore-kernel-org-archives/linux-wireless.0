Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62814611C2
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 10:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484350; cv=none; b=WXfynU4BZ8pYb+lLUB/gz29EPs71vWhtD7J4yYJpFgojLlY7fZzQOPft+uS4J66hSFb3bZLstbRYY6IidC2hh5HJdkm4uHSPEzWgYzUi314Eg2STDt48zlJLdErySdJP7dFQ6uClHg9IJFjKbdf00bQMk5LwD26C8dHH+XQWPEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484350; c=relaxed/simple;
	bh=ZubWPNKb76BgJrfDBjrP2CunDrq90eRpkW8OkfVt0Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YyQr0s9O/k7hNrGINPF2ZHV0FCL4gcuPrcR+hzLTuT7y2W2ruWQYw6mzZ/ZKe35bNnJdEAdSfdjCfR3kWiokzAVOn3uDUraWRCB3eyHEYjqdduNcoJmkdMHHiQrzppzqmEP2tBncj4C6QXLPRxfA+IHIWgRv+GHB+l27aZrTtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DizyQp2P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DizyQp2P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780484349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gUOUj2uQfA2vt7AFIl1y5TD83w2VwUTO4xUveVofnp8=;
	b=DizyQp2PkutsUVgKxgffvE3N4ciZrC7/C7fmXBPtjl5YE2cM1sRw4OjCa0/c1GlQfTetu4
	Q9sC0A0x0m16t93eWepp1zIAU889K8o5gzudxAudPuIgzSce6tWiE7uTf3J6OYKpisKmx7
	aCnmTG7hFIe4TEaDy2E0b/MnyMc/ORk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-U-giJPGxMgSEXrRIli0tUQ-1; Wed,
 03 Jun 2026 06:59:05 -0400
X-MC-Unique: U-giJPGxMgSEXrRIli0tUQ-1
X-Mimecast-MFC-AGG-ID: U-giJPGxMgSEXrRIli0tUQ_1780484343
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8AE71956060;
	Wed,  3 Jun 2026 10:59:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.81])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26C721956095;
	Wed,  3 Jun 2026 10:58:57 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org
Cc: jjohnson@kernel.org,
	mani@kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v7 0/3] PCI: Add d3cold and device-specific reset for Qualcomm devices
Date: Wed,  3 Jun 2026 12:58:50 +0200
Message-ID: <20260603105853.326290-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Some PCIe devices lack working reset methods for VFIO passthrough scenarios.
These devices typically have no FLR, advertise NoSoftRst+ (blocking PM reset),
and have broken or unavailable bus reset. When a VM crashes, VFIO cannot reset
the device for reuse without a working reset method.

This series addresses the problem by adding general d3cold infrastructure and
device-specific reset for Qualcomm devices:

**Patch 1/3: d3cold reset method**
Adds D3cold as a general reset method with strict _PR3 requirement. Only
attempts true power cycling via platform control (ACPI _PR3), never falls
back to D3hot. This provides genuine power-off reset on platforms that
support it.

**Patch 2/3: device-specific reset for Qualcomm devices**
Adds device-specific reset entries for Qualcomm WCN6855/WCN7850 WiFi cards and
SDX62/SDX65 modems using D3cold power cycling with automatic D3hot fallback.
Uses pci_set_power_state(D3cold) which automatically falls back to D3hot on
platforms without _PR3. Extracts shared pci_dev_d3cold_d0_cycle() helper to
avoid code duplication with general d3cold method. Device-specific reset is
position #1 in reset hierarchy, providing immediate working reset for these
Qualcomm devices.

**Patch 3/3: Qualcomm quirk_no_bus_reset**
Disables broken bus reset for Qualcomm devices. Testing proves this is
device-specific: MediaTek MT7925e works correctly with bus reset using the
same passive M.2-to-PCIe adapters where Qualcomm devices fail, confirming
PERST# is properly wired and the issue is not deployment-specific. Acts as
safety net to prevent broken SBR if users override via sysfs.

v7: Address the comments from Jeff Johnson: the problem was detected for
    the specific devices WCN6855 and WCN7850, use the name of the devices
    instead of the related drivers ath11k and ath12k, which support a large
    number of devices (patches 2/3 and 3/3).
v6: https://lore.kernel.org/all/20260602160024.1171949-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (3):
  PCI: Add d3cold as general reset method
  PCI: Add device-specific reset for Qualcomm devices
  PCI: Disable broken bus reset on Qualcomm devices

--
2.53.0

