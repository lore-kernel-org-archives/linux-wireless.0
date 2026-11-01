Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793544517;
	b=Fsloy7v9bnxetVDAeB30Z8o7SlmnwgHOehN4dX78d1v6cc/Rgk6lesiEa2yNy7nYUCta
	 3hO8IGB4eH77/hmDv25n3kIybBGe9PRml1RoclN5sWklMhFJe+jIiv8/o30jM6anL9aRs
	 9ZTLB6roY70jiWnteGa1DV5I/GnBqIzD5FYkrB0vRiYUPbdgYo7TboC1UZqYbc2y9gmdz
	 8T5pOkl+rl1EmzGHD2CW4hd9FETzVEA4O93cfhsLsDn8PHN3wrLUMt4SyiyCz5iDmt/65
	 cUAR5bMQ4uUeMX9shDXH+GQihDLHBSld317X/tkg3Tl9IcPa/P0E3VLEIIEMP5iwniw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793544517;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=hvpAAvAdEd+9Q2TMUO/7py5NLKmlirpnfmmXcoKHwcY=;
	b=gmjVxZPVnetQbOj5IC39klvCY5s36R4nRwtEjUQ8picgpiAX965BZEO4FsMYIQc4pV3V
	 M5/hVR6F9aczgZEp4cX6jYAG7ObMaMZ8kDJ0A4g64I2mDdQWlJBIKtU9IMW8UFu+RvDQj
	 c40/n0Yri+JD4Zg0bVKx7HhVxi+O8q+oDvhAeVvtdF0NpwF8297uMLa7jxBR97ZLFXjIE
	 oSvyljQchNPIeix6O8ai6AG36qMP1qw8Ti8xgqHubQn094Hd/k+gVXDTx23+BC6dXKMCv
	 SfJC0EpCS7ZYD1U9I2r5Nnaip1e9suEx8qcLhBTzu2sJelQVvZ7wvf7zjSC5lnuCe8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=QbOu2LQB;
	arc=none smtp.remote-ip=62.149.156.117
Received: from smtpcmd11117.aruba.it (smtpcmd11117.aruba.it [62.149.156.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACA1606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 14:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ACA1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=QbOu2LQB
Received: from localhost ([87.16.49.252])
	by Aruba SMTP with ESMTPSA
	id NWrCxTZPK1JUyNWrCx3rdb; Sun, 01 Nov 2026 15:48:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793544506; bh=hvpAAvAdEd+9Q2TMUO/7py5NLKmlirpnfmmXcoKHwcY=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=QbOu2LQBscf6m5wKaD4Ya2wOOSNiHz10vfPK4nF7+QrTvDVmh1b5f4Jh+puGVz+kH
	 clazbVPzdf0tEGKg+085KnkiAktd2mdDcFOiyIzMLyLYqwx2Buwfv/yt9wkyBrRmOv
	 0uLiKx27KhktY58xYr88SH7JWZ9ij6iuuFTlns8aOztqtBq7exYjKZfw30c5aNv5VJ
	 C/AJX4Bi1eqEoonAdA+pAbpaybetvrwh9jx3EI8DqX4r8GKBO73xpvNZqCE7cOk+hI
	 onmqsKNMFQbLSuw8PK6xDONLDug9KMKfAeUhxSZhT1DP4+rIg0ITy7SgXiXfAlDBRY
	 QnOeWqHxAYO2g==
Date: Sun, 1 Nov 2026 15:48:25 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Fork of b43-tools
Message-ID: <20261101154825.000023e5@mythread.it>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfHSLSo5mGrDI21PoVDEEw2I99kuVapNHLLbrPSXF5X4FogeI4GCn4oVjd/90j/tGBu8bvEgRS4TS7vozab296P61AOIxd5vQlEcTnaYhcEVN4/WH2CQc
 xiR+AOg4cA25Fzi60JW5tTalc9hj5qcKJrmG9EFjqZQZZD4G+SO17tRgR0Hs9BTi7d0/B7fhAbbcmRA8nuhRnInKXGlFq26+kWe2g0R+lGjIy9JVCrK6Bu5P
 35SDx5rGMctP0Mia/J/P+KYuZ3KUUNIF+EE8wiGu9wkJCWi5upMhLbrVDu7JgvZ8

Following the archiving of Michael B=FCsh repo b43-tools, i have forked
it, my fork https://github.com/aleferri/b43-tools.=20
Current goal is to fix long time documentations issues and progress the
development of a valid python interpreter for the psm to help validate
b43 driver.

Alessio Ferri
