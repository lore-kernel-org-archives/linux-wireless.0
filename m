Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B7B443A86
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787921508; cv=none; b=BuJ7Rxvb74Teg0hIXyuMaPEJFuGT8TSEHetv7gJPMQAbuFiaRlhSenu7eeygQYnRVxRjnkq04PR0evOj99I+Odbhfyx5nOe8l928izzQYfLVhHMNKuQjgsYQq7vr42EFN45Z6Y75vOCJv5jT6uga5BdnTjVrFL9IZfkIZNxYRWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787921508; c=relaxed/simple;
	bh=8W98vqdVKfE7dp9cKK2tjyXef+7Iyvmb7AYrSCT3Hb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz2y0WPScL2qGGJJPHTAUlJD7NvvPtlWssAqBgpVlTESNXrT3DTFwzn8grKG63fwIds6JQnzs/mIqjQZ8ObimySYMK5+7soYhsGTL7HC58ltqyjLQ58VzFubAIiWEdjxl302e40k0Q3tY0mTFns8+GCwTm6nL7OM4DwedWD27mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckKvR7DX; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckKvR7DX"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b9320423cso7674155e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787921503; x=1788526303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GKgfeLMqAUg8eslRWTps4qHRasu8nODkMvH1yUxPj3A=;
        b=ckKvR7DXrS26ieG83xE2+fBatWBJMYMMadVTvMqPZ3bjBLH+G0f+fkxgJ2jaZdlOhG
         KgeOnUuaJJGsesc3JvknT99ZpO7d//ggUQzpapUh7rdPBGNzhKoIlqBhpK38SjvDUqH6
         q5AOrqLQXiOO2UXeB67w8dGSjV7m1AXKTV1CFV4dCt9SwsglvKQuiRWYPhGrv3xO9pOf
         cSWVfCLd8n5nUdmOd6PX84epoWHeRQmADycQld9P3ItAI1jnHCOmkrvhtHM8GhU2FTe0
         0tFRhq6+ixGRBwrv/lm25vjCeU1Z1DkM7aVmX0T3ZItsyiC1miBKP+liainhndurcgI+
         mfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787921503; x=1788526303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GKgfeLMqAUg8eslRWTps4qHRasu8nODkMvH1yUxPj3A=;
        b=aNi9A3KbC8RDQoT+7uw6HmnatYliNo6jGGU/X9Rz4qXfkDvS6OUMV69wJfqB0Raa+E
         3NrABo6ibuUjRfVTE2xI3xj/ny2SZQbA5l7T4Emdzj/jhfKn6lMYhuS2SyJA1UG5Dehl
         P2w5RgyOpvGk8StXj2K/noW45zNNTaLcyUxR6VhWgIbSnU/RRe7sUp7fZMugw59JGa1v
         t1Uho3ZGL8eKheL88lE192g/h6807xFiBwD88KsjpuQvMylmmWhZR5X5FUTXouTSJ6yc
         lFh+HkJv4le1NR8pkWUGOkz7J2A5TEEHwm2tO3EESrG3QE95d/B3dnmX6UxH1ZHVeNqM
         8QbQ==
X-Gm-Message-State: AFuF++kipjOdvTbwIF9JqJ157WrVbJQdUwHhGXAmjFrTx9mTCta3ay01
	2A8w8gIdjndTdEojW4lneSSkchACB3oV5D3obbMaAwFm+DXuDfEvLnDyjVFLMDan
X-Gm-Gg: AR+sD12A8CvAiGasaiLGb40If2r6TYTrMrNuZYrdYfudChsq53k0HHb1DCI+2PwgMi7
	V5eoNKr23V0zt4cspg3JLjJIg5K1MzYJ9l5TUHupRzL41J5y87Wd8/nKUUG3IbZ/9WosXCXhrKk
	yQnnd7OFywZCHK4eoDoDnM4DXwPm1XySFRG/hsNjst39JgNEkZifDAj+oXjHMQUEkhc1f7gjKGg
	UaFihp9DDQgALItJDFqH2+I+V9OPgXuSJeIv5cSrjV+zzA18Q7dbrmfFhv+cTr/10aGeZw6Qo1R
	TWJD5LIpiI05H/3zLwYQOEu6aSX2dDePRyv9/1bSpcWxVKRzIPQ2kDMdkKcsFSva70j2j1x165M
	bd+l/cQGoFmEH7CUVPPh/3H4JnRKUYH+W7YIbN/IRJqxY5uHw3X/TpZBjp+aqGAKU934SxSMZz3
	QrdYgMybQMrtNeaXVwKxn2v90wtnopxshKJvl6EASPY9vbozTFIUUUHM0XJrWoZORCGipGSflYx
	mOEvE7dT+MU0j50Uom2a1tCYSFe9DQS1Sjdav6MO+aDRi3WOWJPOGOmAhubNozwy5+bNWCvC/VL
	4Zm5yyo=
X-Received: by 2002:a05:600c:19ca:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-49b91c47b3dmr95701575e9.11.1787921502954;
        Fri, 28 Aug 2026 05:51:42 -0700 (PDT)
Received: from omarchy ([85.105.43.40])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b497fa9c5sm124804525e9.4.2026.08.28.05.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 05:51:42 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Fri, 28 Aug 2026 06:37:46 +0300
Message-ID: <20260828033746.23039-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <51079deb603845768db7cbe491f40e3c@realtek.com>
References: <51079deb603845768db7cbe491f40e3c@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Is there are version it works well on your platform?
> I'm thinking bisect is a method to find cause.

