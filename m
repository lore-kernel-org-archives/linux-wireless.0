Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453B5427F9C
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792048180; cv=none; b=da9D1Xrv86gvHhh7Oyq7hKB0Q/W0i2I0kMsmArXHaaOywcYUcEbmpFRuPL1TZEhpy3wtspEHDDRzbvGij91s6/TTdQROqbKMPEID1W4X4w43NaZW3uvicHBmWZAx2sGfOnYHFCWqweWyJecNbwRWRjOboTRcQZbMRk/4pkxX2FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792048180; c=relaxed/simple;
	bh=vSE6SF/O7vjB6gvtVPX8GgYZcDaIDXMtT2/2oI7pXAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdmrSeEm5iXEoPvB/s8uob+Jt7Oh3tEBKHOEP3czj823jWxWsgmA6RzuBhl+EjDyc195yLUtbM2dR0rj5kpfKNW6+CNsf8qCkHuPk8zc4h621p6z3yQdUP1PpjylsL/0Rhzt6TZp6u+knwzyXGK7W1QSrJhLT/82R2+kuhP80ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZ781QyM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZ781QyM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792048172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSE6SF/O7vjB6gvtVPX8GgYZcDaIDXMtT2/2oI7pXAI=;
	b=LZ781QyMYaG31kqXmcnoLhvBJkdHsnSE9UlydqGfwfYT84R+RMmFBmbFks2ziCSsMXuR3D
	E/ub9B1YWyvNK/P+AMdcWZikdbJqqppiPGA9x+Aj/1vahXTV6dLqqX1Z5G/RnRFRyNrao9
	UyPP/BnZN4aUcx9C6GyK3zkwgvELZg8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-SirXxdeDPEuJ2pN2inpTCA-1; Thu,
 15 Oct 2026 07:09:28 +0000
X-MC-Unique: SirXxdeDPEuJ2pN2inpTCA-1
X-Mimecast-MFC-AGG-ID: SirXxdeDPEuJ2pN2inpTCA_1792048166
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BCE31956067;
	Thu, 15 Oct 2026 07:09:26 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 485A8300072E;
	Thu, 15 Oct 2026 07:09:20 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
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
Subject: Re: [PATCH 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
Date: Thu, 15 Oct 2026 09:09:19 +0200
Message-ID: <20261015070919.466876-1-jtornosm@redhat.com>
In-Reply-To: <20261014150047.GO14213@ziepe.ca>
References: <20261014150047.GO14213@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Jason

Thank you very much for this. This is a very good and complete analysis.
I need some time to study this carefully and understand all the
implications. After this I will try to do an initial proposal to work on.

Best regards
Jose Ignacio

