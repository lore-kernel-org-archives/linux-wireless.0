Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789137;
	b=M1xHYEiAffkRf6Yyek9+Jc+nxIKZJfanwaZs44HE0IyDxMydBl8vDovifHj+i/OkxW/p
	 Mp03m2sBbfCdAhXjPSrCdLKkFkxoI3PoCxRsXwwzVx6fQ3pEagbUWVZg7g7hASOcnf33f
	 rT21KLQd0T2HLjKoVtnG1mQkB6YJSvuCaEItA3mRnjjPax3u7uFxBkWS/xCXFuTrEZbzD
	 EY+bcSSbziHbnTzvN1lf2h+ZxK79hiKcMiSsvyTiBtx9w7f0llTGQKCqyrRsT+UuVAm2w
	 a0QD0L1zJDOYbI4cUdLu/hkw75l+knZVNXjcR+SacxSp1v+YBcjLzIFuMqPVeXHQLpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789137;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Dz58ddTIcWacdijll4/jjmZ8el9TsxHUA1XVL6xqMC8=;
	b=v5ZJYIkpcILz+9gi0xVua5w+WZkm9ry+kRwwUcRgD9RsdeCioNMAZfwPnXEac+BcoaXk
	 oY7Iv1UmMNsTpjwfXCgcPKBd8RivvrDYEHsPyWRf93bhMiDj5SyQ5wRcBZHfiWlYP5wkq
	 IXs2d92s7AMjYWG4ts5IBTO5uXGet4FrL44ylVrOcWAkJ6Keg/APntrN8PrwyWndCgSXu
	 utb3HCWjqnTlsiYej53Q7sSybna15AxeajRMg2rWsITv8j/dTt1sPtY+9oU1VfjYQJKYZ
	 ni0vIaER3kvmLAZTB6BeRPkY/d7Enxds6THXNPhdTDJ9OsfOLcH/kw1/qsJDJb8gQGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AsB1Zx4U;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A82F606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 10:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A82F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AsB1Zx4U
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490585eddfcso230692f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793789136; x=1794393936; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dz58ddTIcWacdijll4/jjmZ8el9TsxHUA1XVL6xqMC8=;
        b=AsB1Zx4U7u8LiqXXChXgXoa2Gjh+LBnhgkqu4aE5DbwcJfLOEw1U2dp6h1UU2lGa5h
         WN8aCLZqoR7BADIOUDsWMhoQx7t7kAyHSAP7U6oJdMD05e3qOA4Eq/KQqbb/dKyV6Osf
         dWwmUY1gfVa55/VJq5xuNhDdeALizG+D6DAnsHua1N58j7LEveKGgh8v5S5FFnEdKvqR
         pMX+JkV9M6xi09vnjnvGFNi1RbTmHkXgbC/qWJ6z9J13nPx6CiPGW9D+SuSkZdmbJtm9
         GLh8tiDY0f5S6R8sC5XCiqRV5QfYw277se8JjfR+vQreRV0FrS2GiKKu5ESY/8tWBnwa
         hoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793789136; x=1794393936;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dz58ddTIcWacdijll4/jjmZ8el9TsxHUA1XVL6xqMC8=;
        b=CeyrqXbYV++QEvG7DXVksE4PEcTP69oBTQnH+mzpVzrebNSd9qgpb1GR0Tk4itBhdh
         wuPCrSKesZw3gwKqirOJPRpkRxsYQWweaQfY6lxC+T9jsbBnoPNWKHWqbeqkJ2J/ckEX
         0MUloBXBQdTjgTyy6Shhu/4zvLCsWG34kVIy6tVNkso1fl5sFOk5uXM3fszIW3SU3MVn
         UhCq/oxD6nTDoe0vDo5rS2zuUL/m8dAybZiN1lM9tRA2zNVWJB9tRPRKZG5BU3LcGN35
         vlcyD4z/FRtNIs01dUZ+SC8jKefR8AOueQ5LD50bjvk8j6b0IYYdu3VA6WKJL5MYHvuN
         xvyg==
X-Forwarded-Encrypted: i=1; AKwUvBxXviuHZsYZSuecVVZZ41c0ZuEJP12+HLCDImKkWJB4meH4OrrJ8mXcqk3DpcOny3Jm5omMqimxs9daDGIJ/w==@vger.kernel.org
X-Gm-Message-State: APuU4Z9F3ufTDpAqatygeKzVK/FnDDhebsdI/YIuJh+F1JQvXuBCPcf4
	N3H7yfqaq7o1o+PawVIVZd669KhGHrTzqtRMprNvCorwrmnleSP8RuU6dpDzOD6G
