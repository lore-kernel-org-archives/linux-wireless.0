Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704235;
	b=Hkh14dwjGyvrRW1RlHi8i/fmhqIwjiIIAMnV3Xf6kiP1RFV0kkZzxwiqqJP8K29AnYoF
	 ibW4sBCy2nxRNQlEEaNeu7JpB/Vcz0Wv86Z0ObAFyJcAwZs55LQ1D2GwkdMGA7ybbKyQW
	 Ko+FDGrDOa/6haHmlecJ1Uxo4dyXbViRLsYW3LgphhCbCIJXo9OgUkbwAG976MVYWjPdS
	 zaixaHhiu31GJoS+GjtlZE74q5FgUIpIsI4qKoe5vNWav7CWoD4pOQxbSwGohfzm8uFOL
	 EV8k++OAcVZfyr4y2LIiK9Q3oBrlV9WtsKPUpGC1B8BJDI3lEEI6NrSehNcKUkbPizQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704235;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4spENJpTJoN6PqGNme59Kcu9FsiMIbrrjIOpJLLgsEw=;
	b=MFeYCsGemfA4ThZ6H+1Yp8UqcC7w6juJES6QDzXFcheQJFgZ7NQu9ccHkbtX8jSrYSuK
	 Ja5Q9+s/DXjXnRYI4+eu33Ml+IIDh4m0oUXZ3xkVMU8vKTrYz1Ag6UkTvUDbsoOAAvZEt
	 IkJLWn6wDjiSYZFEsPvhU642VNf3KdVchq+V3Pi29+XIsc0rG7zEwRvemBBh/nocbGsfT
	 oJc/KnU1k7RQTbP4gFuQrbEa2Eo6c08gbQlRN/YIu2SOg7J5mYyWa+3h+SXW08hF1DpOC
	 D2atLZmH9NM+Vqc5ftlZBKZEcSMUTB3eXIhcds9g41xC+gSTnG+/DGMPMGZQ0rcFhQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=XV3wv71V;
	arc=none smtp.remote-ip=109.224.244.27
