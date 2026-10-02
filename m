Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806854BE443
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982713; cv=none; b=qBlNgq6iIcT1C77uOTlw+uk3JJwQOCQLyumWITWNoxzV7alYFRKJ4YQxPDIrBBhJH1k9zV6xyN/vpkwMWZLdKgzjfFLnGHce8jeiz5EKxk9lDuys0yJzNkk0Lf3nAVH2vInQOoXonHV+2leV+eg9E6iHRir14h/cKCOBHtKqzQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982713; c=relaxed/simple;
	bh=qCbLziXiyWNl2VOzp96RHXB8I+lqhku946nEasU0b2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMz6bE4sim41NFpsn5DPJjP3HWaCdlndRULTxQbKiTB9Ed6LexEOERqyP5m3mkqCurMq813wFUdJPf5FID/NlAfNKpjdeT9KYrAIBDa1kxpI9FyLhS0/q0eM2m6opMhu0pJ5aXCusU4QXfod+SbGkro1yRAUsuzQPT7bgNl0vek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+2xosvZ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+2xosvZ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b03f23305so19337f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 16:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790982710; x=1791587510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OGZB/UQgqTl+IGtfHxknRNV6wNbmvNEOY0xhQcpShAQ=;
        b=i+2xosvZ9DX6DQ8eJK0pbZdopGw3gNDp+gz2oedMmh9UObhMfibOrZwhQcsbjJ1/Qr
         naIjbOfCGbZrXef1HhOGvFA1qQ08dU9yRXzyzfaC6EVeCTpfCdUwJLx3Y3BjRxVzhqVw
         LujMt8me50NV7mNDtm/VXTdLZi6L/MDYhP1ZPDsgNOT8hphon1bnl1xlFpUtuuhVLHmb
         ziDAhIgLjFRYP1JXqrctF6gGCjKNMduECS3oMkiNIr/YN2VBwt88kWlzpZ6WUw33tL+4
         ibZLBEDmLHcwVAe7V5Yqee/hU//jK92bjomDBjKhvPt9U1IGdVAq/uKqEPtuZz6zfYm2
         ly1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790982710; x=1791587510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OGZB/UQgqTl+IGtfHxknRNV6wNbmvNEOY0xhQcpShAQ=;
        b=R36x+IGC/POt/ZpRluiQi9vnutwSAjmbzKrYuOunxY859UZ/AhUzG/vt7VN4K6d+uK
         PYECIN9vFTiz3mm+/YCA6wD4F1Tq7zaaxqbB5BiD8WGd8KxylQITRo0pdL+e7dMKNx2Y
         aAHrKbHZCu0rDxt/pXYDfQ0RU1trsuiP7WjCMcysayaf3vjxn4WDkmv+eRlYC6p6NGQ3
         EKHbRVH9s9pqCRYV81K3QWuR9vKhF+b5vQjfFG6kYcwG3+zjSyBFJQos93F4tAwen4IQ
         NWjQTd3HqpfyS/kuNzke1wsqJ+AIHFl3qg4G86C0vL8xTKe2Sh37Qsx6M69Ma3JfClwC
         qwdg==
X-Forwarded-Encrypted: i=1; AKwUvByuKoUJD0aeKoUUHwTqOyIt2PKzytP8er6a+GQVpomEJ7ttnE8B7NbtaG/NNwrlh2K33ZA28hh+8ZsEqXYsOg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIySUBJq+QJF/oTa6xsGbOQlD6Ls8uL4mBgU1y19Tmta+gh3wyn
	+T2tdHr4OY0fEsxGNhgpwUXvuIG/4cXoI3/StR0u+8RzZ1vbLkk5frTLX3q6hAiF
