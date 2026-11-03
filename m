Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793744978;
	b=V5kN5/rIMhiejCigyGzSGQcXn0VmC6xk3fZe8vvOABH39S7+yakRBVF+4TerXApUfKH4
	 nGatGveUPFrqXJ76gWXWHbRHkMrTWXslANpBopcrV1TJmwjVaJKhlfA3TnlM/cyffzoK1
	 eRh5vnLAEefr5EVS0KvzgeCZ7LRuMCBQNoiulufDPXYsnyFQq1QAldCwz3ISpWDL/sM0M
	 fW7/ERf3WQr+3d8IQej0IvcDzc2yLZCunnG8XJcUsmgYHnCjjAuaN6rZbCjeL1vlUjWFX
	 8DrsfFsLxiryW6BVOfYRSbKR9J0mmeAZMWYt4Rhrc08o1wS+izN4nYHae29QstgWMFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=e+zgS/meIzysO65no3N4roovnU/p8m28ecSLsndu/gM=;
	b=5Qlln25DscbBozNsMc58VVG7ejLMBaajjyZpaYf7qe/eO9TpmoThwUjlNNHWZv20q7iW
	 dcSw0v/QLZPiDGH7BbMhS39DlMGJJREEJDmdh83mdff3OY3RHwGIhzyobNoVwrLtsB7xs
	 vN9wqqpjaBItJyxQU01uCTiqxQxFpvKO28Qigon+uhO+oDG31GD0JQglZX+watRQHaEoN
	 HC0aRC7B1QdrpOLA/d9pwLbwrUMSip3bRgWaoveA/3Cqad5Vrq4HW84RFxfrsFQjS/M26
	 N3760quf5mQ5vn2q4edug+/Yt15yU9ZLKW0Kj6sFK7gG5L7zYi5KNB8/vNM73ydARpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQqlQN2F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4675606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 22:29:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4675606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQqlQN2F
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b305d38bafso832727b3.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 14:29:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793744977; cv=none;
        d=google.com; s=arc-20260327;
        b=hCozFunsdRHoQtqjqkpxzMWqHfQoE6O6bDF0XnQ8ghoy56ViX1papt/VLq+Hnh0Dit
         VJo7eIa3/rWcPZ/VKv4xO9AlZslUNaFah2hRY8WvYhoX9j0gBnYHfztB9Hjd+oowSrJo
         ReoFZj8nFuw01jCMyS6q4BO+T9KmDl0GKwTOHvR3dyfazRGnQHfOowuA6FTo9aBwUIZx
         Xte2EX/hNPV2ZmmySqHwu4WToNp+kdnEqmA7Iw8wKiyL7V/9sOP3SEGCt6wz813IEUHS
         eOz5BTvMelX8bdWqdPsK03eg7rJjo4jKkyMrE3MJhrKG20b2NxKgSTzoFGywVs7+xBjq
         Bm2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=e+zgS/meIzysO65no3N4roovnU/p8m28ecSLsndu/gM=;
        fh=Y/U50gtRcX/xiKT0iQRQC67OMrNOneTQtxsu5P+GIFg=;
        b=XiudbCg+o2HhufbxVpw6vplbRuW0EQJoN8drWEqZvyvJ5RSVwbZMK3Dp+BEYOs7JqR
         jqv3RHqbrDyDJUEY6zy//ZIGjX8mpVFmHAQGxw5uCuzFPAubqEJRiNxQM+3nzhcipitm
         kRauqEhWuw4yznSzwPvAgtkBbTeB2its2Rigwz/R9Cvx32Gya0FjMgsfguQlkt5MjYPN
         GdfFMz4cKH8NjaLXukoJK5+b6580xbpguMZfeGbRaK6qlP0YkHc2XySzbC7w2sbrOnwh
         prh+k6TTjnvcb3nvy1bm1mjGFHLPbyKVhLgOEt6xJfC6luSlZLEH6OLMkfIyRdo/rEX1
         KHbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793744977; x=1794349777; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=e+zgS/meIzysO65no3N4roovnU/p8m28ecSLsndu/gM=;
        b=vQqlQN2F4BIb2n4DtnU9pg3XHQv/n4OETSzpGfk3DjrzjuyqN+GNPYCJC0lXbJS26W
         Rg9XYqrL/FjlX/K8FOyWBtPrxCpipjmrhWKDfKQaBwO93bOeXjeCWltygLDXPoh1/WAc
         7tW1KlZ3M7v1rjkD4eJFxSANNVg6gVVfj89bu7OZfaQ0GYtyB10EnJsjJLqXSNvZW6Zw
         CzsqHAslZ9x2ubbeoZevOTyhBxjjp2q/Gf5dVHZwzX0cL/ZiRvMERFzOqtJZylbaUquK
         i7Q5zoYXqlyqFe9YMR7fbBNODQ8IFzOb93jZqHqFLGVPCJV4HXTl2fesO3ZyezzYv+m5
         C2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793744977; x=1794349777;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e+zgS/meIzysO65no3N4roovnU/p8m28ecSLsndu/gM=;
        b=tI9AOGkBlNMZBzC3qmwDdmLYmgGTIa22ZWCVI1W0MfzZ7X8M0iPNCyVBKq50wTP0fj
         cNI6S22U+cwDVKgrYthNqxGuhGtLgIA0cNeLSPQcZ+l+r98zqBaMSsxAjIatkWttKi1n
         02UUwMobQWNUhtyFLW78j7+eLLlezl0PW/+LuKJAnf2wYFmVN06+sHewDzL6tAG7evF2
         55hujdiUNNqekTjoLVtJmmsa14gEyzQs/50YZyAN+xV3br88WardhFndo91a6zBR6wzl
         cr20dNBqDR5uuf27Tj3acwi8cKCgDQvdqfIGHd4b+d1llrxT8txI+MDjdRpkqUi0wnv3
         PQ1A==
