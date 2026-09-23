Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6142C21DF
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175649; cv=none; b=JF/v54cxN/vc1zH8sVIwjZLzdO0adnQvawANUloUMUsFqxiNhQSKFdEpiwhW7FU9ZgQMKTZMDTWEKRkw20oZ6zDbMMhc6xCQ0mXERg2zZgc2cRxV6q7WvVTyWtMQAyc0/PsBYDVdZBNQwpc9V+0Am0Zfe6vsvUr/GrazocDp8e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175649; c=relaxed/simple;
	bh=lQDbUbgJo8m4KPr4G/mi16bqjKPXmZeh/XJ2pK1JKgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0rdZVEUNHfLwGow28ZETv/q5v3A5FFZmcaMUcNNee/r+ImEwIvc5ma+7AvVK4X/q4MP0RUmNON+BPdHaikfK+mLiI0+KKJjMIm1upWpChXkS0vjck4AG95UGScZaBsLWG30yhIwTCgIhqzIRMyObBhtY7rTXf15XErPytpowDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gfkvu52Y; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gfkvu52Y"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3931so7764615e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790175645; x=1790780445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h1gdYxtd3AMMHQqcj9Emc5YrSF/TCwXVX2RhgoXpohE=;
        b=Gfkvu52YfMzgUhy7PrOQche9CKhLqaSddEpuY130IuUu5MBlEBJB3qkjtY11qDU0PE
         GNZKC+7jhZS3ZUGflVkEI9IsB45R7zR47opkjZQEnICMZi7O6JUZ4/8pkiirjuH+T9Y2
         3dU/He2knlfIxJIzzVQBr0NZGY3wbJKIEQjZYzxJg7018gc9aitF05MYxiqhqZ6jERYL
         7A6ivZYpn4xcPmsip/OleI5XPPoNxIhfsNdB3cWCqi7XlJSw3hP2PxxhMzUfxbdzlf/b
         TnGCd+SYItIioJxgOHwUZBysgKLDh9Yk1f6MxNcdg+YyMkIcwsdb2QSUHqq7sFjRwsNt
         yBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790175645; x=1790780445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h1gdYxtd3AMMHQqcj9Emc5YrSF/TCwXVX2RhgoXpohE=;
        b=NtJO9Bmuoffyc6ajgGvSTeDwNa0qTgAn9yK68lUBGjK0kgxLPKDSCPNrF6SuURVoyn
         TWEzCbGDqOUIQVuuUcd8pDDJ6BTYB0Q9IaaSzOSxEINFCiqBz9y/1ig+78JXkuzDAoz6
         XO2og2CItTHXLtl4hQ2lTsnexwUWne0aA/NWLxsBUUYZnMkrg0eIKc9F+Ckb5G2BeUHC
         b2lFgeSSP+63KxM0+wPThRlaSE4WDbAoXnC5UCGc/3tQfMZ2WKsyUUGLVfO7bgY2CQ9G
         rovAEpi5oPKuNr7l/vuYQ6AA4oWqAB4bKPd07auxMU85BdQ3oLbnYTD9F1W1YvuZ09EF
         EO4Q==
X-Gm-Message-State: AFuF++mFgFuGOAAZQ6UbbgToZ6ma747SDTeDgXwAab7TC+Osh3aI8DWf
	xE7vFmPSv+fQIqds9CWZPp1+wUojVVa4JQnhwhCvy38Dq8QT0jtJaq7HvyJ/KJas
X-Gm-Gg: AYBFou2aXDi1nb0rY1Hrni3egxuetWUAOpEJGav27dcTocL9mFw31RUjTLdIFawzuzB
	NJn59Nlm/Y+sukDoj/COJznDDe+EM5wbLePAEmWglskAeWVyk3jb71A5kfqtBecm9pUkHSDWmDM
	MFyXBFUAs+kUaEmLqTBNDlG94pYF/rqk+1X54SNqNB5seHJlbJCWP5sYH5vqvgUQhg+d3aBrsp0
	QlOvGIQNo4muJfKxMvb2JnZ5IJyJcvxl+mtygCNKSA9qBiNncSWAhrfiiUGLZNotSi67F4PVES/
	7iSDr+mRCDrGyY2SqlbrvLMeYqodM7CPIM5sbjrOEXlOBzWPI544GhTwxEy1J7LrkRF9EXuEU2s
	PX+AJcnDEe1mjPlF0nZPlRZ9EwhqhFolKX403XY/7SzppyBSH2/iEhgVAt3QpjZjlW7znYw8gCC
	EkXME7cpOAowryWuP/IPZd6yeaInpguH2fHCVnmcfT2E/w/9Pk+bNSkCHBO66g3p3wpUS2LTec7
	ysW6mK4z+LuCP0uKnP88rP6rCRxXheDG3oFzTz60C0iCv4qIIgSLiQcKtRixtkSv/EmjR9POeXw
	M1arf0CWYs2UXvQKCqvT6hA=
