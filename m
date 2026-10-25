Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917001;
	b=MJnxoNU8Ibbd6pmvkLfRGfmOkMMMiki0l7J9AueQWU8etlKMd54aDoFL9uSyY0wbOabA
	 6zN3fZVvCkiqIL6x9WoKR3WLVbrlnzDPIVZQ5biUtaz56e78u3c0QAZ6BSrFLifyqoGK7
	 jaKVLX+RjH/IRoJ8vTVJpj/R8qBB2seuY9IBdf4ae2RAnG0WOAPPQkDsq1YEVdNkBYx5H
	 k3rZ+5Dy0zls7ZBTQPGZI7KQXsgKW7b0IEeeT0GpMIIStD0podRe3LZu2mbf0UWRrgMbl
	 Vbl22ytrFVoutZZlkT6B3K1BPwDEg5J3Tf7TRPP4gTd9xw6AP1W0xWVXQu7FLpm6w3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917001;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:
	 In-Reply-To:References;
	bh=aIlnLoJ4Y0Z0xK1aVyqwtJoyLmThHPvvVkpW2bgAwjk=;
	b=imVL9VWUcU29oruOvcpA6UN3C+HsMxE33gl/VTX4eVardqCzGIc46Km1DcVEvnOZGeXp
	 5gmR31yrN5/licd2LYAYNl1jKk2QQTsuUQiCcgbVXD6EjSubjbejptnttmwVKY08q77mr
	 bKO/JgUmkCZvo8FV0xXyjA0Z1snFxyUbqYNysNy8vRn2UTq5ucoZrImSZcFysJ5HuCwQg
	 ZXEpnS7mf5WfXf4EIjxzUdV2rTYJPPjkeW20VjFBnRUcOThYdpqbk2C6AgQyfHPvEdLwE
	 /B7R9t8dlrA3+tUvrMsnxrJ4eWwddI2yNvCG/Uzw3bQNnrFpWZ9B5lZWMr2pMz3Xctg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="TOVW/vBu";
	arc=none smtp.remote-ip=91.218.175.12
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965B606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 08:30:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8965B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TOVW/vBu
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=v0JL44eMZ8rFkgWng4B5IzytzYgPVW6l+D7dKj8oM8w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792916998; v=1; x=1793521798;
 b=TOVW/vBuYop6oQTWrOi8Zh5reicWZCOsRXPKSaoPgRLCtg4+H+FUTZbt14xTgmuSvl2Iwlsm
 lME/5hg4D/8xX/KzHq6WlpvNCjP9qHSXyzSj95iPdggvJvKmz2ZCsC/sle/vCgigM64LdLiO8/H
 pCa0EVTpWoq6xr6eeQmSYbUQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 24a1db5822e08f63;
	Sun, 25 Oct 2026 08:29:58 +0000
X-Mizu-Trace-ID: 24a1db5822e08f63
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 25 Oct 2026 08:29:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <8331a75e3ee92551eaa9256be8329a843d7bc184@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Carl Quist"
 <equalizerjr@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <836925ba243944dbbc74a713d63d74c7@realtek.com>
References: <b35b82f1331141faa3603574fa3697ac@realtek.com>
 <20261023201724.68885-1-equalizerjr@gmail.com>
 <836925ba243944dbbc74a713d63d74c7@realtek.com>

October 25, 2026 at 3:38 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Carl Quist <equalizerjr@gmail.com> wrote:
>=20
>=20>=20
>=20> Would you be fine with sending v2 as it is, with the commit message
> >  stating exactly what was and was not tested? Or would you rather wai=
t
> >  until someone with a sniffer can run your checks?
> >=20
>=20With your tests from user point of view, I think it is okay. That'd b=
e
> good if someone can capture a sniffer and analyze it, but that isn't
> a blocking item to merge this patch. Please follow Luka's suggestions
> to spin v2.=20

I=20can test v2 on rtl8723du and another card as a sniffer if that helps =
:)

>=20
>=20>=20
>=20> If there is a way to
> >  check any of those points with a single adapter, I am happy to try i=
t.
> >=20
>=20I think no. Driver isn't aware that packets sent by firmware/hardware=
.
>=20
>=20Ping-Ke
>
