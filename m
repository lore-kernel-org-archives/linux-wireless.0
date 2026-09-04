Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226130D41F
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 06:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504980; cv=none; b=tmBKG4i51vkQuzoJxzel2ZDFGU4Yq5c6Aq4WP29ZVLTlvR35XYNPWNBR2Cf9+h3C74kDTWd4INHqk3/IoJUnqDXyBGLSr7DIDsp9cw06ptsYMRoC0VM1pvNxANH96VsWNYh+AEgJa13qgy7BDBd/mahXzdb8Dy14rvORuk5J984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504980; c=relaxed/simple;
	bh=cgWlkURpbAiVTeyrgiFsQaj9VdjUNFDt+UPizZGS9uQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BCJQtj2Eekqf3VHooksJ1DnjAxekgWpx6KCe4HkyMWsDoAldqmDRh0OkJHOo5zE2ZE6mc2JH9iM4DBN2NVemLfrnSIO3ZhVCcRa74ETR8bmu/HEQv0GGtj5oHa9gzx22AiHOpwH4yUx6yPMksuEcHZwBM8skp0PVOQjKFq3ftKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u96/Zvtk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u96/Zvtk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=S/Qk7fuIqKR4PAPugGr9W//wBhW1G+Ji2zXvPBw6oAQ=;
	t=1788504976; x=1789714576; b=u96/Zvtk+Uprpd1mCyHxv06fVmkZB8d8wDGLR4IcqmXjOSE
	u6Jydoh5OnaYN2iV++m7roLePhYXGoSsOrXDZhmF/VeSgbl9+/PSo5I4ADH7d91WHLyGSsk0GtrsZ
	yKKCN70KLzjTYk/cR/akYk4ZwhDqXrGWyb+sGtOYgaodiSkQ4YchkpI+ATRMSDhxcwWGnCPwLEwqh
	fMCoRr213gJB4z7TziXtndxjrDl5N2FA5o4t1jWJ+w7wXeJbncT4crRo5GQe5OQPo7chfiq0mRcYC
	Byf6p4yKDLJQPRSrls0ApMdGoDo0AtVKC4SKPcTn/0gktbocp6cEkjtjTDiHp3Qw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2NqP-00000001DjI-3Oh7;
	Fri, 04 Sep 2026 08:56:13 +0200
Message-ID: <2476da0c8b837dba5750f7a556d9bac2387a9c59.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: queue frames while off-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 04 Sep 2026 08:56:13 +0200
In-Reply-To: <20260820131217.21824-1-stf_xl@wp.pl>
References: <20260820131217.21824-1-stf_xl@wp.pl>
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

On Thu, 2026-08-20 at 15:12 +0200, Stanislaw Gruszka wrote:
>=20
> The change depends on the iTXQ resumption handling introduced by
> commit 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
> and the wake_tx_queue support introduced by
> commit a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to drive=
rs"),
> so use those in 'Fixes' tag.

That doesn't really make any sense, IMHO.

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -267,20 +267,14 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data =
*tx)
>  }
> =20
>  static ieee80211_tx_result debug_noinline
> -ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
> +ieee80211_tx_h_check_offchannel(struct ieee80211_tx_data *tx)

I (vaguely?) had these ordered by execution order, might make sense to
move around and try to keep that.

>  {
> -
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->data;
> -	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
> -	bool assoc =3D false;
> -
> -	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
> -		return TX_CONTINUE;


Not sure you should remove that, still you want injection to go out?

Not sure injection should even be queued - maybe you do want to send
while scanning on a random channel? Or maybe not? Maybe someone depends
on that behaviour? Or maybe not? Kinda hard to say...

johannes
