Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73E3C9429
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 06:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712958; cv=none; b=Zt8zT1WqdZduNKKOhe64xI4zESVb+LaWA8MEZTrDo51JpkY723qL7JHHbDJklzf9UM3dH2qOZZgKkfsj55JaDrHshfwlUHkEUTFNbnpU11uNc+O9TE/CGlR6Hmh5jldsMSO3fCWRhX+T7+qaGoP1N6ZvbMlhHKxl/tJIuJ2N4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712958; c=relaxed/simple;
	bh=4b5bv1z8GDsA/z+8sSO5FQpNdMBCC5lJWTJBBHIy7h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEXbFoCoxX6GuXXzMLrGUFJT75y7KnlFKfIWuEX9vzd2yqJ1Vx8NuOhOihpz47Jfl9tPMsbLeKsPNnty9K2aE7zhIH9iQZux/kKAcPael/POHbhlfCQR0gKSsITgTOOC4ADbe7NuXLS1pf8S87tr8u/E7BmLigQ62OvtzcZb1z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GEHAIMHO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEHAIMHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789712956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4b5bv1z8GDsA/z+8sSO5FQpNdMBCC5lJWTJBBHIy7h0=;
	b=GEHAIMHOqiManDGspRQx8TGD+vq/93TwQjyddg4h5WM0ylqp/GUMO6j87RYtI88ZjgBlBX
	SUL1YRVttOShdfVOiq+vE9frQ5XVIQpLNoYNAW45FYMqZh8NGCOpVe+uLOyo9wNAN5/3bD
	GaSxG57iqkYcC/w5ISfjvDThfupBbaY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-cOgYg1zCMzW2m3hJUs0LyQ-1; Fri,
 18 Sep 2026 02:29:10 -0400
X-MC-Unique: cOgYg1zCMzW2m3hJUs0LyQ-1
X-Mimecast-MFC-AGG-ID: cOgYg1zCMzW2m3hJUs0LyQ_1789712948
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4150C1955D76;
	Fri, 18 Sep 2026 06:29:07 +0000 (UTC)
Received: from fedora.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9A6118004D4;
	Fri, 18 Sep 2026 06:29:02 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: helgaas@kernel.org
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
Subject: Re: [PATCH v13] PCI: Add device-specific reset for Qualcomm devices
Date: Fri, 18 Sep 2026 08:29:01 +0200
Message-ID: <20260918062901.7578-1-jtornosm@redhat.com>
In-Reply-To: <20260917170642.GA1026691@bhelgaas>
References: <20260917170642.GA1026691@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Bjorn,

> Ah, so this depends on the previous VM tenant to clean up
> after itself instead of the host kernel enforcing the
> isolation?

That is actually the current situation without this patch, there is no
working reset method, and since it depends on the previous status, the
host cannot enforce isolation at all.

This patch adds a hardware reset that the host uses on every device
reassignment (device-specific reset is position #1 in the reset hierarchy),
regardless of how the previous VM terminated. It improves isolation by
giving the host a real reset mechanism where none exists today.

The clean/unclean distinction was only explaining why things happen to work
today without a reset in some cases, not a limitation of the proposed reset.

Thanks

Best regards
Jose Ignacio

