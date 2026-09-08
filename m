Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F0D581257;
	Tue,  8 Sep 2026 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897482; cv=none; b=s/QPljw437NhfvrGHQYGBM+yZeQvYc8ULf+SrOCdyyGIQ9GZpErTyh6V1MPaLCAj3Ku/UqO+Tr2S8ywH5ciCHuyIYYg6fgELV26NwFvIFrxf76GvipJC3Pj5l+SYEW92cvNhMy/A0EtmXMUBLW9MhMX98o4HVDaF/cz9s3IEZkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897482; c=relaxed/simple;
	bh=XpDkEhTr/Yw6iMwMZrlhsnShseISqHoN+G/QnxnT4Vs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i9Zw+9Q1QnVwg+0kSFup7xr35dHRjdZVsc/KUnrcZTjxgYjup54MZ7+hcroXoPAN5jSQ0nGIJ5G5Fkkrj0mOwBa1XfoWFURuU4GN0dJ1WoGEkrjRqQBpw3uVYoCgVX8x7PxHltNYb+FPzT5vXqvwuk9IFST3ZJECQikQrmGYsbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=afAyLKJr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="afAyLKJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=aiQQXJOEjT8TXYxFZKkRfnxpC0Z1QBHC+/5QZK2v8Hg=;
	t=1788897481; x=1790107081; b=afAyLKJrHOl0JaYwhNoipUGs52IVhotv8ItNclGmLcIFP9o
	cksMgr0xu3yAnov+djOKp/adyscyLn2GlOsR4sUSD4prc4nQn5YKyuWnOKT5GEinA30QpGLEvxzgM
	gMSgoNstpivnUpthUYzchY7w392/hZpX3zb/JpMHHqdpBdO5Ekz3Z48bz5xmLXb41+9Xj8e7EWTDb
	2Yxa2E2rPHztRAKBTQR3qNv5sz7WwylZiQRku1RRMHvnVHlscitRg49KTp3whOeCvEDdOzFJSta6T
	VBsuF0RvnXyK22gXdS10fTD7DnFgVH4q48/Z99jPx7KGvZqNViXBcl4+WrTwgiYw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x41x3-00000006b8d-3uuh;
	Tue, 08 Sep 2026 21:57:54 +0200
Message-ID: <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kuba@kernel.org>, Pooventhiran G
	 <pooventhiran.g@oss.qualcomm.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, linux-kernel@vger.kernel.org, 	netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2026 21:57:52 +0200
In-Reply-To: <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
		 <20260908125017.0fb226c5@kernel.org>
	 <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
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

On Tue, 2026-09-08 at 21:51 +0200, Johannes Berg wrote:
> On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote:
> > On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:
> > > To: "David S . Miller" <davem@davemloft.net>,        Eric Dumazet <ed=
umazet@google.com>, Jakub Kicinski <kuba@kernel.org>,        Paolo Abeni <p=
abeni@redhat.com>, Simon Horman <horms@kernel.org>,        Johannes Berg <j=
ohannes@sipsolutions.net>
> > > Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,        linu=
x-wireless@vger.kernel.org,        Pooventhiran G <pooventhiran.g@oss.qualc=
omm.com>
> > > Subject: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobili=
ty Domain (SMD) AP support
> >=20
> > Why are you sending this To: core networking maintainers.
> > This is wireless code, what do we know.
> > Drop the core maintainers and netdev@ going forward please.
>=20
> They have patch 1 but I already told them a long time ago that was
> completely broken, I don't know why this is happening ...

Actually, they did fix the free issue in there, but ... dunno. I guess
I'll discuss it with them tomorrow.

johannes
