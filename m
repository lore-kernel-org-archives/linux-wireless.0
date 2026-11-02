Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605636;
	b=uE3BmKuzYjzvOrJ1fZ9b0e26dMqB9lhsabjN/PV+t1rYlFIWf6xzCDyLchO8ESSPBEH2
	 VUNAyDQ83HoyDQgNKcKsmBGTmCrdVe2DxHFGVmQSfa5IAoapCNREox+bilvU5wlL9NYAJ
	 eUMEowm7pUClgDMFK4OlP55gqzxUb3neEmT7PK4a0uT0WuuKorbCnCyQNUqU9J2CwTfAg
	 CrCpR1WR7wYQq1sQcDRM/M1GFqWjGDRqhGwjNUjVaE3bQ01X2axRsMoM/gE6CP1gApnJX
	 DUg9aKN9p4RPKKfA64xVWXbcYXu0Y38tX08bnZt9ZRSSvtYWQs6MeXOoTiXY5JV4GYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605636;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=CJbWBTkQs4ODLU2SOn+Ys6gLyVwtafR2qeYrx5uFG3c=;
	b=frzo9ILhMPZBCdqaenY6V/ny6oPK7qKuX2x53R2pGS52F5ATSh+V/NrscapEn54jhRsl
	 ZElC1uqqOG1vqCCO9My44rVijqCU0EBBBKyxPj9jGFwywOgrIljCsTl3r31v5sNN+Mz5I
	 co3m3wk9DLxKcToFvxgBYcLvNztcDZ2AgGgIYFnmrrdD8p0PSBirOWBQD6yxhtHqgkpwv
	 pM+87QJy92UVAoczdAntbTtJOD9KFzEUhWoOF+NDPNKWjetuxajEMvAmvLBBg11SXcH6n
	 ZpSRflCM2bE5UFJmKd/zbnN3n1qW1eqG5EOAqxyQTZrf6zy5o00H9Dc9mq+IQeipx1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SckGzZHl;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C6606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 07:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 444C6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SckGzZHl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793605635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJbWBTkQs4ODLU2SOn+Ys6gLyVwtafR2qeYrx5uFG3c=;
	b=SckGzZHlqcPQpW44wH/DJUGU94xPAs21ICp3uc8z/ROb3YEyOVVNvlUJq2bhIx956tmyYi
	IQWZ+k+1tx7otVI4Qux70ycJDTNzjfaDjiH8mA015zU5hQ9+uPUVqmqZ/282fpfQ+s7o5B
	qVLrVU12cESn5x3KHaBa7N1R1md0GGI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-FF4iaEjJOfe4njgd1da7Zw-1; Mon,
 02 Nov 2026 02:47:11 -0500
X-MC-Unique: FF4iaEjJOfe4njgd1da7Zw-1
X-Mimecast-MFC-AGG-ID: FF4iaEjJOfe4njgd1da7Zw_1793605629
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AA331964CD0;
	Mon,  2 Nov 2026 07:47:06 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF1751956087;
	Mon,  2 Nov 2026 07:46:58 +0000 (UTC)
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
Subject: Re: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
Date: Mon,  2 Nov 2026 08:46:57 +0100
Message-ID: <20261102074657.27715-1-jtornosm@redhat.com>
In-Reply-To: <20261029165845.GQ1685504@ziepe.ca>
References: <20261029165845.GQ1685504@ziepe.ca>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

> This is not quite what I suggested, this still relies on the host
> setting up the msi using the trapped MSI emulation, which is the
> primary hack..
>
> Was it too hard to make this an 'allocate msi' operation?

I tried this approach as a simpler mechanism to just read the necessary
info from the host side. Ok, I will explore a true allocate operation
for the next version.

> Yet here it is called alloc?

> And this isn't alloc, it is some query..

You are right, the naming was misleading. The implementation was
a query, not an allocation.

> I feel like VFIO shouldn't be involved here, for the purpose of MSI
> all we need is to inform KVM what struct pci_device * is at a vBDF and
> then KVM can do the interrupt bits. Maybe this is already happening?

> Nothing should use vendor/device ID either, it should all be drive on
> vBDF.

I appreciate the hint. I will explore the vBDF-based approach
without VFIO in the MSI path.

> I probably would not have selected this, it is why I suggested
> virtio-msi or something that could be optional and seperate from the
> core KVM guest ABI.
>
> But maybe there is interest in doing it this way?

Since there was no feedback from KVM maintainers, I will try to
follow your guidance more closely for the next version.

Thank you for your help

Best regards
Jose Ignacio

