Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906D135837C;
	Wed, 22 Jul 2026 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784736631; cv=none; b=eULvHrUpFEqX+oqQMGCTwkqFH0SpO36i45y4srA5J4sJWfRIIfpyYbBMwTmjUgRJDR1yFl9Zrm5pjSCMakIEhPrtWdQT8jo7YNbXuK2L0f9cv7OzrEKjrhYg8iAh6gGzjQ3l7eWf5pLdvyin4hC9kG4guFe9Wz9UeFl6FzJCzOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784736631; c=relaxed/simple;
	bh=hInNvtYOxXbvZY5RtIMOlajXh/hrzHIgSD5gdBoS228=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RuoaIHWRoBbHuyGMHPDcroCAPXGSXVDUVQKMR1AZo7W+LupQYt12DgXWkDGiOBbF23JEwUw3CwP+Bb0FrirYLw4NMFtiF2rKMBvufzUu+UkHqa4z+WRewP0pWsWlGYpa8qMGC92bM0dOjYwy+NxXTbQGh3ZhewczQ7rWca0x3Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vmhDEV4h; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vmhDEV4h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=DT+FlYy//5gpti70bZ8f+/+m91rbc7vGMuCSLrCtIGE=;
	t=1784736629; x=1785946229; b=vmhDEV4hEEhTv2bjnhLcDy1JQ0lnhR+rEMK5q4etBMBGp/Z
	jHWGo92G/5+4gMf7P2Uc9XmkTlwHWBBVcXqJoIi5cRnQDp8sn2aH2bTLnHWVRsLr5zQaQ6MS5WQcz
	ywewqH9ouRNNJB23qxHLasvhNXLdex0oC0ghR41rGJHWoXTu0qH81r6LEGGIJa7Mey66rPzL6sjf4
	pxJVOWiS78LHssjnHgqpkywDJqPJpVd2bWRWD9T1idsS4xBv99LXPWyAmiFtrt+TEKy36RzWHOPtc
	783rz4mYpB9X9FueZRQAMUN3i1dfjhvHmYC/HM89hgHuLmyUoliFwYZ9bxmzDywg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmZWc-00000004sHg-3i2s;
	Wed, 22 Jul 2026 18:10:27 +0200
Message-ID: <4418b4f5cd308d18babf6481826a3d9358a8541b.camel@sipsolutions.net>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Wireless <linux-wireless@vger.kernel.org>, Linux Kernel Mailing List
	 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
	 <linux-next@vger.kernel.org>
Date: Wed, 22 Jul 2026 18:10:25 +0200
In-Reply-To: <amDos20YUxH9DFgJ@sirena.org.uk>
References: <amDos20YUxH9DFgJ@sirena.org.uk>
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

Thanks for the heads-up!

> /tmp/next/build/net/mac80211/mlme.c:
> In function 'ieee80211_rx_mgmt_assoc_resp':
> /tmp/next/build/net/mac80211/mlme.c:7279:17: error: label 'abandon_assoc'
> used but not defined
>  7279 |                 goto abandon_assoc;
>       |                 ^~~~
>=20
> Caused by a semantic conflict (probably the same two patches as the
> merge I posted a minute ago).

Yeah. I was _just_ going to reply to that email asking if it actually
built! :-)

> I have applied the patch below and can
> carry as needed:
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 60fc407bb1ebb..5a1c022282202 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -7276,7 +7276,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct iee=
e80211_sub_if_data *sdata,
>  	else if (!assoc_data->s1g)
>  		aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
>  	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
> -		goto abandon_assoc;
> +		goto notify_driver;

I think it needs to be "goto destroy_assoc_data" instead for
correctness, but that's just based on what Jeff told me last night.

Sorry for the mess! I didn't realize this was going to happen :(

Anyway, the plan is for me to do a (hopefully correct) merge after
wireless will is merged into net etc., test it, and then provide that
with the pull request of wireless-next into net-next. I think it'll take
a few days though, more likely early next week than late this week.

johannes
