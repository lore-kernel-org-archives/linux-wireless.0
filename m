Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6324E56CA
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 09:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673472; cv=none; b=h1SjB3aXESIUUCldrKqrhQNYFKlkKPnzqICNZLUbjaxajfEPQ/a64CsEOesGYM9R91T9piWKaUYzV0bqfYpnKArwHTRqJ8OYaKD6khD2opT7wX0h2e1RedvabcpWg91tiQ9LAvPjUFHP/O+Wbuj2dKjdGtrShVzcyc2cKE1m97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673472; c=relaxed/simple;
	bh=iSukeeK7Al6PNeJotCXePCjE/8w/Cz5/cLnryJ5km90=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=lKiotiRXwagB0Sq70BWlPePkaS3JDxbxvZYBWyDWFosbcInsjMJ97JMk7V874Qzk72mo4cz0ERmGXTTPhdOcAuWS/Hd872nWGkWP7gXgKUg2m5qWWntydAhjlutZdFpp45fryKsRa0AOwymKb1sbilM6dCozZfqGxJSxyzNF+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hou/j0do; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hou/j0do"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iSukeeK7Al6PNeJotCXePCjE/8w/Cz5/cLnryJ5km90=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790673461; v=1; x=1791278261;
 b=Hou/j0doJ+qZJh8dGopI+sM3NWwd8w6EWjNjtH4msqqvs2dwVlgfOOycw4B8n9ssm8Zp0pDP
 dvUf1lriMcl6LjpxhBQQ3iOlpX2cDNJOZGmhSrmeljTZMIN9B0qMlixYQTdB33NR7dTH+K03A/q
 lsKy7eGT5rnhAyrkfYflwoJY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ec4e120924e067b0;
	Tue, 29 Sep 2026 09:17:41 +0000
X-Mizu-Trace-ID: ec4e120924e067b0
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 09:17:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ac5f41d6e13f2331fdbbebd66fc28748e4e22502@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael   
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <6cd39b84d1b14bfd82887c07f28e154b@realtek.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
 <afb044e0aef8425880ddb24add9340ab@realtek.com>
 <DLNBECY70VGJ.DRSBNB6M66U8@linux.dev>
 <c7069bdf8e9845e3b26898f545b0d3e5@realtek.com>
 <e38d50f20a710ae0b1424924b16ad260cdb04b99@linux.dev>
 <b6c4c35b28b1262b390d5c05993426e3b6d4ee95@linux.dev>
 <6cd39b84d1b14bfd82887c07f28e154b@realtek.com>

September 29, 2026 at 11:08, "Ping-Ke Shih" <pkshih@realtek.com mailto:pk=
shih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E >=
 wrote:


>=20
>=20>=20
>=20> > I even think we can drop this patch, no need to update MAINTAINER=
S.
> >  >
> >  I little confused, as this conflicts past emails and this above.
> >=20=20
>=20>  I *am little...
> >=20=20
>=20>  So how would you like to proceed?
> >=20
>=20You are the first people who asks me to add MAINTAINERS, and I have n=
ot
> thought about that before.
>=20
>=20After thinking this weekend, I think the basic requirements are:
>=20
>=20>=20
>=20> > Anyway, I want to see people really contribute community and then
> >  > add their names, not reverse way. I don't like to clean MAINTAINER=
S
> >  > sometime.
> >=20
>=20So, if you ask my personal opinion now, I'd say let's drop this patch=
.
>=20
>=20As you subscribed mailing list, give suggestions and reviewed-by to t=
he
> patches after reviewing.=20
>=20
> Ping-Ke
>

Understandable, will do in v5.

Best regards,
Luka Gejak
