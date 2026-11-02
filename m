Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663769;
	b=f69guyHcI1rPAz+EsFosi0cnUV4xZsjuRcWmFBxvUoDtSQ1Lhu92d+NUn0IK3KpqrgmU
	 iDkjb6VTQpHb7Hz0rppuZ0OE2qnGERhd+FjQWUKuWnUlFH8CcmLlJhkoB7+EGsO4lEtCt
	 dTKPuR3lb3dmH1hjHk4iffGb7wOJU4bSyKjlE4qXwYrVHVfd0yK/BjrD0e6ZB+SSq7OyD
	 6BcrcW9zNVqAY3c4j+QLthKrDc5YG2XMtXPFZHC+kzX9k3xmJaY/ewi5Gy8PECU0pWqJH
	 zJwep55rWoz5vz8Xzi0QWRypX4txTMqyGgValQqaDCkb0IEiPqrTGKcrN9q6rKVrJMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663769;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azEi0STqGi1mww4BJ8UVjiw+sdsfdzklyKIkcfB4Eb8=;
	b=pFQ2MQcU3AfJmSibivewtiKl2wqNo9M+3AE9uo19UNPdtXfr9jx05PNAoemkZL67ZfyC
	 XNKOnlSJC7HloMjezFZIrScL1sVlMJWWRBoeS8J9IWYuSNadgxD5U+m2dbWT70nqyXvfl
	 xz21QNklEtf7zf3bQjan3Z2+AeXKkcczY16h2ydmwbP+8+GTtDxXpJ5xVaeSN74Q662SD
	 88fD//A3uyW6FepwBN9ICrAP/D2bVPziPRgUcTlOqTRjvN2i/nKzb+UubGb/lDyvkCXKh
	 nXmkU1N3InKh+wliDKGMS4+c7Wn3mnUnXR4MAqbB3KeusjX8tkzEmzp7pl8bQoQ38kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GjGxCVYJ;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0446E606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GjGxCVYJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=azEi0STqGi1mww4BJ8UVjiw+sdsfdzklyKIkcfB4Eb8=; t=1793663768; x=1794873368; 
	b=GjGxCVYJeDGczSThqkaoemQLFCVPTaJCxVrSXo7ucUwKuSXqppqQEL7Ud6JUodOJAQsaR47eBk8
	At4nhtmF5MKj6T4+jz+nf0t5EqjWT9wfcHiGrUj3dIC1pB3NBtl/SrC7PMRmuSNM+ZKSR0fGTIQxn
	c6ZpVSp9gcb3Fd5T9sn2KHlb3Sz+6Owo8PK48AohvyTEBM71aH4EKSQaRRkY/QVdCNSO539BdTtIy
	mtteQbOmIAA9d3fB9WyYD4qG0D20EH4f8Uh1NuPcztqsgJ5iMYdX6plv/s2RkKBfufWWqKsrHnz0s
	Blb/Wtbjgv5JDGtHpx+iEMDoteWOGSp1RrDw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sk-00000002AZf-1qXj
	for linux-wireless@vger.kernel.org;
	Tue, 03 Nov 2026 00:56:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/7] wifi: further RCU optimisations
Date: Tue,  3 Nov 2026 00:53:57 +0100
Message-ID: <20261102235603.1181883-9-johannes@sipsolutions.net>
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

I'd done this earlier when working on the update-beacon ideas etc.
but now more work has landed so maybe time to post this.

It'll probably conflict to some extent with the queueing rework,
but that seems manageable.

Basically, this gets rid of a few more causes of latency due to
RCU synchronization on scan, aggregation, and STA removal.

johannes

