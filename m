Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92AD310784;
	Sun,  6 Sep 2026 03:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788664049; cv=none; b=Ap2r6hSYR181rkY5022FnJ8thQ4vQ/zjncq/97W6qbrrh4Ny83+BgeAJ/OQEfNyqKt6n0ihNyiEVFU697b/HVMBKUa+BOceCLHGIAWAqDkPWMU+qsU/k8WLPmYETlTxHKMHhFWvqVdyS1coAcQuN6EoLXFsqUK9vMjJrLwTvSok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788664049; c=relaxed/simple;
	bh=s0kqTMAn+RuT8RtrzujibazkTEJeZK6Yu5sX3Ozfops=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I/OeDXm2e8ZdCE7NFU+qrV4n0kQrwgacg75U+EoRHI6RmPdcEUvwFXdgRB3AeSwRMZzO+qod1EptbAVMdU5P/gPt0SFzGiXNTz6XXUdYQxjf+rKKjvZ3Nx8+CIfWgCGqA8Pyqy4zK6MbfRWU8f1Qn33WxR+u/0Eq/vJ8F3AyWm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Pn1HjCUq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Pn1HjCUq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68637JnnC1599463, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788664039; bh=AwALmqCFQoGfbpaeExzkavyaY388OD4xrWSxkXSl1Cs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Pn1HjCUqf36xNB4QqtDQr4NQ3E/zLy9bTNr+Kd3540g5cpG4cP5p4SMpFofjbeWx6
	 hqW5rAVAEA5sPmcuSsDO2CqwslhWpjwMlh5m4a+JqQ4NM/6yVFUn/kCyKWWzgvzPr7
	 7HQcBkN4xqOizoKnzIbjLrMFFp5HeRvKifwHh2Q1hKbAF8iBaAhBbplnNTdQ7pYYAr
	 pS4fevhWqJJQTvXotIS2V27pTsPSgsVgeVtnpZPUUourQg6Eo64m4GvdQRRN4Z61xr
	 HscXW5uXhxSIrUeZSxWEi8RKvJxiV3/1Lw865cpZh0rlxnaisJBTzJbX+AdTo8cj+P
	 mfGnrqdzuAxIg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68637JnnC1599463
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 11:07:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 11:07:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 11:07:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILazZGiAgAXJeAD//9pbAIAH9LaQ
Date: Sun, 6 Sep 2026 03:07:19 +0000
Message-ID: <070f9724ca4a42a0b64bbf63724d8cdc@realtek.com>
References: <9209280c3f044363afd884687ae3cb6b@realtek.com>
 <20260901091830.2506562-1-mehmet.fide@gmail.com>
In-Reply-To: <20260901091830.2506562-1-mehmet.fide@gmail.com>
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
> > The HIQ packets only send out right after beacon within ATIM
> > window controlled by REG_ATIMWND (0x055A). Can you try to
> > enlarge the size to see if it will be different?
>=20
> It makes a dramatic difference. Same storm, only REG_ATIMWND changed:
>=20
>   0x02 (default)  pool 1803 -> 16 in ~105 s, pinned  (reproduced twice)
>   0x04            pool never leaves 1803 over 180 s
>   0x08            same, never drops
>   0x10            same, never drops  (reproduced twice)

FYI. I checked vendor driver. Normally REG_ATIMWND sets 0xa or 0xc in AP mo=
de
for chips.

>=20
> > Is it possible to declare IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and
> > call ieee80211_get_buffered_bc() to get the BC packets to send?
>=20
> I looked at how the existing users time the release. ath9k_htc can do
> it on USB only because its firmware sends an SWBA event at beacon time
> (WMI_SWBA_EVENTID) and the driver pulls the buffered frames from that
> handler; rt2500usb has no such event and explicitly refuses to set the
> flag for that reason (see the comment in rt2500usb_probe_hw_mode).
>=20
> Interestingly, the firmware seems to already have the needed event: the
> vendor driver enables a beacon-early C2H report through a bit in the
> SET_PWR_MODE H2C (SET_H2CCMD_PWRMODE_PARM_BCN_EARLY_C2H_RPT, C2H id
> 0x1E), though it only uses it for TDLS channel switching, i.e. in a
> station power-save context. Do you know whether that report also works
> in AP mode on the USB chips, and fires early enough to pace
> ieee80211_get_buffered_bc()? If it does, this becomes the clean
> long-term solution and I would be happy to prototype it.

As you saw it is for TDLS channel switching (timeslot sharing), I
don't think it can work in AP mode...

I will ask USB experts internally to see if there is an interrupt
to notify driver about TBTT (or beacon early).=20

>=20
> For what it is worth, the vendor driver does not use any beacon event
> for bmc delivery on USB either: it parks at most one filtered burst in
> the high queue, lets the hardware pace it out after the DTIM beacon,
> and refills only when the queue reads back empty - in other words, its
> real protection is a hard bound on high queue occupancy, which is what
> patch 1/2 below brings to rtw88.
>=20
> > Maybe, check bound first, and then filter ?
>=20
> Agreed. Here is how I would combine the four knobs:
>=20
>   - bound (patch 1/2): hard cap on how many bmc frames may sit on the
>     high queue (token bucket refilled at what the default window
>     drains, overflow goes out on the AC queues awake-style). This is
>     the guarantee: the pool stays healthy under any storm, including
>     the ARP/DHCP bursts the filter admits.
>   - filter (patch 2/2): admit only ARP, EAPOL and DHCP to the high
>     queue, matching the vendor driver's default. Ordinary chatter never
>     reaches the beacon-paced path, so the bound rarely engages.
>   - ATIM window: given the measurements, a moderate raise (0x04
>     already drains this storm, 0x10 gives headroom) would add drain
>     capacity as a complement. I left it out of the series for now
>     because the queue stays unbounded either way and a wider window
>     costs every PS station awake time after each DTIM - I assume that
>     is why the vendor driver keeps it small and filters instead. If
>     the firmware is fine with a larger window on these chips I can add
>     it as a third patch; is 0x055A safe to raise across the USB chips?

I think yes. The in AP mode, the value is 0xa or 0xc no matter which
HCI type is.

>   - mac80211 BC buffering: the long-term correct PS delivery, gated on
>     a beacon-time event as above; follow-up work, not part of this
>     series.

I will check internally to see if USB has an interrupt for TBTT.=20


