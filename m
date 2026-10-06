Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8539657A
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270426; cv=none; b=SRUeo1f4+zKnyUmXba6jhWNQchhrDj7IhWGr1JzNyipjTDCAGSawq9/kprjL/CIFfi1aWjja/ufOgf8mO9Ug436HFDCowrsuyAQVBPbaY1+bcfcDjRiTVow3/1r4HSGo7ENeiy37mENfpIa4VBjbeA9GUp9N0GNMogG4z9Sin6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270426; c=relaxed/simple;
	bh=iiX60+Z7HoWkdWXO4dHEAUZDSGDyej80VhEbBoX8gwM=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=AgBYbiW++OCcDm44j1HEwwlh9c3Ew4fiq5MzY2ijAQfqW9KimhT2JcH6xAzG9iDdqsH1nIuWdncjvoHEpT1Dq6M7Tgj78CJnx9VAib1a2JSYuQYZA54V0u/B2q7cLnguP2bu+JITPzmAvcJB2H2MMydlSC1gHGhozUGnkGO+DZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aVoL/uSY; arc=none smtp.client-ip=91.218.175.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aVoL/uSY"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iiX60+Z7HoWkdWXO4dHEAUZDSGDyej80VhEbBoX8gwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791270422; v=1; x=1791875222;
 b=aVoL/uSYBWCW1DCoo2IBDE4gl3og16/jKx5nsu68OzA10UuILy+It16WU3knCDsT0dqH/nHq
 Ye8j/BAalO0FwQ6i3Z4zIEB1M6v8gGTZ1LD9bgquoFbznXTW4M29w/ci9YJZnLiYN3ulIetheKo
 5f5fcifKh3IN+AsjRaxlynHg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 62fdbc330a98d3b4;
	Tue, 06 Oct 2026 07:07:02 +0000
X-Mizu-Trace-ID: 62fdbc330a98d3b4
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 07:07:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <9f11a1ee89aa22a2ce23238b5ac968463f6e79a2@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael  
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <f23d5ed909c746ad851bd1038966d271@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
 <f23d5ed909c746ad851bd1038966d271@realtek.com>

October 6, 2026 at 07:29, "Ping-Ke Shih" <pkshih@realtek.com mailto:pkshi=
h@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wr=
ote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> >
> >  > However, including rtw8703b.h from another chip driver is
> >  > already established, rtw8723cs.c includes it to reuse rtw8703b_hw_=
spec.
> >  >
> >  As I know, 8723CS and 8723B are mutual alias, no?
> >=20=20
>=20>  As far as I know, they are not. They are different chips.
> >=20
>=20fix typo.
>=20
>=208723CS and 8703B are mutual alias, no?
>=20

Possibly,=20but either way I will move, so it shared.

> >=20
>=20> >
> >  > +/*
> >  > + * Row 20 (-6.0 dB) intentionally does not match the v5.2.17 vend=
or driver,
> >  >
> >  > I really don't want to mention vendor driver here. If you really n=
eed it,
> >  > mention it in commit message or cover-letter.
> >  >
> >  > + * which has 0x1c, 0x1a, 0x18, 0x12, 0x0e, 0x08 there. Every othe=
r row agrees.
> >  > + * The values below are what rtl8723be, the mainline driver for t=
his same
> >  > + * chip, uses at the same index, and they are also what the vendo=
r's own
> >  > + * cck_swing_table_ch1_ch13_92e and the staging rtl8723bs driver =
use. They
> >  > + * also track the 0.5 dB step of the surrounding rows: against ro=
w 32 as 0 dB,
> >  > + * 0x1b is within 0.06 of the ideal -6.0 dB value while 0x1c is 0=
.94 away,
> >  > + * the largest error anywhere in the table. Treat the vendor row =
as the
> >  > + * anomaly and do not "fix" this towards it.
> >  >
> >  > And you have comments each row. Is it still need this block commen=
t to explain?
> >  >
> >  >
> >  > I agree, will drop vendor reference and block comment.
> >  >
> >  I'm not sure if LLM writes this? LLM always write verbose comments f=
or
> >  each line it added. Just ask LLM to write self-explained code.
> >=20=20
>=20>  No, I wrote it because only 1 row differs from vendor driver and I
> >  thought I should mention it.
> >=20
>=20No worries. Just remove them.
>=20
>=20>=20
>=20> >
> >  > So I would
> >  > prefer to leave both tables as they are. If you want the unused fi=
elds listed as dummies
> >  > to pin the order, I can add them, but the sequence itself would no=
t change.
> >  >
> >  I will think a bit how to align these messed tables.
> >=20=20
>=20>  I understand. I am gonna send v8 today, and do you think that v8 c=
ould
> >  be merged, so driver lands in 7.4 release?
> >=20
>=20I think only minor changes are needed, it is possible to get merged i=
nto 7.4
> The messed tables can be ignored for now.=20

You=20made few minor comments on rtw8723b.c which I addressed in v8.

Best regards,
Luka Gejak
