Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7F3AF677
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 04:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788667782; cv=none; b=l4HeO6OesnSLC2drR9hgXgiGLxs14LPFwSj8DW6iRubU88B60PgAPc4TN3i8NNNOSnPYbhXs3Lbna9EnF3vyuk3dtT9jgKXBYkSlzDnJHxLrKgk9Xi5Ltt1Sb9xlx46g2pGrUQ7IMhBOp1f+FPfzdjg+E5phfJffulz1Dm5oRWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788667782; c=relaxed/simple;
	bh=UHBmlZvuhWpagsMXqXrhCicSceCbIjum7EJMvDat9pQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ouc6+0Al5Ppx4ZsRXZ2X/X50YVr2k5Wmnv4o7NHD82xGNbwTdoEPZm0elYRppCOs5+9z5xGZWpkvLW43SnyQrJ8fqsnQ+/szGTwTA+kdnm+ZDg+a8AM0mZFNGsaOY6TJfF7eDG4bVhDUNVcuZaxx7z5gQ5LL9A75+rm1MTmrVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DNTk3CLn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DNTk3CLn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68649ZtK41634718, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788667775; bh=4rcsmRp81U3o5XAuKkvwz33fSDThXlEGhjVXNvCEa+o=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DNTk3CLnaPAwvvd6rwGj6iSv8SH4GG0XiWGKXoi0h8qQud//CXeNTv8hoJP/bIO0D
	 KJqeb6lcSgW0V+CibnUDV5e6WjsavGfa7J0NrY4+LCRUlqJF8BTx2FA4K6m0mPENe0
	 xuQG4rlAyr4NHFA2Q1qAQ98fqbyc/CvzO6ZyyELs9XPE+K1oqbjo1qAzmIt0AiLj2l
	 CSdOyS5XaU7v8RxRDmA3sl4YAIgGGtfjveKi6JVaZf1uHFzln4PuJluZHr/9/LjdMf
	 PFXWNAy3SX5Bq0KX2VGlLaMO3NckVLSXK/nVXW+XDdqHwYunMn15UXvMryMTPzP7sO
	 zDrzK1aoWR6VQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68649ZtK41634718
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 12:09:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 12:09:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 12:09:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSD//3bjAIAFLEIQgAMNvYCABnUbAA==
Date: Sun, 6 Sep 2026 04:09:35 +0000
Message-ID: <9d64e207c4434411981bc133ef820d7e@realtek.com>
References: <516290e0e8a84988a9219069596e61a3@realtek.com>
 <20260902091525.39810-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260902091525.39810-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> > Checking commits between 7.0.12 and 7.1.9, the only related commit migh=
t be
> >    c95323ea9dfb ("wifi: rtw88: coex: Solve LE-HID lag & update coex ver=
sion
> >    to 26020420")
> > You can revert the patch from 7.1.9 to see if it becomes normal.
>=20
> I reverted it from 7.1.9 and the wedge still happened, about an hour afte=
r
> boot, so that commit is not the cause. BT is disabled on this machine
> anyway (coex_info reports "BT disabled", BT status non-conn).

I wonder even you use driver of 7.0.12 (on 7.1.9). It will still happen.
Not sure if host side change something?
Can you 100% ensure 7.0.12 is fine?

>=20
> Rather than continue bisecting, I set up a watchdog that dumps
> queues/aqm/TXBD indices at the moment of the wedge, before anything
> touches the interface. I have five such dumps now (I discount one of
> them, taken on a captive portal network where the ping probes are
> unreliable), plus healthy baselines, and they show a consistent
> driver-level failure. I have also been able to reproduce that failure
> deterministically and to recover from it. Details below; I am
> sending a patch as a separate mail.
>=20
> 1. What the wedge looks like from inside the driver
> ---------------------------------------------------
>=20
> This is the dump from 2026-08-28 22:05, taken with power save off, on
> 5 GHz, 91 minutes into the association:
>=20
>   /sys/kernel/debug/ieee80211/phy0/queues
>     00: 0x00000000/0   (VO)
>     01: 0x00000000/0   (VI)
>     02: 0x00000001/0   (BE)  <- stopped, reason bit 0 =3D DRIVER
>     03: 0x00000000/0   (BK)
>=20
>   stations/<ap>/aqm tid 0 (BE): backlog 20941 -> 26960 bytes,
>     94 -> 144 packets, flags DIRTY, still growing while sampled
>=20
>   iw station dump, 5 s apart:
>     tx packets  116017 -> 116017   (frozen)
>     rx packets  244885 -> 244992
>     beacon rx    53304 ->  53353
>=20
>   TXBD_IDX_BEQ (0x3A8) =3D 0x003c003a in all four samples, taken over
>     about 15 seconds

Hardware read index is 0x3c, and host write index is 0x3a.
So, it reaches the limit of stop queue.=20

[...]

>=20
> I will send the patch separately so that it lands in patchwork on its
> own. It only adds the stall detection and the re-kick; it does not touch
> the normal TX path, it skips rings with nothing in flight so an idle
> device is never poked, and it warns once per stall rather than on every
> retry.

As your experiments, the cause is hardware never reads TX buffer and gets
stuck, right?

I quickly check the patch. It looks like the way to unlock this state is
to call rtw_pci_tx_kick_off_queue() again?

Which means not a driver side bug (stop queue but not restart queue properl=
y),
right?=20

>=20
> One question, in case a re-kick turns out not to be enough in the field.
> The out-of-tree rtw88 driver has a pci_old.c for the older PCIe
> generation, where the PCIe DMA is reset after a TRX hang using the two
> status bits at REG_DBI_CTRL + 3 (bit 0 TX, bit 1 RX), with bit 2
> enabling the detection. Is that status bit valid on 8821CE as well? If
> it is, I can dump it during the next wedge and, if it confirms a DMA
> hang, a reset could be added as a second stage.

I checked vendor driver. It only does this at initial step, not to recover
it at runtime.


