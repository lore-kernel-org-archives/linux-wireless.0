Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBB4266A4
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439606; cv=none; b=FfRuxUsrjJN3XsP4h/BYiKTvyjrAdF5s1wBDdj4gasXbEhfsjynO/tYtkFNzZXYLMp9WYKKcdPa9HxM74uRkvNxZtDkv2Sosf3j8LY1cofE0Nvc2cXKtPUfPBB10xflnKyRkHjMGtTusDBldcFX9ftXDOw7TEXy62lM6w/v5WJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439606; c=relaxed/simple;
	bh=ZhWDkRMi4vQe4jtJW5ylUYYrZfcRt5Kq3MEjJao7wf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZVTqf4oWgDeWa7Qxz1RTmZluMIyCdzuqORpsTeuCc6UOB+R2L9fR61WDKhSDiMoAsDSKG3U35LcG6JMUjJ1A65qPxH3OmYHiTCZcEfDA5BHDEfQpgCaEz0k2paEN1dHkaNMLTgGfNeV5bAhADJb2QNEuNxiesUhddxhsU5Yuhvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tgEQObUl; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tgEQObUl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786439590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aP+JWp6pK19o44CSUqpe5ZhlyrXKwVDuUWFXWQdgytc=;
	b=tgEQObUl6euVr3i+L0PawIDsmUXm3kDg+2KmX9WHLzLOWc6i5Wblxy0kP91n0b1zBFv3Cs
	5WLxBxUq+I5zvdHgHjQbfPtRX4iF1ntm5bDIEso0c7ziKc88kZC+2EJasfFgNimVOS65d5
	qdGWNiazNjTkLbcYQvJewBb3mDpXwAY=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 0/7] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Tue, 11 Aug 2026 09:11:56 +0000
Message-ID: <20260811091203.26841-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

This is the first of two series adding support for the Realtek RTL8723B
802.11n chipset and its RTL8723BS SDIO variant to rtw88. It contains
only the changes to the shared rtw88 core that the chip driver depends
on. The chip itself, the build glue and the MAINTAINERS entry are a
second series.

v1 had 19 patches, v2 had 11, v3 had 5, this has 7.

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
and the changelog below gives the measurement for each. In three of
those cases I had told the list, or claimed in a commit message, that
the chip needed something it does not, on the strength of bring-up
notes I had not re-measured. All three corrections are in the
changelog.

What is left is there because removing it made something measurably
worse, not because the vendor driver does it.

What is left falls into these groups:

  - patches 1 and 2: the chip type and helper plus a one-line receive
    fix;
  - TX report handling (patches 3, 4): a longer TX-report purge timeout
    and the vendor firmware's management TX report events, both needed
    on slower SDIO hosts (see below);
  - SDIO (patches 5, 6, 7): software free-page and output-queue
    accounting, RX aggregation and interrupt setup, and TX back-pressure
    with a retry on page starvation.

This series no longer touches coex.c or mac80211.c at all.

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

Patch 6 changes how the SDIO interrupt status is acknowledged. In v1
that applied to all SDIO parts; it is scoped to this chip only, and the
others keep writing the status word back unchanged.

Chip specific code in the common path
=====================================

Ping-Ke asked whether this needs a set of ops rather than a chip test
sprinkled through the core. Working through that question is what
removed most of this series: once the association and coexistence
patches turned out not to be needed, the chip tests they carried went
with them.

What remains is one test in rx.c, two in fw.c, one in tx.c and eleven in
sdio.c. There are none in mac80211.c or coex.c. The SDIO ones are in the
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

  https://github.com/MocLG/rtw/tree/8723bs-v4

Throughput is measured against an iperf3 server one hop behind the AP,
with the wlan0 byte counters as ground truth because the test machine's
wired interface shares the same subnet. On one AP at strong signal
(-35 dBm), 2.4 GHz HT40: TCP 19.1 Mbit/s up and 37.8 Mbit/s down, UDP
25.0 Mbit/s up and 40.0 Mbit/s down, both at 0% loss.

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
reserved page patch dropped below; the throughput figures above are from
the tree posted here.

Every patch builds with W=1 with no warnings on its own, sparse is clean
at the tip, and smatch reports nothing in any file this series touches.
checkpatch --strict is clean across this series. The other rtw88 bus and
chip modules continue to build.

Changes in v4:
  - Re-added two patches that were dropped in v2. Both handle the
    RTL8723BS TX report and leave-LPS paths, and both were dropped
    because I could not reproduce the failures on my test machine, a
    fast x86 host, so those paths never ran for me. Testers on slower
    ARM SDIO hosts, Peter Robinson on the RFC and another on a Rockchip
    RK3288 board, both hit "failed to get tx report from firmware" and
    "firmware failed to leave lps state", and confirmed both clear with
    these patches:
      - "tx: extend the TX report purge timeout" now extends the exact
        fix from commit c80788f7c5ae ("wifi: rtw88: increase TX report
        timeout to fix race condition"), already applied to the RTL8723DU,
        to the RTL8723BS, since they run the same firmware and hit the
        same off-channel-scan race.
      - "fw: handle the RTL8723BS management TX reports" routes the vendor
        firmware's 0x12 and 0x32 TX report events, which rtw88 otherwise
        mistakes for a WLAN_RFON event, so the reports are decoded and
        the LPS leave check is left alone.

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
    it, so I cannot exercise the interrupt acknowledgement change. It is
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
  - rtw_sdio_process_tx_queue() returns 1/0/-errno instead of taking a
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

Luka Gejak (7):
  wifi: rtw88: add the RTL8723B chip type and SDIO helper
  wifi: rtw88: rx: mark zero length packets on RTL8723BS
  wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
  wifi: rtw88: fw: handle the RTL8723BS management TX reports
  wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
  wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
  wifi: rtw88: sdio: add TX back-pressure and retry on page starvation

 drivers/net/wireless/realtek/rtw88/fw.c   |  20 ++
 drivers/net/wireless/realtek/rtw88/fw.h   |   5 +
 drivers/net/wireless/realtek/rtw88/main.h |   7 +
 drivers/net/wireless/realtek/rtw88/rx.c   |   8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c | 373 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |  22 +-
 drivers/net/wireless/realtek/rtw88/tx.c   |   5 +-
 7 files changed, 411 insertions(+), 29 deletions(-)

-- 
2.53.0

