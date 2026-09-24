Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DA917A314
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237688; cv=none; b=XJaV43H43u1Evg+4UgC2vw6wlthM07u89MnuO8fg26kl9AgE1OyDJ8PQJyNdxP5rzAm4hYaVhaM6rr18xqQwFmqfAstbJytHbRmfoP9d+Jf1dNYDmnGlF8oiLJcr8TmeO23Hlupsfm8mXxQfoIWEAG4YHMT35mjHfLsYqV9LJfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237688; c=relaxed/simple;
	bh=MBy79kRrtx7J2pq9frk0FI5XdRNIhf8VGyWrUuvdG0Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u2YO1u9OqKy0rpxfolB4clWQEpGJKz1yyuF/sE01WYTsSB5ZSaXl/iQoMIaNT97XAX1YJ1He5wa8Il5qBd0TmPqI6fyaBDwLnnQ3N09c2aMCDX50ih3H9O+yPfcYE7SXqcnMWh89DpQHvNm46fBqMkgZAbwmKLu3kDYiqezYvbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=B+w6DPJ7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="B+w6DPJ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MBy79kRrtx7J2pq9frk0FI5XdRNIhf8VGyWrUuvdG0Q=;
	t=1790237685; x=1791447285; b=B+w6DPJ7GUXfVh1N2Fq3z+0NSg2aMqAmR08OSRBZJ9T98lU
	fRKUH7NaNcO1+TC/HXaACRr56BrDmr0kN325OS2JKEwHLwzxffcP0p88mEGZdMdtJhL01B0egc5Fu
	gZ6BQc3q15e94lgBQmSZgj6gW1B8M5E2/vHAp9HqlShN8ZqcsLErWnrpl8gDZPZhYu5vd7TdKLgz8
	RQr3b+r+NGSlY3T63zVVcIypBivpxT19H+sMY5h1CnREcOfsVfn7fdwpWDmUItB3jsk3UBoe8z7+z
	q1BRfhIbLk8kPD3i4jrtbGWsuNikTvE971YilIsDbMcqOXAqfv4p7Nb2Upebb5Mw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x9ebC-00000008vSh-10Kg;
	Thu, 24 Sep 2026 10:14:34 +0200
Message-ID: <b76bad90389aad66d9082428f3c969294c6a8d74.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>, 
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Ganesh Kariganuru Mahabalesh
	 <quic_gkarigan@quicinc.com>
Date: Thu, 24 Sep 2026 10:14:33 +0200
In-Reply-To: <66e6b21e-843a-44ca-bf77-30441a80510e@oss.qualcomm.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
	 <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
	 <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
	 <ee25d1c927d4a618384eb05a210b0f9b2147d055.camel@sipsolutions.net>
	 <66e6b21e-843a-44ca-bf77-30441a80510e@oss.qualcomm.com>
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

On Thu, 2026-09-24 at 12:35 +0530, Aaradhana Sahu wrote:
>=20
> Would it be reasonable to remove NL80211_STA_INFO_BSS_PARAM only from the=
 AP-side station
> information, including AP_VLAN, while retaining it for the STA side?

I think it was added for the STA side, so likely is needed there.

johannes
