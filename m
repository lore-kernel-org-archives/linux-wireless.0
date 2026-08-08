Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE42DECDF
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786215693; cv=none; b=qrnvhgRGnkBhAPvyNpOoM/pHr+kEwgWBUtekvgFKYGiyjZCjFVQhreTKV4j+7zQ4l+vOAXctsPnFalj0Sr2ZuZqlGf3HRP9ABUuORaCseSdsMdxoqPnUXIzdK2Hdix8ug+ZddHjsTg8sni9SOtxaQhDcTaEIZwbTMDPMx/+EvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786215693; c=relaxed/simple;
	bh=BEujNMivAoQNhTOX1uqheIbdTM0CsIxGmwzUzoj0GTA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S3Nr40k2OqLYrK/fgUbE/DCPOGsUMI+/P3UUl/otC6k/8gnQ8oM4qgLoo0V1xSeP4VM4zmNQIUI5GwsMsIoLZB7b8t4oY3xbevkwm/ELVT+dd6JCft0XzNbVJyP9ggWg9bIeh97oE0RvKlA0Hl6OyYGnU8YI86PMrC7MEQ0rmgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=WZw30Ix5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="WZw30Ix5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=e4/yDvAMua3/YsymFel2FBV1pS6UOY0vwnEKe6k9JKc=;
	t=1786215691; x=1787425291; b=WZw30Ix5AnUT94g6aM8ow11LHDpaR87wiq+XP//X0CGoZyt
	el+CIYJ/VJTwrf/OaC0u6juEXy+18QLqszYOo3KFBJvsyDoi3Lm7NaPhoWCwwAuKWAlLU9wnPqWtO
	B1pvlz+ZFUVmYeqoqvrIs7P8yey3dqQjyvkc2ESYr9Te7sRRLVqovjpphqToEvxcEibhTOTEkDHlz
	RjTRVOfcuTAz5ic6QFQcCyVPsQPlsLiwh9lvwaEWOYIuAFgCZ0VMDia+vZhXRTvqUfwFCSsGWeom7
	sYk/jprhRANo13JmDTy1m3rRTfVS9Fe4g9JaF7cfYI3oKDoDqY1BusNJ/6KDCVGw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wsmIF-0000000G6Ji-0iEs;
	Sat, 08 Aug 2026 21:01:15 +0200
Message-ID: <6c5b0684ae01237037233b5e7a9c7b71423cb8fb.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v2 1/2] wifi: aic: fix stack buffer overflow in
 aicbt_patch_info_unpack
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Michals <tcmichals@gmail.com>, yanli.yang@bedmex.com
Cc: zhirun.liu@aicsemi.com, dijia.xu@aicsemi.com, chunqiu.liu@aicsemi.com, 
	kvalo@kernel.org, linux-wireless@vger.kernel.org
Date: Sat, 08 Aug 2026 21:01:14 +0200
In-Reply-To: <20260808172305.138690-1-tcmichals@gmail.com> (sfid-20260808_192320_629210_CD98B8D0)
References: <20260808172305.138690-1-tcmichals@gmail.com>
	 (sfid-20260808_192320_629210_CD98B8D0)
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


>  drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c | 6 +++++-

Please don't send patches upstream when the driver doesn't exist there.

johannes
