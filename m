Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E263B47C9
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 03:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788147330; cv=none; b=oIQRjHZ/OhDA9+2LErs9lOReuF9y5S186KjQ6LWN6eTsc6zpG/w17Vu3xcuXIrp1iwUkXjqLN2+1yjGcCCJ+lAbKIn1J8YJI6g2qknbkKuuMKlGj2d1IxO+UK7oAeUuHq8lW460Ff1QMMh6TP2TTHi92ypf1zDb8f0wYLsV25R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788147330; c=relaxed/simple;
	bh=r8qMZxpA14z0eBpEIhyOaBVGiA0pQ5Oi0yy0Yewd/gY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EhnWQn3NfH4QkC/EAqyBxmQSwv/iryIPR/Uj+xohFiPnPK1mWnmLDKos/FEVGd6SiuCesG5+IyYNko/eZ4trAYQGvafVEPMPwXvtQAk9n1vhVStSH2bEUETchu1Z0+xyMArTMh+0uKOJiGhELzqgnhFZcA55nVIwMNs+FEEuAV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SQg80psL; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SQg80psL"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67V3Z7fpC409138, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788147308; bh=/qrBleGWkz+xNTvNeWbYzmZWrrpOkaXA7jVesbF/REg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=SQg80psLDRxXx3RhGA2qZQurc3M7rZd7IinWl11Uubjam/ZbPBNqZVBdU+mRlkdM+
	 T62ApGv2u/RapoNL5Posaq28WHiEEt16NGu1EUGCTLlR+XAAdyAob2Yws5A200DVU6
	 vD8huPC+a9mzxcmj+yQIKbg8po4uWLMZYx6wp7TsQGQR2Y6QLrAbvAFFnEQzOlJleY
	 GhT9avvXHA3BpMIbMOyLwrg7DUhfKcaPynZlVvrlwJWStWMWGKYUAtp+/PG3vAC6M4
	 nPyhxCILPoJVOvNKFUQ0KPPD4SYLMhit6keWy+xYePX3cVBEilJ8GwT7i6Wk+Un8Al
	 e3ZWf2K7QrmiA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67V3Z7fpC409138
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 11:35:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 11:35:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 31 Aug 2026 11:35:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSD//3bjAIAFLEIQ
Date: Mon, 31 Aug 2026 03:35:07 +0000
Message-ID: <516290e0e8a84988a9219069596e61a3@realtek.com>
References: <51079deb603845768db7cbe491f40e3c@realtek.com>
 <20260828033746.23039-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260828033746.23039-1-abdurrahmankaradag19@gmail.com>
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
> > Is there are version it works well on your platform?
> > I'm thinking bisect is a method to find cause.
>=20
> Yes - and I have to correct my first mail, which said "also seen on
> 7.0.12". Going back through the system journal and pacman log:
>=20
>   - 7.0.12 (Arch) ran on this laptop from 2026-06-16 to 2026-08-23. The
>     14 boots the journal holds from that period show no wedge episode
>     (defined as: DHCP lease acquired, then the gateway unreachable / DNS
>     failing continuously until reboot). The few candidates are either
>     sessions caught in the separate 63 s regulatory reconnect loop, or
>     sporadic DNS timeouts spread over hours-long otherwise-working
>     sessions (14-27 timeouts in 0.8-3.5 h), plus one 176 s blip - none is
>     the 100%-loss-until-reboot pattern.
>   - On 2026-08-23 18:41 pacman upgraded linux 7.0.12 -> 7.1.9 (in the sam=
e
>     transaction: linux-firmware-realtek 20260519 -> 20260810, whose
>     rtw8821c_fw.bin is byte-identical by sha256, and systemd 260.2 ->
>     261.2 a few minutes earlier).
>   - The first boot on 7.1.9 (2026-08-23 23:37) logged 12 wedge episodes,
>     and it has recurred on most days since.
>=20
> So for a bisect: good =3D 7.0.12, bad =3D 7.1.9 (with the caveat that
> systemd changed in the same upgrade; I don't think networkd can explain
> a per-AC L2 TX failure, but I mention it for completeness). I still have
> the 7.0.12 package and can confirm by running it again for a few days,
> and I'm happy to bisect the rtw88/mac80211 range between the two if you
> think that's the right next step. (Under Windows the same laptop has
> never shown this.)

Checking commits between 7.0.12 and 7.1.9, the only related commit might be
   c95323ea9dfb ("wifi: rtw88: coex: Solve LE-HID lag & update coex version=
 to 26020420")

You can revert the patch from 7.1.9 to see if it becomes normal.

Another simple way is to use 7.0.12 kernel + 7.1.9 rtw88 driver and
opposite combination to address the cause, like

     kernel         rtw88 driver         result
     ------         ------------         ------
     7.0.12         (built-in)           Good
     7.0.12         7.1.9
     7.1.9          (built-in)           NG
     7.1.9          7.0.12=20

This can also bisect if the cause is driver or mac80211.

>=20
> > I'm not sure why the size can affect the result. Normally large size
> > is harder to transmit basically though.
>=20
> You are right, and I withdraw the size theory. Re-examining the same
> capture by 802.11 access category instead of size explains every frame
> with no exceptions:
>=20
>   - every laptop TX frame that provably reached the AP carries IP DSCP
>     0xc0 (CS6 -> UP 6 -> AC_VO): the DHCP DISCOVER/REQUEST frames
>     (systemd-networkd's DHCP client marks them CS6) and IGMPv3 reports;
>   - every laptop TX frame that provably never arrived is AC_BE:
>     89 ARP requests (no IP header -> BE), 13 unicast ARP replies,
>     83 DNS queries (0 answers), 2 TCP SYNs (no SYN-ACK), mDNS/LLMNR;
>   - sizes overlap the wrong way for a size theory: BE frames of 42-201 B
>     all fail, VO frames of 54-345 B all pass.
>=20
> So the wedge looks like "AC_BE TX dead, AC_VO TX alive", RX intact, and
> it persists across disconnect/reconnect and across AP changes (so not
> per-association state), cleared only by a reboot. It happened with
> power save fully off.
>=20
> As far as I can tell from reading the driver, BE and VO take different
> paths (separate PCIe TX rings per AC, and on 8821C BE/BK on the LOW
> TX-FIFO queue vs VO/VI on NORMAL), so a per-AC stall - e.g. the BE ring's
> mac80211 queue left stopped, or the LOW queue paused/page-starved - would
> match what I see (BE frames silently aged out, VO flowing, no driver
> message). Does that sound plausible to you, or is there a more likely
> place for a per-AC TX stall on this chip? The monitor-mode capture
> should at least show whether BE frames reach the air at all.

I think BE and VO should almost the same, but as your perspective
BE and VO go via different paths. It is worth to do an experiment
to let all packets (by driver modification) go via VO queue.

>=20
> When it wedges, besides the air capture, I plan to dump before rebooting:
> /sys/kernel/debug/ieee80211/phy0/queues (per-hw-queue stop reasons),
> stations/<ap>/aqm (per-TID backlog), and via rtw88 debugfs read_reg:
> REG_TXPAUSE (0x522), REG_TXDMA_STATUS (0x210), REG_FIFOPAGE_INFO_2/3
> (0x234/0x238) and the BE/VO TXBD indices (0x3A8/0x3A0), compared with a
> healthy baseline. If there are better registers or a debugfs page for
> the BE ring / LOW queue state on 8821C, please tell me and I'll dump
> those instead.

Before checking these values, let's bisect the code, check sniffer, and=20
do experiment first.


