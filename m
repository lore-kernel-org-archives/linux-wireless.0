Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6455A562619
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874211; cv=none; b=eb4+W6Hs/pPMcrkedyiO2x6T++PYq3Tc5ZPIaCwIzRTsh0DuJ6QS7x0aZBiKdSB57sQcUsxS/dFGXYHcch1w0+jNYwEboEMx4jN5UQComdWeoiXM0H9uYUepp3hb21fJu8rMqB2jvEjAy9wMRZEvVJr+GjzgHMF032TLxcngFoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874211; c=relaxed/simple;
	bh=hyYoPlJBKyRRl5LH7K8u/NOuGoxBXFqwTHJqfO1fXQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VxU61O39WR5bySMcuPvVKkkcPjgPlx4Z+rOLECvkt3Eq6xmThpEoAE9f+//TgAIDaG/wd8XoY+cvyh6AnpLaLXH+KDAthzpAyveQ2CqIkU18Dfg7DJogKFvfGdSHI3F8s11z62fVjj/BdEusFNG447IRolFHephdAZZ9ECwSG24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=owrsENNp; arc=none smtp.client-ip=91.218.175.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="owrsENNp"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hyYoPlJBKyRRl5LH7K8u/NOuGoxBXFqwTHJqfO1fXQM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874193; v=1; x=1789478993;
 b=owrsENNpeZSaO1kb91wCjiu9cKYXC618DRYu9DXZzMXCOsu2ky6Fk2TllaZlAgkXw9Y8J3yb
 xRzGaJX9vVxBagWN4WjUddxhtgCGz5rQCy4Foyk/w6LzFri0XqHc9y2E5QD2MMLzms3+RJroHUi
 VXH510jgLfsN2EIXbwAjqrVo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 282b1c64c3aa16eb;
	Tue, 08 Sep 2026 13:29:43 +0000
X-Mizu-Trace-ID: 282b1c64c3aa16eb
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v10 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Tue,  8 Sep 2026 15:29:20 +0200
Message-ID: <20260908132926.68976-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

This is the first of two series adding support for the Realtek RTL8723B
802.11n chipset and its RTL8723BS SDIO variant to rtw88. It contains
only the changes to the shared rtw88 core that the chip driver depends
on. The chip itself, the build glue and the MAINTAINERS entry are a
second series.

v1 had 19 patches, v2 had 11, v3 had 5, v4 had 7, v5 had 6, v6 had 6,
v7 had 6, v8 had 6, v9 had 6, and this has 6.

There is no rtw88-style firmware for this chip and no documentation for
the vendor blob it does use, so while bringing it up I deliberately kept
the driver as close to the vendor driver's behaviour as I could. With
that many unknowns at once, matching the vendor exactly was the only way
to tell which difference actually mattered when something did not work,
rather than guessing. A number of the v1 patches came from that: they
reproduced vendor behaviour that was useful to hold fixed during bring
up, not behaviour the chip turns out to require.

Bitterblue Smith's review of v1 prompted me to go back and remove each
of those on hardware to find which were actually load bearing; eight
were not. Ping-Ke Shih's review of v2 did the same for a further six,
and the changelog below gives the measurement for each. In four of
those cases I had told the list, or claimed in a commit message, that
the chip needed something it does not, on the strength of bring-up
notes I had not re-measured. All four corrections are in the changelog.

What is left is there because removing it made something measurably
worse, not because the vendor driver does it.

What is left falls into these groups:

  - patches 1 and 2: the chip type and helper plus a one-line receive
    fix;
  - patch 3: a longer TX-report purge timeout, needed on slower SDIO
    hosts (see below);
  - SDIO (patches 4, 5, 6): software free-page and output-queue
    accounting, RX aggregation and interrupt setup, and TX back-pressure
    with a retry on page starvation.

This series no longer touches coex.c, mac80211.c or fw.c at all.

Scope
=====

Everything is gated on rtw_is_8723bs(), which is false for every chip
currently supported, so behaviour for existing devices is unchanged.
Patch 2 extends an existing RTL8703B zero-length-packet check to this
chip. Earlier revisions of this cover letter said that check was gated on
the SDIO interface rather than the chip id. That was true of an old
version and I did not update the text; the code you have adds
rtw_is_8723bs() alongside the existing RTL8703B test, so it is gated on
the chip id as well and the RTL8703B behaviour is untouched. Ping-Ke has
suggested the check may not need a chip test at all, but I would rather
measure that on RTL8703B hardware than assume it, and I do not have that
part, so it is unchanged here.

Patch 5 changes how the SDIO interrupt status is acknowledged. In v1
that applied to all SDIO parts; it is scoped to this chip only, and the
others keep writing the status word back unchanged.

