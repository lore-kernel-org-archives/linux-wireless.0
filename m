Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793736977;
	b=oo2pGAb3mvflSEzCO46M/OyA8E1e+Us/gdmjkVHQNp3XgX2yzxI9k8iFJklGPHoWc3ZE
	 PL1vTvo/V6k3zYrXwrd7YeE8qfIOL5R9ShZls8TnUo2g6W1uFn84/xlEOOKq7xdWBRVfc
	 fZbtIUG/pNPSnImPaT5ldcQY/78ILzJfce3LH5pbubJ/iu/J1oz/2baW0bi9jiihPebzw
	 a/7/vdYPObelgHDf1toOCd4w/MYf9CtPDAg/ZR9QszASS1AStMu13hWKOjPQ0QWDNs3p/
	 MWk3LKlGNsUK11dWhZ1ZB3+dPywcy9uONWYluOa5m3wNn1CjSiOXwJF7gPEIuEiyLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736977;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=BmhFJ0DqfEnwsR3z69z0SzPhT9jjNHDPlC+wagNCoH0=;
	b=SlWFftCqhlGdtDnjPkaSQBWe3KM87ePrhqFM7hv3gbdxM9zKQh8SclVcCmnqtwxVrEjm
	 MQ7g4+R2HKiyCWYD8gp6ss8JAa6olG0YLhbOy2ehb+kJY/SqIqlbyanQQDFQsf5dr5YSj
	 SGPb68JdCV8892t1CgC4jJ4KnJ0S4aFvE+8ZWqNA35uJLb6T5dNCe24gDziijAp74N+zg
	 X7zDMNsEWlGup8IQ6jfyCCsB7jTPBeWdUDvHU93Crj7e5myfk55hnB554HVdVZ0p8uznf
	 ZeKVqD84jvexalsSsxO0UK3Cy/HvmYQIW1yztD+PASbgP0Qy8nDQcT7V09vkCdqP3Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jiri.one;
	spf=pass smtp.mailfrom=jiri.one;
	dkim=pass header.d=jiri.one header.i=@jiri.one header.a=rsa-sha256 header.s=protonmail header.b=Kv6B8wwE;
	arc=none smtp.remote-ip=109.224.244.20
Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3508606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 20:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3508606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jiri.one
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jiri.one
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jiri.one header.i=@jiri.one header.a=rsa-sha256 header.s=protonmail header.b=Kv6B8wwE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jiri.one;
	s=protonmail; t=1793736972; x=1793996172;
	bh=BmhFJ0DqfEnwsR3z69z0SzPhT9jjNHDPlC+wagNCoH0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Kv6B8wwEkawRzNLcbQ9TytyFP9hWA5vvmW8VSytOo366gV98OwQ0+DzGRuoIqCQBx
	 SeS26lrwwTq2bQ1Llptx6hqurPOpubMdHOHpgavMiBGx/ZTEmFZJnN4MXscmuL6lWn
	 HjWM828g+X3D8HL+nV7Ev2BG90Wzyjq3FAsoCGuWQDmTso2AcyXtdlLKhoBcjRPB5f
	 Im6s/BIvdFZRCIf2x+pK09MvO58s/8CmMUYyy7CLeGoyHLpiuF1UX5irAOsrLFwGti
	 /IainxIXrXghwQ3+9dHL8ihzeuu3+Tiui6W7xiG711b0+/rnQoYT2EcE/BZ992pfGM
	 YykHp+MCc4KXw==
Date: Tue, 03 Nov 2026 20:16:05 +0000
To: Ragul Balaji <ragulbaby@gmail.com>
From: =?utf-8?B?SmnFmcOtIE7Em21lYw==?= <nemec@jiri.one>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH wireless-next 12/17] wifi: bcm4323x: add the USB transport and firmware setup
Message-ID: <179373696123.186829.16487382332905756046@jiri.one>
Feedback-ID: 127903936:user:proton
X-Pm-Message-ID: d8e1848697dbb19457a787391c7179257fdfccb7
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

Hi Ragul,

I have a successful short test report for an LG AN-WF100 USB adapter,
043e:3001 (BCM4323 family), using your 26 October RFC.

The only device-specific change was adding this USB table entry:

    { USB_DEVICE(0x043e, 0x3001),
      .driver_info =3D (kernel_ulong_t)&bcm4323_chip },

The generic dual-band profile worked without LG-specific channel or
WPS overrides. DL_GETVER returned boot ROM chip ID 0x4322, revision 1.

Test environment: x86_64 Manjaro, kernel 7.3.0-rc6-1-MANJARO,
NetworkManager/wpa_supplicant, with Wi-Fi power saving disabled.
Firmware matched the SHA256 specified in your RFC:
cc286a529396434a38e59382dcd46fa92a57f1cd1a38eea20d2b24dec028cf29

Results:
- Network scanning worked in both 2.4 and 5 GHz bands.
- Association on 5 GHz channel 36, HT40, WPA3-SAE with required PMF
  succeeded, followed by DHCP.
- 100/100 pings to the access point; average RTT 2.810 ms.
- HTTPS worked; a single 10 MiB download took about 1.135 seconds
  (roughly 74 Mbit/s, just a short internet transfer).
- Module unload/reload and reassociation succeeded, followed by
  another 10/10 pings and successful HTTPS.

The traffic tests explicitly used the Wi-Fi interface, while Ethernet
remained connected.

For this test I built the RFC driver as a standalone module, linking
its rate helpers locally and using a private copy of the Linux BSSID
helper, so the host mac80211/brcmutil modules were unchanged.

2.4 GHz association, suspend/resume, cold power-cycle recovery,
AP restart recovery and long-term stability remain untested.

Would you consider adding the LG USB ID with this profile?
Thanks for your work on this driver.

Best regards,
Ji=C5=99=C3=AD