X-Gm-Gg: AYBFou0JtvCVeRagaQNp1cl4S1NTC7Gtkje9SF6TDcWdostSrQQoagaT1+SeMcfw9SU
	G5bK+09+90pwcCUBFlIFYUmRvXF4pUeC82JczUkjC+Q14T27wqNWe24gp0uKtMntdxpRLi3fmEH
	fJZRQAO0hFj4ddDJiaoTNRRPDk778MEqggYGd6/3ZlhT5A2K9ETwfJCAnmjMiVEOZ6YUhQyDcgo
	oXbNxX5/25d/AkRgduB1PsmlqanWm9U9u2/1GByRWGK0mpY71W8pD7j/XnHVFvIGbqF8FXENtaY
	JP94inUIKmasu2Znr9ROoHfnBvIsz4N9sikwRqp65wZSyXOZKnrVcLuCD+Ky6Cx7YVJgKrwOlU6
	qjCFOvS0XU+/P8pNZztZNqrhEDlWrURuMsEmv57hYee2GfA0UELObzBCSW109PPaSPAhLnIHWTf
	gHDkP6N0UC4biRFFy6snbVXu/rE/DcEq3DUrH1aCW546mocicdTlgCe1M1MkZ1rnFtNjXbJckbg
	tBKLLdSRP+z2mSjg9IhF/LoeUcw3dVQbO4FgoYlnAaK2sGtSVLHCkv97xhKp3BsbS4gRANcr3c6
	/+kCk5LfvE95gts1CsXNgVDaWt6E7tanNDw=
X-Received: by 2002:adf:e19d:0:b0:48d:ffcb:28e1 with SMTP id ffacd0b85a97d-48e6e4f570dmr35161976f8f.11.1793789135626;
        Wed, 04 Nov 2026 02:45:35 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fec8d87b5sm3049555f8f.11.2026.11.04.02.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 02:45:35 -0800 (PST)
Message-ID: <7d68ebe2-d24e-4c07-9b49-7f76551a12bb@gmail.com>
Date: Wed, 4 Nov 2026 12:45:33 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: rtw88: RTL8822BE (10ec:b822) never authenticates on 5 GHz with a
 Huawei router; poor 2.4 GHz link; same hardware works fine on Windows
To: Ping-Ke Shih <pkshih@realtek.com>,
 =?UTF-8?B?UGFibG8gTWFydMOtbmV6IFLDrW9z?= <pabloriosmartinez@gmail.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CALTviDkEWERPrtc51WFB1K3Sn7wLdt6YhB=_Ck4PwBPdLcojBQ@mail.gmail.com>
 <2c8319def838488cb8a3e4d5dc44f357@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <2c8319def838488cb8a3e4d5dc44f357@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/11/2026 03:33, Ping-Ke Shih wrote:
