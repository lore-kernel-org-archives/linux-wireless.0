Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792831314;
	b=Yu1gnmxrNelmX4+DeJQQ62Ev302o00glqsTDpjOKGA72BzsRdkqFmmVEzGh46VYcMrfl
	 82If8DAPBdbyEg8krovexRvmC1PSR28ufGBl1uhl5QNsmB5R96EFYUKEB8jA9JhgK7w9m
	 GH4J4UEyO2Rgf6ttJpb79wfKxYvldaBuC6D0xL4bUVPGi1iOe54k5+Bdua4K//LmkLxCj
	 plZ5F7TUuHUKGVEPbfX4I1SAJoavqbd0x8EQ+cgzWAs98uSAOy3TZq8FgeW7rDN7Jcvdc
	 liZda5ExbR84QxMk06FELYTChaVvX6a1XaI9h8BDPMYyDaUQ3395xwG++F0D8q1LOLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792831314;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=bZWOdPLxGBuJXpDAvTocZaioh3DtDzl+zN5u5WsynVQ=;
	b=VzjopObgNVYZNMPZx/LwoYVS36lB1HE2iZiTDcsH53jyYqMZ65LIZdJZdedIvwboQwxU
	 RWrGLvHpA8PqLC4sJXpr4UnftwIIXMFrKqKv04lUvAWQXUFrlKnXfNR51WzcaKm4f2bxL
	 uTlPP6QV8+CmVVmFLe16u70JbBODKaPX7H3cnAdTRAEkugeiTvtYF/CKE+oef1t0JgMbV
	 fv3A82kzI4CG47JRxT8vEQCyjeQH+sVPXNnBNWd2FJgZYfDzMY5AQtGTrgFOBMg8TsmQ3
	 +IgjAZDP1yvt1uSVNmKSGfR5kOwHt8u5FdBmg6l973A+WvWZON401+6KLR1RIyRXvXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SEuhRxA9;
	arc=none smtp.remote-ip=91.218.175.135
Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91E606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 08:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B91E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SEuhRxA9
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tc17kdIBHc3lq/GQbmEEQReqy1sqmIMkwHAa7NfHMSo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792831311; v=1; x=1793436111;
 b=SEuhRxA98mt/wN0YF7uhBvNc1jnbp7C/Y8uTMvYeZz+V2OtlIaI30WD/mI/xtq5GBYXLl8VL
 UVSaulpQloWAplCxsHZm7F/OpqtZ9HcrstdGURchZrsDYW/vte9ft5b2K3senl3noN/F3oi1Z8/
 ffz4i5i/LtEUQqwsBkqfwepk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5e986985d9825da5;
	Sat, 24 Oct 2026 08:41:51 +0000
X-Mizu-Trace-ID: 5e986985d9825da5
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
Date: Sat, 24 Oct 2026 08:41:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3a8cd96e14c643837676fcee1d85c720b54f5377@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next 3/5] wifi: rtw88: pci: Introduce struct
 rtw_pci_gen
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <fc308de1-a470-4890-a86a-d8936e093bd5@gmail.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <fc308de1-a470-4890-a86a-d8936e093bd5@gmail.com>

October 24, 2026 at 1:01 AM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:

>=20
>=20Move a few functions into a new struct rtw_pci_gen in order to add
> support for RTL8821AE and RTL8812AE. That is an older generation of
> chips which handle the PCI communications differently.
>=20
>=20Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
>  [...]

>       rx_ring->r.head =3D head;
> +     rx_ring->r.dma =3D dma;
> +     rx_ring->r.len =3D len;
> +     rx_ring->r.desc_size =3D desc_size;
> +     rx_ring->r.wp =3D 0;
> +     rx_ring->r.rp =3D 0;

In my opinion the commit message should mention why these were moved
before the loop.

[...]

>  {
> +     struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +     const struct rtw_pci_gen *pci_gen =3D rtwpci->gen;
> +
>       u8 q;

The blank line before u8 q can go, so the declarations stay together.

[...]

>  int rtw_pci_probe(struct pci_dev *pdev,
>                 const struct pci_device_id *id)
>  {
> +     struct rtw_pci_info *pci_info =3D (struct rtw_pci_info *)id->driv=
er_data;

I think this should be a const pointer, since the pci_info tables are
const.

Best regards,
Luka Gejak