X-Received: by 2002:a05:600c:4712:b0:49e:8354:26fb with SMTP id 5b1f17b1804b1-49fdf2519a2mr42921415e9.32.1790175645017;
        Wed, 23 Sep 2026 08:00:45 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488687791cdsm6885025f8f.22.2026.09.23.08.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:00:44 -0700 (PDT)
From: abkarada <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Wed, 23 Sep 2026 18:00:17 +0300
Message-ID: <20260923150017.181310-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9d64e207c4434411981bc133ef820d7e@realtek.com>
References: <9d64e207c4434411981bc133ef820d7e@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorry for the long silence. I spent it on the monitor capture you asked
for. I set up a second machine in monitor mode and checked it against a
healthy link first: 531 QoS-data frames from my station, all TID 0, and
157 ACKs back from the AP, so the capture side works and would show me
whether the chip transmitted.

Then I waited two and a half weeks and the failure did not happen once.
I cannot tell you whether something masked it or whether it is simply
that rare. The rig stays in place, and that capture is the first thing
you will get if it happens again.

In the meantime I went back over the data I already had, and I think I
had been treating two separate moments as one.

> I wonder even you use driver of 7.0.12 (on 7.1.9). It will still happen.
> Can you 100% ensure 7.0.12 is fine?

I cannot, and it is not. My watchdog caught two stalls on 2026-09-14,
17:48 and 19:09, in one boot, both on the stock 7.0.12 kernel and its
own rtw88. I also withdraw the "12 episodes on the first 7.1.9 boot"
count from my earlier mail: it came from a log heuristic that counted
"DHCP lease acquired, then connectivity lost", and that boot logged 51
"deauthenticating by local choice (Reason: 3)" events, each followed by
a reassociation about a minute later. That is a separate regulatory
disconnect loop and it happens on 7.0.12 boots too. There is no
regression here. My good/bad version claim was never measured properly.

> As your experiments, the cause is hardware never reads TX buffer and
> gets stuck, right?

Yes, and I could not get any further than that. The BE ring's hardware
read index stops moving while the host write index keeps advancing. To
rule out a missed doorbell I taught the watchdog to rewrite the TXBD
host index during a live stall and re-read it. Three independent
occurrences, each pair taken immediately before and immediately after
the rewrite:

                     BE read index      BE write index
  2026-09-06 03:17   0x00b7 -> 0x00b7   0x00a2 -> 0x00a3
  2026-09-14 17:48   0x00c9 -> 0x00c9   0x006c -> 0x006d
  2026-09-14 19:09   0x009e -> 0x009e   0x0050 -> 0x0051

The read index did not move in any of them, and it was not a momentary
sample either: in the 19:09 capture it held 0x9e from the first register
read to the last, minutes apart, while the write index went 0x2b -> 0x4c.
Traffic stayed at 100% loss throughout.

So rewriting the TXBD host index is not sufficient to recover the ring.
I have asked for that patch to be dropped.

> I checked vendor driver. It only does this at initial step, not to
> recover it at runtime.

Thank you for checking the vendor driver. That settles it: those bits
are an init-time thing, not a runtime recovery, so I have dropped the
idea.

> Which means not a driver side bug (stop queue but not restart queue
> properly), right?

Partly. I think we have been looking at two different moments of the
same failure, and there is a gap at each of them: the driver never
notices that a ring has stopped advancing, and it has no way back unless
the hardware resumes by itself. Neither gap is the cause. Both are
things the driver could do something about.

> Hardware read index is 0x3c, and host write index is 0x3a.
> So, it reaches the limit of stop queue.

Agreed, and that dump is the late moment. avail_desc() is 1 there, so
ieee80211_stop_queue() is exactly right and the driver is doing what it
should.

But both stalls I caught in September are from an earlier moment, before
the ring fills:

  17:48  0x3a8: 0x00c9004c -> 0x00c9004e -> 0x00c90053
         read index 0xc9 frozen, write index 0x4c -> 0x53, avail 124
  19:09  0x3a8: 0x009e002b -> 0x009e002d -> 0x009e0034
         read index 0x9e frozen, write index 0x2b -> 0x34, avail 115

The ring still has 124 and 115 free descriptors, the queue is not
stopped, nothing has hit any limit - and traffic is already 100% lost,
because the hardware has stopped consuming descriptors while the driver
keeps writing them and ringing the doorbell. Nothing in the driver
notices this. The watchdog runs, the link stays associated, RX keeps
working, and there is no counter or log line anywhere that says the TX
ring has not advanced.

