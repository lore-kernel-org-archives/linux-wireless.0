Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1268123507B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787642544; cv=none; b=DR+fxPA3VvD/KlNTeGDHOVQYbxUhyydDnxo9cytp00ZKZDR0BttzKQNEMp7vdMw3Uw5OKAYYOnMN39AFkmleNIz3gpWTQ6iBg+Hqo+leaXcGhffRImElQtnm+0M1lfFsdj8buZ3orsshtdorsoq3HN8Sf1Ko6nwGOQeFqxE1JMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787642544; c=relaxed/simple;
	bh=mxU9wlyRRAMr/gT6bN02/hoVK5/SNJpEhZol6Kygds4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=J+VGM2zydy59elzPBWfVtoiJu/Ig3Kns0eodjoX5s0W07VnK/nv2zzMV7kBA/sl9YtXk6dalo7AmFxzDsHAfuIFpv4G/8kZoT7uljsNGVaAz+12rm3MzO0E0n+Cp7j/iSrLRt6oPGW1ljMhsI81Yr2yoV2NGIPAVI5rhrjTzX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WnxLSFZY; arc=none smtp.client-ip=95.215.58.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WnxLSFZY"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mxU9wlyRRAMr/gT6bN02/hoVK5/SNJpEhZol6Kygds4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787642540; v=1; x=1788247340;
 b=WnxLSFZYDl1/spPj05OUHy2sdBlS2S7Bx1mtSbh8Kl0DpoCEwNV4+IGyVeocq3e3D9VUntau
 6fFnjAgABSM1hfdNmB6yvNVJxhPvHB/yU9bdrlKG2J25pGuCi6Y7pryy+aOKG5Yf5uioHNESDSW
 X27/zqfScOZiumH66TyF7zeQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id f4c8cf3697fdc395;
	Tue, 25 Aug 2026 07:22:20 +0000
X-Mizu-Trace-ID: f4c8cf3697fdc395
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:22:18 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v7_6/6=5D_wifi=3A_rtw88=3A_sdio=3A_add_T?=
 =?US-ASCII?Q?X_back-pressure_and_retry_on_page_starvation?=
User-Agent: Thunderbird for Android
In-Reply-To: <348bea609cee45179ee2a0c7dd03f0d1@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-7-luka.gejak@linux.dev> <348bea609cee45179ee2a0c7dd03f0d1@realtek.com>
Message-ID: <6EA9DEEA-DFF7-4AFC-9C46-55D0EDF256BB@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ping-Ke,

On August 25, 2026 8:36:30 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Eco=
m> wrote:

> With WRITE_ONCE() and READ_ONCE(), I think it will concurrency work
> well=2E Did you really encounter problems with smp_mb()?

Not from a failure I hit, no=2E It came out of reading the code, and I thi=
nk
it is still needed, so let me lay out the case rather than just assert it=
=2E

The flag alone is not enough because of this order:

  producer                              worker
  skb_queue_tail()
  reads len, sees >=3D HIWATER
                                        drains the queue to empty
                                        reads the flag, still false,
                                        so it does not wake
  writes the flag true
  ieee80211_stop_queue()

The AC is now stopped with an empty queue and nobody left to wake it=2E Th=
at
is what the re-check under the barrier is for: once the flag is set, read
the length again, and if the worker drained it meanwhile, undo the stop=2E

For that re-check to mean anything the flag store has to be visible before
the length is re-loaded=2E READ_ONCE and WRITE_ONCE stop the compiler from
tearing or hoisting either access, but they do not order one against the
other, so without smp_mb() the CPU may still perform the length re-load
before the flag store lands=2E Then the worker can read the old flag, skip
the wake, and the re-check reads a length that is already stale, which put=
s
us back at the same stuck AC=2E

So I have kept it, with the blank line you asked for=2E If you would rathe=
r
drop the flag entirely, both watermark helpers become two-line functions
and the barrier goes with it, since ieee80211_stop_queue() and
_wake_queue() are idempotent and the watermarks alone can decide the state=
=2E
I did not do that here because it is a bigger change than the one you aske=
d
about and I would rather not touch the concurrency in this patch without
your say-so=2E

> Can we move below just before the user?

Moved, though not all the way: rtw_sdio_indicate_tx_status() consumes the
skb, either handing it to rtw_tx_report_enqueue() or to
ieee80211_tx_status_irqsafe(), so reading q_map after that call would be a
use after free=2E It now sits immediately before it, with a comment saying
why it cannot go further down=2E

Best regards,
Luka Gejak
