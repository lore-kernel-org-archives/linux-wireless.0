Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881BD1DFFD
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489153; cv=none; b=HKNF0KTw04kwWtf/2sizeFyKQeffyWtMvq5GmobqtP5I6Ghpiu7hR394V9jEnByHcfA0utXYA9N7DkvGclaCWABl3QbKlzqQsjEr/C9nRoGoEVaTSIf4LsTP0wOJYXbRlrVtgjEezh36SXaCLDo4qtTuvQ4xO4VqaMhFruIoBUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489153; c=relaxed/simple;
	bh=46hhh44U6UT+dX0F6KILRYoIPLUuWj9LrFhBx0vXmbA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OKaTEkmzzKY61Sapj2NqLEZn0X3M/nEhZXRIzl+8d0CLuwPuhfwvEK0/ihI249+mKtLtdyHNxM+/3Q0nhtHP+wR8p/Og72MkuQgYD4ozg9cP3W1TyCT/ZhZLP9zHcryVjKgu+ogfE4ucvbdeHb/ZTLXjJdwEUHlueeYNoxZuTms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BjxCSO5F; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BjxCSO5F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=46hhh44U6UT+dX0F6KILRYoIPLUuWj9LrFhBx0vXmbA=;
	t=1785489151; x=1786698751; b=BjxCSO5F294wEQTehGqJ0XbOWo/Vi9T0eT4EaVRgUCgDH7d
	e4kI0DSUxZoHTOBFZSAz71raFZNbf/ejZEm7raT9YCcG/onb4gZxgrmV/hqQ9xpLShOz5n8RjGRcx
	1TbsfX4yNwaZm/JVil5tu8FVR/Vn4H86ow8mELYlT2wyvB2tdyPeSu9+CHY/aOHDWYU+b8lpwtk7t
	4hkO8r1LWf0YJzi7ZCvxKsbuP+Vn2Bu5pAuFeBY1iMp38al3CYtdCCrMHk7VTDIwn96A4uKU6u3+D
	Yb9QTkVFof4kU4N3xXn0hRzOnrgj+zSTTaiGmI9no7KeS3gkCF0CzoGtOSA5qbnw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpjHz-0000000FqP7-1wgp;
	Fri, 31 Jul 2026 11:12:23 +0200
Message-ID: <dfbe7009a77ada382d46fe568c28f76c675453ce.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 0/8] Adding NO_STA flag and reworking RX link
 resolution
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org, Jouni Malinen
 <jouni.malinen@oss.qualcomm.com>, 	johannes@sipsolutions.net
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:12:22 +0200
In-Reply-To: <b2232118-9117-4ead-94ba-7c5435844079@oss.qualcomm.com>
References: <20260223123818.384184-10-benjamin@sipsolutions.net>
	 <01295135-6bcf-4567-869b-75597649d11c@oss.qualcomm.com>
	 <640192308052e60589455505d31732cf2e00b1aa.camel@sipsolutions.net>
	 <b2232118-9117-4ead-94ba-7c5435844079@oss.qualcomm.com>
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

Hi,

On Tue, 2026-05-05 at 23:09 +0530, Ramasamy Kaliappan wrote:
> On 4/27/2026 4:43 PM, Benjamin Berg wrote:
> > I believe that hostapd will need a bit of refactoring, including
> > improved tracking to know whether a STA has been inserted into the
> > driver and whether to TX the AUTH frames using the link address and
> > NO_STA flag or using the MLD Address.
> I agree with this design. Refactoring hostapd to handle all STA=20
> consistently both in the driver and in hostapd in scenarios where a STA=
=20
> roams with MLD and link address swaps occurs, in both legacy and MLO case=
s.
>=20
> Additionally, the design should help accommodate upcoming requirements=
=20
> such as Wi=E2=80=91Fi 8 (802.11bi). In particular, it can address scenari=
os=20
> where a non=E2=80=91AP ML STA link address needs to be translated to a DS=
=20
> address in the STA mode, while on the AP mode the link address=20
> translated to the MLD address. I believe these aspects can be handled as=
=20
> part of this design.

While posting the patch again I noticed that I never replied to this.

I am not exactly sure what you wanted to say here. My thought right now
is that the issue of the DS address is a separate one. The DS address
will affect some related code paths, but only affects data frames at a
later point. The translation will happen eventually but only after all
the MLD/link address translations have already been dealt with (or in
HW with RX_FLAG_8023).

So, my current view is that the DS MAC configuration affects related
code, but it is not relevant to mac80211 in this case.

Benjamin