Everything else is behind rtw_is_8723bs(). Since the point of this
revision is to make that checkable rather than asserted, here is the
whole of what is not, and what the other parts run as a result.

New code that is not chip gated, all of it structural:

  sdio.h                   struct delayed_work work
  rtw_sdio_init_tx()       INIT_DELAYED_WORK(), mutex_init(), and
                           mutex_destroy() on its error path
  rtw_sdio_tx_kick_off()   mod_delayed_work(..., 0) in place of
                           queue_work()
  rtw_sdio_deinit_tx()     cancel_delayed_work_sync(), mutex_destroy()

Only this chip ever arms a delay, so on the other parts the work is
still queued immediately, and only this chip ever takes the mutex, so
there it is one init and one destroy and nothing else.

Two existing functions were also restructured, and every chip runs
through them. rtw_sdio_process_tx_queue() returns a value instead of
void, and rtw_sdio_tx_handler() uses it. The behaviour is meant to be
unchanged for the other parts: on an empty queue the new "if (ret > 0)
break" takes the place of the old skb_queue_empty() break, and on a
failed write the frame is still requeued and the loop still retries,
because rtw_sdio_8723bs_reschedule_tx() returns false for anything that
is not this chip.

Two things worth stating because they can be checked against the base
commit rather than taken on trust. rtw_sdio_check_free_txpg() differs by
exactly one inserted branch ahead of the existing 8051 test, which
becomes an else if, with everything else unchanged. And the generic path
through rtw_sdio_write_port(), now rtw_sdio_write_port_generic(), is step
for step what it was: the same address from skb->len, the same
sdio_align_size(), the same free page check, the same transfer and the
same failure message. The only difference visible to another part is
that the unaligned SKB warning now prints rtw_sdio_write_to_port as its
function name, since that is where the check lives.

rtw88 supports five other SDIO parts that share sdio.c: the RTL8723CS,
RTL8723DS, RTL8821CS, RTL8822BS and RTL8822CS. I have none of them, so
nothing here has been run on one. If anyone on the list does, a boot and
some traffic with this series applied would be worth more than the
argument above.

Chip specific code in the common path
=====================================

Ping-Ke asked whether this needs a set of ops rather than a chip test
sprinkled through the core. Working through that question is what
removed most of this series: once the association and coexistence
patches turned out not to be needed, the chip tests they carried went
with them.

What remains is one test in rx.c, one in tx.c and eleven in sdio.c.
There are none in fw.c, mac80211.c or coex.c. The SDIO ones are in the
bus driver rather than the chip driver, and rtw_sdio has no per-chip ops
table today; Ping-Ke confirmed an inline chip id check there is fine.

Fixed in the second series
==========================

Two of Bitterblue's review points are addressed in the chip driver
rather than here, because that is the right place for both:

  - the hardware capability is filled in from a chip-specific
    read_efuse, instead of special casing rtw_dump_hw_feature() in the
    core;
  - the receive FCS handling is a chip configuration fix. v1 stopped the
    core advertising RX_INCLUDES_FCS for this chip. The real cause was
    that the chip cleared BIT_APP_FCS by assigning WLAN_RCR_CFG over
    hal.rcr wholesale, where the 8723x siblings only write the register
    and leave hal.rcr alone. Setting that bit in the chip's WLAN_RCR_CFG
    makes the descriptor carry the FCS like every other rtw88 chip, so
    the core needs no special case and both hunks are gone from this
    series.

Neither change is visible here. I planned to send that series once this
one is applied to rtw-next, but I can send it now alongside if you would
rather review them together, or fold the two into one series if that is
easier.

Testing
=======

Tested on RTL8723BS hardware together with the second series: repeated
scan, authentication, association, WPA2-PSK/CCMP handshake, DHCP,
bidirectional traffic, reconnects and module reloads. This revision was
run on the tree posted here, on two kernels built from the same base:
one ordinary, and one with CONFIG_PROVE_LOCKING and
CONFIG_DEBUG_ATOMIC_SLEEP enabled.

The full driver, this preparation series plus the chip support that
follows in a second series, is available for testing at:

  https://github.com/MocLG/rtw/tree/8723bs-v10

Throughput is measured against an iperf3 server one hop behind the AP,
with the wlan0 byte counters as ground truth because the test machine's
wired interface shares the same subnet. On one AP at strong signal,
2.4 GHz HT40, TCP runs at roughly 35 Mbit/s down and 20 Mbit/s up, and
UDP reaches 40 Mbit/s down with no loss. The exact figures move by
several Mbit/s from one day to the next with the radio environment, so
they are a range rather than a benchmark.