X-Gm-Gg: AYBFou1SpnCIj2OjNsho6sAz4IdphIIhhrNGOX21kfB/T++n/gaww7MWs8Ewx0IVPo/
	N2ubUGwz5HE2Tn5aRKDk5vCJALyfmOADdKrar3X0d7B/tlgJsWdUY6kkgGnYIzbDXcMBT84url/
	v8IBqcH1Qrn/Enr2V5PIQ9OzH3aGaNeDeuVIHz28VF3OIwM1lfS1uZKII/gnRfYBcCmKJ0QYbp9
	YPeI6XTJmisZXAlCvPCXQzQ2XrSWtZUT/b/TrjRAI3DkBM+SLfl6PefVoVjVbNmo7TAuk13hpAP
	NBTShwVo9pPj9LH8NJzB5BkllImBP0MKCV3l18gaPvqhGBhE5VnAMcIGD2JRsQUWoHeCKDlpvum
	THkTHTku5RRfTbP+qYolxzgFnGuT0opepfKiBJfiQCNRwDKe6eejNERQSnR0R58hU7fYtVjpM0w
	XjuLD7ufMxCvlaYkpRz/tBB/AkTfIJ7fUfxpbEhn9M8zCyaucSLUAb1CqYdAoFoXfrfLIriOMlt
	ZzFIQuDvUUYy17exUK3QcgsI4RSAy1niSbiyULd7o5ihElG7bx07VkIqc1GytEzdc9MN5rQ4pIo
	mJu7CQxOfQbj9nvO1kU85YW7NTwPRJiH
X-Received: by 2002:a05:6000:420e:b0:48c:43a4:37f2 with SMTP id ffacd0b85a97d-48c47fe7775mr1301653f8f.17.1790982709594;
        Fri, 02 Oct 2026 16:11:49 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253e5bsm8187340f8f.1.2026.10.02.16.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:11:49 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com,
	linux-wireless@vger.kernel.org
Cc: rtl8821cerfe2@gmail.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Sat,  3 Oct 2026 02:11:09 +0300
Message-ID: <20261002231109.12770-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <fd4a810147fb4daeb42e5b8cae981b27@realtek.com>
References: <fd4a810147fb4daeb42e5b8cae981b27@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Can you trigger the recovery to see if it can resolve the stuck?

Not with the stock driver. The restart itself completes - the chip is
reinitialised and the station reassociates - but a queue that was
already stopped keeps its stop reason across the ring reset, so TX
never resumes. That is a driver bug and it is fixed in the first of the
two patches I have just sent; thank you for asking the question that
found it.

I could produce a stalled ring after all. My own 08-28 capture had it
and I had dismissed it: with REG_TXPAUSE at 0xff the BE read index sat
at 0x9a while the write index ran 0x12 -> 0x1b. Pausing TX in hardware
freezes the read index while the driver keeps submitting, which is the
same shape the chip shows when it wedges on its own. Not the same cause
- in the field TXPAUSE was 0x00 - but the same ring state, which is
what your question needed.

From that state, with the stock driver:

  REG_TXPAUSE <- 0x0f, push traffic
    BE 0x3a8: 0x0081007f, avail_desc() 1, BE stop reason 0x1, in 1 s
  rewrite the host write index
    0x0081007f -> 0x0081007f, no effect
  call rtw_fw_recovery()
    "firmware crash, start reset and recover"
    "ieee80211 phy1: Hardware restart was requested"
    REG_TXPAUSE back to 0x00, BE 0x3a8: 0x00000000, ring empty
    wlan0: associated        (twice, within the 90 s)
    BE stop reason still 0x1, 100% loss, no recovery in 90 s

So the link came back and the ring was reset, and the queue stayed
stopped. ieee80211_wake_queue() is reached only from the completion
loop in rtw_pci_tx_isr(), and ring->queue_stopped is cleared only
there. The reset drops the pending descriptors and frees their skbs
through rtw_pci_free_tx_ring_skbs(), so that loop never runs for them;
the flag and the mac80211 stop reason then sit on an empty ring that
will never complete anything again.

Patch 1 records the queue mappings stopped by the ring-full path and
releases them, both from the normal completion and when the reset
empties the ring. Same script, same procedure, only the patch differs:

                              without patch        with patch
    BE queue stopped after    1 s                  1 s
    doorbell rewrite          no effect            no effect
    rtw_fw_recovery()         ran                  ran
    BE stop reason after      0x1                  0x0
    traffic                   none in 90 s         back within 2 s

> As this is hardware get stuck, we might skip to discuss
> ieee80211_stop_queue()/ieee80211_wake_queue() for this moment.

