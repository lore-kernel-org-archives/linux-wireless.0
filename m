Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7529427A462
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783348228; cv=none; b=i7i1c5HdnnOpZcCX4gwqPTKItjJc3M8y03KjYJapi525CeGmPvQ1t0KucLutL404cdsyJ8YRiow/A53pINlBU5mRHlItuakWrY3Zk9EtHHL0H8bhHL3z0UEiiPfRiNZvicv3S1pWorGqFqWPxVMXkxyhzl0b0S1Yf7008x9D2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783348228; c=relaxed/simple;
	bh=a/XqA2B9IXeqdJvgN26sqTv6vD62XbJlzDTGN+2AxxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VgydOoRxaYpZ1HcZLvpVa5+miP/93cH5VEGqkeuIfgvaARAcAdIJze0Gz/MD2oV7MqEVy0Z2VPQDxX5KxZp5MG4ftWgjihvfVuuBPyofCNMubHa7WsTaK3iSdgYPY+L3r7SVrOjgxf8atRtf2N7AWAsE7RwzI/cNtX5hxy/z1/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=AkovsWdZ; arc=none smtp.client-ip=188.68.63.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="AkovsWdZ"
Received: from mors-relay8203.netcup.net (localhost [127.0.0.1])
	by mors-relay8203.netcup.net (Postfix) with ESMTPS id 4gv63V0HZBz8hWW;
	Mon,  6 Jul 2026 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1783347670;
	bh=a/XqA2B9IXeqdJvgN26sqTv6vD62XbJlzDTGN+2AxxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AkovsWdZpiMelxLU8krRCE9eDs2tuq/iUSYMBaBPkI1J6Ky9iBUxlxNcsf5R3Ii5g
	 61Z9dD/yzX4XcEeTMpYsASzGGTfxYQG3AI9N35VUfJrR2XwPB4gJ8bl9Dr8B92LduN
	 s0HKFDZywHbX9uei9+arFFx+U+hPuEdruaVZqIcqqJNt/ISYXTWnaiFFvlFgeLsEsa
	 b1fwfL10XnJ3TS8f/QQpc3EfFrxKqCNLqoHBRv0hO9/bQTLmgzo4jySv2emfwDMXH4
	 N1P+gFdmtB35pQfQ+bU3c7ZLE4xrmGTUNmXC/zPc9qgyJ5twujPw5yWWe+F4FxxPHg
	 cp2DIJFUOghDg==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay8203.netcup.net (Postfix) with ESMTPS id 4gv63T6jBmz8hVv;
	Mon,  6 Jul 2026 14:21:09 +0000 (UTC)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4gv63T0Tjkz8sZw;
	Mon,  6 Jul 2026 16:21:09 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id C54445F9DD;
	Mon,  6 Jul 2026 16:21:07 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <870f1c80-5027-4503-b6c4-6df80eea7df3@leemhuis.info>
Date: Mon, 6 Jul 2026 16:21:06 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mt7925e: fails to read EEPROM MAC on 7.2-rc2, falls
 back to random MAC (worked on 7.1-rc7 and 7.0.x)
To: B X <brent@msbs.com>, linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com,
 regressions@lists.linux.dev, Rosen Penev <rosenp@gmail.com>
References: 
 <CAPpkL-yLfeNwsePSGDK7m8ctzPLXTVto1HhrufHv12HO0+B1Vw@mail.gmail.com>
 <CAPpkL-y54ySw8ftqeumccNEVatY0Zt6-Ag4PejYddK5WcsiV3A@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAPpkL-y54ySw8ftqeumccNEVatY0Zt6-Ag4PejYddK5WcsiV3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <178334766823.2192487.10433756603207527467@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: C54445F9DD
X-NC-CID: Kzmozycaux/WmByp46B+g7IQPQuWxEGuSNv/BLZgt7tLppAaeJc=



