Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492B1F03DE;
	Sun, 26 Jul 2026 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785085413; cv=none; b=LThnPMBI0RynouMnpq+IMirQQOaIX6iXnlz+R/l/poshng6VizJik0cjHYVUkl7kQ4pyQCiLCQTUz1MlUAtNu8/QU8wdIhdJZH1HGtdyLuWXn1FrNqzA+v834sA8qB0Vp/kxIZa7lRiB22ccu94qU3xXFXhDk03GUerkKbDoLDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785085413; c=relaxed/simple;
	bh=bnSpif699DhPv9Pa3tQXYdKTJJr6VDa5+ZOd/fHfHrQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uSIusCiCuzseRRDt81cvlmmu1NlOqAz5IfiiWD0umUY24iwAZn5oCd7lfZW+yFen3jy9NhFyl9yF2eYwKD9pVk6dAwMYWDuaK6B1BlIcbcuVosCdt8TjfeQtRuyt/I8ygjtBQ+oOZ+5jEQBvmFNZa3BnMcbu3caWmx5dE4BN1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vRD2KPOS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vRD2KPOS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yv7ChB1rD9Y6Ki70EK69ioUwdAhoI0RpOaiIWOIIVq8=;
	t=1785085411; x=1786295011; b=vRD2KPOSAC2L5mgrhji3agwTb0R8Qon1mX89YkZ1PrJnHVt
	V6xjuS+pqOHJqrFDDk4lqLriJMUyasItAxlH7sPNVOtkQKsWl/xnOZqhxPUt5OxV+rQhdddl8b+Zt
	gbv0AX87hbp+cleF8fWGz7E5JauMs7mMtzSssu/F1LtIkBb7BuWZUsMUfRBBTMdf7HK6BtPh6F+C0
	p+1sxei0vXeHplMPNEG06zEdiVgdBEadoCvn7TImwn9xh2xfDnt1Z2tOq3mhJr8y9ZXFQ8qpjG7kf
	o6Ws+cNFucg6j5J8+T6ODQA+F/IaU6vQz/OodoCs3r/1q9GPRfJzo5Nv2/uJumsA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wo2G8-0000000Fncq-32ah;
	Sun, 26 Jul 2026 19:03:29 +0200
Message-ID: <326f4b12b5e4917bdfb5c5aa764f2f7c3252f972.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-07-26
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 26 Jul 2026 19:03:27 +0200
In-Reply-To: <20260726105205.942922-60-johannes@sipsolutions.net>
References: <20260726105205.942922-60-johannes@sipsolutions.net>
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

On Sun, 2026-07-26 at 12:44 +0200, Johannes Berg wrote:
> Hi,
>=20
> Here's a new pull request, big simply because there are two new drivers,
> otherwise nothing exciting is going on (yet, I have plenty WiFi8 work
> in the pipeline, and so does Qualcomm, I believe).
>=20
> Two things to note:
>=20
> 1) There's a merge confict, I've done a test merge of this into net-next
>    and pushed the result to the merge-wireless-next-2026-07-26 tag. Doing
>    only the actual conflict resolution will leave it not building. We've
>    discussed which way it should be resolved in this thread:
>    https://lore.kernel.org/all/b99e4a1428546030b61883063b9542dd953a69f2.c=
amel@sipsolutions.net/
>    and I think for now the "notify_driver" is the better resolution, even
>    if that differs from the original way of handling this failure from
>    035ed430ce6a ("wifi: mac80211: avoid non-S1G AID fallback for S1G asso=
c")

Well, turns out "goto destroy_assoc_data" is actually the better
resolution, hah. I've updated the tag I mentioned, but it really doesn't
matter all that much.

johannes
