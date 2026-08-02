Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5D43C1996
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785688390; cv=none; b=pCIOwS3PGo2RHqv4NA7gAscpooJlk6IDJYqIzn9pnlFTx6zQlTb+QIxYN6yvZf4YGSVfBHC8OX7HdJGf/uvnozJs++XhD6TkxCZLtHFxl9ZNqMU5fD6Qpb59BoQcrPAxFRpp5Oa3X1AagoZd5TXGYAc9agSwieTyN9LSvRf7gzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785688390; c=relaxed/simple;
	bh=GjK3E+M6R/OV/4njTgtrFIVcuR9BoVON2x7SmP5HNDQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q6R6YVIEfypAdRW1ecEhYwN/yjstVMfnmDh7QcKydaza/klp/V0zdRoI7eU/zfixzO+FNBUT0zPuRexSvvQMRWY+DhjR36UvPXRQrfaxE+RdMn/KXyLUjxcra576PZM8Grykpw7Fexb4dA0c4Kmn1uR9hWxi0/v4vAsT17j/OZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=W2rGijNh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="W2rGijNh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GjK3E+M6R/OV/4njTgtrFIVcuR9BoVON2x7SmP5HNDQ=;
	t=1785688389; x=1786897989; b=W2rGijNh3wnDCQec2dRUtq+22zOlNbQraa1et07Tw3U07iY
	UsFvLB7FxmcDOLfjQCM0VmdAsSbX4kYSJNIh7+oAeeu1RMFri1Jj6kiPY/pVbh/8MYB74pD5SD2/b
	780VQF/BP4t1gmGIy6jrjZMiwm64GMrIEiNk7pb4HULpQWJ+HE5mWHq6NivffkqTI66qyQwX2wo5O
	BZoDHJDKnA50rW8KTQMHps/80SEwoR2eJyyDj7yQsIZNHj3x3f8MaG2R3vZcbKF+IDJC8yr1YNWMQ
	uVcCbfdxaGToW/0dAcZ2qDEAhIZK62Q+UUJqSzNHWFJCBw043b8Nst814cKyGlWA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqZ7a-0000000Dw1N-10w2;
	Sun, 02 Aug 2026 18:33:06 +0200
Message-ID: <c0d041baca23377772791242ce0ef241aaba4112.camel@sipsolutions.net>
Subject: Re: pull-request: mm81x-next-2026-07-31
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com
Date: Sun, 02 Aug 2026 18:33:05 +0200
In-Reply-To: <3wboegj7eyorursqi7gftc2s3jqtrfi5fv3k57eoqrr5arxmnh@2jextspacknp> (sfid-20260731_084623_069991_CE483BE5)
References: 
	<3wboegj7eyorursqi7gftc2s3jqtrfi5fv3k57eoqrr5arxmnh@2jextspacknp>
	 (sfid-20260731_084623_069991_CE483BE5)
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

On Fri, 2026-07-31 at 16:46 +1000, Lachlan Hodges wrote:
>=20
> This is the first mm81x pull request, so just a single commit for us
> to test our workflows using b4/patchwork and all that. Obviously
> in the future we'll collect patches overtime like other driver
> sub-trees; though I'm sure our pull request cadence will be much lower
> at first.

:)

> One thing to note is that the tag is not signed, is that something
> you need us to do? The docs appear to say that it's really up to the
> upstream maintainer.

I guess signed would be nice, if you can arrange it, then I probably
will check less ;-)

It would definitely be good though if you actually created a tag object
with a message, the message you had:

> ----------------------------------------------------------------
>=20
> wifi: mm81x: updates - 2026-07-31
>=20
> - Just a single fix for synchronously shutting down timers to prevent
> a UaF.
>=20
> ----------------------------------------------------------------

wasn't actually in the tag, or you pushed a different one, or something
weird happened? 'git show' on your tag after fetching just shows the
commit it points to.

Anyway I've pulled it and copied that into the merge, but a real tag
message would automatically show up.

Thanks!

johannes
