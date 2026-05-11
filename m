Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886DE3BA23F
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 08:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489185; cv=none; b=qTC4etpk8eEkI9uSVi8Sq+TEJiXuCSZXFg+oSvkNLiTEbIZjxDon89hvUGUuSrH8XfwvHyr5cCWmJylEoyaE77ZYHV2+bbkDXXhwJFygItJisE0+IZxcc/oIHG5dsnoQyfICWlFmFVLCzfbJsIX/06ceNKd+shDa8cPbgtHJRA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489185; c=relaxed/simple;
	bh=TyT44KWK1HJdopQrgLzz5/3JZdRoN2h4zUjRZuLqqSE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=erZb+/6AMdOe01HdbgXbxf/QQ1SWAm+qgaBy1cl4f0stYfzOBPpP0hl6qHaz+5kcblb4HkqpW04gkI5i+SvMDd1A7x0kK1msBpOFez50tYcbOaTdkpFwD+SMfwwqeVbPIzVjcpH2uy3cB6i0hK83J2QevzKOaIAq2P1tDRdJg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BuhcZgk7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BuhcZgk7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=TyT44KWK1HJdopQrgLzz5/3JZdRoN2h4zUjRZuLqqSE=;
	t=1778489184; x=1779698784; b=BuhcZgk7f19hxuV82DzDPlzqnL7c6GAFdMSovc/mC/OjzKv
	VAbZWqrcSeiSXLOi7mmKI87YO7glYYyirrc/ck4Q1dLTSrk0xa+2UqzOs8JSlz1RrTmvW89Tzv79a
	Ih+53mvOIaZdT0T6b2MN0i2L7/1hdGvReRL8bvzD7CMuJt76d0lWupPLPL5MJqRF3OZIyLlQZTZCY
	SowdXuEzevWox7TRbJsQ8zdgS5T2Y5MaM+RfSaBqp+zbkqhpiYdCLwIk2NFSNzO+ehKpmt0sjAoEA
	md+rEoNy4SCGTscimAKbCphLypnWYwZwQlQA4PZaKT2etXUbonWpWkdx16gXn2dQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wMMHM-0000000Ec6B-21yf;
	Mon, 11 May 2026 10:46:20 +0200
Message-ID: <72b480830dee1489bc28246d13102048635de5db.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Fix ADDBA request
 rejection after MLD link removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Hari Naraayana Desikan Kannan
	 <hnaraaya@qti.qualcomm.com>
Date: Mon, 11 May 2026 10:46:19 +0200
In-Reply-To: <dbb28e3e-5022-4915-93e3-dd428ea59507@oss.qualcomm.com>
References: <20260415-addba-req-v1-1-6eb9a33d8ca6@oss.qualcomm.com>
	 <1f57207139c3fb955459425deda4d06c374ae212.camel@sipsolutions.net>
	 <1d06b2a3-66d8-4c27-b965-6c21f80b7539@oss.qualcomm.com>
	 <a5b6798819178dd2995c34ec817457e90985708e.camel@sipsolutions.net>
	 <dbb28e3e-5022-4915-93e3-dd428ea59507@oss.qualcomm.com>
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

On Mon, 2026-05-11 at 11:56 +0530, Manish Dharanenthiran wrote:
> No, there is no implementations that combine these two, but there are=20
> cases where the update AddBA request can be received from the station=20
> with link reconfiguration.
>=20
> For instance, if a station associated in 2 GHz, later with link=20
> reconfiguration station can either move to 5 GHz or it can add 5 GHz (as=
=20
> MLD). Station then can send a AddBA request to update the window size or=
=20
> other related parameters.

Ah, well, OK - technically an implementation can do that all the time
(and technically we can refuse it all the time), but I guess then that
some implementations do it with link reconfiguration, and also don't
like the refusal :)

>=20
> We believe that a no-op update is not required (or at-least we couldn't=
=20
> think of a case in which that is actually needed) as there can might be=
=20
> an actual change in the subsequent AddBA request.

I just think that once we require an UPDATE call from the driver, that
raises the question of whether we should even call it for a no-op. This
seems a bit strange? And if we don't then we wouldn't require it for no-
ops either, which is probably generally good for drivers that don't
(immediately) implement the UPDATE.

johannes
