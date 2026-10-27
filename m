Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793078565;
	b=hfhiM+63d2G5rX72C6qYHSTifpxu77XwnoXuoiKzljexkb3LrGxiwIyn2ASV3paRnHAI
	 6TgT/zd759Kr2yA+sdKjxao9uGxlhuXTQOwngsdgTl3Rj08hA2RufYaxx8UDql6bXDaR2
	 w+Lhvp+qqcxHk0ZnBeAuYyQf1wmpYV+yjVziXy160ZXfouG5Xcwwq/KS5ZvFITlX+kI2m
	 DWh8PqZvBKIAGF4O3NXOXXuFqDv8gB+zFEU0OQ9Y5PXCMDUpID3IXPjUxta44sjEKGFC7
	 fKVpNTC+BFDVk5xMYbHDC5xODKjKWmDg6TU/by9BHGauaFm+vvvUbIC3itLDksfXMKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793078565;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=3h0bipYQ30NNkirag0tbhJOK8kCMDwuO36JyJaVg3b4=;
	b=py8k3728/trYGW3EJ1HYNVcobKeZtCdZos8at2o6526P6FG/QtLMZ1QKs26tuNGrn2fl
	 bWSO61SfCTIuUmGh7JU3Fncb2m/prZ9/auek9oQheiwJHOHVivXVFefpI1/5SH6tKr5R7
	 FAG2ZT7Ufq0MkcTsRaaTfq1VLyYcj18wK/Ws3BcVpYAP4SN6nDlZcHd7uLF04QLF5qAS2
	 Sv6v4dWNp5AE1C8o8VCPOKjai5Z7IHNYM2LPOMcKluRCmrxh5KOfF9HX5xGCICKX/zxdj
	 G7s2ZWCPocFz477F8SfIUlGciTYv72L2/+tBbcyCHMJ86ZEwyk4ZLPN+RcMxi/d7V7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NE9h1eJZ;
	arc=none smtp.remote-ip=95.215.58.153
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FBA606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 05:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23FBA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NE9h1eJZ
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Fw6OyKP01k2g85iAwsOvqZrzw8/2cM1lYr4mwckRXJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793078562; v=1; x=1793683362;
 b=NE9h1eJZuSeE3+tazspnMNV37YFIazbCt0cbUuAKiNnUEkOqL50G+Cv4ne8Amp3vJBEI6RVh
 9Ev5KY9SQYCvw7fjyWOgk2LWGOXVGJtV7Rb/fIFjJyAsySNzXPlDLVLJ74A7gLDV2SvuqFdByrd
 wWY8kXadj7FCfX9Syojs+bUc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 563f3a0cdc2a19d7;
	Tue, 27 Oct 2026 05:22:41 +0000
X-Mizu-Trace-ID: 563f3a0cdc2a19d7
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
Date: Tue, 27 Oct 2026 05:22:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <55c325ace9b8cbc9af7ad7fa57a664d63e48d12e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <d6af5cebfa1a46e2bc2da662634766d7@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
 <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
 <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
 <ec4065a1cf2c4d0ea357694a1a73ede8@realtek.com>
 <eaaa18cd9f23a3731bd1f8f17eb0885d1a17049f@linux.dev>
 <d6af5cebfa1a46e2bc2da662634766d7@realtek.com>

October 27, 2026 at 2:19 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> October 25, 2026 at 3:49 AM, "Ping-Ke Shih" <pkshih@realtek.com> wr=
ote:
> >=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20>  >
> >  > I was thinking, as staging got removed, for 10-ish weeks(until 7.5=
)
> >  > users of RTL8723BS won't have AP mode. So I was wondering if these=
 two
> >  > patches could pass as fixes into rc2 release(or whatever is the fi=
rst
> >  > rc into which rtw tree is merged), as this would be DHCP stall fix=
. To
> >  > elaborate: when this driver was merged it, was exposingAP mode to
> >  > userspace, due to RTW88 doing it globally. Therefore AP mode exist=
ed,
> >  > but wasn't working properly. So maybe it's a bit of a stretch, but=
 I
> >  > think it's a valid proposal to send it as a fix into next rc relea=
se.
> >  >
> >  Did you think people use staging driver with AP mode?
> >=20=20
>=20>  It appears so. I saw on forums and articles about the new driver t=
hat
> >  some people were complaining because only station mode is working
> >  because they exclusively or mostly use it as an AP point.
> >=20
>=20This lets me think if I merge RTL8723BS to rtw88 and delete rtl8723bs=
=20
>=20from staging too early. The staging rtl8723bs is a vendor driver whic=
h
> mostly implements "full" functions, but rtw88 should be not. To smoothl=
y
> migrate from staging to rtw88, we should implement equivalent functions
> before merging, at least functions people are using.=20
>=20
> But I really don't want to go back to staging driver. Let's pick the
> fixes of AP mode. I hope no more functions needed to be picked.=20

That=20is the only thing needed to pick. Other things are already impleme=
nted.

Best regards,
Luka Gejak
