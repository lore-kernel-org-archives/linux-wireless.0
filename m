Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C6D426D05
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770309166; cv=none; b=Ip73ot1f4Wo6H8Y/S20Cbzh2qr6GpHNLy/jm/LcZJ1PiEyvX6QDrUlU/EnE3kPhC4K8cYWIYONoDYTUhEYGrZReUysZdMJn1WgFQp2KokN3Ri9ntZT68GG+X45Mn8bn724AyKWulRca2oP2uh1qYuy2XyD94yhBWmkGRGnavvNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770309166; c=relaxed/simple;
	bh=6/HgWrc7kWjkvchXK4iIAHijzyjxS1jF5yIVJGR5vNE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f6z6cNzGhBn5kj2WhliD2bZAGvu9z0qEmTv8KTlsUcaW4VQKYq3+qyx4V8mNBNPuhtDHGLTW02nfCdEPSPWaogW702Gh6UI2M7nFPN/Apy6/19YpfMsnoSUFbzDafrdqXp3z9zcQ1gB3J8p7TEe5TGgmVRC7wLyDpa6UWWxyn7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ErHhcOiD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ErHhcOiD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6/HgWrc7kWjkvchXK4iIAHijzyjxS1jF5yIVJGR5vNE=;
	t=1770309166; x=1771518766; b=ErHhcOiDrV4r5qIFox5nmYDsLpBHPxcwXWf7hO6JxlLDMqU
	altLsBNvA5ShtteuTxnRIbGBHy++H1HdvtskL8vjU8+W87N1/CgdQDhDAt2O88V8uMjz/huMjUcTr
	i9/QZDtb/SGnpqXRFIh7wDJvt6Vt95pU6FxpO66KYzikS3PwLx+KUhkdkI2PC9Q36t0dzV4CYAbvG
	ZgMjsO3nLispdYrOZls2UtDSxdoGdIy23loQ3dsQQCGEu95agqOt+7i0IN1KlLSJ65kJAsllNvVO3
	FVFSVSUTYffwki6jGQSf9QrSDRW8WPJf9J+IhCqdnyOvk4auyEPw/IuyQtzpO6UQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vo2Hc-0000000FkFv-15yJ
	for linux-wireless@vger.kernel.org;
	Thu, 05 Feb 2026 17:32:44 +0100
Message-ID: <a3e5e4a8a8d147e4b77b02b479844f4a9c0cbd8d.camel@sipsolutions.net>
Subject: Re: bot results missing in patchwork
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 05 Feb 2026 17:32:43 +0100
In-Reply-To: <2edc78e3581a11c18189b1ac5ee95b0600586f82.camel@sipsolutions.net>
References: 
	<2edc78e3581a11c18189b1ac5ee95b0600586f82.camel@sipsolutions.net>
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

On Thu, 2026-02-05 at 11:28 +0100, Johannes Berg wrote:
> Hi,
>=20
> Just noticed now that evidently when I did some server shuffling
> yesterday I lost the job that uploads the results to patchwork...
>=20
> I can't fix it right now, so for now just wanted to say that it's
> missing and that I'm aware. I'll get it fixed soon.

Should be good now. And because I mixed up the new config and made it
link to https://..., I actually gave it a key and certificate now so
that actually works.

johannes
