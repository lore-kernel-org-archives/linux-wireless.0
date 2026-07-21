Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8C82866
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784631418; cv=none; b=SwGVMb3pCCxuKmKOyIlbY/8XHbvNFtLTmPE4tJPeGpBU/0E50SZ6u+S45SQCBAOJIBDtFAXcxt/McZurJuB1zqjO5/kvn+oKnFvSRKB2ng8YCeLrxTFxm8FgFBEcXKHiE92AIM6jcys1gYnCEu4F5il3sLo/P7B7lMxu63NO140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784631418; c=relaxed/simple;
	bh=B8V3MC/E2EL0au/EiKI/zAihAfC3IarWgYUy4Lgk/LA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=sAT1Wj7PGB4K5WSLFXF9R0bIjV3ISwvIX3nc5qRc4a4Tqw7j4QzL449ZvR7oh1HoMzPP0jP2lN87DqEa4ouWpirJEZAOn4mp5B70/mztWNjjk2Jt75m5vNSeExfPBD0CRUYIJVveIZ4sHUSaE2lc+WCUbMniravnnfvnzbES9LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NjYzCyjZ; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NjYzCyjZ"
Date: Tue, 21 Jul 2026 12:55:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784631407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RG8mGvYSJiMb8Fh2NHwzWjz+x8iWfd4SkexY/wGOHLc=;
	b=NjYzCyjZBdB4OB349V8mF81Ry8OYJL/BfzfFnlghg7GEXu8qykFdG2kvqZSYOqAlF91pLA
	+KOSapM76+vDVF6gklcAaH9fsfyKKKnmMvun0XDs26pfrV4//oaVYljCBNDLWoZTl5rIzl
	lXXxJx9ByUZOZO4xs4WjvAFJp1Po8gk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "straube.linux@gmail.com" <straube.linux@gmail.com>,
 "pbrobinson@gmail.com" <pbrobinson@gmail.com>, luka.gejak@linux.dev
Subject: RE: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
In-Reply-To: <cbaa891f94ce41c7a6a1d576db50b75c@realtek.com>
References: <cover.1784047561.git.luka.gejak@linux.dev> <1800080a275f4421b16bd3a028131e8a@realtek.com> <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev> <cbaa891f94ce41c7a6a1d576db50b75c@realtek.com>
Message-ID: <9DAF08C8-7661-4AFB-8676-70AA856E1D0F@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Ping-Ke,

Thanks, and noted on stopping the v1 review=2E Before I send v2 I want to
report two things: the firmware experiment you suggested, and what I
found when I tried to work out which patches are actually droppable=2E

1=2E Firmware

I tried all of them, plus the staging blob:

  rtlwifi/rtl8723befw=2Ebin      loads, version 15=2E17=2E0, associates
  rtlwifi/rtl8723befw_36=2Ebin   loads, version 36=2E0=2E0,  associates
  rtlwifi/rtl8723bs_nic=2Ebin    loads, version 35=2E0=2E0,  associates

So the driver runs on all of them=2E But the coex reading does not change:
BT Rpt stays 0x00000069 on every one, byte for byte=2E That makes sense in
hindsight, since the version is reported by the BT firmware
(rtl_bt/rtl8723bs_fw=2Ebin) and relayed through, so no WiFi firmware can
move it=2E rtl8723bs_nic=2Ebin additionally produced 72 RA report WARNs,
because the driver sets c2h_ra_report_size =3D 4 for the v41 report format
where the siblings use 7=2E

Since the driver was developed and tuned against v41 and swapping the
blob does not help coex, I am keeping v41 and leaving the linux-firmware
submission as it is rather than withdrawing it=2E If you would still
rather I hold it, say so and I will=2E
,
I have not closed the coex question, and I no longer think it can be
closed from this driver=2E

The driver does ask: rtw_fw_query_bt_info() goes out on the connect and
scan paths and at power on=2E The BT side answers, so this is not a
missing or timed out request=2E The answer is the problem=2E With A2DP
streaming it reports conn-idle and an empty profile list,
BT_RSP =3D 01 01 40 12, while the same dump shows 440 low priority packets
each way=2E The profile byte stays 0x01 (CONNECTION) and never sets A2DP
or ACL_BUSY=2E I checked the decode against the vendor driver, which reads
the same byte, so this is not a parsing error on my side, and the coex
algorithm itself is clearly running: TDMA case-3, table 10, reason
BTINFO=2E

