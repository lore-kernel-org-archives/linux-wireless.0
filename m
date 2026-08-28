Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8297435675E
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 09:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787910447; cv=none; b=JlICGr9bE4CnIEjtJOFtTgnihM2oUV9FHjtRwd5e6noBvGo3avNk0UVX3TxfJ/O8a21+aDGG29gJV8gCJ/Dx8adIg65qXK50ylf52f4+BQSAxQbLgOSBXCEzIZiXoPv3Cq/4mYjzF1zHEKHyN3Ix1HujFYtpEYAfH6YTmYqfS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787910447; c=relaxed/simple;
	bh=e2tq/2mp/rNEDN4L24NTPonrqDPRQjbDqRitpaYNyjU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=X5zO0CHT23N/csWIK5lVId7hYGzSSFgoENV7I1Z9l6ZcqKnL/Zy/wvu3rVBOArnl6QN6KsG1BbrqjuWCs79S/lkC3t25iN5GhY7pZwxTKnkZGvkIpP/zoRhmGM1YI5JJIbGDqnjmieEM4cyCKum67d9vjDfVBbKK7Xo1CKYWfWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kCIopN4M; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kCIopN4M"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e2tq/2mp/rNEDN4L24NTPonrqDPRQjbDqRitpaYNyjU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787910443; v=1; x=1788515243;
 b=kCIopN4MwssuJf6/js/6iQSBuimUle+n//ZaHJZkqePCjhvwt7LYHzXiVMxE2N8kjt6IidnV
 nwdwU9UPYF/6rRu91LPZQ99q7yn91jXNK5IGSlIMj8fMbWjAY+Mz0YfsuB91+M3/ec523eB/ah/
 Ydw143ZI96+3XxqkIoap9UxA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 656fa8ba58c7583a;
	Fri, 28 Aug 2026 09:47:23 +0000
X-Mizu-Trace-ID: 656fa8ba58c7583a
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 11:47:21 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v8_6/6=5D_wifi=3A_rtw88=3A_sdio=3A_add_T?=
 =?US-ASCII?Q?X_back-pressure_and_retry_on_page_starvation?=
User-Agent: Thunderbird for Android
In-Reply-To: <abbadda4537640eab1bce5620ade5f47@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev> <20260825163314.1590-7-luka.gejak@linux.dev> <abbadda4537640eab1bce5620ade5f47@realtek.com>
Message-ID: <FCC54106-9CBC-4987-899B-4C7E0C997063@linux.dev>
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

On August 28, 2026 11:29:29 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ec=
om> wrote:

> At the last review (I think v9), I will focus on the changes of this
> patchset doesn't affect existing chips=2E

That is the right thing to focus on and it is the part I cannot test, so
let me set out what the other parts actually run, and correct something
in the v8 cover letter while I am at it=2E

New code that is not behind rtw_is_8723bs(), all of it structural:

  sdio=2Eh                   struct delayed_work work
  rtw_sdio_init_tx()       INIT_DELAYED_WORK(), mutex_init(), and
                           mutex_destroy() on its error path
  rtw_sdio_tx_kick_off()   mod_delayed_work(=2E=2E=2E, 0) in place of
                           queue_work()
  rtw_sdio_deinit_tx()     cancel_delayed_work_sync(), mutex_destroy()

Only this chip ever arms a delay, so on the other parts the work is
still queued immediately, and only this chip ever takes the mutex=2E

Two existing functions were also restructured and every chip runs
through them, so I should not describe the above as the whole story=2E
rtw_sdio_process_tx_queue() now returns a value instead of void, and
rtw_sdio_tx_handler() uses it=2E The behaviour is meant to be identical
for the other parts: on an empty queue the new "if (ret > 0) break"
takes the place of the old skb_queue_empty() break, and on a failed
write the frame is still requeued and the loop still retries, since
rtw_sdio_8723bs_reschedule_tx() returns false for anything that is not
this chip=2E That is the piece I would most like you to check=2E

Two things I verified against the base commit that I will spell out in
the v9 cover letter rather than leave implied:
rtw_sdio_check_free_txpg() differs by exactly one inserted branch ahead
of the existing 8051 test, which becomes an else if, everything else
unchanged; and the generic path through rtw_sdio_write_port() is step
for step what it was, same address from skb->len, same
sdio_align_size(), same check, same transfer, same failure message=2E

The correction: the v8 cover letter says patch 2 is "gated on the SDIO
interface rather than the chip id"=2E That was true of an earlier version
and I did not update it=2E The code you have uses rtw_is_8723bs(), so it
is gated on the chip id as well, and the sentence understates how narrow
the check is=2E I will fix that section in v9=2E

One thing that would settle this better than any argument from me=2E rtw88
already supports five other SDIO parts that share sdio=2Ec: RTL8723CS,
RTL8723DS, RTL8821CS, RTL8822BS and RTL8822CS=2E If anyone on the list has
any of them, a boot and some traffic with this series applied would
answer the question directly=2E I do not have that hardware=2E If nobody
does, I will say so in the cover letter rather than let it look tested=2E

Best regards,
Luka Gejak
