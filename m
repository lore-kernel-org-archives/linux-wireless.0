Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FD54137BC
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769978; cv=none; b=ZneuAfUQKrN70XQE/RkarMsi8UH52MTxm0Kyl8edFVEo1bYLWatHETEjtS5KRcUpTM5UYGBOvGXfSZd7x3vFYny1REyEoUNxzlQvhSNwauo9AW5B279AOmyPcDCv93vKyW/+6oUTEtXyQ0a/RQ8WDVNkb7Szh8M+Gt45fbnGlvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769978; c=relaxed/simple;
	bh=rk0+6ARBqcP9auye9CJ7PQZYSy+uWfnEwN1ENbN5FxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mwrMLDu/Kzp0qf08JvGSvvKNdu/Sq5ikksgr91+WPgOpNUeXr+881YCR9waPS0gXdxEjZnJz2ysJAT1M/dk7N5jEc1ZGYNvw9hR902tyr6LdiW4rcrLaD8AsYpthltHMdluhy80Kf0X5RWbBB1HGV1/jmjfLwWeh2CXIz51Pf3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkPcUAkF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkPcUAkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785769976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rk0+6ARBqcP9auye9CJ7PQZYSy+uWfnEwN1ENbN5FxA=;
	b=BkPcUAkFooP9k756tduIC3OdJpSDSGPC2fB19c9UMdigKyr2rakAcaD54iDOpRZWYykYPh
	wW16+42fHKJ8ydv43gPyaofZoC2eIPvH/nnCTG0pnoPG2Fw5K0H1Xq9AvOJShek+ZSd7OS
	w+duUJ/R9XmrF7kJG87IT9rd0Q6TvHQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-dhasU5nhPTWKT7lp6M0ttw-1; Mon,
 03 Aug 2026 11:12:51 -0400
X-MC-Unique: dhasU5nhPTWKT7lp6M0ttw-1
X-Mimecast-MFC-AGG-ID: dhasU5nhPTWKT7lp6M0ttw_1785769969
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509DC1956046;
	Mon,  3 Aug 2026 15:12:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E8276195608E;
	Mon,  3 Aug 2026 15:12:46 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] wifi: ath12k: fix MLO dp_peer ID desync with firmware
Date: Mon,  3 Aug 2026 17:12:44 +0200
Message-ID: <20260803151245.28946-1-jtornosm@redhat.com>
In-Reply-To: <f7e90024-df8e-4fad-ad42-864c092a56d2@oss.qualcomm.com>
References: <f7e90024-df8e-4fad-ad42-864c092a56d2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Thanks for the pointer. I will test with the fix from [1] on
ath/main and drop this patch in v2 if it fixes the problem
reported here too.

[1] https://lore.kernel.org/ath12k/20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com/

Thanks

Best regards
José Ignacio

