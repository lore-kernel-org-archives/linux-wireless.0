Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792535038;
	b=x1KKXH7bt6rhSjYwabi5WcEZhlSNs8aKkrgLPSwWrq+V1B8m7aFlhjwc0tUvRg8ps9Ca
	 WLpe06hUinh4fsbp+EQGBBnwAYn9W6/bjp/XydYWbd0lvoAdjc82rzriJseK9STzb4GDf
	 TLND1Pi2p3u2gy94cSQCxTt73SObIDtwxLMly0zjPwpqSP9wfrLh+yEVnB63HtwcLLq16
	 v1F6G4tNnCWHaOkJjr7oTqCENuPEgNvxcg5QMwCjRJiu2pznP7hWlZBz8dnrMWzwryHYF
	 SySlrvBAZ7IkZYSj7RBa3x7bqYU1NF1hFq/3oQVq/SbRW2DwELTxzIaICTpMRTEU/0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535038;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=zgopDG4n/rFNaM7xk6N+YvJ7dhBJ5rpyuZaaQEwCtYY=;
	b=SaTlZphzy4JjL3pjtm+jgKGUGT+qGmvyj4q3CTbLqRC1f4cLDx3N7zkR4Kn6P/LxcqQL
	 a0aqVdWMmka2bNHAFD2t5zoHdzLIf1JwUQ3tDEmTXFM1UZmr9opUkRhsCbXvkkSxXsZUN
	 ExSCVNyn8JpJ4wSz011VZFm86PvKP/wfU6KrlpCTLAveRJdZWt4IIVTM6cQcqZG2aaVWI
	 IbF48nG2yiGFtwijWNRpCKedJRxPmNfizcuVJqe8rIFKm/nHpd97/l3423cVqJO/l0/F5
	 MyAEF0XN2wo3EG0/uGcTg4KWfxBZeuC1d/dVfuDyZNwM8hhNOX935+yMHzqe1odOduQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CTGoFUUo;
	arc=none smtp.remote-ip=91.218.175.164
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6D606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B6D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CTGoFUUo
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IglmDcOYmcyXlIMJI9vW7PPHYIyUN1EhxXZb0CKn84M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792535035; v=1; x=1793139835;
 b=CTGoFUUo6k5DYLLLaeMo2tFnx0KpC9w4x/1jempllme8Yp8fXUJFl7WOn/3P6c+cXG9FW7Hr
 1GSZkg7LUUkxTUUOuUOrer7gNj+DDrI2a87aKZCshUTfky+KFOahqe0QNK4FzgDZ6iotsEOJefl
 BtL9PLjCr8nN3rTcvh7QR9KI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a29e21cc53c6a8fa;
	Tue, 20 Oct 2026 22:23:55 +0000
X-Mizu-Trace-ID: a29e21cc53c6a8fa
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 20 Oct 2026 22:23:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <c76695aec44d818f319923495b7be5f2d1b4a699@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>
In-Reply-To: <c14d646f-b8b1-47ce-a92e-cbd5f534503f@gmail.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <c14d646f-b8b1-47ce-a92e-cbd5f534503f@gmail.com>

October 20, 2026 at 8:08 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:


>=20
>=20On 06/10/2026 16:06, Luka Gejak wrote:
>=20
>=20>=20
>=20> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, =
the
> >  power sequences, the efuse layout, the RF and IQ calibration, and th=
e
> >  chip specific coexistence handling.
> >=20=20
>=20>  The RTL8723B chip support is based on the initial work by
> >  Michael Straube <straube.linux@gmail.com>.
> >  Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> >=20=20
>=20>  Co-developed-by: Michael Straube <straube.linux@gmail.com>
> >  Signed-off-by: Michael Straube <straube.linux@gmail.com>
> >  Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >  Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> >  ---
> >  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2534 +++++++++++++++=
++
> >  drivers/net/wireless/realtek/rtw88/rtw8723b.h | 14 +
> >  2 files changed, 2548 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
> >=20=20
>=20>  diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drive=
rs/net/wireless/realtek/rtw88/rtw8723b.c
> >  new file mode 100644
> >  index 000000000000..8bb9c03d769c
> >  --- /dev/null
> >  +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >=20
>=20[...]
>=20
>=20>=20
>=20> +static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map=
)
> >  +{
> >  + struct rtw_efuse *efuse =3D &rtwdev->efuse;
> >  + int ret;
> >  +
> >  + ret =3D rtw8723x_read_efuse(rtwdev, log_map);
> >  + if (ret)
> >  + return ret;
> >  +
> >  + /*
> >  + * Report a power track type this driver does not implement once,
> >  + * here, rather than on every two second pwr_track() tick.
> >  + */
> >  + if (efuse->power_track_type !=3D 0)
> >  + rtw_warn(rtwdev, "unsupported power track type\n");
> >  +
> >  + /*
> >  + * No firmware hardware feature report exists, so fill the hardware
> >  + * capability here; a zero stream count kills the HT MCS set.
> >  + */
> >  + efuse->hw_cap.nss =3D max_t(u8, rtwdev->hal.rf_path_num, 1);
> >=20
>=20Another thing I noticed too late: this chip always supports only one
> spatial stream. rf_path_num happens to be 1, so no harm done.

You are right, we can just set it directly, no need to derive the value.
I have sent a patch for it.

Best regards,
Luka Gejak
