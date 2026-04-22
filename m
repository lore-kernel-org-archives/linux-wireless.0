Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47F52D8DDF
	for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2026 21:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776893196; cv=none; b=Txb2oGewvm7lE3P+GjfRLElkP6wIvGekzFQng7oA8vLRHMbludownGdWl9SxABa6KkVeFH5KCQCg7yV+0S86kUXGZ0cP6Vg38wu75isdDnDaQO81x657l5itoFmRtdsiyUVKySNrA7nNOMwkr/R5aNAX6ZaPiCfRFttfCOF1hIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776893196; c=relaxed/simple;
	bh=9pwkexW3cJtVROSOGAqIDAeZRkbN2tOAeKiDqYkdzTs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YK9/r07qhgqF0IJUFa9J0y/c+9RPSqSuJXrjfFHYrpLuMfqm2FIZHDl1NzAF8fbIuupNdSXIikJnnE/1fNuQLyjLKZYLlzHNJCj00EX2rOcW/erfaxDBrOZWoi3mjjM5utAL3Xk7qv6/NbraLnsPcAzYhpKvmsUDz+9cmdSI9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v06kYt8/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v06kYt8/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=rT4kQtu6K4GyZXYm8FKO5pqPPMiX4F9dNAfEdIGivEw=;
	t=1776893193; x=1778102793; b=v06kYt8/1za9giZg0u2N5z8BbyRs+5Tr0FWRy1imFf48vxC
	8wUCNSrSlpfN5TVigRCtn9zfgyoh9hvT7wI2rEb/zkeVOa7Z5GI6TJCy/RVelD0j5pAAr2KEzm41V
	7sFiDPfyYbC7icNnp1AL1ZOy/PugBUOjUlwghz9eIrXwj3EIXFT2G5gqHV6gjuPliOdbo1Bkq0uvF
	PbL+8oeuuTdoPD83FVo12gRpQVMlBGI4Uu343dWCP9RY3k4j2eNkyXxsco0vszzpTGY+NS5V2D7Fq
	OEN6h1esdk4on11vFhbtWqAC9/fVNLOvu3tJ2444Y5vkZxkiR8uquQNgeGIqhcNg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wFf5b-00000006WMc-0Hlr;
	Wed, 22 Apr 2026 23:26:31 +0200
Message-ID: <385e7ded5eea5896ca2fae92e5d7de9c3e497f6a.camel@sipsolutions.net>
Subject: Re: [PATCH v3 1/2] wifi: wilc1000: fix integer underflow in
 wilc_network_info_received()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tristan Madani <tristmd@gmail.com>, Ajay Singh
 <ajay.kathat@microchip.com>,  Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-wireless@vger.kernel.org, Tristan Madani
 <tristan@talencesecurity.com>
Date: Wed, 22 Apr 2026 23:26:30 +0200
In-Reply-To: <20260421135001.343596-2-tristmd@gmail.com>
References: <20260421135001.343596-1-tristmd@gmail.com>
	 <20260421135001.343596-2-tristmd@gmail.com>
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


> @@ -1594,7 +1595,15 @@ void wilc_network_info_received(struct wilc *wilc,=
 u8 *buffer, u32 length)
>  	if (IS_ERR(msg))
>  		goto out;
> =20
> -	msg->body.net_info.frame_len =3D get_unaligned_le16(&buffer[6]) - 1;
> +	frame_len =3D get_unaligned_le16(&buffer[6]);
> +	if (frame_len =3D=3D 0 || frame_len > length - 9) {
> +		netdev_err(vif->ndev,
> +			   "%s: invalid frame_len %u (buffer %u)\n",
> +			   __func__, frame_len, length);
> +		kfree(msg);
> +		goto out;
> +	}
>=20

It seems it'd be trivial to check this *before* allocating the 'msg',
and be much better that way.

johannes
