Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8B2381E87;
	Wed, 19 Aug 2026 00:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100299; cv=none; b=a7numqxm3pcxoq+J8bmx8P4/L9yx46KszXN0bgN9VIL9DEBBLSb7qHXcY7SkBQdmh+7SbXdtbC9qM90TVZ5aqN+vrJMuF63OtFIwTy5cI5Sj3/D831MLAHxtXsm6Z3QeL27tNUOe6QLCJQct21DefIIWoozUtMKQa/GxOcuaAw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100299; c=relaxed/simple;
	bh=Q0rGBKEaTEfMgppYIP6u50KBVUOr8IjEmDS7q53YqZ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HmxZVKqggWGnMZ2COz3CpVefgvHRL3/AVVuDqfiTPi/yf6KSciVZr6TPFK6E0GmVqQaWfGYxUU9YShgoyQgLVkkeMq54jW2HqizET0rWTPhyxfv7ZOPAANKAZDlJWWrjDYGsxqtgjyRHkEoiRGFsM38BnckweNIlUOW/hMC4WpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mjtyOV2Q; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mjtyOV2Q"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J0idZkB1919425, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787100280; bh=YIgH7WGXuX9LZcgSE+FkDY9bkIDK3XpmWCfpD8qmN9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mjtyOV2QK7O5YtL7u9M3ZkIoAv/k8n4Ay5yKYX96CaoDgkE/CjgVLXCAAwz3bJJYR
	 3gByjotMFUx+xRRubAZTSAr6E4RRJUAl52koOaBKdBTWsYAohrazUmtEx5iDDGuJun
	 J3PlyEhLKwXp4xmuXBzvFsLe/5gZwyvTWWe86EUDgACXvgazYDR6H8I970vP8NCajQ
	 TSwKWz8rC0hjYVIwWf+RSzBZ4HjcHVkmJvphwsYs5RXxyXhfZ5NK3333d4obiZmMq7
	 Ma3eJsGM2dkPLa03tyylpW8W4qH+lV64XTsDRoo2mkXheBBkO6pDiWoKG6TczBPv46
	 dJpaPJzUFZBKg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J0idZkB1919425
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 08:44:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:44:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 08:44:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Topic: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Index: AQHdK9s24o7nvN7toUOll3UaGdFmtbakj2pw
Date: Wed, 19 Aug 2026 00:44:40 +0000
Message-ID: <99f04f89fb584e97807ef5470a37d0fd@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
In-Reply-To: <20260814105327.6687-1-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> Changes in v5:
>   - Dropped "fw: handle the RTL8723BS management TX reports", which v4
>     had restored. It cannot do what its commit message claimed. This
>     firmware does not advertise FW_FEATURE_LPS_C2H, so
>     rtw_fw_leave_lps_check() takes the REG_TCR polling path and nothing
>     ever waits on the C2H completion the patch rerouted; and with the
>     driver instrumented, 93 TX reports over three scans all arrive as
>     C2H id 0x03, with no event ever arriving as a top level 0x12 or
>     0x32. Bitterblue Smith made exactly this point on v1 and was right.
>     A tester on a Rockchip RK3288 board confirmed the timeout patch in
>     this series is enough on its own. This is the fourth correction of
>     something I had claimed on the list; restoring it in v4 was based on
>     a tester reporting that a branch containing it cleared the warnings,
>     which showed the branch helped, not that this patch in it did.
>     With it gone the series no longer touches fw.c.
>   - Power save is now enabled on the test machine, so LPS is exercised
>     there. The v2 entry below dropped a patch that gated LPS entry on
>     smoothed throughput, partly on the grounds that LPS never engaged on
>     this setup at all, which was never a sound reason to drop it. It is
>     measured now, paired against this series in one session with power
>     save on: 60 idle pings average 5.1 ms without the gating and 6.0 ms
>     with it, and TCP is 30.0 down and 19.1 up against 32.3 and 18.9. It
>     makes no difference, because the gate tests the smoothed throughput
>     and interactive traffic rounds to zero there, so it never fires in
>     the case it was meant to help. It stays dropped, now on a
>     measurement rather than for want of one.
>   - sdio: fixed a transmit stall in the back-pressure patch, found while
>     auditing a tester report of transmit stopping under bidirectional
>     load with receive unaffected and nothing in the log. The TX work
>     item was only re-armed when a transfer failed with a page shortage.
>     Once the mac80211 queue can be stopped, that is not enough: a
>     stopped queue is handed no further frames, so on any other failure
>     nothing would kick the worker again and the affected access category
>     would stay stopped for good, with the link still up. It now also
>     re-arms on a failed skb expansion, which together with the page
>     shortage covers both of the failures that produce no log message.
>     The remaining errors are each logged where they happen, so unlike
>     those two they are visible rather than an unexplained hang, and they
>     keep the existing behaviour rather than being retried forever.
>   - rx: the zero length test now evaluates pkt_stat->pkt_len first, so
>     the unlikely case short circuits before the chip test.
>   - sdio: the commit message now says what OQT is, as far as the vendor
>     driver reveals it: the vendor calls the register the OQT free space
>     and never expands the acronym, and it holds the number of further
>     transfers the SDIO output queue will accept.
>   - sdio: rtw_sdio_8723bs_sync_free_txpg() now returns whether the chip
>     reported anything and is the only caller of
>     rtw_sdio_8723bs_store_free_txpg(), and
>     rtw_sdio_8723bs_init_free_txpg() returns an error rather than
>     nothing. Working through that suggestion found a real bug: the
>     public pool size was computed as acq_pg_num minus the reserved
>     queues with no check, so a chip that came up with no transmit page
>     allocation at all would underflow a u16 and leave the driver
>     believing it had about 65000 free pages. That calculation is now
>     rtw_sdio_8723bs_pubq_num(), shared with the queue page allocation
>     repair path, and it fails cleanly instead.
>   - sdio: the output queue wait is now bounded by a jiffies deadline
>     rather than a loop count, so RTW_SDIO_OQT_TIMEOUT_MS really is a
>     timeout in milliseconds. It was 1000 iterations of a 1 to 2 ms
>     sleep before, so the name was only approximately true.
>   - sdio: rtw_sdio_8723bs_check_rqpn() returns an error instead of
>     silently doing nothing when the transmit page pool cannot cover the
>     reserved queues, and rtw_sdio_start() propagates it. Both early
>     returns are now explained: a non-zero free page count means the
>     allocation latched during power on and must be left alone.
>   - sdio: fixed the interrupt acknowledgment. It masked the status word
>     with both irq_mask and RTW_SDIO_HISR_CLEAR_MASK, but for this chip
>     irq_mask is REG_SDIO_HIMR_RX_REQUEST alone and that bit is not in
>     the clear mask, so the two had no bits in common and the driver
>     acknowledged nothing at all. It now masks with the defined bits
>     only, which is what the comment described. Thanks to Ping-Ke for
>     catching this. Retested on hardware.
>   - sdio: the back-pressure and wake conditions moved into
>     rtw_sdio_8723bs_stop_tx_queue() and _wake_tx_queue(), and the two
>     requeue sites into rtw_sdio_reschedule_tx_work(), instead of long
>     conditions inline.
>   - sdio: rtw_sdio_process_tx_queue() now returns 0 on success and 1 for
>     the empty queue case, rather than the other way round.
>   - sdio: queue_stopped[] renamed to tx_queue_stopped[].
>   - RTW_SDIO_TX_RETRY_DELAY is left as msecs_to_jiffies(1). Ping-Ke
>     asked whether it becomes 0 when HZ is below 1000; it does not, since
>     msecs_to_jiffies() rounds up for HZ < 1000 and returns one jiffy.

If you can add these notes along my comments, it will be easier to me.
Not only your reply, but also I can reference source code again to
reconsider my comments if needed.=20


