Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605756;
	b=XQK5lC50aEhNFvQFFn4U1Ebu/W+ZkmJ0d1WzctibIAPd3M80tLj+HbIuwz8+Od6n1noV
	 Q0C8XzXR01eiKJOtHWxgtUdRS5kaq+yO1JgNoQtzsRkcgJbnRRuPxzJ4UgwNll6Zd9/kY
	 eZiKHJM9t01AXaxkHZq+gQ6E184RtqVrSWwFdb6+sxO9PgKDFZ4aVBCasCZftrndk15lE
	 VX7nv2DpCOg/AKDLSIIh/OZttP2EDnOHox8RWrA07O0l+OQSEXiAMGPiTbw7Wgd1dWA4H
	 84LwDY122RV5jGdlCPoG7xLHrO+Nya0f1SIH/TVR+JSBN+95vdIP6ylsRvIMbdYsrrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605756;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=9E0zGD2ODat2SvttteActsyR0xXKqRS4RgBIccVpIig=;
	b=suf0HZrCG2Ob4+KE/+yGv1auHkApqJmBLVIaVVcwVh16c5XU8r5TNcGpoN2RR4ZoEiJr
	 g7wHWgiaF3z0yS97geVtdfUW2i6cMjz1Fx++jcanzPFKL4pYheXUYXzF8QmI31/YlsHc6
	 b9HMv/x8/YsW2qfu5qDi/PLK1bZXe+i0GpwNNNC0rFYvMUasw873SeZKsV3FnHjNwI+JC
	 OWIpK8jAEYNLRz/h0zxtU2/RFXpjg8zK7CQVAE8wWAISLKIE1y0nJCIQGbD7MJw/45KAA
	 UcdZbRPpKhL83I8FhhIufRMIyoVjRlrNyJN7ZO7yrSvhW2+n6NsT3CxwkEFp1mQOo+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y2WNM8XS;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E8B606A331
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 07:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4E8B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y2WNM8XS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793605754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9E0zGD2ODat2SvttteActsyR0xXKqRS4RgBIccVpIig=;
	b=Y2WNM8XSRiHDKY0jXgNNSRAraYz56kqs/Jgeucn4DJ8N2E/QC2uGBrmn2FdxMQQXWW3jWP
	day4E7LqpngUYbz5Eq45HmfKDqFhowzrJFuO+PnWPzp/t3fHZkNZWhQFbNVdgj3zmKX1rG
	x02aMfS5jFjaq7sM0tpyHkCV6eRLuxw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-rafnIFLNMu2yIqXetp5ebg-1; Mon,
 02 Nov 2026 02:49:11 -0500
X-MC-Unique: rafnIFLNMu2yIqXetp5ebg-1
X-Mimecast-MFC-AGG-ID: rafnIFLNMu2yIqXetp5ebg_1793605749
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C42019560B8;
	Mon,  2 Nov 2026 07:49:08 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5BF2E300019F;
	Mon,  2 Nov 2026 07:49:03 +0000 (UTC)
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
	kwilczynski@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	lpieralisi@kernel.org,
	mani@kernel.org,
	pbonzini@redhat.com,
	robh@kernel.org,
	seanjc@google.com,
	vkuznets@redhat.com
Subject: Re: [PATCH v3 5/8] ath11k: use KVM MSI domain for VM passthrough
Date: Mon,  2 Nov 2026 08:49:02 +0100
Message-ID: <20261102074902.27907-1-jtornosm@redhat.com>
In-Reply-To: <20261029170044.GR1685504@ziepe.ca>
References: <20261029170044.GR1685504@ziepe.ca>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

> This connection should be done through ACPI somehow, and I think
> Thomas would expect this to be modeled on the platform msi domain,
> just ported to PCI instead of this.

Thank you for the suggestion. I will explore the ACPI-based
discovery approach and study the platform MSI domain model for
the next version.

Best regards
Jose Ignacio

