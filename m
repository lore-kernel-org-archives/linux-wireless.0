Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B056846A5E4
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369365; cv=none; b=pMc2jkNvU7cZp6dE3A3uqmNfMIbpaCH09vnqMdAiiid0dvws9Ee5dyVyeQ5Gp6hBbOODw8Iib4TEQ0R0uTmuLpXYwHMGi35iP9t2j/Or5ZlsvqjAiBXi9aaR10F3Nxsd5uVE1S3sa72ZrZgrPSSFUKgUcM0RtX/CB1AV2xxdhp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369365; c=relaxed/simple;
	bh=BTPtT4fLkt097I05m7+silvWVGjUTctleHSPZZ/bp44=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=dRf3iW5CcFJLJKkAb8ChErGVvWkG7ig5Wq/9BL6onw+lERtG+2iUJdtsNbnhmdFDmRAjRjO+KhaLb3EIds2dEfgLDf0l+4AbQL8oCFvb0M5z/hlnd8VcZaFo50Li/fMEEOXpkLT4NeklYMeT8YGE0fdu/LKugz/KDYI3Qo/IrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xjQZrJ2g; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xjQZrJ2g"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BTPtT4fLkt097I05m7+silvWVGjUTctleHSPZZ/bp44=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791369335; v=1; x=1791974135;
 b=xjQZrJ2g1nnN86TuHLt2Xmp9LCSSBS3foeBFTKG/AVvjbz4pUGQZXdhw220uDberf6x2g11e
 hbWYnXa23c4/fpP/ou7ZseoEHvZ9vmte2D2lHqM0q7MfzSilgpdezYvzbb6hf2wT9BXuLXJY+ti
 +0JP7IqpO7Vqzc+Op5IEtu7k=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 80cbc86ac8bff3f9;
	Wed, 07 Oct 2026 10:35:27 +0000
X-Mizu-Trace-ID: 80cbc86ac8bff3f9
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 10:35:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Greg KH" <gregkh@linuxfoundation.org>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <2026100746-delicate-carless-a04c@gregkh>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
 <2026100746-delicate-carless-a04c@gregkh>

October 7, 2026 at 12:06, "Greg KH" <gregkh@linuxfoundation.org mailto:gr=
egkh@linuxfoundation.org?to=3D%22Greg%20KH%22%20%3Cgregkh%40linuxfoundati=
on.org%3E > wrote:


>=20
>=20On Wed, Oct 07, 2026 at 08:54:03AM +0000, Ping-Ke Shih wrote:
>=20
>=20>=20
>=20> + Greg to staging rtl8723bs driver question
> >=20=20
>=20>  Hi Greg,
> >=20=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >  October 7, 2026 at 10:32, "Ping-Ke Shih" <pkshih@realtek.com
> >  mailto:pkshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40re=
altek.com%3E > wrote:
> >=20=20
>=20>=20=20
>=20>  >
> >  > Luka Gejak <luka.gejak@linux.dev> wrote:
> >  >
> >  > >
> >  > > October 7, 2026 at 04:57, "Ping-Ke Shih" <pkshih@realtek.com
> >  > > mailto:pkshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%=
40realtek.com%3E > wrote:
> >  > >
> >  > >
> >  > >
> >  > > Luka Gejak <luka.gejak@linux.dev> wrote:
> >  > >
> >  > > >
> >  > > > Add the Realtek RTL8723B 802.11n chip driver: the chip operati=
ons, the
> >  > > > power sequences, the efuse layout, the RF and IQ calibration, =
and the
> >  > > > chip specific coexistence handling.
> >  > > >
> >  > > > The RTL8723B chip support is based on the initial work by
> >  > > > Michael Straube <straube.linux@gmail.com>.
> >  > > > Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> >  > > >
> >  > > > Co-developed-by: Michael Straube <straube.linux@gmail.com>
> >  > > > Signed-off-by: Michael Straube <straube.linux@gmail.com>
> >  > > > Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >  > > > Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> >  > > >
> >  > > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> >  > >
> >  > >
> >  > > Hi Ping-Ke,
> >  > >
> >  > > Thanks for helping and reviewing the series throughout this
> >  > > upstreaming process. Just one question, when is the series plann=
ed to
> >  > > be applied to rtw-next? I am planning to send a patch to staging=
 to
> >  > > remove staging rtl8723bs and I need to have information when is =
it
> >  > > landing.
> >  > >
> >  > I'll merge this patchset and send pull-request tomorrow, but I thi=
nk you
> >  > should remove staging rtl8723bs until this patchset drains to upst=
ream.
> >  >
> >  > Ping-Ke
> >  >
> >=20=20
>=20>  Ok. Thanks for information. However, by the time this series reach=
es
> >  upstream, won't the merge window be closed? Therefore 2 drivers for
> >  the same chip will exist for one kernel version, and Greg previously
> >  said that when a driver is merged we should remove staging so there
> >  are no two drivers for the same chip.
> >=20=20
>=20>  Luka did rewrite RTL8723BS vendor driver (i.e. staging rtl8723bs) =
into
> >  upstream rtw88 driver, and I plan to merge this patchset and send
> >  pull-request to wireless maintainer tomorrow. However, the two drive=
rs
> >  are existing at this moment.=20
>=20>=20=20
>=20>  My question is that can Luka send a patch to remove staging rtl872=
3bs,
> >  and goes via my tree? Then you don't need to wait for my pull-reques=
t
> >  being upstream. Can it work to you?
> >=20
>=20That's fine with me, delete away!
>=20
>=20thanks,
>=20
>=20greg k-h
>

Hi Greg,

I have sent the patch, and I think you are going to like this
number: 66186 deletions

Not sure what people are going to use to learn though. It seems to
me everyone is repeating the same patches.

Best regards,
Luka Gejak
