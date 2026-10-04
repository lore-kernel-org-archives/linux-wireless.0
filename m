Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9833F54C4
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 20:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144679; cv=none; b=LxuVwdB71fmywpeoSvAuhgIXBzuUIM3Df4EEUhdakw164nSQcRFliuwWnVYuzjG7mSRBK0BGaxW636tTqGydRW1/vcXKhUgTy8L0aKEPB5Dfla33yJXzl7w9ZTyyz6jNV1ie4TurWC6fOfisdk4CsPg3SHte+iGqzIjJiZRnPT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144679; c=relaxed/simple;
	bh=LLOkn0+G94RKjf6YHFK9L4Pnw0NtPwMcFFF3c5IghqI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cDg6661LYSROGrDVwcgV6n6UFfOR/sztpgyZB1X4nPXDldpuCPgEoNNNtz7CjwGJ4hmFsLEpvDRolxAO8fl+EdM3wuuaxhCDucPzDtS8cd35T4MNTp1MO3hWXFC46avoxvb4VXpZVzpHHr77BQBolx210eaaRGcZ9eojQ4C9HAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xVCZY78j; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xVCZY78j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6Gg0kE0KqBWiA3jybB99zBhEw2kK/hXZxJeAOB8U5QM=;
	t=1791144677; x=1792354277; b=xVCZY78jZj/tlJVVG8HkLz9obk8vXiXJK7XDkpTGSKToLyM
	ne2cfSuEwWILcYUHAvx3jR5/iNKM9YELOGtc+H5e/Gz5PwLWfqtPnjQrLIpXGH0T7OwauUKmhGKAz
	ip3wVVjJVxg/8GRvUOHALdN3rbJiJts/S16lomy6Tdx5y7f3FE9h20kunZtuqvtjnH4GnrtcL/JsS
	sQ8vtEsVCY0jNNYsFjlwOA2k8mgWoMImPRzssXAl3J/Nrz1toxcTbyw3AOuuMN7JLbqOeu5Xup1mn
	j+7HuHGWAjd7/74wgoo5sogBDzkTOlTB3/bOqAev3ykPdsCLwvfkBLt40ymxKihQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDSY8-00000004MAU-2FDU
	for linux-wireless@vger.kernel.org;
	Sun, 04 Oct 2026 22:11:08 +0200
Message-ID: <e326af8e0b64b477359fbb5576130451179a2b82.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for
 commands that don't want it
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Sun, 04 Oct 2026 22:11:07 +0200
In-Reply-To: <20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
	 <20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
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

On Sun, 2026-10-04 at 21:01 +0200, Johannes Berg wrote:
>=20
> @@ -19703,10 +19795,8 @@ static int nl80211_pre_doit(const struct genl_sp=
lit_ops *ops,
>  		if (internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
>  		    !wdev_running(wdev)) {
>  			err =3D -ENETDOWN;

Ohh. Nice race - possibly only in hwsim tests.

hostapd can now react to RTM_NEWLINK so quickly that this rejects the
calls - previously we took rtnl and that avoided seeing !wdev_running().

I'll fix it by inserting an rtnl_lock()/rtnl_unlock() here:

> +	if (!need_rtnl) {
> +		if (rdev)
> +			get_device(&rdev->wiphy.dev);
> +		if (wdev)
> +			wdev_id =3D wdev->identifier;
> +		rcu_read_unlock();
> +	}

of course only if it needs NETDEV_UP, wdev->is_running is false and
netif_running() is true - that'll wait for the notifier to finish.

johannes
