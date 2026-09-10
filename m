Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92D735F61A
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042896; cv=none; b=L9mWIbynpxQOWmJgQAInKCLD+X8w9t8f6D25/UgKVzDc69gArA6lD9gvm9NJKFfHAU0Uu+PYWFju1NX3RUCUFWOjaB5wNc6uVeKPiP4Lb6xp8w6fz4Vq1maFPhREt5phxc/3AOzCRPRczRjiSeps5+OZEvLUDN+QS43uD4FkE7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042896; c=relaxed/simple;
	bh=3YSi9//y6wPD28wU1XlcObZ8SNQ+ub6n3+CUfTGp2ck=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Subject:
	 References:In-Reply-To; b=EgGdVw8ZKA4NumQIom8mFQiLWWoBnUVifvIZo2Cr7oKTyuoxGxwIjZelCIVQeK8R/i25dit1WUZutUM4H5w41B/9bBacbB8dtnSj1xy9WOhslBiQ7EkK48jRbEgxHjRoo1w/RGGjCj5FndD15XQKgc3d93swEl0CNfcxT7FPgGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=F0/R/kWc; arc=none smtp.client-ip=91.218.175.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="F0/R/kWc"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3YSi9//y6wPD28wU1XlcObZ8SNQ+ub6n3+CUfTGp2ck=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789042888; v=1; x=1789647688;
 b=F0/R/kWcf/d54h8sE31UDjW+Xj5ggxQX0w4FM1YxI6RQleHwAFkMvtA0qT2/1F4CDR8R+jrQ
 BJkzAVoEoZMnJlwAG/AK8bX56h+kLorRBgGQpIH3iTxu1UIpOwC5jOyMt2WO0NJK+oD2Yt0licB
 lx4aY/ZfdI+27FjtFEkalwpnaBgHQaj9y+jUt3mTdze1JAI0/Qh2DY8uKYltZ++r0jKFrMqx3/Y
 x6t0uylZd576281/1FQTTckfn725EwKkSin7pi4VzQeqfYaKBmn05wFxMBGnF+eX7ba0xh+1qCY
 lYHGXvVdWU9kKJqr7cD1azEQ2KrlajLG5zCWF7HDj5fQg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7068feb5e5d40f55;
	Thu, 10 Sep 2026 12:21:18 +0000
X-Mizu-Trace-ID: 7068feb5e5d40f55
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 14:21:10 +0200
Message-Id: <DLBMROQPJN2T.3BIEEFHQ7R6QB@cknow-tech.com>
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Diederik de Haas" <diederik@cknow-tech.com>,
 <linux-wireless@vger.kernel.org>
Subject: Re: Stack trace when starting iwd with Intel BE200 M.2 Wi-Fi+BT
 card
X-Mailer: aerc 0.22.0-9-ge948bb7230f4
References: <DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech.com>
In-Reply-To: <DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech.com>

On Thu Sep 3, 2026 at 2:59 PM CEST, Diederik de Haas wrote:
> I have a FriendlyElec NanoPC-T6 LTS (arm64, RK3588 SoC) and plugged in
> its E-key slot an Intel BE200 card. I'm using TF-A + U-Boot as firmware
> and bootloader, not something with ACPI support.
>
> That's probably why I'm getting these warnings in dmesg:
> ```
> [   11.313596] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-81=
4f-75e4dd26b5fd rev:0 func:0 (0x1001)
> [   11.313641] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-81=
4f-75e4dd26b5fd rev:0 func:0 (0x1001)
> ```
>
> My kernel does have ``CONFIG_ACPI=3Dy``, but it's not used on this device=
.
>
> When I start iwd.service, I get the following stack trace:
>
> ```
> [12144.572968] ------------[ cut here ]------------
> [12144.572984] WARNING: net/wireless/nl80211.c:10730 at nl80211_get_reg_d=
o+0x244/0x270 [cfg80211], CPU#6: iwd/2361
> ...
> [12144.604286] ---[ end trace 0000000000000000 ]---
> [12145.058595] ACPI: <n/a>: failed to evaluate _DSM bf0212f2-788f-c64d-a5=
b3-1f738e285ade rev:0 func:0 (0x1001)
> ```
>
> Despite the stacktrace, the wireless connection does work:
> ```
> root@nanopc-t6-lts:~# iwctl station wlan0 show
>                                 Station: wlan0
> -------------------------------------------------------------------------=
-------
>   Settable  Property              Value
> -------------------------------------------------------------------------=
-------
>             Scanning              no
>             State                 connected
> 	    ...
>             RxMode                802.11ax
>             RxMCS                 10
>             TxMode                802.11ax
>             TxMCS                 7
>             TxBitrate             1225100 Kbit/s
>             RxBitrate             2161300 Kbit/s
>             ExpectedThroughput    1020936 Kbit/s
> ```
>
> Similar results and stacktrace with kernel 6.18, 7.1 and 7.2, so it's not
> a recent regression.
>
> I also have a NanoPC-T6 Plus, which is quite similar, with an MediaTek MT=
7925
> M.2 Wi-Fi+BT card and there I do not get the ACPI msgs or the stack trace=
.

I also have an Intel AX210 M.2 card and I plugged that into that same
NanoPC-T6 LTS and there I do NOT get the stack trace.
I do get the same kernel warning as with the BE200NGW card:

```
root@nanopc-t6-lts:~# dmesg | grep ACPI
[    0.265591] ACPI: Interpreter disabled.
[    0.285103] pnp: PnP ACPI: disabled
[   11.047559] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-814f=
-75e4dd26b5fd rev:0 func:0 (0x1001)
[   11.047579] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-814f=
-75e4dd26b5fd rev:0 func:0 (0x1001)
[   11.295741] hci0: No support for bluetooth device in ACPI firmware
[   13.026720] hci0: ACPI-BT: No ACPI support for Bluetooth device
[   13.026745] Bluetooth: hci0: No support for BT device in ACPI firmware
[  119.634515] ACPI: <n/a>: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3=
-1f738e285ade rev:0 func:0 (0x1001)
root@nanopc-t6-lts:~# iwctl station wlan0 show
                                 Station: wlan0
---------------------------------------------------------------------------=
-----
  Settable  Property              Value
---------------------------------------------------------------------------=
-----
            Scanning              no
            State                 connected
	    ...
            RxMode                802.11ax
            RxMCS                 4
            TxMode                802.11ax
            TxMCS                 3
            TxBitrate             29200 Kbit/s
            RxBitrate             432300 Kbit/s
            ExpectedThroughput    26328 Kbit/s
```

Not very impressive Wi-Fi speed, but alas.
I actually bought the BE200NGW and (later) AX210 card for Bluetooth.
Both perform poorly/terrible on that front, while the Intel 8265/8275 card
in my *amd64* laptop works great, including Bluetooth.
My laptop does have a BIOS/UEFI firmware with ACPI support.
Is ACPI support in boot firmware a requirement?

Cheers,
  Diederik
