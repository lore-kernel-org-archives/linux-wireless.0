Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23795305E1F
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269040; cv=none; b=ga0gK8cKGuRRpvqL//A7Uj7qJPjysu6TqSB9VlFvDMTgSUhxa2Kso4PI3NP+xFjF5mYFJC9vDfCValxI7GMJBFv9rM6kvzMmlkCikUmDWV60/sTv9xCxkHtwiwxcWbQql+o+afOJ+NeJ+6ZQB5TyuVbDLXphkYbZIjJgqIwIONg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269040; c=relaxed/simple;
	bh=Qed+1As6Equ23uWfRUM55nbFX9LN3crl8/5w+JaGi1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbC01lz2QPcr0CgITc7GekfHo7NwcX6DOf3xcthR/u30XTzxVn5hcB2VDCJ5Xr/qew3CfstDDtKUGqu7LddM772n/IP+MIbsc7DdRHO5lgeHCyVKb5ng2g6ksv1srdKO17dCWIfO8HKg/2bJ3vn6HsNOU0Lq1iZO2WHn0aTqpPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qb2Y9BhL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qb2Y9BhL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784269038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qed+1As6Equ23uWfRUM55nbFX9LN3crl8/5w+JaGi1w=;
	b=Qb2Y9BhLlq3ZHzsAx4TMGt7sFo8pdRWEWBlkZk2BczPg0HGwo71HHBzWpuwbFP7LXOz7mO
	YofXIiCqFU8wORixLhLCC+47MF+rNj9rUEH+pjEU/I8FKmwR9wBDjxt8OcVxpJX4aEepIG
	RoUR+XBam/hpcL7x+eWYByKEE5FHW7I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-JXrbyaWgPPSASAlVLQ0sLg-1; Fri,
 17 Jul 2026 02:17:15 -0400
X-MC-Unique: JXrbyaWgPPSASAlVLQ0sLg-1
X-Mimecast-MFC-AGG-ID: JXrbyaWgPPSASAlVLQ0sLg_1784269034
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF87518007EE;
	Fri, 17 Jul 2026 06:17:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0605819560A3;
	Fri, 17 Jul 2026 06:17:09 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: tamizh.raja@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/3] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Fri, 17 Jul 2026 08:17:08 +0200
Message-ID: <20260717061708.327038-1-jtornosm@redhat.com>
In-Reply-To: <CABkEBKbcQYvMMRUmVgv+GyG8eNiot0acJ13Xy2236zqqr2cnXw@mail.gmail.com>
References: <CABkEBKbcQYvMMRUmVgv+GyG8eNiot0acJ13Xy2236zqqr2cnXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Tamizh,

Thank you for the review. You are right, I will fix this in v3.

Best regards,
Jose Ignacio

