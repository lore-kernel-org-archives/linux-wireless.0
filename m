Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC521E98E3
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786773115; cv=none; b=p4WFei5DtpZmdoDbjKj1zWYT8YZPL/xjn2DLZZnL2elb79V0gpKSxUaOuo+APvMUbMlwfoE9BXPnYWL2S38Bc8Qk0KPMHquDkyribvc/ndCIMDlZvN1RrLw99Iqu4V2ptoUXwLT3tnxUV6hpdTlWRIlzeBdo4tjXsQR0qIvKsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786773115; c=relaxed/simple;
	bh=A9irWmcIhI6ALbZTSoKs9i10AfbHLtjNjLzA24zxlsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttoeoyvb2ocFmLGrGoHd/tngZXCMHkNIbYjBsdP2onXTEHLa3XCXN1YQ/s3HQw7hc77imdSN2Owc7jD/WxBXoTc68Si+p6L1JvVhRMhIABifJZAvbasSIFOnRLwB3IVRctAGCGChRFKIPkIybK4PqLKgU33Qt40vtVShA2uxUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=TkCGrLGw; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="TkCGrLGw"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4hMSs94Dhtz4F1F;
	Sat, 15 Aug 2026 07:51:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1786773101;
	bh=A9irWmcIhI6ALbZTSoKs9i10AfbHLtjNjLzA24zxlsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TkCGrLGwxJiJb8Z2t4HnYnwQX9nIr4TXtWdmVtH/Z0eKW+x0f8WvMJ7HdeqVlLKQA
	 vEhUILSG8pLiup/MJv+qwoxM5VSJPo4rtBTpJbIwAhyA/t5GzrgZUVBFgMeiw+PmvX
	 2CNElSRGWcqZ1T66iKvEKp82uWAmsVi36Pbm5qqfIFuS5rLAZvuyGx5vWuUIKDeeWg
	 qX09sg4mfFCOlcj1gOjBhIYopZKiDq4tCoqjW1wDOq47pu06AElWoctvxeL9Lz6tRZ
	 d4yfYErbY/7UHwi0gDxRIyff9+xWjhVmr4/3PRRKS7o8R4qUEjAwjRDJV03unExS25
	 Yh9lkIfogJ+uA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4hMSs93WmWz4F01;
	Sat, 15 Aug 2026 07:51:41 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hMSs84phvz8svk;
	Sat, 15 Aug 2026 07:51:40 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id A1C9E5F98A;
	Sat, 15 Aug 2026 07:51:35 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <d8e493ef-90ff-4364-ad4e-1709fae97005@leemhuis.info>
Date: Sat, 15 Aug 2026 07:51:35 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
To: Jonas Hort <jonas.hort@posteo.de>, regressions@lists.linux.dev
Cc: linux-wireless@vger.kernel.org, lorenzo.bianconi83@gmail.com,
 Devin Wittmayer <lucid_duck@justthetip.ca>
References: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <178677309598.4118759.4557917680638760400@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: A1C9E5F98A
X-NC-CID: vcpBS7klDK/RW6cfGfjwxixU2QpwtVL0KzU15eWjVMznh4QGUso=

On 8/14/26 16:04, Jonas Hort wrote:
> Filed as: https://bugzilla.kernel.org/show_bug.cgi?id=221884
> 
> Summary: WiFi 7 MLO (5GHz+6GHz) on MT7925 silently stops passing traffic
> after a few minutes, while the driver continues to report a fully
> healthy link. Root cause appears to be a stalled WFDMA0 TX hardware
> queue. Reproduced on both linux 7.1.8 (stable) and 7.2.0-rc7 (mainline
> pre-release), not fixed as of rc7. Disabling the 6GHz radio on the
> access point eliminates the freeze entirely in my testing.

Not my area of expertise, but there was one patch was reverted on
Thursday that is somewhat related
(https://git.kernel.org/torvalds/c/3aa1dcaa4f6f5ae08936491e08bd456f331f2d40
), but that was more about shutdown/module unload aiui and likely
something else.

But there were other reports that sounds somewhat related (but careful,
I might send you on the wrong track here; CCing Devin, who wrote two of
the following messages):

https://lore.kernel.org/linux-wireless/20260629083543.153564-1-jb.tsai@mediatek.com/
https://lore.kernel.org/linux-wireless/20260804185118.19705-1-lucid_duck@justthetip.ca/
https://lore.kernel.org/all/20260812155811.10950-1-lucid_duck@justthetip.ca/

