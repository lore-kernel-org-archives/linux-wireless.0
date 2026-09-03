Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3466641A919
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788421386; cv=none; b=Ns+cBUyft8xW1ElTyY52JvFfLYede5K0SUgfOjGIUVnh3JWWLaKKQ8sFSqkm24UkPpeVqDRKBSsepfbWFah7HGlNgho4yGO6yIvdM2hj9lkv4HlmNRXj7RpinW5VjT4gjp6lmf0hp35VFsPDs8t3Df7Sg+4k9Ja/9Mpf41mZaN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788421386; c=relaxed/simple;
	bh=PsY1iHq2BeSQCINa9gbajP738oZxwRZg3JA5676l0po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BbRFA/Uou7DFbSQBB5XQXRRkCXVe4TYlrnFQsEc+WKoSq9BoMcGlnfhlXz8Vk3vfFmuwRxn5Yt5UOqoNWsnVtZHiZrKaOE/NMIhLR2QMcIYPYKhQDJ1Qw6/XQK6eW0rkKFXKG/3O7IL5zrNC5ScnP3ZjAiBPST0AxewG6JbSbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=mArabnue; arc=none smtp.client-ip=95.215.58.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="mArabnue"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PsY1iHq2BeSQCINa9gbajP738oZxwRZg3JA5676l0po=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788421382; v=1; x=1789026182;
 b=mArabnuezLZglAhhf35fyDTxtUDFd0xLjKGwr7tC/KqYtZ0L/Q6iCiKrXUl5Ehum55IcQLkT
 C3ahP4MozAU5d9CwShkU+hW+Bg1dO1W7ShYKQh/zIraAj/hSdhT2YZLLkI1QtxTMGBVAjkSftKg
 Q5ImhqD5kEAQCBk5agmub//Rw6iuEEYSYRvA8CcZ1w+RGlcyF5tHCRaePTJWTTAI4tswDseIpC6
 ojrxQ88gTWwyAy73XMMjnev+G5N59psboLGzpbp89HrqY1cRpccUvA6KW1XBYqoDpq6eOC0MaHa
 nyLnzs0bSvpc7lXR9GwfMCdX0Vnq6XCIWBqKFMS8Zy5JQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2a69e8a19ec4a853;
	Thu, 03 Sep 2026 07:43:01 +0000
X-Mizu-Trace-ID: 2a69e8a19ec4a853
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Thomas Hilber <thomas.hilber@enxio.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
 linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
 completes (ath9k_htc, mt76; not brcmfmac)
Date: Thu, 03 Sep 2026 00:42:59 -0700
Message-ID: <178842137902.19372.6968639520035628037@justthetip.ca>
In-Reply-To: <20260831054740.1543875@enxio.de>
References: <20260827074442.826644@enxio.de>
 <20260829232532.29622-1-lucid_duck@justthetip.ca>
 <20260830104236.521389@enxio.de>
 <20260830190028.20209-1-lucid_duck@justthetip.ca>
 <20260831054740.1543875@enxio.de>
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-31 at 07:47 +0200, Thomas Hilber wrote:
> Done, and it does not hold here. The window is filled correctly and my
> stall happens anyway.

Welp, that kills it, and TID 0 on its own is enough. I read too much into
one capture.

Your question first, and the answer is half unhelpful. I can't check
whether my slow cycles survive a session where the SSN does arrive,
because I can't reproduce the slow cycles any more. Cleaning up the
harness took the effect with it. My traffic had been going over loopback,
and my timing metric merged the stall into the reassociation gap. Thirty
five associations on the MT7922 across both bands since, nothing in your
range at all. So treat my 27-in-95 from the 30th as unreliable until I can
produce it again.

What I can do is make your window happen deliberately.

I built stock mt76 with a module parameter that sleeps inside set_key, so
a key install takes as long as I like. Same binary both arms, the only
difference is a number I echo into sysfs. The station is on a different
driver, so the delay only hits the AP.

  keydelay_ms=0     key install   1.1 ms
  keydelay_ms=150   key install 155.3 ms

With the delay, all nine associations took 103 to 184 ms before traffic
passed again. Without it, seven of nine were back inside 78 ms.

The reason it works is that mac80211 calls the driver before the key is
reachable. In ieee80211_key_replace, enable_hw_accel runs first and the
rcu_assign_pointer that publishes the key to the RX path runs after it. So
while set_key is blocked, the AP has no key in hardware and none in
software either. It is deaf, not slow.

And yes, the MT7922 does give me a monitor interface on its own phy with
hostapd running, same as yours. So I captured air and the AP's netdev
together through an induced window. Across four windows the station put
21, 26, 25 and 25 data frames on air and the netdev saw 7, 24, 13 and 24.
In a quiet 200 ms a second later, nothing is lost at all.

Which says your 22.2 ms isn't evidence against a deaf window. Frames in
the window are dropped, not delayed, so anything timed at the netdev can
only be timing the survivors. Yours would look fast for the same reason
mine does.

So the measurement worth making is your key install.

  echo 1 > /sys/kernel/tracing/events/mac80211/drv_set_key/enable
  echo 1 > /sys/kernel/tracing/events/mac80211/drv_return_int/enable

Pair each set_key with the next return on the same pid. Near 134 ms and
it's ath9k_htc's key path. A few ms like mine and it isn't, and your
two-mechanisms reading is probably right.

Assuming CCMP, two things you can skip. The key writes take the else
branch in ath_hw_set_keycache_entry and batch into one WMI multi-write,
not six round trips. And the buffer enable and flush around them are a
paired inc/dec, so nothing sits unflushed. TKIP takes a different branch.

Thanks for the monitor-on-the-same-phy trick. That'll save people a run.

Devin

