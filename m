Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59D230BE9
	for <linux-wireless@vger.kernel.org>; Fri,  8 May 2026 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778236335; cv=none; b=FT35fGaAnS1PREEoVXo4q7GY6Wzz0qimmkTcbQ/gFML9pZcnJQSHloEVoYHs8bd97IwQTt2I2x6ZaxLNjbHKCFO3Ljbdv8uePKjs5KjKfId/59zPgxSXJOT2hgQsggUKCJjWIdHU+TSxpdeP1t1wm6ArFpGXUY/CUmeoiPq6n14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778236335; c=relaxed/simple;
	bh=YP/7ci/J9TJ5edW5yKTAQPEPG3mpePlkU70HrqxFuPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPRVuwTy+DZ5Ne0ZE5twTHhoC5e1OvzE1tt/0eSHZwGvsX30aoLHdo8rIZXMNX1xip8kshPCrPLrbjmHBQTvtYnqQOlZV/o4pHcnaCZGr1nP49wz489Wjt1HLADykeM0i3FCXdu0DrKcV+F+ZXaQyh31IsSuQqbyg0Pjz4SLiKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RB8VKNk+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RB8VKNk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778236332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YP/7ci/J9TJ5edW5yKTAQPEPG3mpePlkU70HrqxFuPU=;
	b=RB8VKNk+LlVDWKnc+A1OcMSpDilhGfSIEQ4Jd5mjExrVpfrV3c0IKKePsiIGFU/OLi8OKA
	Ll8hQ+YsvDx//tPmXLfd/zpULOvdX3giI87VMC0EzHktpk4RSgqYFWgoY0MPstAnqMg71c
	TN/s+0uTqzGFp4epvilj39OjgY9Jjgc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-J-Ot9qY_PMag7huwB8KdpA-1; Fri,
 08 May 2026 06:32:09 -0400
X-MC-Unique: J-Ot9qY_PMag7huwB8KdpA-1
X-Mimecast-MFC-AGG-ID: J-Ot9qY_PMag7huwB8KdpA_1778236328
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E05F9195609D;
	Fri,  8 May 2026 10:32:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E0F3300019F;
	Fri,  8 May 2026 10:32:04 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: rameshkumar.sundaram@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: fix warning when unbinding
Date: Fri,  8 May 2026 12:31:59 +0200
Message-ID: <20260508103202.456865-1-jtornosm@redhat.com>
In-Reply-To: <336655c6-4dac-46e9-a783-549f0a9cccea@oss.qualcomm.com>
References: <336655c6-4dac-46e9-a783-549f0a9cccea@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Rameshkumar,

> What is the exact failure? Do you see any driver error logs when it occurs?
No error log, just the warning.

> Got it. I was just thinking along with the proposed fix — whether we
> might also need to handle the sequencing on QMI failure.
> In other words, do you think the issue(double free) would still be
> reproducible if we include a change like below ?
Yes, I think so and in addition the code is more robust.

There is no need to handle other stuff, the device can be bound again with
no problem.

Thanks

Best regards
José Ignacio