I did drop it, and then the test you asked for landed in exactly that
code. I want to be clear about the scope though: this is not why the
hardware stops, and it is not what killed the five events below, four
of which never reached the stop threshold at all. It only means that
once a queue has been stopped, no restart can bring it back. So it
matters for any recovery, not for the stall itself.

> Can I say that touching host write index doesn't affect hw read index?

In the stalled state, yes. On a healthy ring the write index is exactly
what makes the read index advance, so not in general. What I rewrote
was the value already there, through the same register
rtw_pci_tx_kick_off_queue() uses. It had no effect in the three field
events where I tried it, and none in the controlled stall above either.

> Before that, can you summarize the methods that can resolve the stuck?

First a correction: there are five events, not three, across three
boots, all with power save off and REG_TXPAUSE at 0x00.

  2026-08-28 20:32   BE 0x45 frozen, wp 0x19 -> 0x22   queue open
  2026-08-28 22:05   BE 0x3c frozen, wp 0x3a           queue stopped
  2026-09-06 03:17   BE 0xb7 frozen, wp 0x84 -> 0x9e   queue open
  2026-09-14 17:48   BE 0xc9 frozen, wp 0x4c -> 0x68   queue open
  2026-09-14 19:09   BE 0x9e frozen, wp 0x2b -> 0x4c   queue open

The second line is your dump. "Hardware read index is 0x3c, and host
write index is 0x3a" came from my own 08-28 capture, 93 minutes after
the 20:32 one in the same boot, and avail_desc() is 1 there so the
queue was stopped exactly as it should be. I replied as if your dump
were a different case and said all my events were from before the ring
fills. That was wrong, and it is the state patch 1 is about.

The ladder stops at the first step that works, so the denominators are
not comparable:

  1. Rewrite host write index    0/3   no effect
  2. ip neigh flush              0/4   no effect
  3. iwd reconnect (new PTK)     2/4   fixed 08-28 20:32, 09-06 03:17
  4. ip link set wlan0 down/up   1/2   fixed 09-14 17:48
  5. Reboot                            always
  6. rtw_fw_recovery()           0/1   measured above, before patch 1

I previously told you an interface restart is what recovers this. The
data does not support that: a reconnect cleared it twice and a down/up
once, and the ordering gave the reconnect the earlier attempts. And on
09-14 19:09 my ladder printed a timeout at step 4 only because it
waited 25 s; the journal shows the link up 3 s after the down/up and
reassociated 90 s later, no reboot. The subject line's "until reboot"
describes what a user sees, but three of these recovered without one.

The debugfs fw_crash knob, by the way, does nothing on this chip. The
write only pokes REG_HRCV_MSG; recovery is entered later, and only if
the firmware raises the C2H interrupt and rtw_fw_c2h_cmd_isr() sees
REG_MCU_TST_CFG == VAL_FW_TRIGGER. Here that never happens, so I called
rtw_fw_recovery() directly from a debug build instead.

> By the way, recently people want to disable deep LPS and ASMP [...]
> Can you also try the settings on your platform?

Both have been in /etc/modprobe.d since 2026-08-24, before every event
above. I should be careful though: my captures do not record module
parameters, so I cannot prove from them what was in effect. What they
do record is power save off, "IPS/ Low Power/ PS mode = 0/ 0/ 0", and
REG_TXPAUSE = 0x00 in every sample. And on the one occasion I dumped
sysfs, disable_aspm=Y had not changed the link's L0s/L1 state, so I
would not claim ASPM was actually off.

So: not prevented by disable_lps_deep=y, and nothing was pausing TX in
hardware. I cannot say ASPM was off.

> Have a look at RTK_PCI_HISR0 and RTK_PCI_HISR1 too.

Added, 0x0b4 and 0x0bc, twice two seconds apart next to the TXBD
indices. If the TX-done bit is asserted and stays asserted while the
read index does not move, that says something quite different about
where this sits. Thank you - I would not have thought to look.

Patch 2 is the detection half of the patch I withdrew, without the
doorbell rewrite. It is only a log line; I am not proposing a recovery
for the stall itself, because the table above does not single one out.
