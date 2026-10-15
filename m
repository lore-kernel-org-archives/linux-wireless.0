Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361251FCBD;
	Thu, 15 Oct 2026 12:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068879; cv=none; b=jddoJnS7FFZ8AKDg5E18FGT33xI5I2cWY9h668i7KpAVR4hZrbl5C3GUdsTNotwybc08tWjTLFQFfx8PrWaKjEwx87XVGuXHQ9BWdhbkbc4ryeYbKIMriVvJyB3jLcpLkOwfUIQrqnMgy0lgKLlRzwSweeZAn8C6/EOs+4z1kDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068879; c=relaxed/simple;
	bh=Vj+Ks2WpJd32vcgw6WagxzhHIqVHbI0rs33EKvZlLZc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FuX+6COqcWeJ00EsQ9U5rdETzRRauI2UOQsZgtwXFbdlTNbCc41ldbYOeqHcetRX2rfjumHBkLGsOGr8rLSXNJTEAICafMghUpcOjxuCWYmmwjIiSQhrcu9GJgghFKQu/82nW/UcshJ2+XzdUwQjmxBiK4nL/jawlY78EikQVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QCVmWfGA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QCVmWfGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PbtHM47vD37xRugiLgkVK73GPsLMSnus4Srt6/JuRtE=;
	t=1792068877; x=1793278477; b=QCVmWfGAV2rEnboyevEaUQU4CZKC7mtg4yD+Cc/LGFgKNVY
	wE1kaZgJnm8lKriA7Ol+u4YzYregeNFLHtxYerpdCflXjE5GaLYucMlOlRJWwbe6wI1K7BwvWGHbY
	uI8/nEPRY1/sj8S6YhuUUThmr7sF4zduce27lqjkipiHnlOPcA3JMHabls5bG8eF9NGhNE3lgR8LE
	n2ajFStMhp4+Nou2RzooowWdeSOqu7WhMW33Yk6hQRaps7Mje2qAbpKFXDjvrCznkv1TV5GTff5yt
	MUOiHVa5WD4O4DlRGaFb3KFwEGku+Tv2U3xDsXEySJnfi9iOMr22SlYV3/paPl1Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xHKyg-00000003bSS-0Zit;
	Thu, 15 Oct 2026 14:54:34 +0200
Message-ID: <7e95ff419f81425b9fa18c74f3a77208764751bb.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Hartkopp <socketcan@hartkopp.net>, Kuniyuki Iwashima
	 <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Oct 2026 14:54:33 +0200
In-Reply-To: <51e3f9ce-fa8c-4cdb-b5bf-d05f53cb52ac@hartkopp.net>
References: <20261007205827.467974-3-johannes@sipsolutions.net>
	 <20261007163616.1088d364@kernel.org>
	 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
	 <44cb773984f61ae85b8c42904ef1ce7a62e85e4e.camel@sipsolutions.net>
	 <51e3f9ce-fa8c-4cdb-b5bf-d05f53cb52ac@hartkopp.net>
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

On Thu, 2026-10-15 at 14:43 +0200, Oliver Hartkopp wrote:
>=20
> On 15.10.26 14:27, Johannes Berg wrote:
> > On Wed, 2026-10-07 at 19:05 -0700, Kuniyuki Iwashima wrote:
> > >=20
> > > Also,
> > > I hope we could remove the long comment in __rtnl_unlock().
> >=20
> > So I sent my next PR, and we could therefore do that now. I also checke=
d
> > across the other places in the tree, and isotp_release() was the only
> > one that seems to do something similar, keeping a socket pinned around
> > rtnl_unlock(), but I don't think that could cause a similar problem.
>=20
> If I got your claim correctly, I think we are solving this in this=20
> net-next PR too:
>=20
> https://lore.kernel.org/linux-can/20261015015336.816543-8-mkl@pengutronix=
.de/

I _think_ that's unrelated, but I might well not understand it
correctly. I was looking at the rtnl_unlock() portion, where that could
run a netdev todo item. Even with that change, you have

	rtnl_lock()
	lock_sock()
	...
	rtnl_unlock()
	...
	release_sock()

which looks sufficiently similar to

	rtnl_lock()
	wiphy_lock()
	rtnl_unlock()
	...
	wiphy_unlock()

that my search flagged it, but isn't really the same anyway. But I'm not
sure I understand the socket lock semantics and the socket notifier etc.
well enough that I should be commenting on this at all :)

johannes
