Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AFF374186
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547626; cv=none; b=ceEbBTFyvt6ESDyyRQQ3fk4dXgSNTEZkddyjQHORPadVcHY4TXKyiHEknUxD0VNUNyH64HDW/bEm984vzQk7g9KnJpnwMXmerXLwNBGD3M9lqO4F1IF0BzvK8S/pvLMCK8ptB15i9lv6OuxfYjH4aVPUtChJN7N+IziLMgZeshQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547626; c=relaxed/simple;
	bh=XgnWoqC9vlOxYt8TkrbhJL8JlSG616CE7CLNhY/UYes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzeJ8XQFtVJJKK+AnoZJeGSHhaDl/dJMRCJGirmIA0JDLW54Rd6nAiAELvpKocRfk8izjiFu1+QwRNaxm7V+WnhYDPNDHXk86nJmemvd/wzW+nWcoJHPSRHrABh9+wrXmQ9OxRtBRcygV4Nt/OfwPOuNSzjrZk5hBkJ/HpbfWP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=YW3Emin0; arc=none smtp.client-ip=188.68.61.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="YW3Emin0"
Received: from mors-relay-8405.netcup.net (localhost [127.0.0.1])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4hSz6v0vndz74QG;
	Mon, 24 Aug 2026 06:52:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1787547159;
	bh=XgnWoqC9vlOxYt8TkrbhJL8JlSG616CE7CLNhY/UYes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YW3Emin0qJ/aLYlnYJMZSXz9o+zrUVW1zMe8ZM2/5uGEJcngC96KDcnNauhL57grC
	 iu9ix0QcHFukb7R8wn3gSBLFlvOUvddFfCT5bl/4dwwZgAdnOpBMckaY4JpFpYgE3V
	 2NbIEqIxre05L//8gVKmsSCGfnXpAM8hgHTk4iv9pL0BXcu6Iy3t5st7nkibkXj8zj
	 uoZmBCmpfl8TxHLSBirNLsLI5si1iG0xhgpQ9nxZYfNABUdYR6yMkTG6qyuYORLQ96
	 LMPT1olozhUpCeIN7i43bzlChQv1ix4V8f26eQJAciPXypqK4PWL3Gbgy6HhXF2AGk
	 Ulv6y+eXcVWuQ==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4hSz6v0B71z74Py;
	Mon, 24 Aug 2026 06:52:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4hSz6s1kFMz8tdN;
	Mon, 24 Aug 2026 06:52:37 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 8DE805FA13;
	Mon, 24 Aug 2026 06:52:36 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info>
Date: Mon, 24 Aug 2026 06:52:35 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
To: Sean Wang <sean.wang@mediatek.com>
Cc: regressions@lists.linux.dev, linux-wireless@vger.kernel.org,
 Devin Wittmayer <lucid_duck@justthetip.ca>, Felix Fietkau <nbd@nbd.name>,
 Jonas Hort <jonas.hort@posteo.de>, lorenzo.bianconi83@gmail.com,
 linux-mediatek@lists.infradead.org
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de>
 <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de>
 <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <178754715696.1770844.12341715983871143000@mxe9fb.netcup.net>
X-NC-CID: jZRQ2YBXAlL/TetqCSSSWEo4HFDmv75leDsS4FbASSy4KieyXQs=

On 8/23/26 22:54, Jonas Hort wrote:
> Bisect is done. First bad commit:
>
> ff643b81bc38eaff6c0ab783a62e4ba9e10d2476
> wifi: mt76: mt7925: pass mlink and mconf to sta_mld_tlv()
> Sean Wang, 2026-03-06
> https://patch.msgid.link/20260306232238.2039675-4-sean.wang@kernel.org

Then let's add Sean to the list of recipients. :-D

Sean, FWIW, this thread starts here:

https://lore.kernel.org/all/066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de/t/#u

To quote the summary: "WiFi 7 MLO (5GHz+6GHz) on MT7925 silently stops
passing traffic after a few minutes, while the driver continues to
report a fully healthy link. Root cause appears to be a stalled WFDMA0
TX hardware queue."

