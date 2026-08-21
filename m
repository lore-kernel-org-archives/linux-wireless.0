Received: from m4-bln.bund.de (m4-bln.bund.de [77.87.224.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C73BAD88;
	Fri, 21 Aug 2026 11:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.87.224.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311546; cv=none; b=fPlCS9sMeU/k56cojQuk4EkpsbV8V0PLBb3jVx9TC6JyM3wxwOjwvy/xO9dor3Phck6EULIsUZfuPrgeHfAZRPiDMkKN+1SN+MmvvnQLoJJYQZTjkgD5zP/Ea0YqNPy5+JWGOxBDs89IeCOppvB1A6UpLxXGdfP6z1NMwcfpQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311546; c=relaxed/simple;
	bh=DR/Y6w9+H+QQokCsnj/ldeIrwcOXxl6DD4X6JfBZJ3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uoYOukvgf+BaAF+EFfP9kvnJDQbstQ83jnbwHc3xTDvWGMoFk48QS0O+B+LRExyzmJwIj/uIlMTDH4XQ3aZnzZ2Zz2srNLsDnbMqq9bQssGdRWQln/jZPQ7K2XXRdhwrJXfQxuhhzN94K6aywKFB+B0w4e+j1EV7ACExVUzlfdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bfs.de; spf=pass smtp.mailfrom=bfs.de; dkim=permerror (0-bit key) header.d=bfs.de header.i=@bfs.de header.b=u0X9G795; dkim=pass (2048-bit key) header.d=bfs.de header.i=@bfs.de header.b=ZkNQ2pFn; arc=none smtp.client-ip=77.87.224.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bfs.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bfs.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=bfs.de header.i=@bfs.de header.b="u0X9G795";
	dkim=pass (2048-bit key) header.d=bfs.de header.i=@bfs.de header.b="ZkNQ2pFn"
Received: from m4-bln.bund.de (localhost [127.0.0.1])
	by m4-bln.bund.de (Postfix) with ESMTP id 8B9116AAA84;
	Fri, 21 Aug 2026 13:15:31 +0200 (CEST)
Received: (from localhost) by m4-bln.bund.de (MSCAN) id 5/m4-bln.bund.de/smtp-gw/mscan;
     Fri Aug 21 13:15:31 2026
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=bfs.de;
	s=260302-9830-ed25519; t=1787310927;
	bh=ELP8XoqtwHpGXZp9s0PtfJjENoaqOIvGUl+aKyo3+mU=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:Cc:
	 Content-Transfer-Encoding:Date:From:In-Reply-To:Openpgp:References:
	 Reply-To:Resent-To:Sender:Subject:To;
	b=u0X9G795Qlf3KXw9Io2djjanTZJN3f9H12IpLVsEWdA/8Bl1MD+VXdQjqEA8rZsnP
	 +Gik6ydRn+Wfrtbl1d7CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de;
	s=260302-9830-rsa; t=1787310927;
	bh=ELP8XoqtwHpGXZp9s0PtfJjENoaqOIvGUl+aKyo3+mU=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:Cc:
	 Content-Transfer-Encoding:Date:From:In-Reply-To:Openpgp:References:
	 Reply-To:Resent-To:Sender:Subject:To;
	b=ZkNQ2pFngEbrzZ/N9/wZizUs4dHstSfl9R1mSkNuF1v4CQHBkQMgF311xySxYQuAw
	 DFZWWfouMZEq7V9L1RqGDRbnPbhkuI7v+Z0BCIRNDoBoqoYKpEUVwPVAQbfdfOUCeQ
	 5kFdViCa2Nhc4C1dZLXu2PBppsmOTrbVysJ07Mt6Kbl6hiQIVtus/JHxmfT4iElQMX
	 FruNDCngmwchJmcVIUejY4UAL/JPoe/wynK3CLaNWIuCUNlDuprIjcV/w2VLxIUaeI
	 Bti7dvqVCnCO/UofHLzOyFqO8rJPZ3dVk6yfLHmRLy64XekoPYR7revYAKUhpeAsY7
	 UGMLs/WjmhquQ==
X-NdB-Source: NdB
X-P350-Id: 54419a78fc1360ae
From: Walter Harms <wharms@bfs.de>
To: Dan Carpenter <error27@gmail.com>, Lachlan Hodges
	<lachlan.hodges@morsemicro.com>
CC: Dan Callaghan <dan.callaghan@morsemicro.com>, Arien Judge
	<arien.judge@morsemicro.com>, Johannes Berg <johannes@sipsolutions.net>,
	Chetan Mistry <chetan.mistry@morsemicro.com>, Sahand Maleki
	<sahand.maleki@morsemicro.com>, Simon Wadsworth <simon@morsemicro.com>,
	"James Herbert" <james.herbert@morsemicro.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: AW: [PATCH next] wifi: mm81x: fix type bugs handling
 sdio_readl/writel()
Thread-Topic: [PATCH next] wifi: mm81x: fix type bugs handling
 sdio_readl/writel()
Thread-Index: AQHdMH8qRRzVdgeNuESsQteZWvdtJ7aoWCnu
Date: Fri, 21 Aug 2026 11:15:26 +0000
Message-ID: <9dd07bf672c245a1a8656037d3b6ca72@bfs.de>
References: <aoa7Hj1W7ETOrOzO@stanley.mountain>
In-Reply-To: <aoa7Hj1W7ETOrOzO@stanley.mountain>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rusd: domwl, Pass through domain bfs.de

hi everyone,
Dan has a point here as the function should use int as requiered by the int=
erface.
I would like to point to an other problem here;  too many casts.

  sdio_writel(func1,
          (__force u32)cpu_to_le32(val),

the code for sdio_writel() has this already ...    *(__le32 *)func->tmpbuf =
=3D cpu_to_le32(b); //=3Dval
the conversion for address is missing, is that intentional ?

        (__force u32)cpu_to_le32(address), &ret);

By adding the cpu_to_le32() it should be possible to drop all the casts. Th=
at would improve the readability here.

BTW: all other familymembers (e.g. sdio_f0_readb) check from  func !=3D NUL=
L maybe this should be done here also ?

jm2c,
  WH
________________________________________
Von: Dan Carpenter <error27@gmail.com>
Gesendet: Donnerstag, 20. August 2026 10:30:22
An: Lachlan Hodges
Cc: Dan Callaghan; Arien Judge; Johannes Berg; Chetan Mistry; Sahand Maleki=
; Simon Wadsworth; James Herbert; linux-wireless@vger.kernel.org; linux-ker=
nel@vger.kernel.org; kernel-janitors@vger.kernel.org
Betreff: [PATCH next] wifi: mm81x: fix type bugs handling sdio_readl/writel=
()

The sdio_readl() and sdio_writel() functions, instead of returning kernel
error codes, instead stores the error codes in a parameter.  These caller
functions pass should pass an int pointer to store the error code but
instead pass a signed long.

This will not work on big endian systems.  On little endian systems
passing a ssize_t means negative error codes are converted to positive
values near UINT_MAX.  This doesn't cause a problem at runtime because
in mm81x_sdio_reg32_write() the error codes are discarded and we always
return -EIO.  In mm81x_sdio_reg32_read() the high bits are truncated
away so the positive value is re-converted back to negative and the
code works as intended.

Either way, passing an int is the correct thing and is a cleanup.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/morsemicro/mm81x/sdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/sdio.c b/drivers/net/wir=
eless/morsemicro/mm81x/sdio.c
index 96fce187dd35..65277399bf18 100644
--- a/drivers/net/wireless/morsemicro/mm81x/sdio.c
+++ b/drivers/net/wireless/morsemicro/mm81x/sdio.c
@@ -381,7 +381,7 @@ static int mm81x_sdio_dm_read(struct mm81x *mors, u32 a=
ddress, u8 *data,

 static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val=
)
 {
-       ssize_t ret =3D 0;
+       int ret =3D 0;
        u32 original_address =3D address;
        struct mm81x_sdio *sdio =3D (struct mm81x_sdio *)mors->drv_priv;
        struct sdio_func *func1 =3D sdio->func->card->sdio_func[0];
@@ -391,7 +391,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u=
32 address, u32 val)

        address &=3D 0x0000FFFF;
        sdio_writel(func1, (__force u32)cpu_to_le32(val),
-                   (__force u32)cpu_to_le32(address), (int *)&ret);
+                   (__force u32)cpu_to_le32(address), &ret);
        if (ret)
                goto error;

@@ -411,7 +411,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u=
32 address, u32 val)
 static int mm81x_sdio_reg32_read(struct mm81x *mors, u32 address, u32 *val=
)
 {
        u32 value;
-       ssize_t ret =3D 0;
+       int ret =3D 0;
        struct mm81x_sdio *sdio =3D (struct mm81x_sdio *)mors->drv_priv;
        struct sdio_func *func1 =3D sdio->func->card->sdio_func[0];

@@ -419,8 +419,7 @@ static int mm81x_sdio_reg32_read(struct mm81x *mors, u3=
2 address, u32 *val)
                                         MM81X_CONFIG_ACCESS_4BYTE);

        address &=3D 0x0000FFFF;
-       value =3D sdio_readl(func1, (__force u32)cpu_to_le32(address),
-                          (int *)&ret);
+       value =3D sdio_readl(func1, (__force u32)cpu_to_le32(address), &ret=
);
        if (ret)
                return ret;

--
2.53.0


