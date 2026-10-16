Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACD52931EF
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 22:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792190974; cv=none; b=mfa8Wd+QvWbKU0vwGhhnxJ0FbhwDcZJAF0m9xB7TY10p2nfCFa89XBwpVM4GZLrS/ckyUclIcl5ZEmpz8/UX5nrzAz/EA8aQOtLsWQBe+twRyQidsV4LAsRXinLMyxUg96RSNbdeMOrZSvK7FW87ZiXEhV0frQn3KWAIA0v2gRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792190974; c=relaxed/simple;
	bh=/tc040OS2f+w/mas9qF0QuTJKcxxq0J8OJybyI2iiEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9JblkYo/3WaDnmKVLSvq7JaqhgTdSu6GMA2wPp+jVYPmrNRj69kYO0PfbI66mUUgG0ZoRsgp0ttykE7Rh2CYJB7GJUZCrmA/Y2dXr6wbdOU+QUHbw90TuN2po5iaGnUkwPpUTU4gebL+qLlwk7pbbkuzig7MMmE+D3qputSSJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFbW8Kef; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFbW8Kef"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so3074115e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792190972; x=1792795772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XeJG4nYwSGiw5/AWkFsrqpbT1l5smvCe5L2Gqo0ZInE=;
        b=CFbW8KefamXmwu257EIduOj/+Z/xLRKlZ0V5qT468nX5A3D4xvG89ppzwstgSWVfno
         OT/Prg+BNAbMsLR+OophCJSKZxNpmEIh9+rQUBtzpkBdMAwvGXfSzroYxw7+w1H09Rf/
         LV7tBHinZE0Ufx+NJ4OEznY/5S2IKaekpzjnJyTksAlEDxPz4jbi6gdKfiM2eSm9aCBL
         9/jwStbw8RFFbn5K4sfjvoKYR9/0Qd9zaJWWTgaAwwe5XcKivOFi8GPoEaC6QcK4oi7d
         4BmMyDlgfV+gq9nGrqcBTzMCPQekq/BYqg6l2NaeRofu6DvhPZNawgnlQN8QjKuFR6OA
         LrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792190972; x=1792795772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XeJG4nYwSGiw5/AWkFsrqpbT1l5smvCe5L2Gqo0ZInE=;
        b=lJzqNEwNXdS+sEBh8HYrnwQiUzO4TLmg9IpSMJzb/xPryWNN9rQ4s2xu+VCrGZUda+
         uQjNluhQGw0aKBQk2uPuzHqpPuHhcbvTV0QmHa3SYzD62Gbd78Z87p3euXOARanZ5VVE
         Cxd5+NT1iKph6asMoKKVfpA9gA3FIM40Y7XPNh7Hhlu+Yg7ybdLr6/O3Bw9a3noAmCAK
         okFHI81Sz5oHW3yHSPTR7tsnzAF6u1LGWLtqiJe+Ff1Ef1y9XU/MEGLlXMSVOswZdbt2
         SGiRYQQdRGav4fvKXCKIxolTvSWxS8sfCkuFwsnqF1CAeqEYZ8Ndc7+kh0NMymNQpAcY
         x94g==
X-Gm-Message-State: AFq9FYKc0NpdqwvP6sUN4+YB/jaRKAOK7A2mbu4Wouw5ANMTfKas/WTM
	ueVqRD8+BUsH6AoILbx+hm2JjPsoLcKLqL09XNIuxiSAnfhNuWwvXoP/f7mViA==
X-Gm-Gg: AYBFou3iANkWlRJd0gqbvuR/42PcM0bTVL62WJenKazO+659AWIkTSuzX6hrhkcC5uO
	3ve5z9DaXtxjha4BP4eyS5x9+Vdt9RFMoa29L0dmHMG5sFRCoDYGUXRBGBFFquM/CzEsvqOQhwz
	u70SErwjKgCsygA6uzQL9jmrXmuhhlTv/DeFueLLi3su9LeoaWcKLEy3ZWfupCns/Y+6RopahIL
	RYacrhsXV4EG7Ue8JA27RY9j5Bip3lrrhaR/aeNN1lZwVUmiz0WFwhBSAaY9yr9MpwNMgAq99TF
	wVDrorDNjFK+G6RtJWyaH1NcNLvjxYfdHMyhQpXe2SrxbgauRIAgNAhBkzRSM6SgNmwj8LrifaH
	ZLEL7ZIgJsIKktfn1IbNJr9jXYsUh6023KNpmZeiLw0yYOh46K/7s5XVB1YkgGIF0DpYdngPTUE
	Eb2rLXRfdyCkg8z/fldlsPAUrZTBk5mr++sFGjD2daHpubsu+gkGz/mCC04HbEwcanJyHiFf+2Y
	Zn/3+lllx+d3aqmSHpZ7QXN5PRG0b5RzgZtAajH6E+vDd0tUmgIU+C63i5Upl1MElkod4EGEXUv
	VCiIbNUOoPkSJrbHaouAIzX9jc35xdIF
