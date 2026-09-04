Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9113F074A;
	Fri,  4 Sep 2026 10:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517150; cv=none; b=XJVbIUdD1Ywv2eTKGuT2DORb/2qGtvCy1Tj+wrftR0TPI/j2DXahCJE2EVugHkXcG7ZeuEAAJsRZCsJd8biTZ4UOZGoCGNVaZodBwcty1VwII1QJNtnyCG2FP5u/gS+MS1+o/nsJd5Eq23ORDZUgbr15bcI3V9gpWnr4LtxvDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517150; c=relaxed/simple;
	bh=4wZ/5nCaJz3F5oP0m9Iecc3mS8QoHMXl4WMwrVGsOQI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BxwMZqBbU+kwiPdnQTXpmzVJet4D+ao8x0J7Qkgeg7cSKAN3pNzoQtd/T8xqL0RjlYRdRSf6a+Yu9YpO2GXxVZZLSmDrUk57JyIYdBsKbfZig1KOpIoT6sxt6vJA09tkGSCZ5sjU93bnQsO1GP0ADRxPX5w2CnrjM3E1NekS0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nPv+tcw+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nPv+tcw+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=68pzRNsYJaP2rQ3iuG1Ri7/9ObcoO7zaiD1kxsjnUpM=;
	t=1788517146; x=1789726746; b=nPv+tcw+miVge+7agITL+l3mFwiU8MkWaeqvPdkl67W34lu
	O9BHz/6XRW8HAhkt6r2mQXnQ5vpiFKObN8hFeoC5jXW5iKU9a1aYWq202aNY70LGkffgl0FGACHc6
	enZjrACh3gJ4SW/4wHDKlPZaoFvBoC+aQJFzvs2GtjEd9rdL1WQ5AW+obMw6EyhVczxzknx5SUwRC
	XIqJdANcFAeIHV4s9bM6WSGLu8Lo4ONXMfaTpNT/3dERMgV6unSYLgtup0bSRx6PrR+G35Dxf53tz
	jQfvF9tshftOZPA+n8K2z8L0m6ZpaXb2ADB9LIit+U+73OdJuR/jg/g627ygrXow==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2R0e-00000001KPO-24AE;
	Fri, 04 Sep 2026 12:19:01 +0200
Message-ID: <efe435ed41cd5943a3fd60901d90f2e2087495a4.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: mac80211: refuse to make a monitor
 active when it has no queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 12:18:59 +0200
In-Reply-To: <20260824003656.27049-1-lucid_duck@justthetip.ca>
References: <20260824003656.27049-1-lucid_duck@justthetip.ca>
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

On Sun, 2026-08-23 at 17:36 -0700, Devin Wittmayer wrote:
> commit 8105f9b8a887 ("mac80211: allocate TXQs for active monitor
> interfaces") reserved a TXQ for active monitors, because drivers using TX=
Q
> expect every interface handed to them to have one.  It covers only
> interfaces created active: vif.txq is assigned in ieee80211_txq_init()
> from ieee80211_if_add(), and cannot be added later.
>=20
> MONITOR_FLAG_ACTIVE can still be set afterwards.
> ieee80211_set_mon_options() refuses that while the interface is up, but
> while it is down it just stores the flag.  Such an interface then reaches
> the driver with vif->txq NULL, and ath9k resolves its multicast node's
> tids through that pointer unchecked:
>=20
>   BUG: kernel NULL pointer dereference, address: 0000000000000066
>   RIP: 0010:ath_tx_node_init+0x49/0x170 [ath9k]
>    ath9k_add_interface+0x10c/0x140 [ath9k]
>    drv_add_interface+0x54/0x250 [mac80211]
>    ieee80211_do_open+0x32f/0x800 [mac80211]
>=20
> Two commands from a user with CAP_NET_ADMIN reach it:
>=20
>   iw dev <iface> set monitor active
>   ip link set <iface> up
>=20
> The fault happens with RTNL held, so it is never released and all later
> netlink operations block.
>=20
> Refuse the promotion when there is no queue to give.
>=20
> Fixes: 79af1f866193 ("mac80211: avoid allocating TXQs that won't be used"=
)
> Cc: stable@vger.kernel.org
> Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> ---
> Reproduces on mac80211_hwsim, no hardware needed: create a monitor, take =
it
> down, make it active and bring it up, and the driver gets a NULL vif->txq=
.
> One created with flags active gets a real one.  With the patch the first =
is
> refused, the second still works, and an interface created active, set to
> none and back to active, is still accepted.  Same on an MT7922.
>=20
> Only drivers advertising NL80211_FEATURE_ACTIVE_MONITOR reach this, since
> cfg80211 refuses the flag otherwise.  ath9k, mt7603 and mt76x02 deref
> vif->txq unchecked.  mt7615, mt7915, mt7921, mt7925 and mt7996 test it
> first.
>=20
> Where it faults today, refusing costs nothing.  On the drivers that check=
,
> I could not test whether a promoted interface actually works, so that is
> where a regression would show.
>=20
> Reserving a queue for every monitor instead would make the promotion work
> rather than refuse it, and would also cover a passive monitor reaching th=
e
> driver under NO_VIRTUAL_MONITOR.  That undoes 79af1f866193 deliberately, =
so
> I did not assume it.  Happy to write it if you prefer.

I really gain nothing from reading LLM output all day long.

The fix seems legit, but please don't let LLMs write commit messages and
comments.

johannes
