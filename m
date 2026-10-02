Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7F47DD5F
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 10:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935963; cv=pass; b=cOFGUiqPfTxA4rCGUiMW41lSvaQDzx0NHwB336i2mKtfnPwdYUpOu3a/3XFeo0ib0Rt4UppZCzTW+BUZgLmgtJstWQHAfwaNPLmGw6mOsBg/CgNccbex/jv3NzYD+2ARvYiy2QRqIty3a1/TsnhqtHnFFv1ASc2ZTarZK0vVHMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935963; c=relaxed/simple;
	bh=KfWkAC7ciIkbo6PDaSl0uLznVmfVh3leTBBxkpyFSjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvb6rjVrOxkHM6FJF4eBKVvme12ApisnSwE96zjcgnj8yDWJ35En78LHAfR6yEb4CGC3GaIJgvsL0G0zWGCFEHLFs1yt4bvSxmP/F3EY1mqTAtIQEK1EmRxHVvnsW2cf6zws4Jv7oOTilRLpcdzekstcghvvqz5Rrz8o4m7RDl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCzZsjB8; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCzZsjB8"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba330dbd67so3364201e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 03:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790935959; cv=none;
        d=google.com; s=arc-20260327;
        b=Zg3twVG2Ma9wv8Fc1yJxz3bkUa+O6fNmx3gAyA0gdFN69WiXoVkNc6zbz1aCvUTcxk
         bYjCuHEZDI5pGl1e8OWHXP+qytnK8oJubW2aLAaIkvMrR1ZePrY0t+BF3dveFA012YJQ
         FcyoVO90tF5PL/PORfNL08o1EePTnahKJY5eSYyiH0t6UX28Rw5hNyfW4w1QXwQdIQgH
         Bu68qf+SKhmRIxY9nxRaJeV92XCQs2SoNoBBkKKow1xwpheCG9fdmh0DrreP9VBpEUma
         d8q7fapvk2QRNfceaiXK5MCh/sN1M7uBtyEGHNVJ9Tu4brbL0uOc4lFXwtOc2z8aOPHe
         KrEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nul3VjPP6p4uv61w9bRbyY3s7TwhdtmKvGkMiKjUI8c=;
        fh=G5vXVxugKcBzqnzsV9oLoAu7e9StgzwGSUcUBHQo9GA=;
        b=hM8s4JlyZM3Qai7lIrHMMUqOk1LI66DhXGtq/sX0zw8AYUuTzVjyau7RbB28fWgr4O
         nExPVOm0LxXf+rwf9Ce0HM/nynVcZPeQfXSDh210RGwmAt4d0utz6im3XWdqBFolkgFc
         D90c7U8olvaq8PiblW++jAe7+xZMJVDcd5/WyBIzdRYYKBFJXtHABR0kdv1AHQXF1SiA
         l3xhTY/7Lps7kRtok3DFzTdJjDCmx23khOrvEhBmP8OPXb+5PtaFBmrNFqIOugan5L5w
         eO25oSosMPqGUwZPK5FufLKO8BgPEiDgfPiTsCOHjem43R9CnHDG96uj6jNTS65/o1AV
         lHCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790935959; x=1791540759; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nul3VjPP6p4uv61w9bRbyY3s7TwhdtmKvGkMiKjUI8c=;
        b=hCzZsjB8PgyB5anSul08lit+C1jRucuP28QGt8obp7RKjLP8LTCmMQN7N8uYA6LyGP
         rHcOew3mJhljYm+OMCgcahnkIEwcg1w0QTn8UmVlLhTpYFYJFjDXkYc/s0lbmdrrZ+AH
         MEXwLHnbm2mh1+AaNIjvnuCoLRGsMC2mLt2ECGOU6PpnyjTspPYC4+PQh5IKjCrydNoV
         0jhYE57svlhfk5jVj0gipUf672VTSgB1hUeso49UWBxeaOEUX3d5yZ4Tn4RBFl45mC2l
         zTI0OzHvT5fiX3XeurrHIqGBJifGxJTRUjg34XfOJwOy3Adg3c/t+20j7euNiDNq+ads
         sQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790935959; x=1791540759;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nul3VjPP6p4uv61w9bRbyY3s7TwhdtmKvGkMiKjUI8c=;
        b=Ycr2PHDkUfUEOVs8OPQG1PAVJa1Atew773h6o5SX3N1GLOw3IJ7Q+gWxbxIhD3wmfJ
         i6GBSsz3bJYsh6kU2lud8vh3Wfgr0yJ6MzZ9opFg0JmvL6e/FDJdFH9Aj548W7gZ4Hal
         dOMDgg+qR16fpGseE0XERHQQbsRAEeSjT8CamcPJWvA1TelPIzs9GJXaw6g6MwOiGRGj
         8YREHBXwQErCq99nk7WVtINIWG1QkZ/PLl7nemdMEi4WX4Q5taNV/ryStkqRbTFQB79v
         uBqivPJLStbX3atvPVX8WiV0d7Vl95MTzfvnGfDJoN2keLAi6OC6fVDquCpdERH4cJdZ
         3jTg==
