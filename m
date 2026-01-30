Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50B284898;
	Fri, 30 Jan 2026 08:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769761088; cv=none; b=iUgmkV+wHccyp2x/b18cEXnZSEL8QhYTI8YbyGL+WsbSFPkkK0QYpXvv0Nwe9Abd+IJ2XvZpKvX6sJdzGXfmqLEMNsxeiytnk/699wHzLgogxcCGL8DIAHtxMkFl4MkOBnHJUlypWnyxwb+RiX/KzTixA8Lwo5+n2a9/wU5JW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769761088; c=relaxed/simple;
	bh=xCzL548OVGU/CZoRZbMzTvCjMYH4riptZHgiKQ8loY4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BZvVu7U3Tep48BkLdocBNb53zlUZKaWoTdbG3cgfq9pMnq1dJZuXGF9jzEuMrFdK2zCepDNP1nsKnsk5LtIjz6Kv0gsV+XhGPGzZ9jYTBE5/5pqyaA9Xr9snrDQOigK6V1bhkeD8zXhfS5AYkRJSWXjDXERVbuh+4rr5RgPfBfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RLqVWVzk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RLqVWVzk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xCzL548OVGU/CZoRZbMzTvCjMYH4riptZHgiKQ8loY4=;
	t=1769761087; x=1770970687; b=RLqVWVzkjGLEjjhrbFY9yh5pDbyD9O0PzIdu9ZzgocwrLzJ
	6srp0f5ZMpFTiAd4rXi7OL/9n6kjVJz3gFUeOUFfcgkZrSyJteSfn2jKPGtm2zyB9sI+rEB6KxP16
	CP9HyXCRWLvjFrxG6s9LASFvZ93DRTgPKbNj2sBKF/ko0uMXCSWKI4xnKSpFco3KdbiG17x/5SEuj
	TAmMDHvvHxFZlMyW027rRHeOqrkcGJw80iw0lIcfDM+3cDGqqKPPYS4uSQ/XGrl+qCV15WG7e4o3D
	jBA+VMNlM//1uBbmRvdJ2Dj7xN6znT3FJ0SejACxSS5YQkY4yvtQLV1TDY04x2rw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vljhc-00000007kYJ-0iEh;
	Fri, 30 Jan 2026 09:18:04 +0100
Message-ID: <63066fe204fa808ae305c663a2abcc9acf0e26ef.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-01-29
From: Johannes Berg <johannes@sipsolutions.net>
To: Ping-Ke Shih <pkshih@realtek.com>, Paolo Abeni <pabeni@redhat.com>, 
 "netdev@vger.kernel.org"
	 <netdev@vger.kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2026 09:18:03 +0100
In-Reply-To: <a3298543662a4ba68395a61d687b5e0f@realtek.com> (sfid-20260130_082244_496343_1BC79E82)
References: <20260129110136.176980-39-johannes@sipsolutions.net>
		 <b0d6887f-7946-46b6-986a-bf410b832d66@redhat.com>
		 (sfid-20260129_150854_647905_46B9C6EC) <f20c64ea4f4a2d3567ab707d98a5164457b02735.camel@sipsolutions.net>
	 <a3298543662a4ba68395a61d687b5e0f@realtek.com>
	 (sfid-20260130_082244_496343_1BC79E82)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-01-30 at 07:22 +0000, Ping-Ke Shih wrote:
> Hi Johannes,
> >=20
> > I just did a 32-bit build manually, and only see some warnings like
> > this:
> > drivers/net/wireless/realtek/rtw89/util.c:43:45: warning: decimal
> > constant 2238721139 is between LONG_MAX and ULONG_MAX. For C99 that
> > means long long, C90 compilers are very likely to produce unsigned long
> > (and a warning) here
>=20
> Our local 32-bit build can't find this warning. Could you share .config
> you are using?=20

My bad. It was an old version of _sparse_ giving me this, not anything
about the .config etc.

johannes
