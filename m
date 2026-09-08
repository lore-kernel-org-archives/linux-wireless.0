Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3D3AC0FA;
	Tue,  8 Sep 2026 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899281; cv=none; b=HJ39ExWM0qkU0KCpUabYnkA2dcuE92DCxN1OAMqfsuZ/MgxLVwy3vTM9cebM1ATEBTNsZW+COTUOwl1Kykat/i93WSQ5p6K3db1VSKT15si8hzZlfkjfkMnD01RTpKUNZVEPYsm49ZGzXB2WPQSP0ZWJtZK3cxRy8r9R95nyUU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899281; c=relaxed/simple;
	bh=6PGUsdWAJ5itb1tBxcAZFkYjuulVrO26ZhmGSsf2HB0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H25vD3ABIgJVtLybd5HouinF84uyD48IjBHuJbgAOj30IAuuw4KJ27Hf3kiA70XqpkHZyQWK0HICKfOfVgHnTwPXYacsDUfKmiLdl/E+Obi/deMJpye71oH+Zv9ui2PIn7Bd/QWiEOnNvY/cfKPXQupKlLFruopGhwTExSk3mJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bC/+sGBY; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bC/+sGBY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=E339hku+nsXigG6xS5eAMnOglg7j43G8fXIZZLMCQvc=;
	t=1788899280; x=1790108880; b=bC/+sGBYJcC3JnGbZeJFdGMDFD9qB04n05Jd2lVEFsQwvwj
	RhLMWZB1Ab82MuISeIBpRWKErVV+0yqSu8Qn/+db3yS+8Fx0LI3WTjj0OvVNVUQuCEGp7LoFHBk4R
	bqjOqYfqL7Lzr83F3kI7+Pc0SHNoVbbY2Na4IzzLf02WcurnbhbDS5LQ1tzZn8Y/Vc1b8zl/QxnhF
	6kxW8uY9zLjjcRNSEKb8+tKBOxHj+LmTiSdNLJ3inXDtaD3WO/dP5BeHt/13PMgGqiXb1FN25akWN
	lwVpXlZq9eNJAtWop3fTZuIzymd/kCI1e23ih4ocVMRvYzDmO7jFyAcqh7ncSkLA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x42Q5-00000006dMP-1QZK;
	Tue, 08 Sep 2026 22:27:53 +0200
Message-ID: <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2026 22:27:52 +0200
In-Reply-To: <20260908132004.29176fec@kernel.org>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
		<20260908125017.0fb226c5@kernel.org>
		<404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
		<80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
	 <20260908132004.29176fec@kernel.org>
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

On Tue, 2026-09-08 at 13:20 -0700, Jakub Kicinski wrote:
> On Tue, 08 Sep 2026 21:57:52 +0200 Johannes Berg wrote:
> > On Tue, 2026-09-08 at 21:51 +0200, Johannes Berg wrote:
> > > On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote: =20
> > > > On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote: =20
> > > > Why are you sending this To: core networking maintainers.
> > > > This is wireless code, what do we know.
> > > > Drop the core maintainers and netdev@ going forward please. =20
> > >=20
> > > They have patch 1 but I already told them a long time ago that was
> > > completely broken, I don't know why this is happening ... =20
>=20
> Ah, missed the skb extension. Obvious AI slop. Fun times.

"Look Mom, I can push a button, I'm an engineer now!"

Do we have rules? I'm currently refusing to read anything that has an AI
written commit message ... at the very least.

While I was on vacation the AI sloperators were arguing with each other
on the wireless list:
https://lore.kernel.org/linux-wireless/20260827074442.826644@enxio.de/

Can I ban those email addresses somehow?

johannes
