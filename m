Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC22264C7;
	Sun,  2 Aug 2026 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785694041; cv=none; b=LIJ4CDD0mdobsSulynFLd7Zv4oP1kcSqCdvioxME9/hr8By/4tRyutgKG7mkYfvB9F2Ajp4S1k9fPdBRXkOD1NkiVDa1T56zmDa8YYmRmaGWlDZwP27uT9frhWXVGYmDf31VqwfHxsMMa4e6tpIDGdoZJbY8cpqpl0G1/tT/EeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785694041; c=relaxed/simple;
	bh=3GLnhRhZ5ZtWlYBvzYRmLdWBLLxYQqTqnpK0e6Ug+gQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QExYoOjBaQVbk56c69g07kvZ/s6Bf396Rm0xHQe/vdNhqRTQVNiRIMhIo1LcDUL+xF7HntIBNV88t0WhtZlt55b4v7wuglM6cglgCl5FBQ7WHWVgSAwhvAq3O9Wj0BX36lwDJMUiazOmdyE6UbWVbfcKOb18Y8EoP+mP0Qhj9Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=R4QX6Kvk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="R4QX6Kvk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3GLnhRhZ5ZtWlYBvzYRmLdWBLLxYQqTqnpK0e6Ug+gQ=;
	t=1785694039; x=1786903639; b=R4QX6Kvkqm+2TgUjvFPJcSez2zrW4w1r7En2L9h3Y+Lkc2L
	Q8EI7A4B0L76BlC9QvqQo35tha/NqlQx7oB1/Ay6BYyY0UeeFoRzT99yJ8gsHWfGCSRGKGzHCkgE9
	3avN/k3MBSeYwPx0B6YYGABJ+Zw7oZwAzQOBURMvpKJHoVi9ZFQPgZKyzsqAehDpUIl6k45czb76b
	k0JL4ad0/CmfYm+1jC4Og8ZRPerKDkwZ6lOoVBxVpR5s+A7hpvA4cz1bj5uJSoEF2EQfx6/rSFwrl
	C+8I6XYrssCi93MALCfaR2y+SwB067kN9v2b1DJdGO1alMMJi9Vp50G+hlUdc5aA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqaai-0000000DxdI-0lAc;
	Sun, 02 Aug 2026 20:07:16 +0200
Message-ID: <3673f70c00e5059c644dbac17eca46e020db4233.camel@sipsolutions.net>
Subject: Re: [PATCH -next v3 00/13] wifi: cfg80211: consolidate cookie
 assignment for async ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
Date: Sun, 02 Aug 2026 20:07:15 +0200
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com> (sfid-20260731_143523_286560_2029D88D)
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
	 (sfid-20260731_143523_286560_2029D88D)
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

On Fri, 2026-07-31 at 14:34 +0200, Arend van Spriel wrote:
> NL80211_ATTR_COOKIE is a userspace-visible u64 that correlates an async
> nl80211 operation with its completion event. Three cfg80211 ops currently
> delegate cookie generation to the driver: remain_on_channel, mgmt_tx, and
> probe_peer. This produces inconsistent strategies across drivers: some us=
e
> an incrementing counter, some use get_random_u32(), some use a CID cast t=
o
> u64, and brcmfmac's mgmt_tx always assigned zero - which is arguably brok=
en
> since cfg80211 treats zero as an invalid cookie.

Thanks for cleaning this up, I've applied it.

Incidentally, this also simplified some changes that I'm slowly
prototyping in this area - I want to queue ethernet frames on the TXQs,
initially at least for client mode, in order to build A-MSDUs at TXQ
dequeue rather than enqueue, and to be able to more easily move frames
from one place to another during SMD transition.

I guess it'll be a while before I'll post _all_ of that though, might
post some prep patches soon with some "further thoughts" in the cover
letter.

johannes
