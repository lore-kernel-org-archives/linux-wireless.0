Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CAC28CF6F;
	Mon, 22 Jun 2026 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127003; cv=none; b=SlUD8Ny+FLawe9ctxYV+3Sy2kSz6dqbVjsOvniDy+VyJUl0OunD+X63D7WfLaCCqI2FlZY6ixYw12vqkyNHhQbxVoAaOA2rxfkbaGR9FSWIsLp+W5tSxeYxDLv57gSaw84GktqO+2Aqhs7sqIYarHOrXHOKCl3wCh4BPiAIJaUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127003; c=relaxed/simple;
	bh=kBKzLAJCRkq24se/DjbI2sU50SBkMjoVg6kw+7bEAaE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iJC7ZNSEuqz4l1kwIM6d0DwCP4cx3Wu2dM7rriwOPSySV2F8gSCOvbPBEDjW9WbzsSVZtk6lT0CCOEBu4RyzPydV+/OKLTzJZPdiwpHbvJL48r/KpbTuh38bR+VemrOVcJBCvlZ6P8GNzBCHYktPplB6fURjeqJSnaWnnBAAe1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ROuDB9Zs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ROuDB9Zs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kBKzLAJCRkq24se/DjbI2sU50SBkMjoVg6kw+7bEAaE=;
	t=1782127001; x=1783336601; b=ROuDB9Zs8EOcvQdskOjsHporwBVKStmJBAbzwalO0+zr4jn
	WvAF4+nSRzxwoaa1o8HM4LA3jFm/FuX2sDcYjimQimhfEdA9o9oUE5uHorTeHyJZQt1dYOR3gRj+I
	IaUauSnFx3GusQXZHAHEoKDuip7flPU5lsUgq6nfn8FMyrVlO34TL0x5uegY2J6TWKQKI2Hm3W3hX
	aCWM6XrvdJOhN5hv1gcOBigMWzZwgyJDtnXF73C/suDY7h5YBjqb7512b8If6jrVYnbuicPk/Mng3
	OuiJSLGYG9Q1krqUtVX/uVzNOSD0+Zr+c47Zztwzzi/Y3n+An7bnDjyPEKs0/A7A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wbcdi-0000000CWhV-2Z32;
	Mon, 22 Jun 2026 13:16:30 +0200
Message-ID: <54974e4298efd26a52c9c0e9ada88d57e8695a09.camel@sipsolutions.net>
Subject: Re: [PATCH v1 1/2] overflow: Allow to sum a few arguments at once
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kees Cook
	 <kees@kernel.org>
Cc: linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>
Date: Mon, 22 Jun 2026 13:16:29 +0200
In-Reply-To: <ajY5hg0f34C-iV3R@ashevche-desk.local>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
	 <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
	 <202606182046.AE5F6A241@keescook> <ajTlfuOFHXlA7xdu@ashevche-desk.local>
	 <202606192025.CF68F2E@keescook> <ajY5hg0f34C-iV3R@ashevche-desk.local>
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

On Sat, 2026-06-20 at 09:56 +0300, Andy Shevchenko wrote:
> Johannes, are you okay to take a new version (I assume the wish is to hav=
e
> the balanced additions)? If so, I will prepare one.

Sure, I can take the patches, sounds good to me.

johannes
