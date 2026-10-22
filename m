Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664326;
	b=139RX1QjhE3pmHrzCiXaJbVJxzaV/5TEZFKcN6EWb67/3wZPBwrfXLi4dtj4JG4RwYvn
	 Dv/Er7hqaJJkAphLoSLPF2BOZZUZ6pGLOUwnUSZRIf/SDjV+S106779w+o1LVqCx/HaU/
	 DSwicPr3A2ImSQfQChtTaXgYmPC4ww9Y5u5PpKvx11y63d2GdY+RPLWtl9ri1WVRhyUB7
	 /ZHlNhS4xTcgIxIAWkDQFSoUrurbx2Q9hydG1NL8Ikiv+vVMVVjVspvojMjKGg5kj3/H0
	 Wi6Y7Kc2kF9+TNEvBRkx/J7Gnh9rf7Aa7yeRk/aGFu2QopqP8fnFIstIfdJ2p9EwkFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664326;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IKG7j3fwe2NPiWLI2r+AmjsGqP+iT7rK3Ouiy5n0xXs=;
	b=n+EWk3C8J111po50dn60csROavsaYcDQfC+bFu1Mg5ihb0z9dKmOXu37sXBh7Pp+FRyS
	 49/sZOHd98gt430xYXs+2UEb0q1lxVuELanHAGhx55Z4B61alCLupv6RfvdlDbBQmy26u
	 rARxt04q/VjilIeg0Sqf0Au9QlsHOBnmsn+A+8oaCr9+64a0z2c6TFEOWonHMtqtZQRJX
	 cJTp484ODeifJD9HqllZnka+0l4nOSJtQnA5IF5NXA7ZamKJCYqzkLh0oGOzrgTroDlFi
	 ujHFpNNEUSUsJhrUBH/QmCF7W8PPrMx3yytFFabxqjIrxAY9FRWMftwwKVVzWETD4Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=m7q17CJw;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98241606A31E
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=m7q17CJw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=IKG7j3fwe2NPiWLI2r+AmjsGqP+iT7rK3Ouiy5n0xXs=; t=1792664325; x=1793873925; 
	b=m7q17CJwNN+aCAcVlxkcQ+cslS4kknR+LLHM/vOQ8LUvVvdtu5dXw3Q2ToXJ1O+6ULoyjzaUYd5
	ibBgGZFsedwRiKEQzYn6lxehU9+EQNWp1A6/GDDCJ8Dl+N4iVwsaCHn5oyOTsYBZ9+ymFDxWxNFmt
	8ObcFBjSZbQgA21z/03gyRkvEhxG9MoFJaNQoV6u3c8Mh3MYZxmsc/+R3AlvctIqSh6AMc2EnLA0j
	PJ/42TjZPRs8QhZTlW6jVxAgLLzrHUQfbMCdj+BMGGocT/X9w/M9nXsjbno9ahdO2Yc0f3KbqEepC
	qOW8WznPZcgZe3kaFBlD5HXxla/v/JeSXrTw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsg-00000004Ifb-2csd
	for linux-wireless@vger.kernel.org;
	Thu, 22 Oct 2026 12:18:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/6] wifi: fix regulatory domain ordering
Date: Thu, 22 Oct 2026 12:15:31 +0200
Message-ID: <20261022101836.148512-8-johannes@sipsolutions.net>
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

It's been reported multiple times that we can hit a warning
in nl80211 when custom regdomain registration comes before
wiphy registration and userspace races with it, and I've
debugged this problem multiple times in the past...

Let's just put an end to this, and _require_ that the regdomain
for self-managed is registered first, but clean it up so that
the processing for that only happens during the registration,
so userspace doesn't see the events in the wrong order and we
don't update state for failing registrations.

I think I'll (need to) merge this through my tree, but please
take a look - the drivers seemed OK with this but I couldn't
actually test that.

(The first patch I posted before, it's just a patch dependency,
not semantically required.)

johannes

