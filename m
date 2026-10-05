Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4F447A898
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197309; cv=none; b=tFo3u6jCc9lgV8Opvc5UttwCyjog311+XfMgE6OdQgSHtxPGRgH9NlxLxj5kQXEaRr0bdAOnqtL7nUuKLuJK+cCatJuf0cJXtHdF3T1CTIGLpfCN08hsgfPM8XAu1G4SIIqEPuaZgz7kO6IBrBrj7HPlfPu0lnpczeXhnLoTfgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197309; c=relaxed/simple;
	bh=jR9p+VjROivHPCcQOHzYwQJDmbJUOUEqe/SJl79LCD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1K51x50/CMPiZZdBVZF8U4wpoYChJ3n/zXJkLT+tCcR9SkYMWP8EFLksZ6tCR1HQk/UdE4+YM9WqG8f/hMUUOmSvvlVwkR7jPeZjqDs/nge9p7JPg80T06jwLcWl7LK4uMHfqgcGs/K7pb3i2t4xyutWl/Ge6GOg1Ks9Kyzn9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XU6S7Ct6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XU6S7Ct6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791197307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jR9p+VjROivHPCcQOHzYwQJDmbJUOUEqe/SJl79LCD8=;
	b=XU6S7Ct6eYpZB8Lb5/RdK3ZYNnnsx+R+tfBkOR2CKyJ4NLB5PQPA7Slkj/zF2s3mcyrKOe
	0RgQCpw5HUUYvI1tgZkOlTN2dB/5qCMMbkLElocvbT7rLfIrXkjqTQOcl+Y3CJC5F4dzlV
	5MT3SYo+gRtIZ1LSX1fsIRmlJSAIIBw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-pb7Iyv_NOo2UQC-rFUkeSg-1; Mon,
 05 Oct 2026 06:48:22 -0400
X-MC-Unique: pb7Iyv_NOo2UQC-rFUkeSg-1
X-Mimecast-MFC-AGG-ID: pb7Iyv_NOo2UQC-rFUkeSg_1791197301
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E1C11955F6F;
	Mon,  5 Oct 2026 10:48:20 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF3521800446;
	Mon,  5 Oct 2026 10:48:15 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: helgaas@kernel.org
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jgg@ziepe.ca,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org
Subject: Re: [PATCH v14 0/2] PCI: Add device-specific reset for Qualcomm devices
Date: Mon,  5 Oct 2026 12:48:11 +0200
Message-ID: <20261005104814.77479-1-jtornosm@redhat.com>
In-Reply-To: <20261002234749.GA411439@bhelgaas>
References: <20261002234749.GA411439@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Thanks Bjorn for the feedback, and thanks Alex for the Acked-by.

I'll send v15 with the commit messages updated as suggested,
emphasizing isolation and referencing 6a4f64c3a3ad.

Best regards
José Ignacio

