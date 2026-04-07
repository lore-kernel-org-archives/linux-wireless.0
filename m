Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856AD1A6809;
	Tue,  7 Apr 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570522; cv=none; b=sN0CNMUiPHlaLN0o3BLSfa76OW85/a5tt2jpFnDAPFwEpeSLSmZkIKwJWrd6VNJwTkz0R7i6R1QreKbQMBoviGVaELle0njo7IWAadFAvUfKJSiuJPU2+MPr4qGqhR2MgNsSYI4EsnnEdWVq5RpuyyWGX27X0QEMvIpncwDct14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570522; c=relaxed/simple;
	bh=cUaoKVPneZ84aF1rThwRGECv84LRhOys9/6kgVY5JV0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t9D6WLQP0xLKCLuS5WSrRXzbuWsL/qKYsYrDUE1HvSGOxe7e36QGhzPuHEHgYZL1x8YDTNICdTVKqKwZRmw05QGnyLM6LgQn5X2aJOb47GM/Mt0h/9uuFwbB/mUwtbz43euuIVMKotpjiivqRO5lq+3UF348P212Vjkl30Bbcwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jZ+AVoqV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jZ+AVoqV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=y+yBpU5cbVSKNi9CL8NCHx1VsCoZ21dADef4cd7RGHo=;
	t=1775570521; x=1776780121; b=jZ+AVoqVyzWWJft9Es78j+A1nOCTKuY3Xqv9xjtbcOC/pox
	lGbJzqtOSLopSO578xOdDGPoaCI6TZ10KDfHRy408mOtMJMgs7DROCkZPduJ8QTsvJbGWXsC7Ft4N
	tPsociD9/BWW91Nu1Mu/5MSURUNlKoU7Lef9DR5S1OCimPidJUo1tFehHs4oxYd22mKH7joPm8IrY
	59iIlCbHKpJDMrZ03bNidD/sNBKIJxr7Ygp5MFb3BO623T2rCtINUJ7S7y6uiIUwci2zNu1POnEHo
	XsAh61HqIx7Ndj/QJfb5YghJKrvPtS+poNEZgnBydbBTDVVN3Y8EDLEBcmRKYe9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wA709-0000000CXDU-1pjO;
	Tue, 07 Apr 2026 16:01:57 +0200
Message-ID: <b6d7e95b953bf3fa6fb0b3a7266a748309b1882b.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] wifi: refactor USB endpoint lookups
From: Johannes Berg <johannes@sipsolutions.net>
To: Johan Hovold <johan@kernel.org>, linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2026 16:01:56 +0200
In-Reply-To: <20260330103207.1671926-1-johan@kernel.org>
References: <20260330103207.1671926-1-johan@kernel.org>
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

On Mon, 2026-03-30 at 12:32 +0200, Johan Hovold wrote:
> Use the common USB helper for looking up bulk and interrupt endpoints
> instead of open coding.
>=20
> Johan
>=20
>=20
> Johan Hovold (3):
>   wifi: at76c50x: refactor endpoint lookup
>   wifi: libertas: refactor endpoint lookup
>   wifi: libertas_tf: refactor endpoint lookup

These didn't apply on wireless-next, please fix and resend.

johannes
