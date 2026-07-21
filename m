Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE13C8C74;
	Tue, 21 Jul 2026 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784633215; cv=none; b=c+VjIo09w6PO90y2S17cHUw00EfiWni9hDf6RS1Yx+k5lk8N3QC8RbiQfvXfo0f7eCZbicB/gd2XQJ7vj2bHfPXnv+BDxk92AdJ2oEtKhR86RtYST4GJXJcQGLInSTJfMLbuZyEeFgJUQxRpWCSZcGBBgT7RvCmPmr5apgn8DNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784633215; c=relaxed/simple;
	bh=tLpUtnqVzHrSWOtaFQKo0jvqog54ATvEOTxXcHgHveQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ttzrp7MGB3LH/81+QS/9KB8aoJUFBTNxpsLNtdrnUvYWFLnixgBwLrm4Sia5JVcSOCpYXNlyiV3wHRco7qeDkYyKTsozxnZ6ij6d9E+XSoAm+DZi0dK1alcHXBmSjNnzyqosGbigIlPZ/wzl0naUQLam/jffW8JyfMpfwyuiSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LcXBjU0z; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LcXBjU0z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tLpUtnqVzHrSWOtaFQKo0jvqog54ATvEOTxXcHgHveQ=;
	t=1784633211; x=1785842811; b=LcXBjU0zS0huMTvQeuT0BVsm3bA9VSy2UGhSVnfv56vOGuM
	XBq/zkPEk/ozWPTyZVaVQlpTyRoqpHCiPX9qZ96jnHsDZ24BbBtYOFjW75UU26cc+j0KGZ+Woc9Qb
	vMWSOD2Bdo/QKW4I2S1L7JYvtqBsDcmblNcfC0hRfYSR5HpMFkb/acfu55RGXpitOSe62PZ3j0nBF
	XMs55z9+hbjBUwgrgtAzwngAzX7Q2qr1BCXUPt3K4JseqKvPtXCGfIk+MZpVSQQ2nzomwFY2aQnHm
	bj2QkDpc6G/c4bnsaCe0PCU+8zvVLJG8eESbfamiaM3wy7taW4UyEFESRcKWkMqQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wm8cZ-000000020Os-06sP;
	Tue, 21 Jul 2026 13:26:47 +0200
Message-ID: <ee3df0174cce496f9d2d49854080cce516fbbed6.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] mac80211: stop tpt LED trigger timer before
 freeing trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, open list
	 <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jul 2026 13:26:46 +0200
In-Reply-To: <20260715014715.1416183-1-rosenp@gmail.com> (sfid-20260715_034720_953990_4566870E)
References: <20260715014715.1416183-1-rosenp@gmail.com>
	 (sfid-20260715_034720_953990_4566870E)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-07-14 at 18:47 -0700, Rosen Penev wrote:
>=20
> +static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local);

I'm sure we can get away without a fwd declaration.

johannes
