Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257985;
	b=D9hsoRXcw0LOlSJHptyQpFRZ8vcehONwkXv9JtIp6TQKNEgNUVQC9MYpNHTPybH+bXn6
	 /g/0P1YJrJjjqDCgAW6uPK6LoxndSv62jylzxrCwEaPIsGDVaJVTz0qU1JwX5YyzPf/Q6
	 CB1VS4ii5ZHEYuRLt5tFFXTuxM0euqp4nI05y6P4m3J2zMkaoZNNNzZdDGnkTBbG/fl2i
	 B1uL+492vxE8+PvWs2GeARBV2u/EPHsagvlmwwMTWBTJuohDaUBdEDffPqf90ssqqK3pe
	 qVGx/ZXlfKsPCk8BYaN2eKi2bAhZdpCj9iABLC7tkQ1R2SYJ9pYgchWM/NvmTIx6oYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257985;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=WimqeynmBXGGzLPxeEW5Wa98ND5Ah4K5gVVzfixyt4M=;
	b=Xq4Nbxg7HriqAb9iU9p+bhkNfbLGdRsIgoMY7ZepBSl7iHA6h+fcRIMSQT2WIxwU5VAZ
	 +Yx4GlkquTd5mNTUIZGXKzofHm4Ndrzmcgus5is6KEsWo4JmhKZZzxGHzoy1gKAFgS5vZ
	 J0BZOVJGWAVH43wqan+HTup2sXJYXzTBXYyf4BZu+QdrXUOq6584PFkxnoatCNqVvbnNr
	 jNo+Gmg1/MmvknYVxG1rt84mV62KB6cR2MnOTW3WNYlPWsYm8QyJFWMPV7GZSMMI/THDi
	 rjlF933pDVob3jezlg7IQi32atEtCa7IH6Rhi8OPeOvCJgKpNZ6KCEKjrGhb9vwMSRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="JIt/XitP";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA13D606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=JIt/XitP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WimqeynmBXGGzLPxeEW5Wa98ND5Ah4K5gVVzfixyt4M=;
	t=1793257984; x=1794467584; b=JIt/XitPZdQFeoQQZJRXebsgj1lP6PWgjn9UAlX+BvrK6C2
	sljUwv+QmsbA6/l5G16KCNa8nehEZ3J9797vnVJ3eULw6kM7UsPBHAWnzkgk4oijVJutHX9HyXf8t
	9KcNCwzokyKdAzgBPkrEitAVzu+F+5f/jBJTYqzsnBm6YIKV8d8pR0/KU2lIG2p8c2qz6k0sGdu12
	V0o7bWotgxqLJx3CSPIYevtKHbPfMzIMOYOF9JxS/EJo9duNG7K02H6XtXDR7Tz0/HZ5wypjKEoBO
	smbYaHraKkjYdsIjfVZrXDN/KEWCywsGu/5pF72nS68yd2Ch7XgJaajGxE9D2Aug==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xMKJp-0000000GUEh-3YhF;
	Thu, 29 Oct 2026 08:13:02 +0100
Message-ID: <2b4bd7bafad25b2f13973e1b1f486395615d0bbc.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 0/5] b43: N-PHY: fix calibrations on rev7+
 (BCM43228)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, Luca Casati <luk00casati@gmail.com>, 
	linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, b43-dev@lists.infradead.org
Date: Thu, 29 Oct 2026 08:13:01 +0100
In-Reply-To: <DMGOAJTSLTRX.3NHOMSGMQXH1X@gmail.com> (sfid-20261028_191212_602985_F54B2DE2)
References: <20261026181543.77763-1-luk00casati@gmail.com>
	 <DMGOAJTSLTRX.3NHOMSGMQXH1X@gmail.com>
	 (sfid-20261028_191212_602985_F54B2DE2)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-10-28 at 11:12 -0700, Rosen Penev wrote:
>=20
> For all of these, Fixes: tags are appropriate. They help linux-stable
> pick them up. Meaning that wireless, instead of wireless-next is the
> more appropriate place for them.

For the record, you could listen to this guy who, by his own admission,
is nearly banned on netdev and seems to revel in the fact.

Or you could continue sending patches sanely. A decade(s?) old
calibration issue doesn't really count as urgent in my book.

johannes
