Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A0371887
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217648; cv=none; b=SVLWlcgQu51UxBKU3/iUQ2VHrt5h43iLSqJef9J07U9/uRcmMF2RNp4ULW6GxCoWNz7uN/LBGmoT+e2XGF6lfAtWXmmBNH2ZTc2kM6bCFNz8JrEIxVypl+OjfkhEGgl/3a7mYcUj3id7uu/edp5WpSFNyzSLORRrjQzi2VU3PvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217648; c=relaxed/simple;
	bh=UlpuANQ03LNKyn6P5s8LUoOdjN2e9gv0UgkKjSqfqx4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KHilnko4BXI7tAdI/KWZiQeg36A3aqmW6OAvgYQOCP7HXv3XnRIviOWgeZ8N3QVAl3H7BOsS614G/WhY52IYJeF959XaKX0N6ox83qziqM9pjnFsUGRhlOp5DFDeJHVPHQ8AQcGRXM95wB5D4eIKVZPcGo6iH/pZXcSFcajTNjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RAhv6E1N; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RAhv6E1N"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68O2ef173824805, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790217641; bh=appBhQqVwJqCP+w3KB1RHJtbub8yUQ49MfJO378BALU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RAhv6E1NY27JwmxZZ+LZvbseCwPvHQAabs6JSqLuaFltOcHhzRRLYLDrZqKcIO6dx
	 j2RP6YwGDl9dyBglo77KavMsXErDjL2CC0YtomTTdoBWPrviRlbWhKcir284GoMqIu
	 1QZRpoE02kl1ibt7RRLCD/u1K8+0r4yDnHK3ex8imC2T6J00wXJmuZPQ9Rh9ev35tR
	 2fgpgTc6U1RJCBqjUafM71Gr+K6SO8wzyfFkubT3lRuju6GntpHVkoYISmAOi92iP+
	 yrUFDTRU/PxcSMwwh+Uc2Us4PoTI6eZXvTWw3Dhge6ZkL2ZP32BH00zyaO9MjUOf5G
	 ab2a2+rY01ekw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68O2ef173824805
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 24 Sep 2026 10:40:41 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 10:40:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 10:40:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 24 Sep 2026 10:40:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: abkarada <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSD//3bjAIAFLEIQgAMNvYCABnUbAIAa7DWAgAFB57A=
Date: Thu, 24 Sep 2026 02:40:41 +0000
Message-ID: <fd4a810147fb4daeb42e5b8cae981b27@realtek.com>
References: <9d64e207c4434411981bc133ef820d7e@realtek.com>
 <20260923150017.181310-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260923150017.181310-1-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

abkarada <abdurrahmankaradag19@gmail.com> wrote:
> Yes, and I could not get any further than that. The BE ring's hardware
> read index stops moving while the host write index keeps advancing. To
> rule out a missed doorbell I taught the watchdog to rewrite the TXBD
> host index during a live stall and re-read it. Three independent
> occurrences, each pair taken immediately before and immediately after
> the rewrite:
>=20
>                      BE read index      BE write index
>   2026-09-06 03:17   0x00b7 -> 0x00b7   0x00a2 -> 0x00a3
>   2026-09-14 17:48   0x00c9 -> 0x00c9   0x006c -> 0x006d
>   2026-09-14 19:09   0x009e -> 0x009e   0x0050 -> 0x0051
>=20
> The read index did not move in any of them, and it was not a momentary
> sample either: in the 19:09 capture it held 0x9e from the first register
> read to the last, minutes apart, while the write index went 0x2b -> 0x4c.
> Traffic stayed at 100% loss throughout.
>=20
> So rewriting the TXBD host index is not sufficient to recover the ring.
> I have asked for that patch to be dropped.

Can I say that touching host write index doesn't affect hw read index?

