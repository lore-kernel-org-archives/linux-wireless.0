Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CCB48BD26
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047443; cv=none; b=aNE/esVVGvPeH+Bn3VP5xiMIIdnz5yb33nc+AplzsTzcHoQUmFM44SDqD0SvahXWYSy8DBkTC6/N4uX1hUqABTDQupZ+9eAEWGgW5MPQd7QdsH8dBh8pvGzNZivnJNSCQVkeC4P2Ap+ZqExIrigZ1r/fKIUFJNdp3zgLatLD+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047443; c=relaxed/simple;
	bh=edDdu0m1Tays1tEmbQaqGjg3SKbY2zUZEO/enKdLJNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6LzM4+8VrOFFaAPSU85RM6EQirOT3dj+PwrVedjyJghgxUs+bTcnwL0d1fPajow4w0cbjDonK3Sa1Wn3Rd4GEQYmKa6P1isEthQTHpO3WY9bTx6egun2D7uDnUszuVfgze+GgeganW4Rib2614UfmLSB239rNqnb9bQG0Nf0b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/ZdTy1Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/ZdTy1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792047435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PlndOUpPD0rIHOGOOB7+cfhvzEcigQMJ8mrT3merEI0=;
	b=H/ZdTy1Y/rGfep0UU69jiVLLURtEt5WnbHQnLVyqAtdBVkulTEJNukgSiynUk6S8oyIwar
	ZrW+gHayyv177UZQQflbummAXKFmDAo0BelVhiEfDGJUOobL3jHiq4OAdyaOme1w2V4yHr
	SyNVAji52dcc4Gnq0HhlBLl4UXtuC7M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-zjakPm4AMKSwoTffPaeZCA-1; Thu,
 15 Oct 2026 06:57:11 +0000
X-MC-Unique: zjakPm4AMKSwoTffPaeZCA-1
X-Mimecast-MFC-AGG-ID: zjakPm4AMKSwoTffPaeZCA_1792047429
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B30B1956071;
	Thu, 15 Oct 2026 06:57:08 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B26353000723;
	Thu, 15 Oct 2026 06:57:02 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: helgaas@kernel.org
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jgg@ziepe.ca,
	jjohnson@kernel.org,
	johannes@sipsolutions.net,
	jtornosm@redhat.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	skolothumtho@nvidia.com,
	yishaih@nvidia.com
Subject: Re: [PATCH 4/7] ath11k: add PCIe link recovery retry
Date: Thu, 15 Oct 2026 08:57:00 +0200
Message-ID: <20261015065700.120184-1-jtornosm@redhat.com>
In-Reply-To: <20261014165829.GA1636877@bhelgaas>
References: <20261014165829.GA1636877@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Bjorn,

> Link down is a PCIe reset of the endpoint, which should clear all
> PCIe-specific state, e.g., BAR values.  Is that restored somewhere?

PCIE_SOC_GLOBAL_RESET is a device-internal SoC reset, not a PCIe
fundamental reset. The link drops transiently but PCI configuration
space (including BARs) survives. Only a device-specific window
register needs restoration, handled by ath11k_pci_restore_window()
right after. Same pattern as ath12k.

Thanks

Best regards
Jose Ignacio

