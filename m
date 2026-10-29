Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293247;
	b=kVDD/VAFUeo3sOrVqD4ZpNgxZHoZyHk+KmwFDDXtN++l+ZCHOPQnIHezUGz1/WsKyZP+
	 r5ejmTfey9L5QsEq5HLvjoW4gV9eemryPtUD/QM/tMYhDQZGqn0zTcLdYyjUjP6taMJcD
	 sY7kjZAvBpK2pr12nIxL7zK6AzP8upB62KplTZL2LUquYrDiqaiaR8FAvEre+MemYn1r7
	 tK+En21MD4XTQUTGGk5fpmTiG7cPySqDZfFU+O21gohuf6jpyok4B++2o4rPl0yYPGiqF
	 YbSo2TbjoXb62/ajGYRk8NXr1seHoPEg73Zth2Dd+IVuTGlpwpLFqh24zJAvWcADpjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ZD/qDGi1O6nHsAaexh1x5wdETQZTzQoYlRWPgZIsXpY=;
	b=2AiUnS1FZmwEnECoULIS8x4Wq7VB28RVTMcek+HTjzS+keX1zYM5rMI8iZRbZ6Cf8CFB
	 L3jyn4A0MPp2UvHwQGr5DpsL10J/83Jdt3ITTcWmcuHL8eJQH/F5mYiy9GFyEddYo9w6q
	 iS4ZVIr7Ig9BrsoNvgKDswQYo7QO9urMAlyVi29Ept+3KiWU6ltm3DgnuaCUMZNaCJj9p
	 8qcRGK7KD/sRxc5tfGu9QSvK1sRH9celqMw/u8Bf2YTuFCKZECo7aOFSUJCX0ZnI461zK
	 jmeuqJhZdaZnWjFdgJdZZOgCFoqDTLaMCgrlfoegWysSVd5AcIgaYvmQXwIj1sH7iWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="P/ryviEr";
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F872606A321
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 17:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F872606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=P/ryviEr
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c75267b0fso26709646d6.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793293246; x=1793898046; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZD/qDGi1O6nHsAaexh1x5wdETQZTzQoYlRWPgZIsXpY=;
        b=P/ryviErdiPh42kReFxkMw1q1mH9fz9TsFFVhDr7/C5Fa2PSoxZUA9NuSEwkEuOkDH
         fNZeVoONCuCJO6q9+z+VTVZWbo0t4PQAZZQbmnCCao5RytIfbF7qM4u0UGfrh8SXqE5C
         1Oy++8U8wu01GKb+uUKj/3+Vr18qQiyVTGVonel5fUq452tyDa7V3ank6XovkMgPdMz1
         b4mfXcw4lUP07SJ9XOoL+xDmONdFYgfmQzR+4w8bOdy6pmffsNZIdJApXGGJQO3JrUXL
         yXzp8LM+iVAhhqSPhoFCJc5loCUVs6wj2cMaSUauBqxFa4vtTkEvYVcrRZ93WpEPiEEE
         wK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293246; x=1793898046;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZD/qDGi1O6nHsAaexh1x5wdETQZTzQoYlRWPgZIsXpY=;
        b=KN13mHEZJzP3Rp6kbjfF4gOSK4S3OZguF1+tv20xW4t7s5ewrl1gUIYHoX7LfohzHg
         4FG0ZbuRKyfIR0cyQcAnylP6dwhgiTyqoPmM0S3Pu4fOaWTB4A4l7TPcX8nCczqE7Q7Q
         /+21469+K3n0OtxuyYeo60mgufWhyxg04POO3R1XgHZ/zMFOMu/ufdT8iJwUx8TdY4RS
         YVbUMKBeWOfYX3khQmhLwwx9Fd6E8MBDRT501LC1ICLtjNc7X8Q6tdIT6ZkG2AbsM0mb
         /p+1nlPGWzEm7gtD5fd+XQZFM3tcTbNqaatEKSDtNS/QKwkOwlYS1dGaM8+uJMG91Wi9
         anqg==