X-Gm-Message-State: APuU4Z8umkbUHrzRgmsqXNGv2DQW1P54+dyPwCJgwkr+ZroJZZXu2IKW
	AmjZg5Rm6H5Cmoi86xrFp6yr/dIX9OqYnmNYadLSWNOB6BgQTPqXA/sLghdsfyqR2WoZ6QsnOhV
	BpBXsq3CzVskpjF98A2Quh+cgMiKVEorNRKDGBNk=
X-Gm-Gg: AYBFou21ixJaUS8bVSwpqCAQQN8phglQhy1kF2gyOmoE80SJZTP8EkamUERc55+g4+x
	9tuH0nawtM6jbBHwxylPqOApLutV1tMZRWdFipkdn6iPEaOcXP+WBYzsV9pp5zicsuWJP6eoJwk
	1WnTda9bsYARMMRduKb98CnJ+bxI1QGadzVrAaeILk4I+Ksn7oe+uv+G3+OSsmEAoENrIJYMRrX
	xYJ8SiHetNHG6tfn0l1DLgltYislxZC06LKkTJWsTfTtOjnRjDFOhXk8X223Bb07Qyhj2oGOHwD
	lNH9wUEx9j/v8C3Ja+m7GLLBWvVp5no0Wt4OMFkroyFt+bZ5RLofgI5ypC5GiKOeaKLsJTNh9N4
	BiPuG7Hzn+kLKCY+Cz6PGCfFlFNI6DfencKx6vKY=
X-Received: by 2002:a05:690c:f05:b0:897:73ed:dd25 with SMTP id
 00721157ae682-8b2b67095afmr108503777b3.27.1793744976631; Tue, 03 Nov 2026
 14:29:36 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?UGFibG8gTWFydMOtbmV6IFLDrW9z?= <pabloriosmartinez@gmail.com>
Date: Tue, 3 Nov 2026 23:29:25 +0100
X-Gm-Features: AclHuK-KWyigjh-JYhxazCuURrcf6kvPyIG1od7zsbxQNPNPqPflWrx8PqIWT6c
Message-ID: <CALTviDkEWERPrtc51WFB1K3Sn7wLdt6YhB=_Ck4PwBPdLcojBQ@mail.gmail.com>
Subject: rtw88: RTL8822BE (10ec:b822) never authenticates on 5 GHz with a
 Huawei router; poor 2.4 GHz link; same hardware works fine on Windows
To: linux-wireless@vger.kernel.org, pkshih@realtek.com
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report a problem with an RTL8822BE using rtw88_8822be.
The same card, in the same spot, works well on Windows, so I suspect a
driver/firmware issue rather than coverage. I am happy to run any tests
or try patches.