Those profile bits originate in the BT firmware and reach the WiFi side
over the chip internal link, so no change in this driver can supply
them=2E I am not going to infer a profile or pin a TDMA case to
compensate, because that means guessing at BT state I cannot observe,
and it is the same kind of unjustified special case I have just spent
this round removing=2E I will document the limitation in the cover letter
instead=2E I can say the empty profile list would explain why WiFi is left
with almost nothing, but I have not proven that it is the cause=2E

2=2E Which patches are hard required

You suggested keeping the first version minimal and adding special cases
after it merges, so I tried to find out what the minimum actually is,
by building reduced sets and testing each on hardware=2E

The result is that there is less to defer than I expected=2E

Building only the chip body plus Kconfig and MAINTAINERS compiles clean
with W=3D1, the firmware loads, and RX works: a scan finds the APs around
me=2E But it never associates, because nothing implements the SDIO TX
path=2E

Adding that back pulls in the rest, because the shared code is
interlocked:

  SDIO transfer contract  needs  the association sequence
                                 (rtw_sdio_rx_skb calls into it)
  association sequence    needs  the coex antenna handling, the H2C
                                 interface and the scan/calibration
                                 patch
  scan/calibration        needs  the H2C interface

Taking any one of them without the others does not build=2E Measured on
hardware, with all of them in but without the TX retry patch:

  uplink 11=2E9 Mbit/s, 204 TCP retransmits

and with the TX retry patch added:

  uplink 20=2E1 Mbit/s, 2 TCP retransmits

Downlink is ~40 Mbit/s either way=2E So the retry patch is not a
refinement, it is worth most of the uplink on this hardware=2E

That leaves exactly one patch I can defer, the TX report purge timeout,
and it is this:

  -	if (rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723D &&
  -	    rtwdev->hci=2Etype =3D=3D RTW_HCI_TYPE_USB)
  +	if ((rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723D &&
  +	     rtwdev->hci=2Etype =3D=3D RTW_HCI_TYPE_USB) ||
  +	    rtw_is_8723bs(rtwdev))
   		timeout =3D msecs_to_jiffies(2500);

Three lines, and it only adds one condition to a case that is already in
tree=2E Without it the "failed to get tx report" warning comes back on
slower SDIO hosts, which is what Peter reported on his Pine64 boards=2E I
would rather keep it than defer it, but I will drop it if you disagree=2E

One correction to something I told you earlier=2E I said the auth_sync
mechanism tested removable, and its wait does=2E But the SDIO RX path
calls rtw8723bs_auth_sync_rx(), so it cannot simply be deferred without
also changing the SDIO patch=2E If you want it gone I will remove the hook
with it, I just did not want to imply it was free=2E

3=2E Shape of v2

Unless you prefer otherwise, I will restructure to what you sketched:

  1 add hard required handling for RTL8723BS   (the shared code: main=2Eh,
    reg=2Eh, sec=2Eh, fw=2Ec/h, coex=2Ec/h, main=2Ec, mac80211=2Ec, sdio=
=2Ec/h)
  2 add RTL8723B main body                     (rtw8723b=2Ec/h, tables,
    rtw8723bs=2Ec)
  3 add Kconfig and Makefile
  4 MAINTAINERS

That means splitting the current chip patch, which today carries both
the shared definitions and the chip body, and squashing the shared code
patches together=2E No code is removed by this, it is only re-shaping=2E

The one thing I would like your opinion on before I do it: patch 1 above
touches six shared files and will be large=2E Would you rather have it as
one patch, or split into two or three smaller ones, for example the H2C
interface, then coex, then the SDIO path? I will go with a single patch
if I do not hear otherwise, since the dependency analysis says they
belong together, but it is easier to review split up=2E

Peter has said he will retest v2 on his Pine64 boards and get others
with the hardware to test as well=2E That covers the main gap in what I
can measure here, since his hosts are slower than mine and are where the
timing sensitive paths actually show up=2E

Best regards,
Luka Gejak
