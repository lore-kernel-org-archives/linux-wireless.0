Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662E3E717A
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 12:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791289164; cv=none; b=FmSJgwjxU0vaKi5roK2oo9Ap9DyTdhHidCKV+a4H5iDvdzacbX0ZOI7l5Yr9Lz990rnOwyqqk/ELzUBkJtISmZ3B9GCMbqTU1VRA0mHqv2yT7y18Kl9qKm1sGoSFNiCFs0zCj6ukZcGV6BqziP0eXmgjTSdYdrGQswm7C/lDGyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791289164; c=relaxed/simple;
	bh=3hHU8L2POZNJGy3vALHqfv0rSAOQHEs0iJx+Kc2DoLw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=KBGurNKbJ6Is6d8t33jmLNGa119FBFRtyM4wt4zYACXiXwWwIc70CC2m25uujPyOy6MQ+42VXGr/VItVzM5pUmsPOGrgW8Qd4Jkqm5buIXlJAFfiLhneIo2jrkY59QJ5bUyiSz9WQ0gQTLoLZ0AhbnercB2NXKBU8VTeA7YVXbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dea+f9kx; arc=none smtp.client-ip=91.218.175.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dea+f9kx"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3hHU8L2POZNJGy3vALHqfv0rSAOQHEs0iJx+Kc2DoLw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791289160; v=1; x=1791893960;
 b=Dea+f9kxtfX5sqciFVjSjN3ihPZ6XSmS7GUrzZdtBDbKVspaeqIdtvUk8ZgTPCq4kWM3itur
 jBTPIYgOLv9J3YyeMF2TQeKaq3DQD09rbhcE2zDWdgjHewYUBTDW7aCddXmB5JkBUgkLA32Tlrq
 8lTtBzr5kbtq1P0MQrhDsL98=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 819c3038e7e603b7;
	Tue, 06 Oct 2026 12:19:19 +0000
X-Mizu-Trace-ID: 819c3038e7e603b7
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 12:19:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <452b014a9d4c509260c79eef66a975a5f723c1e8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <3a57c874-ab57-4ca2-98a9-d5cf4fdf285b@gmail.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <3a57c874-ab57-4ca2-98a9-d5cf4fdf285b@gmail.com>

October 6, 2026 at 13:18, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mai=
lto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821cer=
fe2%40gmail.com%3E > wrote:


>=20
>=20On 06/10/2026 03:39, Ping-Ke Shih wrote:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20> >=20
>=20> > On Mon Oct 5, 2026 at 8:08 AM CEST, Ping-Ke Shih wrote:
> > >=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20> >=20
>=20> > [...]
> > >=20
>=20>  +/*
> >  + * Shares the receive PHY status layout, the SDIO aggregation burst=
 fields
> >  + * and a few baseband registers with the RTL8703B; reuse that heade=
r.
> >  + */
> >  +#include "rtw8703b.h"
> >=20
>=20>  Which layout you are using?
> >  Should you move the layout to rtw8723x.h ?
> >=20
>=20> >=20
>=20> > The layout I reuse is the RTL8703B receive PHY status structure, =
struct
> > >  phy_status_8703b, together with the SDIO aggregation burst fields =
and four
> > >  baseband registers.
> > >=20
>=20>=20=20
>=20>  Let's use another patch to move the struct out of rtw8703b.h, and =
rename
> >  to phy_status_8723x for example.
> >=20
>=20The same struct could be used by other chips in the future, like
> RTL8192EE/RTL8192EU and RTL8188FU/RTL8189FS.
>

It probably could. The layout is the vendor driver's
phy_status_rpt_8192cd, used across the 8192cd generation of 11n chips.

I kept the 8723x name and rtw8723x.h for now because the only users in
rtw88 today are the RTL8703B and the RTL8723B. When the RTL8192EE/EU
or RTL8188FU/FS drivers are upstreamed they can be pointed at this
struct and it can be renamed and moved then. Same way this patch makes
for rtw8703b.h.

Best regards,
Luka Gejak
