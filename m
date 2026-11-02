Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631530;
	b=013hg72sNDBoAQvdPomvFXvvJPNZukdj1TcD5723jCCSUPox1I0vaouSvS0Nz2jbWaua
	 lW1VbNflnbQQLAyu+Rw+P9f759O76X0aaXcjiRwBKRYFq+BS5gm2oy9QS2SOhxSh97Ug1
	 Lsy3ExfBhg17ASVSjOLBoxFmzwgkcFAykrhAR0rkd6wjvBjugEDD3inmv5R6+nephNGH8
	 kjuLOiuherUp0Gsl31WAEdAif+YjR3cSJz5ZkpPh/pCs2RHemwNEMrtUZ9dVbVq+jgE0p
	 EVEDg0vJQql/dkaHB4YHbtcdAdugRhN1rJuekiCV2VO8g2SPcAa5fYUlQEt6BKJ92nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=BGZaLVl/bf+VQNDSvC9YaFRzMNQ+JkOw52QT0TU0FxI=;
	b=wqkzlqzSrpv+lysLf1JN10uoqLhyucll9Z7KWHPG+M8bl3otyQuxdqHH3n7iQICnfsBu
	 yCJ7raiv3TfXkhiWION+CtHo1NPJ5dvNf8G6ZqKm/609uqg0r0EeFROqelmzDcy6VK6XP
	 5+gIx4X9feDzjyzUejFocxi0G3cxeddloi8gl/9Rx7+umdY9V2wzkNjqAXtWlAzfup2UT
	 OIERcL4YmFL2tZHoRhk8cTHZ6ZAOgNV7rnI5AtMxWk9elaV4NKKnjCr8ebKbDEa8Z4gdx
	 ep3Htzk2WaH9pbVrhulYJG84ptl+tEq+dIeZPZkU1+khB5IOYlbj4bjQp8aUvoZTwXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TZywBXE3;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8E4606C3D5
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 14:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C8E4606C3D5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TZywBXE3
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea0fe07201so19379915ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793631529; x=1794236329; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BGZaLVl/bf+VQNDSvC9YaFRzMNQ+JkOw52QT0TU0FxI=;
        b=TZywBXE3oo1AuLBH7fBdMETQ/ZJUgYCO5nOgYZhMM2/RSWMHeOnBsVWpkN2kAt7KvD
         74dzAt9PIPbwp/6+RUsGUMXtWVUoMV3MdAigrrJIZiU/oT21l+cUq8atuQ+RAalmSlHk
         g3RJ7DyQkTdkIAvVBxgZUe0Sz810/Xb582RtJwJCvscY3ni5bJfSTeCbvv+C4vp62UV3
         an0957++A+LpFnNFNacx9MYI7lnZMrH8MOcXyiWyZ5j8n9FueDIB/nvRaAJodCsoUOg1
         oMXcKKC21ctT7VDibGCwQcUAZ00IKICYtJZusuhXMeMnt4qTZRFqLClfq3HFOkmznWQ7
         q4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793631529; x=1794236329;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BGZaLVl/bf+VQNDSvC9YaFRzMNQ+JkOw52QT0TU0FxI=;
        b=MHre9hnxCfMf2C28l+3P3D+zvQcxoIC4AdGqeCdug5DUldQWDecM4VCgP/TXmrIfzF
         u44If1Y/6rCZRE6ofb6uSCja1j8ZW1cUk+Yw7VgMnT8Mce4W72wAdFGj2G0zGuEHMwdO
         wLDutZBTO8QQyDTM4LfJTHUFBP8JrQofLVczTeimKsZ2Sj/JBFHqX072QqaVm+5h+GIU
         BD8rIAEPxD/pjgUz+F2clKpUdIf6NioMrIFId5OlsxY8ZMkFSgceQiBryloRDxeJ1/K7
         TYWXQzhtIzyYZkRB5PQI/Qdw6vRo+Ck/VvtYB8GC8DRrd/fZG5ErABGfGXorIdIsmmHC
         ypCg==
X-Forwarded-Encrypted: i=1; AKwUvBwRYf/160NBwdQpxF0if3ELvUieR77LSRYMtrwzAsMLzKtFCobHg9mIo0UiPhwGiRg9dW8A/VLGBmWvtkvsdQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+0TuMN9MXAShZsv+ad6EAJ7bs+SpY791pK9CQvEdLP+a7ESywh
	c5t1lYpsWrbzUT+O09Wefm9PJYUCDViVz0sMkkzTmNp4unqaBmKLAsJk1x60TJ4/R6EzpmkHs9B
	0HhZ5cg==
X-Received: from plnl5.prod.google.com ([2002:a17:902:fd85:b0:2ea:44fa:2c44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f691:b0:2e2:d39f:182f
 with SMTP id d9443c01a7336-2eb3643d489mr99134825ad.28.1793631529137; Mon, 02
 Nov 2026 06:58:49 -0800 (PST)
Date: Mon, 2 Nov 2026 06:58:48 -0800
In-Reply-To: <20261102074657.27715-1-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029165845.GQ1685504@ziepe.ca> <20261102074657.27715-1-jtornosm@redhat.com>
Message-ID: <auilKFwKLjw-BnZM@google.com>
Subject: Re: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
From: Sean Christopherson <seanjc@google.com>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jgg@ziepe.ca, alex@shazbot.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, bhelgaas@google.com, jjohnson@kernel.org, 
	johannes@sipsolutions.net, kevin.tian@intel.com, kvm@vger.kernel.org, 
	kwilczynski@kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org, 
	lpieralisi@kernel.org, mani@kernel.org, pbonzini@redhat.com, robh@kernel.org, 
	vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 02, 2026, Jose Ignacio Tornos Martinez wrote:
> > I probably would not have selected this, it is why I suggested
> > virtio-msi or something that could be optional and seperate from the
> > core KVM guest ABI.
> >
> > But maybe there is interest in doing it this way?
> 
> Since there was no feedback from KVM maintainers,

NAK to adding any KVM-handled hypercall, and probably NAK to any approach that
requires KVM changes.

With regard to timing, please show a little patience and awareness.  It's Monday.
You posted a fairly large series on a Thursday, during a merge window.  If you
change direction after ~2 days for a series of this natures (touchs multiple
subsystems and introduces guest/host ABI), you're likely going to end up with
severe whiplash.
