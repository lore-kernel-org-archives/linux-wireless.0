Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217CE45A2A0
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981084; cv=none; b=VoYcArm/tmXPy9LR9hyuiNPJm0eUhWDI9+cjnMJJjbp3RBuH5WC9LebY0O4aKPtfaohcHaoJzemxIJq98yISmKA8wm4zj2ShKLbB6hbFR4Pwaye15kHY6b8N+Hlxx9XDTFsLZHFNNjJEyZiP7Sb8VQ2wzRsGPd3lLCnPFS7WnG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981084; c=relaxed/simple;
	bh=qisMA7Qvz/3ZbWsDfkIVlFILCAegOe0W2xzrK1USZyA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MfnxHaubzeplatQyYJJF5qU5ZbrEpcE0MOAUeg3Rug46of8jaJtd9ENzV45MR798PoWM8+0EeHJoLBU6q/E/rQdfkQPDBTuizDelH2vmsFCYPw1cMtve4OgJiZ54S0G5P4Pwf4FzNyUZkcnXnUv+FMUcqXnt+xv8gRxRGQQkgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FYGcyLO+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FYGcyLO+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cpjBkP+621T4e6rMBOnrTwMZ8BBt3yPlcY2RGsXAAwY=;
	t=1789981082; x=1791190682; b=FYGcyLO+kVqHn7WcWU8ND7qSyiYtlSqvFH+5ouzWhPWZdx2
	JvK1KRSWsS1ztlrAXHcP00uemJAXdFb/kCtHSgYo9l5kYy7KEA2BD4D8jIZEddj5ejADNYikTfkQQ
	+0OJa8NoKrUWqnmrasJOtZkEmKOexeRiR9Ad+VFtavrZZVhA2QKNeiuhVUr54cMhR7QmlXDENUZgs
	cYIERED241YW6MMf1Pu+Cb9jakEOEyZfaHWqgK/J7/MMzcvzZIzoQdOi1ZZcgX67lC0iOZ59setOF
	5tUGux7PUZYhYRTyswt2CnGClx24gP4YoAswPB/8yf3htMdK2S5C8ESLRqOohcqA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8ZqY-00000005hM2-1o52;
	Mon, 21 Sep 2026 10:57:58 +0200
Message-ID: <a1a5fa095dabb37ef67137bf1fb3ce2eb7e8d84e.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Guard FILS discovery
 and unsolicited broadcast probe response
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Sep 2026 10:57:56 +0200
In-Reply-To: <20260918-fils-v2-1-44e41f714f18@oss.qualcomm.com>
References: <20260918-fils-v2-1-44e41f714f18@oss.qualcomm.com>
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

On Fri, 2026-09-18 at 12:47 +0530, Manish Dharanenthiran wrote:
>=20
> Currently in user-space there is no restriction on sending this for
> non-transmitting BSS, thus it may send these for those BSSs as well.
> However the driver will use the config only for transmitting BSS and
> ignore for non-transmitting BSS. Returning an error here, even if
> user-space sets these, could be fatal because failing start_ap or
> update_ap operation would result in failure of bringing up those BSSs.
> Thus, ignore the config for non-transmitting BSS silently.

And honestly, it really _should_ be fatal since it really is a wront
configuration, so that text isn't really that useful, nor the comments:

> +	/*
> +	 * Only transmitting BSS should set this config, ignore this config for
> +	 * non-transmitting BSS silently even if user-space sets it, as
> +	 * returning error would result in failure of bringing up of those BSSs=
.
> +	 */
> +	if (!params->update || link_conf->nontransmitted)

Please state that currently it actually _is_ (erroneously) being set by
hostapd and we need to keep it working.

johannes
