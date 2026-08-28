Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BFB21767D
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 03:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889461; cv=none; b=E67R2okCdiND1TZ1zdwh6JnzoiJUP7zbUVrqZjnZ22mv3gJzb8uvwuaSjFOMpfUUUSzV1+tvVGTzjdniVIQIeU8tUuUFiZURYuAolJF/WbKJGSx4Gd84zDHZfuC+DHZAUMHMDNMKT24UqQdYJG7AZr95OpTrKRJcTxbaxFL6CiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889461; c=relaxed/simple;
	bh=YHIkpO+OXUoyo4ezK7e35wx5qD3x/gn7rP2DNWZd+Fc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nL3LBHbdlvEuTPelrTgTLGSCliZDuPcJjYqINmLd+yTdKkxu2hd5kA2kxHs0qUdqOOm7aKU5OCGBn+MWU5SxSnA/YM55bq/ZVU0zrSbOsCBMglywxSoARxes3P2Tm+7BrKhQP93TnXvKsSAllNnUYjOqxCoSpofa6v2j/1u7quA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DJKUHxtI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DJKUHxtI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S3vX7d92135898, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787889454; bh=8/kjic2j4tiqkFdAhQQtUg1joBfdj1oJTtSJFtCFWPI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DJKUHxtI4Wd2sd3tWEyIIZfQsKoWT/QjiBUU1DKpakBdKs2BPt8HUpNxvI4j/Jj+f
	 w5iv5KEyzg9JzzCiKDtJyfR+RdfuB3C8g7GcaQyqrzvFPodMCPORW7fv68tvWkmfQS
	 zEiKXAdUugEzg/YNPip2EYb0aZ0NCTzopuXd/zdDcJkiQnKN6UOJb98CpBnX1JuDi+
	 g1YXNEyHFQVwzzabg9cM1cfztU9PwIg8v18xGyyyTT7uzeascQ/Dn5FtYbXet9IX6I
	 XKhOm+QFimsNcgAkaDDPXLlcY9ELZ97Dq6pfFQtQZJ79azzqGC2Zt4sBNj3b66PdUn
	 G1ocCtj5PPLuQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S3vX7d92135898
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 11:57:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 11:57:34 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 11:57:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 11:57:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSA=
Date: Fri, 28 Aug 2026 03:57:33 +0000
Message-ID: <51079deb603845768db7cbe491f40e3c@realtek.com>
References: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
 <20260826180042.34109-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260826180042.34109-1-abdurrahmankaradag19@gmail.com>
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
> Correction and new data.
>=20
> First, a correction to my report: I have now hit the wedge with station
> power save OFF, so power save is not the trigger. My earlier "power_save
> off makes it stop" was coincidence on an intermittent bug. Please disrega=
rd
> the PS/smart_ps angle.
>=20
> Second, I captured a wedge with Wireshark on wlan0 (802.3 view, i.e. at t=
he
> netdev boundary), and the signature is much more specific than "connectio=
n
> wedges":
>=20
>   - RX is fully intact, including unicast: DHCP OFFER/ACK addressed to my
>     MAC, an ICMP echo request from the router, TLS data from the router,
>     and the gateway's ARP requests sent *unicast* to me were all received=
.

Good to know RX is good.=20

Can you setup another WiFi as monitor mode to capture 802.11 packets?

>   - My DHCP DISCOVER/REQUEST (342/345 bytes, L2 broadcast) reach the AP a=
nd
>     are answered within milliseconds - on two different APs (an Android
>     hotspot and a MikroTik router).
>   - 14-30 ms after those successful DHCP exchanges, my ARP requests for t=
he
>     gateway (42 bytes, L2 broadcast; 89 of them, 1/s) get zero replies on
>     both networks.

Use another WiFi monitor to see if RTL8821CE actually transmitted the packe=
ts.

>   - The gateway ARPs *me* (unicast, 10 times at ~0.77 s intervals, then
>     falls back to broadcast). I receive every request and reply immediate=
ly
>     (42-byte unicast ARP reply) - yet it keeps asking, so my replies neve=
r
>     reach it.
>   - My TCP SYNs (78 bytes, unicast to the gateway MAC) get no SYN-ACK.
>=20
> So the failing set is small STA->AP frames (42-byte ARP, both broadcast
> and unicast; 78-byte SYN) and the working set is 342-byte broadcast DHCP,
> with RX working throughout and no kernel/driver messages. Since DHCP
> succeeds tens of milliseconds before ARP fails, this looks like a
> per-frame property (frame size, or possibly ethertype) rather than a
> temporal stall. Two unrelated APs show the identical pattern, so it is
> not AP-specific. The interface stays associated; only a reboot clears it
> (a live driver reload froze the machine once, so I avoid that).
>=20
> Next time it wedges I will run a size probe (static ARP entry for the
> gateway, then ping -s 8/56/200/400/1000) to confirm whether it is
> size-dependent, plus station-dump tx-failed/retry deltas and a
> neigh-flush -> reconnect -> link down/up ladder to see which layer holds
> the wedge. If there is anything specific on the 8821c TX side you would
> like me to dump (tx desc, debugfs, registers) while it is wedged, tell me
> and I will capture it.

I'm not sure why the size can affect the result. Normally large size
is harder to transmit basically though.=20

Please fully turn off power save when you do the tests to reduce one
factor that can possibly cause TX slowly or stuck.

>=20
> Capture available on request.

802.11 capture by another WiFi monitor is better.=20


