Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792683798;
	b=AlFptZJaCwlC3ZOhqIn0IROzXPGkUqTgMZsy43LjyjrnDI/xQjF+2+K0eoOMuSgzgyUh
	 Bq44/DGpVi8zUUjRr7FqieeTIcUsLwlWGDQsGofLpNPl7MOEk9SbMVlMZpbjwpjGw9s8a
	 TxFkEvgbat7vZ/XjLxAzLULvKOWpSS/nmJ61gen8toKOJuyowd0rHU/I+NMMkoqu4DeS/
	 cA6ywIirNNBw7c6jQ0K72SEebQuQnDw0rI5x947HyQ3AtLhBohtk2/tD9FO+TtUKZdoTJ
	 5oEFvOXOJPienpzzv7Jf2cubf+Zj8AEmXyQgmCjRv/qvGRu5zCawFsuAvFbPW60/bhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683798;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=f0S4xWNDYAoCZk2p2wttJP+pOLEqD6Zen+2h5DTu9/4=;
	b=x4SEp0Z4ph3gYbjsUMyfVkGpqk5v3AAPrPKhTRp+cwoVMVqkjjA4xhN1ECrdK7e03syw
	 bY/OnBuC3ssfDtcD5dbGGZg4bDTqUr81T2w9RQxcCHlpUJhQT/7CFIsnKfOFtGm1zmKKV
	 jJ/UpQ1YNM2f/89Kco79iXLPTggUOZ2e07X8UspbY31ZJS/rm1ZqAQSki109eJL8vYP4Q
	 wBACQIXdfwYUNWdNIxkAfv5CGT/83WkkQfjBDPYolrdtPjVdncFmKZmiA8Y7Wdc84av+H
	 4MoEwI+4Q5D7DDcapXa8Ij4D+ZN1MefaW/P4tkSzzduoFLkTIgIjnL7gKXiXRrHvXgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="n5Y/ADNC";
	arc=none smtp.remote-ip=95.215.58.226
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604D606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 15:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A604D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n5Y/ADNC
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jf+Q3XThyUyaPYG1v6zMuwaR86BUo0Kf/foH0DTvbtM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792683793; v=1; x=1793288593;
 b=n5Y/ADNCqZ9hmKpieqaDUhgd+VMpCjEir7thxrdfgGbkux502RQAa525H9m0hMY8FcqDZt8U
 CLt8aoVXMqdgU/XwLZJeuBZELI9NalDz184+46ti2AqaQA4aSwrKCYlQ1tb7QGmbxWffKBr53op
 quweI2ZmDeMisciAJ8gnv534=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c526b7e1436fc1d6;
	Thu, 22 Oct 2026 15:43:13 +0000
X-Mizu-Trace-ID: c526b7e1436fc1d6
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
Date: Thu, 22 Oct 2026 15:43:11 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ccfe24ed9b239c05e334389bcc8547d91d06d020@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 0/7] wifi: rtw88: add RTL8723B/RTL8723BS
 support
To: "Peter Robinson" <pbrobinson@gmail.com>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Michael Straube"
 <straube.linux@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
In-Reply-To: <CALeDE9NKkv8TxiCNUt-fUYUkh_zk7Ne7hRKF51QDOSvvrp1YRQ@mail.gmail.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <CALeDE9NKkv8TxiCNUt-fUYUkh_zk7Ne7hRKF51QDOSvvrp1YRQ@mail.gmail.com>

Hi Peter,

October 22, 2026 at 5:38 PM, "Peter Robinson" <pbrobinson@gmail.com> wrot=
e:


>=20
>=20Hey Luka,
>=20
>=20On Tue, 6 Oct 2026 at 14:07, Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> This is the second of two series adding support for the Realtek RTL=
8723B
> >  802.11n chipset and its RTL8723BS SDIO variant to rtw88. The prepara=
tion
> >  series has landed in rtw-next, so this series carries the chip regis=
ter
> >  definitions, the BB/RF/AGC tables, the chip driver, the SDIO bind an=
d the
> >  build glue.
> >=20
>=20>  The first and fourth patches are the shared-core changes. The firs=
t moves
> >  the CCK power detect setter out of rtw88xxa.c into phy.c as
> >  rtw_phy_cck_pd_set(), so this chip can use it without pulling in
> >  rtw88_88xxa. The fourth moves the definitions RTL8723B shares with R=
TL8703B
> >  into rtw8723x.h. The five chip patches apply on top and can be read =
on
> >  their own.
> >=20
>=20>  The driver supports:
> >=20
>=20>  - RTL8723B / RTL8723BS, SDIO only
> >  - 2.4 GHz 802.11n, HT20 and HT40
> >  - one spatial stream
> >  - station mode
> >=20
>=20>  Only station mode has been validated. The common rtw88 core advert=
ises AP
> >  and IBSS for all chips, so those modes are advertised for RTL8723BS =
as
> >  well, but neither has been tested. An out-of-tree tester has reporte=
d AP
> >  mode associating without DHCP completing. The five additional SDIO I=
Ds are
> >  included for parity with the existing staging driver, and only the 0=
xb723
> >  device has been exercised.
> >=20
>=20>  The chip driver requests:
> >=20
>=20>  rtw88/rtw8723b_fw.bin
> >=20
>=20>  This is the version 41 firmware extracted from the Realtek rtl8723=
bs
> >  vendor driver. It was submitted separately to linux-firmware with it=
s
> >  extraction provenance and carries Ping-Ke Shih's Reviewed-by. There =
is no
> >  known native rtw88 RTL8723B firmware.
> >=20
>=20Did we get the firmware PR done against linux-firmware?

Yes the firmware was merged even before the prep series.

>=20
>=20One thing to note here is that the old revision of the firmware will
> need to remain in linux-firmware as the LTS kernels will need them,
> not sure that's a problem as the drivers use different paths.
>=20

It=20is its own entry, not a replacement for existing one, so LTS kernels
are not affected.

> It would be useful to get that done so users don't see a regression as
> the old driver is removed.
>=20

Already=20done as said above.

Best regards,
Luka Gejak
