Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2283603E9;
	Fri, 31 Jul 2026 06:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785479644; cv=none; b=mfCS9tmbf7s2IjqX8iuY1Uir9kM88q63AsnZgpNH9KUr+jFKu7zu1EqjiUJq+aUg6xtGYfedUeHT/wDK1kIsKyl9nGsM2BmnIVdCTYCS6Pl9WarP+JGI/NcEgFLHxDxcoLHIX8z2Ge7jJC73ZqItCAl/6RcYrCldN5bGFoDWzeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785479644; c=relaxed/simple;
	bh=KiZihmARTGMJaq1QQeWAZxCUGfrDoemTtDFUmdpfmmw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dGRtXWDjXZGXPlsqK4eamNe8bDWppYgNXOwbeneBD7tNvgXWrY4ENHzTFFuimHFY6TFbaYb5ZcJ2IgBy5XT2G8Y8GNNRzgVc7aw2LOZpTui0V1A0mt8J7wxnqS+UjTm4ldIaYznj+PX6e+YOi5/tJAxbvT+9pFlZUa5RAS6oBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KBpFbCxN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KBpFbCxN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1C3kzKsjx1i/oqnnr7TqivG/v2a5qqKglXp3keQit4E=;
	t=1785479642; x=1786689242; b=KBpFbCxNcrFlSNNfEZ15k+QILcPMfyK6ZOBBcF3qvIW8DlG
	O7oiHmQzDOAOMwrEO8Ifi4835e/OVEeEF90Ov9s+OjuLUEFLM+BXuDDS7koYUeJZnmrYHvSasSWv3
	BVZoH5kT2XIVXKeeYLKQL0/dmQ9RZktw+vtLuWLZIQQS8ED1b6imKQ7uu1slnZiwMt4hAjeOQgL0T
	VaTyneCBpmqcnfMpCRBlbBGH8ExA63DqTrODRSsx2VvNRvJUwCY4py4VlEWvyb2OEkwm9QAhYQt0m
	bKEXLnRUrWPtG1DgmPAeZ01Vjg2TOlCuVnVkFiZrbsnstJ+lLdaCo2tDBz+iBKwQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wpgoZ-0000000CyEL-34Zo;
	Fri, 31 Jul 2026 08:33:52 +0200
Message-ID: <60bba9a844d8fe0a94d19b8e59f52b4b36e9a35a.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v2] wifi: ath10k: make in-order rx amsdu buffers
 persistent
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, david@ixit.cz, Jeff
 Johnson	 <jjohnson@kernel.org>, Kalle Valo <kvalo@qca.qualcomm.com>, Michal
 Kazior	 <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	phone-devel@vger.kernel.org, Richard Acayan <mailingradian@gmail.com>
Date: Fri, 31 Jul 2026 08:33:50 +0200
In-Reply-To: <0b9f80bf-73e8-4e9d-9726-b8816c9a364b@oss.qualcomm.com>
References: <20260719-ath10k-a-msdu-v2-1-f479bb9d1217@ixit.cz>
	 <0b9f80bf-73e8-4e9d-9726-b8816c9a364b@oss.qualcomm.com>
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

On Thu, 2026-07-30 at 19:24 -0700, Jeff Johnson wrote:
> On 7/19/2026 2:45 PM, David Heidelberg via B4 Relay wrote:
> > From: Richard Acayan <mailingradian@gmail.com>
> >=20
> > The WCN3990 might split MSDUs among multiple "in-order" indications. Th=
e
> > driver needs information from previous indications to handle MPDUs that
> > are not started by the same indications that complete them. Move the
> > list that tracks unprocessed MSDUs to the driver state so the driver ca=
n
> > handle MPDUs that are split in this way and be less confused.

> I'm transcribing a few comments from my review agent (which may overlap
> Sashiko). I have not vetted them for correctness. Hopefully I placed them=
 at
> the correct spots!

I think this is one of those cases where just doing LLMs isn't all that
helpful?

I'm not at all familiar with this, but why does this really need all the
complexity of hanging on to the entire MPDU etc. when "[the] driver
needs information"? Couldn't it just hang on to the relevant information
and reduce the complexity here?

Also, the entire point of this is for the loop, so when the LLM says:

> > +	msdu =3D skb_peek(list);
> > +	rxd =3D HTT_RX_BUF_TO_RX_DESC(hw,
> > +				    (void *)msdu->data - hw->rx_desc_ops->rx_desc_size);
>=20
> Dead rxd computation before the loop =E2=80=94 VALID, MINOR

I feel like it's probably missing the point entirely - the in-loop
version should be removed?

johannes
