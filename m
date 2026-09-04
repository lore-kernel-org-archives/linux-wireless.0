Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A443F8A5
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515403; cv=none; b=QOeNlho3ZL7gDMTVm/s6rrOt32oW0GmKKMgXEIrDcGoxIUiuhfQzF4b+2HLk0/tNk6iOedm56wDQbNxEx8DXUVwr4c5VaR6NoTm5QRCDhjCYUAGXpQLIIh1LlmIF9+IG7P654vWVRRRLJt2bDZLamFw3iHbRhxNqGawDd8BWwWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515403; c=relaxed/simple;
	bh=pSwpVf/i2xqZ000VZuC2PIk6/LkrD+pr6yWCpe9m3Cc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eJuFjxCFRCWbjdv1DpL+AujkJlXXv8kxbY7kY49r0wfHA6RmUlS4XPcl7zPtwsuf1jr0NdwQ4E6n8GG94SOmGvZF67bA+DDwAbf4HnRzLX7DIwIR4dvOPzPuaBuPQ0mhA+YBkv8yEqUFAcFR3qMv+z/qpKo7hi/7jzJjaEDALng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ur7VOddJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ur7VOddJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=pSwpVf/i2xqZ000VZuC2PIk6/LkrD+pr6yWCpe9m3Cc=;
	t=1788515401; x=1789725001; b=Ur7VOddJV7HvCRbJw/sTzOrQbl8CiNdaGWxVFHhNRPdmmWl
	1YsuFQFN/Wf619xGcLtYes8mE5opKUbYZO1Npu0erBapTf1AUeoYVkQWy0kQl5C2aSAQw0jCnpOlQ
	dAOHW+kBydWV1DnFBZ0bdGicXafuJS98gJYNUd0mOJTC+K1mZr7EyOVFNn+hFaDBmKirJKwQBTMPX
	PxdwYUagOSIPxXl9vDP3ymA9m29Gqr/VNZNQCllyJwoPeJvG/BsiXxw6nQ9GBH7yLtejdvxBLaOyS
	7PamGZr494R7Do7H0XnHXCtVTX6/5FwwZ+qKCCVasWs2qWEw3D6V1GGpaGZRPo+g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2QYZ-00000001JQM-01WQ;
	Fri, 04 Sep 2026 11:49:59 +0200
Message-ID: <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
From: Johannes Berg <johannes@sipsolutions.net>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Date: Fri, 04 Sep 2026 11:49:58 +0200
In-Reply-To: <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com> (sfid-20260904_114736_899943_815E331D)
References: <20260824142435.1757391-1-julius@bairaktaris.de>
	 <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
	 <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com>
	 (sfid-20260904_114736_899943_815E331D)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-09-04 at 09:46 +0000, Julius Bairaktaris wrote:
> Hi Johannes,
>=20
> > airtime weight is already used to select when the queues are serviced,
> > so why should it be used for the queue depth?
>=20
> While I used AI to help me write the change, my understanding of it is
> that on ath11k the order does not matter.

ath11k doesn't appear to use ieee80211_next_txq(), so it doesn't get
this and then AQL doesn't really work, I guess?

But for a driver that *does* use it, I believe this change is wrong.

johannes
