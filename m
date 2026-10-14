Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4521A453
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941989; cv=none; b=JVxVwNTyIR/i3UUxg9Y6ijouOkXStNTlY/qQajD/lbV1kZpE0+CJbhMBMaaExy7UJUixOjsdRS1UKgZZ4U0GmkVbhP3X9paXRJP6IniPW/awkzWPPhyVQqBba25za92NabxUMKy+H+DVxijcjcsmZIR56Vju64+DSiwY4Yx8lcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941989; c=relaxed/simple;
	bh=2Lgc2rAGQ2JbaoEMh1qFK+fi4BxNegZdox03MFHPLKk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jMRM2qKNKwpYDcz2M8K6fs1ONK6w5DTsYjxKfHDsGtKASJcNC4YyR6j+ZVRnBdcw9EcogPJ81iArqqBcS+d2s2H8Hu4a8koDWnfPLkOd2dr+UbKHmZWDj1HTUaf1mYN9hiWeH8tN5M10OdYM4v/8FLnj7MDyexjVGWBQqKQYKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mKfL8vOh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mKfL8vOh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69E1dgVdB1176564, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791941982; bh=bZ+o8aGoW6oDmtHlB/JhEbUQbroEMt2VXrhweiM7rTE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mKfL8vOh8vixIockHU10wZ/YmXtp5dNGbgDk9WtTnXeYxjcaEAAipN8fDBPV2F3Kj
	 1MkmRLxfwXZtLQI9kOUyBa+jx2nD5c3E5KNJ99V/jfXXNL/n2Qh5fVWhgg9xV/Lgd2
	 u5ggnbz+Nw0fqz53EHEZJsok6ctkj3EUWSC7nlbTAOj65v/IuzVLBOZ0g8AuRFd0X5
	 hlcrgF1n0rvzuYehKgseq//A7PX3ltbHTZLyDF4mCeznqd38navpj/HhAMgX7KncIw
	 5LSH5lZeNB5ueK4EVqC3UMVjnDPumMrbkFPjX9RHgLe00265Fryej7qdjVYwZ6C0UT
	 +ZJAYvKQHmn3Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69E1dgVdB1176564
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 09:39:42 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 09:39:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 09:39:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 14 Oct 2026 09:39:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Topic: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot)
 with station power save
Thread-Index: AQHdNXenhFnJjakLnk6yTA3qd/0xArawGJIAgAK8rSD//3bjAIAFLEIQgAMNvYCABnUbAIAa7DWAgAFB57CADWw6gIADzgMQgAiHcgCABaA3IA==
Date: Wed, 14 Oct 2026 01:39:42 +0000
Message-ID: <ff87de261ecf43f78776baf48c7e6865@realtek.com>
References: <91866c4b0baa40f4a8af787d7a5ae690@realtek.com>
 <20261010193208.295640-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261010193208.295640-1-abdurrahmankaradag19@gmail.com>
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
> > could you please give summarize the causes you found and the solutions
> > you adopted?
>=20
> Two things, and I only have a fix for the second.
>=20
>   (a) The BE TX ring's hardware read index stops advancing. The driver
>       keeps submitting until avail_desc() drops below 2, and from then on
>       the ring-full path holds the queue stopped. Why it freezes is still
>       unknown.
>=20
>   (b) ring->queue_stopped is cleared only by the completion loop in
>       rtw_pci_tx_isr(). That loop does not run while the read index is
>       frozen, and a ring reset rewinds the indices, so nothing is left
>       that could complete and run it. The queue then stays stopped for
>       good.
>=20
> v2 of patch 1 fixes (b), with ieee80211_wake_queues() as you suggested. I
> have nothing to offer for (a). Patch 2 is dropped rather than resent.

Okay. Let's move discussion to the patch.=20
(Two interleave threads are hard to read.)

>=20
> The five events from my 3 October mail stand unchanged: the same five,
> power save off, REG_TXPAUSE 0x00 in every sample.
>=20
> > Can you dig why REG_TXPAUSE becomes 0xff?
> > I wonder this is the cause PCI TX gets stuck?
>=20
> It is station power save, and it is not the cause.

Got it. Thanks for the info.

>=20
> Nothing in the driver writes it on this chip. rtw8821c_mac_init() writes
> 0; rtw_core_enable_beacon() returns early unless ap_active and only
> touches BIT_HIGH_QUEUE; ps.c never references the register; the 0xff in
> rtw_wow_bb_stop() is unreachable because 8821c declares no wowlan_stub;
> and 8821c has no act_to_lps power sequence. The other writers are in chip
> files an 8821ce does not load. That leaves the firmware, which enters LPS
> over H2C rather than by writing 0x522, so there is no host write to
> catch.
>=20
> The correlation is clean. Of 48 register dumps, the 6 taken while "iw dev
> wlan0 get power_save" reported on all read 0xff; the 42 taken with it off
> never did. REG_CR agrees: 9 of the 11 0xff samples read 0x043f instead of
> 0x06ff, and the difference 0x02c0 is BIT_MACTXEN, BIT_MACRXEN and
> BIT_MAC_SEC_EN cleared.
>=20
> But it is neither necessary nor sufficient for the stall. All five events
> read 0x00 with power save off. And 08-29 04:35 reads 0xff with the BE
> ring filling and draining normally - read index equal to write index in
> every sample - and the link was still 100% lost. So I am dropping this
> line.

It looks like you did experiments with power save on/off cases.
I suggest to turn it off for all experiments, since you are trying
to narrow down the cause.=20

> The monitor capture I still owe you. I will stop promising it against the
> next event and send it when I have it.

No rush because it might be not important clues to dig why TX gets stuck.

Though we have not found cause, could you describe how you resolve the
stuck (by the method of your previous patch, maybe v1)?
I'd think the workaround a little bit.

Ping-Ke

