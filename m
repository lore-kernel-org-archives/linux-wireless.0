Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A50F472531
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803786; cv=none; b=t2L2+I+yaOLmR+TxbcYqtnkJigEQwWrU0hMMKsNR1aybQnj/i5Z9gZNc+28rUXUb6r9JWY3lNUmI47MJoIZ9gKxPzEQ9Kot3HpzHr55fElo4McFPHccrpVub44ARAcxxktwrd49D8/xk/Rlu0dhEoWE9T/qJCP2Pp1dKe29QIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803786; c=relaxed/simple;
	bh=RNE2zEFEbIU7zgo64PZ7Qb+LFxEHRB5BNu5YQrHhczs=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=LweXvJZxOASJkg28/yD2OymgmyyZ5q+d0Mx4fJBmpOAXnZpyl9PjWugKHpTcZ0trdgYw70mDLNWfpww53y0r0VhCUOYxwdaXgG5dK2/vjvBpL/h0JR2nDwWOkl6Z+IWZS0D0cAnWbGzZQaHU453/AaweD/wVmSo6fbyD5Bk0QmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MpSq4XUF; arc=none smtp.client-ip=91.218.175.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MpSq4XUF"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RNE2zEFEbIU7zgo64PZ7Qb+LFxEHRB5BNu5YQrHhczs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790803782; v=1; x=1791408582;
 b=MpSq4XUFFfpjRjtKpHCK313NlWdzCzLYm5uC8bea25aF1dm6KPOua0TPl40DNyH4QecuwYcM
 1LPm6sISYLji6mFVjkus2fWAGC34etasuTQMwf+yq/G0Ba2s8v1hVbwWEzjUJv8osiPT/JBwJB5
 FAkyx+huDHxuptnAxsu+gJEU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 440e8ab0d8eb58a6;
	Wed, 30 Sep 2026 21:29:42 +0000
X-Mizu-Trace-ID: 440e8ab0d8eb58a6
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 21:29:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <5b31fdb4474eea9b9403fc6ff466994b62a79fd3@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <a6ea2df9-b2c9-4417-ade4-f3947f36d139@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
 <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
 <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
 <a6ea2df9-b2c9-4417-ade4-f3947f36d139@gmail.com>

September 30, 2026 at 23:27, "Bitterblue Smith" <rtl8821cerfe2@gmail.com =
mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821=
cerfe2%40gmail.com%3E > wrote:


>=20
>=20On 30/09/2026 23:36, Luka Gejak wrote:
>=20
>=20>=20
>=20> September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gmai=
l.com mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Cr=
tl8821cerfe2%40gmail.com%3E > wrote:
> >=20=20
>=20>=20=20
>=20>=20
>=20> >=20
>=20> > On 30/09/2026 12:15, Luka Gejak wrote:
> > >=20
>=20>  The receive control word is the same for every chip today. The gen=
eric
> >  default is written in rtw_core_init(), so a chip that needs a differ=
ent
> >  value has to overwrite it afterwards, in its own init path, far away
> >  from where the default is decided.
> >=20
>=20> >=20
>=20> > I still don't understand why RTL8723B(S) would need a different v=
alue.
> > >=20
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
>=20It will work fine...
>=20

Want=20me to drop the patch?

> >=20
>=20> That value does not survive rtw_core_start(), which writes REG_RCR =
from
> >  hal.rcr after power_on. The field is what keeps it. BIT_APP_FCS is t=
he only
> >  bit added on top, because rtw88 advertises RX_INCLUDES_FCS.
> >=20=20
>=20>  Best regards,
> >  Luka Gejak
> >
>
