Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3E62BEC23;
	Sun, 26 Jul 2026 10:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785062007; cv=none; b=db6genHYpce68ZwtR1z7o6Oe5aGRxobnGSBYD9NtKvThdKSCQF3ajpmozMPgCQz3f1c1h0SnugsGzIHaakIMZqeG9s3+3sh2HlT0ytNWJlCdUiTU4ukozEMQ6xEK9YxRfoA15CjHOoSNSa/vYjUbWli/etqtm7S4PdWFjhybdWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785062007; c=relaxed/simple;
	bh=XVXyKzZBx24LOs6cE+LXcrqk2mNMPxD7cpL8aVCd5Og=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ggr7O+ucHMXuqkz3QuNjTAYdo68yZ1aUZEA6Wrgg1NUf3V7uirI/B1aOtaQaHG6PwOVGaIazSCZig3rEdDpIcmoE1YyNaeiVWvEfir8/UOz4wtCdzswoSMtI6pyRI+jPt7qnB1s5A9/pwP/o+i+jJhr6394qhzKISQqNJs0fhWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cIwlIG6E; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cIwlIG6E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zV0HRV8Xtdbd8JuQfKpB8a5pi2z217fw192NdKRGMyo=;
	t=1785062004; x=1786271604; b=cIwlIG6E+upNwBFx6hUEX1sfdsjAjblmctZizZllx/bkxca
	QiImddj/5wO2KqwLiUFcjqerjt89cwWzn33AtOhGyBc7eTh6NqeSW8HDMp3VlIvJNVSxjIh2yVhyZ
	B4F/5qGVlJmos2xrJWebIjGWDYGyrdS8eQN1Xb2RFs4BPm+CAXXdGwLKkqvXvEiGCuSz2DDfUJ3jf
	NNqjAlB0ZMZDfbcfv9kL4PJsZTSc+fT8GnmMGOrZ73kaCMbH6N2nh1zaorld70a6a4E2BhcVFBsc4
	/KloaU+IPSriSnmm5ToE9w4o4oTUqip2yHUwjHo8HW53A5zN2GP4Mbah8vu6nqyw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnwAU-0000000AZYu-2C69;
	Sun, 26 Jul 2026 12:33:14 +0200
Message-ID: <b99e4a1428546030b61883063b9542dd953a69f2.camel@sipsolutions.net>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 origin tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-next@vger.kernel.org, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>,  Pagadala Yesu Anjaneyulu
 <pagadala.yesu.anjaneyulu@intel.com>
Date: Sun, 26 Jul 2026 12:33:13 +0200
In-Reply-To: <20260723202153.97352-1-enderaoelyther@gmail.com> (sfid-20260723_222207_378983_9EE2E883)
References: <ac48f782-3fbd-4c61-89d0-4dd032ca81b9@sirena.org.uk>
	 <20260723202153.97352-1-enderaoelyther@gmail.com>
	 (sfid-20260723_222207_378983_9EE2E883)
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

On Fri, 2026-07-24 at 04:21 +0800, Zhao Li wrote:
>=20
> That last branch was introduced by 035ed430ce6a ("wifi: mac80211: avoid
> non-S1G AID fallback for S1G assoc") as:
>=20
> 	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
> 		goto abandon_assoc;
>=20
> f13e573ab3f12 ("wifi: mac80211: notify driver before destroying assoc
> link") consolidated terminal association cleanup at destroy_assoc_data
> and removed abandon_assoc. The conflict resolution retargeted this branch
> to notify_driver, but notify_driver only calls drv_mgd_complete_tx()
> without destroying the association data.
>=20
> Since assoc_status is initialized to ASSOC_ABANDON at function entry, the
> equivalent target is destroy_assoc_data. A successful S1G association
> response with no AID Response element otherwise leaves assoc_data live
> instead of abandoning it.
>=20
> > but that is immediately after another goto notify_driver, there's
> > further notify_driver error handling afterwards and all the earlier
> > error handling is return statements so it looks at least unclear what's
> > supposed to be going on.
>=20
> Other goto notify_driver targets are intentional:
>=20
>   - "if (!elems) goto notify_driver" is a pre-existing allocation failure
>     bail-out; so association timeout handles cleanup.
>=20
>   - The comeback path WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY keeps
>     assoc_data live deliberately for retry.
>=20
> A successful S1G response without an AID Response element is terminal.
> It needs to abandon association immediately, so the target should be
> destroy_assoc_data rather than notify_driver.

Actually, looking at this again because I was going to send a PR for
wireless-next, I disagree.

From userspace perspective, you're right, we could and perhaps should
abandon the assoc attempt entirely and send a "something went wrong" to
userspace.

However, from the driver's perspective, we're going to need the
notify_driver part, because we're done with the transmit/receive cycle.
Just abandoning it there would introduce a bug around this area.

But because I don't think (a) we should fix that in the merge, and (b)
it's actually very important, I'm just going to leave it as
"notify_driver". Sure, this means that for a bogus association response
we're going to try again (and who knows what the AP will do then), but
that only risks confusing the AP and potentially wasting some time
against a broken AP, rather than confusing the driver.

If we actually observe this in practice and want to get rid of the time
wasting, I guess we could add a path out that does both, but I'm not
sure it's worth it.

johannes
