Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792683499;
	b=bIrWM5wKl5A9LviaIZASiyqSjWJR+kkg1aIDpb3qK8wLMI1QK2+4sJVT3PinLZbdbiUd
	 fWG+ipDucMVLzj2iYMOP3nZQ8M4ghdve+bBTDI6aP+b9m+1Gpgn80lKslKfiAJtOOPfTD
	 ie15Mb8ylXl38JNcG+mEXaYxSXxLvrL74iVxbFI0If6u0C7DrjUt5XnFJx3x4/hcFvd8y
	 PLhhQIFapblvkeb+108kpNonxIi+RomraCDsSxFxm2XKhPawY7Dn6jl5q1jCQO8odWzx3
	 5leZW3iZR4gHKpGQuPoXOMON6pKSFGB5dVnUa8RBEdYRAkgWRqWONGvcDaDy0Jckm4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683499;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=o7ZhmIgapO7sB4tEy9JjIYiQH9wnF4DTp0ZY1/4zEaE=;
	b=LF+XVaJOplBYm7RBvTBYQHuEf4n6JozMOihmZpT08FIlCbhvyvYMYBK3NqDKNjJvDVLp
	 ZtuCHhOBa7Dq6ohTBTvyWKj/yiq8vC32mnd6eaEtECeWiFBwcDd2MKjLRG8J/XQNDhNg2
	 5pk9Fu+7K2eDUWVEu8iBwgMCPo4OrJCzYpX3lSlvEafEorwG3jXXenrtDjxYkxF5qaF9m
	 1/+BMD6pzWiQkumYV5/5v/X45Ai0Fxj5hVx8WwP5c5tnnIW5h1jPWT2E+2PYU1+rbFOJJ
	 H5tW6e0e2Vmd7Gb9hzflXMVzaH4Q5TcAdll4jXyCieBOk4CdJcqrpjg4NlenJxOgD3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ofiTsxrs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE7C606A31B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 15:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EE7C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ofiTsxrs
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91b83459526so18226d6.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 08:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792683497; cv=none;
        d=google.com; s=arc-20260327;
        b=G65mczKn+egp3iXxfOjaK1Y8dxZfoDizHJPoSAzJn9mIggbg79s55IgGzH39oewGNL
         W/LQcGwHBxtwMmj+RUtWCuIBY1zzlj93kKNPqVRUmetwHuco570Tj874t3YgJ4zicbkO
         +zPoEtXMxNUBJMCLThx/5qQ4KX6VuNu99/pYfDccnigRL8tfMySwuToyJ1t4G4KsHPr4
         kYhbaNp49rz+TgmfukhbOtu+xnbziFY/xrnIN5e3NeFFFMyxSwUrmpoNSDSlOEoHNaZD
         e469IY4zgVHBxzz/zBTGe0A2XthqqrcWUe3gO00vshQ8dPdrS1bf8dvJN9NdGG4CUcS6
         QhVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o7ZhmIgapO7sB4tEy9JjIYiQH9wnF4DTp0ZY1/4zEaE=;
        fh=0K30IcIZ5rd88XEjs6v0ZlsEnDypfWGkY51/oJuUgwM=;
        b=bNu6HvP3udtLTbzTvyZAN2y+vCtN6wzqy0JZL9ugtDe8t7RcLsqRtkRYyDJm6t7e9h
         ivzM8/gAG+0019GSGy9deH0bxPkhSgxqMpELFtuXyhJUbmUQohYGlg965Y74FOAQk+g2
         LIn69XB3mWWHws8DnzfjIzmFOqaNGPTeXcLRxyRxDFjUTd+ibf6XmNTuPmUhwR5Z1tgb
         8M5vHSsZNtg0qvyMTa4hiB1xRhbDPXVMK4jenIFx0b9krSfoSSKm3BrMB/V9jUBWAwJ5
         +HHtdj+wRCsLBocXOKAaa071B+SNOJx1cjACymHyasPTiHG+QPUV09jMsFdif2i8S2mK
         2NVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792683497; x=1793288297; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7ZhmIgapO7sB4tEy9JjIYiQH9wnF4DTp0ZY1/4zEaE=;
        b=ofiTsxrsZbMusf4Xlcz/c1ye5oZ4NvwBZjKGm8C9ARSTR+axAZ16zEUWeEszZbojv6
         zC1mDYCF5CL/SLjZpYa0nKf48qTVpzZGu5xeVKlEx3zgmvORcVY0MkgMpwO6gVJXNkHP
         U/5HyRUMUB+ZP9afP1JJ8Zvc1BvezO0RgZiKGxrj5aOCvfF6YT+M9l5SJIJIdZTty83v
         oxMsJ7ZMWZ/tePek5ugY9TyvbvzjA1zEsUHoTzAH0dPn57BSIhmhrcv9bJjg8iP+H1f+
         nPSK/6dDIubxvm0Jm/98aoZ1kNPcJ1YcgFHmK+BjePzBluviZCOcCu7C/gydgnGUHL0l
         KYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792683497; x=1793288297;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=o7ZhmIgapO7sB4tEy9JjIYiQH9wnF4DTp0ZY1/4zEaE=;
        b=wWx7ZYj15HGd8Z8INYSneW6gfEub80Xr1s0r39S+VLGp6scxZHM1pA05wKJEpT8Jqf
         2RbrvZHhIte/iEo0D+qDKYNYWeCoog366qpwr2aB2Rb1LmcotyRudOqryhZhVlCliYTe
         anlUnwdehP80JFzNFETmj2+1R9+9weGhSP3sNENPv7RHNc2p6ZqY5hTcUDSLKBIokxth
         0XFlx1r9X6Xz3sxP5H96GDFtqQlchUrqUnv7TrSZg1+Zq4pyhAHpHHSYChHmJAFl6X1d
         DxnjwYukOld2APomcOoQSiqMyUP+wiJZf6uGIEm/VI2pPh6altW0X1/8Rz7HiryXxinc
         74Vg==
