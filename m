Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308583DAACA
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976720; cv=none; b=idtLvf4bQtbvXOjc3CLJjtsCwvHmxDiL68iupJCBGtq11AxM9r+yZ3+TbBhDYmiwdpJqjcIbEkYpJaaZXAt+UDCJCPuQBo5v9VxbtfdmrOwEOUd3snqEWLUOHy7wdpKbbfzNb5qn9HVwYUvADonIJA5OruRUQ4j6SGG3fZmVsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976720; c=relaxed/simple;
	bh=5NYCdV7DxO0yfbG8hSq4BoGXgeh/C3dc4BvFmYUP9OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Px3JxRyksUtIlxUZedXHoZfYCx5wXxJJbczw0BR0NCqGmnnraEl2chb0eCTyD12169TXsvr3scfRGquU45986RZ9tuFuLCdrv/YWEex/nK3+c36HJsE0PvYuZJFJhkXdschETyX5QMBas+AmO7wyoeyjaW1ea5UCFTXRXXkLvKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=a+tsw9lR; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="a+tsw9lR"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id CB680240103
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 16:25:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1786976714;
	bh=SILDQTFVoY+AHwG+3Bgw2hvsn82dE9tOcH20jBz/6ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:Content-Type:
	 Content-Transfer-Encoding:From;
	b=a+tsw9lRrER2gTA9zq3zXBc2A8tWz6RINzlT2l2WJYQp4KPo9YY5Rrk3FdSpyi/Bl
	 oEwppZGI6gFdmqSvrWhtnINB6HrUEJrw5SpnbX5sAMqLyAdgzjk6CWiTv/hNB08TDT
	 na7FCVTEpz4LCKWVZw6jKdm+QLf8/GWQccToTpqQQQmYHyVyNkUlFxlPmElUpLxWzu
	 2PX+Ai6z5RqecktfHpkDUTXooM1H6lX7Q6GgK5OWHlzyG9L/Hvm7McvGCyb9kwjVmx
	 eW5pWcFo4zjlE0E0FPAnG6b0zonVgUGxzmGk8oYbl/CslWh40+GIUF0zKdTFgJBpKS
	 3QDUmDTReH4/g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hNw8n1Txrz9rxB;
	Mon, 17 Aug 2026 16:25:13 +0200 (CEST)
Message-ID: <b83a5708-b5f4-48e9-85a5-37b3ab34af46@posteo.de>
Date: Mon, 17 Aug 2026 14:25:14 +0000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
To: Devin Wittmayer <lucid_duck@justthetip.ca>,
 Thorsten Leemhuis <regressions@leemhuis.info>, regressions@lists.linux.dev
Cc: linux-wireless@vger.kernel.org, lorenzo.bianconi83@gmail.com
References: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de>
 <d8e493ef-90ff-4364-ad4e-1709fae97005@leemhuis.info>
 <20260816204805.46779-1-lucid_duck@justthetip.ca>
Content-Language: en-US, de-DE
From: Jonas Hort <jonas.hort@posteo.de>
In-Reply-To: <20260816204805.46779-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

First, thanks to everyone helping out with this - really appreciate
the time you're all putting in.

One correction to how I described this earlier: the connection does
NOT reliably self-heal on its own. I have manually intervened every
single time to restore connectivity - either by disconnecting and
reconnecting the WiFi connection, or by switching to my band-lock
workaround (forcing 5GHz-only, which disables MLO). What I can say
for certain: the system itself has never needed a reboot - it stays
fully responsive throughout, only the WiFi link itself needs manual
action to recover. Wanted to correct that record before it causes
confusion.

Update on the ROC tracing: three real freezes captured now with the
kprobes active (all confirmed via the WFDMA0 tail-frozen signature).

- Freeze #1 (15:37): no ROC activity in the trace. Fixed by
   disconnecting/reconnecting the WiFi connection fairly quickly.
- Freeze #2 (15:43): this time I deliberately waited longer before
   intervening. The trace shows several ROC events (rocabort, mloroc,
   rocwork) clustered together. Fixed by switching to the band-lock
   workaround (5GHz-only).
- Freeze #3 (16:15): no ROC activity again. Fixed by
   disconnecting/reconnecting the WiFi connection.

Uploaded all three logs to the bugzilla ticket if useful:
https://bugzilla.kernel.org/show_bug.cgi?id=221884

Still haven't gotten to confirming 6.18 as a clean baseline on my own
hardware - that's next on my list.

Am 16.08.26 um 22:48 schrieb Devin Wittmayer:
> On 15/08/2026 07:51, Thorsten Leemhuis wrote:
>> CCing Devin, who wrote two of the following messages
> Those are the mt7921 regd deadlock. mt7925 does not have it, there is no
> equivalent of the mt7921_mac_sta_add() call site that creates it.
>
> Worth ruling in or out before you bisect. mt7925 sets
> IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS to 0 in mt7925/main.c. It is an N-1
> field, mt7996 sets MT7996_MAX_RADIOS - 1, so 0 means one simultaneous link,
> and mt7925/mcu.c then requests MT7925_ROC_REQ_MLSR_AG or _AA. MLSR is
> multi-link single radio: your two links share one radio, and ROC is what
> moves it between them.
>
> If 5 GHz is your deflink, your pair is named on that path in
> mt7925_mac_set_links():
>
> 	if (band == NL80211_BAND_2GHZ ||
> 	    (band == NL80211_BAND_5GHZ && secondary_band == NL80211_BAND_6GHZ)) {
> 		mt7925_abort_roc(...);
> 		mt7925_set_mlo_roc(...);
> 	}
>
> That one only runs at association. The path that can run mid-session is
> mt7925_change_vif_links(), which calls mt7925_set_mlo_roc() for each added
> link. Both reach mt7925_mcu_set_mlo_roc(), and all of this is the same in
> 7.1 and 7.2-rc7.
>
> Under your existing watchdog:
>
> 	cd /sys/kernel/debug/tracing
> 	echo 'r:mloroc mt7925_mcu_set_mlo_roc ret=$retval:s32' > kprobe_events
> 	echo 'r:rocabort mt7925_mcu_abort_roc ret=$retval:s32' >> kprobe_events
> 	echo 'p:rocwork mt7925_roc_work' >> kprobe_events
> 	echo 1 > events/kprobes/enable
>
> Association will fire mloroc once, so anything later is a mid-session
> switch. If the WFDMA0 tail freezes while one of those is in flight, it is a
> link switch that did not finish. If they are silent across a stall, the
> whole path is ruled out and that is worth as much.
>
> On the bisect itself: your 6.18 good point is second-hand, from different
> hardware and a different AP. Worth confirming on your own box before
> spending steps against it.
>
> Devin
