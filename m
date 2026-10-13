Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ABC4E77FC
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 22:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929349; cv=none; b=RcnInIuJbxAoiHrUpguqcVYSJhb0tyBu01Ez+Uvy+z/JblWkVExS8e1K9ScvR6/uTyqNKpWDS7bVaT/IEuDeO4+XIIjEaqc0SLcbd6cNi42BedV6xpQ/AaF1N4P0v5WHzNwj7hUZXZlaDLmZepQHIkT2+FZNg6h6D4i1tk+u+c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929349; c=relaxed/simple;
	bh=PYBC4PYddErwzreL9d7e3W9N6VWcJLYl+RxspMecDL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiNjKQqiT3exCobfslUM2Sq8/f/MWIFEBNrmjuxlFYtm5cMyK2a0oyv1lbo6vrtcXRFOWSiDCfpXyGskxK5Y2HI8HUFAMOSUTc28R0lNoVXWse0aJhX22czIW1F2fIdVbllXGecHOhTSMStY5g2TmQw7DCBZN169y/ywvO7CD9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjL8+cDj; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjL8+cDj"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a16bc2278aso24566005e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 15:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791929347; x=1792534147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r16N6Bcquou4n0SyVmg+6OcVew17A2VRLXfMymweVaQ=;
        b=pjL8+cDjoTQ8WLJuHir77S2HONUyz3AyF16x6KbZb2jPtbBgq4LlWslhUAcRQrvr1W
         0eXteTX3/RqwlJJxH9ku3CrKSEtR7+BzmE0lOfb1TetIano9O/ibiTVJuKtLHrDO9jwy
         SyoayDoyVuQutNgs3nAhCHddT7b1LfBRk/541TuOxBDqdfsA8Wzcbfj7Ru1Gsny7+1bQ
         M4hn8h6JePmOHT5zObk/tfK2PUMLFsBT/fh8mYs8Vo8qHsZuDz6+cPIjRhwaepidUKQP
         I6qO6xwk1scejU4lBjEI1fPxl7SCUEEGffxQmjNju9C5UfG4ibPp2uqTuTbfS4sbpLGi
         rNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791929347; x=1792534147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r16N6Bcquou4n0SyVmg+6OcVew17A2VRLXfMymweVaQ=;
        b=VT8kchL4eUAKyVg004eL1wVZDkoEMNvyY3P3L23ru2KbwvQUN9DIC5T7TLRsqYivKN
         N3GutFXPEba5avRFLM3SB3w6b9IGB07pXlkG/dT7j9+ZLjSXp7ABzYoLCY7FwOMWNLIF
         l6xUZHPe8hpsOHufqqNzkoF7gwDe8fJQvAjwQeIR8b5E1LzJgWpp5/3wonFpYyMsD+16
         kijVMqHCnCdumLe4fyAKKTiI4USqgpdheBJuMqpYd/rN+hsEQZK+rwZylnRT7Fmu5U6k
         dFpNJPJLsdZbbaS3mf0xCv9RxMpW2AtyR7THQvgJ9U6MKl/Exl+li+IumN+Yqdg8dQnp
         /zog==
X-Gm-Message-State: AFq9FYIUBQwESvUfeJ5TvA/LR0CCsAqTg/i7tluOtZwkaOflu/cBTJwl
	7mKWurIGDSzP73oMLlqm+ACKfSGRztPysr2IGpYmnYHauwkqIY4Fa0CQWQLnXsnn
