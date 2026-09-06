Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2FC347533;
	Sun,  6 Sep 2026 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788705853; cv=none; b=fiUqlXa1vpykpjhjvnPZN4z9Agqgj8FPZsCONukEKkk8Wxmc0zZkidP9FpugFH+kmnHN7DGdnVJYUb3W3XewKftYf/1wHIYdRQQdXUR2fcthdMjYXq7jeGg4e6+QzEcPTn8Zf0zB1emN68bTqbp0DKBuVeunqH4/X+GJf6VtyXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788705853; c=relaxed/simple;
	bh=/+TbxWPvt8Y2/J5G2/EFNHjGi1axHxBhIBKzr+e2naw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nMT1IReDV8QsTK1VniofheIZxZ9xJPEcc1myM7FI+xp01/dv8/1a0/7TDu+7kPWmQT5kklm6anduoWJ/t37pa4EWEPQFB44b8WAGYue9fBsoMBQT19YDySL+yxGq1SBVlMtbgu2k7jTwyuAL6FNgQN7YREIbPR0Q763TzL+FtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=sSA3xEp4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="sSA3xEp4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/+TbxWPvt8Y2/J5G2/EFNHjGi1axHxBhIBKzr+e2naw=;
	t=1788705850; x=1789915450; b=sSA3xEp4uUvosvADI+hqRE/rtUMv+9H9esARckd9Q49gE79
	eWmj70DL9CJ3JXaHEhXQkSCU9jcCEms1ieyfYSWFWJpDf+modohdv2Yu3dk/7r38m0ER4QJKG49x/
	DWpUvE0J8xInr4WOfoYEiYUFvHyafL+VY5m3l6jT28fEYBWr/dm1+mKwRhIqQEavR05kNNrCXujVn
	Rh9mgmO23M+0kA96GTsRcTtQze4gVfw2zoVYb5mua7sxF+EJtZpJTzlGj4mY13eXOWPxuMDoNu5xn
	rklLE8uqy2dHXqMX0/O2C1A/Ckee9oRQ/+8Zs7WQZnJasTCk28/ztVWkXtI5UAag==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3E6D-00000003Lf0-3WUD;
	Sun, 06 Sep 2026 16:44:02 +0200
Message-ID: <75869083607cf39b5a32616395b14663ecdf3615.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: p54: fix incorrect frame length check in
 p54_find_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@gmail.com>, Wang Yan <wangyan01@kylinos.cn>
Cc: zilin@seu.edu.cn, linville@tuxdriver.com,
 linux-wireless@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Sun, 06 Sep 2026 16:44:00 +0200
In-Reply-To: <5a29065b-87ae-4c63-873d-fa22b0899199@gmail.com> (sfid-20260906_162442_218051_2470202B)
References: <20260903081200.267514-1-wangyan01@kylinos.cn>
	 <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
	 <087d18429b448d5b63f922fd6779925f827134c7.camel@sipsolutions.net>
	 <5a29065b-87ae-4c63-873d-fa22b0899199@gmail.com>
	 (sfid-20260906_162442_218051_2470202B)
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

On Sun, 2026-09-06 at 16:24 +0200, Christian Lamparter wrote:
> >=20
> > FWIW, I dropped it because it really shouldn't have been there this way
> > since 'mgmt' can be far bigger than needed since it contains the union
> > for all kinds of action frames etc.
> >=20
> > I'm not even sure it's needed regardless of the next check since the
> > beacon is built by mac80211.
> >=20
> > Just blindly patching one mistake for another doesn't help anyone.
>=20
> Ok, alright? I just looked in both:
> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.gi=
t/
> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/
>=20
> Was there a patch already? Or did I missread the first sentence that hint=
ed this was "dropped"?

Oh, I didn't phrase that well - I dropped the patch from my queue.

johannes
