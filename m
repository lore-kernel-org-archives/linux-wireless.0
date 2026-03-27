Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451EE3EF0CE
	for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2026 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774623086; cv=none; b=iXiHX4GPvCME6g2/8tRxQc7Zppe5fEQHqA/jFrbUeJUurWIA5X531h5wKj8e0oZHIdhEHaFCti7mhYQqbtwEpiJsAv4FiIwfhEl89zWYqsjSXcqibqKLzBSeyvyz//rZSlfhWSaSH5cLdB1lwmcDtTBHJqkPP9ANr1y4iCixuT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774623086; c=relaxed/simple;
	bh=fHE/TQ2VA6qDa84vRAUIEQ8F5oXeKUmPHwXYv28cr70=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WgyK5esXRxBEMy+svGf/p8QYh5iW5oEcNNuYlOPPj7kgRNLi5ljCVtIlWW37D37XOaf+kqMMkKqtnE7C6EqomaV2WUM3ku2M/IizHQDsz+kcfcHXXOh3wzgPKHBnh29+yArf7oW3pfSk1TKTGOdTNhQfuZGODWAVn/0eo2CHjj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=txRvY3QS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="txRvY3QS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eEiccdRL8mVq3UdqfFSuFGUi0qiM444bkdxzwYJl8kU=;
	t=1774623084; x=1775832684; b=txRvY3QS/3XhI+FKDOyhWHo+2netU3zy4zQj1oooeYFnkY4
	rTB5+snRd+cRiAFto8hP4qiY6Xy+hDLe4EUDnk92lfljC/0Tunkvj71G2tPsaeUE2dnCHbrkRpBKJ
	26Zt4rLIc6Fwb/tRx738CwjN7Qs76cl2pIXUGFNdSuTePzqW6P/hQlgInMO4l30Fc24dvChXv8YBz
	Q8IlD6Zs/pQ+YY6ejcnk3ny6htKePh6RiBofAbx1jbTdeMVTP3lRw6eA4S+UM7tLDGf47x2TYt1Yr
	ZyOsaAMub7Le12e0iKBYMhPEnO/ZBctO8yWLcKZqbXPtXMT3M9S5ZwpYwLOOMrWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w68Wv-0000000EL8T-3OR2;
	Fri, 27 Mar 2026 15:51:22 +0100
Message-ID: <ab3241404c0366a5f06cc1d02cb7e9068d7d72cc.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 14/19] wifi: cfg80211: move AP HT/VHT/... operation
 to beacon info
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo MG <pmartin-gomez@freebox.fr>, linux-wireless@vger.kernel.org
Date: Fri, 27 Mar 2026 15:51:21 +0100
In-Reply-To: <91b36670-30c2-4d67-a57b-c1b8295b5990@freebox.fr> (sfid-20260327_143420_271808_1069F29F)
References: <20260327093659.711584-21-johannes@sipsolutions.net>
	 <20260327103659.1cdda25b617f.I0d21120b41eed661eefc61d5417dadaae7145845@changeid>
	 <91b36670-30c2-4d67-a57b-c1b8295b5990@freebox.fr>
	 (sfid-20260327_143420_271808_1069F29F)
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

On Fri, 2026-03-27 at 14:34 +0100, Pablo MG wrote:
>=20
> > @@ -1524,14 +1534,11 @@ struct cfg80211_s1g_short_beacon {
> >    * @vht_cap: VHT capabilities (or %NULL if VHT isn't enabled)
> >    * @he_cap: HE capabilities (or %NULL if HE isn't enabled)
> >    * @eht_cap: EHT capabilities (or %NULL if EHT isn't enabled)
> > - * @eht_oper: EHT operation IE (or %NULL if EHT isn't enabled)
> > - * @uhr_oper: UHR operation (or %NULL if UHR isn't enabled)
> >    * @ht_required: stations must support HT
> >    * @vht_required: stations must support VHT
> You forgot to remove those from the doc
>=20

Hmm, yeah. No surprise, I had some conflicts here because our internal
tree has some merge damage in the comments... oh well, next time.

johannes