Uplink on this band drifts by several Mbit/s from day to day, enough to
swamp the differences I was trying to measure, so where the changelog
below compares two builds the comparison is a paired test: the two
builds alternate within one session, rebuilt and reinstalled each time,
rather than being measured on different days.

The locking change in patch 6 was retested that way for v8, against a
build carrying the v7 barrier version of the same patch, alternating
between the two within one session and reassociating each time. The two
came out the same within the usual run to run spread, uplink and
downlink alike, and the log was empty after every run.

Suspend and resume are not covered: this machine only offers s2idle and
does not reliably come back from it.

On the ordinary kernel: 20/20 cold module reloads reassociated, 10/10
scans while connected left the link up, 2000/2000 pings at 0% loss, and
three idle periods in power save woke with no loss. A shorter pass over
the same tree also gave 5/5 scans with the target AP seen every time,
5/5 reconnects and 3/3 link up/down cycles. No tx-report timeouts, no
leave-LPS failures, no failed H2C commands, no SDIO errors, and nothing
logged by the driver at all.

The lockdep kernel matters for patch 4 and patch 6 in particular, since
the lockdep_assert_held() calls in patch 4 compile to nothing without
CONFIG_PROVE_LOCKING, and patch 6 calls ieee80211_stop_queue() and
ieee80211_wake_queue() with interrupts disabled under the TX queue lock.
Over the same tests there was no lockdep report of any kind, no "sleeping
function called from invalid context", and debug_locks was still 1 at the
end, so lockdep had not switched itself off part way through and every
check was live for the whole run. Throughput on that kernel is roughly
half, which is the instrumentation, so the figures above are from the
ordinary one.

Every patch builds with W=1 with no warnings on its own, sparse is clean
at the tip, and smatch reports nothing in any file this series touches.
checkpatch --strict is clean across this series. The other rtw88 bus and
chip modules continue to build.

Known limitation
================

After a long idle period the firmware intermittently fails to leave LPS,
which rtw88 reports as "firmware failed to leave lps state". That check
is the REG_TCR poll in __rtw_fw_leave_lps_check_reg(). On one occurrence
here the warning was followed fourteen seconds later by a full
reauthentication, so it is not only log noise.

Power save is enabled on my test machine and it reproduces there,
roughly once per day of mostly idle uptime, and the occurrences cluster.
It was first reported on ARM SDIO boards, but it is not specific to slow
hosts.

Instrumenting the poll settles what a failure is, and it is not a
budget that is slightly too small. A local debug patch logged REG_TCR on
every poll of __rtw_fw_leave_lps_check_reg() and counted how many polls
each wake needed. Over 110755 wakes:

  poll0=158 poll1=110557 poll2=35 poll3=1 poll4=0 fails=4

pollN is the number of wakes that finished on the Nth read, so poll1
needed one 20 ms sleep and poll0 was already clear on entry; fails is
the number still set after all five. Nothing ever finished on the last
poll, yet four gave up completely, and in all four the patch kept
reading for a further 500 ms with the bit still set. The distribution
does not taper into the failures, it is bimodal: the wake is either
quick or the firmware never completes it, about once in every 28000
wakes. Raising the poll count would not have caught any of the four.

In v7 I described a failure as the far tail of the ordinary
distribution. That was wrong, and the measurement above is what
corrects it.

Ping-Ke suggests the firmware may be unable to leave LPS while packets
are still sitting in a hardware queue, which fits that shape better than
anything I had. I am extending the instrumentation to dump the per-queue
lengths and the free page and output queue counters at the failure.

It is not caused by anything in this series, and it needs the chip
driver from the second series to be reachable at all, but it is open and
I am chasing it.

