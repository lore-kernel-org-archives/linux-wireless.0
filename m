Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECCA3D332C
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782383726; cv=none; b=lCYo3cM9j4j5WVOYmFJtVnn0JkLvXMrxivrTWBLp01qItXhROSrEq6Qrtd8ymAzXM0GPjRdvaXPbujYg5572KQGQ28/amWi5cTOrARP1kPlcnndV6eB76NF1cbnXnBZ+spdMj+RMpIXTL3KtVB8t7jD/eGfosHcSZd+YZj4ilFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782383726; c=relaxed/simple;
	bh=Y3Miu2YhT7SrtUsYIL8AYGPh3SjyCfmCKsBa9nRtp8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TplHvKjZ9EZ4+GcnbAsxKLQLXGaHUYAj8ppPTfoMP+R8PsgNgYxeCKeHKDFzyVQpdK4ehy2/COReurGTbUn0yEslvnzA9ueCRye3H7nLnpm+4PQERHicUnf1iDER6A9awJsmLTBbqXsRDqOqKDvrp5AJ8cKNOyjA9UT17nCf3u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ihH3YPAF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ihH3YPAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782383724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1RjNSxi6/DZ1slyVUbnnH4tQHsFe5xiJqc+dcxVOzE=;
	b=ihH3YPAFHcWjnaE+katKXZLlAJXbFSU3x5fE91y7d5E4hCZLtsvkKEa8foC/IHkvxCeFiq
	pIt12LMu+RBU9CcuopJoQpW/YskN7Y4gkOOTEChm/n6d4XuFnt3zdqTbkl4s4U6Ggom+iE
	nH2pVeDLytDYXZRk7Jp3sg39Z5UCfQo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-XJDlf0bfPs-KqjrzTaxxaQ-1; Thu,
 25 Jun 2026 06:35:22 -0400
X-MC-Unique: XJDlf0bfPs-KqjrzTaxxaQ-1
X-Mimecast-MFC-AGG-ID: XJDlf0bfPs-KqjrzTaxxaQ_1782383721
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E0931955F75;
	Thu, 25 Jun 2026 10:35:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.60])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A052630003B6;
	Thu, 25 Jun 2026 10:35:15 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	mhi@lists.linux.dev
Subject: Re: [PATCH v10] Add device-specific reset for Qualcomm devices
Date: Thu, 25 Jun 2026 12:35:14 +0200
Message-ID: <20260625103514.602783-1-jtornosm@redhat.com>
In-Reply-To: <4cdfb71b-2ef8-4985-8294-c4a29e37faa3@oss.qualcomm.com>
References: <4cdfb71b-2ef8-4985-8294-c4a29e37faa3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Baochen and Mani,

> QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET is beyond the first 4K bar area hence requires MHI
> wakeup before accessing, see [1]. the wakeup callback for WCN6855 is
> ath11k_pci_bus_wake_up() which calls mhi_device_get_sync(). Not sure how this can be done
> here. Maybe Mani can provide some hints?

I've analyzed the driver code and see that ath11k_pci_power_down() calls
ath11k_pci_force_wake() before sw_reset(). 
I can add the same force_wake sequence to the WiFi quirk before accessing
the reset register:

/* Force wake before accessing registers beyond 4K boundary */
iowrite32(1, bar + QUALCOMM_WIFI_PCIE_SOC_WAKE_PCIE_LOCAL_REG);  // 0x3004
ioread32(bar + QUALCOMM_WIFI_PCIE_SOC_WAKE_PCIE_LOCAL_REG);      // Flush
msleep(5);

With this addition, both WCN6855 (ath11k) and WCN7850 (ath12k) show successful
reset and shutdown cycles in VFIO scenarios, same stability as without it.

Do you consider this addition necessary, or is the current v10 implementation
sufficient given that testing shows direct register access works without
wakeup in VFIO scenarios (where no driver is loaded)?
If you recommend including it, I can send v11 with the force_wake sequence
added.

Thanks

Best regards
Jose Ignacio

