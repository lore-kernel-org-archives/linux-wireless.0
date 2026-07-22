Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E273C0617;
	Wed, 22 Jul 2026 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713947; cv=none; b=u+I7bm1oFIBccuETI3THEZNvspuzMkzvAQIfcu5RLu/3ncHZMVA99EN0cJw3A0iw6jQ50+ZiS6on+H35dgD4eLwlWW7n6x1AbIHrb3D7Okn9MqJmCdlplXn/vAPZUeOsMaf8ZYLm/G18u3LoYOnzK/tiPyg9QM9jSVeY2c2ds1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713947; c=relaxed/simple;
	bh=YUBmWuesBq0wbR3Llfr7bd0Cy/31CbRKs8gIk37jzoY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TP1GqYXFEpzJyvyVCm2UJ5FH/kzvc0Xo+IlqUYDet5QqYk1z+567JleENA/Gax7Xd+P5uVCEJV4hE2g3Bjo1ce0rm+mWuYnsfUosJnMMilFJ2bWWKWuQ2hZ9gU1bv2OdewfwVgxgsR5HO9j/U86PGgbIaRcMK+X7iIaTuWNmeiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ddemQMRF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ddemQMRF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YUBmWuesBq0wbR3Llfr7bd0Cy/31CbRKs8gIk37jzoY=;
	t=1784713945; x=1785923545; b=ddemQMRFj8gXKYQ+wvdqFGlMXPS243OHd5v8oKxAQuRUg6D
	UVevtllBx5cj/OXie7FghOUw6J0E6VoKT3TA7X0LlGdZQQT87IrO/cvT8Df4SPFwnK3yEyct0JrYf
	k944SleQSMFVRfKhsUc0fpt+QyDDmrvJ2khZA+NOivxawTYI+lOfikEm3PtDuMQvqO2Qh8nqrRQ8v
	UZZEneMw+ofvDnwMJUh9/Q4QHhV+0Ttk2CJ0Z3RyjsU8R4rGK1pdZhWuipwFZNVnlI2Kr0KGZEZfz
	h8wBvLG1+CxqiHHCaaS8s5wn5bGpjALqmo4Vxus+BDcckAVwYe4DGcSN4eABcN3A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmTck-00000004fwc-1gmQ;
	Wed, 22 Jul 2026 11:52:22 +0200
Message-ID: <c0a20c1ab127085ff17b58aec490d06b22a4f092.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: brcmfmac: fix P2P action frame handling without
 device vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	linux-kernel@vger.kernel.org
Date: Wed, 22 Jul 2026 11:52:21 +0200
In-Reply-To: <20260722082608.412472-1-Jason.Huang2@infineon.com>
References: <20260722082608.412472-1-Jason.Huang2@infineon.com>
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

On Wed, 2026-07-22 at 16:26 +0800, Jason Huang wrote:
>=20
> Fixes: 30fb1b272909 ("brcmfmac: use actframe_abort to cancel ongoing acti=
on frame")
> Fixes: 6eda4e2c5425 ("brcmfmac: Add tx p2p off-channel support.")
>=20
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>

I feel like I might have fixed that for you last time, but there
shouldn't be a blank line here, please change it in the future.

johannes
