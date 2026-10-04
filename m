Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187AD41440D;
	Sun,  4 Oct 2026 10:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791109399; cv=none; b=g/v5fsk0AVzahdPnsuIlXZkzdNBCguu8bWGhGst6cOrz9+h0tBTrFIYtXBZ2WhHBlIG5XlJ51nB5pkllNMW5cU8tHy4IGEOY/n2T2wTFD6554AFWcp7Zh8eNiV9C+v2h+vfzrtxMUCUeetK1YMvI3Iodaksm7KCp5TTODAj1Wjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791109399; c=relaxed/simple;
	bh=2U8h5dEiY0J7fdwn/Vs7hFbFBlImHX8Ep9FzXxgpwOY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tcNtJ9DVOYYLFNsOYqfLvPjxHkqVZxHC9H0tGHLyMMj5ByKA3xEYhTqk6Cs6EzlwDYRYJshD7q8PcLmzc/SGUWcluhH+B+sglQAWG2j7Mct9s8g3+BDvK5VWt/Nh2dgd9+V/shZMi3W+6EUZrqfjS0BBCPdyTSyTu1W/CuXDr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UP6xjC8v; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UP6xjC8v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jtk2Q6oUmf7r9TnOiKJ14B3ioxUuvgkLSGgcO2hOsZo=;
	t=1791109396; x=1792318996; b=UP6xjC8vfHhDBMWJt8mSmX8cxCaonktboiy+5N8F+42urLy
	5rs/WIGVXAtTGtlaJ4vvH9Qlk1uurEirutuEtDCdcN++S1d7KqMEZf4zm+H0OrfcP2ZsYPcQ62dp8
	uld4PsgcQwBeI+IApMtBJavFowhEvcrM+sUOo6mKImxWzp+vF6o0uMoRhsYkjo2A606ZLQd7EJMrx
	bzQOkzzt8e6QhvzLco6FknHBCpcR2jtj8fXLSWLAQ5upqxU6rKXtfN3HysekrHEM9TjlovIs39d0i
	oN95vzRGWOyaSI0xLhiMvdpqCMyKImE6pDKnHNFR+Ij78ulI0BX+VUcPkC/qRP9g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDJNA-00000003zMU-1VRx;
	Sun, 04 Oct 2026 12:23:12 +0200
Message-ID: <616e0013e78323cbd6a1a307cd40d59b1e562373.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 11/16] wifi: cfg80211/mac80211: Handle
 UHR Link Reconfiguration frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, Kees Cook
	 <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Sun, 04 Oct 2026 12:23:11 +0200
In-Reply-To: <20260924-smd-v2-11-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
	 <20260924-smd-v2-11-bb40094da1d4@oss.qualcomm.com>
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

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
> A UHR Link Reconfiguration Request frame (ST Preparation or Execution)
> triggers SMD BSS Transition on the current AP MLD. Userspace needs
> reporting of the STA's dynamic context along with such frames so that
> the same can be transported to the target AP MLD for setting up the STA
> TX and RX queues.
>=20
> Reserve a field in ieee80211_rx_status that enables drivers to attach
> the STA's dynamic context to the corresponding frame. Since the maximum
> possible context can grow too big, attach the pointer to the context to
> the frame. Add handling for UHR ST Preparation and Execution Request
> frames so that the associated context is propagated through cfg80211 and
> nl80211 for userspace reporting.
>=20
> Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
> ---
>  include/linux/ieee80211-uhr.h | 59 ++++++++++++++++++++++++++
>  include/net/cfg80211.h        | 13 ++++++
>  include/net/mac80211.h        | 10 ++++-
>  net/mac80211/ieee80211_i.h    |  2 +
>  net/mac80211/rx.c             | 96 +++++++++++++++++++++++++++++--------=
------

This change is big due to argument refactoring - better do that
separately.

Also, I think better to combine the whole series a bit differently with
cfg80211 APIs more isolated and then mac80211 implementation(s)

One thing I'm missing completely - which is why I was looking for the
rx.c changes - is handling of 4a substate frame limitations?

johannes
