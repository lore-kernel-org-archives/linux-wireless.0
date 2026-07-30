Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EA73B6348
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397546; cv=none; b=oVF0Nuyjoz8EBHLQ+geq5MELX1WLfHwAVqj8/ZEPSuImKZdTiMFRNrnddnnGRY4NsoPxtXV1DZfhMbGDY217vI1orZ42wYsAc7ijYzdTtqKyAqqwfdqZgv/0GFpwpUYdqlpVBT6cpjy/hLFjd+U5TSschNDtW7pddxmwQwxnNgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397546; c=relaxed/simple;
	bh=34GdtLV2kLpfzoYH0LOFN7JLEJTL1ma02Bm8yKw43no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTX2rnXn8dKT+f3elHUCz+2a/RJWp+Kk98AiW2s8IB+z2P1c7dH8hPnFoynAWIf0mCAaRCHO9dnj7jca/sBfPnbrfuOgz8JPsc/ZJwLHL7xmtwubCE3g0qghxqqeHeYqGNdjkuDZI9mIadnGjGtID1b8A8SqPm6Z+yt+ixiynm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WgRS8MrO; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WgRS8MrO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5GqlmurrZI+UAzodTam5xYTbk2+/8ptNeXnVqpdSbEw=;
	b=WgRS8MrOX+9sl9GFaes6gNOwbIEiBJEuBUlR1VVCrajtE8zoo7uHjfXy0rC2Pe8PN/HcfR
	WlFXtEfpy31WSLMLRQZGmo326jPfjTJHW+wGygZmQATSpjITrmPqEa/ZGzWmp7k7Z643Nq
	Y4PHHzgQsWDQAFSBcDVj4kIKOTXnOhk=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 09/11] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Thu, 30 Jul 2026 07:45:02 +0000
Message-ID: <20260730074504.19725-8-luka.gejak@linux.dev>
In-Reply-To: <af51f851a5254faa9caba6b1e04fefe8@realtek.com>
References: <af51f851a5254faa9caba6b1e04fefe8@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 09:21, Ping-Ke Shih wrote:
>> +/* 8723BS SDIO TX FIFO back-pressure watermarks: stop the mac80211 queue once
> 
> comment style.

Fixed, both of them.

>> -       queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
>> +       mod_delayed_work(rtwsdio->txwq,
>> +                        &rtwsdio->tx_handler_data->work, 0);
> 
> queue_delayed_work()?

Changed inside the TX handler, where the work is not pending and
queue_delayed_work() is the right call.

I kept mod_delayed_work() in rtw_sdio_tx_kick_off() on purpose, because
there it can race with a pending retry. If a page shortage has already
armed the work with RTW_SDIO_TX_RETRY_DELAY, queue_delayed_work() would
see it pending and do nothing, so a newly queued frame would sit for up
to a millisecond for no reason. mod_delayed_work() re-arms it to fire
immediately. I have added a comment saying so.

>>         if (ret) {
>>                 skb_queue_head(&rtwsdio->tx_queue[queue], skb);
> 
> This case is also `processed = true`?
[...]
> Can you cleanup the handlers of return value and processed?
> The logic isn't clear to me.

You are right that it was not clear, and the requeue case was the
reason: the frame had been dequeued but not sent, so neither value
described it well. The out-parameter is gone. rtw_sdio_process_tx_queue()
now returns:

   1  a frame was written
   0  the queue was empty
  <0  the write failed and the frame is back at the head of the queue

which the handler reads as

	ret = rtw_sdio_process_tx_queue(rtwdev, queue);
	if (ret == 0)
		break;
	if (ret < 0) {
		if (rtl8723bs && ret == -EBUSY) {
			queue_delayed_work(... RTW_SDIO_TX_RETRY_DELAY);
			return;
		}
		break;
	}

with the management frame restart after it. Behaviour is unchanged; a
non-EBUSY error still moves on to the next queue.

Best regards,
Luka Gejak