>=20
> > Hardware read index is 0x3c, and host write index is 0x3a.
> > So, it reaches the limit of stop queue.
>=20
> Agreed, and that dump is the late moment. avail_desc() is 1 there, so
> ieee80211_stop_queue() is exactly right and the driver is doing what it
> should.
>=20
> But both stalls I caught in September are from an earlier moment, before
> the ring fills:
>=20
>   17:48  0x3a8: 0x00c9004c -> 0x00c9004e -> 0x00c90053
>          read index 0xc9 frozen, write index 0x4c -> 0x53, avail 124
>   19:09  0x3a8: 0x009e002b -> 0x009e002d -> 0x009e0034
>          read index 0x9e frozen, write index 0x2b -> 0x34, avail 115
>=20
> The ring still has 124 and 115 free descriptors, the queue is not
> stopped, nothing has hit any limit - and traffic is already 100% lost,
> because the hardware has stopped consuming descriptors while the driver
> keeps writing them and ringing the doorbell. Nothing in the driver
> notices this. The watchdog runs, the link stays associated, RX keeps
> working, and there is no counter or log line anywhere that says the TX
> ring has not advanced.
>=20
> So the first gap is detection, and it happens before your dump.
>=20
> The second gap is what happens after it. Once the ring does fill and the
> queue is stopped, everything that could undo that sits behind the same
> frozen index. In rtw_pci_tx_isr():
>=20
>         if (cur_rp >=3D ring->r.rp)
>                 count =3D cur_rp - ring->r.rp;
>         else
>                 count =3D ring->r.len - (ring->r.rp - cur_rp);
>=20
>         while (count--) {
>                 ...
>                 if (ring->queue_stopped &&
>                     avail_desc(ring->r.wp, rp_idx, ring->r.len) > 4) {
>                         q_map =3D skb_get_queue_mapping(skb);
>                         ieee80211_wake_queue(hw, q_map);
>                         ring->queue_stopped =3D false;
>                 }
>                 ...
>         }
>=20
>         ring->r.rp =3D cur_rp;
>=20
> The only ieee80211_wake_queue() in pci.c is inside that loop. As long as
> cur_rp remains equal to ring->r.rp, count stays zero, so the body is
> skipped and neither ring->r.rp nor the stopped queue is ever
> reconsidered. Meanwhile rtw_pci_tx_write() keeps consuming descriptors
> until avail_desc() < 2 and calls ieee80211_stop_queue().
>=20
> To be fair to the design: this is not a deadlock. The descriptors are
> still sitting in the ring, so the normal completion path can recover the
> queue - but only if the hardware resumes consuming them. When it does
> not, and in the three occurrences above it did not, there is nothing
> else: no timeout, no ring reset, no device reset. The interface stays
> dead until userspace does something about it.

As this is hardware get stuck, we might skip to discuss=20
ieee80211_stop_queue()/ieee80211_wake_queue() for this moment.

>   14:29:58  injection on. The driver's own counters, logged from the
>             ISR, one second apart:
>               r.rp=3D174 r.wp=3D175 avail=3D254 stopped=3D0
>               r.rp=3D174 r.wp=3D172 avail=3D1   stopped=3D1
>             mac80211 BE queue: 0x1, IEEE80211_QUEUE_STOP_REASON_DRIVER
>   14:30:00  ping to the gateway: 100% loss
>   14:30:30  injection turned OFF
>   14:32:30  r.rp=3D174 r.wp=3D172 avail=3D1 stopped=3D1, queue still 0x1,
>             120 s later, with no recovery
>=20

[snip... Since I don't quit understand this test after I read twice.=20
Maybe I can read it again when I have free time]


> So I am not asking you to treat the stall itself as a driver bug. I am
> asking about the two gaps around it: the driver currently has no
> mechanism to detect that a ring has stopped advancing, and no way back
> if the hardware does not resume on its own. Would you consider a patch
> that addresses those - per-ring detection of "read index has not moved
> for a few watchdog rounds while descriptors are pending", triggering the
> recovery the driver already has for a firmware crash,
> rtw_fw_recovery() -> fw_recovery_work -> ieee80211_restart_hw()?
>=20
> In the field a full interface restart is what recovers the link in both
> occurrences where I got that far; on 2026-09-14 19:09 it came back 3 s
> after a down/up and reassociated without a reboot. __fw_recovery_work()
> does firmware-crash-specific work, so this would need a lighter variant,
> and I would rather hear your view on the direction than send something
> you do not want.

As your subject "100% loss until reboot", I can't say if this can help.
But here you mentioned "it came back 3 s after a down/up...".

Can you trigger the recovery to see if it can resolve the stuck?

>=20
> If you would rather not add a recovery path at all, the detection half
> is still worth something on its own: a log line at the moment a ring
> stops advancing, instead of a user discovering that the network died. It
> would also have saved me most of the last two months, and it would make
> the next report of this kind arrive with the register state already in
> it.

Did you mean detection stuck + recovery is the new proposal you want to
do? I think this can be a candidate solution.=20

Before that, can you summarize the methods that can resolve the stuck?
1. if up/down?
2. recovery?
3. (X) write host write index
4. ... (more)

By the way, recently people want to disable deep LPS and ASMP for this
chip, because they encountered hard system freezes [1], which they did
disable_lps_deep=3Dy and disable_aspm=3Dy before.

Can you also try the settings on your platform?

[1] https://lore.kernel.org/linux-wireless/20260918232801.119348-1-eexto@ao=
l.com/