On 7/6/26 15:35, B X wrote:
> B X <brent@msbs.com>
> 8:12 AM (1 hour ago)
> to linux-wireless, nbd, lorenzo, ryder.lee, shayne.chen, sean.wang,
> regressions, Brent
> 
> Hi,
> 
> Reporting a regression in the mt7925e driver: on Linux 7.2.0-rc2 the adapter
> fails to read its stored (EEPROM/efuse) MAC address and substitutes a random
> one. The same hardware read its real MAC correctly on every earlier kernel,
> including the immediately-preceding boot one day earlier on 7.0.0-22.

Sounds a lot like it's the problem "wifi: mt76: fix MAC address for non
OF pcie cards" aims to fix:
https://lore.kernel.org/all/20260630210215.400379-1-rosenp@gmail.com/

Would be great if you could confirm.

Ciao, Thorsten

> Verified with Claude Code when my ATT fiber kept failing to pin IP on
> my Halo Strix
> 
> Hardware
> --------
> MediaTek MT7925 (RZ717) Wi-Fi 7 160MHz
> PCI ID: [14c3:0717], driver mt7925e
> Platform: AMD "Strix Halo" (Ryzen AI Max) mini-PC
> linux-firmware: 20260319.git217ca6e4
> 
> Symptom (kernel 7.2.0-rc2, 2026-07-06)
> --------------------------------------
>   mt7925e 0000:c3:00.0: enabling device (0000 -> 0002)
>   mt7925e 0000:c3:00.0: ASIC revision: 79250000
>   mt7925e 0000:c3:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260106153007a
>   mt7925e 0000:c3:00.0: WM Firmware Version: ____000000, Build Time:
> 20260106153120
>   mt7925e 0000:c3:00.0: Invalid MAC address, using random address
> 12:1f:34:c6:57:04
>   mt7925e 0000:c3:00.0 wlp195s0: renamed from wlan0
> 
> The driver then brings the interface up with the random MAC 12:1f:34:c6:57:04.
> 
> Last known good (kernel 7.0.0-22, 2026-07-05, same machine, no MAC override)
> ----------------------------------------------------------------------------
>   mt7925e 0000:c3:00.0: ASIC revision: 79250000
>   mt7925e 0000:c3:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260106153007a
>   mt7925e 0000:c3:00.0: WM Firmware Version: ____000000, Build Time:
> 20260106153120
>   ...
>   wlp195s0: authenticate with <ap> (local address=ac:f2:3c:35:31:15)
> 
> i.e. the real MAC ac:f2:3c:35:31:15 was read straight off the adapter. Note
> the firmware init lines (ASIC revision, HW/SW Version, WM Firmware Version,
> build times) are byte-identical between the good and bad boots -- only the
> kernel differs, and only the MAC read fails. This rules out a firmware or
> bad-NVRAM cause: the same silicon read the MAC correctly ~24h earlier.
> 
> Regression range
> ----------------
> Confirmed good on: 7.0.0, 7.0.0-22, 7.0.0-27, 7.1.0-rc7 (dozens of boots,
> journal-verified, no "Invalid MAC address" line on any of them).
> First and only bad boot: 7.2.0-rc2.
> 
> So the regression landed between 7.1-rc7 and 7.2-rc2. I have not bisected to
> the exact commit yet, but I can -- the machine builds kernels quickly -- if a
> bisect would help pin it down.
> 
> Not reboot-type dependent: on the good kernels (7.0.0-22 / 7.0.0-27) the
> correct MAC was read reliably across both warm/clean reboots and cold/hard
> power cycles. The failure does not correlate with reboot type or chip power
> state -- it correlates only with the kernel version (7.2-rc2).
> 
> Impact
> ------
> The substituted MAC is random per boot, changing the adapter's L2 identity.
> This breaks router-side DHCP reservations / fixed-IP allocations keyed on MAC:
> the host stops receiving its pinned address and lands on an arbitrary lease.
> Any MT7925 user relying on MAC-based address pinning is affected. Current
> workaround here is forcing the real MAC via NetworkManager cloned-mac-address.
> 
> #regzbot introduced: v7.1..v7.2-rc2
> 
> 
> 
> Thanks,
> 
> 
> Brent Paine, AWS, CCNP
> 
> git bkpaine1
> Medium bkpaine1
> 
> 
> On Mon, Jul 6, 2026 at 8:12 AM B X <brent@msbs.com> wrote:
>>
>> Hi,
>>
>> Reporting a regression in the mt7925e driver: on Linux 7.2.0-rc2 the adapter
>> fails to read its stored (EEPROM/efuse) MAC address and substitutes a random
>> one. The same hardware read its real MAC correctly on every earlier kernel,
>> including the immediately-preceding boot one day earlier on 7.0.0-22.
>>
>> Verified with Claude Code when my ATT fiber kept failing to pin IP on my Halo Strix
>>
>> Hardware
>> --------
>> MediaTek MT7925 (RZ717) Wi-Fi 7 160MHz
>> PCI ID: [14c3:0717], driver mt7925e
>> Platform: AMD "Strix Halo" (Ryzen AI Max) mini-PC
>> linux-firmware: 20260319.git217ca6e4
>>
>> Symptom (kernel 7.2.0-rc2, 2026-07-06)
>> --------------------------------------
>>   mt7925e 0000:c3:00.0: enabling device (0000 -> 0002)
>>   mt7925e 0000:c3:00.0: ASIC revision: 79250000
>>   mt7925e 0000:c3:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260106153007a
>>   mt7925e 0000:c3:00.0: WM Firmware Version: ____000000, Build Time: 20260106153120
>>   mt7925e 0000:c3:00.0: Invalid MAC address, using random address 12:1f:34:c6:57:04
>>   mt7925e 0000:c3:00.0 wlp195s0: renamed from wlan0
>>
>> The driver then brings the interface up with the random MAC 12:1f:34:c6:57:04.
>>
>> Last known good (kernel 7.0.0-22, 2026-07-05, same machine, no MAC override)
>> ----------------------------------------------------------------------------
>>   mt7925e 0000:c3:00.0: ASIC revision: 79250000
>>   mt7925e 0000:c3:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260106153007a
>>   mt7925e 0000:c3:00.0: WM Firmware Version: ____000000, Build Time: 20260106153120
>>   ...
>>   wlp195s0: authenticate with <ap> (local address=ac:f2:3c:35:31:15)
>>
>> i.e. the real MAC ac:f2:3c:35:31:15 was read straight off the adapter. Note
>> the firmware init lines (ASIC revision, HW/SW Version, WM Firmware Version,
>> build times) are byte-identical between the good and bad boots -- only the
>> kernel differs, and only the MAC read fails. This rules out a firmware or
>> bad-NVRAM cause: the same silicon read the MAC correctly ~24h earlier.
>>
>> Regression range
>> ----------------
>> Confirmed good on: 7.0.0, 7.0.0-22, 7.0.0-27, 7.1.0-rc7 (dozens of boots,
>> journal-verified, no "Invalid MAC address" line on any of them).
>> First and only bad boot: 7.2.0-rc2.
>>
>> So the regression landed between 7.1-rc7 and 7.2-rc2. I have not bisected to
>> the exact commit yet, but I can -- the machine builds kernels quickly -- if a
>> bisect would help pin it down.
>>
>> Not reboot-type dependent: on the good kernels (7.0.0-22 / 7.0.0-27) the
>> correct MAC was read reliably across both warm/clean reboots and cold/hard
>> power cycles. The failure does not correlate with reboot type or chip power
>> state -- it correlates only with the kernel version (7.2-rc2).
>>
>> Impact
>> ------
>> The substituted MAC is random per boot, changing the adapter's L2 identity.
>> This breaks router-side DHCP reservations / fixed-IP allocations keyed on MAC:
>> the host stops receiving its pinned address and lands on an arbitrary lease.
>> Any MT7925 user relying on MAC-based address pinning is affected. Current
>> workaround here is forcing the real MAC via NetworkManager cloned-mac-address.
>>
>> #regzbot introduced: v7.1..v7.2-rc2
>>
>>
>>
>> Thanks,
>>
>>
>> Brent Paine, AWS, CCNP
>>
>> git bkpaine1
>> Medium bkpaine1

