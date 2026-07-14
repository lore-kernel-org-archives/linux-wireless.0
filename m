Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C654A1383
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784044770; cv=none; b=txaBgwerZHwrEAJU84HU5wx6TK5geaWmkbrYnGzdSGvOo4CT7Bpx5hKMneOhLvYCHAQ6bzI18dYS7DsMvcGVfbFd5gGPKAowdZeXX8ifdoUhZ6nTRjxGwb0AdSmPlmJT7PBJ8S+J5xfBZI4dV5JzbMUa+QSqQY7DL7nnAVESEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784044770; c=relaxed/simple;
	bh=1dh24pC1RhR3jWKl6U9WnLTqhHEZRr0wAavb5R/xV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pixeSCbn1pV/+V5oGYJcF1II+vDluGVHk4wPezVJy+pwFQa0yI3ioupLHOm6NaO2YC5IGPulYx3/32Spyh6kLEWkBK94G0PR2EOM3MLTYHyEKCTag94JOO8q87UWoPfsHGIS/mr45jpvHj6DQbMEF6fCx5qL28DuLYUKLti3bQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9M52B1w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9M52B1w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784044767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1dh24pC1RhR3jWKl6U9WnLTqhHEZRr0wAavb5R/xV1A=;
	b=H9M52B1wvU4aOP4ygFlvRiticGZqQnvUCrxNumfPg1EB12WBg9PJbjkHHrMlRkd+xE2E32
	qh9QjdSCmGbd2EPeAUkQARuCoZsm2Dj5TVcpdM8ovHbKHTYDpOAVA6EP9DlBV7Iaqd99aG
	+fHK7KKbfQgiGgWdjdz4EN2teUBYk4E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-lxA7Vp8lMY6uXLc4DMMmaQ-1; Tue,
 14 Jul 2026 11:59:24 -0400
X-MC-Unique: lxA7Vp8lMY6uXLc4DMMmaQ-1
X-Mimecast-MFC-AGG-ID: lxA7Vp8lMY6uXLc4DMMmaQ_1784044763
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F02AE180059A;
	Tue, 14 Jul 2026 15:59:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.50])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC426195608C;
	Tue, 14 Jul 2026 15:59:18 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Tue, 14 Jul 2026 17:59:16 +0200
Message-ID: <20260714155916.663864-1-jtornosm@redhat.com>
In-Reply-To: <2b5dfc9a-d2fc-4396-a004-4d3dbe30b408@oss.qualcomm.com>
References: <2b5dfc9a-d2fc-4396-a004-4d3dbe30b408@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Jeff

Thank you for your feedback and for routing to the team.
I will try to ensure the approach fits all the ath12k datapath requirements.


Best regards,
Jose Ignacio