HARDWARE / SOFTWARE
- Laptop: HP Pavilion 15-bc450ns (i5-8300H), BIOS F.32
- Card: Realtek RTL8822BE, PCI ID 10ec:b822 (04:00.0), HP subsystem.
  Both antenna cables are connected; "iw phy" reports available and
  configured antennas TX 0x3 / RX 0x3.
- Debian 13.7 live USB, kernel 6.12.107+deb13-amd64, firmware-realtek
  20250410-2, rtw88 firmware 27.2.0 (H2C 13)
- Same behaviour earlier on CachyOS (a recent 7.x kernel, exact version
  not recorded) and on an Ubuntu live session (26.10)
- Module parameters at defaults: disable_lps_deep=N, disable_aspm=N,
  support_bf=Y
- Router: ISP-supplied Huawei OptiXstar EG8145X6-10, separate SSIDs for
  2.4 GHz (ch 6, 20 MHz) and 5 GHz (ch 36, auto width). The router is
  one floor below the laptop, with a concrete slab in between.

PROBLEM 1: 5 GHz
Linux never authenticates. This repeats indefinitely:

  wlo1: authenticate with 22:87:ec:xx:xx:08 (local address=90:32:4b:xx:xx:xx)
  wlo1: send auth to 22:87:ec:xx:xx:08 (try 1/3)
  wlo1: send auth to 22:87:ec:xx:xx:08 (try 2/3)
  wlo1: send auth to 22:87:ec:xx:xx:08 (try 3/3)
  wlo1: authentication with 22:87:ec:xx:xx:08 timed out

- It fails with WPA2-PSK and with WPA3 (SAE), and with the router set to
  WPA/WPA2 TKIP+AES and to WPA2/WPA3 AES, so it fails at the 802.11
  authentication frame, before any SAE/EAPOL exchange.
- Same result with regulatory domain 00 and with "iw reg set ES".
- The BSS appears in scans (its beacons carry country IE ES), but no
  authentication response is ever received.
- Windows 11 on the same laptop, same spot (Realtek driver
  2024.0.10.209): connects with WPA3-Personal, reported RSSI -76 to
  -81 dBm, 80/80 pings answered, 3-9 ms, link rate 260-292 Mbps as
  reported by Windows.

PROBLEM 2: 2.4 GHz
- Linux associates, but the link is very poor: iw reports about -73 to
  -76 dBm, and the beacon loss counter rises about once per second
  (14 to 65 over roughly 2 minutes). Across 5 runs, ping to the router
  showed 0-54% loss and average RTT of 37-278 ms.
- Kernel messages: "rtw_8822be 0000:04:00.0: firmware failed to leave
  lps state" (several times), and once "failed to send h2c command".
- The beacon signal average (-97 to -109 dBm) is far below the frame
  signal average (about -75 dBm). With a phone hotspot at -48 dBm both
  agree (-46). Occasionally signal readings of -100 to -112 dBm appear
  with the second chain at 0 while traffic continues.
- Windows, same spot: 60/60 pings, average 12 ms (max 157 ms).
- With a phone hotspot (2.4 GHz, ch 1, -48 dBm), Linux works well:
  rx 78 Mbit/s (VHT-MCS 8, NSS 1), tx 65 Mbit/s (MCS 7).

TRIED WITHOUT EFFECT
- "iw dev wlo1 set power_save off" (one run had 54% ping loss)
- rtw88_pci disable_aspm=Y (lspci still showed "ASPM L1 Enabled"
  afterwards)
- WPA2 vs WPA3, regulatory domain 00 vs ES

COULD NOT CHECK
/sys/kernel/debug/ieee80211/phy0/rtw88 does not exist on the Debian
kernel (presumably rtw88 debugfs is not enabled), so I could not read
tx_pwr_tbl, phy_info or coex_info, nor test the edcca_enable switch.
A single correctable PCIe error (BadDLLP) was logged once; the AER
counters were 0 later.

QUESTIONS
Is this a known issue? Which additional data would be most useful (a
kernel with rtw88 debugfs, a debug_mask setting, a monitor-mode
capture)? I can provide full logs and test patches.

Thanks,
Pablo.