Changes in v10:
  - sdio: patch 4 no longer pads the transfer up to the SDIO block size.
    Ping-Ke asked why the generic path does not need the same thing, and
    the answer is that it does: rtw_sdio_write_port() rounds the transfer
    up and hands that length to sdio_memcpy_toio() while the skb still
    holds only skb->len bytes, so bytes from past the end of the frame are
    transmitted. That is pre-existing and applies to every SDIO part, so it
    is a separate patch and not something this series carries for one chip.
    It will follow once this series is applied, against
    rtw_sdio_write_to_port(), which both paths call and which only exists
    after this series, so one patch covers every part including this one.
    Measured on hardware, this chip does not need the padding for its own
    sake: transferring unpadded, exactly as the generic path does today,
    measured no worse than padded in an interleaved comparison.
  - sdio: patch 4 takes the transfer size from sdio_align_size(), as
    Ping-Ke suggested. On this card, which reports multi block support and
    a 512 byte block size, it is identical to the rounding it replaces,
    checked at the block boundaries and then against every frame of a
    session. The equivalence rests on those two card properties rather
    than being unconditional.
  - sdio: patch 6 no longer retries -ENOMEM. With the padding gone from
    patch 4 nothing on that path can return it, so the case was dead. If
    the separate padding fix is applied it becomes reachable again, for
    every chip, and this has to come back with it, otherwise a stopped
    access category can be left with nothing to kick it.
  - the comments are cut back across the whole series, as Ping-Ke asked.
    This revision adds 62 comment lines where v9 added 103. What is left
    records things the code cannot show: which page pool a queue draws
    from and how that was measured, why the counters are atomic_t, why
    only the defined interrupt status bits are acknowledged, and the two
    places where an skb has already been handed on and must not be
    touched.
  - patches 1, 2, 3 and 5 are unchanged.

Changes in v9:
  - sdio: rtw_sdio_write_port() is a dispatcher now, with the two paths
    in rtw_sdio_write_port_8723bs() and rtw_sdio_write_port_generic(),
    as Ping-Ke asked. The chip specific one takes the mutex with guard()
    directly, so the extra rtw_sdio_8723bs_write_port() layer, which
    only existed to give the guard a scope while the generic path shared
    the outer function, is gone.
  - sdio: the unaligned SKB warning sits in rtw_sdio_write_to_port() now,
    once, next to the transfer whose pointer it checks and after any
    padding. It was duplicated in both callers in v8 to keep __func__
    reading rtw_sdio_write_port on the other parts; Ping-Ke had no
    preference there, and one copy in the right place seemed better than
    two in the wrong one.
  - the Scope section above is corrected and extended. It described
    patch 2 as gated on the SDIO interface rather than the chip id,
    which stopped being true several revisions ago, and it did not
    mention that rtw_sdio_process_tx_queue() and rtw_sdio_tx_handler()
    are restructured for every chip.
  - patches 1, 2, 3 and 5 are unchanged, and patch 6 is unchanged apart
    from Ping-Ke's Acked-by.

Changes in v8:
  - sdio: patch 4 accounted RTW_TX_QUEUE_VO against the high page pool,
    but rtw_sdio_get_tx_addr() writes that queue to the normal transmit
    FIFO, and the FIFO written to is the pool the chip charges. Polling
    REG_SDIO_FREE_TXPG through a saturating VO flood, the high pool never
    lost a page while the public pool drained, so the check was reading a
    pool the traffic does not use and overstating the free space by the
    whole dedicated high allocation. It is accounted against the normal
    pool now, which is also what the other two rtw88 SDIO parts do.
    RTW_TX_QUEUE_MGMT stays on the high pool: it goes to the extra FIFO,
    which the register has no counter for and this chip gives no pages
    to, and there is nowhere better to put it.
  - sdio: patch 4 claimed an output queue entry before the transfer and
    did not hand it back when the transfer failed, leaving the cached
    count low until the next resync from the chip.
  - sdio: patch 4 called mutex_init() without a matching mutex_destroy()
    on teardown or on the init error path, unlike rtw_core_deinit().
  - sdio: patch 6 no longer stops a queue and then undoes it. Ping-Ke
    pointed out that pci.c has no such back and forth, and he is right:
    it holds irq_lock across the descriptor check and the stop in
    rtw_pci_tx_write(), and the wake in rtw_pci_tx_isr() runs with that
    same lock already held by its caller, which is why there is not one
    barrier in the whole file. Both SDIO sides now take the TX queue
    lock across the length check and the flag update, so a queue can
    only be stopped while it really is above the watermark and there is
    nothing left to undo. The smp_mb() pair, the READ_ONCE and
    WRITE_ONCE accessors and the re-check all go with it. It matches
    pci.c in shape too: the enqueue is its own critical section and the
    check and the stop are a second one.
  - sdio: patch 4 moves the locked region into
    rtw_sdio_8723bs_write_port() so the mutex can be taken with
    guard(mutex). guard() expands to a declaration and so cannot be made
    conditional, and the lock is only wanted for this chip, so the
    generic path is a short branch that never reaches it. The transfer
    itself is shared as rtw_sdio_write_to_port(); the unaligned SKB
    warning stays in both callers so that the message other SDIO chips
    log is unchanged.
  - sdio: lockdep_assert_held() added to the three helpers that must run
    under tx_credit_lock, and checked on a kernel built with
    CONFIG_PROVE_LOCKING over bidirectional traffic and three module
    reloads: nothing fired, and lockdep reported nothing against the TX
    queue lock the back-pressure path now takes either.
  - sdio: patch 4's padding uses a pad_size local, and its comment is
    cut to the one point that matters, that __skb_pad() must not free
    the skb. The comment above the lock is gone, since the one at the
    declaration of tx_credit_lock already covers it.
  - the LPS note under Known limitation is corrected against a much
    longer instrumentation run; see there.
  - patches 1, 2, 3 and 5 are unchanged.

