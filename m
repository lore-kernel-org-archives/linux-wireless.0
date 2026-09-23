Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA5446A5EB
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152072; cv=none; b=Bu/LZCLV/EQypN+lPSahtewsYzHy2rcY9DASFnBRpPxJe3jZHY9c/gR48v0G4RByiEFNwcTOOFfyBo9vgCyZPL1Ymn6Vh4IYxAQDnz9It4ntUwfFsWO4g2IAftxdzQKUTmefcCMdOd1emE2Kncdkz9mv8kS/Cs/F3JvfnX3O97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152072; c=relaxed/simple;
	bh=BMKxsQmi58H/uZew8StRECE2xaJEG42dtibHqp9UYjw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=DAjKjuJ9pQaiDlihWT0+Cc/mVSC/ExlE6bQOavk8TY0tgp8QRs0v2R/kAXdc+4lyhaYPlSKI/1z5u0Fq4DYOZ3FiuGpzgPN7NoyNRlavbv21n4M+abREbgojoaHHdn38C++Qma+FD+xpaMMEGN7V3rWl9TtXH0931AJ2CR/AQdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d23TNx96; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d23TNx96"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BMKxsQmi58H/uZew8StRECE2xaJEG42dtibHqp9UYjw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790152068; v=1; x=1790756868;
 b=d23TNx96ZcEhZ5yb824ENDvAdYfqZEVapD98kNqxnB0Z0jajvCd6J1tJB+hH1z8TkTePSacW
 A7xlVx/rcN+DGXvmeDy+iCJoKjFBq1JiVGy+q0v0Zzrky5SIDgLtCLT8bfd/LuhyO3kxBQEpVTx
 osoN56mrcuoZoNongDn/0bGw=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 66856671cb505ba9;
	Wed, 23 Sep 2026 08:27:48 +0000
X-Mizu-Trace-ID: 66856671cb505ba9
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 08:27:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 2/6] wifi: rtw88: 8723b: add the RTL8723B BB, RF and
 AGC tables
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
 <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>

September 23, 2026 at 10:50, "Ping-Ke Shih" <pkshih@realtek.com mailto:pk=
shih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E >=
 wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> Add the baseband, RF and AGC parameter tables for the RTL8723B, and=
 the
> >  transmit power limit and power by rate tables, in the layout the sha=
red
> >  rtw88 phy code expects.
> >=20=20
>=20>  These are split out from the chip driver so the driver patch that
> >  follows is easier to read. Nothing references them yet.
> >=20=20
>=20>  The RTL8723B chip support is based on the initial work by
> >  Michael Straube <straube.linux@gmail.com>.
> >  Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> >=20=20
>=20>  Co-developed-by: Michael Straube <straube.linux@gmail.com>
> >  Signed-off-by: Michael Straube <straube.linux@gmail.com>
> >  Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >  ---
> >  .../wireless/realtek/rtw88/rtw8723b_table.c | 862 ++++++++++++++++++
> >  .../wireless/realtek/rtw88/rtw8723b_table.h | 18 +
> >  2 files changed, 880 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table=
.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table=
.h
> >=20=20
>=20>  diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> >  b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> >  new file mode 100644
> >  index 000000000000..49989da3b8aa
> >  --- /dev/null
> >  +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> >  @@ -0,0 +1,862 @@
> >  +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> >  +/*
> >  + * Copyright(c) 2007-2017 Realtek Corporation
> >  + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> >  + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> >=20
>=20I'm not sure if we should claim copyright year back to 2007?

What would you prefer, just tell me and I will change it?
>=20
>=20[...]
>=20
>=20>=20
>=20> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> >  b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> >  new file mode 100644
> >  index 000000000000..49291fd1dd9d
> >  --- /dev/null
> >  +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> >  @@ -0,0 +1,18 @@
> >  +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> >  +/*
> >  + * Copyright(c) 2007-2017 Realtek Corporation
> >  + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> >  + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> >=20
>=20ditto.
>

Same question as above.
