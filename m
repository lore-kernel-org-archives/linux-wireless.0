Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C46B46A603
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649725; cv=none; b=QuWPQ3lN46p/9IA6pn90AbpzYGLb2yx7b5mlq6h6KUeeJy3nHN9B8Xfd3z0XYKD4GA95N+8lfWORcfrRdZFGNC5I5KsohzobfVxWF8RV204RDLxMbkLMUE687olBBJjlAbw/yQDnW3DoWBAOE8zx1/5Rq3Lll4MXrhNSxvPJHj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649725; c=relaxed/simple;
	bh=p8YTM6xTfMhnQGiBcN3CWDDwhvFQiglVybyirCIq3y4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=n9q89q45q9RuV/EOmtEL7j9b4Rij9dYqsssqzuCq/sq4U8XebzCcbVYc+OHa3/DeaGwJLHr7gOjh5CnuLv/tlEVlF4ND3C3LnjNb6pqm+h2Y7+q6ZimiQpbKqoROz+5TKCW0/Q6v39/tHiEGmTD6z8uRhJEPXXhbDJOLvXpWSDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xCrsA7lm; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xCrsA7lm"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784649721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kgqo9p7Y06WA2YxlsqGlLDIGvv1oqAkj767wqdoPcQ=;
	b=xCrsA7lmK6Tx4zr5hmisMwUPP7sFJA+QjCjxX1k7p5gFKJziatiYoqpRg/AyI6M2v7GJd0
	k9SlscBLiuJ4TzMlC6CFAOa7rhwwLDgdn9IyyT7zV9G4W/okWqpv+tXsjsVMKnhgx6VrN0
	/Om4QTXUHM3OSkd8vtlTcwE9W9RUCpo=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jul 2026 18:01:35 +0200
Message-Id: <DK4DINWYSQQK.3687NKGCC6EJE@linux.dev>
Cc: "straube.linux@gmail.com" <straube.linux@gmail.com>,
 "pbrobinson@gmail.com" <pbrobinson@gmail.com>
Subject: Re: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, "Ping-Ke Shih" <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <cover.1784047561.git.luka.gejak@linux.dev>
 <1800080a275f4421b16bd3a028131e8a@realtek.com>
 <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
 <cbaa891f94ce41c7a6a1d576db50b75c@realtek.com>
 <9DAF08C8-7661-4AFB-8676-70AA856E1D0F@linux.dev>
 <7b9bf365-d07c-481a-8c9e-c2e03e326d5f@gmail.com>
In-Reply-To: <7b9bf365-d07c-481a-8c9e-c2e03e326d5f@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue Jul 21, 2026 at 4:47 PM CEST, Bitterblue Smith wrote:
> On 21/07/2026 13:55, Luka Gejak wrote:
>> Hi Ping-Ke,
>>=20
>> Thanks, and noted on stopping the v1 review. Before I send v2 I want to
>> report two things: the firmware experiment you suggested, and what I
>> found when I tried to work out which patches are actually droppable.
>>=20
>> 1. Firmware
>>=20
>> I tried all of them, plus the staging blob:
>>=20
>>   rtlwifi/rtl8723befw.bin      loads, version 15.17.0, associates
>>   rtlwifi/rtl8723befw_36.bin   loads, version 36.0.0,  associates
>>   rtlwifi/rtl8723bs_nic.bin    loads, version 35.0.0,  associates
>>=20
>> So the driver runs on all of them. But the coex reading does not change:
>> BT Rpt stays 0x00000069 on every one, byte for byte. That makes sense in
>> hindsight, since the version is reported by the BT firmware
>> (rtl_bt/rtl8723bs_fw.bin) and relayed through, so no WiFi firmware can
>> move it. rtl8723bs_nic.bin additionally produced 72 RA report WARNs,
>> because the driver sets c2h_ra_report_size =3D 4 for the v41 report form=
at
>> where the siblings use 7.
>>=20
>> Since the driver was developed and tuned against v41 and swapping the
>> blob does not help coex, I am keeping v41 and leaving the linux-firmware
>> submission as it is rather than withdrawing it. If you would still
>> rather I hold it, say so and I will.
>> ,
>> I have not closed the coex question, and I no longer think it can be
>> closed from this driver.
>>=20
>> The driver does ask: rtw_fw_query_bt_info() goes out on the connect and
>> scan paths and at power on. The BT side answers, so this is not a
>> missing or timed out request. The answer is the problem. With A2DP
>> streaming it reports conn-idle and an empty profile list,
>> BT_RSP =3D 01 01 40 12, while the same dump shows 440 low priority packe=
ts
>> each way. The profile byte stays 0x01 (CONNECTION) and never sets A2DP
>> or ACL_BUSY. I checked the decode against the vendor driver, which reads
>> the same byte, so this is not a parsing error on my side, and the coex
>> algorithm itself is clearly running: TDMA case-3, table 10, reason
>> BTINFO.
>
> Does the driver receive BTINFO regularly after you connect the headphones=
?
>
> If it doesn't, maybe rtw_coex_active_query_bt_info() can help. Currently
> it only does something for RTL8821A.

Hi Bitterblue,

Thanks, that was worth checking. I measured it with debug_mask=3D0x40.

It does receive BTINFO regularly. With the headphones connected and A2DP
actually streaming I get 19 Bt_info arrivals in a 30 second window, so
roughly one every 1.5 seconds, and the values do change between them:

  [BTCoex], Bt_info[1], len=3D7, data=3D[01 40 0e 00 00 00]
  [BTCoex], Bt_info[2], len=3D7, data=3D[01 40 11 00 00 00]
  [BTCoex], Bt_info[2], len=3D7, data=3D[01 40 0e 00 00 00]
  [BTCoex], Bt_info[1], len=3D7, data=3D[01 40 0f 00 00 00]
  [BTCoex], Bt_info[2], len=3D7, data=3D[01 41 0f 00 00 00]

For comparison, with BT disconnected it is 1 arrival in 30 seconds. So
this firmware does not go quiet the way the RTL8821AU one does, and
rtw_coex_active_query_bt_info() would not add anything here. Good idea
though, it was the obvious thing to rule out first.

The problem is what is in the reports rather than how often they come.
bt_info_lb2 is 0x01 in all 19 of them: BIT(0) CONNECTION set, BIT(3)
ACL_BUSY never set, no profile bits. So bt_acl_busy stays false and
rtw_coex_update_bt_link_info() logs CON_IDLE 18 times, which is the
correct conclusion from that input. Meanwhile the same coex_info dump
shows Lo-Pri TX/RX at 419/418, so BT is clearly moving traffic.

In other words the BT firmware reports connected, not busy, no profile,
so I do not think this one is fixable from the WiFi driver, therefore I=20
am documenting it as a known limitation rather than guessing at BT state
in coex.

Best regards,
Luka Gejak
