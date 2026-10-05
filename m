Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35994153BE9
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 01:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791164575; cv=none; b=Q+1QTQ5eH7F+AWlwLmMiYdRi+M095pMmZK7h0kIqP9K4ol6hx8FTG3GXB6b6OB0dAxhtVRpxMph0RHrrSNnFXEMEJDoTcnhO7b8rdX3JbSmYNbqyc1UfzCya1/9l++ndil25ySHb2zozuVSts8Ku/Aaf0j3eIIbF8sPXM/CTE3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791164575; c=relaxed/simple;
	bh=K0YNUe7KNUSjPEoM6XKZq3dLUyPL3xR8m0e3aZW9HLs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TSusX3SddOQAFDtpSd9YAQ+UNKlrjv/lgCwBXuc9bfWijQT3Zzy7SNhY2bsqboyEf7b6wkfw+dYVuv8isQXBk/tu2B/PBSdAFQ49t2EvvhE+JcgyQwc+kfE9T+Q1yDtchiOpq5xl8+CJ75nJImumnDPBxD+MQANy2Dnvh+gQ+PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=W0dlGIGy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="W0dlGIGy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6951gmlyF1524358, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791164568; bh=mDmtsIo18Xw+2m9M82OmZ0Emew225GsEAEYl2okH9OU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=W0dlGIGyluKHvff+ICHOjBSLtdG8vlH3SH0WR/mt4GWD+cIIWdE8AM9KA5vhfmrJf
	 eH0h5eP19aFltIJSkWVuTrq3ZkhmaZKCHTlI7g/cPsLER3+JuMI5RkfrD+fYm97otY
	 gHnXRnelJiUUJqPKe8hb0c8TEexJGSCMW9hYnQnLI/3ZVZMYkUDSGeCyoLugvSaGBj
	 iG/IuIDm83ZaIINfdL6HsCc+FCd2QPzLX5JJEfV6x+brbmH2O5LtmrJhqUQ+GZuTpg
	 hyxHOQzdiLB4/0/IofxwijkOHJCJmzZDJ3ArQF8l+2+cfPQ4liAxGJJz6o6xJQZTO6
	 KXy+IrQM8xY8w==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6951gmlyF1524358
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 09:42:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:42:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:42:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 09:42:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSD//3bjAIAFLEIQgAMNvYCABnUbAIAa7DWAgAFB57CADWw6gIADzgMQ
Date: Mon, 5 Oct 2026 01:42:48 +0000
Message-ID: <91866c4b0baa40f4a8af787d7a5ae690@realtek.com>
References: <fd4a810147fb4daeb42e5b8cae981b27@realtek.com>
 <20261002231109.12770-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261002231109.12770-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> > Can you trigger the recovery to see if it can resolve the stuck?
>=20
> Not with the stock driver. The restart itself completes - the chip is
> reinitialised and the station reassociates - but a queue that was
> already stopped keeps its stop reason across the ring reset, so TX
> never resumes. That is a driver bug and it is fixed in the first of the
> two patches I have just sent; thank you for asking the question that
> found it.
>=20
> I could produce a stalled ring after all. My own 08-28 capture had it
> and I had dismissed it: with REG_TXPAUSE at 0xff the BE read index sat
> at 0x9a while the write index ran 0x12 -> 0x1b. Pausing TX in hardware
> freezes the read index while the driver keeps submitting, which is the
> same shape the chip shows when it wedges on its own. Not the same cause
> - in the field TXPAUSE was 0x00 - but the same ring state, which is
> what your question needed.

Can you dig why REG_TXPAUSE becomes 0xff? I wonder this is the cause
PCI TX gets stuck?

>=20
> From that state, with the stock driver:
>=20
>   REG_TXPAUSE <- 0x0f, push traffic
>     BE 0x3a8: 0x0081007f, avail_desc() 1, BE stop reason 0x1, in 1 s
>   rewrite the host write index
>     0x0081007f -> 0x0081007f, no effect
>   call rtw_fw_recovery()
>     "firmware crash, start reset and recover"
>     "ieee80211 phy1: Hardware restart was requested"
>     REG_TXPAUSE back to 0x00, BE 0x3a8: 0x00000000, ring empty
>     wlan0: associated        (twice, within the 90 s)
>     BE stop reason still 0x1, 100% loss, no recovery in 90 s
>=20
> So the link came back and the ring was reset, and the queue stayed
> stopped. ieee80211_wake_queue() is reached only from the completion
> loop in rtw_pci_tx_isr(), and ring->queue_stopped is cleared only
> there. The reset drops the pending descriptors and frees their skbs
> through rtw_pci_free_tx_ring_skbs(), so that loop never runs for them;
> the flag and the mac80211 stop reason then sit on an empty ring that
> will never complete anything again.
>=20
> Patch 1 records the queue mappings stopped by the ring-full path and
> releases them, both from the normal completion and when the reset
> empties the ring. Same script, same procedure, only the patch differs:
>=20
>                               without patch        with patch
>     BE queue stopped after    1 s                  1 s
>     doorbell rewrite          no effect            no effect
>     rtw_fw_recovery()         ran                  ran
>     BE stop reason after      0x1                  0x0
>     traffic                   none in 90 s         back within 2 s

