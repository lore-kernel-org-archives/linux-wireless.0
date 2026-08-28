Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC97D12CDA5
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 03:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888918; cv=none; b=T+IupgQVRkJYgAWAK1DGOOeLZNm8gaPmr9oyTEw0QGfHbhgyNXkUbcQuufBk8RBJSw962Uoyh4vu3280F5LiTzGH0Wohmnlo27n0HYji30BcdtC7oMPdTXBOeQfAtDb6W/htVxq7e/oO5fSmw1u6F+xBIBtnJhtiP0SxK26ceqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888918; c=relaxed/simple;
	bh=mJz4f6a/MHovBCRkuNY5N2SofwQWgJqPaLNBS33XDJ4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IScpL4scEKvcl0JTQoQ8hOcmy508umrOV7OQt/aToJ+UAOFmBW/Ibqf9PwxyTZH1WIfll1kTL7LM3eiptF8mfRyLUk5ab8sxStPGBGibUDnE/815pPHuboeXJG8DvVB2gpf3mjiNGJj4x2uDKn8ICcaqQKxHL4aAXM0J0togduw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Iq70BLgR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Iq70BLgR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S3mSoC52132614, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787888909; bh=rdKE98tzsKeCIxsc+66+T4d4wU6y11l/aV6tTbmMC50=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Iq70BLgRXhUqryC6DvPjKwptwyJApuGzfKztqjoeFY665vK1TFW6MqZZ1YyEZbaZ/
	 IGOgjjvZhJPZMHUTXA02xI38th1obXMIIqGfoA3LC7vWrQKID9M6PLqPImQ2vWMalg
	 /7uV6u57iDi08q3HOCfwlLBkuaph+KMNna2HVS1LA2ipJ70xzjEt5U3CuvMhrZTxAO
	 jAstSQvBOJgsbI13K9dhw0d3WO4yuIp/bOYuKaxjHau/mkG9AuEkVitnTsazCvHzYA
	 EQlf0gyL5aFnsaj3exLyyQ6rv83If2f9DsVIiDJdIGbDa5hRhsO6kJjM042o4p3UyW
	 QRKK9gjgDmjvQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S3mSoC52132614
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 11:48:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 11:48:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 11:48:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xAray0ibw
Date: Fri, 28 Aug 2026 03:48:28 +0000
Message-ID: <8ca74ba7d3164357ab644f2ddd456758@realtek.com>
References: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
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
> Hardware:
>   RTL8821CE [10ec:c821], subsystem AzureWave [1a3b:304a]
>   PCIe root port Intel [8086:51be] (00:1c.6)
>   ASUS Vivobook X1504ZA, firmware rtw8821c_fw.bin 24.11.0
>   (feature word 0x7: SIG|LPS_C2H|LCLK, no TX_WAKE)
>   Arch Linux, kernel 7.1.9 (also seen on 7.0.12).

Is there are version it works well on your platform?
I'm thinking bisect is a method to find cause.=20

>=20
> Symptom:
>   At some unpredictable point the connection wedges: traffic goes to 100%
>   packet loss and STAYS there until a reboot. The interface still shows a=
s
>   associated (iwd/networkd report it connected, DHCP lease held), but not=
hing
>   passes - gateway ARP goes INCOMPLETE and stays that way. It does not
>   gradually degrade or self-heal; it is a hard stop that only a reboot cl=
ears.
>   It tends to hit soon after boot / when joining a network rather than on=
 a
>   connection that has already been up for a long time.

I'd reply this by the latter mail of yours.

>=20
>   The one reliable workaround is disabling station power save:
>       iw dev wlan0 set power_save off
>   With power save off I have not hit the wedge; with it on it recurs. Thi=
s is
>   the strongest signal I have that the station-PS path is involved.

(Asked to disregard this.)

>=20
> What I ruled out (each tested on this machine):
>   - rtw88_pci disable_aspm=3Dy      : no effect (the module param only ga=
tes the
>                                     device DBI 0x719 bit; it does not cal=
l
>                                     pci_disable_link_state, so host ASPM
>                                     L1/L1ss stay on - link/l1* remain 1)
>   - rtw88_core disable_lps_deep=3Dy : no effect (firmware deep-PS off)

The full cold power-off boot includes above two settings, right?

>   - full cold power-off boot      : no effect
>   - suspend/resume                : NOT the trigger - connectivity recove=
rs
>                                     fine after resume in my tests
>   - The correctable PCIe "Physical Layer / RxErr" this card logs is DECOU=
PLED
>     from the failure: I measured the link working perfectly both while Rx=
Err is
>     being logged and while it is absent. RxErr is not the cause.

How did you measure the link? CAT-C?

>=20
> Reproduction (honest):
>   I could not reproduce the wedge deterministically. Controlled tests all
>   passed on the stock driver: steady-state idle (minutes), long idle with=
 an
>   off-device pinger sending to the sleeping STA, and disconnect/reconnect
>   loops. So it is intermittent and tied to station PS being active, but I=
 have
>   not found the exact trigger - which is why the reliable handle is
>   "power_save off makes it stop".
>=20
> Questions:
>   - Is a hard wedge (RX/TX stops until reboot) with station power save a =
known
>     failure mode on 8821ce? Does the driver have any watchdog/recovery fo=
r a
>     firmware or RX-DMA stall on this chip, or does it rely on the firmwar=
e?

The latter mail of yours explain RX is fully intact.

For RX path, if beacon gets loss, it will disconnect, so I think RX still w=
orks
for your case.

>   - rtw_enter_lps_core() (ps.c) programs the same PS config for every chi=
p
>     (rlbm=3D1, smart_ps=3D2, awake_interval=3D1) with no chip-specific ov=
erride.
>     Given fw feature word 0x7 (no TX_WAKE) on 8821ce, could smart-PS mode=
 2
>     be the problem, and would legacy PS-Poll (smart_ps=3D0) for
>     RTW_CHIP_TYPE_8821C be worth trying?

It looks like it still happened if you entirely turn off power save, so
ignore this...


