Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686071;
	b=tsC0RWyje6Ru0/xa/1W0DBxa+KyiNSrHATyBP7lPAVwL/qJ2sUe7xV+a3x5+gDmuII/e
	 tC5B+3zPftxzLwtKXzUPjthNelj67Ix6nvPS6ZhzeV6B13XVo7lDMaBrl0HdsyalMpPmV
	 Qgh6Y3lZVg8QwOz1AKJwZR9JSenPdaDp85kZbS2mLgslwB3NinIKZkR2WGGpKU244DhaB
	 xcvtSXgUQHH2y75H1DrRsjXFriHzWKXR8QQmmbYmA06g2D434fTYapABtss+BeNfBWEBt
	 mnFJPKypnxuOmGtb0fyz3NdD7SB+RzZGC0xUxh9DsO+MHXBG6G+udo33zMM0WeLV/BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686071;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=wwMXdVcHWj7VNgwLkXURMtAFowP+ywwx/JvFKagWc38=;
	b=i9yxYMxbSr5PJr74hdwDdloPRC65qSaI22s2kIjThTaWx3enMM1hIMU/TaD/J4UqFJOW
	 THoflmonnfVonddsPB1GJyQA6sJA0Ocw9V4hfKFoBI4SS12QoSeZg+6AXJyc7e+Z8qohR
	 6e/swMnp1TNuSpmcd/cYBPk4cs47ud0UqVktC3RuFqq8pOwDnvNoFz1886eHbfZDZlUg5
	 adbK1lFZzKXHr04heOXfNhBMMqQz08hXKBq2RwePZL8NhUG7NErN1MdJL2xwlgzLGBYj3
	 FSefZP5NMoXSNFndE1GGLARr0SMHLLTAw075REoXkndLEyzPPiJJ8yKBExEUTlk3EZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ork3legz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3172606A32D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 06:07:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3172606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ork3legz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwMXdVcHWj7VNgwLkXURMtAFowP+ywwx/JvFKagWc38=;
	b=Ork3legzMXPUo4f2UaBgh/cOlVBGVj8bSReJntizE7rbHephrSfllwSgPC6b3sAarLSvS2
	mLpsYqd8ekh86B5IIwDMW+Ddx22WrnKtEOQc/ArdkOoE4TtnVQ6Knj/V5FNA7Gx5CrWUrm
	0DUqd1QCPFexWaib32JCXTRVFHp7h6E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-5vqILIpvNNKt6mHTo7xz6g-1; Tue,
 03 Nov 2026 01:07:43 -0500
X-MC-Unique: 5vqILIpvNNKt6mHTo7xz6g-1
X-Mimecast-MFC-AGG-ID: 5vqILIpvNNKt6mHTo7xz6g_1793686061
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D64391956044;
	Tue,  3 Nov 2026 06:07:40 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C013A30000E3;
	Tue,  3 Nov 2026 06:07:35 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: seanjc@google.com
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
	kwilczynski@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	lpieralisi@kernel.org,
	mani@kernel.org,
	pbonzini@redhat.com,
	robh@kernel.org,
	vkuznets@redhat.com
Subject: Re: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
Date: Tue,  3 Nov 2026 07:07:34 +0100
Message-ID: <20261103060734.34199-1-jtornosm@redhat.com>
In-Reply-To: <auilKFwKLjw-BnZM@google.com>
References: <auilKFwKLjw-BnZM@google.com>
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

Hi Sean,

Thanks for the feedback. Understood on both the NAK and the timing,
apologies for the rush.

I am exploring the virtio-msi approach that Jason described, which
would not require any KVM changes.

Best regards
Jose Ignacio

