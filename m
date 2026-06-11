Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25C7364EB2
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2026 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163013; cv=none; b=FkxgxZu+pR7zuD8Q0ZCmJ4gCixDIrFQaI4pAR4RuX1OFVHTBTKU8cLEy6HLxENBXdEXz4EEriFrl+BQY//k1Ffgzzk4yc0mfSjeuhNdfFPn5USREZUmeS4yezN50LAkDmamlor3UjQ/x6KZ1dm+AuNW3yv5Wgwd3glqBuZED0bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163013; c=relaxed/simple;
	bh=xufJC7/cvAmigCIamDa2w5Kt01W8fLKzWT3UauXNpi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0dGS49o8KUiMdLdcTMxCIhezd5TqQ0dMgfu/cbF4hoIPVbX0gJcLGMIlw5Mu3bmgdb0P1mwqOFZ0ENuS2pyH+N8BT7a6KeU1vsWDbYOcenOR0DYXmaviJIe0rGr8iSdqGPzzYhHNcShT9Gd6AKjkYc9GPxFoHdJt/GIBts0PXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XTkAzPJz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTkAzPJz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781163011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kuw0J3g45Skc3QfhRqB7uACn5uzzyF7cYO293roxvqI=;
	b=XTkAzPJzR7Dp9oGaNtF0LfYQPtReG7ats0H355AdYGGiX2RSklEA8raPEL+Cv03NAJOokh
	mTNU1pPEYeCxpoO0cQ6R2i22A/mlh3moINENxviE4XxMn9eBdz9SubGZGd6ECXArdBVUih
	Nd0LEu+GqhBG13PAd02+rvCxiFqFnOc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-kKtD1rzIMJGQH5L-LcWCpQ-1; Thu,
 11 Jun 2026 03:30:05 -0400
X-MC-Unique: kKtD1rzIMJGQH5L-LcWCpQ-1
X-Mimecast-MFC-AGG-ID: kKtD1rzIMJGQH5L-LcWCpQ_1781163004
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36451800378;
	Thu, 11 Jun 2026 07:30:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C97B30001A1;
	Thu, 11 Jun 2026 07:29:57 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: alex@shazbot.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	mhi@lists.linux.dev
Subject: Re: [PATCH v8 2/3] PCI: Add device-specific reset for Qualcomm devices
Date: Thu, 11 Jun 2026 09:29:56 +0200
Message-ID: <20260611072956.22448-1-jtornosm@redhat.com>
In-Reply-To: <20260610131517.6d7bd63a@shazbot.org>
References: <20260610131517.6d7bd63a@shazbot.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Alex,

> This seems to suggest that the D3cold reset method is also untested...
> I'd suggest dropping the D3cold throughout, unless you can get someone
> to volunteer to test it. It seems like you really just want this quirk
> to do a D3hot regardless of NoSoftRst+ with a select set of devices
> where it appears to do more than nothing, where doing nothing is
> effectively what's left after the other reset methods are being quirked
> off for being worse than nothing.  Thanks,

Agreed, I don't have access to hardware with _PR3 support to install the
Qualcomm devices - all my testing for these has been on platforms without
_PR3 (desktop M.2 adapters).  
I'll drop the general d3cold infrastructure (patch 1/3) entirely and simplify
patch 2/3 to just a D3hot-only device-specific reset for the specific Qualcomm
devices where testing shows it works despite NoSoftRst+.
  
v9 coming soon.

Thanks,

Best regards
Jose Ignacio

