Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6DD35C699
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 06:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789626792; cv=none; b=L7396Wr0bo+BjN7U2QIs/rgRCNtrG4El7J3iqUToXLxdXDlgZ3F96nOU+APu8ktKj4PWJDE6udMQF2rs2qdChJimLKRI17AKQYaplbCGeaWgfRVZZSRNEynfiHlrhTcjXd4C2IY5ZZSPMueoNf83F+zgG/xpJwp1YoatF/VxNBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789626792; c=relaxed/simple;
	bh=G3gh9xfQo/aWe9NTkMuu8d6h2PqoLGornjU7sCJIkzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRdR3JVAdmiOiVJcOyelSy93m+5XieBzzHRXhds88VD2i9c1YrrhPOU5+8NhLJ8pUVgYBJA4Z3+5RSs3jTQ4iwmRqJVta/pzE69kVBiWuOXN4PQX8rzXQA8Uimq9pyR3wWvxAVME+Xaf2oEWce7+RkDerNb+SoJpiJ4P9bk9Q1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeViNHEr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeViNHEr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789626789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3gh9xfQo/aWe9NTkMuu8d6h2PqoLGornjU7sCJIkzs=;
	b=KeViNHEripFVHD7XcyHKB8jzo8AVTDKkDLe6A58MEaY+MCZEHdaZatpqWODWMVefDEu27+
	TnCcAQjgVoWRLFg6hj1ZQS/2EKn3eiVEqexgG7NnFZ3vzkO+/wHskjxrVxbtSXCBMgJHFv
	ZwTvU0SfxIAETbpDCp270LKH6MTdYLI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-tlbqaWevOFyFAdsXmJOHNA-1; Thu,
 17 Sep 2026 02:33:04 -0400
X-MC-Unique: tlbqaWevOFyFAdsXmJOHNA-1
X-Mimecast-MFC-AGG-ID: tlbqaWevOFyFAdsXmJOHNA_1789626782
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 589DD19541A0;
	Thu, 17 Sep 2026 06:33:02 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ECB661800352;
	Thu, 17 Sep 2026 06:32:59 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Thu, 17 Sep 2026 08:32:57 +0200
Message-ID: <20260917063258.11886-1-jtornosm@redhat.com>
In-Reply-To: <170a200e-f0fc-4e8f-a7c6-72294beb185a@oss.qualcomm.com>
References: <170a200e-f0fc-4e8f-a7c6-72294beb185a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Jeff,

Sorry for the late reply, I was on leave as noted in the v6 cover letter.

> Yes, but if that outer spinlock is ever removed, the inner spinlock would no
> longer be correct. So the defensive pattern is to use _bh in both places, and
> both of my AI review agents concur with this practice.
Ok, changed to spin_lock_bh() in both ath11k and ath12k for v7.

Thanks

Best regards
José Ignacio