X-Forwarded-Encrypted: i=1; AKwUvBw9EkHUdcZwuK8asLnipZsq7lYs31fbQpTtl109NUX2K8wP9W+T0mtCSSLLR80Vblb7mJXs7Sh9xGJRZot+dw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJpzBB+LFg1V4HFa2svgkB1AAXPgzbQdmIMQ2Aipf9dDMDMlXS5
	B1hr/HdqJVMNK2fBUmTPfTBe96Zpkx0B/6FkdRyGgCUB0gliufHYPUiHU5WjMwjQVXg=
X-Gm-Gg: AYBFou0Ej0voZcy1dZrh7KHpsFazK+CybSyE8W0YA+rm9nAOOBxK7jspymlu1YrJ+h1
	Kp6iUbjxJ1nZkX+MqH8qX2owKg7oE6b7+70Ji1rCXwCd0uSBFvqJO54ic6EvEcIS8zCiA8sEUwe
	ytUEbqbeNyYZWaRq/tcQ19FPK2cQIkRHmHPKk3Ms+m+yD022Rb+XI66fhZb/ht9ggqNypt81AtM
	UFSN+bYqatd12b6XzaUw5+eKQ6mUt89j42g8sQtD1H+bT3j0xhPjxUIgyhjpTRUjoxmJVTzIIXu
	b9nbxEHiongiIZAl7g1E3j6qxyYnSnoa4s1zAFFy3C8QawyIfJgJfDp7CBowE0u2fQFOoPYbM7m
	CA7dTM0UHI7/ctc+pwr0Fc0Uyb4VcjFqg05ZcS/gRn4AEqzeHOS7droXim6T6ThYDfqivRRmMXx
	XUi9S+Vy6cfzw/jt0JGzbG81Rj0TgP2CHa42RywEpqXL4NieHr27wNBso1S867y2GjG2Km9T6H8
	cayAK/QxVeQvrF1DzOoEvzp2/fr81rIgDBaXrf7s4DP4iS/ZUkHk0fqfPRtnyN137xcjPVFy48j
	PKbgnz+DVzVj2qTUz3PrrJbUaXwhjoQMFi/6MDBppo+xkDMKxTtndurkIUBJTAOlYtKsDKHeWwU
	oVbYLRDgBCDM=
X-Received: by 2002:a05:6214:3a87:b0:91c:6e6a:f1ad with SMTP id 6a1803df08f44-91c7cb836c2mr100048286d6.0.1793293245829;
        Thu, 29 Oct 2026 10:00:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca317a421sm870346d6.44.2026.10.29.10.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 10:00:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMTUa-0000000G37w-2g1i;
	Thu, 29 Oct 2026 14:00:44 -0300
Date: Thu, 29 Oct 2026 14:00:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, pbonzini@redhat.com, seanjc@google.com,
	bhelgaas@google.com, jjohnson@kernel.org, johannes@sipsolutions.net,
	mani@kernel.org, lpieralisi@kernel.org, kwilczynski@kernel.org,
	robh@kernel.org, vkuznets@redhat.com, kevin.tian@intel.com,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] ath11k: use KVM MSI domain for VM passthrough
Message-ID: <20261029170044.GR1685504@ziepe.ca>
References: <20261029163713.1366077-1-jtornosm@redhat.com>
 <20261029163713.1366077-6-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029163713.1366077-6-jtornosm@redhat.com>

On Thu, Oct 29, 2026 at 05:37:10PM +0100, Jose Ignacio Tornos Martinez wrote:
> @@ -855,6 +858,13 @@ static int ath11k_pci_power_up(struct ath11k_base *ab)
>  
>  	ath11k_pci_msi_enable(ab_pci);
>  
> +#if IS_ENABLED(CONFIG_PCI_KVM_MSI_DOMAIN)
> +	if (kvm_pci_msi_wait_ready(ab_pci->pdev, 500) > 0)
> +		kvm_pci_msi_get_address(ab_pci->pdev, &ab->pci.msi.addr_lo,
> +					&ab->pci.msi.addr_hi,
> +					&ab->pci.msi.ep_base_data);
> +#endif

This connection should be done through ACPI somehow, and I think
Thomas would expect this to be modeled on the platform msi domain,
just ported to PCI instead of this.

Jason