X-Forwarded-Encrypted: i=1; AKwUvByMvr2iSzBZPlVlWmPpwJ3dIo2SO+3kh6QewGelUdfnqvX4ZXbUEb8y/NNdF/R+E/uoTiBn0qfysi3qJkrLwA==@vger.kernel.org
X-Gm-Message-State: AFq9FYL/Hca5K5v1hUq7s8AFn6grazYAYaW/GR1T//60yj0XhGLbrrKp
	VnAiM/5cUoUwP8bldcNdWzm/KnKINjDfhNc8t616DklbKahd0tXfK4t2mFyNbUiwRoMCw5hH0gj
	Mfix1sQEyswCHox5vTH9fgfYrnMQGWqk=
X-Gm-Gg: AYBFou2duXy9kjp6qwvw5Uw0qoW2v1qDD+JKBczGqO7GmnVysH5xEaqG42zWRds/GFw
	erawfKndEspUkyF7ZVIfFvRiSt1Y/Suk1CXSm47RHccrEKLhTkcuXBlzwS7I8gnxJKQOQ/0CIwu
	sqCfsQa2OMI4D6tuBJ2XTEWt1hsFgybnZcclxHzK+vxB/Dc1LpFBjZTBoHBzUishkyAYRhhz7HC
	Pnl4Vu9exppwtUAHX4HaoNb+Nck0Gr7TXJ4axZftveCN8MpiiuMW5pmMoLikq1t/pntzOcynEk9
	fHuWp3B1AeVpbfWWIyyWZpA2k/458n2JpYdJYxWaQ7b+OcxnbpTDUlgI0Kw1PuKIwB3nDXd9hd5
	uie8mKXEd0eHFUmfTyoI1tPfTc+BA+xREoQqiJnVYhZWfSiHYsMfee0NUPEv6ugsPHDiNo0NmZX
	+lfTnlwBp+nys1joZwMOxmRUbZWTrcxdMuutQdTOnWlfL+ws/TZZmJzQsJXsbnWngXGhl6Mshv1
	uSKojKVxlRSTV476v41QxYB5WrrXNBfwQY=
X-Received: by 2002:ad4:5d46:0:b0:91b:84d1:5c73 with SMTP id
 6a1803df08f44-91c12eed190mr92514456d6.12.1792683497164; Thu, 22 Oct 2026
 08:38:17 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261006130701.120460-1-luka.gejak@linux.dev>
In-Reply-To: <20261006130701.120460-1-luka.gejak@linux.dev>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Thu, 22 Oct 2026 16:38:05 +0100
X-Gm-Features: AclHuK9XC8r_3uVfTWtK8cLfOLYuPfjNqTOzeWnstj8Yb7R7BoPLwf8SDqgM9Tw
Message-ID: <CALeDE9NKkv8TxiCNUt-fUYUkh_zk7Ne7hRKF51QDOSvvrp1YRQ@mail.gmail.com>
Subject: Re: [PATCH rtw-next v8 0/7] wifi: rtw88: add RTL8723B/RTL8723BS support
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>, 
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hey Luka,

On Tue, 6 Oct 2026 at 14:07, Luka Gejak <luka.gejak@linux.dev> wrote:
>
> This is the second of two series adding support for the Realtek RTL8723B
> 802.11n chipset and its RTL8723BS SDIO variant to rtw88. The preparation
> series has landed in rtw-next, so this series carries the chip register
> definitions, the BB/RF/AGC tables, the chip driver, the SDIO bind and the
> build glue.
>
> The first and fourth patches are the shared-core changes. The first moves
> the CCK power detect setter out of rtw88xxa.c into phy.c as
> rtw_phy_cck_pd_set(), so this chip can use it without pulling in
> rtw88_88xxa. The fourth moves the definitions RTL8723B shares with RTL8703B
> into rtw8723x.h. The five chip patches apply on top and can be read on
> their own.
>
> The driver supports:
>
>   - RTL8723B / RTL8723BS, SDIO only
>   - 2.4 GHz 802.11n, HT20 and HT40
>   - one spatial stream
>   - station mode
>
> Only station mode has been validated. The common rtw88 core advertises AP
> and IBSS for all chips, so those modes are advertised for RTL8723BS as
> well, but neither has been tested. An out-of-tree tester has reported AP
> mode associating without DHCP completing. The five additional SDIO IDs are
> included for parity with the existing staging driver, and only the 0xb723
> device has been exercised.
>
> The chip driver requests:
>
>   rtw88/rtw8723b_fw.bin
>
> This is the version 41 firmware extracted from the Realtek rtl8723bs
> vendor driver. It was submitted separately to linux-firmware with its
> extraction provenance and carries Ping-Ke Shih's Reviewed-by. There is no
> known native rtw88 RTL8723B firmware.

