Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D8D36492C;
	Tue,  7 Jul 2026 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783425242; cv=none; b=vF88udABtafqOeoGgc8gaKXe9PAUdi/FTdDZNfQlXfX8tVi5JwnEXFoNhBJBpAr7PgrlO9ws/Um+/6P/7CRII0flo9j+foZvMZZFUl8hivK0hFrosaxh8C7zrpWYeAiOyVeM4KOCV2TA4ggdIWoj/5ieccz4nkGLvd/dJL8PLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783425242; c=relaxed/simple;
	bh=UQG5tqqR/SxCXiYIVw9rXYRTneBRCFBjtBbXNLE8DK0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PggNL9yQLTapTV5b/jl3Cx/gYqAUUjmBG2QY5ppnkSATfSrNIxBqAzV3cc8eAG6xXss+TzrAD3VFnt8ilekmOWu+f3bKurniVzptT0dT/UcnQ4Ehn+eCrBUysri3YYWd+CCuaar2pL31Q/S8PT2FZlpKl2YD/1XpYOJd+tBzr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dN0PGSmL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dN0PGSmL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UQG5tqqR/SxCXiYIVw9rXYRTneBRCFBjtBbXNLE8DK0=;
	t=1783425240; x=1784634840; b=dN0PGSmL5G46yM5LsPZuje4S1giu1x+yoq6Ikty3eAXYgSf
	5PW3j057lJfJ7VgFlAEym1eDHCZtDJvoEbjkt3flIc6FaQpW/ULfjs5B0dY+74QOPriZfX/gmXO1q
	0pxEtnaijyZf7u+Gp06w9lUZftvnN+iRNEcYtTHvXBSZviaafKKhhVvoHjlM5k4KKR4pmFqSlqloN
	nqfp1/4ftjDRM8in9LIEzwk4dzMFgkKWOIDr+d76EAERjg3XghDjkOFrTgq00HnrXCmhmRX9pKjPX
	sCRa2QpWM7J2ol/vSbJBUq+fOemobPXpqUBYuP3iD3qv77tmvYvsiWsw/w/1jDMg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wh4N5-0000000HZMV-3sN0;
	Tue, 07 Jul 2026 13:53:52 +0200
Message-ID: <6fbaefdeba935d0adaed1992037d0f746b9821fb.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: fix heap overflow on a short
 auth frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, Maoyi Xie
	 <maoyixie.tju@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 13:53:51 +0200
In-Reply-To: <996adbdb-9531-49e1-8cae-5fcb7b914d19@broadcom.com>
References: <20260707063155.3099999-1-maoyixie.tju@gmail.com>
	 <77dfa2f3-296f-470b-8d21-0f10a56a2a4a@broadcom.com>
	 <996adbdb-9531-49e1-8cae-5fcb7b914d19@broadcom.com>
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

On Tue, 2026-07-07 at 13:40 +0200, Arend van Spriel wrote:
>=20
> Actually v1 was already applied to the wireless tree.

Yeah, I thought the Link: was fine - I (only) add links to the patch
submission itself for tracking (Linus isn't super happy about accepts it
now), but the link given was to a report/further discussion, so that
seemed OK.

johannes
