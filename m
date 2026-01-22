Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66ED3624DB
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2026 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100113; cv=none; b=bK/rIFx/R/NDX6mAyBBLKWuhh2erhP0wvjmjltaYSzlPk1d/PZzGweFT3iyFWreULWSxN065zgHcZoknApHF+JW8dDyAWVi6Im5/UGfw+Tz30DRmg/7XUW1HA+MYv+NtyqBuQcJrdwXwHz65VDZgpj1+cp89f7MhRuSr9Nzc4S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100113; c=relaxed/simple;
	bh=p0F7OtkvqeBlRUVvQNfUUbvthsVKxKCrn+F9uF8lM4Y=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gx+XvPUrA8odXpXnjzV/GIC9dNUJmuXQeCMMv2amSp2daa69zICQ22IBI/HRuIchzXRfomIEEbAI/m3OS+6ZEvBZGhZcUdMm4Pai/RXiBqaiDKZlsJdF52GdZxYW75TAF3qmlhFVLDTyFnu5NG9USij6nNzVQGfi6bEl9G0IF1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Un3WwchV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Un3WwchV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=p0F7OtkvqeBlRUVvQNfUUbvthsVKxKCrn+F9uF8lM4Y=;
	t=1769100108; x=1770309708; b=Un3WwchVlUvigFJebL3O2xIbLVQctBjkyidhR9QFDw5o+rh
	sxBQOv5tgZQJ3zMz+pr4etAF1YiDRPxerynbNRxTepuK2yfhJhNgQioHPx8mofEgxdZwtcL3y2C5I
	tmw6N1U0ORDSw7Bot39ExV824M7Sg/ppVjv9GvMlG7GU+50SFuMTexjayfAAPkl6XKnTWyIto5PS5
	Iy4wYl7ppnsh3YWGqWliTRE8BKcSiELgQNdy5oDf4ylwvhNgYL2DQBb8k5zO4izv//c/fxlZokKFb
	RZFf4BMWr3kX2UGWp94oFMQjL9EcTlDZ4ljwmh3I7+Mz9uVxMR9kuPlTTP8WWp6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vixke-00000000wQ5-090q;
	Thu, 22 Jan 2026 17:41:44 +0100
Message-ID: <b2cc421f0416cc1ab42a937ccd78b4a8c27d47cb.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: do not set 320MHz EHT capabilities on
 non 6GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Escande <nico.escande@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 22 Jan 2026 17:41:43 +0100
In-Reply-To: <DFV9KI49QEP2.2TMVJXR5EK0B7@gmail.com> (sfid-20260122_173804_650198_DBFE758F)
References: <20260122145620.861355-1-nico.escande@gmail.com>
	 <829488acfdbf7ecfe6418bfb2c5669dae18392ed.camel@sipsolutions.net>
	 <DFV9KI49QEP2.2TMVJXR5EK0B7@gmail.com>
	 (sfid-20260122_173804_650198_DBFE758F)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-01-22 at 17:38 +0100, Nicolas Escande wrote:
> For context I initially encountered this problem on an ath12k AP which ha=
s a
> single phy with both 5GHz & 6GHz bands available but only had a 5GHz AP s=
tarted.
> On such a platform, we set this '320MHz in 6G' operation on the 5GHz no m=
atter
> what beacause of the phy's capabilities.

But that's what I'm saying why it's a driver bug - the PHY capabilities
are advertised *per interface type* and *per band* by the driver. It
shouldn't set this one on 2.4/5 GHz bands.

johannes
