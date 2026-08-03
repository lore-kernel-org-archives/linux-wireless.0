Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F702D7386
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769726; cv=none; b=E9d+0a607baBNOGseNJ3eqRqnAKozw6XZKzwfRPta6TMa8sjITQVR7toMdQ0Lh+h+brFmwOxjqwZVQaTOALkZCF1DCJiPHKLA3OQIMc0aJBE0zyIEv2/hZ5QYY2OXimRGoC/JBsA9uo7kQsHtWTjaSufUSeFphZv8dVd18M5juw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769726; c=relaxed/simple;
	bh=LWkOHrFhk8AsrGT8WYQGQjT9fngol3OgZMxTYxNslao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCOWxmOe2Guemhjh/Ou9Mq9ZJWiaEC8hMhPGvTF3R/DvfM97c3HNQRR0ak+nporsABL2bst+7Jctwc9+fC1j7VUM6ry2HMVNJys9iy+v7hVqlvtoO2SZytka42uZhCu9gd5JsPDsyd9avLXpEULJEgumaUbm7OA425msuJ4t4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmm6OLra; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmm6OLra"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785769724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LWkOHrFhk8AsrGT8WYQGQjT9fngol3OgZMxTYxNslao=;
	b=gmm6OLrahKK9arJ3wuu9GaSHrRgVAVbFxf+CHiJfGcAEb74XAeX6Tz6GIAjQNPMno9nO89
	D91QZGGS+i11k09wsDTPaWuPfDAn2OVpBN5184eK8OD8/bu9QpHaGox5GpaLY15/TEERM6
	3u5KShOXONa0Df+CaWjdb6//jfS+ASw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-Sx1XUb1JPaGfKfg_7MaeJg-1; Mon,
 03 Aug 2026 11:08:40 -0400
X-MC-Unique: Sx1XUb1JPaGfKfg_7MaeJg-1
X-Mimecast-MFC-AGG-ID: Sx1XUb1JPaGfKfg_7MaeJg_1785769719
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C55A195609D;
	Mon,  3 Aug 2026 15:08:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF0181956087;
	Mon,  3 Aug 2026 15:08:36 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] wifi: ath12k: prevent scan during firmware recovery
Date: Mon,  3 Aug 2026 17:08:34 +0200
Message-ID: <20260803150835.28721-1-jtornosm@redhat.com>
In-Reply-To: <81041a09-bffe-426f-a087-f6e48de93531@oss.qualcomm.com>
References: <81041a09-bffe-426f-a087-f6e48de93531@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It is reproducible by triggering a firmware crash while there is
an active connection — userspace immediately attempts a scan via
nl80211 while the firmware is still powering on through MHI.

I iwill also fix the radio[0] issue here for v2.

Thanks

Best regards
José Ignacio