Ciao, Thorsten
> This is a regression: reported by multiple users on the CachyOS forum
> as broken starting with the 7.1.x kernel line; earlier kernels
> (6.18.x longterm) are reported to work fine. I have not yet performed
> a commit-level bisection but can if guided on the best approach given
> the AP-side 6GHz dependency.
> 
> --- Detailed description ---
> 
> Symptom:
> When connected via MLO (Multi-Link Operation, EHT/WiFi 7) with two
> active links - one on 5GHz and one on 6GHz - network traffic silently
> stops after a few minutes of normal use (web browsing, etc). The
> connection continues to show as healthy:
> 
> - `iw link` / `iw station dump` report the connection as associated,
>   authenticated, good signal (-60 to -65 dBm), high negotiated
>   bitrate (800-1700 Mbit/s), 0 tx retries, 0 tx failed.
> - Nothing is logged to dmesg/journalctl at the time of the freeze.
> - Ping to the gateway shows 100% packet loss for several minutes,
>   until the connection eventually recovers on its own.
> 
> I built a small watchdog script (ping-based failure detection + live
> kernel log monitoring) to catch the freeze automatically and sample
> mt76 debugfs state repeatedly across the event. This revealed the
> actual mechanism:
> 
> `/sys/kernel/debug/ieee80211/phy0/mt76/xmit-queues` shows the WFDMA0
> hardware TX queue's `tail` pointer completely frozen while `head`
> keeps advancing - i.e. packets keep getting enqueued but the firmware
> stops draining the queue. RX stops in the same instant (rx byte/packet
> counters in `iw station dump` freeze completely). No tx retries or tx
> failures are ever reported by the driver, so it does not appear to
> notice the stall itself.
> 
> Example from one incident (kernel 7.2.0-rc7):
>   t+1s:  WFDMA0: queued=130 head=390 tail=260   rx bytes=184791894
>   t+9s:  WFDMA0: queued=148 head=408 tail=260   rx bytes=184791894 (unchanged)
> 
> `tail` never advances during the whole stall window while `head`
> keeps growing - the queue is being filled but never drained.
> 
> Reproduced this exact signature four times total (twice on 7.1.8-1,
> twice on 7.2.0-rc7-1), always with MLO 5GHz+6GHz active, always
> within 3-5 minutes of normal use.
> 
> 6GHz correlation:
> My MLO links are 5GHz (5180 MHz) + 6GHz (varies, e.g. 6135 MHz).
> Fully disabling the 6GHz radio on the access point (FritzBox 5690
> Pro, FRITZ!OS 8.25 - not just client-side band restriction via
> NetworkManager, which does not reliably suppress the second MLO
> link) results in 30+ minutes of clean operation with no freeze.
> Re-enabling 6GHz reproduces the freeze again within minutes.
> 
> Regression info:
> Multiple users on the CachyOS forum report this started with the
> 7.1.x kernel line; the previous longterm kernel (6.18.x) is reported
> to work fine by another user with different affected hardware
> (different AP). I have not personally tested 6.18.x myself, and have
> not performed a commit-level bisection yet - happy to do so if
> pointed toward the most likely area of the driver, given the AP-side
> 6GHz dependency makes a fully automated bisection awkward.
> 
> Steps to reproduce:
> 1. Connect to an AP advertising WiFi 7 MLO with 5GHz+6GHz link
>    options, so the client negotiates both links.
> 2. Use the connection normally (web browsing is sufficient).
> 3. Within roughly 3-5 minutes, new connections start hanging;
>    existing traffic stops.
> 4. Check `iw link` - link still reports as connected/healthy.
> 5. Check `/sys/kernel/debug/ieee80211/phy*/mt76/xmit-queues` -
>    WFDMA0 tail pointer frozen while head continues to advance.
> 
> Environment:
> - Kernel: linux-cachyos 7.1.8-1 and linux-cachyos-rc 7.2.0-rc7-1
>   (CachyOS, near-vanilla Arch-based build)
> - cat /proc/version:
>   Linux version 7.2.0-rc7-1-cachyos-rc (linux-cachyos-rc@cachyos)
>   (clang version 22.1.8, LLD 22.1.8) #1 SMP PREEMPT_DYNAMIC
>   Mon, 10 Aug 2026 20:51:00 +0000
> - Distribution: CachyOS
> - Architecture: x86_64
> - Kernel tainted: no (/proc/sys/kernel/tainted = 0)
> - WiFi hardware: MediaTek MT7925 (mt7925e driver, mt76 core),
>   WM Firmware Build 20260605184805, ASIC revision 79250000
> - Access point: AVM FritzBox 5690 Pro, FRITZ!OS 8.25
> 
> Related community discussion:
> https://discuss.cachyos.org/t/mt7925-wifi-7-mlo-breaks-connectivity-on-7-1-x-mt76-regression/31972
> (I am the thread starter; several other users report matching
> symptoms with different hardware/APs)
> 
> Possibly related (different symptom, same 6GHz/MT7925 area, worth
> checking for a common root cause):
> Bug 221627 - MT7925E - System locks up with flashing caps lock
> (comment 1 there: "caused by switching between AP's with the same
> 6GHz wifi name")
> 
> Attachments (will add to this ticket):
> - Full incident logs for all four reproductions (dmesg + journalctl
>   + mt76 debugfs time series across each freeze)
> - iw station dump / iw link output during freeze
> - Kernel .config
> 
> Note: checked bug 220424 (mlo_sta_cmd/sta_cmd regression) before filing -
> different symptom (persistent near-zero throughput vs. our intermittent
> full stall with healthy link stats) and different root cause (broadcast
> wtbl hdr_trans_tlv handling). That fix landed in 6.16.6/6.17-rc5, well
> before the kernel versions tested here, so it is not the cause of this
> issue.
> 
> 

