Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AFF372EFF
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791228077; cv=none; b=Ic9l6/Kz87sTyOxl9nlIPecOofhlTe2c5o1xCBgckTkKy0k+E7COkFzTPuEt8KzyjHow0iFBoMf22u+bPboMAFsqv/0IO2cpdckSyYiE6HKXJjFXHlMbZQD8V3ZbX9O8SL36kHYdA/MYQUQkyKvOzlwFCMPcTjAki1AmUHVBgHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791228077; c=relaxed/simple;
	bh=95mx75ne2Smv0Xlx6gksSb5Vy4KeqfkA1hY6vGiIYWU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MuhlWGmMVUcBLN31OcW568WIMUgZl8a1f9mqzAC1RIQYSGlB55y1HO31WQaUHBME9/GtJiWZNFo2gk0k4ayNgJ6vDY5S8I6RJ3zBhgPfdKAAB377R8fOK8Nki7nqwVEFrTKKQWg7osc5JCL1noTQRAcB41TdV+N6IV6g/xqE9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Zyp6qi/y; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Zyp6qi/y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=95mx75ne2Smv0Xlx6gksSb5Vy4KeqfkA1hY6vGiIYWU=;
	t=1791228076; x=1792437676; b=Zyp6qi/yTROyYePdn1PtGqNEZJzaz3jQFfH+2gcflolj3ST
	43IfMGqtcdgLAtJ12SR7AGM54qpi71RV0lL7QK0oDg47QPOTrqaGZH0E+8Phs44XKs0mFje4vIdfJ
	ZGvG6ceJTv8iv/LQtRdzNwUKTgD7T4GUGUUPcv3w/LkBvFO4fNJYQelaAm/7SV7MT+X6kDugIm4Ux
	5StxgY6M/BDs2oMJwz4pzPRWPxmYWey0yo6pS7Z81PUty7OIVYabUUYq64iTT+moumURLBJ/vcDGi
	4Lm5FgfUb7MiHhk7Kb7nXMIpkkEfi+DTNs7HdBtw9IXRZj0iNnJCq+YkoL6onsog==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDoFN-00000005ZaG-1ttE;
	Mon, 05 Oct 2026 21:21:13 +0200
Message-ID: <e4f0c620cc941c0ee369cf12f58f38423728a53f.camel@sipsolutions.net>
Subject: Re: pull-request: nxpwifi-fixes-20261006
From: Johannes Berg <johannes@sipsolutions.net>
To: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2026 21:21:12 +0200
In-Reply-To: <8234429838b276fdf1eaa54da32c4b32347ed361.camel@sipsolutions.net>
References: <20261005171814.2884772-1-jeff.chen_1@oss.nxp.com>
	 <8234429838b276fdf1eaa54da32c4b32347ed361.camel@sipsolutions.net>
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

On Mon, 2026-10-05 at 21:17 +0200, Johannes Berg wrote:
> Hi,
>=20
> You based this on wireless-next, I cannot pull this.
>=20
> > nxpwifi updates for 7.3-rc7
>=20
> Ideally -rc6, but I'm not really sure it's worth mentioning what you're
> aiming for anyway ;-)

Wait, no, I got confused, oops. Ideally -rc7, yeah.

johannes
