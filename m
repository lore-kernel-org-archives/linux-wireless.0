Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C2A383329
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646737; cv=none; b=CCvSWLmSlLbkKMG/k2/XkyRHfllpo0kiKuz9nbHRHUamisVnc5lkWnZ1VKs5Okndc3AIOzZyyZ52znpnx99HVcBiR7SCLWWRmH/8tpeish/w5bdugd5ZHXr/MHP4BMhcEHa1fdB6WL0vkTcTl/6nhqJd/oLTXTvcjmlmhg8DZMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646737; c=relaxed/simple;
	bh=8Rsz+a5wXUsBYjuss7PLL7p77KJPmzZO7vA9P5Yq0KI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=nX4BmIjHvac/2faeS6rVyIjEcYuFzBTyoCuaZDeEI2iX5TxS/kxWOAiARpFvE+ggsBx65QTxItfV0RTy0yeIUaJBaXUwoo6zcfpzVP8vO28vx4wc7KQW9f++Kohiz/gwq06A+Smnktrd1hYMMB4xmh0ffNrmZYB1ABFgt+IMZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vFUJOOH7; arc=none smtp.client-ip=95.215.58.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vFUJOOH7"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8Rsz+a5wXUsBYjuss7PLL7p77KJPmzZO7vA9P5Yq0KI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787646734; v=1; x=1788251534;
 b=vFUJOOH71AVof2mc4Eqawct6EwFDHxaSzENLIZaEA/1tM0z2x6UubOsFotlhEpApwgSYQzSB
 xPAY8UdU9Vq2DfG3Fd3bgkjsLCszt2w2BjSPEoskOFbXVscCwTbgBRaaOevLwUDEyo5NOzbNI0K
 58ikh8Qd1EoIQZo2ungaOSLU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id c3a1ce48f45f0779;
	Tue, 25 Aug 2026 08:32:14 +0000
X-Mizu-Trace-ID: c3a1ce48f45f0779
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 10:32:06 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v7_4/6=5D_wifi=3A_rtw88=3A_sdio=3A_track?=
 =?US-ASCII?Q?_free_TX_pages_and_OQT_credits_for_RTL8723BS?=
User-Agent: Thunderbird for Android
In-Reply-To: <5c6d6a1826334966a4f0893ad306fba4@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-5-luka.gejak@linux.dev> <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com> <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev> <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com> <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev> <68a844f5ea2b4eea827da95080a9dbcb@realtek.com> <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev> <5c6d6a1826334966a4f0893ad306fba4@realtek.com>
Message-ID: <2776B724-A5C6-4068-BFB5-3F0EC981F650@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 10:22:53 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Eco=
m> wrote:

> But I don't find rtw_sdio_write_to_port()?

My fault, it does not exist in v7=2E It is a function I added in v8 while
splitting the locked region out for guard(), and I asked you about it
without saying that=2E Sorry for the confusion=2E In v8 the transfer moved
into rtw_sdio_write_to_port(), called from both the generic path and the
8723BS one, and the warning had to go either inside it once or in both
callers=2E That was the whole of my question=2E

> Is this a normal case? Can current sdio=2Ec handle this properly?
> If so, I'd change to debug level=2E

It should never happen=2E rtw_sdio_tx_skb_prepare() aligns the pointer
itself: it pushes the packet descriptor, and if the result is not aligned
to RTW_SDIO_DATA_PTR_ALIGN it pushes the difference as padding and tells
the firmware about the shifted offset=2E main=2Ec reserves those 8 bytes i=
n
hw->extra_tx_headroom for SDIO so the push always has room=2E So by the ti=
me
rtw_sdio_write_port() runs the pointer is aligned by construction, and the
check is really an assertion that the alignment step did its job=2E

It has never fired here, across all the testing on this chip=2E

So I would keep it at warn rather than debug=2E If it ever does fire it me=
ans
the alignment path above is broken, and the transfer would go out with a
misaligned pointer, which is worth being loud about=2E But it is your code
and your call=2E

Best regards,
Luka Gejak
