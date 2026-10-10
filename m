Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7BC4B405E
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791660755; cv=none; b=uhevSzmC+F/sbVULQl6mhMs9E9E3Kv4YWM0rwC1x0eGr6t0x7Y9iQj81eEou4z6U8bNjISHb66HoD/tAiL9IA1vj6BpICPHDe/otmYgXHPe2M9h4ZLvV+XcgX1gaEtppzaOnkm7ESrP5capU7EMGB0yAVNV9DWB+PhnhpTfPsDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791660755; c=relaxed/simple;
	bh=Dk08cb/g9NJdhjFfwsSG71cQUKStumvt+jd5Tovufj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2FWzSUayRoZ7WMvgaU6Y9KcmFsftevyeQhe5j05sAbSpo74LinE1hONSpsOoqTSum+q1t8AEaN52Rl7YLX4wBcH6RHcxqQt6ZU1HseLfX09Z/Xs9DeMYYaqD+kh3BM7ze62t30kYXmZCxb4nYcg/HnmDC2enqKm0/igkTKJKgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8VQ9757; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8VQ9757"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1688d7769so6192635e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 12:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791660752; x=1792265552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=im2Z7dJoZ26/tWLQjbeVBurC/b9QUS5n6Zv90LAY54I=;
        b=f8VQ9757t2252IbXbe0kLYY/qeo0zfrf4x13A9ERcQP11Pp+4OXC18qphgwTXplvhl
         eRMBGKT6/9T3wkiL8xUFcl5jVolTsCOA/CVTqqSF72NmwFtIGOvW9O5QxkpYAm3Q+SUV
         7/roSsz4bc8tKJeunPNXi/Nm7bHzhOfl9oZbKyiVrHQlKNg1L3LOJVc/JIjaEPOAZkgW
         OkkiMjrV+47I27mG69u769t1BX6t+sKaLbW2RA0s+LDlkgpeV5pFnGdtlLyzg2CJfHXS
         xIdlKINdDMZNaiEejf5ZIbB/stQ77vuINu/nXKhAfaB7Lc+JroVUNvB3EV1W1l3VsG4I
         pG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791660752; x=1792265552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=im2Z7dJoZ26/tWLQjbeVBurC/b9QUS5n6Zv90LAY54I=;
        b=dg32j2Zk97yiNBbBd2cSch0zNWEk0imftT79UUL48HHRgJKbLjEEYDWPlEtcJMRjZB
         fhM3YZnVnH2PgFMeLADF4KSCtQ8zw+Tf5Jk76e1d1X7AOblTs2wTU0enVFOVvz6qroT+
         Hfy7AZVbqmixfENKgJBPDR2yoeRh8gaBCbR2Hhm4G5zugp6hjry53txAHwNpMc5HIzsp
         znyfxHOBkITeoal6eSjeJ5HzYea4ZGZmIPlcDQrm+2sScXnEjcFLuiY5PAkaKRxACFkQ
         lVWhR2rPaFwTOdeAf+fLMxVYJFXlJ0rwJtH8EJnzSZ1k+UnH/jhyS8FF5q5YPPZE1S77
         VwSg==
X-Gm-Message-State: AFq9FYLL/oTJoz6b0f5SvUZG/hvMbXJhyKncUODkwZ80nZJNYoPanyxL
	X08+RVZvG4vyHMGkhXqJJ0642gKXdN7U8yz5UrrQzTA8dCMXybxf2cVxdIEBdA6J
X-Gm-Gg: AYBFou03iIzVMLQdpbiBDzeWXJ/QKshviMpkSs5LIsjmkoHgZ3yChkvt3enKtj3u1J7
	XOitu7oaAjoEhFDvCli3iWboA9PcL6aDfOclTwjFDMpdQa3t6WJE5APh8B84t6cVEWThqax0wSR
	orpa08B7MQ5BLUtlzYYNpucCYOiGZEOUvgv/TGx+h9ReazIM20JbHAJjH1ZOf4KP5vJVf/ytWHS
	mKyEanAIIC655tzYydYkDgeGrcR2hoyq+a002Xu0yUyZUJLFSIRtzo4SE8+kP+KLk5ssyCwlSSa
	MXmbfXSlsqWKX+T7p7AH7/RnumqtQhnscJjUsXt3q3PfaVR2nG7n5cf039iCGU4NNl4ktyxxf38
	kdMfgiMlBwwLPhxCiC9q9Qo4vrH916wkHH00rU+rHkmAo1Eroc7aEodQ3OSNYgHbraFjls2BGW7
	+8gL3QrQAXsZf0a3MDgIgZ6HGd2b/slRKn4waEOqfuwYUNLeoW+UO9seKBGTRQpfZ3k+3tBWr77
	MYMeA5G94GDVhqe+QQBSdFka5JdEr1/cH378n9ClvKrpte3igPGMJIG8rq8/3dmPsV6wq0R/b1c
	sWdDpbugv297irJ0A5+xSA==
