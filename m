Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7897D4CC29F;
	Tue,  8 Sep 2026 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897101; cv=none; b=a4uEfu7IcKvpq1GjUxgUjSmAFB1CSVeiB197+sYS9AKh/8u2uLpt0JNQRcd126lzkCy6aL+KM+jgw+1NNuN3JYr0Yh6JZIxN5D8yXyd8i5p9ZRlLnUbNZ5pEE4VEzMh4mV9EsKENCKU05yIxUeJ7HxOYdDJXTMHv3aQBb15EgCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897101; c=relaxed/simple;
	bh=omPlMiTVCW327mbMqINUVXlknUzAf66hUuY5nfrH8QM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f99KTQXqgOT1+oH0ZLOaRCP2l3Z9xBqNCHAEF9XpcN4aJcNvZBgn3NdKeef/b7tEgAGDq5p8nT6xO8chmNJmXZF3S1uDhe2DQxQ3lgxtYMAmLqjGOMoimljb2YFYG6jwT5L27jokcnGTO4gKsNgTzp+A37hXE5kFb80IpuK39Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZDveY/od; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZDveY/od"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=79AAB6e143oUnf3Pvsxqw7MU2OH/Wj39JnNK2/3pLL0=;
	t=1788897099; x=1790106699; b=ZDveY/odX2C80yxNsNMtBYjLkmK0HcGlHi6X7fkjOrWHFZ0
	w8vcmFKNmiD15EyrTMQgIXkiHDrzQsCr3hSb+5FwDKtJRnURNBA3ZlYKWzTenSctqqeIqmsb064Na
	V7vd6Xg4BcAHcY8w6MmJYuG2dM+YDCFgtPw4HxWdTSp5oG3Z2+1ypj3rmJUmxbObP3cBChEQY4xrh
	TJ+j0ui7lBzTgRIrvWdMxdDHPsL/wUvi2pUiYmH/QZN7ZkIRvINqbSEY9WfuCM1IfGjfHEAI13Nuy
	B6yBzv7ADuAF/h4Mvh3luPNejt63/dFz5+EIIpBvZWUlDWK5HNsN/kbVg4oOQj6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x41qu-00000006amv-16QI;
	Tue, 08 Sep 2026 21:51:32 +0200
Message-ID: <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kuba@kernel.org>, Pooventhiran G
	 <pooventhiran.g@oss.qualcomm.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, linux-kernel@vger.kernel.org, 	netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2026 21:51:31 +0200
In-Reply-To: <20260908125017.0fb226c5@kernel.org>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
	 <20260908125017.0fb226c5@kernel.org>
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

On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote:
> On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:
> > To: "David S . Miller" <davem@davemloft.net>,        Eric Dumazet <edum=
azet@google.com>, Jakub Kicinski <kuba@kernel.org>,        Paolo Abeni <pab=
eni@redhat.com>, Simon Horman <horms@kernel.org>,        Johannes Berg <joh=
annes@sipsolutions.net>
> > Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,        linux-=
wireless@vger.kernel.org,        Pooventhiran G <pooventhiran.g@oss.qualcom=
m.com>
> > Subject: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility=
 Domain (SMD) AP support
>=20
> Why are you sending this To: core networking maintainers.
> This is wireless code, what do we know.
> Drop the core maintainers and netdev@ going forward please.

They have patch 1 but I already told them a long time ago that was
completely broken, I don't know why this is happening ...

And the RESEND was also pointless, I dropped it without looking because
it didn't even *build*.

johannes
