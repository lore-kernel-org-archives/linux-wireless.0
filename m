Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432CB2E8DEB
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786716246; cv=none; b=hh/zE7tCPnm7mMQ1D3VClKSKe2sPgsolW1dmhMSI7ot2dhTqWHbdxa3Kk0Dy0SMAz1ztwY4WmG1L0JMFlF+bwL2kra/XXuzNKSu83Fx0646+ot20tq8Wp+gbywYny0CKU7upCHDe6M4hfOBa6Xqq2zngQq5ELM0Sph0iYmQpVcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786716246; c=relaxed/simple;
	bh=KoHa5GbljRRG3jbxDYQ1Ubn0KE6wGG4QtLRjUCmaO3I=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=Ksl+VImtb5qMIKlW3kxHctHpHQCtyxOCGa5kC9lVaFZX4RSNzh5jCrFemZwpxqHdoy8Xklu3o6RopC6XvYfK/GEL50vADGsDxjMnTEbjb3feV0mq1fLVB1XAyalNTkl6ly3qzZnd+CbJ4cVNERfnqALJ4mH4mWTwvvCKv7KIF4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=WiwFc1CX; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="WiwFc1CX"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 10556240027
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 16:04:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1786716242;
	bh=KoHa5GbljRRG3jbxDYQ1Ubn0KE6wGG4QtLRjUCmaO3I=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=WiwFc1CXA23kStNwqTi6BMwx0J5rcgd35R4f1y0vSTVKXWChx9DDveQF2I78uSwq0
	 ewkFIuRShevzYRwKvq57/bK0Sxg1QGquMTJTkw2dF/mZmDvXgJ/K6VV8RPo5ErX02f
	 uzMhNleBeR7M6rLkI3ZcpNJtH3T0CEwvox13lPxPJ3EPe4hG410zfYPhndOG2jFVay
	 O7wmFSMK0tsQ3K3TiXRKgmAZ3KZB1Blszymgg7S5Ch0/thuDwx53OplLFCnxCYlr0S
	 g8o1PIhXVT6/JVfI0kaI0c2qaIBA78tIbqZPQvhE3N+AEcH70wK9ZeGJ4Eyq2xc1cy
	 0/jQWbpcDPWEw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hM3qj3lKkz9rxy;
	Fri, 14 Aug 2026 16:04:01 +0200 (CEST)
Date: Fri, 14 Aug 2026 14:04:01 +0000
From: Jonas Hort <jonas.hort@posteo.de>
To: regressions@lists.linux.dev
Cc: linux-wireless@vger.kernel.org, lorenzo.bianconi83@gmail.com
Message-ID: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de>
Subject: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de>

Filed as: https://bugzilla.kernel.org/show_bug.cgi?id=3D221884


Summary: WiFi 7 MLO (5GHz+6GHz) on MT7925 silently stops passing traffic
after a few minutes, while the driver continues to report a fully
healthy link. Root cause appears to be a stalled WFDMA0 TX hardware
queue. Reproduced on both linux 7.1.8 (stable) and 7.2.0-rc7 (mainline
pre-release), not fixed as of rc7. Disabling the 6GHz radio on the
access point eliminates the freeze entirely in my testing.

This is a regression: reported by multiple users on the CachyOS forum
as broken starting with the 7.1.x kernel line; earlier kernels
(6.18.x longterm) are reported to work fine. I have not yet performed
a commit-level bisection but can if guided on the best approach given
the AP-side 6GHz dependency.

--- Detailed description ---

Symptom:
When connected via MLO (Multi-Link Operation, EHT/WiFi 7) with two
active links - one on 5GHz and one on 6GHz - network traffic silently
stops after a few minutes of normal use (web browsing, etc). The
connection continues to show as healthy:

- `iw link` / `iw station dump` report the connection as associated,
=C2=A0 authenticated, good signal (-60 to -65 dBm), high negotiated
=C2=A0 bitrate (800-1700 Mbit/s), 0 tx retries, 0 tx failed.
- Nothing is logged to dmesg/journalctl at the time of the freeze.
- Ping to the gateway shows 100% packet loss for several minutes,
=C2=A0 until the connection eventually recovers on its own.

I built a small watchdog script (ping-based failure detection + live
kernel log monitoring) to catch the freeze automatically and sample
mt76 debugfs state repeatedly across the event. This revealed the
actual mechanism:

