Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593D13D6CDF
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124464; cv=none; b=fUethSesTaAXXsAjyuHZZ+XrxHqTD1MFkG/Yk8dRp16jTDU9nCWiieVltvC2XDxNd1bnYGnI8O96DTSF1eTNFC/hQebGAk4Fc7r/R3TMUjDfgbc4t4MZXhSmug53ObSiQ4AVExXm7vXTRveLCmGdk4k30SK4FyRCeT5VgeTX9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124464; c=relaxed/simple;
	bh=/OzR0Ga6dcdZUbBnsvQWMH7KtcGotB2sVaIQ6r6NrQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QKPfi/VBiJOJJjzC245NBhKK499p7skITyF1TWwy3fApXt65oiz9QXpwfZXMZY07iqCNfg4A/GcZAzwcEPXMhyKSxbvn4gXrJpvLW2r4ueRhhxyX8WNAs6nYHX+QLqlnpH6iU+BQshKABr6tZ/NyM3E9Ekp0qkMDXRYq0wxUX7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LJPl+Qu2; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LJPl+Qu2"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/OzR0Ga6dcdZUbBnsvQWMH7KtcGotB2sVaIQ6r6NrQ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787124459; v=1; x=1787729259;
 b=LJPl+Qu29DkdPMNdOqruKIOfVCYKU1xPwJCzIh0HSk830IdKiPaoflgGtIjZV0H7Do9lqnUG
 90RkBXalvf9bbkJL8v+URXOnHtbnwbjo2qiqqSkNnUm6qg6E6L+3JfZufYYAff5DQfRn6kC7tFr
 xqkhnCQDgfNmBZZmecTX/c6M=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 5894fca14c54cc40;
	Wed, 19 Aug 2026 07:27:29 +0000
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v6 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Wed, 19 Aug 2026 07:27:11 +0000
Message-ID: <20260819072717.22648-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
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

v1 had 19 patches, v2 had 11, v3 had 5, v4 had 7, v5 had 6, and
this has 6.

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
There is one exception, deliberate: patch 2 extends an existing RTL8703B
zero-length-packet check and is gated on the SDIO interface rather than
the chip id, since that is the only place the behaviour has been
observed. Ping-Ke has suggested that check may not need a chip test at
all; I would rather measure that on RTL8703B hardware than assume it,
and I do not have that part, so it is unchanged here.

Patch 5 changes how the SDIO interrupt status is acknowledged. In v1
that applied to all SDIO parts; it is scoped to this chip only, and the
others keep writing the status word back unchanged.

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
bidirectional traffic, reconnects and module reloads.

The full driver, this preparation series plus the chip support that
follows in a second series, is available for testing at:

  https://github.com/MocLG/rtw/tree/8723bs-v6

Throughput is measured against an iperf3 server one hop behind the AP,
with the wlan0 byte counters as ground truth because the test machine's
wired interface shares the same subnet. On one AP at strong signal,
2.4 GHz HT40, it runs at roughly 40 Mbit/s down and 20 Mbit/s up, with
UDP showing no loss in either direction. The exact figures move by
several Mbit/s from one day to the next with the radio environment, so
they are a range rather than a benchmark.

Uplink on this band drifts by several Mbit/s from day to day, enough to
swamp the differences I was trying to measure, so where the changelog
below compares two builds the comparison is a paired test: the two
builds alternate within one session, rebuilt and reinstalled each time,
rather than being measured on different days.

Suspend and resume are not covered: this machine only offers s2idle and
does not reliably come back from it.

A five minute soak: 1495/1495 pings at 0% loss, 15/15 reconnects, 5/5
link up/down cycles, 3/3 module reloads, 5/5 scans under traffic, 24
group rekeys, no deauthentication, no SDIO errors, no warnings in the
log. Scanning saw the target AP in 18 of 18 attempts across 6 cold
module reloads, with 6/6 associations.

The soak and scan figures were taken on a build that also carried the
reserved page patch dropped in v3; the throughput figures above are from
the tree posted here.

Every patch builds with W=1 with no warnings on its own, sparse is clean
at the tip, and smatch reports nothing in any file this series touches.
checkpatch --strict is clean across this series. The other rtw88 bus and
chip modules continue to build.

Known limitation
================

After a long idle period the firmware intermittently fails to leave LPS,
which rtw88 reports as "firmware failed to leave lps state". That check
is the REG_TCR poll in __rtw_fw_leave_lps_check_reg(), and the failures
arrive in long runs rather than singly, so it does not look like a
timeout that is merely too short. On one occurrence here the warning was
followed fourteen seconds later by a full reauthentication, so it is not
only log noise.

Power save is now enabled on my test machine and it reproduces there:
five occurrences over three days of mostly idle uptime. It was first
reported on ARM SDIO boards, but it is not specific to slow hosts.

It is not caused by anything in this series, and it needs the chip
driver from the second series to be reachable at all, but it is open and
I am chasing it.

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
 drivers/net/wireless/realtek/rtw88/sdio.c | 458 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |  22 +-
 drivers/net/wireless/realtek/rtw88/tx.c   |   5 +-
 5 files changed, 471 insertions(+), 29 deletions(-)

--
2.53.0

