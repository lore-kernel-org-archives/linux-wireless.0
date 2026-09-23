Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA29B47A0C0
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790154601; cv=none; b=KmET3JCWy2m401lQNj8zOGeQdUysNPwdSCRqryn2K4L4ju0PRfVddmYhXuRAyIjj1fbzQFQ6UHXrxrkeSWv2bBM1QRgkuOqo0xmkQakCD/woWjX1HiYaCMWVLhBrTS0WuN24VmOzH0X/+KqWfIMTjcACoxHpo2+4BcglfH8oPsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790154601; c=relaxed/simple;
	bh=NVL2uUXDSe8UVs+D9FKlOgLuLLswb0xtaQ4XR1VvYsg=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=f/59px3oPN1aaeeGEeLimRmdurnr7G+19wf2GIXI4MvlRY+1sSeM+kMNW3PE5YOXDhXC/hyyyOrkkv8rLMkjHn5CWwbTPG7ZyzrKIEXn7FTdLhE5BYWIxaNlsU2YNk/ppORsh5Je1cEM0TRT37lQiAuPjOc2oHgIAt+JSmIEmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AI1O0Ts3; arc=none smtp.client-ip=91.218.175.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AI1O0Ts3"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NVL2uUXDSe8UVs+D9FKlOgLuLLswb0xtaQ4XR1VvYsg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790154597; v=1; x=1790759397;
 b=AI1O0Ts3zBoM6wGYX1oOxRN6hXOl8bz/nss1pEnrwK0zG8OWP5RErsTfPdVxWIY4DHzpBTvi
 ODPq2gAvsfh4HHMQhMI7rHkFOzfrrvznI4mRx0T99xd3TlLq4szQAVtpVsampp29UE4BFWmia1H
 g/3DlMxl5iFQODUyNlk1BqcY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 99c88c09ab6822ea;
	Wed, 23 Sep 2026 09:09:47 +0000
X-Mizu-Trace-ID: 99c88c09ab6822ea
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 09:09:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <8acd337635cda76b7e1f5dfacfaeb0c8c93a886f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 2/6] wifi: rtw88: 8723b: add the RTL8723B BB, RF and
 AGC tables
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael   
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <16eeca262aab43a798afeb806e88aac8@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
 <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
 <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
 <3ce6a66b25274fb0b58f259529359bfe@realtek.com>
 <09c6a890906e4d4e93d8dcde41e2b808b7d9582c@linux.dev>
 <16eeca262aab43a798afeb806e88aac8@realtek.com>

September 23, 2026 at 11:59, "Ping-Ke Shih" <pkshih@realtek.com> wrote:

>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20>  >
> >  > Luka Gejak <luka.gejak@linux.dev> wrote:
> >  > > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> >  > > +/*
> >  > > + * Copyright(c) 2007-2017 Realtek Corporation
> >  > > + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> >  > > + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> >  > >
> >  > I'm not sure if we should claim copyright year back to 2007?
> >  >
> >  > What would you prefer, just tell me and I will change it?
> >  >
> >  You can reference what Bitterblue did [1]. I don't have much study
> >  about the copyright.
> >=20
>=20>  [1] 1a7545784642 ("wifi: rtw88: Add rtw8814a.{c,h}")
> >=20
>=20>=20=20
>=20>  He uses 2025, so should I copy his line for Realtek copyright head=
er?
> >=20
>=20Maybe "Copyright(c) 2026 Realtek Corporation"
>=20
>=20If needed, more copyright are also okay, but I don't know much about =
that.
> You can study Documentation or somewhere to know more.
>=20

Understood,=20will do.

> >=20
>=20> Also I will address all comments and send v4 tonight/tomorrow morni=
ng.
> >=20
>=20No rush. Deeply what review the patches before sending is more import=
ant.
> As this patchset is large LOC, one iteration spends me a lot of time. I=
'd
> minimize iteration as few as possible.
>=20
>=20Ping-Ke
>

I agree that less iterations are better, and architecturally I
believe very little, if any changes should be made, therefore I
think only style changes are left, and I will try to catch as
many myself when I review today.

Best regards,
Luka Gejak