Received: from mail-24427.protonmail.ch (mail-24427.protonmail.ch [109.224.244.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A01606D801;
	Tue,  3 Nov 2026 11:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5A01606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=XV3wv71V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1793704228; x=1793963428;
	bh=4spENJpTJoN6PqGNme59Kcu9FsiMIbrrjIOpJLLgsEw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=XV3wv71VpWsMwVtDTDJ33Ez5tGMQI2nbZspwWg9Bl4k+SyHF/DThAUBpeWc32vDKD
	 MPTQPdNuWkG48xXUcM30FBs5NAlChKFU/iqKqMEElfAx38EQVnADBXbTWSDwHLua5d
	 F41SrcqlUJxIt8Q/sihgaPzbz2rU/pjbVSNX9b2PNQuOyaD8YQoof/1Ht+XPKxSjPM
	 KvgyDp+5Dt74SQ3d23Gyu2qhH/OKAAXcgMWWaHp5yJTxX1WbtN0BiYHBdllBLmel0N
	 2/hJv1Z6nsdPCWx7bgYh7K02xAsLnXv4gUWKjGolsoSIMhCdcPLqvb/9v76bP4tXWh
	 zQr2FgRxr0sxQ==
Date: Tue, 03 Nov 2026 11:10:24 +0000
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Tor-Arne Forsmo <torarneforsmo@proton.me>
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] rtw88_8822bu: RTL8822BU unstable/disconnects on USB3 with newer kernels
Message-ID: <1ZyN-kxUvoIDfNiCh2Ro6EooWLDGuN7Jwm8yKK8c1ZAeNrcmCia0aYwIDZs77lZtpppfBohrqEI6q4dwxAfcQRJa0JkjcQBO7mDZ7ACyAKM=@proton.me>
Feedback-ID: 154127122:user:proton
X-Pm-Message-ID: 8f1a2d66ca0581014f75837943e922ad17c20fda
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I've experienced new issues with a=C2=A0TP-Link Archer T4U. I've used this =
the past half a year without issues on a ubuntu server install, but recentl=
y I started experiencing disconnects on three different linux devices with =
two different Archer T4U (I bought a new one). The final fix was to revert =
back to a 6.18 kernel. I have never reported a bug before, I hope I'm writi=
ng to the correct e-mail addresses (I've gotten some help by AI). I've inst=
ructed ChatGPT to write a report of my findings, I hope this is helpful.

From ChatGPT:


I believe I have encountered a regression affecting the rtw88_8822bu driver=
 / RTL8822BU when operating over USB 3.0.

The problem is reproducible on a Raspberry Pi 4 with a TP-Link Archer T4U v=
3 (USB ID 2357:0115).

The important result is:

    6.12.62+rpt-rpi-v8 =C2=A0- GOOD
    6.18.50+rpt-rpi-v8 =C2=A0- BAD

These are Raspberry Pi OS kernels rather than vanilla upstream kernels, so =
I have not established the exact upstream regression range.

Hardware:

-   Raspberry Pi 4
   =20
-   TP-Link Archer T4U v3
   =20
-   USB ID: 2357:0115
   =20
-   Realtek RTL8822BU
   =20
-   Driver: rtw88_8822bu / rtw88_usb
   =20
-   Raspberry Pi OS / Debian 13 (trixie)
   =20
-   Adapter connected directly to a USB 3.0 port
   =20

With 6.18.50+rpt-rpi-v8, the adapter repeatedly disconnects and re-enumerat=
es when used directly on USB 3.0. After reaching the SuperSpeed bus, it fal=
ls off USB again and this repeats approximately every few seconds.

I observed the device numbers continuously increasing as it re-enumerated. =
The pattern was essentially:

    rtw88_8822bu: Firmware version 30.20.0, H2C version 14
    usb ...: USB disconnect
    rtw88_8822bu: Firmware version 30.20.0, H2C version 14
    usb ...: USB disconnect
    ...

This continued for minutes.

There are also -EPROTO (-71) errors associated with the USB2 -> USB3 transi=
tion. I understand that a single -71 during this transition may be expected=
 for this device/driver. The problem I am reporting is not that initial mes=
sage itself, but the subsequent repeated disconnect/re-enumeration loop aft=
er the adapter has reached SuperSpeed.

The adapter works when limited to USB 2.0.

I then installed 6.12.62+rpt-rpi-v8 on exactly the same Raspberry Pi withou=
t otherwise changing the system.

With 6.12.62:

    $ uname -r
    6.12.62+rpt-rpi-v8
   =20
    $ sudo modinfo rtw88_8822bu | grep -E 'filename|vermagic'
    filename: /lib/modules/6.12.62+rpt-rpi-v8/kernel/drivers/net/wireless/r=
ealtek/rtw88/rtw88_8822bu.ko.xz
    vermagic: 6.12.62+rpt-rpi-v8 SMP preempt mod_unload modversions aarch64

The same Archer T4U then enumerates successfully at SuperSpeed and remains =
there:

    $ lsusb
    Bus 002 Device 005: ID 2357:0115 TP-Link Archer T4U ver.3
   =20
    $ lsusb -t
    /: =C2=A0Bus 002.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dxhci_hcd=
/4p, 5000M
    =C2=A0 =C2=A0 |__ Port 001: Dev 005, If 0, Class=3DVendor Specific Clas=
s, Driver=3Drtw_8822bu, 5000M
    =C2=A0 =C2=A0 |__ Port 002: Dev 006, If 0, Class=3DMass Storage, Driver=
=3Duas, 5000M

The JMicron USB 3.0 disk dock shown above is simultaneously attached and op=
erating at 5000M.

I then connected the Wi-Fi network through the Archer rather than merely le=
aving the interface idle:

    $ nmcli device
    DEVICE =C2=A0TYPE =C2=A0STATE =C2=A0 =C2=A0 =C2=A0 =C2=A0 CONNECTION
    wlan1 =C2=A0 wifi =C2=A0connected =C2=A0 =C2=A0 netplan-wlan0-Rasktnedi=
kanten
    wlan0 =C2=A0 wifi =C2=A0disconnected =C2=A0--
   =20
    $ ip addr show wlan1
    wlan1: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
    =C2=A0 =C2=A0 link/ether d8:44:89:03:3e:29
    =C2=A0 =C2=A0 inet 192.168.10.71/24 ...

The Pi is therefore actually carrying its network connection over the Arche=
r at USB 3.0 speed under 6.12.62, rather than the adapter simply surviving =
enumeration.

So far I have seen no USB errors or disconnects with 6.12.62.

For comparison, under 6.18.50 the same adapter, Pi and direct USB 3.0 conne=
ction entered the disconnect/re-enumeration loop within seconds.

I also have two physical Archer T4U v3 adapters. Both exhibited the direct-=
USB3 problem on the Pi with 6.18.50, so the Raspberry Pi result does not ap=
pear to be specific to one defective dongle.

There are some additional observations from x86 systems which may or may no=
t be related:

-   One older Archer T4U v3 has worked reliably for a long period on an x86=
 Debian machine in the past.
   =20
-   The same older adapter works on another current x86 Linux machine over =
USB 3.0.
   =20
-   On a different x86 Kubuntu machine with a newer kernel, the older adapt=
er failed during/after USB3 enumeration with rtw88 errors including -71 and=
 -110, register access failures, "failed to read hw feature report", "faile=
d to setup chip efuse info", and a USB SuperSpeed reset.
   =20
-   A newer physical Archer T4U v3 works on that particular x86 machine.
   =20

Because of these additional results, there may also be some host/device sen=
sitivity involved. However, the Raspberry Pi test is the controlled compari=
son I consider significant: same Pi, same adapter, same USB3 port, with 6.1=
2.62 working and 6.18.50 failing very quickly.

On the bad Raspberry Pi kernel, the relevant modules were:

    kernel: 6.18.50+rpt-rpi-v8
   =20
    rtw88_8822bu:
    srcversion: 594B4CB53E28BF8F6458E02
    vermagic: 6.18.50+rpt-rpi-v8 SMP preempt mod_unload modversions aarch64
   =20
    rtw88_usb:
    srcversion: C08071F92A5EA09279ABA16
    vermagic: 6.18.50+rpt-rpi-v8 SMP preempt mod_unload modversions aarch64

For reference, two Ubuntu x86 kernels I checked used:

    rtw88_8822bu srcversion: C04D1014EBE0F8F11E65854
    rtw88_usb =C2=A0 =C2=A0srcversion: B5E531378AC65924BDEA496

I have not bisected the regression or tested intermediate kernels. The Rasp=
berry Pi is now being used as a working system, so I would prefer not to re=
peatedly change its kernel unless further testing is particularly important=
.

I can provide the complete dmesg from the failing 6.18.50 test if useful. I=
t contains the repeated disconnect/re-enumeration sequence.

Please let me know if there is any other diagnostic information I can colle=
ct from the currently working 6.12.62 system without changing its kernel.



Best regards, Tor-Arne Forsmo
