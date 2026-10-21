Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577672;
	b=1s/7SXGuVoh2DSHGj0oFhwXkikVicYCfT3jBX7COUa9j0UQCi6LKRwT/UFAXnAiSI3MX
	 h+P3MdcCOmNZlPsEwZq4hh5wZmyO2fqwPv39fGX5NSXU8inI5oy0jeR8pmyzCSW7Uxxtv
	 EBuz8jsqtkURgRScJBeMq613kYgL0O/apkhkNgpSyI5Yo6ywlXMqzCE1YWQNk+kJhT1Sb
	 3iTA5Bs05aBKXkfVQTlamJv3wIqXWZKRRBLbbRggMhJRD5aFbu6pekWPLBYT55v5Q5E0v
	 cCpvOmOJXMp29PMB3r32zwu2rzGbdlZxGa9FlJE50x3Kwr26D2HGds+4xEaCTb/Zrdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577672;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-malware-bazaar;
	bh=BDN+UiwX4dBEBh5y7D0QpWF83D3+WwbbbxuOce4C+bE=;
	b=U+6FLcv2EbiD5HLN0DXxh+SWm9cET7sAqZnPzVvhBrV6JG+p0RgyNbX4jzFgpWdvE5oE
	 5u8SjoMv8Lq2DTGEkPb43Sw9u0UP+pLKiC3+55aTNafxcGOqzacGmj2+aGAFcSe5uBR9Z
	 DURJfBWg1DgkcvGzwZF6ot9qD2yVQlFtveUcVC2dJhAtLRa0Wbc7tQT90kSOoao0vlc6H
	 xaUXVG2qbebdr178b5xmH+Aroacs173w4FxvlBAkdWJzYNF4z1eyVNEvV53fGDOtGJitN
	 6FUCvg0E4kpd7Ih9zFxxUFGgUqepAql4FGcAfwH5oPvsaV4M6Vud3ky2BdXeeko7xvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=cZmE6n93;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB4606A31B;
	Wed, 21 Oct 2026 10:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=cZmE6n93
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=BDN+UiwX4dBEBh5y7D0QpWF83D3+WwbbbxuOce4C+bE=;
	t=1792577671; x=1793787271; b=cZmE6n93awAVmHUc5kRk1v0ic68Nn213CA5wPqQUYN2EDJF
	SpP18fACXepNjm4ZTRFkJAwkaJTlaAhOTlCTDvQcDFCAEggd6DWaLHJZ2RjKjN2mwL++qwYzSvl5c
	rui7Hu0+l2O4Arc7jp3K8AbZSjWcfjdP62GUnIGQuvHbcK/DO3CKAuj5frlgWnQl1cIZbXr3on/Kr
	wbAucCvsD6HLIrSNUtBbtmCiAIqykb1GFbP7YMusVu3mcbauL4Ska+Di/OrdFg70QoU+Hk3DFomk8
	4cnGnuljg3QmyJcqT34zfhZ9mq8ZBEcS1Pm6SEbe0RwRmuEweJM7dBngJbSZLzvg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJTL1-0000000243u-3m11;
	Wed, 21 Oct 2026 12:14:28 +0200
Message-ID: <e0875c5e3a36835a3d41aa99d0f4de66b721f9d3.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: zd1211rw: unwind failed interface additions
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiale Yao <yaojiale02@163.com>, "John W. Linville"
 <linville@tuxdriver.com>,  Daniel Drake <dsd@gentoo.org>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2026 12:14:26 +0200
In-Reply-To: <20261019013211.1489233-1-yaojiale02@163.com>
References: <20261019013211.1489233-1-yaojiale02@163.com>
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

On Mon, 2026-10-19 at 09:32 +0800, Jiale Yao wrote:
> zd1211rw stores the vif and interface type before programming the MAC
> and receive configuration. If that setup fails, mac80211 does not call
> remove_interface and the stale type prevents another interface from
> being added.
>=20
> Clear the vif and type and restore the hardware MAC state before
> returning the setup error.

This is completely crazy. "I have an LLM and it found something that
doesn't make sense to it" is not a reason to send a patch.

Does this actually matter at all? This driver only supports a single
interface anyway - who cares about the hardware state when it's going to
be shut down right away?!

johannes