I feel patch 1 can only do ieee80211_wake_queues() instead of iterative=20
each queue by ieee80211_wake_queue().

By the way, the detail is good, but could you please give summarize the
causes you found and the solutions you adopted? This will be easier
for me to understand this quickly.

>=20
> > As this is hardware get stuck, we might skip to discuss
> > ieee80211_stop_queue()/ieee80211_wake_queue() for this moment.
>=20
> I did drop it, and then the test you asked for landed in exactly that
> code. I want to be clear about the scope though: this is not why the
> hardware stops, and it is not what killed the five events below, four
> of which never reached the stop threshold at all. It only means that
> once a queue has been stopped, no restart can bring it back. So it
> matters for any recovery, not for the stall itself.

Before rtw_fw_recovery() isn't a solution, queues will not be relevant,
right? It looks like the recovery missed to consider doing wake up all
queues if any queue stopped.=20

> > Before that, can you summarize the methods that can resolve the stuck?
>=20
> First a correction: there are five events, not three, across three
> boots, all with power save off and REG_TXPAUSE at 0x00.

I'm confused. REG_TXPAUSE is 0x00 for below cases? Or it becomes 0xff?

>=20
>   2026-08-28 20:32   BE 0x45 frozen, wp 0x19 -> 0x22   queue open
>   2026-08-28 22:05   BE 0x3c frozen, wp 0x3a           queue stopped
>   2026-09-06 03:17   BE 0xb7 frozen, wp 0x84 -> 0x9e   queue open
>   2026-09-14 17:48   BE 0xc9 frozen, wp 0x4c -> 0x68   queue open
>   2026-09-14 19:09   BE 0x9e frozen, wp 0x2b -> 0x4c   queue open
>=20
> The second line is your dump. "Hardware read index is 0x3c, and host
> write index is 0x3a" came from my own 08-28 capture, 93 minutes after
> the 20:32 one in the same boot, and avail_desc() is 1 there so the
> queue was stopped exactly as it should be. I replied as if your dump
> were a different case and said all my events were from before the ring
> fills. That was wrong, and it is the state patch 1 is about.
>=20
> The ladder stops at the first step that works, so the denominators are
> not comparable:
>=20
>   1. Rewrite host write index    0/3   no effect
>   2. ip neigh flush              0/4   no effect
>   3. iwd reconnect (new PTK)     2/4   fixed 08-28 20:32, 09-06 03:17
>   4. ip link set wlan0 down/up   1/2   fixed 09-14 17:48
>   5. Reboot                            always
>   6. rtw_fw_recovery()           0/1   measured above, before patch 1
>=20
> I previously told you an interface restart is what recovers this. The
> data does not support that: a reconnect cleared it twice and a down/up
> once, and the ordering gave the reconnect the earlier attempts. And on
> 09-14 19:09 my ladder printed a timeout at step 4 only because it
> waited 25 s; the journal shows the link up 3 s after the down/up and
> reassociated 90 s later, no reboot. The subject line's "until reboot"
> describes what a user sees, but three of these recovered without one.
>=20
> The debugfs fw_crash knob, by the way, does nothing on this chip. The
> write only pokes REG_HRCV_MSG; recovery is entered later, and only if
> the firmware raises the C2H interrupt and rtw_fw_c2h_cmd_isr() sees
> REG_MCU_TST_CFG =3D=3D VAL_FW_TRIGGER. Here that never happens, so I call=
ed
> rtw_fw_recovery() directly from a debug build instead.

The debufs fw_crash only can take effect on RTL8822C.=20

>=20
> > By the way, recently people want to disable deep LPS and ASMP [...]
> > Can you also try the settings on your platform?
>=20
> Both have been in /etc/modprobe.d since 2026-08-24, before every event
> above. I should be careful though: my captures do not record module
> parameters, so I cannot prove from them what was in effect. What they
> do record is power save off, "IPS/ Low Power/ PS mode =3D 0/ 0/ 0", and
> REG_TXPAUSE =3D 0x00 in every sample. And on the one occasion I dumped
> sysfs, disable_aspm=3DY had not changed the link's L0s/L1 state, so I
> would not claim ASPM was actually off.
>=20
> So: not prevented by disable_lps_deep=3Dy, and nothing was pausing TX in
> hardware. I cannot say ASPM was off.

It is enough to make sure you have disable_aspm=3Dy and disable_lps_deep=3D=
y,
and do cold reboot before testing.