Changes in v7:
  - sdio: patch 6 read the mac80211 queue index from the skb after
    skb_queue_tail() had published it to the TX worker, which can
    dequeue, transmit and free it first. That is a use after free; the
    index is now read into a local before the enqueue.
  - sdio: patch 4 passed the padded size to rtw_sdio_get_tx_addr(),
    where upstream passes skb->len. That value is encoded into the CMD53
    address as the transfer length, so the encoded length changed for
    every other SDIO chip whenever sdio_align_size() padded. For the
    RTL8723BS both expressions are the same value, so the change bought
    this chip nothing. The padding itself also ran on the generic path,
    giving the other parts an allocation and an -ENOMEM path they did
    not have. skb->len is restored and the padding is gated on the chip.
  - sdio: the free page check, the output queue wait and the accounting
    after the transfer are serialised. The TX worker and the H2C path
    both reach rtw_sdio_write_port(), and two writers could each pass
    the checks and claim the same pages and output queue entry, after
    which the chip discards one of the transfers silently. The vendor
    driver funnels all transmission through one thread and so never had
    to handle this.
  - sdio: the padding called skb_put_zero() after checking only the
    tailroom, so a cloned skb with room to spare had its shared buffer
    written. It uses __skb_pad() now, which reallocates in that case and
    does not move skb->len, so the trim on the way out is gone too.
  - sdio: the back-pressure stop could race the drain. The worker could
    empty the queue after the length check but before the stopped flag
    became visible, see the flag still clear in its wake check, and
    never wake the queue, leaving an access category stopped with
    nothing left to wake it. The stop path now re-checks after setting
    the flag and undoes the stop if the queue drained.
  - patches 1, 2, 3 and 5 are unchanged.

  Most of these were found by Sashiko's automated review of v6. Each was
  verified against the code before acting on it.

Changes in v6:
  - Each patch now carries its own changelog after the --- delimiter, as
    you asked, so the notes sit next to the code they describe.
  - sdio: dropped rtw_sdio_reschedule_tx_work(). You did not ask for it
    in v4 and it was a thin wrapper that hid queue_delayed_work() for no
    gain. I had read your comment as asking for one, which was my
    mistake.
  - sdio: the reschedule conditions moved into
    rtw_sdio_8723bs_reschedule_tx(). rtw_sdio_tx_handler() no longer
    explains any chip specific condition in the common flow, which is
    what you were actually asking for. No functional change.
  - sdio: dropped an unconditional break on a failed transfer that v4
    and v5 carried. It changed the other SDIO parts without meaning to:
    upstream requeues the frame and the loop retries, and breaking gave
    up after the first failure. The two errors this chip needs to retry
    are handled in the helper above, so the rest keep the existing
    behaviour and the other parts really are untouched again, as the
    Scope section claims.

