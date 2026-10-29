Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257312;
	b=cspoVEYo7hJf9dU66m/wBJiR9N/1gF24PYYz6z8Vx8Ewa6W0pl9D8/Czkd4bDAqohTSD
	 6Mer+w6TRJC5yZOUP2pPMEqat+c6lwM2edCRVxfH6G6nT01SXjkcj+5Tnupn8JZe9YNOm
	 EuMVkFs22vz1BWx+3XapWSBOA3p7hyJMv37bNSMMa0Cej513aXKCJR0ba8fCaypmnDH16
	 AZl/j8pY96Q02NeXRAR1Ib8P6/gzUXdw57Irq/mR4epUpIfpZi2652t4zb4ah6SoI3Svl
	 c3Iu7H3bZzUFNQM2shalp9wcJlis8T6SiFWYZjYx6WVlDeTHY8i3oDPhLLTGJTYIMmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257312;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=nNh3+dC51ICKXx1gM8EqsdzIHJ7uG3P40rm777hpDF8=;
	b=p5rDlM4u7mNK7vblbdO/FfM+BpVeZp+z1rPm7CYzNag0C9BfQ+4TqSknbDWoRy6NfhgF
	 m0zhNn6u4xRx9Qe98iJVgcbHfoxO4L4/f2BK8ojn4IFu6h5MhradvxZbArVQlxcImJaHh
	 SYICdKc6TvwH3sLaggQsDduxnNk+WSynNeAm6FsVMoJ7RnfOD0UFlUAhe3/YXHLMTTpqf
	 u2lk3fYDMTwG5oZ97iMieD0DI8Wc1J/HkgRlhCCZaCbUnUBHQymSxerYV4cbU0osSyXU8
	 pu5gkF0DfeD/vLkKAu8uO0eFSsavSr65fjWOHmcpcGv7H+Phe8hCnJP2sS+xu7LjaJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Fzs433BR;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7B4606A31C;
	Thu, 29 Oct 2026 07:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Fzs433BR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nNh3+dC51ICKXx1gM8EqsdzIHJ7uG3P40rm777hpDF8=;
	t=1793257310; x=1794466910; b=Fzs433BR/NyYwt90J3zxwCsXO7P1DBK4Xmy3maspPZKLOwc
	762UbDspsHeX71TeG3Azj30cM9shbnEoQj685UjH2bby4mMwrYA3cfmPEjSZpmflzkwSjmB3bJJ3i
	jWZ0CbpWHtrx0HyJx8sDhn2PO8cZGnE41KUpzYA5IWdK6x7u3ij+6CtWHUoD1vqfReq4DvlN9ouyF
	xfR9+V9Y6QKkPIjfjqzfmdb6BclVuXc4HZl4KMf9lZuuR3TQBRFX5HPkjUmCWXkA6iE5nqpMqMboN
	tmL4m14ZKyswNuTW0Xv6/gn6rj1gd7IqM18Kt4/HAlv4ZQ/fzffp6NFlivZkf5Lg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xMK8s-0000000GTTs-2BMV;
	Thu, 29 Oct 2026 08:01:42 +0100
Message-ID: <0198c9f52e6a4e3ee63ed6b9ee5c86673ef2e6f4.camel@sipsolutions.net>
Subject: Re: [PATCH wireless v2] wifi: wext: Limit notifier event flushes to
 the device's netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kuba@kernel.org>, Cosmin Ratiu <cratiu@nvidia.com>
Cc: linux-wireless@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>, 
 Carolina Jubran <cjubran@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 netdev@vger.kernel.org
Date: Thu, 29 Oct 2026 08:01:40 +0100
In-Reply-To: <20261027162710.34e0e17c@kernel.org>
References: <20261023081044.728500-1-cratiu@nvidia.com>
	 <20261027162710.34e0e17c@kernel.org>
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

On Tue, 2026-10-27 at 16:27 -0700, Jakub Kicinski wrote:
> On Fri, 23 Oct 2026 11:10:44 +0300 Cosmin Ratiu wrote:
> > With mlx5 netdev instance locking enabled, registering an IPoIB netdev
> > calls the WEXT notifier while holding the instance mutex. Its call to
> > wireless_nlevent_flush() takes net_rwsem to walk every namespace,
> > completing the following lockdep dependency cycle:
> >=20
> >   netdev instance mutex -> net_rwsem (read) -> GID table mutex
> >     -> event_handler_rwsem (read) -> netdev instance mutex =20
> >=20
> > RoCE GID enumeration takes the GID table mutex under net_rwsem. GID
> > updates dispatch events under the table mutex, taking event_handler_rws=
em.
> > The IPoIB event handler takes the netdev instance mutex in
> > ipoib_queue_work() to traverse child interfaces.
> >=20
> > The all-namespace walk originated in the single global worker servicing
> > per-namespace WEXT queues. The ordering fixes later reused that routine
> > in netdevice notifiers to prevent delayed WEXT RTM_NEWLINK messages fro=
m
> > following RTM_DELLINK or reporting stale interface flags. A notifier on=
ly
> > needs to drain the affected device's namespace; there is no reason for =
it
> > to walk and flush all namespaces.
> >=20
> > Pass dev_net(dev) from both notifier callers and make the flush helper
> > operate on that namespace. Keep the all-namespace walk and net_rwsem in
> > the existing worker. This removes the instance-mutex -> net_rwsem
> > dependency while retaining synchronous flushing from the notifiers.
> >=20
> > It may seem strange that the fix for a lock cycle across multiple
> > subsystems lies in a completely unrelated part of the code, but this
> > seemed the most justified lock cycle edge to break.
>=20
> If Johannes thinks this scoping is good for other reasons - SGTM.

It seems reasonable, in truth roughly nobody [1] ever really runs WiFi
in network namespaces.

[1] except security LLM-babysitters trying to prove certain bugs are bad

> But my knee jerk fix would be to skip all the wifi processing
> for ops-locked devices since no wifi device is ops locked.

In wext_netdev_notifier_call()? I suppose these days we could also just
skip that for non-wifi devices, somehow.

But it's much easier for me now to just take this patch (in fact I
already did), rather than try to break it in other ways and have Cosmin
go back to test it. Maybe we'll just do both, the latter as an
optimisation, we can likely do better than "ops-locked" as a
discriminant too.

johannes
