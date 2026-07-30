Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4573A8730
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397544; cv=none; b=q6TyfH69KRy5zPOXsgyHZKzs0K5+rabyrWocm1MyRLfmfw3PyjpP7CIkSgj4kxL2+Np0KWDqxG6PeGQuN7YhvXq0//HsYkqb8YUQx0SQ01viB2pw93s7Z/XKNI9dpuDvpCZkNBm3O1N8DWdCl3yBxX1HnpTfbFQGjkv53/tSzMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397544; c=relaxed/simple;
	bh=gj9+kNKRkV3nWB45telUVAls9tz5dAFxbb+IDLln3hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fht6aR6HQ+I6Vl0F/I6xcVJIVjFyEOMV8bP8ihYK9Iw5nqMLPdsyrDUogyzkp2N42OG5M5tu54vx4yb+c9KthfGbO4gF4zXvRXvIKcDTcsfeyWRaqUp/S5QwGKN0msKWEUPmAwR8wR4aPqbjXpqMbQdxiWlYZ5YjkkDqsVXj368=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cp4yXQD+; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cp4yXQD+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDgkfuDMQ7MkSSpSDhadNVZZKx6lFg1RamWCeqeTi2g=;
	b=Cp4yXQD+qdvRWSmev53GSkJvkNdrAoUc1kQkRoodmNhrIP1zAcoORcJM//XIv9cdkqjSJx
	a8WWnCmua1P2GwcDjjt87naTHGhKc84+iqhbh41fAY+cyMGuryQ25nr+vbLUrJSYnQR6CA
	TESwbnj8LDLcOkxlsL0KoErtGfxGZ3A=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 07/11] wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
Date: Thu, 30 Jul 2026 07:45:00 +0000
Message-ID: <20260730074504.19725-6-luka.gejak@linux.dev>
In-Reply-To: <cc9251b01235422e8b5a22fc0997b0f7@realtek.com>
References: <cc9251b01235422e8b5a22fc0997b0f7@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 08:52, Ping-Ke Shih wrote:
>> output queue token count that rtw88 does not track at all.
> 
> Does OQT mean Output Queue Token? Could you explain a little bit?

Yes. REG_SDIO_OQT_FREE_PG is how many more descriptors the chip's SDIO
output queue can still accept. On this part the chip discards a write
that arrives when the count is zero, silently, so the frame is lost
rather than retried. The vendor driver polls the register before every
port write; this patch caches the count and only re-reads when the
cached value is exhausted. I have rewritten that paragraph of the
commit message to spell it out and dropped the "OQT" abbreviation from
the prose.

> I think this can largely improve SDIO. Please share the performance
> numbers before/after this patch.

Added to the commit message. Measured against an iperf3 server one hop
behind the AP, using the wlan0 byte counters as ground truth because
eth0 on the test box shares the same subnet:

  without this patch: TCP and UDP both 0 bit/s in either direction
  with this patch:    TCP 25.3 Mbit/s up, 37.3 Mbit/s down
                      UDP 25.0 Mbit/s up at 0% loss

To be clear about the "before" number: on the generic path the
association itself still completes, but no data gets through at all, so
this is not a tuning patch. The transfer sizing in the third hunk is
the part that matters most there; without the block size padding the
chip stops accepting writes entirely.

>> +static void rtw_sdio_init_free_txpg(struct rtw_dev *rtwdev)
>> +static void rtw_sdio_sync_free_txpg(struct rtw_dev *rtwdev)
> 
> _8723bs_ specific so add to the function name

Renamed, along with rtw_sdio_wait_tx_oqt() ->
rtw_sdio_8723bs_wait_tx_oqt(). The shared field decoding is now
rtw_sdio_8723bs_store_free_txpg().

> It is clear that bit masks of REG_SDIO_FREE_TXPG are PG_{HIGH, NORMAL, LOW,
> PUB}. Let's define them in reg.h, and use u32_get_bits() to read out the
> values.

Done, in sdio.h next to REG_SDIO_FREE_TXPG since that is where the
register lives:

  #define BIT_FREE_TXPG_HIGH	GENMASK(7, 0)
  #define BIT_FREE_TXPG_NORMAL	GENMASK(15, 8)
  #define BIT_FREE_TXPG_LOW	GENMASK(23, 16)
  #define BIT_FREE_TXPG_PUB	GENMASK(31, 24)

and read with u32_get_bits(). That also removed the duplicated decode,
which is what let me answer your next question properly.

>> +               dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
> 
> Why do you check ` dedicated < 0` for this case?

There was no good reason; the queue does not change between the two
calls so the second result could not have been an error. Rather than
add a second check, rtw_sdio_8723bs_free_txpg() now returns the
atomic_t * for the queue, so the mapping is resolved once, NULL is
checked once with a warning, and the resync path just re-reads the same
counter.

>> +       bool rtl8723bs = rtw_is_8723bs(rtwdev);
> 
> reverse X'mas tree

Fixed.

>> +       if (!ret && rtl8723bs) {
> 
> move to else-branch below?

Done, it is now if (ret) { warn } else if (rtl8723bs) { account }.

>> +       if (fifo->acq_pg_num <= pg_tbl->hq_num + pg_tbl->lq_num +
> 
> second and third lines don't align.

The sum was computed twice with different formatting, so it is now a
reserved_num local used in both places.

>> +       rtw_sdio_8723bs_check_rqpn(rtwdev);
> 
> Should we check chip is RTL8723BS before calling?
> I'd have consistent the calling rule -- callers check?

Agreed, and applied across the series. rtw_sdio_start() now has the
test and both helpers assume it.

>> +       atomic_t free_pg_high;
> 
> Could I know the reason why these should be atomic_t? Which context are
> they running?

Two contexts. The usual one is the TX work, which is single threaded
(create_singlethread_workqueue), so on its own it would not need them.
But rtw_sdio_write_port() is also reached from rtw_sdio_write_data()
for H2C commands and reserved page uploads, which runs in process
context under rtwdev->mutex and does not go through the TX workqueue.
Those two share no lock.

The counters are a fast path hint rather than an authority: whenever
they claim there is not enough room, rtw_sdio_8723bs_sync_free_txpg()
re-reads REG_SDIO_FREE_TXPG before the caller gives up, so a lost
update costs one extra register read and nothing else. I have put that
reasoning in a comment above the helpers. If you would rather have a
spinlock around the group I can do that instead, it is not a hot path
in the sense that would make the lock cost anything.

Best regards,
Luka Gejak
