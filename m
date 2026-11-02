Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657900;
	b=Gf+9TCnIZfMI1ySjnildirVV3mSnPI11zdIY+jbbzdWOkhElb3TTPv/Vdz+gwr4z6Lgh
	 CN5SCAL5VmqIBfJVyaKCj8RJfvPWtaYCmIhnzhGhM3iP3IqzsFEoqooMZ7i49hKw99nVg
	 v2oj8MrQ2GCC8vRYDQWN5Upcqkg0TJ7c59umpZr+cafiFn4PJtAzkIniWMiutGU6EQn+3
	 MbYrpHZ2YpQd6wO3EZ5RupSFpp3lFmnCSPKTsY+hN/UJ8etXq8mGy3WrOzHDKIwSkbCV+
	 ZC2SqJldQYuojTDyQlP2rANG5M4xv2lhe/yAQZ/owYmuIx9B87gy8P20oLKT7nRQ+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657900;
	h=DKIM-Signature:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0myw98yljTaOstnR9RfsjWNn0mcJWzDnWr6vLgvuXE8=;
	b=C0hSL7SarxgHey3TYgyQHv5DhnsuBD8XBLWNwPoQLAX0EIy9lnQojYY1etwbbIYoETVn
	 5UIB/Vor/fk2ZCMuMdkUldODBodb0z0Vkz71BoDJd9UTEOmUhpDBKfpfwEO4FnQiZDBK7
	 lAAUzQCC+k2397zidFuoS4TwZRDeriNsvjWpatLOmR4zeMoa8DkHVQI0JWHijetC9n60M
	 9Zp5h1PwWCBJmqhkiaWRhNXdIdNLQy48GfW9CKmpauOMmOsJLD4CFT/WZe4wpzfGmfgDd
	 j8vDWY8XbCH6ge/WpxXNSKMpBgLtqrsGxADEqW/pzPflRcJgwELzGQwKlhWws3KogOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="M9UpO//W";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D44606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=M9UpO//W
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=0myw98yljTaOstnR9RfsjWNn0mcJWzDnWr6vLgvuXE8=; t=1793657900; x=1794867500; 
	b=M9UpO//WWdojwDEpFUiDvirjxDePHKfxNbsLHGXfeRYV6ME+I7tB1Gluh2/7MV3IYtjPN2lMbF+
	Xal6fWO4oYosODUXiHVVAMGkn7z9me1gdJ6gIQrfC8KtSLnsTKEPfYpY9Li1eEovgdFq/dNy6pyI0
	eEcvjQiBIpAq5HTQ+sszNKZ70MvAopRNpJVEc96geS9JvjtWnca51xXIdXBmZGBLybS7tKsKItfR5
	yWh/ClvzTne5hB6rDjk0Z/sl3JJfYMfPw13j1lB5oNVDGfDVhY6uuRYaKz0/+LdA4fQ84nUHcL5Gh
	g80jhxWqSEQ5oUypWeQSQkRFL7L2bvFcRlGA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0M5-000000023YI-1puX
	for linux-wireless@vger.kernel.org;
	Mon, 02 Nov 2026 23:18:17 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/2] wifi: mac80211: new block-ack debugfs
Date: Mon,  2 Nov 2026 23:16:52 +0100
Message-ID: <20261102221815.1131181-4-johannes@sipsolutions.net>
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

This is something I did during SMD Transition work (but is sort
of standalone), in order to be able to test various cases with
SMD transition having to flush the reorder buffer etc.

johannes

