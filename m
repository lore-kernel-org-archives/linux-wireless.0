Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1243A5422
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971858; cv=none; b=N8BnUWfDSD94MPbNMc3wgYRuCrf6nJs4kAeynh8pZDQ91N6WZZjEv7NRXS7EFcROMQQROgQLTBNkIlOYGDBbsHIJcOj6KQgrf7Uw22h8pD0oYwp1kugRXt7gH7TBOfcgylsNsoZYBY7n1GtLGI/VHX2HpmazwVonWJyKzs+p30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971858; c=relaxed/simple;
	bh=8UI3eSPQYvHS1Cml8uk6KGNRnF/S/wxnEZbKolaZL4s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QQiF50FGh0rXUc2eXUKMPu7eiD4JXZXKMmN9G5dPjLK0UizA/eF+gbvh0STBVgfi8h9kab3AagG5BZ6/44Df5iDup/7CKQsiSOcEYPrLR7MnJu2+dQR6pIPltVKuQ+vQpqMl/EyiRSVqZU4Et1XAY89kzWyEGNc7JCGBWGeexCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rHSDhej8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rHSDhej8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8UI3eSPQYvHS1Cml8uk6KGNRnF/S/wxnEZbKolaZL4s=;
	t=1791971856; x=1793181456; b=rHSDhej8tsmRqMQ0Hf5lWuriIjPRK5esiJkW90BI1ha+tVb
	kuLoq+WjsUI9FNhIhe5MXsq1OtVJy7ayrmL9bRbZ5cDjSJEPs4j8MXsiOAe6umIHsejKJ+4kC3+U/
	m0fpL8QExKru8E5+5LHcPHZm/HiOykXB05IgVCX5asL3PnCwZ0wNExpU6FxtvhEsMX2WDb0E+p9ZW
	g1sJ/yEMVG7sF1vKYsgcN/Y/76+1Kgoo4zTiaA0yKblLSXsfeJ8X6erzpce264mDm0mmt1YVSVPmO
	T3F4FyTUlYTw0ARQizVKhtr323lwyP8IhYgtojOM/bukUlIvWt9I4JZAOmQTfZrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGvjn-00000001KqJ-3z9w;
	Wed, 14 Oct 2026 11:57:32 +0200
Message-ID: <655328be546511b780c15e96c5076846f2f30631.camel@sipsolutions.net>
Subject: Re: pull-request: wifi: iwlwifi: updates - 2026-10-14
From: Johannes Berg <johannes@sipsolutions.net>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>, 
 linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 Oct 2026 11:57:30 +0200
In-Reply-To: <IA3PR11MB7213130F93D66D28E04328C3C1A39D2@IA3PR11MB721313.namprd11.prod.outlook.com>
References: 
	<IA3PR11MB7213130F93D66D28E04328C3C1A39D2@IA3PR11MB721313.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-10-14 at 09:43 +0000, Korenblit, Miriam Rachel wrote:
>=20
> Avraham Stern (1):
> Ayala Beker (1):
> Benjamin Berg (3):
> Daniel Gabay (2):
> Emmanuel Grumbach (24):
> Endrik Einberg (1):
> Ilan Peer (2):
> Johannes Berg (23):
> Miri Korenblit (29):
> Pagadala Yesu Anjaneyulu (11):
> Shahar Tzarfati (7):

I guess I'll pull it this time, but this really is _way_ too big for
this late in the game. Please send pull requests more frequently. I
should have most stuff in linux-next for a few days before I send it out
again, and at this point that's impossible.

johannes
