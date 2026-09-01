Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C138F642;
	Tue,  1 Sep 2026 05:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788240260; cv=none; b=GljuV5TXzb6JzoGJYpwY580062jimutYaslH1WYvrgGFtgQ3RypU+0EgNx6bXCbXN/vi39XpYMTtMi1Kthr7l9dDd6QjsaUPmK1/NO33Ytac3c7A0CRP8cBnl1d/wnWngmpJcVivrGaHEQAZdPcKBFuCJ9aqjc6rXkpyD40BtKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788240260; c=relaxed/simple;
	bh=Rd1+8Drlvqve5BS7MQCml9zsuJlAOqB4b34aulE+dEM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ARFEvvu6Eht3x7lbV5mVnmwZz6KJLgO7AU0UwZIKHQ96dVZi+lUEOtCnN3xc8NECnwkfuWaPq/CfRCNq/RAWJ9NkLKCak6ZIWcEtjqQ58G8/Tbqrw7JsiuShguo49LuIaiDBNeBRG6wdIEa6VnzwgNcjiV7WhPh8j+AIIHcdtaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S4WSMe25; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S4WSMe25"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6815ODwoC1394487, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788240253; bh=E1gVoItUvm6Loo9Ud9VyGjaKlBM9ZGi38uHYPKnX07I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=S4WSMe25gEaGEnX42Uzoo0O+dUszrlIsTB16nUUmjRsT085T0gllDehqWCneww1jn
	 01z3xjTFvqC1FI+FDfCn3EB/kG7wcTox7LirIKpinIMEjju+MyspeWcf718vzGPNo6
	 Pgcgedneqw/pBUBLfrLKSB792V8Hc7Lo+WYB2ai6GT2KbtJzklu7GTErAVEfF7/Xxv
	 q3whtLZ4YfxuoaMgmmm8dvjWp1JoTE0I3smp/BcvrjboVWLJKAt80xKB9qlkBxiPSL
	 JldubCr+Bp4nAMV9BlfiESkEJbORGvpAgE446YrMBjUbf9nA5GOyNBGVfqbgHbVh/K
	 jJ+gwev+QtIkQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6815ODwoC1394487
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 1 Sep 2026 13:24:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 1 Sep 2026 13:24:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 1 Sep 2026 13:24:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILazZGiAgAXJeAA=
Date: Tue, 1 Sep 2026 05:24:13 +0000
Message-ID: <9209280c3f044363afd884687ae3cb6b@realtek.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
 <20260828191051.178481-1-mehmet.fide@gmail.com>
In-Reply-To: <20260828191051.178481-1-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> Hi Ping-Ke, Bitterblue,
>=20
> thanks for the ack on this one. It has not been applied yet, and before
> I post anything on top of it I would like your opinion, because I now
> have a case where the same lockup comes back with this patch in place.
>=20
> What happens
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The patch made the after-DTIM routing conditional, but nothing bounds
> that path. mac80211 sets IEEE80211_TX_CTL_SEND_AFTER_DTIM on every bmc
> frame while a single station is dozing, so one client in power save is
> enough to put all broadcast and multicast traffic back on the high
> queue. The chip drains that queue at beacon pace while the frames
> occupy the shared TX page pool, so ordinary chatter such as mDNS
> exhausts the pool and with it every other transmit, including the auth
> and assoc responses other clients need. The AP still beacons and looks
> alive, but nothing can join until the device is rebooted. That is what
> our field report looked like.
>=20
> Measured on an AM62 based AP with an RTL8822BU, one associated client
> in power save, and 40 broadcast frames per second generated on the AP
> itself. Free page count at 0x240:
>=20
>   t=3D0     1803
>   t=3D30s   1148
>   t=3D60s    716
>   t=3D90s     16   <- 0.9 % left
>   ...       16   pinned for as long as the traffic runs

Have you confirmed the broadcast frames ate all of them?

The HIQ packets only send out right after beacon within ATIM
window controlled by REG_ATIMWND (0x055A). Can you try to
enlarge the size to see if it will be different?

>=20
> and at that point dmesg starts printing "error beacon valid" and
> "failed to download drv rsvd page". When the client wakes or the
> traffic stops the pool recovers; in the field both conditions persist,
> so the AP stays dead.

If you stop 40 broadcast frames per second, will AP become available?

>=20
> How to reproduce
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   - any rtw88 USB device as an AP, one client associated
>   - put the client into power save (a phone with the screen off will
>     do; on Windows set "Wireless Adapter Settings -> Power Saving Mode"
>     to maximum and reconnect)
>   - from the AP itself send roughly 40 multicast or broadcast packets
>     per second, for example in a loop:
>       socat -u - UDP4-DATAGRAM:224.0.0.251:5353,ttl=3D1
>   - watch the free page count:
>       echo "0x240 4" > /sys/kernel/debug/ieee80211/phyX/rtw88/read_reg
>       cat /sys/kernel/debug/ieee80211/phyX/rtw88/read_reg
>=20
> Do not ping the client while watching. That wakes it, mac80211 flushes
> the queue and the pool recovers, which is what hid the problem from me
> in the first run.
>=20
> What I would like to do
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Mirror the vendor driver. It never lets chatter into the hardware high
> queue: xmitframe_hiq_filter() in core/rtw_xmit.c admits only ARP, EAPOL
> and DHCP (CONFIG_RTW_HIQ_FILTER, default "allow special"), everything
> else leaves on its access category queue. With the same rule in rtw88
> the pool stays at 1803 in the test above, a DHCP flood still takes the
> after-DTIM path, so the filter is selective rather than a blanket
> disable, and plain join/ping cycling without power save is unchanged
> (10/10 here).
>=20
> The trade-off is that a dozing station can miss non-special multicast,
> since we do not buffer it in software the way the vendor does.

Is it possible to declare IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and
call ieee80211_get_buffered_bc() to get the BC packets to send?

>=20
> Before I post a patch:
>=20
>   1. Is such a filter acceptable as the fix, or would you rather see a
>      hard bound on how many bmc frames may sit on the high queue, which
>      would also cover an ARP or DHCP broadcast storm?

I think it depends on which kind of packets get lost we can accept.=20

The vendor driver considers ARP, EAPOL and DHCP as important ones, because
user experience becomes bad if they get lost, but actually they have
their own re-transmit.

Consider multicast streaming, I guess it has error correction (like FEC),
so maybe it has more tolerant to handle packet loss. (I'm not familiar with
streaming, and no much experience with playing multicast streaming).

>=20
>   2. Or both, filter first and bound on top?

With the filter, I think it will not reason bound, because there will not
be much that kind of packets. Maybe, check bound first, and then filter ?

>=20
>   3. Is there a way to learn the DTIM boundary on USB that I have
>      missed? With one the driver could hand the chip a single burst per
>      DTIM and the pool could not run dry at all.

I think this is not possible, because USB needs time to transmit packets=20
from host to WiFi card, and then it needs to wait for next DTIM. Though
driver can prepare packets earlier, but it will be inaccurate=20
(still buffered in hardware HIQ).


As above, we have ATIM window, BC buffer in mac80211, HIQ filter,
and HIQ bound. But I don't have clear picture how to combine them to
deal with this case. Since you have spent time to dig the problem,
you may have more sense and better idea. :)