Yes - and I have to correct my first mail, which said "also seen on
7.0.12". Going back through the system journal and pacman log:

  - 7.0.12 (Arch) ran on this laptop from 2026-06-16 to 2026-08-23. The
    14 boots the journal holds from that period show no wedge episode
    (defined as: DHCP lease acquired, then the gateway unreachable / DNS
    failing continuously until reboot). The few candidates are either
    sessions caught in the separate 63 s regulatory reconnect loop, or
    sporadic DNS timeouts spread over hours-long otherwise-working
    sessions (14-27 timeouts in 0.8-3.5 h), plus one 176 s blip - none is
    the 100%-loss-until-reboot pattern.
  - On 2026-08-23 18:41 pacman upgraded linux 7.0.12 -> 7.1.9 (in the same
    transaction: linux-firmware-realtek 20260519 -> 20260810, whose
    rtw8821c_fw.bin is byte-identical by sha256, and systemd 260.2 ->
    261.2 a few minutes earlier).
  - The first boot on 7.1.9 (2026-08-23 23:37) logged 12 wedge episodes,
    and it has recurred on most days since.

So for a bisect: good = 7.0.12, bad = 7.1.9 (with the caveat that
systemd changed in the same upgrade; I don't think networkd can explain
a per-AC L2 TX failure, but I mention it for completeness). I still have
the 7.0.12 package and can confirm by running it again for a few days,
and I'm happy to bisect the rtw88/mac80211 range between the two if you
think that's the right next step. (Under Windows the same laptop has
never shown this.)

> The full cold power-off boot includes above two settings, right?

Yes. /etc/modprobe.d had "options rtw88_pci disable_aspm=y" and
"options rtw88_core disable_lps_deep=y", initramfs rebuilt, full power
off, and after boot both parameters read Y in /sys/module/. The wedge
still happened on that boot.

> How did you measure the link? CAT-C?

Nothing special: 30-second windows of ping to the gateway plus
"ip neigh" state and "iw dev wlan0 station dump" counters, while
recording the delta of /sys/bus/pci/devices/0000:02:00.0/aer_dev_correctable
and counting RxErr lines in the kernel log for the same window. Examples:
one window had 0% loss with 6 new RxErr; another had 0% loss with 0
RxErr; over that boot 329 RxErr accumulated while the link was fine. And
the wedge itself occurred in a window with almost no RxErr. So I could
not find any correlation in either direction.

> Can you setup another WiFi as monitor mode to capture 802.11 packets?
> Use another WiFi monitor to see if RTL8821CE actually transmitted the packets.

Yes, I will. I need a second adapter for that; I'll do it on a 2.4 GHz
20 MHz network so a simple monitor-mode dongle is enough, and filter on
the laptop's TA/RA. I'll report whether the ARP/BE frames appear on the
air at all, and if they do, whether the AP ACKs them.

> I'm not sure why the size can affect the result. Normally large size
> is harder to transmit basically though.

You are right, and I withdraw the size theory. Re-examining the same
capture by 802.11 access category instead of size explains every frame
with no exceptions:

  - every laptop TX frame that provably reached the AP carries IP DSCP
    0xc0 (CS6 -> UP 6 -> AC_VO): the DHCP DISCOVER/REQUEST frames
    (systemd-networkd's DHCP client marks them CS6) and IGMPv3 reports;
  - every laptop TX frame that provably never arrived is AC_BE:
    89 ARP requests (no IP header -> BE), 13 unicast ARP replies,
    83 DNS queries (0 answers), 2 TCP SYNs (no SYN-ACK), mDNS/LLMNR;
  - sizes overlap the wrong way for a size theory: BE frames of 42-201 B
    all fail, VO frames of 54-345 B all pass.

So the wedge looks like "AC_BE TX dead, AC_VO TX alive", RX intact, and
it persists across disconnect/reconnect and across AP changes (so not
per-association state), cleared only by a reboot. It happened with
power save fully off.

As far as I can tell from reading the driver, BE and VO take different
paths (separate PCIe TX rings per AC, and on 8821C BE/BK on the LOW
TX-FIFO queue vs VO/VI on NORMAL), so a per-AC stall - e.g. the BE ring's
mac80211 queue left stopped, or the LOW queue paused/page-starved - would
match what I see (BE frames silently aged out, VO flowing, no driver
message). Does that sound plausible to you, or is there a more likely
place for a per-AC TX stall on this chip? The monitor-mode capture
should at least show whether BE frames reach the air at all.

When it wedges, besides the air capture, I plan to dump before rebooting:
/sys/kernel/debug/ieee80211/phy0/queues (per-hw-queue stop reasons),
stations/<ap>/aqm (per-TID backlog), and via rtw88 debugfs read_reg:
REG_TXPAUSE (0x522), REG_TXDMA_STATUS (0x210), REG_FIFOPAGE_INFO_2/3
(0x234/0x238) and the BE/VO TXBD indices (0x3A8/0x3A0), compared with a
healthy baseline. If there are better registers or a debugfs page for
the BE ring / LOW queue state on 8821C, please tell me and I'll dump
those instead.

> Please fully turn off power save when you do the tests to reduce one
> factor that can possibly cause TX slowly or stuck.

Will do - power save stays off for all further tests.

Thanks a lot for looking at this.
