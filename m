Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781402;
	b=auszYZIZaKw4UGpyYp1nW/+F6EDlzp3JBBYOatpR4jY0LOZ5/u6ltSrq3u3FOESKRykm
	 +qG+cjgPaoocpB9pf60JY8lqsnBl52MaFk2xxhb8/IwOo+7vSa8no4hrcxOxg2ILJ5Axq
	 udQOIXbtjMlL1A49SmRCEOCj3+ctqXjMjOHWAdwzPFdHZBfeEvSu8GP16I88dKjSwVu0C
	 3FpOX6pW1H/PiC+MD0p7/UmxUHLbcEErIUq/r1UpVXp3GEFlJGd7ifZYgPzEY1Y60L5MA
	 B5RDAWmc5Qv4FLNcxF0dZtOhZeeEAB85loq0nPSt2gc+vyWVUjHj2eoml1U+GitbsDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781402;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-malware-bazaar;
	bh=JVfuxFdvPZKXflkAWiwEyTE+Cn3z/jyS+y+LpcBkNJ0=;
	b=vQ9RGqzsyb3amCLLyBiPNrQ7b6NYb77YTCQ/tvGq43vUTKL5egp+rLiFklqmv27znzcU
	 7cWSnoC50XKFAyystFgnUFwVOPaQr/pBPkPe3OyFcwqG5xpSAtRbvMPoJPkWUNWbtvxB5
	 s/R9TJOIycYdV/FrCEndiQrAsXvT6GTezpwMQ8F/66+GkCChAYCj4i9RHpJ/DgV+mOfj2
	 mcMHCGj8UpGZPFNrSCu6T+FS6Qajh+iYt9azoMjt8h3FEHizG00Ygi7YHbdrtit5ybWbm
	 st+gL4q72icnjrrQ0F9JsXNhPyvJGXOV3sb+u2OPwd2moTAnb+CYbvSGgkjVAn8XvDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vnMS7tTj;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE379606A328
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vnMS7tTj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JVfuxFdvPZKXflkAWiwEyTE+Cn3z/jyS+y+LpcBkNJ0=;
	t=1793781400; x=1794991000; b=vnMS7tTjET04ev8rXTDQs43E8jTVspAV+tKECgSnEErW7Rm
	fplyx8q7RWBiNfVGjPC3BtiT7zAyRH29n+clrSOc/lud3TvZEpfYnnNKzhTTdKPRg/qjLcHcFNO+t
	rYs4XKv8s6P1HQkMxfcwkkkC6KHFR7yYeXHlJe82DlgX1sWik+gdKEx4v4JjPWhVpWi4F9QPh+op1
	xGpz8Grn+amluDqOiyMl0DcqE/wlSPGd4bv6Z4+De5exFOqQHRHU5mcaGtG0887oSTrEQ2DrtJGWw
	Ku02Gw7NJh6GBKEITXKBqPU4KErWo3G6D1199eJNMAXVD4JXNwriO+ZBDA7pl4XA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOWU0-00000005Ew3-3qfz;
	Wed, 04 Nov 2026 09:36:37 +0100
Message-ID: <9efc1e507a2c7eaf6ab68ea0be0f5f02178ff4c7.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory
 before wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Date: Wed, 04 Nov 2026 09:36:36 +0100
In-Reply-To: <d613e20e-16c3-4a39-b9a6-538a8740d2d6@oss.qualcomm.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
	 <20261022101836.148512-11-johannes@sipsolutions.net>
	 <d613e20e-16c3-4a39-b9a6-538a8740d2d6@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi Baochen,

> Hmm, this might reopens the race that 906619a00967 ("wifi: ath12k: handle=
 regulatory hints
> during mac registration") fixed: With this patch there is no ath12k_regd_=
update() call
> after wiphy registration. So when there is userspace regdomain hint sent =
during
> registration, that hint is sent to firmware and firmware update to host w=
ith a new
> regdomain, however the new regdomain is simply ignored.
>=20
> I'd suggest keeping this old call (to make sure the new regdomain is hand=
led) and
> also adding the new call before wiphy registration as this patches does.

I'm not sure if you changed your mind about this since you sent the ACK
a few seconds later?

Despite the long commit message I don't really understand the commit you
point to, I guess I'm missing the FW side of things. Also not exactly
sure what you mean by the userspace regdomain hint "during
registration", I thought this was self-managed?

But I can also change the patch to do both, cfg80211 won't really care
about the second call after the registration, although it might send
another notification to userspace and cause quite a bit of work.

johannes