`/sys/kernel/debug/ieee80211/phy0/mt76/xmit-queues` shows the WFDMA0
hardware TX queue's `tail` pointer completely frozen while `head`
keeps advancing - i.e. packets keep getting enqueued but the firmware
stops draining the queue. RX stops in the same instant (rx byte/packet
counters in `iw station dump` freeze completely). No tx retries or tx
failures are ever reported by the driver, so it does not appear to
notice the stall itself.

Example from one incident (kernel 7.2.0-rc7):
=C2=A0 t+1s:=C2=A0 WFDMA0: queued=3D130 head=3D390 tail=3D260=C2=A0=C2=A0 r=
x bytes=3D184791894
=C2=A0 t+9s:=C2=A0 WFDMA0: queued=3D148 head=3D408 tail=3D260=C2=A0=C2=A0 r=
x bytes=3D184791894 (unchanged)

`tail` never advances during the whole stall window while `head`
keeps growing - the queue is being filled but never drained.

Reproduced this exact signature four times total (twice on 7.1.8-1,
twice on 7.2.0-rc7-1), always with MLO 5GHz+6GHz active, always
within 3-5 minutes of normal use.

6GHz correlation:
My MLO links are 5GHz (5180 MHz) + 6GHz (varies, e.g. 6135 MHz).
Fully disabling the 6GHz radio on the access point (FritzBox 5690
Pro, FRITZ!OS 8.25 - not just client-side band restriction via
NetworkManager, which does not reliably suppress the second MLO
link) results in 30+ minutes of clean operation with no freeze.
Re-enabling 6GHz reproduces the freeze again within minutes.

Regression info:
Multiple users on the CachyOS forum report this started with the
7.1.x kernel line; the previous longterm kernel (6.18.x) is reported
to work fine by another user with different affected hardware
(different AP). I have not personally tested 6.18.x myself, and have
not performed a commit-level bisection yet - happy to do so if
pointed toward the most likely area of the driver, given the AP-side
6GHz dependency makes a fully automated bisection awkward.

Steps to reproduce:
1. Connect to an AP advertising WiFi 7 MLO with 5GHz+6GHz link
=C2=A0=C2=A0 options, so the client negotiates both links.
2. Use the connection normally (web browsing is sufficient).
3. Within roughly 3-5 minutes, new connections start hanging;
=C2=A0=C2=A0 existing traffic stops.
4. Check `iw link` - link still reports as connected/healthy.
5. Check `/sys/kernel/debug/ieee80211/phy*/mt76/xmit-queues` -
=C2=A0=C2=A0 WFDMA0 tail pointer frozen while head continues to advance.

Environment:
- Kernel: linux-cachyos 7.1.8-1 and linux-cachyos-rc 7.2.0-rc7-1
=C2=A0 (CachyOS, near-vanilla Arch-based build)
- cat /proc/version:
=C2=A0 Linux version 7.2.0-rc7-1-cachyos-rc (linux-cachyos-rc@cachyos)
=C2=A0 (clang version 22.1.8, LLD 22.1.8) #1 SMP PREEMPT_DYNAMIC
=C2=A0 Mon, 10 Aug 2026 20:51:00 +0000
- Distribution: CachyOS
- Architecture: x86_64
- Kernel tainted: no (/proc/sys/kernel/tainted =3D 0)
- WiFi hardware: MediaTek MT7925 (mt7925e driver, mt76 core),
=C2=A0 WM Firmware Build 20260605184805, ASIC revision 79250000
- Access point: AVM FritzBox 5690 Pro, FRITZ!OS 8.25

Related community discussion:
https://discuss.cachyos.org/t/mt7925-wifi-7-mlo-breaks-connectivity-on-7-1-=
x-mt76-regression/31972
(I am the thread starter; several other users report matching
symptoms with different hardware/APs)

Possibly related (different symptom, same 6GHz/MT7925 area, worth
checking for a common root cause):
Bug 221627 - MT7925E - System locks up with flashing caps lock
(comment 1 there: "caused by switching between AP's with the same
6GHz wifi name")

Attachments (will add to this ticket):
- Full incident logs for all four reproductions (dmesg + journalctl
=C2=A0 + mt76 debugfs time series across each freeze)
- iw station dump / iw link output during freeze
- Kernel .config

Note: checked bug 220424 (mlo_sta_cmd/sta_cmd regression) before filing -
different symptom (persistent near-zero throughput vs. our intermittent
full stall with healthy link stats) and different root cause (broadcast
wtbl hdr_trans_tlv handling). That fix landed in 6.16.6/6.17-rc5, well
before the kernel versions tested here, so it is not the cause of this
issue.

