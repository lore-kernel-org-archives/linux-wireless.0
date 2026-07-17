Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB4B3612CF
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269123; cv=none; b=bkezuiFqjSCjjI/FwzX/gbJ+068ewGeN0a2AWtLPOy8WZYsSPHdben7GHxPMlqYlr4S/NaqqKeXmEaw4+DuMu4CJk5cfHfd3X196nv7BRNtjuzordg3E1TX+Og2tqVy9jHriIfpz+BKq2pZsORmtXQ9JLonvGRkxwMdY3xeh5qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269123; c=relaxed/simple;
	bh=Qed+1As6Equ23uWfRUM55nbFX9LN3crl8/5w+JaGi1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coACJFUgSv0vIYiGeZBqSK1ieCnM6tBwySNMgoCRCZd1F8JO7m1ubbCasejxSbOloGbr+6pwu62stZ/6ODW6lDkUjc8DsBIVcbCuAMdpRZ5S/Te0gjhQsvxeAzslKHgqYbfrJ8XRBLayN8gEqgoR92X42JriOVu/R1UhrYDYLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYYPZiuJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYYPZiuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784269117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qed+1As6Equ23uWfRUM55nbFX9LN3crl8/5w+JaGi1w=;
	b=TYYPZiuJJQefYyFzd4QYgbf5AUAipZRrewTc29EHU4KlPTzP5qG1qB/Do8vhbSgZIxkje4
	MzDgK+Drf+Tc8MF5jro8B6DuMd9HKhVvY5qZtGPki4DuDaHL0MPEC568/FC/Cy8deQAqmf
	bwueBTbJe8hlFD2f4qyF75R79znk3Ns=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-vzKCaRkgNuCMbvJRa-iPZA-1; Fri,
 17 Jul 2026 02:18:32 -0400
X-MC-Unique: vzKCaRkgNuCMbvJRa-iPZA-1
X-Mimecast-MFC-AGG-ID: vzKCaRkgNuCMbvJRa-iPZA_1784269111
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CE6E18005A9;
	Fri, 17 Jul 2026 06:18:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8372C3004082;
	Fri, 17 Jul 2026 06:18:27 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: tamizh.raja@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Fri, 17 Jul 2026 08:18:25 +0200
Message-ID: <20260717061825.327097-1-jtornosm@redhat.com>
In-Reply-To: <CABkEBKa26vR52mX85t4xuZbrXz0FiRc0O_NeDFSNAQpSx=RR7g@mail.gmail.com>
References: <CABkEBKa26vR52mX85t4xuZbrXz0FiRc0O_NeDFSNAQpSx=RR7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Tamizh,

Thank you for the review. You are right, I will fix this in v3.

Best regards,
Jose Ignacio