X-Forwarded-Encrypted: i=1; AKwUvBzT5lQdmypvefwGHe7pPK2DbrrhPGKTCjmXcWYbyrN5z0OPlo7jSGnPDb7QFNWg56xWktVoTr3crjTqQqHDsQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK+NJK8PUIH8j1RbfS94IwYfUFf1byxe5JKwgB1Iu8o2R2zSdlI
	yVkTdCX9gRMc5mYJvVZZHGypSVjZQEAtH2t9qpUv0jPetQvgyZW7QZjnVil59o0ZKTZtQaU+et8
	CefBjPrk5K8xFAcb8/F4GHl1FruVsiPc=
X-Gm-Gg: AYBFou2CyX/U1DuDQ2g93V4vP1oVLV1rClIApdzLtjFRZ6k7XZC36FXBBvn/rCHn6fe
	qOcCvTiZoRA3h2OfJ3BWIFUuHHdgNJOvmeBqf4+hwuH/FnuQz0YATjjqzUYzFB5P75sRhCucp9v
	ocZTs5te5ox5+VA2fnDUrU6CeMtNra5T80eKv/q2dTDO11GjKlSIdtlfk+bN1ZnLSVgg+Ax/+ZE
	xuGuTZL1m09zxOVboTp/I4vDg4tv6xXnGEUWxaDqT1MgdCdafPm76cg+Tn7tuCEKheeD+mM17VE
	Eg/akAaVR7IkquZ7Pt0a/UL9TAHbNeYKf/R509bjKJrs9uc+YiU8UV2s62Ko1e2yiQqKhwovB6s
	AiHYIZpzBD9coLUIvATXOXg==
X-Received: by 2002:a05:6512:a93:b0:5b6:1a7c:aa12 with SMTP id
 2adb3069b0e04-5bb9bb1da91mr722330e87.42.1790935958794; Fri, 02 Oct 2026
 03:12:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-5-sigefriedhyy@gmail.com> <179089748154.434549.15968186317991628500@kernel.org>
In-Reply-To: <179089748154.434549.15968186317991628500@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Fri, 2 Oct 2026 19:12:28 +0900
X-Gm-Features: AclHuK85FbqNwq-ELq8SKnyUcRuKjUZjdyqLDZaraiuSRJzWpMMsnKZCTynBQIc
Message-ID: <CA+7S2vKEVD5HUnotmTZ764iJXEWbPXY6bDp9i6p3uzm7ZFJkCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 4/6] net: add AF_PACKET multicast dumps
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> - [Medium] Concurrent device removal can end an unfiltered AF_PACKET
>   RTM_GETMULTICAST dump early without setting NLM_F_DUMP_INTR.

This window is in unlist_netdevice(), the device leaves the index
before dev_base_seq is bumped. Moreover, it seems it affects the IPv4
and IPv6 address
dumps the same way. If it should be fixed, it seems it needs to be
fixed seapartely, not a new issue introduced in this patchset.

> - [Low] The commit message gives a false reason for not extending the FDB
>   dump.
> - [Low] dev_mc_genid is only bumped through the __hw_addr_count_*
>   helpers, i.e. when a dev->mc entry is added or removed.

Agreed on both, but they are nits, will adjust if there is a v10.

> - [Low] At this commit, Documentation/netlink/specs/rt-addr.yaml does not
>   describe the new AF_PACKET multicast dump: - The ifa-flags enum stops=
=E2=80=A6

The spec update is the next patch.
