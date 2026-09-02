Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B8411FB3
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788340554; cv=none; b=kJXQOp5Styq3dkGvuYOVAAH5BQ3cxlYv6iphbhCNgJkBKA1kzM8e/D0eN9Ut9rmXsdkDyJS5VY1uxbkqMF4v4Ve4tGr8T3PBemfhAzmiLK4wpSomNt1Q1mB5PL0RTrxAqAbbKklINCETUiwcINZ3m3Q7Hek7mfFQdWDGQXImjQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788340554; c=relaxed/simple;
	bh=MAcT7Fr83fkZEgSja0KK8Ex90mGLkQoMkiYjzyO9Lyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5mwqS58QkPE04DIy5jhW5uhTzvXwGKu7DnNRUWfi1KD6PzQfYdbE7q+M4TlUyuhfl0CZ315UrGZwHMlXCJzIfBYikHqpX0DJ+AW6uqYQ/3aonA3VSZrkmSgVo5L1WKDMrMLEOlghYBXUFzz90FccSeSmTSlBxsUi0kI879rKuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CviKkvOF; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CviKkvOF"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso537612f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 02:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788340550; x=1788945350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2fcj6gzju5BNZPQYoD7KnHYqAnNL+DXTFxHzcxRypQ8=;
        b=CviKkvOFwSGr5rlomINyVseeJpMEpL9sd81e7kKMPDo74WJK3T28BDyXEBWrUVpfZj
         mc3EWlZ0TDaqM5mAkMBHD1G94XUFV2HcSIMfPNLdCZUJdpY3PQr0sSOvX6oOkXOc0HCN
         ctamx0LXLEeP6PhGD93Ar4vPiUOKuaEdpl77Z+MIpKtIVWEk2VRfCftav8Ay5jNXc+ZY
         Oo/eO6+6rI4/58/2brvopdyikroRYaw8aL0m18fI2JnI7I7dUIvUO2x91fh0SdGChi7j
         fF5+doRYTiXAkOcyosTgbJdUOh07uX0G0OBJsXar3yHTyR17q/i9j2pEKNXr/q6KdEIF
         3njA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788340550; x=1788945350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2fcj6gzju5BNZPQYoD7KnHYqAnNL+DXTFxHzcxRypQ8=;
        b=GqTth2j6WDZwGo+lVPI1VR5HvSzQ0RCB8Ycdaa5mtMgk7eVyqtf71rBIMgdbs5oOmT
         LYV5aMbk9MgaZlFZ1qY42IwusdDGqpOcdZSA5GSdsM9ZN1NMYTumijlP5Mdg34NDjlI5
         aZ68fyn3aEblsvm7g915wuuaOS11TuOYt8UN4rrA6LwRN3gBueehDrUqg0HRxvg1j20w
         XpRRbBtnEOXxvVNIs3D8uh0W22feRbqqI7xHEcPHStvXVaRkCRIiexPMp5kd+3ir3mKm
         q8Z0Za3KA0uQmOjqU5cAu7eW6DiJNYUlPjChRwqh8Ya60mRx26qhReg+52JOR++dgSXr
         7qQQ==
X-Gm-Message-State: AFuF++kFon96IFx8vPZWns4mKINLS2mxZf/J6mrH1gccFb2QarXq4ELw
	KAavE3KUlwIE/HO8hIPutl101goqr/yPGmQA0pv13aB/WZTInTdVfkaxX+8Xma7O
X-Gm-Gg: AYBFou2maFAPnIuPjoSo5E9JPXmvsqy2EeovvQeG2NXr4pkFeUh4Llou/VMPU1gDaR0
	ASbeu5+/ndzS18CMDfYFgk+dw0YTPRebI7W9nYqGtJjZDDlIhiCrXq5AFBnNGizwkFK20QOPDzt
	IvpvLkAKsqC+3SWivGrsiMVwajIU4DBXCsgeTa6s+VshzfqDD8DANgBXl3TdIbRYgpnvxh9udg3
	FsiW2hi4PVe+KzeTAvLGROJbX3c4VXt+NbB+VgWwfJ3qM1x0VERuGjrA9Z8O/WF7nyiVkX4VPdC
	oI1JrRqCPO00JvJNZl72cy/32/o7NXYJRJ34UrPyHdqf2oUPMfbKQM1oggj+qlheooX3OoDmG16
	7g/cfv0r38o7+AA5UZOea8b7CU529RIMTLaSAmqnHAfMuwWqYXOmkgcu0f5IXnpodSbxEXTF+2Q
	PpGKuq0kvc9HJH5aUzVE6xmgXUfTBGeNjNbKR0VlobNFUKk4P4bRF3izgH+NGDOiMCdT/Ov+E/Q
	C6PcGRUYtmbZmKgOZwengOuBGNiHme2ehCTD3Q54htIzJpKCI3F62SGl+LExiUvzDca/CxXx5fC
	x9l6uMZorw==