So the first gap is detection, and it happens before your dump.

The second gap is what happens after it. Once the ring does fill and the
queue is stopped, everything that could undo that sits behind the same
frozen index. In rtw_pci_tx_isr():

	if (cur_rp >= ring->r.rp)
		count = cur_rp - ring->r.rp;
	else
		count = ring->r.len - (ring->r.rp - cur_rp);

	while (count--) {
		...
		if (ring->queue_stopped &&
		    avail_desc(ring->r.wp, rp_idx, ring->r.len) > 4) {
			q_map = skb_get_queue_mapping(skb);
			ieee80211_wake_queue(hw, q_map);
			ring->queue_stopped = false;
		}
		...
	}

	ring->r.rp = cur_rp;

The only ieee80211_wake_queue() in pci.c is inside that loop. As long as
cur_rp remains equal to ring->r.rp, count stays zero, so the body is
skipped and neither ring->r.rp nor the stopped queue is ever
reconsidered. Meanwhile rtw_pci_tx_write() keeps consuming descriptors
until avail_desc() < 2 and calls ieee80211_stop_queue().

To be fair to the design: this is not a deadlock. The descriptors are
still sitting in the ring, so the normal completion path can recover the
queue - but only if the hardware resumes consuming them. When it does
not, and in the three occurrences above it did not, there is nothing
else: no timeout, no ring reset, no device reset. The interface stays
dead until userspace does something about it.

Since the stall itself is rare and I cannot produce it on demand, I
built a way to put the driver into the stopped-queue state instead, so
that a recovery path could at least be tested. rtw_pci now takes a
debug-only module parameter that makes the TX completion handler behave
as if the read index never advanced, for a chosen ring - the same idea
as the existing fw_crash debugfs knob, which crashes the firmware
deliberately to exercise the recovery path. On 7.0.12, BE ring, station
otherwise idle:

  14:29:58  injection on. The driver's own counters, logged from the
            ISR, one second apart:
              r.rp=174 r.wp=175 avail=254 stopped=0
              r.rp=174 r.wp=172 avail=1   stopped=1
            mac80211 BE queue: 0x1, IEEE80211_QUEUE_STOP_REASON_DRIVER
  14:30:00  ping to the gateway: 100% loss
  14:30:30  injection turned OFF
  14:32:30  r.rp=174 r.wp=172 avail=1 stopped=1, queue still 0x1,
            120 s later, with no recovery

The important observation is the final state: the injection is gone and
completions are no longer being suppressed, but nothing in the driver
revisits the stopped queue. By then the hardware may already have
consumed all descriptors that were submitted during the injection, so
there is no further TX completion to generate an interrupt and make the
driver observe the current hardware read index. With the mac80211 queue
stopped, no new descriptor is submitted either.

I should be precise about the limits of this. It is not your failure
reproduced. The field stall leaves real descriptors pending in the ring,
so if that hardware resumed, the driver would recover on its own; with
the injection, the hardware can consume the submitted descriptors while
the software read pointer is deliberately held back, leaving no later
completion event to make the driver revisit the stopped queue. What it
does give me is a deterministic way to reach that stopped-queue state,
which is what I would need to test any recovery patch - I did not want
to propose one I had no way of exercising.

In an earlier run of the same injection I also captured on wlan0 while
it was wedged. Once the ring is full, frames are either dropped in
rtw_pci_tx_write_data() with -ENOSPC or held in the qdisc; either way
they do not reach the air, but the ones that reach the driver are still
visible to tcpdump. So from userspace it looks like this: ARP requests
to the gateway repeat once a second and are never answered, while the
station still receives ARP requests from another host on the same
subnet. That is exactly what I see in the field.

So I am not asking you to treat the stall itself as a driver bug. I am
asking about the two gaps around it: the driver currently has no
mechanism to detect that a ring has stopped advancing, and no way back
if the hardware does not resume on its own. Would you consider a patch
that addresses those - per-ring detection of "read index has not moved
for a few watchdog rounds while descriptors are pending", triggering the
recovery the driver already has for a firmware crash,
rtw_fw_recovery() -> fw_recovery_work -> ieee80211_restart_hw()?

In the field a full interface restart is what recovers the link in both
occurrences where I got that far; on 2026-09-14 19:09 it came back 3 s
after a down/up and reassociated without a reboot. __fw_recovery_work()
does firmware-crash-specific work, so this would need a lighter variant,
and I would rather hear your view on the direction than send something
you do not want.

If you would rather not add a recovery path at all, the detection half
is still worth something on its own: a log line at the moment a ring
stops advancing, instead of a user discovering that the network died. It
would also have saved me most of the last two months, and it would make
the next report of this kind arrive with the register state already in
it.

Full dumps, the injection patch and the test script are available on
request.