Ciao, Thorsten
> Bisected on vanilla, path-restricted to
> drivers/net/wireless/mediatek/mt76/mt7925/, using v7.0 as good and
> v7.1 as bad. Each step was booted and tested with MLO active
> (5GHz+6GHz, FritzBox 5690 Pro), and every "bad" verdict was confirmed
> by the WFDMA0 signature (tail frozen while head keeps advancing),
> not just by the connection dropping.
> 
>   ea757740dd87  pass WCID indices to bss_basic_tlv()      good (45 min
> clean)
>   ff643b81bc38  pass mlink and mconf to sta_mld_tlv()     bad (freeze
> after ~4 min)
>   dc019e3294c7  pass mlink to mcu_sta_update()            bad (freeze
> after ~3 min)
>   9e4d518a4707  pass mlink to mac_link_sta_remove()       bad (freeze
> after ~4 min)
>   cf9db836b1e0  pass mlink to set_link_key()              bad (freeze
> after ~4 min)
> 
> git bisect log and the incident logs for each step are available if
> useful - happy to attach them to the bugzilla ticket or send them
> here.
> 
> Let me know if you want anything else tested.
> 
> Thanks,
> Jonas
> 
> Am 22.08.26 um 22:18 schrieb Jonas Hort:
>> Quick update: v7.0 vanilla has been running clean for over 2 hours now
>> with MLO active (5GHz+6GHz, same FritzBox 5690 Pro), no freeze at all.
>>
>> Am 19.08.26 um 11:03 schrieb Jonas Hort:
>>> Thanks for the detailed breakdown.
>>>
>>> I'll build v7.0 vanilla and test it, as suggested. Fair warning
>>> though: I'm on vacation this week, so I'll pick this up next week.
>>> I've also never compiled a kernel before, so it'll likely take me a
>>> bit of trial and error the first time around - please bear with me
>>> if it takes a little longer than expected.
>>>
>>> Will report back once I have results.
>>>
>>> Thanks again,
>>> Jonas
>>>
>>> 19.08.2026 03:18:34 Devin Wittmayer <lucid_duck@justthetip.ca>:
>>>
>>>> Thank you very much, that answers both things.
>>>>
>>>> The ROC tracing is the more useful of the two even though it came back
>>>> negative. Two of the three freezes have no ROC activity in them at
>>>> all, so a
>>>> link switch that never finished cannot be what starts this. The
>>>> middle one
>>>> does have rocabort, mloroc and rocwork in it, but one out of three
>>>> makes
>>>> that look like the exception rather than the pattern. So the area I
>>>> sent you
>>>> looking at is out, and that is worth knowing before you spend nights on
>>>> builds.
>>>>
>>>> One other thing worth saying first. There is a five patch mt76
>>>> series on the
>>>> list at the moment and two of the patches look like they were
>>>> written for
>>>> exactly this bug. I do not think they were, and it is your own
>>>> numbers that
>>>> show it. The failure 4/5 fixes stops mt76_txq_schedule_list from
>>>> servicing
>>>> the queue, and the one 5/5 fixes stops mt76_txq_send_burst once the
>>>> non-AQL
>>>> count reaches its cap. Both of those keep frames from ever reaching the
>>>> hardware, so if either were your problem head would be sitting still
>>>> alongside tail. Yours does the opposite. Head climbs 390 to 408
>>>> while tail
>>>> stays at 260, so the frames are getting into the ring and nothing is
>>>> finishing them, which is the far end of the same path. 2/5 is a use
>>>> after
>>>> free when an interface goes away, so it does not fit either. I would
>>>> not
>>>> expect that series to change what you see.
>>>>
>>>> On the bisect I would build v7.0 next. There are 32 mt7925 commits
>>>> between
>>>> 7.0 and 7.1 and 19 of them are one run of work from Sean Wang,
>>>> reworking how
>>>> the driver tracks the per link mlink and WCID for an MLO station.
>>>> That is
>>>> the kind of change that fits a bug only showing up with two links
>>>> up. If
>>>> v7.0 comes back clean, that series is where I would look. If v7.0 is
>>>> already
>>>> broken then it is off the hook and 6.19 becomes the next split. The
>>>> mt76
>>>> core and mac80211 both moved in the same window, so mt7925 is where
>>>> I would
>>>> look first rather than the only place worth looking.
>>>>
>>>> Devin
>>>>
>>>> Am 17.08.26 um 23:34 schrieb Jonas Hort:
>>>>
>>>>> Quick follow-up: managed to confirm 6.18 as a clean baseline on my
>>>>> own hardware now (not just secondhand from others in the forum
>>>>> thread) - running Linux 6.18.42-1-cachyos-lts with MLO active
>>>>> (5GHz+6GHz, same FritzBox 5690 Pro) for 3 hours straight, no freeze
>>>>> at all.
>>>> Am 17.08.26 um 16:25 schrieb Jonas Hort:
>>>>
>>>>> One correction to how I described this earlier: the connection does
>>>>> NOT reliably self-heal on its own. I have manually intervened every
>>>>> single time to restore connectivity [...]
>>>>>
>>>>> Update on the ROC tracing: three real freezes captured now with the
>>>>> kprobes active (all confirmed via the WFDMA0 tail-frozen signature).
>>>>>
>>>>> - Freeze #1 (15:37): no ROC activity in the trace.
>>>>> - Freeze #2 (15:43): [...] The trace shows several ROC events
>>>>>    (rocabort, mloroc, rocwork) clustered together.
>>>>> - Freeze #3 (16:15): no ROC activity again.
>>>>>
>>>>> Uploaded all three logs to the bugzilla ticket if useful:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=221884