Did we get the firmware PR done against linux-firmware?

One thing to note here is that the old revision of the firmware will
need to remain in linux-firmware as the LTS kernels will need them,
not sure that's a problem as the drivers use different paths.

It would be useful to get that done so users don't see a regression as
the old driver is removed.

Peter

> The implementation is based on the initial RTL8723B work by Michael
> Straube:
>
>   https://github.com/mistraube/rtw88/tree/rtl8723bs
>
> Michael's Co-developed-by and Signed-off-by tags are present on the three
> chip-code patches containing code derived from that work.
>
> The known limitations are unchanged. Bluetooth coexistence depends on the
> BT firmware's status reports. During A2DP streaming those reports identify
> a connected link but do not expose the active profile, so the WiFi
> coexistence logic cannot make a correct traffic-aware decision. WiFi
> throughput can fall sharply while audio remains smooth. This is documented
> rather than guessed around in the WiFi driver. The intermittent RTL8723BS
> firmware failure to leave LPS also remains, and instrumentation shows a
> firmware stall rather than a polling timeout that a longer budget would
> fix.
>
> Testing
> =======
>
> The exact seven-commit branch builds with W=1, with no new warnings, and
> links all rtw88 modules with real modpost. Sparse and smatch were run over
> the rtw88 directory. Sparse is clean. Smatch reports nothing in the 8723B
> files, and its only output is an existing container_of static assertion
> from include/net/neighbour.h while checking usb.c. checkpatch --strict is
> clean apart from the complex-macro report on TRANS_SEQ_END, which is an
> initializer macro that rtw8703b.c already defines in the same way, and the
> "does MAINTAINERS need updating" reminder on the file-adding patches, which
> the existing REALTEK WIRELESS DRIVER (rtw88) entry already answers with its
> F: line. git diff --check is clean and all seven commits are GPG-signed.
>
> Hardware validation covered module identity, boot, scan,
> authentication, association, WPA2 key negotiation and DHCP, TCP and UDP
> traffic in both directions, ten scans while connected, and twenty module
> reload and reassociate cycles. dmesg is clean, with no warnings, no errors
> and no TX-report, H2C or leave-LPS messages. The extended soak added six 30
> second TCP runs, UDP saturation in both access categories with no loss, a
> 2000 packet ping run with no loss, and three idle power save periods with a
> clean wake. The test machine provides only s2idle, so suspend and resume
> are not covered.
>
> Changes in v8:
>   - a new patch moves the receive PHY status layout, the SDIO aggregation
>     burst fields and four baseband registers out of rtw8703b.h into
>     rtw8723x.h, and renames struct phy_status_8703b to struct
>     phy_status_8723x. The chip driver no longer includes the header of a
>     sibling chip. It is a pure move, rtw8703b.c only follows the new struct
>     name;
>   - the vendor driver's name for that layout, phy_status_rpt_8192cd, is in
>     the commit message rather than in the source;
>   - dropped the long comment above the CCK swing table;
>   - the two receive PHY status helpers take void *phy_raw and read the CCK
>     LNA and VGA fields with u8_get_bits().
>
> Luka Gejak (7):
>   wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
>   wifi: rtw88: 8723b: add the RTL8723B register definitions
>   wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
>   wifi: rtw88: move the shared 8723x definitions to rtw8723x.h
>   wifi: rtw88: 8723b: add the RTL8723B chip driver
>   wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
>   wifi: rtw88: 8723bs: enable building the RTL8723BS driver
>
>  drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
>  drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
>  drivers/net/wireless/realtek/rtw88/phy.c      |   39 +
>  drivers/net/wireless/realtek/rtw88/phy.h      |    1 +
>  drivers/net/wireless/realtek/rtw88/reg.h      |   34 +
>  drivers/net/wireless/realtek/rtw88/rtw8703b.c |    4 +-
>  drivers/net/wireless/realtek/rtw88/rtw8703b.h |   63 -
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2534 +++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
>  .../wireless/realtek/rtw88/rtw8723b_table.c   |  861 ++++++
>  .../wireless/realtek/rtw88/rtw8723b_table.h   |   17 +
>  .../net/wireless/realtek/rtw88/rtw8723bs.c    |   59 +
>  drivers/net/wireless/realtek/rtw88/rtw8723x.h |   60 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |    2 +-
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |    2 +-
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c |   38 -
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |    1 -
>  17 files changed, 3647 insertions(+), 106 deletions(-)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c
>
> --
> 2.55.0
>