X-Received: by 2002:a05:600c:8b09:b0:4a1:6f78:842f with SMTP id 5b1f17b1804b1-4a18e4987b8mr109600815e9.11.1791660752401;
        Sat, 10 Oct 2026 12:32:32 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb68abfsm165231315e9.0.2026.10.10.12.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 12:32:32 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	rtl8821cerfe2@gmail.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Sat, 10 Oct 2026 22:32:08 +0300
Message-ID: <20261010193208.295640-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <91866c4b0baa40f4a8af787d7a5ae690@realtek.com>
References: <91866c4b0baa40f4a8af787d7a5ae690@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> could you please give summarize the causes you found and the solutions
> you adopted?

Two things, and I only have a fix for the second.

  (a) The BE TX ring's hardware read index stops advancing. The driver
      keeps submitting until avail_desc() drops below 2, and from then on
      the ring-full path holds the queue stopped. Why it freezes is still
      unknown.

  (b) ring->queue_stopped is cleared only by the completion loop in
      rtw_pci_tx_isr(). That loop does not run while the read index is
      frozen, and a ring reset rewinds the indices, so nothing is left
      that could complete and run it. The queue then stays stopped for
      good.

v2 of patch 1 fixes (b), with ieee80211_wake_queues() as you suggested. I
have nothing to offer for (a). Patch 2 is dropped rather than resent.

The five events from my 3 October mail stand unchanged: the same five,
power save off, REG_TXPAUSE 0x00 in every sample.

> Before rtw_fw_recovery() isn't a solution, queues will not be
> relevant, right? It looks like the recovery missed to consider doing
> wake up all queues if any queue stopped.

Yes, and that is a better description than mine. Three captures have the
driver's stop bit set on BE, all three with the read index two ahead of
the write index, so avail_desc() is 1 and rtw_pci_tx_write() stopped the
queue exactly as you describe:

  08-28 22:05   0x3a8 = 0x003c003a   the dump you quoted
  08-30 09:12   0x3a8 = 0x001c001a   read index frozen, down/up timed out
  10-09 07:41   0x3a8 = 0x005e005c   read index still advancing

08-30 09:12 is the one patch 1 is about. A down/up reaches
rtw_pci_reset_trx_ring() through rtw_core_stop() -> rtw_power_off() ->
rtw_hci_stop() -> rtw_pci_dma_release(), so patch 1 would have released
that queue. I cannot prove from the capture that the stopped queue is why
it stayed down, so I am not claiming it. Patch 1 fixes the recovery, not
the stall.

> Can you dig why REG_TXPAUSE becomes 0xff?
> I wonder this is the cause PCI TX gets stuck?

It is station power save, and it is not the cause.

Nothing in the driver writes it on this chip. rtw8821c_mac_init() writes
0; rtw_core_enable_beacon() returns early unless ap_active and only
touches BIT_HIGH_QUEUE; ps.c never references the register; the 0xff in
rtw_wow_bb_stop() is unreachable because 8821c declares no wowlan_stub;
and 8821c has no act_to_lps power sequence. The other writers are in chip
files an 8821ce does not load. That leaves the firmware, which enters LPS
over H2C rather than by writing 0x522, so there is no host write to
catch.

The correlation is clean. Of 48 register dumps, the 6 taken while "iw dev
wlan0 get power_save" reported on all read 0xff; the 42 taken with it off
never did. REG_CR agrees: 9 of the 11 0xff samples read 0x043f instead of
0x06ff, and the difference 0x02c0 is BIT_MACTXEN, BIT_MACRXEN and
BIT_MAC_SEC_EN cleared.

But it is neither necessary nor sufficient for the stall. All five events
read 0x00 with power save off. And 08-29 04:35 reads 0xff with the BE
ring filling and draining normally - read index equal to write index in
every sample - and the link was still 100% lost. So I am dropping this
line.

> I'm confused. REG_TXPAUSE is 0x00 for below cases? Or it becomes
> 0xff?

Of the 24 captures that sampled it, 21 read 0x00 in every sample and 3
read 0xff in at least one. The three are the power-save-on ones, and in
two of them both values appear seconds apart, so it is a transient rather
than a state the device sits in.

> The debufs fw_crash only can take effect on RTL8822C.

Understood - that matches what I traced on 3 October, and it is why I
called rtw_fw_recovery() from a debug build instead.

> It is enough to make sure you have disable_aspm=y and
> disable_lps_deep=y, and do cold reboot before testing.

Both have been in /etc/modprobe.d since 24 August. The capture records
them now rather than leaving me to assert it - this morning's reads
disable_lps_deep=Y and disable_aspm=Y. The cold boot is still owed:
that capture has 39 h of uptime.

One correction: I said HISR0/HISR1 were sampled "twice two seconds apart
next to the TXBD indices". They are read once per capture, in a later
section, and have been there since 27 September. They also say less than
I hoped - HISR0 reads 0xe1100000 in all seven captures that carry it,
none of those bits is in rtwpci->irq_mask[0] so nothing clears them, and
every TX-done bit reads 0 because rtw_pci_irq_recognized() write-1-clears
each masked bit on every interrupt. To tell whether one stays asserted
during a stall I need irq_status[] logged from inside
rtw_pci_interrupt_threadfn(), which I am adding.

The monitor capture I still owe you. I will stop promising it against the
next event and send it when I have it.
