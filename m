Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793469158;
	b=ugUsinv4+w1G2b5JQZI/XRvPNdvzpOWyuwavLe7ghLCXsseNXj+1VeTXAHPgCCJ7tV49
	 UQTsMqnx1WJ9H525TRmiCZmajrjwbz6FKjrvBzqXO//2nbeGVtdTOKoZWIF1Tfbj3Thte
	 Uc/TMg5BMCyxfyV2kagIi/rHpVLPZ5MFYIdopk+e3Wrfvla4M48va6dMrnbO2BHiY3P9A
	 p5b2VJr/GTrjBQ3SB3I39olkgDBZOXBQ7yf4K8w9AkciYhDha+bkdCwa0eVw5Pm/+JTfr
	 mplc626DqOsyCzlPsfS2x+mDmnQxRBYMXrPQpxRn8LOu3lp83wf7rQSyEal90Dr6qYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793469158;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:Date:
	 User-Agent:X-malware-bazaar;
	bh=E3WEgmPOUHWlXU6Ft1pzF+B26+feTHlzchfIB1LDb9o=;
	b=bD+REBpRHy75MWn2amfzWWjvaJAtFJueOQt71KxC9JBdasWNkWitxHHyq+xJhk55wjOz
	 JLJlc5tJFp+YS5Lh9WjPQgUq/DBtQJdtDPq/vnQE7mJFQKCkRTjc92gt5BwpMvm2eWdig
	 8Oo781dFdQZQcNDhF0C3zuNldYENfpwDKHin/4gu8LoiFEvTeedSbydcpfAFi9QLBuDI8
	 cXvRE+b6uH8GISt+zgvae9FWeEkeZ4MXhZeR+IlNJ6e01vIStS8iBvjLvNwsquETnNuEc
	 HucMhxyUN5Iw29UbfnWPkcSHNHNKdtNtKM2IKKzFGNKzDgXMm6bVuqyYPT53USbcOkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=EbbXCcsQ;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A37606A31C;
	Sat, 31 Oct 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=EbbXCcsQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Date:MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Cc:To:From:Subject:Message-ID:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=E3WEgmPOUHWlXU6Ft1pzF+B26+feTHlzchfIB1LDb9o=;
	t=1793469156; x=1794678756; b=EbbXCcsQPJ0ezkdq+8//vBA2jXRVcecywbA2AKAjFYt6ZwV
	/QDDcv+Oo8SbQdR9FysCtVWV6/GGBov9R362lLZW3Hz5XLBISkNsd9WmkbYz2MctZyMO7lPKvkN9R
	iN37FQRNsFiwrLa/PT5aj4e1yTLJBu295lgHk79i8stgkdoP0oG/9juEpNF+/rqZvuiFLbksj+Ge1
	/2OPItQY2+Y8h3qpgMFA7WP3PW1RFjZvBVOFoWrPhIR9raIIpBinS3HBk0EbOeQ+adcnv1ltwrXHV
	3fjP8NE1zVlXYlaNuTDDQA32DoXYx8/OOEIRhTT1ogagtpUiLXz8Y/IBB2nGeDWA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNDFj-00000003M6d-2QhI;
	Sat, 31 Oct 2026 18:52:28 +0100
Message-ID: <6276295c884e76ea3d0c3407c7952d8785b85e67.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 6/8] wifi: rt2800: set the mac80211
 fast-xmit and aggregation flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <stf_xl@wp.pl>, Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261031110608.GD31143@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
	 <20261029134752.1299130-7-hjf3108@gmail.com> <20261030091743.GB27096@wp.pl>
	 <CABOQOSX6mBCtTTg9eJX665t7tj65jo=9hVTgr7pmFRB6csG2Yg@mail.gmail.com>
	 <20261031110608.GD31143@wp.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sat, 31 Oct 2026 18:23:01 +0100
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-malware-bazaar: not-scanned

On Sat, 2026-10-31 at 12:06 +0100, Stanislaw Gruszka wrote:
>=20
> > I think maybe a more general patch to mac80211 to enable fast-xmit when=
 PS
> > is disabled and not only checking the feature flag will be better?
>=20
> Sounds like good idea to me, but let check with Johannes (cc-ed).

Can we defer that? I have some work in the pipeline that reworks the
whole TXQ scheme towards queuing ethernet rather than 802.11 frames, and
then eventually gets rid of most fast-xmit checks, because then fast-
xmit is basically just a header cache.

johannes
