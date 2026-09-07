Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7C3101D4
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793193; cv=none; b=f+pT1Z2y9CYY41HqZml5kED0uPyaSEOaABk78bCmyz5DUqq4D9SJE3G2cSxXhfbHRKyO2P/ti7cpzPwRsbngzfxEVxxg8dlErDTnac9oIwpXQn5r4qNrMd8qd1TcnD1i+mguzj1hjlqGmQf1wQzNO02MWvg2nX7eVsAt4oE/y8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793193; c=relaxed/simple;
	bh=zbnIss0FGh+N+DJnVZBUVNJDw5ZpLSCxXNul7nG76X8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J95jBob709Y090YCV521jRU8wO4JtJ99qX++j8XYSwTYB86spRUU6l6t/5uZk7yV8dWlskGYAumhLlR+lg9RFxUVeQihdzrLSsGpv3JneGx6UyXb7zJbdyh6BGkX9V20nqvRYruaIwtnMeD+zZt07NCXqaDKOOZg+Ck/JyKUvkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cA/R6Jfs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cA/R6Jfs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WxYZRv9ODU7zprOumsXdS+h334YL8M6xDB/R5QY4NlQ=;
	t=1788793191; x=1790002791; b=cA/R6JfsF9lhqBU6eU11I3iQMsl8BY4rBbmExe58vIBH8QW
	3v+tJfLRvUmrmod+cdzOcEGWymFXrbTv3hUsKZvgYT3zjCeW1XI3mZ7X1ebdscwj8i4T9UZzXp6GX
	DZVqe7X1awzIk4ruSZw1pXoWt3VETr9QIGAHpkKairo2E3qyqr6te9ezKWlRgayB72H+adjV+4UNd
	NpoiE79S3qtMNcYo/85PWY8ftwLEL1ByzLcu7qcCUrUZNonRY7FHIysuYbp1XMbEpFuGwVZU8bntY
	eTVktWFCWbaUtL4HA+0NcAqnXzcYJi3JtgTUnXBp64Jq0eiXjz06VTTGHhrHpVgA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3aov-00000004fKu-3HWX;
	Mon, 07 Sep 2026 16:59:41 +0200
Message-ID: <78ae8d5339fb26ec79f11661e68c02ad5c36dce2.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 0/1] wifi: mac80211: reset default-key debugfs
 after netdev recreate
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-wireless@vger.kernel.org
Cc: gregory.greenman@intel.com, miriam.rachel.korenblit@intel.com, 
	vega@nebusec.ai
Date: Mon, 07 Sep 2026 16:59:41 +0200
In-Reply-To: <cover.1788783312.git.zhilinz@nebusec.ai> (sfid-20260907_142729_116498_9C6A08A7)
References: <cover.1788783312.git.zhilinz@nebusec.ai>
	 (sfid-20260907_142729_116498_9C6A08A7)
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

On Mon, 2026-09-07 at 20:27 +0800, Zhiling Zou wrote:
> Hi Linux kernel maintainers,
>=20
> We found and validated an issue in net/mac80211/debugfs_key.c and
> net/mac80211/debugfs_netdev.c. The bug is reachable by a root user.
>=20
> We've tested it, and it should not affect any other functionality.
>=20
> We will provide detailed information about the bug in this email, along
> with a PoC to trigger it.

[snip]

Did you read what your LLM wrote?


>     	printf("[4/7] add WEP40 group key idx 0\n");
>     	err =3D new_key(sock, family_id, ifindex, 0, wep40_key, sizeof(wep40=
_key));
>     	if (err < 0) {
>     		fprintf(stderr, "NL80211_CMD_NEW_KEY failed: %s (%d)\n",
>     			nl_geterror(err), err);
>     		return 1;
>     	}
>    =20
>     	printf("[5/7] set key idx 0 as the default key on the deflink\n");
>     	err =3D set_default_key(sock, family_id, ifindex, 0, -1);
>     	if (err < 0) {
>     		fprintf(stderr, "initial NL80211_CMD_SET_KEY failed: %s (%d)\n",
>     			nl_geterror(err), err);
>     		return 1;
>     	}
>    =20
>     	printf("[6/7] add MLO link 1; this recreates the netdev debugfs tree=
 while the key stays alive\n");

Sure, WEP on MLO, but somehow debugfs is the problem ...

johannes
