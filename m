Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC6F489FB2
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 11:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789991508; cv=none; b=QKI96nYOHzvUzjPiB9dFcFhON0FOqHqXQj4QpnuxIPYy0RTewJnO1KuLoHODXsVHZe3xVqIGd2R05Qgg7fenwfMghzmjgaNGF3drhALYiEjVrwNCcD7z7/0zF5JL9ZeXeeofiXMWSO7X7y9wy0UUbRkd0e0/+b5bgtC/Dmn46Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789991508; c=relaxed/simple;
	bh=PYeJW5bTcHcFyRqoD8LOZOnJMT3bFUMUhzn24qlPg2Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hzbNFFjXW4tZDhas+q2n/JYwj8d2X8BwkrVgZHORI6p1DLbZavAuk8jVSiSXjDd4lQTf0rDapPOT/O61HpJbTvEBNFOspGQlu+eD001y+QXgdSAvEylICJ/Mqb7GCv4oj17VKrUbVbNXfgsGzaV7aUKbLYinN5rnShyqOtjWhT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LudeHORO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LudeHORO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PYeJW5bTcHcFyRqoD8LOZOnJMT3bFUMUhzn24qlPg2Y=;
	t=1789991507; x=1791201107; b=LudeHORO3fz+gwtiRqPpFvtG87JspnRgmxLrE9l1eCLa5kH
	dNzuxzwz48dFik3K2idVSE+yNWnEFXPatgWMdIFSsChuCfXr3pNplO0oNjd/RcuM/uYdSTu25oaIE
	x6Hm0fd+d5eX+UHT18kdbgE814wlKIeuZu/iX7J3OqxFRdxhIrpV/nmvI4Ig5IURp3VVf8lSMFYI+
	sMfRKUf5p2msK8NkzEYxy71l1y/yGDfiyg7U47+cvi9yBKAVfphMtsaAZ/KO3sqf7o19KqRQRM/dV
	G3B/KWfOwbzZVsQQOoGcqpAm6SC6PFhFi9vvbUVbE6GfB8VSLG9KJ3KtUOVMhMEg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8cYf-00000005n3v-1GiB;
	Mon, 21 Sep 2026 13:51:41 +0200
Message-ID: <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>, 
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Ganesh Kariganuru Mahabalesh
	 <quic_gkarigan@quicinc.com>
Date: Mon, 21 Sep 2026 13:51:40 +0200
In-Reply-To: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
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

On Tue, 2026-09-15 at 10:59 +0530, Aaradhana Sahu wrote:
> AP_VLAN interfaces do not maintain independent BSS configuration.
> When station information is reported for a 4-address station, BSS
> parameters are read from the AP_VLAN interface, causing beacon interval,
> DTIM period and BSS capability flags to be reported incorrectly.
>=20
> Read the BSS configuration from the parent AP when populating station
> information for AP_VLAN interfaces. This ensures that beacon interval,
> DTIM period, CTS protection, short preamble and short slot time reflect
> the parent AP configuration for both legacy and MLO station dumps.
>=20
> For MLO, the per-link BSS configuration is used so that CTS protection,
> short preamble and short slot time reflect the configuration of the
> corresponding parent AP link.
>=20
> Only advertise NL80211_STA_INFO_BSS_PARAM when a valid BSS
> configuration is available. This avoids reporting zero-valued BSS
> parameters when corresponding BSS configuration is unavailable.

So ... I guess I can't disagree with that - but is it worth reporting
any of these parameters at all? They're entirely under control of
hostapd, so it already _knows_ - is there a separate tool that really
needs to get them via the station info?

I'd be tempted to just _remove_ these on the AP side rather than making
the code more complex to report them correctly, in particular since
basically nobody could actually be using them right now since they're
just broken ...

johannes
