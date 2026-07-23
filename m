Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8835C685;
	Thu, 23 Jul 2026 08:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794718; cv=none; b=NBb0/qYHoZwdn1HMan53n7MVaqlcaPXgoqVlj+4HK97dAWWLGXipryV50ZujNBpS0KJ1JL3PWWNU/jsm0Wh5y4vXn1uoDQyEkBW5j0cvWx3mhq0zJjei0adTruieY6Tm2YKh0gLb0Rn8RnP1n6oMf4n6M6qZbSu5vm5W5NHsfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794718; c=relaxed/simple;
	bh=Y64mjaCtGxTIF9N/SBXI/tAFigLZlbf6RLFxEq9KUlA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oN/51AOz/YdGRV8ZWdIipV0SmeWEf1gwNch9LkQKRltsJi6U6zJxwkggvKPJALUKp9viOh4lq3cUaW9lPwmLjvEFh3/ug3z4El6mJelv4dF4MskEeJe0XK1UXEypZ58XvV7y+jacf1Wc1KHmkeKp1th4UktrpczQT0bKzPGzcz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=khFPwYLe; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="khFPwYLe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NUfFR+3Bsy542uS2ZqJBKBvjn9UDk1KCrkWlGxWZ2Qs=;
	t=1784794717; x=1786004317; b=khFPwYLe9J99Z6xQAFbMuP2yqKwkIUqmI+vRYi0gG8Ah6gI
	2O3E2C3AnyQrXF9MkxpAM2yv89gHZcSHuDFx0IqIJAn44FHXK0UCC6v3Oii+7INXlZYKabAc6koPo
	P5Nvghmx560l2FBPc/NrqLv7q1KkJjPpsGrqhQr4vuvDK22p2nSnP/f1WmWUiZmY3AVUANY7VUEQA
	gEN0cuMSmtmq/9yZvwUj5M61uyaFUkeAFmzVDjC0MEciKkirhXUKkIzroUxJUO9mx9TvZK/cG/Voa
	VYyVasjZm2ynKsopFvyWsEZvqNss1AvQbWIoHh6UYqunuAlrjPelZtB0Y/Y2jDKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmodW-0000000AJa9-0xAt;
	Thu, 23 Jul 2026 10:18:34 +0200
Message-ID: <3552acdf7839106b152edfd13502684306ea42a3.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: publish PMSR request before starting
 the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 23 Jul 2026 10:18:33 +0200
In-Reply-To: <20260723010916.76433-1-enderaoelyther@gmail.com> (sfid-20260723_030932_237420_AA10BE01)
References: <20260723010916.76433-1-enderaoelyther@gmail.com>
	 (sfid-20260723_030932_237420_AA10BE01)
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

On Thu, 2026-07-23 at 09:09 +0800, Zhao Li wrote:
>=20
> This ordering also permits a successful driver callback to complete the
> request synchronously. Document the resulting start_pmsr lifetime contrac=
t.

From a locking perspective perhaps yes, but cfg80211_pmsr_complete()
sends the results to userspace immediately, so userspace might see a
completion with a cookie before it even got the cookie as the request
response, which (semantically) makes no sense.

Given that measurement requests are always going to take some time, I
don't think this is an issue in practice that we really need to work
hard to prevent (we'd have to do something like attaching the result to
the request on the list, pivot to a wiphy locked worker, etc.)

However, I don't think it makes sense to actually *document* that it's
now possible - it's only possible from the kernel's locking POV, from
userspace's POV it's still highly confusing at best, and it makes no
sense semantically either.

At best the documentation would be something like "the kernel doesn't
crash if the request is completed before returning success" but that's
not useful either :)

> +	/*
> +	 * Publish before the driver can complete the request. Completion may f=
ree
> +	 * it before rdev_start_pmsr() returns, so use the cookie snapshot belo=
w.
> +	 */

That comment then should call out how it's really about preventing races
with drivers from doing UAF (we could technically be preempted here
too), rather than making that sound like a reasonable order - just
saying "Under races and/or broken drivers immediate completion might
free it ..." or something along those lines would be better I think.

johannes
