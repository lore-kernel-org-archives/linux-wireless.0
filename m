Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D0D30C168;
	Fri, 26 Jun 2026 09:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782464697; cv=none; b=sHrtiuWEmI+EcpZ48bFZtSFcqhu3iawkvHqbfLXDBC/agu69X5Nb6lXqV72SxWbIVeooh+/724UU/9bIs7ghHyvnSPSTAxrdGg9GdpRPBWuJ45Q2PTdR0kzyWwtBbDcJj0GAXFl2G0arTWHj/SzqljgqN1UJ5ODkNGu3toGkKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782464697; c=relaxed/simple;
	bh=xhKMx7fneCt45U02pHJWe6Qs7ZPoHihiDb8p1Vxqiik=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qf8olWU+jGnuRn+4zSSYGNHb+03RckunJEevh2sGTbs1Hp4YbGPchVpXZXDfhx7mOzqQsVwGx4d1cxBD7aiINXy6kt6heG7FUYUZKj16x2fb8Btum/Lf2J9/T986KMxWl6EgPQsQE2C5n9BEFRwlb682PptV117QvoiB0/CpEro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qO7fz5S1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qO7fz5S1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hte3vjAzJ4brTzseVp1La6QRMHdGwUA6jGROLVkBg9I=;
	t=1782464695; x=1783674295; b=qO7fz5S144YYEa8X5zhYurcntD8BOPCDi4KX5UbBoY2RRRJ
	U3Y3ffFugCYqXLFw3YIDcIoqtCrfHjKs+hufD35mFMUYpVvLP+tHLUXL/X47BgaVRpC+/68EWOlOm
	faBpMQpa7hv27uVbsQbame7DgpdguFWVZFcmdXRgvpldb8pXDkic4DyOo4kRHBAQaZrHU7hQRLglS
	+o6X9u3i1GdnRvd3MOkbn9Cxcy21XRIcwITTAlItH4vFtL4jkBKrF0hTOeTFLXw8u8kCYn3I0p2KK
	R2OdF1U0NR6Ij6HZC0ygMXFT6ECC4v6QRb8QspYKn2MpHU6plHxigocoi3Za3Fkg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wd2UW-00000005Ejj-1foy;
	Fri, 26 Jun 2026 11:04:52 +0200
Message-ID: <da2c4e2396697d3c245a3a0cf35d8d9a6b24981f.camel@sipsolutions.net>
Subject: Re: mac80211: MLO link removal frees link RX stats percpu without
 RCU grace
From: Johannes Berg <johannes@sipsolutions.net>
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Jun 2026 11:04:49 +0200
In-Reply-To: <20260626080158.3589711-1-maoyixie.tju@gmail.com> (sfid-20260626_100204_586946_E725C9D9)
References: <20260626080158.3589711-1-maoyixie.tju@gmail.com>
	 (sfid-20260626_100204_586946_E725C9D9)
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

Hi,

> I think there is a use after free on the MLO link removal path in
> net/mac80211/sta_info.c. The link RX stats percpu buffer is freed while a
> concurrent RX softirq can still write to it. I would appreciate it if you
> could take a look.
>=20
> sta_remove_link() frees the link stats and defers only the container:
>=20
> 	sta_info_free_link(&alloc->info);
> 	kfree_rcu(alloc, rcu_head);
>=20
> sta_info_free_link() does the free right away:
>=20
> 	free_percpu(link_sta->pcpu_rx_stats);

Funny, I was looking at this code just yesterday for other reasons.

> So the container waits for a grace period but the percpu stats are
> reclaimed at once. The RX fast path runs in softirq under rcu_read_lock
> only. It resolves link_sta early and writes the percpu stats later:
>=20
> 	stats =3D this_cpu_ptr(link_sta->pcpu_rx_stats);
> 	stats->last_signal =3D status->signal;
>=20
> A reader that resolved link_sta before the removal NULLed it keeps the
> pointer. The container is still alive from the kfree_rcu, so the read of
> link_sta->pcpu_rx_stats works. But the percpu block it points to is
> already freed. This needs uses_rss. That is when pcpu_rx_stats is
> allocated. The trigger is an MLO link removed over the air through a
> Multi-Link Reconfiguration element.
>=20
> The full STA teardown does this safely. __sta_info_destroy calls
> synchronize_net() before sta_info_free() frees the deflink stats. The MLO
> link removal path has no such barrier. That path was added in
> cb71f1d136a6 ("wifi: mac80211: add sta link addition/removal").
>=20
> I do not have WiFi 7 hardware. This is from reading the code. A small tes=
t
> that frees the stats buffer and writes it through the live container trip=
s
> KASAN with a slab use after free.
>=20
> Does this look like a real use after free to you?

The above analysis doesn't look _incorrect_ to me, though I think
between uses_rss, sta_pre_rcu remove and how drivers tend to work
(though I can mostly speak for iwlwifi, and ath1[12]k also have RSS),
it's going to be pretty fairly difficult (if not impossible?) to hit in
practice.

The only (relevant, real RCU) reader is rx.c, which requires fast_rx too
(not all that relevant I think). During STA removal, both are removed
together and we always have to have both, so I think it's mostly OK.
When the driver passes the STA it could still be an issue though, I
think?

During link switch it could be more of an issue, but then it's MLO and
we require the driver to tell us where it's receiving, and it wouldn't
receive on a link that was just disabled, so I don't think you'll hit it
in practice here either.

> Is the right fix to
> defer the percpu free to RCU, like the container already is? I am happy t=
o
> send a patch once you confirm.

I think it'd be better to combine them and free the link with data after
RCU, rather than bumping each to RCU separately?

johannes
