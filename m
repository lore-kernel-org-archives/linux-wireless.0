Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2164F18FC80
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792190906; cv=none; b=EObts4r+I3GI5pS81AZ5saxjUv25Nyhs7lWRs+/V9+CF6V1PPunNmd96XVGfQnI8/pHGrAFi8Dp/28WQJ/4j52mUCUp1w7v/Nou1fta8OWlyK5MFolsbj293YzUqWpa1+NKg5jzXjwDHzO7KoE91alDpmpnodsZrnbAKb7bPm+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792190906; c=relaxed/simple;
	bh=+gA638rtqsJQs67WBNocIrZSS+Fsh3ZGdCCXETyBUgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNQz9yeKZINpTalsT19UEd9wI0ho7PBktFmV664KfTGP2VaEi9zr7E6nqzupXoESTUTAZxjFNdZLYo4iy3o52xnAAmT+zYgZ8BKTRolISyQnWajyMHFub+M9wGrlXyuSzdetzkR2F/rob0F9CRB4y5x0prIfgRQ14QohFs0o/U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEmqVddw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEmqVddw"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a01933b584so3547045e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792190903; x=1792795703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QlW5rCF1LOEaE/EVtHAefF4nPUnJV/cigAGGhcLiuB4=;
        b=CEmqVddwaZhglM6iQ7urMfsMIzgM6XPMMYedMmKqR62jy24VnhBVukcfChJCJIk/vi
         85oR6n+ue6xIn4lLrJl7yGWhFvKNfF6O3YTUk4m/aQnoaF+aqEoG3rO5XEYHAqsqf4B3
         Np8qH6J1DA1JR5BSQev6hAd687JkqLCTp3mmL4qkT1d08OHO0e06dSLpE6ZOByBcOSGD
         BDW/fTzWtqFYkh/4pg95aUHr1QhjS9ZZTXnPVZChhCTC8JsMhLqz7UyRZRvHEa+zH08Z
         ncqvKhJgEGF0Bk71yv03qNJq+MdBzGeNRLNos6sUBtsEs1D8zhrOJCnjWRZ/vNX5Ja/I
         dXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792190903; x=1792795703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QlW5rCF1LOEaE/EVtHAefF4nPUnJV/cigAGGhcLiuB4=;
        b=HPacT7vPGsJc5jNOwgW0tWkNlAHNAtKT983IYGyYGKY3kMRNklPQlHARYHD13wP2IF
         hjhTZquLHh1McQRLQV3Osp81Kmu+QQRqOZAIKYHP+pO3nRTj2gPmkDyCiDE98p63BMa0
         4W17tzOmNOzjXDCx2sw+nrkdXPsWX/zYoYHByrwup80fu/hOzF9kEsNn3lw5SCcEE6It
         8hdzttnrz/i9FqFTGTErbC1/r7ban2tL0clup1kWq78L9ONALt1/1uX03s+WXIfDr3Cz
         pe2gKOxGqkf2l8lOc7/I8eglz743MbfcpdOuCwkQ62kaxGKhDLch7DEukbHdBJjZ1Ciy
         qYPg==
X-Gm-Message-State: AFq9FYKHgse0u6eAuAM61ws2gmEn2ozQQ83PkOLQnVapJ3m3si+3ost9
	K45F3ipAUHH7DIcjz7SAQneDfRW8LVJVCXOAYMMlI1HLxlTI5jmH5fiSiIkcxA==
X-Gm-Gg: AYBFou0ip+hRr4BKtRcKFowbmpKFL1u/T6boYgDzp5F1DlhPrnt5gLhBX92PpojrNWn
	9KhYILxdudLTPt4m/QPS/iaIx28DBFDKH6bnQ/1ZCt/3vjmItpYwlBZk7fJGZ2pURT2IzngKwOu
	0+kGxjp+z9zM94/RwJDGm8yA0ibOTmzk08m2pn0sPMEFg/rok8DItAIWmJkPmw7CCVCGVLqG3b+
	ykWuX0oSjaklOjP2SVM6XN5K7S2yPeiuXxOuilimYu7v5its9Y44zxBbeQ4mvm6/D7yAu0BdUo2
	NI6GJKoIS3I9CrhMvhnrocrE1JvsSSlq0s06fKyBEPbLLSICfA4I4NoNElA3TKAArRXLm2A67Mx
	gOeYorfPj1rVXvbWKIz6TTmdvFtQwNOoTSXoz4bcPPWcQX+27/EmcPqDlcErtPe8lDEMv+/Y6BG
	I3yKSR5JjLSsvTve4bvy8f6sTsfRMoe9kLKtW3IcDEMuen2TWD4A6tHCX2+pnExHZIZ7Fx+uvab
	aRt1PVluYCp4EJHrqDDx7ahQYlVEMfCZSLefLso1XvXeHT9SYIgJueA3Y4jTGFMBhN8wC4tq4rD
	9hcQWVDughcwXRVqQA7f2A==
