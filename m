Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB52837EFFF
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516998; cv=none; b=b5AOwmIRxb1PAlEHVAf9y9hixSpcti3trNMuNfUFhRBRXtWhmpZodi8jk18EFHNHgrwIhDMT1fLRA+6ZvRrJmzJPsZ1w+J3om1M42GVcy7f9wuhN8+vcsSYWiai2iNKb0MWGqPpokrW0fJfx+QAE+RrdRhStR+AajWMRLiLHiIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516998; c=relaxed/simple;
	bh=8qpuggiPxb5agCZJoL66jt34Vabrq3L+JR+yypsf5BY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YsOeLVQVCC4D3rf4vWJqZiyiW5sIYSv4fMsT84Qkzu3yQNB2qZTHNYcQRj5VZ9dz01/q5qXLdI4ILzj6qixXCpIBl5smtMNyiHns+/il7jZ0SX6e35CjxJzZ1gy0ckntUaBD/xn8oNepjquXP88/6ch13L6NzfBQk/RWaklFMwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=arXdFov7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="arXdFov7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=r/LlU7HD5Cz+2il28JuOtKYaBhnu1yqTKMSU1unBvYA=;
	t=1788516996; x=1789726596; b=arXdFov7SWYnHpyHaPkEDCMGSBk3lX/vqeAvsfqh4yBLPMq
	7TaN9esBMjrSbzNVnBnnJz9OuU1cUCabWIYi7X4KRRtrdD7KH0aVgbvqrjLRGg4vjUQc+YovmKvh/
	dx2IiauB6NV9OHBz0RFzLhUOnWOsfY7NUD2qohX+pik+YyvllV7r4AU9X3YvE3gt+jfhoUJJ8AFjE
	IMHY2D93u5bSb9xhI273ivv+9NSgWfq8bCHj43WJ0Y9mLe8cTDwmcri/eGZo/Y3d5+M0Ntgw7WA0E
	4/CIwFs9WwHaQy5jTucJ6jfNzNwchzXdGCErjNQTQ+zYYj/NDDIYofzps1FXMdxQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2QyC-00000001KKx-0m8N;
	Fri, 04 Sep 2026 12:16:28 +0200
Message-ID: <63ab746686edee2e7919edb1cf6c5ce06e9999d0.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 04 Sep 2026 12:16:27 +0200
In-Reply-To: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
References: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
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

On Thu, 2026-08-20 at 21:37 +0530, Manish Dharanenthiran wrote:
>=20
> +++ b/net/mac80211/cfg.c
> @@ -1138,7 +1138,7 @@ static int ieee80211_set_fils_discovery(struct ieee=
80211_sub_if_data *sdata,
>  	struct fils_discovery_data *new, *old =3D NULL;
>  	struct ieee80211_fils_discovery *fd;
> =20
> -	if (!params->update)
> +	if (!params->update || link_conf->nontransmitted)
>  		return 0;

So why shouldn't we just reject it?
=20
>  	fd =3D &link_conf->fils_discovery;
> @@ -1173,7 +1173,7 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee802=
11_sub_if_data *sdata,
>  {
>  	struct unsol_bcast_probe_resp_data *new, *old =3D NULL;
> =20
> -	if (!params->update)
> +	if (!params->update || link_conf->nontransmitted)
>  		return 0;

Same here.

johannes
