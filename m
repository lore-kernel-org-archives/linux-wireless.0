Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7B3C3C12;
	Thu, 18 Jun 2026 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781808831; cv=none; b=tGHh3cv10OH8CUySZTMRH0fZBQnHDuOjlSI2JaDv+Z0r7mu09K9Y+gJ6CRF2B4yK5Zdo3qiPXpxCVUohC4sO+jB+pgdJI0RcQ0vjyflMoZnnz3f85YxNgU+IEgQi8P7bhNi8ipZ+y91ukz1IB+qVqbcwRvQLT1QkHRUlwUhn25g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781808831; c=relaxed/simple;
	bh=hkGXZObuvBdwjYuZ33YV8Gu3IfIIBL/PXAMdfSBQCf8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qMGHPqt9Usx0YdbrNUPg3j2AhCnWKQuC4cVwvT17toxUPGKy91W7UTZt2cs93MJkabGHZ/vpWRwHvf+6HOG7eY0TfhDueL9ThJAIsq5P8mAmMffaxQtIyAnDvJvfJrdSbChk/7bAkOLUluKjpz0Ed9W1tYZ9Fsr0kIU3dbbSo2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pqaXhDUB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pqaXhDUB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Jx3GZ4a5Dt8zZS/PeOiLVa+tRgvqf4hUK+IjWziV8Wk=;
	t=1781808829; x=1783018429; b=pqaXhDUBQu5J1cCZTLFSIv6zHWiC32ZE1aD6GZTaq3arY08
	pBn5KnWZfT4gUhz5Mdal8HSFsJchG8DSf2AX3vqCa0kl9wZG4LHeAMz1KHAAnNDvXwGwKDk4lMNJA
	jHHyKoNp9n7fwwO/7sHP9PNqBhs2P1ZuFrWF8Yq5/2digDUpXtVlqF4gIk/0MIB5YCS+WdcZhJ78H
	iIy2xqD6jXnReyso1R/ca0tPJeN+WBEt2sGBNp4nO2SHGuwSpoBj0gXXu/kiCoQDG61EfjEXoSdIC
	yXVV6+zJbY/3dll2xSYAtJPaE2Wl4He3DIQrk/dYiTemnLQDsL289LWxkXIZhV9A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1waHrv-00000005dPs-1FbU;
	Thu, 18 Jun 2026 20:53:39 +0200
Message-ID: <37fcf7c0b1a330a40005fc5ddbe075267b93851e.camel@sipsolutions.net>
Subject: Re: [PATCH v1 1/2] overflow: Allow to sum a few arguments at once
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Laight
	 <david.laight.linux@gmail.com>
Cc: linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>
Date: Thu, 18 Jun 2026 20:53:37 +0200
In-Reply-To: <ajOSqWpYUhFTVqP-@ashevche-desk.local>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
	 <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
	 <1e656f5798a9f2f36daa00aba60d2196b2456335.camel@sipsolutions.net>
	 <20260617223056.754bfcb8@pumpkin> <ajOSqWpYUhFTVqP-@ashevche-desk.local>
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

(hah, just found this window open from this morning ...)

On Thu, 2026-06-18 at 09:39 +0300, Andy Shevchenko wrote:
> On Wed, Jun 17, 2026 at 10:30:56PM +0100, David Laight wrote:
> > On Wed, 17 Jun 2026 14:56:09 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> > > On Wed, 2026-06-17 at 13:12 +0200, Andy Shevchenko wrote:
> > > > Convert size_add() to take variadic argument, so we can simplify us=
ers
> > > > with using a macro only once. =20
> > >=20
> > > > +#define __size_add3(addend1, addend2, addend3, addend4, ...)			\
> > > > +	__size_add(__size_add2(addend1,  addend2, addend3), addend4)
> > > > +#define __size_add4(addend1, addend2, addend3, addend4, addend5, .=
..)		\
> > > > +	__size_add(__size_add3(addend1,  addend2, addend3, addend4), adde=
nd5) =20
> > >=20
> > > I guess it's not going to really matter, but it would generate fewer
> > > calls to have something more like
> > >=20
> > > #define __size_add3(a1, a2, a3, a4) \
> > > 	size_add(size_add(a1, a2), size_add(a3, a4))
> > > #define __size_add4(a1, a2, a3, a4, a5) \
> > > 	size_add(size_add(a1, a2), size_add(a3, a4, a5))
> > >=20
> > > as a binary tree, rather than only cutting one off every time. Not su=
re
> > > that results in hugely different code though - maybe fewer overflow
> > > checks?
>=20
> Good question. I'm also thinking that one-by-one may expand in too much o=
f
> preprocessor code (haven't checked myself).

No. I was confused, and managed to confuse you too perhaps, sorry!

We have to have the same number of operations (__size_add calls)
regardless, since you have to add it all up: 1 + 2 + 3 + 4 + 5 has a
fixed number of + signs regardless of how you parenthesise it.

I guess actual CPU execution would have a better data dependency tree if
we balance it, but ... if our hotpath depends on size_add() we've lost
already.

johannes