X-Received: by 2002:a05:600c:314f:b0:4a1:d41a:afbc with SMTP id 5b1f17b1804b1-4a1d7608492mr26393395e9.23.1792190903062;
        Fri, 16 Oct 2026 15:48:23 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d0e2bb8dsm63358285e9.2.2026.10.16.15.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 15:48:22 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the rings are reset
Date: Sat, 17 Oct 2026 01:47:56 +0300
Message-ID: <20261016224756.20687-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c15cbcb38aed477ab8d4c06ce30b174d@realtek.com>
References: <c15cbcb38aed477ab8d4c06ce30b174d@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I re-think ring->queue_stopped and restart work. I feel the flow
> should be [...]
> I'll discuss above flow internally, and give back to you.

I traced the three steps against rtw-next. 2.1 looks more necessary than
I expected, 2.2 I need one clarification on, and 3 is v3.

2.1. ieee80211_restart_hw() does stop every queue, but only after the
teardown has run:

  rtw_fw_recovery_work()
      __fw_recovery_work()      <- rtw_enter_ips() on its last line
      ieee80211_restart_hw()    <- queues stopped here

RTW_FLAG_RUNNING is cleared in the rtw_core_stop() that rtw_enter_ips()
calls, so for almost all of the teardown neither flag test blocks a
frame - not the one in rtw_ops_tx(), not the one in
rtw_ops_wake_tx_queue(). And the guards do less than I thought. rtw88
does not set STA_MMPDU_TXQ, so in STA mode mgmt and nulldata fall to
rtw_ops_tx(), which frees the skb as I said last mail, while data goes
through .wake_tx_queue, which frees nothing - those frames stay queued,
and __rtw_tx_work() tests nothing at all.

The reset does unlist them - rtw_sta_remove() and rtw_reset_vif_iter()
call rtw_txq_cleanup() on every sta and vif txq - but those calls sit
just above rtw_enter_ips(), and the flag is still set until
rtw_core_stop() clears it, so .wake_tx_queue can relist a txq in
between; for AC_VO it runs __rtw_tx_work() inline. rtw_core_stop() does
not cancel tx_work, so one queued in that window can still be writing
descriptors and ringing the doorbell while the MAC is powered off.
ieee80211_stop_queues() at the top closes the TXQ path too, because
ieee80211_tx_dequeue() returns NULL on a stopped queue. So I would
keep 2.1.

The one thing I would check in 2.1 is the reason code.
ieee80211_stop_queues() uses IEEE80211_QUEUE_STOP_REASON_DRIVER, which
mac80211 does not unblock by itself - restart_hw() picks SUSPEND
deliberately, with the comment "use this reason, ieee80211_reconfig will
unblock it". And ieee80211_reconfig() can return before
reconfig_complete() is reached: if drv_start() fails it wakes only
SUSPEND and bails. A DRIVER stop taken in 2.1 would be left set on that
path, with step 3 never running.

2.2. There is no ieee80211_wake_queues() on that path today - pci.c has
one, in rtw_pci_io_resume() - so I read "(but not call
ieee80211_wake_queues() if restarting)" two ways: either the reset gets
a wake beside it for the callers that are not a restart, gated on
RTW_FLAG_RESTARTING, or the reset stands alone and step 3 owns the wake.
Which did you mean? The flag fits either way: it is set on the first
line of __fw_recovery_work() and cleared in rtw_reconfig_complete(), so
it is set across the whole teardown, rtw_pci_dma_release() included.

With a wake for the non-restart callers I have no question. With the
reset alone, that path is also reached outside a restart: rtw_enter_ips()
when mac80211 goes idle - which is how the restart itself gets there -
and rtw_ops_stop(), for a plain "ip link set wlan0 down/up" and for
suspend. Step 3 covers only the restart: ieee80211_reconfig() has two
callers, ieee80211_restart_work() and __ieee80211_resume(), so a down/up
never reaches rtw_reconfig_complete() with any reconfig_type at all. And
rtw_leave_ips() -> rtw_core_start() does not wake anything either.