> Pablo Martínez Ríos <pabloriosmartinez@gmail.com> wrote:
>> Hello,
>>
>> I would like to report a problem with an RTL8822BE using rtw88_8822be.
>> The same card, in the same spot, works well on Windows, so I suspect a
>> driver/firmware issue rather than coverage. I am happy to run any tests
>> or try patches.
>>
>> HARDWARE / SOFTWARE
>> - Laptop: HP Pavilion 15-bc450ns (i5-8300H), BIOS F.32
>> - Card: Realtek RTL8822BE, PCI ID 10ec:b822 (04:00.0), HP subsystem.
>>   Both antenna cables are connected; "iw phy" reports available and
>>   configured antennas TX 0x3 / RX 0x3.
>> - Debian 13.7 live USB, kernel 6.12.107+deb13-amd64, firmware-realtek
>>   20250410-2, rtw88 firmware 27.2.0 (H2C 13)
>> - Same behaviour earlier on CachyOS (a recent 7.x kernel, exact version
>>   not recorded) and on an Ubuntu live session (26.10)
> 
> Is there any version working well to you?
> 
>> - Module parameters at defaults: disable_lps_deep=N, disable_aspm=N,
>>   support_bf=Y
>> - Router: ISP-supplied Huawei OptiXstar EG8145X6-10, separate SSIDs for
>>   2.4 GHz (ch 6, 20 MHz) and 5 GHz (ch 36, auto width). The router is
>>   one floor below the laptop, with a concrete slab in between.
> 
> I think it is worth to try putting closer.
> 
> And, can you try another AP to see if anything different?
> 
>>
>> PROBLEM 1: 5 GHz
>> Linux never authenticates. This repeats indefinitely:
>>
>>   wlo1: authenticate with 22:87:ec:xx:xx:08 (local address=90:32:4b:xx:xx:xx)
>>   wlo1: send auth to 22:87:ec:xx:xx:08 (try 1/3)
>>   wlo1: send auth to 22:87:ec:xx:xx:08 (try 2/3)
>>   wlo1: send auth to 22:87:ec:xx:xx:08 (try 3/3)
>>   wlo1: authentication with 22:87:ec:xx:xx:08 timed out
>>
>> - It fails with WPA2-PSK and with WPA3 (SAE), and with the router set to
>>   WPA/WPA2 TKIP+AES and to WPA2/WPA3 AES, so it fails at the 802.11
>>   authentication frame, before any SAE/EAPOL exchange.
>> - Same result with regulatory domain 00 and with "iw reg set ES".
>> - The BSS appears in scans (its beacons carry country IE ES), but no
>>   authentication response is ever received.
> 
> How can you prove "no authentication response is ever received" ?
> Can AP ack the auth? I mean that might be a TX side problem.
> 
>> - Windows 11 on the same laptop, same spot (Realtek driver
>>   2024.0.10.209): connects with WPA3-Personal, reported RSSI -76 to
>>   -81 dBm, 80/80 pings answered, 3-9 ms, link rate 260-292 Mbps as
>>   reported by Windows.
>>
>> PROBLEM 2: 2.4 GHz
>> - Linux associates, but the link is very poor: iw reports about -73 to
>>   -76 dBm, and the beacon loss counter rises about once per second
>>   (14 to 65 over roughly 2 minutes). Across 5 runs, ping to the router
>>   showed 0-54% loss and average RTT of 37-278 ms.
>> - Kernel messages: "rtw_8822be 0000:04:00.0: firmware failed to leave
>>   lps state" (several times), and once "failed to send h2c command".
> 
> For this case, "iw dev wlo1 set power_save off" should help.
> 
>> - The beacon signal average (-97 to -109 dBm) is far below the frame
>>   signal average (about -75 dBm). With a phone hotspot at -48 dBm both
>>   agree (-46). Occasionally signal readings of -100 to -112 dBm appear
>>   with the second chain at 0 while traffic continues.
>> - Windows, same spot: 60/60 pings, average 12 ms (max 157 ms).
>> - With a phone hotspot (2.4 GHz, ch 1, -48 dBm), Linux works well:
>>   rx 78 Mbit/s (VHT-MCS 8, NSS 1), tx 65 Mbit/s (MCS 7).
>>
>> TRIED WITHOUT EFFECT
>> - "iw dev wlo1 set power_save off" (one run had 54% ping loss)
> 
> How about the loss rate comparing to power_save on? Almost the same?
> 
>> - rtw88_pci disable_aspm=Y (lspci still showed "ASPM L1 Enabled"
>>   afterwards)
>> - WPA2 vs WPA3, regulatory domain 00 vs ES
>>
>> COULD NOT CHECK
>> /sys/kernel/debug/ieee80211/phy0/rtw88 does not exist on the Debian
>> kernel (presumably rtw88 debugfs is not enabled), so I could not read
>> tx_pwr_tbl, phy_info or coex_info, nor test the edcca_enable switch.
>> A single correctable PCIe error (BadDLLP) was logged once; the AER
>> counters were 0 later.
>>
>> QUESTIONS
>> Is this a known issue? Which additional data would be most useful (a
>> kernel with rtw88 debugfs, a debug_mask setting, a monitor-mode
>> capture)? I can provide full logs and test patches.
> 
> The kernel v5.3 or earlier support RTL8822BE. Could you bisect (use
> distro live image) which kernel can work to you? It would be easier
> to address problem. 
> 
> Have you tested with disabling Bluetooth, since this is a combo chip?
> 
> Another point is that rtw88 can only support these types:
> 
> static const struct rtw8822b_rfe_info rtw8822b_rfe_info[] = {
> 	[2] = I2GE5G_CCUT(efem),
> 	[3] = IFEM_EXT_CCUT(ifem),
> 	[5] = IFEM_EXT_CCUT(ifem),
> };
> 
> You can add a printk to print the type of your RTL8822BE.

On CachyOS you can get the RFE type from debugfs:

cat /sys/kernel/debug/ieee80211/phy*/rtw88/coex_info