X-Received: by 2002:a05:6000:4022:b0:482:c676:8d04 with SMTP id ffacd0b85a97d-48488f12454mr5725415f8f.18.1788340549774;
        Wed, 02 Sep 2026 02:15:49 -0700 (PDT)
Received: from omarchy ([151.135.13.136])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e72b5bsm5144051f8f.4.2026.09.02.02.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 02:15:49 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Wed,  2 Sep 2026 12:15:25 +0300
Message-ID: <20260902091525.39810-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <516290e0e8a84988a9219069596e61a3@realtek.com>
References: <516290e0e8a84988a9219069596e61a3@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Checking commits between 7.0.12 and 7.1.9, the only related commit might be
>    c95323ea9dfb ("wifi: rtw88: coex: Solve LE-HID lag & update coex version
>    to 26020420")
> You can revert the patch from 7.1.9 to see if it becomes normal.

I reverted it from 7.1.9 and the wedge still happened, about an hour after
boot, so that commit is not the cause. BT is disabled on this machine
anyway (coex_info reports "BT disabled", BT status non-conn).

Rather than continue bisecting, I set up a watchdog that dumps
queues/aqm/TXBD indices at the moment of the wedge, before anything
touches the interface. I have five such dumps now (I discount one of
them, taken on a captive portal network where the ping probes are
unreliable), plus healthy baselines, and they show a consistent
driver-level failure. I have also been able to reproduce that failure
deterministically and to recover from it. Details below; I am
sending a patch as a separate mail.

1. What the wedge looks like from inside the driver
---------------------------------------------------

This is the dump from 2026-08-28 22:05, taken with power save off, on
5 GHz, 91 minutes into the association:

  /sys/kernel/debug/ieee80211/phy0/queues
    00: 0x00000000/0   (VO)
    01: 0x00000000/0   (VI)
    02: 0x00000001/0   (BE)  <- stopped, reason bit 0 = DRIVER
    03: 0x00000000/0   (BK)

  stations/<ap>/aqm tid 0 (BE): backlog 20941 -> 26960 bytes,
    94 -> 144 packets, flags DIRTY, still growing while sampled

  iw station dump, 5 s apart:
    tx packets  116017 -> 116017   (frozen)
    rx packets  244885 -> 244992
    beacon rx    53304 ->  53353

  TXBD_IDX_BEQ (0x3A8) = 0x003c003a in all four samples, taken over
    about 15 seconds

  dmesg, shortly before: "failed to get tx report from firmware"

The BE queue is stopped, and rtw_pci_tx_write() only does that when the
ring has no room left:

    if (avail_desc(ring->r.wp, ring->r.rp, ring->r.len) < 2) {
            ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
            ring->queue_stopped = true;
    }

The only ieee80211_wake_queue() for that ring is inside the completion
loop of rtw_pci_tx_isr():

    count = cur_rp - ring->r.rp;
    while (count--) {
            ...
            if (ring->queue_stopped && avail_desc(...) > 4)
                    ieee80211_wake_queue(hw, q_map);
            ...
    }

so it can only run if the hardware read index has advanced. In the dump
that index is identical in every sample, the ring stays full, and the
queue is therefore never woken again. Nothing is logged, no counter
moves, and there is no watchdog for this state, which is why the
interface stays associated with RX working while TX is silently dead.

A second dump (2026-08-30 09:12, this one with power save on) shows the
same thing: BE stopped with reason DRIVER, backlog growing, tx packets
frozen at 115902 while rx packets and beacon counters keep increasing,
TXBD_IDX_BEQ = 0x001c001a identical at +2 s, +7 s and +2 min.

Two other dumps caught an earlier stage of the same failure: the read
index was already frozen while the ring still had room, so the queue was
not stopped yet. In the 2026-08-28 20:32 dump the read index stays at
0x45 across four samples while the write index moves 0x19 -> 0x1b ->
0x20 -> 0x22, i.e. frames were still being written into a ring that the
hardware had stopped draining.

2. Reproducing it deterministically
------------------------------------

Since I could not wait for another occurrence, I broke the TX path on
purpose: a temporary module parameter that skips the doorbell
write in rtw_pci_tx_kick_off_queue() for the BE queue, simulating a lost
kick-off. With BE traffic running, this reproduces the failure in about
12 seconds:

    BE ring 0x000e000e   q02 0x00000001   100% loss

that is, the same observable state as the dumps above: BE queue stopped
with reason DRIVER, ring full, read index not moving, TX dead, RX
unaffected. A Wireshark capture on wlan0 during the artificial stall
looks like the ones taken during real wedges: our ARP requests leave the
netdev and no replies arrive, while RX keeps working (artificial: 40 TX
/ 51 RX, 9 ARP requests, 0 replies; real: 193 / 300, 186 requests, 0
replies).

3. Recovery
-----------

I then added a TX stall check to rtw_watch_dog_work(): for each TX ring,
if there is outstanding work (queue stopped, or cur_rp != ring->r.wp)
and the hardware read index has not moved for three consecutive rounds
(about 6 s), run the kick-off for that queue again. Controlled run, with
the recovery selectable at runtime so both arms use the same build:

  13:01:16.293  TX queue 1 stalled (rp 14 wp 170), recovery DISABLED
  13:01:22.309  TX queue 1 stalled (rp 14 wp 5),   recovery DISABLED
  13:01:28.325  TX queue 1 stalled (rp 14 wp 12),  recovery DISABLED
  13:01:34.341  TX queue 1 stalled (rp 14 wp 12),  recovery DISABLED
  13:01:40.293  TX queue 1 stalled (rp 14 wp 12),  recovery DISABLED
  13:01:46.309  TX queue 1 stalled (rp 14 wp 12, stopped), kicking

With recovery disabled the stall persisted for 24 s across five
detection rounds and did not clear by itself. One kick-off was enough:
the ring went from 0x000e000e to 0x00470047, the queue stop flag
cleared, and ping returned to 0% loss within a second of the kick. The
wake up then happens through the existing path, because once the
hardware starts consuming again rtw_pci_tx_isr() runs with a non-zero
count.

4. What this does and does not prove
-------------------------------------

The artificial stall simulates a lost doorbell, so I cannot claim the
root cause in the field is the same. I looked for a register-level
difference between the two and did not find one. I had suspected the
real dumps were special because the hardware read index sits a couple of
slots ahead of the last announced write index, but after instrumenting
the driver I see the same relationship during perfectly healthy
operation, when the ring fills up under load and the queue is stopped
and woken again within milliseconds. The only thing that distinguishes
the failure is that the read index stops advancing at all.

What the experiment does show is that once a TX ring stops draining, the
driver has no way back, and that a re-kick recovers at least the
lost-doorbell case.

I still do not know why the hardware stops consuming descriptors in the
field, and it is not easy to catch: since the dumps above I have gone
about 74 hours without a single occurrence, across five driver builds
(including the stock one), five networks and both bands, with the
association living well past the ages at which it used to happen. It
seems to come in bursts - three occurrences in four hours on one
evening, one two days later, then nothing.

The 802.11 monitor capture you asked for is still on my list (the second
adapter is on the way), and my watchdog now also re-writes the doorbell
during a real wedge so that I can tell whether a re-kick is enough there
too. I will report that separately.

5. Corrections to my earlier mails
-----------------------------------

  - "persists across disconnect/reconnect ... cleared only by a reboot":
    only true once the ring is full. Two of the wedges were cleared by a
    reconnect, and the 2026-08-30 one by ip link set wlan0 down/up,
    which reinitialises the rings.
  - "AC_BE TX dead, AC_VO TX alive": that was the early stage. In the
    two dumps where the ring is full, ping -Q 0xc0 fails as well, so by
    then TX is dead on VO too.
  - "it tends to hit soon after boot": wrong. The association ages at
    the moment of the four wedges were 95, 91, 36 and 61 minutes.
  - Power save: three of the five dumps were taken with PS on, because
    my udev rule only ran on ACTION=="add" and the setting reverts after
    a link down/up. It is now forced off every 20 s. The two dumps I
    rely on most, 2026-08-28 20:32 and 22:05, were both taken with PS
    off, and they show the same state as the PS-on ones, so PS does not
    look like a factor.

I will send the patch separately so that it lands in patchwork on its
own. It only adds the stall detection and the re-kick; it does not touch
the normal TX path, it skips rings with nothing in flight so an idle
device is never poked, and it warns once per stall rather than on every
retry.

One question, in case a re-kick turns out not to be enough in the field.
The out-of-tree rtw88 driver has a pci_old.c for the older PCIe
generation, where the PCIe DMA is reset after a TRX hang using the two
status bits at REG_DBI_CTRL + 3 (bit 0 TX, bit 1 RX), with bit 2
enabling the detection. Is that status bit valid on 8821CE as well? If
it is, I can dump it during the next wedge and, if it confirms a DMA
hang, a reset could be added as a second stage.

Full dumps (five wedges, healthy baselines, the controlled run) and the
captures are available on request.