Clearing the flag itself costs nothing, and it is what I offered last
mail - after rtw_pci_dma_release() the indices are rewound and the skbs
freed, so count is 0, and for as long as mac80211 holds a DRIVER stop on
that queue nothing completes, so the wake branch inside
rtw_pci_tx_isr()'s loop cannot run whether the flag is set or not. What
persists is mac80211's DRIVER slot, and that part is self-sustaining:
while it is set neither path reaches rtw_pci_tx_write() -
ieee80211_tx_dequeue() returns NULL for the TXQ frames, and
ieee80211_tx_frags() parks the rest on local->pending[] instead of
calling .tx - so nothing sets queue_stopped again.

3. That is v3 and the part I have measured. Luka Gejak's point from the
v3 thread sits here: rtw_reconfig_complete() also runs after a plain
resume, with RECONFIG_TYPE_SUSPEND. If the wake does go away there,
covering both types would close the resume case; the down/up case needs
something else, for the reason above. v3 stands on the list in the
meantime, and I am holding the respin until you come back with the flow,
so your decision and Luka's points land in the same version.

Your other two questions were in the bug thread; bringing them here as
you asked.

> could you describe how you resolve the stuck (by the method of your
> previous patch, maybe v1)?

Nothing the driver did on its own. Over the five events, power save off:

  rewrite the TXBD host index   0/3   read index never moved
  ip neigh flush                0/4
  iwd reconnect, new PTK        2/4   cleared 08-28 20:32, 09-06 03:17
  ip link set wlan0 down/up     1/2   cleared 09-14 17:48
  reboot                              always

The ladder stops at the first step that works, so the denominators are
not comparable, and the down/up row carries the caveat I sent on 3
October: on 09-14 19:09 the reconnect did fail - the AP answered status
30, "rejected association temporarily" - and the timeout at the down/up
step was my ladder giving up after 25 s rather than the outcome. The
journal has the interface up 3 s after the down/up, and the station
reassociated, with a fresh lease and no reboot, some 90 s after that -
but through iwd's own autoconnect, which it had fallen back to at the
status 30, eleven seconds before the down/up. So I cannot credit the
down/up with it either, and I have left the row at what the probe
measured. The doorbell rewrite is the patch I withdrew.

What the five do separate is narrower: nothing short of tearing the link
down ever cleared one. The two steps that never worked leave the
association alone, and every step that did clear one tore the
association or the interface down and rebuilt it - the down/up through
the driver's own rtw_ops_stop() -> rtw_core_stop() path. I cannot rank
the reconnect against the down/up, because the ladder gave the reconnect
the earlier attempts.

rtw_fw_recovery() also tears down and rebuilds, through the same
rtw_core_stop() -> rtw_power_off() -> rtw_hci_stop() -> rtw_pci_stop()
-> rtw_pci_dma_release() path. In the controlled stall I sent on 3
October it did reinitialise the ring and still left the BE stop reason
at 0x1, with nothing back in the 90 s I watched, while the same script
with patch 1 cleared the reason and had traffic back within 2 s. That is
the one measurement I have that bears on a workaround, and it is
narrower than it looks: the restart also cleared the REG_TXPAUSE I had
set, and in the field TXPAUSE was 0x00 already.

One thing I should flag before you read the dumps. My ladder pokes
debugfs fw_crash anyway, so nine of the captures print
"rtw_fw_recovery() tetikleniyor" - Turkish for "being triggered" - six
on 27 September, two on 14 October, and one where the knob was not
writable. Eight of them follow it with "fw_crash ->
ieee80211_restart_hw: 100% packet loss". Both strings are labels my
script prints for that rung, not anything the driver reported.
rtw_debugfs_set_fw_crash() never calls rtw_fw_recovery(): it leaves deep
LPS, sets RTW_FLAG_RESTART_TRIGGERING and writes REG_HRCV_MSG, and
recovery is entered only through the C2H path I described on 3 October,
which matches your point that the knob only takes effect on 8822C. So
nothing was triggered and nothing was tested at that rung. Section 4 of
the six September dumps also reads fw_crash as 1 before that dump's own
write, because the file prints RTW_FLAG_RESTART_TRIGGERING and only
__fw_recovery_work() clears it; all six are the same boot. The two
October ones are later boots and read 0.

> I suggest to turn it off for all experiments

Agreed. It is off at all five, and no dump since 01:00 on 1 September
records it as on - partly by construction, though: the watchdog forces
it off at the top of the same 20 s pass that takes the dump, and it has
had to do that about a hundred times since, because an iface down/up
returns it to the kernel default, as I said in the bug thread.
