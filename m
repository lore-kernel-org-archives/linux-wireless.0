Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DF93A5456
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647370; cv=none; b=b8wuYWoQnPZsC3rUnkzgF6yxhQDrrI3U8PZlKUfQpWjAFKA5Zqo0eUclEV8LkvCkxbTpe3j8EMOdOJ1qXrpJREaGf2rIkVRPjTRGlmHtA0coPsOb2aVGRYgIO9kTvRk9CFzPFMzea5a5ItPddRRUORqJDoLMVDO3jLdKtQPUHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647370; c=relaxed/simple;
	bh=OMGHS4R+GPams+T6tLYy9IGqdYxo/MP3iV5hufih0CE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=NPRMPHqm/qjadpMRDbT5HG/SOuCdclYCxKnWxvqfJ0xhJKJSYuoqyUxYWjsJJmzSmUKTqFKud36vRO2+ycYwHdC8btiVVAer4rc+zSWhfCcVA7632M5VNvoPeryu/tSNPeDCHHqaTe8ZSUjk9LZo6ras/7ORdz0Yqi+SLuGT77g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R9UD8mO+; arc=none smtp.client-ip=95.215.58.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R9UD8mO+"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OMGHS4R+GPams+T6tLYy9IGqdYxo/MP3iV5hufih0CE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787647366; v=1; x=1788252166;
 b=R9UD8mO+JLl0coLiR5GeH623EIqAO4VUkf39QfEYyJQkshkRgwyhBVvyKKfgyti4Uzb/poDg
 P1v9dfq982VQQaR4Ebdgb+Gc526l+ly4dA78rlLJs8Eau6E+ipoyLusDKPI8xUU4TBTDbk3KrO0
 vWIhEB7gD6KVxi2QxZ4xXQPI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id 89a7c3342a250548;
	Tue, 25 Aug 2026 08:42:46 +0000
X-Mizu-Trace-ID: 89a7c3342a250548
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 10:42:43 +0200
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
In-Reply-To: <bb13c730fce14d7bbd54a3e5f7f21a2d@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-5-luka.gejak@linux.dev> <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com> <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev> <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com> <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev> <68a844f5ea2b4eea827da95080a9dbcb@realtek.com> <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev> <5c6d6a1826334966a4f0893ad306fba4@realtek.com> <2776B724-A5C6-4068-BFB5-3F0EC981F650@linux.dev> <bb13c730fce14d7bbd54a3e5f7f21a2d@realtek.com>
Message-ID: <971ADD2E-3336-473E-ADC9-1E16D32B416E@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 10:38:15 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Eco=
m> wrote:

> Let's review it by v8=2E Please help to mention this by change log=2E

Will do, the v8 change log for this patch will say that the transfer moved
into rtw_sdio_write_to_port() and where the alignment warning ended up=2E

> Okay=2E

Thanks, I will leave it at warn then=2E

On your other mail about the back and forth in patch 6: you are right, and
pci=2Ec is the better model=2E It takes irq_lock around the check and the =
stop
in rtw_pci_tx_write(), and the wake side runs in rtw_pci_tx_isr() with the
same lock already held by the caller, so the two cannot interleave=2E That=
 is
why there is no smp_mb, no READ_ONCE and no undo anywhere in pci=2Ec=2E

I will do the same for SDIO, using the tx_queue spinlock that
skb_queue_tail() and skb_dequeue() already take, and drop the barriers,
the _ONCE accessors and the re-check entirely=2E That really does change t=
he
locking, so it needs retesting on hardware and v8 will follow once that is
done=2E

> By the way, I'm not so familiar with SDIO code=2E Just learn by reviewin=
g=2E :)

It is working well enough, you have found real bugs in it=2E

Best regards,
Luka Gejak