X-Received: by 2002:a05:600d:4446:20b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-4a1d75f9e85mr17431145e9.15.1792190971415;
        Fri, 16 Oct 2026 15:49:31 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cf05009csm70445905e9.10.2026.10.16.15.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 15:49:31 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: luka.gejak@linux.dev,
	pkshih@realtek.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: wake the TX queues after ieee80211_restart_hw()
Date: Sat, 17 Oct 2026 01:49:07 +0300
Message-ID: <20261016224907.21709-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <DM4GODU3YQTM.25D25F2A98RO8@linux.dev>
References: <DM4GODU3YQTM.25D25F2A98RO8@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

Thank you for reading it this closely.

> The same callback runs with IEEE80211_RECONFIG_TYPE_SUSPEND after a plain
> resume, and the wake is skipped there. [...] Is that reachable, or is it
> released somewhere I missed?

It is reachable, and you did not miss anything. I traced it after your
mail:

  __ieee80211_suspend() stops every queue with
  IEEE80211_QUEUE_STOP_REASON_SUSPEND, then calls
  ieee80211_stop_device(), which is drv_stop() -> rtw_ops_stop() ->
  rtw_core_stop() -> rtw_power_off() -> rtw_hci_stop() ->
  rtw_pci_stop() -> rtw_pci_dma_release() -> rtw_pci_reset_trx_ring().
  So yes, the ring is rewound on the way down, exactly as in the restart
  case.

  On resume ieee80211_reconfig() runs with suspended set, so the
  RECONFIG_TYPE_RESTART call is skipped - its condition is
  "!suspended || reconfig_due_to_wowlan" - and the SUSPEND one is made
  instead. The only wake it does by itself is
  ieee80211_wake_queues_by_reason(..., SUSPEND, ...). Nothing releases
  the DRIVER reason.

So a DRIVER stop that is still set when the system suspends survives the
resume, and v3 does not cover it.

One thing that narrows it in practice. After the SUSPEND stop nothing
new is submitted, and the interrupts stay live until rtw_pci_stop()
disables them - which it does before rtw_pci_dma_release(), with a
synchronize_irq() in between. So on a healthy ring the outstanding
descriptors complete in that window, rtw_pci_tx_isr() runs and clears
both ring->queue_stopped and the DRIVER reason on its own. It only
survives when the hardware has already stopped consuming descriptors -
the same precondition as the case this patch is about. That makes it
narrow, not unreachable, and I would rather it were handled than argued
away.

It also bears on the flow Ping-Ke sketched in the v2 thread: clearing
ring->queue_stopped in rtw_pci_dma_release() and waking from
rtw_reconfig_complete(). His "(but not call ieee80211_wake_queues() if
restarting)" reads two ways to me - either the reset gets a wake beside
it for the callers that are not a restart, or the reset stands alone
and the wake lives only in step 3 - and your case turns on which he
meant. The suspend path reaches rtw_pci_dma_release() through
rtw_ops_stop() as well, so a wake there would cover it; a wake only in
step 3 would not, since a resume gets RECONFIG_TYPE_SUSPEND. I have
asked him in that thread, with your point attached.

> ieee80211_wake_queues() releases every queue with the driver reason, not
> just the one the ring-full path stopped, and the offload scan and PCIe
> error paths use that reason as well. I think the first sentence reads
> narrower than it is.

You are right, and that is my fault - v2 said this and I cut it when I
trimmed the message. rtw_hw_scan_start(), rtw_hw_scan_chan_switch() and
rtw_pci_io_err_detected() all stop queues with the same non-refcounted
DRIVER reason, so this wake cannot tell them apart. I will put it back in
the next version, along the lines of:

  Wake every queue holding IEEE80211_QUEUE_STOP_REASON_DRIVER. mac80211
  keeps one non-refcounted slot per queue for that reason, which the
  offload scan and PCIe error paths share, so this cannot be narrowed to
  the queue the ring-full path stopped.

I am holding the next version until Ping-Ke comes back with the flow he
wants, so your two points will land in the same respin.

Best regards,
Abdurrahman
