Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9070643CE42
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790663792; cv=none; b=h0x9N+gUEigDyKcxu5GqasvYlnHDvT3YauLe1WDx3PaTJPITQTgr3/cdzFgIIo/rTetI8sOgzZShtOntW88YGMyU/ImAdtG2duxjn5XpRv34i4a67CEFpOcD3HFR+Q4lt/XdZACPm9FAMIzBRpJS774juBc22Z6H+6XAT4e0oBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790663792; c=relaxed/simple;
	bh=+t7OmXx2t0HO2zpPbTZUcSCvOXpNr8J7vV9ol68o/uI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=AQw6A4wnS9cAdVwHRKagdL9ZSbH9smoRjSgDlJ9Kho2sy+hUgSkHFHOIq5JQ2jveDlTbXTtKsbtcFeXDAmtveIOEDaRliQa20JlLhv1jONEDpGV2mkjm8Y5u27LukhDtWKWgr0iR1PKJD5XW1YVhi/3ev0AFqJnJERozgWQQteU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CbCyibD4; arc=none smtp.client-ip=95.215.58.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CbCyibD4"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+t7OmXx2t0HO2zpPbTZUcSCvOXpNr8J7vV9ol68o/uI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790663787; v=1; x=1791268587;
 b=CbCyibD4k3wj+wkgEeq8zYREKNyX79mkw1yOVg7i8CWgh03eTPRzlqlVIkhOz3U5AnHFWSwn
 +7Tl9oyp6F3HY2uKBiSCabOitf/bccKvgBftFW01g0BDvXb/SzckM19iv2V553iiutNF9AM5Sb6
 BvZOKcDuv8QbK0N7O+y59Tr8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fad3010bc0696cbc;
	Tue, 29 Sep 2026 06:36:27 +0000
X-Mizu-Trace-ID: fad3010bc0696cbc
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 06:36:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <e38d50f20a710ae0b1424924b16ad260cdb04b99@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <c7069bdf8e9845e3b26898f545b0d3e5@realtek.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
 <afb044e0aef8425880ddb24add9340ab@realtek.com>
 <DLNBECY70VGJ.DRSBNB6M66U8@linux.dev>
 <c7069bdf8e9845e3b26898f545b0d3e5@realtek.com>

September 29, 2026 at 03:15, "Ping-Ke Shih" <pkshih@realtek.com mailto:pk=
shih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E >=
 wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> On Thu Sep 24, 2026 at 3:24 AM CEST, Ping-Ke Shih wrote:
> >  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20=20
>=20>  [...]
> >=20=20
>=20>  +REALTEK RTL8723B WIRELESS DRIVER (rtw88)
> >  +M: Luka Gejak <luka.gejak@linux.dev>
> >  +L: linux-wireless@vger.kernel.org
> >  +S: Maintained
> >  +F: drivers/net/wireless/realtek/rtw88/rtw8723b*.c
> >  +F: drivers/net/wireless/realtek/rtw88/rtw8723b*.h
> >  +
> >=20
>=20>  I think no need this entry.
> >=20
>=20>  Just with below 'R', the ./scripts/get_maintainer.pl with rtw88 pa=
tch can
> >  output your name, no?
> >=20
>=20>  REALTEK WIRELESS DRIVER (rtw88)
> >  M: Ping-Ke Shih <pkshih@realtek.com>
> >  +R: Luka Gejak <luka.gejak@linux.dev>
> >  L: linux-wireless@vger.kernel.org
> >  S: Maintained
> >  T: git https://github.com/pkshih/rtw.git
> >  --
> >  2.55.0
> >=20
>=20>  By the way, your patch should tag rtw-next (i.e. [PATCH v5 rtw-nex=
t]).
> >  Otherwise, NIPA test your patches on wireless-next tree, reporting
> >  errors [1].
> >=20
>=20>  I don't know if someone is reading your patches. I'd skip v4.
> >  Please wait a while and send v5.
> >=20
>=20>  [1] https://patchwork.kernel.org/user/todo/linux-wireless/?series=
=3D1172592
> >=20=20
>=20>  Thank you. I will hold and send v5 tagged [PATCH v5 rtw-next], and=
 I am
