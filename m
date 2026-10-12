Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240D743E9D2
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793158; cv=none; b=rIH0iKrDCNqE/9OAKWJBuidsfhbdPvZ+RKuLPVeueKnc6vmv76gKashVitaUSvTvvFvXvdUC3nnvPATdngU24K846Okg5uACPnT1innY2SW3/epRwcEJvXd1OwD6Iba1VqZ2snITjQ/e0mxPg6CgQRhxZ7tHDDiN7ztCRgmkBUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793158; c=relaxed/simple;
	bh=HGo+Bxfg52n1iqks+M2fQnvYdd9MTMeoXf6BUFuIImg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tq32ZkcYmE2A7Z9/SMXubHLdT9JIBjnCKHcyYWhgKGQYZtwpBWBshukA3SWt/fjYg0VGdFy1j1hAfchKp69Q3lkvQxYagPLTVo38ynXZmvyCfiYFKNQN8o3cesMyK47T8Kzg4PKnu1UoeuxZsDggzT8RySV7QiqARG7qKJCb2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=hkMqLF70; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="hkMqLF70"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4j39Nd21K8z41Tq;
	Mon, 12 Oct 2026 10:19:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1791793153;
	bh=HGo+Bxfg52n1iqks+M2fQnvYdd9MTMeoXf6BUFuIImg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hkMqLF70mLdBzBhIbcnbuToVCt2F1nlMOOI8hSImURCfPLaUKUVqE6mi5kZgWtqGA
	 ThukZvYFRUckCDmPRi6UF/lAVSBa5ENRwcEIDlsjFPCGyIUFgHcFvWaUXQFQBD64vo
	 WjarXn94tAOwPB761JcCFdsxxrqnhhnEqjAWngaj/y3bllGqEdj5NH12Fe4HE0zA7P
	 Ll83ixQYJb4Ru0NqyjbUynfXBIYg78+APplikOvMMpGw1lDqx7oNpYxzeyqmmIfOlL
	 ic3VzOyxDoTBjYy81MaTPvtsCHLg3BPASqnWAt46PdW/0bfCOanf8dXiNw+LKzqLOc
	 2HaOTEPuY5XpQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4j39Nd1Gc6z41TD;
	Mon, 12 Oct 2026 10:19:13 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4j39Nc3y2Bz8sgW;
	Mon, 12 Oct 2026 10:19:12 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 9329F5FA5F;
	Mon, 12 Oct 2026 10:19:07 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <7aeed66a-1d47-4a72-8fe0-b53b1fbd2238@leemhuis.info>
Date: Mon, 12 Oct 2026 10:19:07 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: [REGRESSION] mt7921e: ~20% lower throughput on first
 association after boot (7.1/7.2), reconnect restores it
To: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0JHQtdGA0LjQtNC30LU=?=
 <game.advencher229@gmail.com>, linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, regressions@lists.linux.dev
References: 
 <CAEhAYcrrRyZvNU4i+jznPW4jxS1F_s5iH6AMZE4_mVgLbtAhXQ@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAEhAYcrrRyZvNU4i+jznPW4jxS1F_s5iH6AMZE4_mVgLbtAhXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179179314798.2742533.8167460197205619580@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 9329F5FA5F
X-NC-CID: g5AckDi4N8G9bPrQeSy4cwFNZCYJNPyiACBDcBe+5np3kHZwkzY=

On 10/6/26 19:17, Георгий Беридзе wrote:
> 
> On my laptop the MT7921 (PCIe, mt7921e) gets about 20% lower TCP
> throughput on the first association after boot with 7.1.10 and 7.2.8.
> Simply re-associating (NetworkManager "connection up" on the same
> profile, nothing else changed) immediately restores full speed.
> 6.18.55 is fast right from boot.

Thanks for your report. Nobody replied yet. With a bit of luck somebody
might still do that with an idea what's wrong. But if not I guess you
will have to run a git bisection to locate the change that causes this.
Remember to first check if latest 7.3-rc is still affected (and give
that 7.3 is close it might be even worth trying -next, but YMMV).

Ciao, Thorsten
> Hardware / software
> - Lenovo IdeaPad 5 Pro 16ACH6 (82L5), Ryzen 7 5800H
> - 03:00.0 MEDIATEK MT7921 [14c3:7961], subsystem 17aa:e0bc,
>   ASIC revision 79610010
> - WM firmware ____010000, build 20260224110949 (linux-firmware
>   20260916; the MT7961 files are identical to 20260622)
> - Arch Linux kernels: 6.18.55-1-lts (good), 7.1.10-arch1-1 (bad),
>   7.2.8-arch1-2 (bad)
> - NetworkManager 1.58.1, wpa_supplicant 2.12, WPA3-SAE, CCMP
> - AP: TP-Link 802.11ac router (no HE), 5 GHz channel 48, 80 MHz
> - iw reports the same rates in both states (VHT-MCS 9, NSS 2, 80 MHz,
>   SGI, 866.7 Mbit/s rx/tx), signal -37..-52 dBm
> 
> Measurement
> 4 and 8 parallel HTTP downloads and 4 parallel uploads (curl, 8 s
> each) to an Ookla speedtest server 3-7 ms away (ping min/avg),
> bound directly to wlan0. The ISP plan tops out at ~530 Mbit/s,
> which is also what a phone on the same AP gets, so "fast" below is
> capped by the uplink.
> 
> Results in Mbit/s (ranges over 2-3 rounds)
> 
>   kernel   state                                  down     up
>   6.18.55  right after boot                       525-531  510-538
>   7.2.8    first association, ~5 h uptime         402-431  470-483
>   7.2.8    first association, fresh boot          340-431  368-430
>   7.2.8    first association, fresh boot          426-443  409-472
>   7.2.8     -> same boot, reconnect only          520-531  525-538
>   7.1.10   first association, fresh boot          359-426  421-496
>   7.1.10    -> regdb installed, RU, reconnect     519-531  521-537
>   7.1.10    -> regdomain back to 00, reconnect    522-530  530-539
>   7.1.10    -> modprobe -r + modprobe mt7921e     516-526  536-539
>               (plus one outlier at 388 down)
> 
> The slow state persists for the whole session: on one 7.2.8 boot the
> journal shows a single association at boot and it was still slow
> about 5 hours later. The fast state after a reconnect has so far been
> observed for about 10 minutes without another re-association.
> 
> Ruled out
> - power_save off (iw): no meaningful change (+~3%)
> - PCIe ASPM: disabling L1.1/L1.2 and then L1 for 03:00.0 via sysfs
>   on 7.1.10: no change
> - Regulatory: slow both with regulatory.db missing (world regdomain
>   00) and with wireless-regdb installed (driver sets RU before the
>   association). After a reconnect it is fast with either 00 or RU.
> - Firmware: the same files on all kernels
> - Association parameters are the same on the slow and the fast
>   association (SAE, PTK=CCMP GTK=CCMP)
> 
> Not tested yet: Bluetooth coexistence (the combo chip's BT is powered
> with no devices connected; hci0 finishes setup ~4 s before the first
> Wi-Fi association) and suspend/resume. I have not bisected yet. I can
> test patches, enable debug options or try more kernels if that helps;
> I also have ethtool -S and station dumps from both states.
> 
> #regzbot introduced: v6.18..v7.1
> 
> Thanks,
> Georgy B.

