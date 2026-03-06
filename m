Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E161256D;
	Fri,  6 Mar 2026 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772788082; cv=none; b=AdAzEayASWFCqgQKrxxgEo6dkGMMWtVacvhWm1tWGSEleTdUjPoUWLh2dtoAnEMWw8xUmvvu7iF2E8Oc/lTptORr9S1sCiz4rdmSwELt7BROOyN5ftUcRJR2iWzuwSZxxqPlNSYWUpaduMiebeRamWP0j2rvbMwrFWVLEjvlSD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772788082; c=relaxed/simple;
	bh=fPidnimtjaDRCQHd2+cl6NjTUF77AmEWM/Ub53HJcFg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bK3I/9g3lrHINXb4dey1mgzJFcD62ejGAIjt0ptjPPY4M0tLq/JKb+5joNkRDXosKqtF20A+OoZM3Ju5iBnBK4AVIpC0NMguMxffWRR1tyUtBEfGI5gHbMFKXEZsgLE5a8GrRWB8uOie/CO7Pn066KlpLy8kiyTl8Lj2UEOAUjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vRk1P+pX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vRk1P+pX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=m+RHR1CL8PXcHYzAj9grwC3bOvwCPDUegL7Mm+LnsFI=;
	t=1772788081; x=1773997681; b=vRk1P+pXZBySWckyWPlRmUMJTRDzc0rhVugLjzGrtNxoonb
	CJ3OHMkrLfMtK1oVLGMf6JdaaNSKsN4BdnSf5mym9KbIRcwGvrRiRsOrEk75OyDHWrD8ct8wvx5bE
	P1aKSw3H56/a0TxeIvAaZcZ69soq7CwrCvtRegwO4WE6Lw3kcHFMaWK2g67pOezeKk0O7h4/VEekg
	OmrGzuNV8HIZ7yIMAlYqFMd9Mtf74NuEgqUJ7JIF9/YexG+zlrfvZKSQFbtf7QqSerQXzuwJB+hzU
	0nZI+5i8JASF00Yrcs8PLsErlvr4sw3s2wH8rUHP6z2LWFSqIZZvfcL8wzEPOhkA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vyRA6-0000000A0CY-1Otv;
	Fri, 06 Mar 2026 10:07:58 +0100
Message-ID: <54a4fe7c30dae6a1108f46330431c4ebbd5cdb83.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 18/35] wifi: mm81x: add ps.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>, Dan Callaghan
	 <dan.callaghan@morsemicro.com>, Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 06 Mar 2026 10:07:57 +0100
In-Reply-To: <20260227041108.66508-19-lachlan.hodges@morsemicro.com> (sfid-20260227_051343_546245_F77982C8)
References: <20260227041108.66508-1-lachlan.hodges@morsemicro.com>
	 <20260227041108.66508-19-lachlan.hodges@morsemicro.com>
	 (sfid-20260227_051343_546245_F77982C8)
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

On Fri, 2026-02-27 at 15:10 +1100, Lachlan Hodges wrote:
>=20
> +	return (gpiod_get_value_cansleep(mm->ps.busy_gpio) =3D=3D active_high);

I thought something (checkpatch?) used to warn on "return as a function"
:)

johannes