Changes in v5:
  - Dropped "fw: handle the RTL8723BS management TX reports", which v4
    had restored. It cannot do what its commit message claimed. This
    firmware does not advertise FW_FEATURE_LPS_C2H, so
    rtw_fw_leave_lps_check() takes the REG_TCR polling path and nothing
    ever waits on the C2H completion the patch rerouted; and with the
    driver instrumented, 93 TX reports over three scans all arrive as
    C2H id 0x03, with no event ever arriving as a top level 0x12 or
    0x32. Bitterblue Smith made exactly this point on v1 and was right.
    A tester on a Rockchip RK3288 board confirmed the timeout patch in
    this series is enough on its own. This is the fourth correction of
    something I had claimed on the list; restoring it in v4 was based on
    a tester reporting that a branch containing it cleared the warnings,
    which showed the branch helped, not that this patch in it did.
    With it gone the series no longer touches fw.c.
  - Power save is now enabled on the test machine, so LPS is exercised
    there. The v2 entry below dropped a patch that gated LPS entry on
    smoothed throughput, partly on the grounds that LPS never engaged on
    this setup at all, which was never a sound reason to drop it. It is
    measured now, paired against this series in one session with power
    save on: 60 idle pings average 5.1 ms without the gating and 6.0 ms
    with it, and TCP is 30.0 down and 19.1 up against 32.3 and 18.9. It
    makes no difference, because the gate tests the smoothed throughput
    and interactive traffic rounds to zero there, so it never fires in
    the case it was meant to help. It stays dropped, now on a
    measurement rather than for want of one.
  - sdio: fixed a transmit stall in the back-pressure patch, found while
    auditing a tester report of transmit stopping under bidirectional
    load with receive unaffected and nothing in the log. The TX work
    item was only re-armed when a transfer failed with a page shortage.
    Once the mac80211 queue can be stopped, that is not enough: a
    stopped queue is handed no further frames, so on any other failure
    nothing would kick the worker again and the affected access category
    would stay stopped for good, with the link still up. It now also
    re-arms on a failed skb expansion, which together with the page
    shortage covers both of the failures that produce no log message.
    The remaining errors are each logged where they happen, so unlike
    those two they are visible rather than an unexplained hang, and they
    keep the existing behaviour rather than being retried forever.
  - rx: the zero length test now evaluates pkt_stat->pkt_len first, so
    the unlikely case short circuits before the chip test.
  - sdio: the commit message now says what OQT is, as far as the vendor
    driver reveals it: the vendor calls the register the OQT free space
    and never expands the acronym, and it holds the number of further
    transfers the SDIO output queue will accept.
  - sdio: rtw_sdio_8723bs_sync_free_txpg() now returns whether the chip
    reported anything and is the only caller of
    rtw_sdio_8723bs_store_free_txpg(), and
    rtw_sdio_8723bs_init_free_txpg() returns an error rather than
    nothing. Working through that suggestion found a real bug: the
    public pool size was computed as acq_pg_num minus the reserved
    queues with no check, so a chip that came up with no transmit page
    allocation at all would underflow a u16 and leave the driver
    believing it had about 65000 free pages. That calculation is now
    rtw_sdio_8723bs_pubq_num(), shared with the queue page allocation
    repair path, and it fails cleanly instead.
  - sdio: the output queue wait is now bounded by a jiffies deadline
    rather than a loop count, so RTW_SDIO_OQT_TIMEOUT_MS really is a
    timeout in milliseconds. It was 1000 iterations of a 1 to 2 ms
    sleep before, so the name was only approximately true.
  - sdio: rtw_sdio_8723bs_check_rqpn() returns an error instead of
    silently doing nothing when the transmit page pool cannot cover the
    reserved queues, and rtw_sdio_start() propagates it. Both early
    returns are now explained: a non-zero free page count means the
    allocation latched during power on and must be left alone.
  - sdio: fixed the interrupt acknowledgment. It masked the status word
    with both irq_mask and RTW_SDIO_HISR_CLEAR_MASK, but for this chip
    irq_mask is REG_SDIO_HIMR_RX_REQUEST alone and that bit is not in
    the clear mask, so the two had no bits in common and the driver
    acknowledged nothing at all. It now masks with the defined bits
    only, which is what the comment described. Thanks to Ping-Ke for
    catching this. Retested on hardware.
  - sdio: the back-pressure and wake conditions moved into
    rtw_sdio_8723bs_stop_tx_queue() and _wake_tx_queue(), and the two
    requeue sites into rtw_sdio_reschedule_tx_work(), instead of long
    conditions inline.
  - sdio: rtw_sdio_process_tx_queue() now returns 0 on success and 1 for
    the empty queue case, rather than the other way round.
  - sdio: queue_stopped[] renamed to tx_queue_stopped[].
  - RTW_SDIO_TX_RETRY_DELAY is left as msecs_to_jiffies(1). Ping-Ke
    asked whether it becomes 0 when HZ is below 1000; it does not, since
    msecs_to_jiffies() rounds up for HZ < 1000 and returns one jiffy.

Changes in v4:
  - Restored "tx: extend the TX report purge timeout to RTL8723BS",
    dropped in v2 because I could not reproduce the failure on my test
    machine, a fast x86 host, so the path never ran for me. Testers on
    slower ARM SDIO hosts, Peter Robinson on the RFC and Zhang Ning on a
    Rockchip RK3288 board, both hit "failed to get tx report from
    firmware". It extends the exact fix from commit c80788f7c5ae ("wifi:
    rtw88: increase TX report timeout to fix race condition"), already
    applied to the RTL8723DU, to the RTL8723BS, since they run the same
    firmware and hit the same off-channel-scan race.

