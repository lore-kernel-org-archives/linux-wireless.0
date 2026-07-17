Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F076285072;
	Fri, 17 Jul 2026 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784328517; cv=none; b=MTnv/il80eXcgrYds/k0s1Qwk0waftqZ7BWH7Cs9wGw2yKgo0/gFCsfJfm+AB7cB1pMp4kX+mHGyPw1/PczBUAgMNOSnX/Zi9D9DgXf6QIv5Qi38dbrZzWgkTXtbz8LI0tkAQRSN4ahK1TfayE7NwyH/LXSaJ+1scMoBb5pJaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784328517; c=relaxed/simple;
	bh=iNZz33SPNtqeO4sw3tXln8CKF04wkLp0SkIy8XRzAME=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=poERY2k1RXO18Wu3TNgJ/q+lkyavkv+uN8efrLjQGcf0q1NepWzvVFLx/YncIBBNk/jocPT2E/CFhtKh7aI/oEDjgl2QhR4ASBUJBgTq1SAwanlEi9YeDxNdOwd7rcKp3AO5iGnXRIasUKYyHTSCAkQlCskBVu4EBvLVFvf27Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=breiteneder.me; spf=pass smtp.mailfrom=breiteneder.me; dkim=pass (2048-bit key) header.d=breiteneder.me header.i=@breiteneder.me header.b=RZDGg7kv; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=breiteneder.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breiteneder.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=breiteneder.me header.i=@breiteneder.me header.b="RZDGg7kv"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4h24nZ09WXz8G2j;
	Sat, 18 Jul 2026 00:48:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=breiteneder.me;
	s=key2; t=1784328498;
	bh=iNZz33SPNtqeO4sw3tXln8CKF04wkLp0SkIy8XRzAME=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=RZDGg7kvCyGRyiIIqkzL5lT8PrRldIJkeKFXFpIMx8sp270ERR4Mukbttb70LbCdR
	 PHmJvIBxk3Pvr+7BkgZ2S2l/8EEvR0Dd0QbozC9+/ae+OvhKAcFW31nmPwhefPAXp2
	 ab1ys2gzvqYh9SK1ocr65nmkSQq/LjruuMJqTUNrwbwrXlsIeg88lyYcEhP47LaIrR
	 eY5VjT7Gp60FN6IXvbr7PPgpWJ3mc25lR+Jbr2X2lloxdc6u+mIzQEqp615TwtqVYM
	 XBSyMSafof5sDiew7HHAqi0abQpYc6bbMplHX+7camQ87pCyfsq2usG6nY3q3lgm1L
	 fMMScS7kowqlw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4h24nY6ZM1z4y1T;
	Sat, 18 Jul 2026 00:48:17 +0200 (CEST)
Received: from mxe81b.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4h24nY3zRXz8sWT;
	Sat, 18 Jul 2026 00:48:17 +0200 (CEST)
Received: from [192.168.178.143] (unknown [185.151.22.188])
	by mxe81b.netcup.net (Postfix) with ESMTPSA id D7B7DC0087;
	Sat, 18 Jul 2026 00:48:16 +0200 (CEST)
Authentication-Results: mxe81b;
        spf=pass (sender IP is 185.151.22.188) smtp.mailfrom=armin@breiteneder.me smtp.helo=[192.168.178.143]
Received-SPF: pass (mxe81b: connection is authenticated)
Message-ID: <0f6d921f-1026-4d9a-bad5-7e5b9485c4a2@breiteneder.me>
Date: Sat, 18 Jul 2026 00:48:16 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [regression] rtw89_8852be: silent RX stalls since v7.1; reverting
 bda294ed0ed0 appears to fix it
From: Armin Breiteneder <armin@breiteneder.me>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: o-Hao Huang <phhuang@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <7de74e5c-3ad4-4264-a250-fcb1e66675be@breiteneder.me>
Content-Language: de-AT
In-Reply-To: <7de74e5c-3ad4-4264-a250-fcb1e66675be@breiteneder.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <178432849709.1077806.9489022866371157896@mxe81b.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: D7B7DC0087
X-NC-CID: kRrkI88LYGuQPe3QllqY7qI5l/UzV1B2ZxBkaE6Yg95F/eHj

Hi,

I am hitting a reproducible WiFi regression with rtw89_8852be 
(RTL8852BE, 10ec:b852, CV:1 RFE:1, firmware 0.29.29.18) on Fedora 44.

Good: 7.0.14-201.fc44
Bad:  7.1.3-200.fc44, and v7.1 vanilla

Reverting bda294ed0ed0 ("wifi: rtw89: Drop malformed AMPDU frames with 
abnormal PN") on top of v7.1 appears to fix it -- the stalls are gone.

Symptom: every few minutes the RX data path stalls silently for 1-7 
minutes at a time. The radio link stays perfectly healthy -- still 
associated, signal unchanged (~-62 dBm), "tx failed" and "tx retries" 
both 0 (the AP ACKs every frame we send), "beacon loss" 0 -- and the 
station's rx_packets counter keeps climbing at ~23 frames/s. Yet almost 
nothing is delivered to the network stack. The kernel logs nothing at 
all. Then it recovers on its own, without re-association, and the whole 
backlog is delivered in one burst.

Quantified over one 54-second stall (mac80211 station counter vs. the 
napi_gro_receive tracepoint):
   frames received and counted from the AP : ~1230
   frames delivered to the network stack   :  ~211
   frames withheld                         : ~1000
   delivered in one interval on recovery   : +5070

Everything that does get through during the stall is broadcast/multicast 
only (ARP, IPv6 multicast, vendor ethertypes) -- exactly the traffic 
that bypasses Block-Ack reordering.

That fits the suspected commit: dropping a frame inside an A-MPDU leaves 
a hole in the sequence numbers, so the RX reorder buffer waits for 
something that never arrives, everything behind it piles up, and it is 
only released once a timeout fires. I have not verified this in the code 
beyond reading the commit, so please treat the mechanism as a hypothesis 
-- the revert result is the solid part.

The AP is a FRITZ!Box 4040 on channel 36 (5180 MHz, VHT80), non-DFS.

Already ruled out:
- Powersave: disabled (NetworkManager wifi.powersave=2, confirmed via iw).
- ASPM: disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y 
disable_ps_mode=y
   all set and confirmed active. The stall still occurs -- note this is the
   workaround that reportedly fixes the CachyOS case below; it does not 
help here.
- Signal / range / DFS: signal constant across the stall, channel is 
non-DFS.
- TX path: txf=0 and txr=0 throughout.
- Stable patches: "git log v7.1..v7.1.3 -- net/mac80211/ 
drivers/net/wireless/
   realtek/rtw89/" is empty, so this came in with the v7.1 merge window.

I could not find a way to trigger the stall on demand, so I could not 
bisect; the suspect was found by reading the v7.0..v7.1 commits touching 
the RX/AMPDU path and running a targeted revert test.

A regression with the same version boundary was reported against the 
CachyOS kernel: https://github.com/CachyOS/linux-cachyos/issues/921

Fedora bug: https://bugzilla.redhat.com/show_bug.cgi?id=2501974

Happy to run a debug build or test patches -- I have the affected 
hardware and the failure shows up within minutes of normal use, so 
turnaround is fast.

#regzbot introduced: bda294ed0ed0

Thanks,
Armin