X-Gm-Gg: AYBFou3upAwwkdmcgThtzmNXdTaRi1ZXDzDPKzKHylLzv+hhVarjzeZX+LGYWuGpubs
	mEZa2UjBdSySu5oAko9WifbxVw8ltc/aGIUnAi9BgVGdtcUeRvKLG8Q/K1s9MInQpkh9M6y4fUU
	BOSoz1Z573PpmeLAyhLNABsY7EasYzwTL7Zl1dIsXkPzjQ1XvxMvCWW2+nivegqep4nTjQTEuos
	oWUMGZV1Z318f+mpAGG5BVmpqgqNW5pBgsRRptOnDD4YsXnnsNArFzC/4LLW/9qeTjG8ZOl+8IC
	+ZBCePgDWmwwIol+4CSqWhthyMFch5gOW0Lx9td4+eY0CYjNuiOnTJx5sjxFwzJcQnBH3aiyY+m
	6LTjRhOfmX0bvEZeX6Fsjp1+r+kR8NMT1eJF9XrYYqzkOZpuaGqFTGZoOHy6uAq3NMmw3evWNVU
	zeWCVZBpyqkaHSokWYzBN9WsFSqFg4az/elSEIgDwgUKNVKSeEQ7CrfQyeO9/f8/bc7iqoVhj3a
	X8X5d46lLAC5/9eUT+4FX8GsdINBhDdB3TsjH/bNw32DDLz5LR/YrQH56Xvyrz8kSsIT7EMHCJu
	gLI/qwOJHkB7xdop7bHg6LQ=
X-Received: by 2002:a05:600c:6388:b0:4a1:ac66:5ffe with SMTP id 5b1f17b1804b1-4a1ac666396mr67570285e9.15.1791929346529;
        Tue, 13 Oct 2026 15:09:06 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de77b35b5sm1627717f8f.21.2026.10.13.15.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 15:09:06 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the rings are reset
Date: Wed, 14 Oct 2026 01:08:39 +0300
Message-ID: <20261013220839.39149-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <02b86ed0d0814f009cb5ca83bae343c7@realtek.com>
References: <02b86ed0d0814f009cb5ca83bae343c7@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I'm thinking if here is too early to wake up queues. Should we do this in
> rtw_reconfig_complete()?

It is too early, and rtw_reconfig_complete() is the right place. v3 does
that.

On the reset path rtw_core_stop() has already cleared RTW_FLAG_RUNNING by
the time rtw_pci_reset_trx_ring() runs, so anything mac80211 hands the
driver between that wake and the end of the restart is freed again by
rtw_ops_tx(). reconfig_complete() is called from the wake_up label in
ieee80211_reconfig(), where the comment reads "If this is for hw restart
things are still running". It also makes the fix bus-independent instead
of PCI-only.

I measured it at the new hook before sending, with two builds of current
rtw-next that differ by nothing but this patch, using mac80211's own
tracepoints instead of a register read. Under load the BE queue is
stopped by the ring-full path, then rtw_fw_recovery() is called:

  without the patch
    511.499278  stop_queue  queue:2 reason:0      DRIVER, left dangling
    511.501625  stop_queue  queue:0-3 reason:4    SUSPEND, the restart
    511.957404  drv_reconfig_complete reconfig_type:0
    511.957411  wake_queue  queue:0-3 reason:4    only SUSPEND is woken
    AC_BE stays 0x00000001, 100% loss

  with the patch
    475.930915  drv_reconfig_complete reconfig_type:0
    475.930925  wake_queue  queue:2 reason:0      10 us later
    475.930926  wake_queue  queue:0-3 reason:4
    AC_BE reads 0x00000000, 0% loss

So the wake lands after the restart has completed and before mac80211
wakes the SUSPEND reason itself. No TXPAUSE write and no injection this
time - the ring fills on its own under load, which is also why I am happy
to leave the measurement out of the commit message.

One consequence I should flag, since v2 covered it and v3 does not. A
plain "ip link set wlan0 down/up" also reaches rtw_pci_reset_trx_ring(),
and mac80211 never clears a DRIVER stop on interface down - nothing
outside the stop/wake helpers touches local->q_stop_reasons[]. So with v3
a queue stopped before a down/up stays stopped. Is the restart case the
one you want fixed, or should a down/up release it too?

I also left ring->queue_stopped alone. It stays set until the first
completion after the restart, which clears it, and rtw_pci_tx_write()
does not read it before stopping a queue, so a stale value costs nothing.
I can clear it in rtw_pci_reset_trx_ring() if you would rather the driver
state did not claim a stop that is gone.

> As I see, the commit message can be very simple -- wake up queues for
> ieee80211_restart_hw() case.

Done, and the subject names it now. The measurement paragraph is out -
you are right that the stall belongs elsewhere.