Changes in v3:
  - Dropped "fw: fix the reserved page upload on RTL8723BS". Its commit
    message said the BIT_BCN_VALID handshake fails on 8723BS SDIO
    without it. That does not reproduce. The failure path is an explicit
    rtw_err("error beacon valid") returning -EBUSY, reached from
    BSS_CHANGED_ASSOC on every association; over three associations on
    each of five builds with the patch reverted it never fired,
    associations were 3/3, and there was no packet loss after 30 s idle
    in power save, which is the path the reserved page's null data and
    PS-poll frames serve. As a control, rtw_info messages appear in the
    same captures and rtw_err outranks them, so a failure would have
    been logged. AP mode and WoWLAN also download the reserved page and
    are not tested here, so if it turns out to matter there it can come
    back with evidence behind it.
  - Kept "sdio: add TX back-pressure and retry on page starvation", now
    with a measurement rather than an assertion, since you asked whether
    the remaining chip tests are necessary. Counting
    rtw_sdio_tx_handler invocations under an identical 60 Mbit/s UDP
    flood, because the retry re-arms that same work item: 1798 and 3095
    on two baseline runs against 69 with the patch reverted. Achievable
    transmit rate falls by about a third without it, 25.5 Mbit/s against
    38.3 and 40.2. tx_dropped and tx_errors stay at zero throughout, so
    the failure is not dropping frames, it is failing to push them.
  - Kept "sdio: set up RX aggregation and interrupts". The aggregation
    half makes no measurable difference to throughput here, and on that
    evidence alone I would have dropped it. The rest of the patch does
    not show up in a throughput test at all: the chip keeps raising the
    interrupt after resume if undefined status bits are written back
    when acknowledging.

    I have not been able to validate the suspend and resume path: the
    test machine only offers s2idle and does not reliably resume from
    it, so I cannot exercise the interrupt acknowledgment change. It is
    kept because the failure it addresses was observed during bring up,
    not because it has been re-measured. If someone with hardware that
    suspends cleanly finds it unnecessary, it should go.
  - Dropped "run the RTL8723BS association register sequence", 440
    lines, which was the vendor join sequence, six sites in
    rtw_ops_bss_info_changed() and both sites in rtw_ops_set_key().

    Ping-Ke asked for this to run from rtw_chip_prepare_tx() rather than
    a chip test in mgd_prepare_tx(), and I had done that with a new
    chip_ops::prepare_tx. Since the whole patch is gone, so is the
    callback; the core is left as it was rather than gaining an op with
    no user.

    I had told the list that association fails without these registers.
    That was wrong, and it was bring-up-era data I repeated without
    re-measuring. With the whole patch reverted: 18/18 scans saw the AP,
    6/6 associations, and the five minute soak above, whose 15 reconnects
    and 24 rekeys exercise the exact path the sequence ran on, since it
    ran from mgd_prepare_tx() on every authentication. Uplink measured
    paired against the full series, 19.0 against 19.2 Mbit/s over ten
    runs each.

    The default key search handling in that patch was also simply wrong:
    rtw_sec_enable_sec_engine() sets sec->default_key_search itself and
    programs all four USE_DK bits on that basis, so the enable path was
    a no-op and the disable path was clearing bits the core had
    deliberately set.
  - Dropped "coex: add the RTL8723BS scan antenna workaround" and "coex:
    reassert the antenna path when associating", and with them "fw: add
    the GNT_BT firmware command", whose only caller they were.

    The commit message on the first claimed the site survey does not
    hear the AP reliably without it. That is also wrong: 18/18 scans
    without it. Both were gated on the chip and on coex bt_disabled, so
    that gate is their entire scope rather than a subset of it, and the
    measurements above cover it.
  - Dropped "record beacons from the target BSSID before
    authenticating". Ping-Ke doubted the beacon wait affected the
    connection and he was right: with the wait removed, association
    succeeded 12/12 from a cold module reload and 12/12 from a warm
    reconnect, against 10/10 and 10/10 with it, at the same latency.
    The pre-auth deauth already sleeps 100 ms with the recording window
    open, so on a 100 ms beacon interval the wait was almost always
    already satisfied when it was reached. struct rtw_auth_sync and the
    RX-path hook go with it.
  - Dropped the BT_MP version queries and the BT_INFO query at scan
    start, and the BT_INFO query plus two of three repeated PS-TDMA
    H2Cs in the pre-auth replay. Measured over cold module reloads with
    three scans each, 8 reloads with the queries and 10 without: 29/30
    scans saw the target AP and 10/10 associations succeeded without
    them, against 24/24 and 8/8 with them.
  - The cached SDIO page counters are clamped at zero. A lost update
    between the free page check and the accounting could previously
    drive the public counter negative, and the sum was assigned to an
    unsigned, which made the check pass unconditionally from then on and
    suppressed the resync that was supposed to recover it.
  - REG_SDIO_FREE_TXPG now has field masks and is decoded with
    u32_get_bits(); the RX DMA burst count uses BIT_DMA_BURST_CNT;
    open-coded BIT(0)|BIT(1) on REG_SYS_FUNC_EN uses the existing names.
  - The RTL8723BS-specific SDIO helpers are named _8723bs_ and the chip
    test moved to their callers.
  - rtw_sdio_process_tx_queue() returns a value instead of taking a
    "processed" out-parameter, which makes the retry and back-pressure
    logic in the TX handler readable.
  - mod_delayed_work() in rtw_sdio_tx_kick_off() carries a comment
    saying why it is not queue_delayed_work(): a page-starvation retry
    may already be armed with a delay, and the newly queued frame should
    not wait for it.
  - An argument that had a single value at every call site is gone,
    along with its dead branch.
  - Block comments use the general kernel style, per commit 82b8000c28b5
    ("net: drop special comment style").

