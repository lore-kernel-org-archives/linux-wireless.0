Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D89F23BCF7
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991897; cv=none; b=N3Y0uIoCZOgnIbtiUFVjNrMQnVsBntyhro7fJoN2+Jj7hmnQCHG3cIuYYFf3yccUnERJAtaKgf1vG8a2ZmCjp8YR0m/vqL7KtiHWJFF3Xq4XY0aRv1PdETdaTJxXwmGxOcga7/E7FXQs8etrdgvzdaqqzYwYGlo1HvkfYzU7DVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991897; c=relaxed/simple;
	bh=/ffam6DRaFakOxN7xOr3dyQBn2AxIFn9B+p6hWgDeuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hYs84/NEGKGQ4O9lawpu0e3l150H7DP5DX6rt/hwIvNuBSwOfj2t32q+ZhC31wv3bol2VouR0pToifime7It+oMYAErIaD8T4uazIWCBUlotp3ErucAPQhbxxTSz6SnEI31d689hm+NYbHwkb09iBpHqNnkw18k1RBKm9NaHDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tx/P75+v; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tx/P75+v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Hqi4AZjl1bPGk2dE9l6JxTrVeubyk/S+NatmfXGV6hA=;
	b=Tx/P75+v1H96QO8bXzv6loRXeetvKVEKq/OHwvvpqSiz5oUixhxRQROgiqMeonq7JTspot
	sAmntx5up/3TCylElyiHQjV0mXgwKub+s/IsbrWfW9Ouax7YLVG/PXxdTjun7zmxnZTahI
	2vdwYe2wrL+/GBb4cY9xeUn1Dlld4NU=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 00/11] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Sat, 25 Jul 2026 17:04:16 +0200
Message-ID: <20260725150427.93887-1-luka.gejak@linux.dev>
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

v1 had 19 patches; this has 11.

There is no rtw88-style firmware for this chip and no documentation for
the vendor blob it does use, so while bringing it up I deliberately kept
the driver as close to the vendor driver's behaviour as I could. With
that many unknowns at once, matching the vendor exactly was the only way
to tell which difference actually mattered when something did not work,
rather than guessing. A number of the v1 patches came from that: they
reproduced vendor behaviour that was useful to hold fixed during bring
up, not behaviour the chip turns out to require.

Now that the chip works end to end, and prompted by Bitterblue Smith's
review, I went back and removed each of those on hardware to find which
were actually load bearing. Eight were not. The changelog below gives
the measurement for each.

Why the remaining changes are needed
====================================

The vendor firmware's association behaviour and SDIO transfer contract
differ from the firmware the existing rtw88 8723-family devices use, and
those differences sit in code that lives in the core, so the chip driver
cannot handle them on its own.

What is left falls into four groups:

  - firmware (patches 3, 4): the GNT_BT command rtw88 does not
    implement, and a fix to the reserved page upload handshake;
  - coexistence (5, 6): the PTA antenna path has to be programmed
    directly during scan and reasserted when associating;
  - SDIO (7, 8, 9): software free-page and OQT accounting, RX
    aggregation and interrupt setup, and TX back-pressure with a retry
    on page starvation;
  - association (10, 11): the vendor join sequence, which programs the
    BSS parameters directly and waits for a beacon from the target
    before authenticating.

Patches 1 and 2 are the chip type and helper plus a one-line receive
fix.

Scope
=====

Everything is gated on rtw_is_8723bs(), which is false for every chip
currently supported, so behaviour for existing devices is unchanged.
The one exception is patch 2, which extends an existing RTL8703B
zero-length-packet check; it is gated on the SDIO interface rather than
the chip id, since that is the only place the behaviour has been
observed.

Patch 8 changes how the SDIO interrupt status is acknowledged. In v1
that applied to all SDIO parts; it is now scoped to this chip only, and
the others keep writing the status word back unchanged.

Fixed in the second series
==========================

Two of the review points are addressed in the chip driver rather than
here, because that is the right place for both:

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
rather review them together.

Two things deliberately kept
============================

Two further patches could be removed without breaking anything on my
test setup, and I have still kept them, because passing on a single AP
is not evidence that dropping them is safe:

  - the basic-rate handling in patch 11 programs the response rates
    from the BSS rate elements. Removing it associates and passes
    traffic here, but this AP advertises a conventional basic-rate set;
    an AP with an unusual one may not behave the same. rtw88xxa writes
    a fixed per-band set instead, so there may be a simplification here,
    but it needs more than one AP to justify.
  - the ERP preamble and slot-time handlers in patch 11 respond to
    BSS_CHANGED_ERP_*. Dropping them passes a static test, but that test
    cannot see a mid-session ERP change, such as a legacy station
    joining the BSS.

If you would rather have either of them out, say so and they can go.

Testing
=======

Tested on RTL8723BS hardware together with the second series: repeated
scan, authentication, association, WPA2 handshake, DHCP, bidirectional
traffic, reconnects and module reloads. On one AP at strong signal
(-38 dBm), 2.4 GHz HT40, throughput is roughly 34 Mbit/s down and
17 Mbit/s up, with no "failed to get tx report" warnings and a clean
log.

Every patch builds with W=1 with no warnings on its own, and sparse and
smatch are clean at the tip. checkpatch --strict is clean across this
series. The other rtw88 bus and chip modules continue to build.

Changes in v2:
  - Dropped "tx: extend the TX report purge timeout". Instrumenting the
    report path shows payload[6] & 0xfc equals the enqueued sequence
    number, 32 out of 32 times, with rtw88's existing decode, and no
    report is missed. The longer timeout was covering for the next
    patch, not for the hardware.
  - Dropped "fw: handle the RTL8723BS management TX reports". 0x12 and
    0x32 are the first payload byte of C2H_CCX_TX_RPT, not C2H IDs;
    every C2H event this chip sends carries a known id, so the existing
    handler already covers them. Thanks to Bitterblue for catching this.
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

Luka Gejak (11):
  wifi: rtw88: add the RTL8723B chip type and SDIO helper
  wifi: rtw88: rx: mark zero length packets on RTL8723BS
  wifi: rtw88: fw: add the GNT_BT firmware command
  wifi: rtw88: fw: fix the reserved page upload on RTL8723BS
  wifi: rtw88: coex: add the RTL8723BS scan antenna workaround
  wifi: rtw88: coex: reassert the antenna path when associating
  wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
  wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
  wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
  wifi: rtw88: record beacons from the target BSSID before
    authenticating
  wifi: rtw88: run the RTL8723BS association register sequence

 drivers/net/wireless/realtek/rtw88/coex.c     | 225 +++++++-
 drivers/net/wireless/realtek/rtw88/coex.h     |   3 +
 drivers/net/wireless/realtek/rtw88/fw.c       |  38 +-
 drivers/net/wireless/realtek/rtw88/fw.h       |   4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 527 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/main.c     |   2 +
 drivers/net/wireless/realtek/rtw88/main.h     |  29 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   3 +
 drivers/net/wireless/realtek/rtw88/rx.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     | 328 ++++++++++-
 drivers/net/wireless/realtek/rtw88/sdio.h     |  18 +-
 drivers/net/wireless/realtek/rtw88/sec.h      |   1 +
 12 files changed, 1154 insertions(+), 32 deletions(-)

-- 
2.55.0

