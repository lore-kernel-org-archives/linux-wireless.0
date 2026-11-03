Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719766;
	b=YpahzD6Lk9oMQm4GV3UTZYSx0Q/zmZTvl4Y6bQvSPb1vn1z39i0v9IkQmdx1Vqa3tJ/J
	 6YHRtEkW8t5X1Ls/5IdzCYR1VbLDhaYOhzFr4CTgEERNd2gH2OiDhyspL8EVDKbnFqzHi
	 6ls+lKJk78Kk8stkfypTzLZL/s6ejQdk8KapIIqS9Bh1IpNMqxp6hPd5bcqQee6G4BeWc
	 foK7JRyE4D97dIPS88r7VzeKXsXKTfaAA8jU7GcSgKKtAZinaNph4W9xkTf0ZZeTjYPsq
	 CV0NZzMA6gEIxyUQzEUBdyayPB7TzsaPxeY92lzNbFZPq+pBmOg5p7ZDJzij2BAlxWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719766;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6EORodUkxfdkTCz/xzEQnfBa/K/Q7cbSsb1m0o63AvA=;
	b=pZ6yfJEfx3N7NZdtvXJWXY7mwP8r2WNXmxVDp+bgn4xT7T1iIM3S+7kfiN2qMPo0iRPV
	 0s4KB4hjy3NuC2bZA+ex8QoAObvwUiDQC2PDxHVzDrG1i1rrY7VdyjUSIuQTDl8ZJrWJe
	 2cQgKC79oUBM0gYseT1FdPIW2cbn45dln9b0uft1gQssJ1/YL7U1oes51/IksPsvYL4J0
	 0PeLt/7gyiIrXbYrEnNqGCl4QNnYo9jl5JkBkxpqkyzbFhgWq17Qj54gGJAKiCzoFDIm2
	 nFMjJq/i6Atxkm86wgAG6zeZSjmCuc5ZiNkaSSVif7ztIV5T64Optu8A7OPpzGXZAwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=labljQOn;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760C606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=labljQOn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=6EORodUkxfdkTCz/xzEQnfBa/K/Q7cbSsb1m0o63AvA=; t=1793719765; x=1794929365; 
	b=labljQOnDhj+ALQ3/Mp+XEUw/A8h2Ae9YI+lVhiMptzXPmeAWQ4cDo/5tPpjPg9KuJL6W59ItQs
	yNhUnsLnhB/CtTfmn3AetQJ0drG15MRiP/+zTVAEIb4jbB1r9Nc2Jg070qqaeI7R0Fnosjaznt8z/
	9Sg0evLgOafbfzTiglRbPHLoW6ZNgvXkog3was/s9+d41IChDSaKyPJwvkoVhWn/KUwJnf3pfIRXe
	83FLkXvpba7bQgH94vpSq1HK7Mj6RRU96khI0n7NpA+O4V7Mnxp1ZVHbwIhfCBG3Kr9ciWzV8dtXc
	Cluq+S21F7EE8o6XEqrhHbJuUdEQ1lk+c90g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGRv-00000003eXZ-0NTJ
	for linux-wireless@vger.kernel.org;
	Tue, 03 Nov 2026 16:29:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/4] wifi: enable context analysis
Date: Tue,  3 Nov 2026 16:29:12 +0100
Message-ID: <20261103152920.294873-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With recent rework in the kernel we lost sparse context tracking,
but gain it back by supporting it with clang 23. Do that.

Since clang can't evaluate "IS_ERR()" in the condition for locks,
this requires some refactoring in nl80211.

johannes

