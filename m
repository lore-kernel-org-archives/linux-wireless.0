Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34C536606A;
	Thu, 10 Sep 2026 02:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789007067; cv=none; b=R9qCVEQnBNWV628Suk1AzoHVclTmtjyl+C4Hj1FS9hTYnNKN8/ulST18F5LkPXYnU9pC6NR2JlhJAIYtzGwJWciqMiDNSqLMNuVFywrSLvWE5JdRIIW0Z2x+SDLScWweJC5TenDw5NXH/fO+GSWLY/I91iALKUxV2Ipc0M25Lic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789007067; c=relaxed/simple;
	bh=Wn1CYZMGIFXmgzYiBLBqu1Ir/1xUW6nAt2FTwwjwMfs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gdasPKBR0GBvxpfXJXFi8MydhZa+WFlIZEl4BgRM8G7icWP0ePs8eATJ14dh4DRTEwgizjq8UJWArU8VkWr5iasCNq8SG5PmBVaXqKG0d4yxPzAiY319vULXUbjGyh52HER19g3K9z9tzycvxbGgTp7Bu2Mlh3w0k6kgYraM/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OwFfPE0V; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OwFfPE0V"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A2OCqyC1112934, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789007052; bh=Wn1CYZMGIFXmgzYiBLBqu1Ir/1xUW6nAt2FTwwjwMfs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OwFfPE0V60ilyrCMBe/mSXjyF3BdP0H7hRSSvw2O5aRGXmpcvhWPM7d839meEBxnT
	 R7ld/c5kNd+6hm5lGfIiGPM5iYKINO9dJJUKyk3/hYOuNM1tJY4KzBXxCGDYSnUcr6
	 bV8FHfjnNbgvzhcH6OgeqUNg9nwop+OJH5WGrc5ik6ICsbu5YA/y6Q3Oswiictw60m
	 heMULWjEgRjERkyCbgB44mx+zKvhPCqLQ2ReQiNTfctspS81EwBGI3DF1LHoOuI07I
	 SUIBSL7wUBE8AXvkezNNKyqdjT8mlJyUXy0o+VHf2c4RFaPYW0kwPbArGlw/U9p5oD
	 oiJArJTUEaZcA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A2OCqyC1112934
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 10:24:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 10 Sep 2026 10:24:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 10 Sep 2026 10:24:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 10:24:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a TX
 transfer
Thread-Topic: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
Thread-Index: AQHdQC9VHG8DgIV+fU6Rc/HoW7uZv7bHFi4g
Date: Thu, 10 Sep 2026 02:24:10 +0000
Message-ID: <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
In-Reply-To: <20260909074556.55709-5-luka.gejak@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
> then hands that length to sdio_memcpy_toio() while the skb still only
> holds skb->len bytes. The difference, between one and 511 bytes, is read
> from beyond the end of the frame and transmitted. Whether it stays
> inside the skb's allocation depends on how much tailroom the skb happens
> to have, so this is at best sending uninitialised memory over the air.
>=20
> Pad the skb up to the transfer size first. __skb_pad() zeroes the added
> bytes, reallocates a cloned skb rather than writing into a buffer a
> clone still shares, and leaves skb->len alone, so nothing else in the
> transmit path has to change.

With __skb_pad(), it might increase CPU usage.
Could you roughly measure that?

>=20
> It must not free the skb on failure: rtw_sdio_write_data() frees the skb
> itself and rtw_sdio_process_tx_queue() requeues it, so both callers
> still own it and would double free.
>=20
> Found while reworking this path for the RTL8723BS. Measured on RTL8723BS
> hardware, padding the transfer costs nothing observable: uplink is
> 19.5 to 19.8 Mbit/s padded against 20.9 to 21.1 Mbit/s unpadded in an
> interleaved A/B, with scans, reconnection and a UDP flood clean in both.
> The other SDIO parts sharing this path are untested; I have only the
> RTL8723BS.
>=20
> Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO =
based chipsets")
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