> >  reading the list in the meantime.
> >=20=20
>=20>  On the entry: it is a maintainer entry for one driver, which is no=
t the
> >  same thing as the reviewer line. The file's legend:
> >=20=20
>=20>  M: *Mail* patches to: FullName <address@domain>
> >  R: Designated *Reviewer*: FullName <address@domain>
> >  These reviewers should be CCed on patches.
> >=20=20
>=20>  The names it reports them under are "maintainer:" and "reviewer:":
> >  get_maintainer gives the M: role the first and pushes R: entries as =
the
> >  second. With R: alone the entry says my name should be CCed on RTL87=
23B
> >  patches, which is correct, and I have kept that line, but it does no=
t
> >  say that anyone is expected to look after the chip.
> >=20=20
>=20>  Documentation/maintainer/feature-and-driver-maintainers.rst covers
> >  exactly this case, a maintainer for one driver inside a larger
> >  subsystem:
> >=20=20
>=20>  - "The term maintainer spans a very wide range of levels of
> >  engagement ... to people responsible for a small feature or a
> >  driver";
> >  - "Drivers and alike most often do not have their own mailing lists
> >  and git trees but instead send and review patches on the list of a
> >  larger subsystem" - which is why the entry deliberately has no T:
> >  line and patches keep going through rtw-next;
> >  - "Maintainers must review *all* patches touching exclusively their
> >  drivers, no matter how trivial" and "an Acked-by or Reviewed-by tag
> >  ... from a single maintainer is enough to satisfy this
> >  requirement" - an Acked-by on the list for 8723b patches is the
> >  role I am asking for, not a tree of my own;
> >  - "Most natural and common choice of a maintainer is the author of
> >  the code", and the file "is not a list of credits ... it is a list
> >  of those who will actively help with the code".
> >=20=20
>=20>  I know that least one person(with my help) is working on an RTL872=
3BE (PCIe)
> >  build and I expect an RTL8723BU (USB) to be added eventually. rtw872=
3b*.c and
> >  rtw8723b*.h already cover all three variants, so the family has one =
named
> >  owner as it grows, and those patches do not all have to reach you fi=
rst.
> >=20=20
>=20>  It is not a claim on rtw88. The patterns cover rtw8723b*.c and
> >  rtw8723b*.h only. Nothing else in the directory changes: get_maintai=
ner
> >  on reg.h returns you as maintainer and me as reviewer whether the
> >  section is present or not, and the R: line you suggested is what put=
s me
> >  on those patches.
> >=20=20
>=20>  The nesting is not new: the ath family keeps separate entries for =
ath5k,
> >  ath9k, ath10k and carl9170 inside ATHEROS ATH GENERIC UTILITIES, who=
se
> >  F: is drivers/net/wireless/ath/* and whose M: is Jeff Johnson, and a=
th5k
> >  and carl9170 carry M: with no T: line, as this one would.
> >=20
>=20Is this a good example to your case? Jeff is the maintainer of all at=
h drivers.

I meant him as an example of nested maintainer, I didn't focus
on the size of code he is maintaining. But I will drop M as you
requested.

>=20
>=20>=20
>=20> This is about the one chip I have the hardware for, not a proposal =
to
> >  split the other rtw88 chips out of your entry.
> >=20=20
>=20>  checkpatch --strict on the MAINTAINERS patch is 0 errors, 0 warnin=
gs.
> >=20=20
>=20>  If you would still rather keep it to the R: line, say so and the
> >  section goes, it is one patch, and it should not hold up the series,
> >  but please take these points into account.
> >=20
>=20As I mentioned earlier, I suggested to subscribe mailing list and rev=
iew
> rtw88 patches (I read your limitation, but I think it is easier to find
> an alternative way, no?).=20
>=20
> As you replied [1], I suppose you have subscribed the list, right?

Yes, I have setup lei(just need a little bit of configuring).

>=20
>=20I still think 'R' is enough. With your subscription of mailing list,=
=20

I=20understand and respect your decision.

> I even think we can drop this patch, no need to update MAINTAINERS.
>=20

I=20little confused, as this conflicts past emails and this above.

> Bitterblue Smith you Cc'd is a main contributor of WiFi drivers (not
> limit to Realtek). I don't see any difficult to him to review and=20
>=20contribute patches. (If I miss something, please correct me, Bitterbl=
ue).
> Anyway, I want to see people really contribute community and then
> add their names, not reverse way. I don't like to clean MAINTAINERS
> sometime.
>=20
>=20[1] https://lore.kernel.org/linux-wireless/20260926180007.28030-1-luk=
a.gejak@linux.dev/#t
>=20
>=20Ping-Ke
>

Best regards,
Luka Gejak