Changes in v2:
  - Dropped "tx: extend the TX report purge timeout". Instrumenting the
    report path shows payload[6] & 0xfc equals the enqueued sequence
    number, 32 out of 32 times, with rtw88's existing decode, and no
    report is missed. The longer timeout was covering for the next
    patch, not for the hardware.
  - Dropped "fw: handle the RTL8723BS management TX reports". 0x12 and
    0x32 are the first payload byte of C2H_CCX_TX_RPT, not C2H IDs;
    every C2H event this chip sends carries a known id, so the existing
    handler already covers them.
  - Dropped "fw: send rate adaptation and RSSI info in the vendor
    layout". The vendor byte layout is equivalent to what the existing
    macros produce; uplink and the negotiated rate are unchanged without
    it (16.4/16.5/17.0 against 15.4/16.7/16.6 Mbit/s, MCS7 both ways).
  - Dropped "fw: send the media status report in the vendor layout". The
    role field the vendor sets makes no difference here, as with the
    other chips.
  - Dropped "sdio: handle the RTL8723BS management TX path". Sequence
    numbers do work for management frames on this chip, so reporting
    completion at DMA completion is unnecessary.
  - Dropped "calibrate and tune the PHY" entirely. All three parts were
    vendor-matching scaffolding and none survived measurement: the
    scan-time initial gain override is worse than
    rtw_phy_dig_set_max_coverage() (five scans found 41 BSSes without it
    against 34 with it); the IQ calibration works from the normal
    phy_calibration path; and the hardcoded per-rate TX AGC table
    overrode the efuse calibration by up to 22 index units and bypassed
    the regulatory limit the by-rate path applies, which is not
    something a driver should do.
  - Dropped "match the RTL8723BS firmware connect and power save
    behaviour". Deferring the connect report changes nothing, and the
    LPS gating cannot be justified from measurement: with RTW_DBG_PS
    enabled, LPS never engages on this setup at all, so the gating never
    takes effect here.
  - Dropped "advertise the correct receive capabilities". Both halves
    move into the chip driver, as described above.
  - "fw: add the vendor firmware commands" now adds only GNT_BT. rtw88
    already implements MACID_CFG and the WL channel info report, and the
    coexistence antenna select reserve became unused once the PHY patch
    went.
  - The zero-length packet check is gated on SDIO rather than the chip
    id.
  - The SDIO interrupt acknowledgment change is scoped to this chip.
  - The association sequence no longer re-applies the BSS capability at
    association time; BSS_CHANGED_ERP_PREAMBLE and BSS_CHANGED_ERP_SLOT
    are handled later in the same callback.
  - Register accesses that had raw addresses now use the existing
    REG_GNT_BT and REG_BT_COEX_ENH_INTR_CTRL, plus a named define for
    the BB antenna select register.

The implementation is based on the initial RTL8723B work by Michael
Straube <straube.linux@gmail.com>:

  https://github.com/mistraube/rtw88/tree/rtl8723bs

Based on the rtw-next branch from pkshih/rtw.
Luka Gejak (6):
  wifi: rtw88: add the RTL8723B chip type and SDIO helper
  wifi: rtw88: rx: mark zero length packets on RTL8723BS
  wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
  wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
  wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
  wifi: rtw88: sdio: add TX back-pressure and retry on page starvation

 drivers/net/wireless/realtek/rtw88/main.h |   7 +
 drivers/net/wireless/realtek/rtw88/rx.c   |   8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c | 491 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |  24 +-
 drivers/net/wireless/realtek/rtw88/tx.c   |   5 +-
 5 files changed, 502 insertions(+), 33 deletions(-)


base-commit: 81510c3d6f2199889a4a936d8cf8b9e05911b10e
-- 
2.55.0

