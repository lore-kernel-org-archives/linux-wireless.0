Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71894235C01
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2026 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219412; cv=none; b=sQpl+vBYPAv+Z1YXvTrKRLaB3R0IHHOMwn5ysVH5oq05aBQKAPiCmJQnCkGXeDlQix+xf2VsbEpi34a44cE7lxr479y01DxFHclAF16jpG/O12UDrBMNeYlcPkGXmdZl3+EPK3PwRDGCYWqnLwyoMx0GVZi6ETIJo/N2Tv4mYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219412; c=relaxed/simple;
	bh=DT3BfKR3AXFYmo7yS7ELpC/WeLp4nOFohzAkP1KTUJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cklO6m7RQOEUYle8KUqDu6elEHmIvNNNNQxlqmOx1H4KqasF5bqatMT4jebN9tDfPOymUmEWepK41Pjmf9gxOn3x9NFFT7MXI/4AUCNpR5IOumNfchQlBdqPafg6oEy6WYEN3XxXuF3ZkMvgwn8C5st/BEU8h3YJz+DWwMAaIVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OSWxLKbq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSWxLKbq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782219410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6OViMVvFs1Rdaduz4uN6EcMeVo/mRomtYu9z3RnglZk=;
	b=OSWxLKbqWuWsaQyR05o8vq0wQdaqyXoqD2bIfwIzDYJD08CsUW9Y4+ynpbL86eEbEKXf9f
	Nuk4Ifykt5MYmeKeOR1mVv2zINAxFjmIcU9jwwcM+wUl++/zfrotER7/pf/QGSQASxV7Rx
	Ifz7emQe4bv4RES7nukjGIuep5L22ys=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-taBlM7F5OqCiYqbK9DozoA-1; Tue,
 23 Jun 2026 08:56:46 -0400
X-MC-Unique: taBlM7F5OqCiYqbK9DozoA-1
X-Mimecast-MFC-AGG-ID: taBlM7F5OqCiYqbK9DozoA_1782219404
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 295321956075;
	Tue, 23 Jun 2026 12:56:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B71551800598;
	Tue, 23 Jun 2026 12:56:38 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: mani@kernel.org
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mhi@lists.linux.dev
Subject: Re: [PATCH v9] PCI: Add device-specific reset for Qualcomm devices
Date: Tue, 23 Jun 2026 14:56:35 +0200
Message-ID: <20260623125637.1188867-1-jtornosm@redhat.com>
In-Reply-To: <r4jeqtx247iosfjdps6g4fqwtsdzine5qlgh33sdt4p6ktmaln@o725aolrpj4l>
References: <r4jeqtx247iosfjdps6g4fqwtsdzine5qlgh33sdt4p6ktmaln@o725aolrpj4l>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Mani and Alex,

Thank you both for the guidance. 


I think your insight about the BAR-space reset mechanisms is a much better
approach to have a "real" reset. With that, I've implemented device-specific
reset functions based on the driver code Mani referenced:

WCN6855/WCN7850 WiFi (reset_qualcomm_wifi):
- Uses SoC global reset via BAR0 offset 0x3008
- Follows the sequence from ath11k_pci_soc_global_reset() /
  ath12k_pci_soc_global_reset() / ath11k_pci_sw_reset()
- Set reset bit → 10ms delay → clear reset bit → 10ms delay → verify link
  recovery (up to 5s)
- Includes MHI controller reset cleanup (offset 0x38) to clear SYSERR after SoC
  reset
- Both WCN6855 and WCN7850 share identical register offsets and reset sequence

SDX62/SDX65 modems (reset_qualcomm_modem):
- Uses MHI SoC reset via BAR0 offset 0xb0
- Follows the sequence from mhi_soc_reset() / mhi_pci_reset_prepare()
- Write reset request → 2s delay for reset completion

All implementations follow Alex's pattern: save command register ->
enable memory decode -> ioremap BAR -> perform reset sequence ->
iounmap -> restore command.
Testing results: The implementation shows successful reset behavior for both
WiFi and modem devices in VFIO passthrough scenarios.


Regarding the approach (quirks.c vs dedicated VFIO driver):

Mani, I understand your concern about potential conflicts with the native
drivers. I want to make sure I implement this correctly. Could you clarify
when you envision the conflict occurring? 
From what I can see, the native drivers call their reset functions directly
without using pci_try_reset_function(), so the device-specific reset in
quirks.c could be enough, but I may be missing some error recovery paths or
other scenarios.

Alex, Mani - would you prefer a dedicated VFIO PCI variant driver (similar
to mlx5-vfio-pci) to ensure the reset logic only runs in VFIO scenarios, or
is the quirks.c approach acceptable? I can implement either approach.

With the decision I will send v10.


Thank you again for all your help

Best regards
José Ignacio

