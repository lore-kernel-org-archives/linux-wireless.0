Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08FC3B7752;
	Wed, 17 Jun 2026 12:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781700984; cv=none; b=HL71EHKWcVw8KV9dVKQ/mx7QqPldlZqTikPGdFv7ioUJ5kwZsGCZ9hEi0c3BsnQDdHgBuetYchERspuUI+3YGLgNaGB3PLb/sibS7A3fuzv3p5615hB11cw+QRdGnOZ2FfxA2wt6SnecoO1UoYBwt0C9RfTb88TDgS1YlLNJjqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781700984; c=relaxed/simple;
	bh=4kX7Vgcf7HCZZi909HYoz8IJ7SLc9IU0Ws8WvYg36t4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PFDUzBchTcyuT/HajIdmWyrrEXZqiwVqJgrr1AkrS79fk2i6iWUxOe1pNLMKPRC0qc6BrtKQCwz4Mf5FQY4UGxvW4r86n9EgDYWqXezi5DZZF+MX2YfJ6j0pvFAU5CsLUc2FcLO3RQ651TTtH1zDteSCXp4zCcAFxeNY7s3v42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fvgB/gNz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fvgB/gNz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VA99D5bK8lnbrqdc2poWyS2qPB2HZZGsDz4JLTRMe/U=;
	t=1781700981; x=1782910581; b=fvgB/gNz/4FsaajvjT0ocSqITeDxtasaCQ1eyozZdCWVjJ8
	7etV+dYiLMk/XVLoP0iSORFx2OBp522QwCPDNF6SJesOar5LgMOINwAMYM3RxcAilefx+RqxFR1+k
	VB6nyADoRj1jl/wyYEeITmzS0HFLfBKqIs+kxS1su48F8uIrwgTKFzKsclMU0INoSSGNPs8N2Hezj
	7CR27hoYEI24dPJJlcfg+kbNMrYmxGLScWcz3L5v0YQVH1FcGhk7HlUuDBWncyYPq4tfQ7WYCRLtf
	I+N/+JQG/ezaPXoW3PDqMCNqHl/Ujx9tsC37e/QXW+IzK3aCcliAACPgH85tjDCg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wZpoQ-00000001C8x-2nsJ;
	Wed, 17 Jun 2026 14:56:10 +0200
Message-ID: <1e656f5798a9f2f36daa00aba60d2196b2456335.camel@sipsolutions.net>
Subject: Re: [PATCH v1 1/2] overflow: Allow to sum a few arguments at once
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>
Date: Wed, 17 Jun 2026 14:56:09 +0200
In-Reply-To: <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
	 <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
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

On Wed, 2026-06-17 at 13:12 +0200, Andy Shevchenko wrote:
> Convert size_add() to take variadic argument, so we can simplify users
> with using a macro only once.

> +#define __size_add3(addend1, addend2, addend3, addend4, ...)			\
> +	__size_add(__size_add2(addend1,  addend2, addend3), addend4)
> +#define __size_add4(addend1, addend2, addend3, addend4, addend5, ...)		\
> +	__size_add(__size_add3(addend1,  addend2, addend3, addend4), addend5)

I guess it's not going to really matter, but it would generate fewer
calls to have something more like

#define __size_add3(a1, a2, a3, a4) \
	size_add(size_add(a1, a2), size_add(a3, a4))
#define __size_add4(a1, a2, a3, a4, a5) \
	size_add(size_add(a1, a2), size_add(a3, a4, a5))

as a binary tree, rather than only cutting one off every time. Not sure
that results in hugely different code though - maybe fewer overflow
checks?

Although your version make it really completely equivalent to the
nl80211.c code, clearly it doesn't matter if all the values are "good",
and I believe the overflow behaviour means it doesn't matter for the
overflow case either?

johannes
