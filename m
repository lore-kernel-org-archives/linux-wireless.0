Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075985349BB
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804995; cv=none; b=rvAw0Iiyfdikst530yOqCTUWi/lfYCqzEdlym/gfIF2AP6JxhyTpmYiSHXt2b3861rzhjU6toEDs+YwgwLRu5CVWOQ5937UmOBOtRrQ7a2AIHA5iA6ozUuGQ5snXpV+htuVcMQQzoZnyL68stwRd5+KZUYahi8+ePwrt5i6mCeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804995; c=relaxed/simple;
	bh=5i1ANq/Smk5Laa7zjnvg47gWby2Li5Aw4qx1cKOpiKE=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=DZqc1lkwfa6WayUsQoHQ76e+NNxRaeHMy0OU4zGbawte68gnQvurCaUm+9hkLzR4S28tWhec2fwscHQbOwhnyqo0nn3K8fgRK2f/HNqWB4HcQ0E7MDUCjUQG1mf5ueOwyn9sCs3OI8NCFBjyyEHsz2cpCFHXft6aJHE202QTH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=crNQHk3i; arc=none smtp.client-ip=91.218.175.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="crNQHk3i"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5i1ANq/Smk5Laa7zjnvg47gWby2Li5Aw4qx1cKOpiKE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790804988; v=1; x=1791409788;
 b=crNQHk3iERe7HaWZlpjUWKtX2mlY3p7cwbLJR9F/vcr8gQXfxUPHbtQFqvceu1FvA9LM7lL8
 fBmTrikTY0HJQA3dz1EioGbM4mRI6qoW+ENEpxaC6euutD1o2tr5g5Qv3EL7np12RI2Eyxoa7YJ
 cbyeq6zD5XnkZF0yOWocuErI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 627e79e027d2c8b3;
	Wed, 30 Sep 2026 21:49:48 +0000
X-Mizu-Trace-ID: 627e79e027d2c8b3
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 21:49:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <dbebd1c7deff61626d9f5daaf32332b0ca11f457@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <0f32b66a-c5fe-407a-92ff-387c3fe39e64@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
 <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
 <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
 <a6ea2df9-b2c9-4417-ade4-f3947f36d139@gmail.com>
 <5b31fdb4474eea9b9403fc6ff466994b62a79fd3@linux.dev>
 <0f32b66a-c5fe-407a-92ff-387c3fe39e64@gmail.com>

September 30, 2026 at 23:46, "Bitterblue Smith" <rtl8821cerfe2@gmail.com =
mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821=
cerfe2%40gmail.com%3E > wrote:


>=20
>=20On 01/10/2026 00:29, Luka Gejak wrote:
>=20
>=20>=20
>=20> September 30, 2026 at 23:27, "Bitterblue Smith" <rtl8821cerfe2@gmai=
l.com mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Cr=
tl8821cerfe2%40gmail.com%3E > wrote:
> >=20=20
>=20>=20=20
>=20>=20
>=20> >=20
>=20> > On 30/09/2026 23:36, Luka Gejak wrote:
> > >=20
>=20>  September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gma=
il.com mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3C=
rtl8821cerfe2%40gmail.com%3E > wrote:
> >=20=20
>=20>=20=20
>=20>=20
>=20>  On 30/09/2026 12:15, Luka Gejak wrote:
> >=20
>=20>  The receive control word is the same for every chip today. The gen=
eric
> >  default is written in rtw_core_init(), so a chip that needs a differ=
ent
> >  value has to overwrite it afterwards, in its own init path, far away
> >  from where the default is decided.
> >=20
>=20>  I still don't understand why RTL8723B(S) would need a different va=
lue.
> >=20
>=20>=20=20
>=20>  Because 0x700060ce is what the vendor driver leaves in REG_RCR for=
 this
> >  chip, and it is what rtw8723x_mac_init() already writes for it. I ha=
ve
> >  both from tracing this card: a register dump at the end of
> >  rtl8723bs_hal_init prints RCR=3D0x700060ce, and the same dump in rtw=
88
> >  matched it field for field.
> >=20=20
>=20>  The default is a different filter. It sets BIT_PKTCTL_DLEN, which =
the
> >  8723B vendor HAL and rtlwifi's rtl8723be never set, and it clears
> >  BIT_AMF, BIT_CBSSID_DATA and BIT_CBSSID_BCN, which the vendor value
> >  sets. Four bits in total.
> >=20
>=20> >=20
>=20> > It will work fine...
> > >=20
>=20>=20=20
>=20>  Want me to drop the patch?
> >=20
>=20Yes. If you check the vendor drivers for the other chips,
> they're all in the same situation.
>=20

Ok,=20I will drop it in v6.

> >=20
>=20> That value does not survive rtw_core_start(), which writes REG_RCR =
from
> >  hal.rcr after power_on. The field is what keeps it. BIT_APP_FCS is t=
he only
> >  bit added on top, because rtw88 advertises RX_INCLUDES_FCS.
> >=20=20
>=20>  Best regards,
> >  Luka Gejak
> >=20
>=20> >=20
>=20> >=20
>=20> >
> >
>
