Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC09A3CF1E6
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238664; cv=none; b=P+HN812/SxsnTZz5jsyN94WjihGODyej175QjsTvAuAmXG1p7hcsSIArqR/FZ/1FmqJx0WQJO+dMyZCGBcj/0T8PlopcWsBbYsnbEJC5RoPsCWLGnwChkQrhvit1EWsmK621tIFHGHacE1nhR5d7RGw4/CSD7VfXNF0s7vryeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238664; c=relaxed/simple;
	bh=xLGdQCYH8fv/MMj4Cl6/vPRyWC2T7C08ioRwAvs/MNc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=Yj857UdWNfuAtJv1SYbQpSB8gyzWfhAr5BLTx5CTX+AScZurB3zo+FEETnx9Asv5+jgVqvc2wTPZ4WiQj7q3Qlie0VfZIBcbA8pFlmpIUD9rWVnBgeJr/Xdw4ZvmzFWnQaLtyfFzJkHvexPRRToo9bC5xhAEz7Z5RLrZT9d1nCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SncIlRNW; arc=none smtp.client-ip=95.215.58.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SncIlRNW"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xLGdQCYH8fv/MMj4Cl6/vPRyWC2T7C08ioRwAvs/MNc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790238659; v=1; x=1790843459;
 b=SncIlRNWYIX7cl54LqKJMaI+QZ2O+7GGZNzKg8jZchf4AQEC65yED8+gspJu4kKuHn8Xz+/k
 4jleJFG/RSPxQ0JnIDWvNqUaMxfjlyVtwA/nSdlk92ftz4gjGRb5HkMVPRsnN1vQetmzejsTVeI
 qkMdf7S98z6czwyQe/E0mNpE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 645dadc53ae5ce75;
	Thu, 24 Sep 2026 08:30:59 +0000
X-Mizu-Trace-ID: 645dadc53ae5ce75
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 08:30:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <92337f29a7dd8d517c2037e857e13eb2612e10e7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
 <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
 <304bbb9a43a74e909eec0dd84d86d528@realtek.com>

Hi Ping-Ke,

September 24, 2026 at 06:11, "Ping-Ke Shih" <pkshih@realtek.com> wrote:
>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:

Answers in the order of your mail. The MAINTAINERS point is in a
separate reply.

> Can you also review other RTL8723B specific functions? I didn't review
> them one by one by v3, but I wonder why it needs specific functions,
> not common flow. If any of them is necessary, please point out reasons.
>
> By the way, I didn't only mention these three functions. At here there
> are many specific functions. Please analyze them.
> (Honestly, I don't fully re-examinate your analysis in detail, and
> believe your results.)

I went through the whole file. The part that is already common flow can
be listed exactly, because those ops point at shared code:

  power_on, power_off        rtw_power_on, rtw_power_off
  mac_postinit               rtw8723x_mac_postinit
  set_tx_power_index         rtw8723x_set_tx_power_index
  false_alarm_statistics     rtw8723x_false_alarm_statistics
  read_rf, write_rf          rtw_phy_read_rf_sipi,
                             rtw_phy_write_rf_reg_sipi
  read_efuse                 rtw8723x_read_efuse, plus the hardware
                             capability, because this chip has no
                             hardware feature report: the firmware
                             reports id 0xfd instead of the C2H
  efuse_grant                rtw8723x_efuse_grant, plus the 0x6b BT
                             power cut and output isolation write that
                             the vendor efuse path does

The calls inside rtw8723b_phy_set_param() are the ones you mean. There
are twelve of them, and I have to be straight about one thing first:
there is no shared function to reuse for them. rtw8703b and rtw8723d do
the same work inline in their own phy_set_param(), and rtw8723x has no
equivalent. So "reuse the existing" cannot be done by calling something
that exists today. What is the same, what is not, and the three ways to
fix it follow.

Same as rtw8703b, value for value:

  REG_SPEC_SIFS, REG_MAC_SPEC_SIFS, REG_SIFS, REG_SIFS + 2   0x100a
  REG_EDCA_BE, _BK, _VI, _VO           0x005ea42b, 0x0000a44f,
                                       0x005ea324, 0x002fa226
  REG_ACKTO                                                0x40
  REG_RETRY_LIMIT                                          0x3030
  REG_SLOT, REG_BAR_MODE_CTRL, REG_ATIMWND    0x09, 0x0201ffff, 0x2
  REG_SINGLE_AMPDU_CTRL, REG_RX_PKT_LIMIT, REG_MAX_AGGR_NUM,
  REG_PIFS, REG_AMPDU_MAX_TIME         BIT_EN_SINGLE_APMDU, 0x18,
                                       0x1f, 0, 0x70

8703b has a name for each of these (WLAN_SPEC_SIFS, WLAN_RL_VAL,
WLAN_BAR_VAL, WLAN_SLOT_TIME, WLAN_RX_PKT_LIMIT, WLAN_MAX_AGG_NR,
WLAN_PIFS_VAL, WLAN_AMPDU_MAX_TIME). The chip file writes most of them
as bare numbers, which is why the two look different when they are the
same, and that is on me. 8723d is not the one to compare with here: it
uses 0x17, 0x0a and 0x1c for the aggregation values.

Not shared, and I think they have to stay chip local:

  - REG_RESP_SIFS_CCK and REG_RESP_SIFS_OFDM. Only 8723b and 8822c
    write these in rtw88; neither 8723x sibling does. The comment says
    why they are set.
  - the SDIO and page side: REG_BCNQ_BDNY, REG_MGQ_BDNY,
    REG_WMAC_LBK_BF_HD, REG_TRXFF_BNDY, REG_DWBCN0_CTRL, REG_PBP,
    REG_SDIO_TX_CTRL. The first six exist in the 8812a/8821a family but
    not in either 8723x sibling; REG_SDIO_TX_CTRL is an SDIO register and
    is used from sdio.c and mac.c.
  - REG_NAV_UPPER and the two REG_PKT_*_LIFE_TIME writes, which appear
    nowhere else in rtw88.
  - the rest of the chip's own hardware: the BB and RF configuration
    and the 3-wire setup, where BB_SEL_BTG differs by HCI type; the two
    LCK steps (rtw8723b_lck() is a superset of rtw8723x_lck(), it adds
    the RF_AC standby read and write and the 0xb0 writes around the same
    poll); the phy status page layout used by query_phy_status and
    cck_rx_power; the IQK, where rtw8723x_iqk_* gives the register and
    path control backup and restore and the compare, and the rest of the
    algorithm and its tables are this chip's; the power track tables;
    set_channel_bb and set_channel_rf; and the coex antenna, PTA and RFE
    logic, which each sibling has its own version of.

Here is the accounting for all twelve. init_adaptive_ctrl, init_edca,
init_retry_function and init_burst_pkt_len are your "the same"
comment, see the reuse answer below. init_tx_buffer_boundary,
init_operation_mode and init_beacon_parameters are the chip's own: the
FIFO page boundaries and REG_TRXFF_BNDY, REG_BWOPMODE which appears
nowhere else in rtw88, and a beacon control value that differs from
8703b. init_page_boundary, init_transfer_page_size,
init_driver_info_size and init_antenna_selection are one write each and
have no reason beyond naming the step, and 8723d writes REG_LEDCFG2
inline with the same value. Those four I can fold into phy_set_param()
so they read like the siblings, or leave them named, your call.

The twelfth is init_wmac_setting(), and it is where I found a real
problem:

1. rtw8723b_init_wmac_setting() re-implements part of
   rtw8723x_mac_init(), and one line of it is missing.
   rtwdev->hal.rxfltmap1 is never set. Every other chip sets it, and
   rtw_ops_configure_filter() writes it back to REG_RXFLTMAP1 when
   FIF_CONTROL is turned off, so on this chip that write would put 0
   into the register. The register itself is written correctly here, it
   is the cached value that is missing. I did not spot this in v4.

   The fix I would make is to drop rtw8723b_mac_init() and let the chip
   point at rtw8723x_mac_init(). That writes REG_TCR, RXFLTMAP0/1/2 and
   sets hal.rxfltmap1. It also writes REG_RCR with the vendor 8723x
   value, which is fine for this chip: phy_set_param applies the RCR we
   want after it, and rtw_core_start() applies hal.rcr after that. Then
   rtw8723b_init_wmac_setting() keeps only the RCR and the two REG_MAR
   writes, or disappears entirely if the RCR moves to rtw_core_init(),
   see below.

Outside that block, two more functions carry the same question, and I
would rather answer them now than in a later review.

2. rtw8723b_fill_txdesc_checksum() is the same body as
   fill_txdesc_checksum_common(txdesc, 16), which 8812a, 8821a, 8821c,
   8814a and 8822b already call with the same sixteen words. Only the
   shared 8723x version inverts the sum, which is what the comment here
   points at. If the non-inverted sum is deliberate for this chip, I
   will keep the function and say so; if it is not, the wrapper is the
   shorter answer.

3. rtw8723b_cfg_ldo25() is empty. The reason is in the vendor code:
   Hal_EfusePowerSwitch() only touches the 2.5V LDO when bWrite is
   TRUE, so on a read-only efuse path it is left alone, while the
   shared rtw8723x helper clears BIT_LDO25_EN whenever it is called
   with enable false. That is a hardware reason, so the function stays,
   but I would like the comment to say that instead of what it says
   now.

> I think the better way is to assign proper rtwdev->hal.rcr per chip
> in rtw_core_init().

I agree, and here is why the chip did it by hand, so we can pick how to
do it properly.

The value is the vendor 8723x one, 0x700060ce, plus BIT_APP_FCS, which
is needed because rtw88 advertises RX_INCLUDES_FCS for every chip. The
chip cannot just write the register: rtw_core_start() writes hal.rcr to
REG_RCR after power_on, which runs after phy_set_param(), so a write
that only touches the register is undone. Assigning hal.rcr is what
makes it survive, and fw.c and mac80211.c then keep toggling the same
cached value.

Doing it your way means a per-chip value in rtw_chip_info and the
assignment in rtw_core_init(). Two things I would want to get right:

  - the per-chip value has to keep BIT_APP_FCS, so it is not the same
    constant as the shared 8723x one;
  - rtw8703b and rtw8723d would keep the current default, so this
    changes nothing for=20them. Today __rtw8723x_mac_init() writes
    0x700060ce to REG_RCR and rtw_core_start() replaces it with the
    default, so that write does not survive anyway. Whether the shared
    value should reach those chips is a separate question and I think
    it needs its own patch, not this series.

If you prefer, I can put the core change in a small patch before the
chip series rather than in patch 3, so the chip series stays free of
core changes.

> Can you reuse the existing since they are the same?

For init_adaptive_ctrl, init_edca and init_retry_function, and also for
init_burst_pkt_len, which is the same block as the packet burst part of
rtw8703b_phy_set_param() down to the last write (8703b names BIT(7) as
BIT_MASK_TXQ_INIT, this file writes BIT(7)): the values are the same,
but there is nothing to call. The three ways:

  a. inline them into rtw8723b_phy_set_param() in the 8703b order, with
     the 8703b macro names. This makes the objection go away and patch 3
     reads like the two siblings. The per-step comments would move or
     be dropped.
  b. keep the named functions and give the reason for each. Smallest
     diff, but it does not really answer "why specific functions".
  c. move the common part into rtw8723x (a shared
     rtw8723x_phy_set_param() helper, or just the WLAN_* macros in
     rtw8723x.h) and call it from 8723b, 8703b and 8723d. Best answer
     to "they are the same", but it edits the two chips that are already
     in.

I lean to (a) or (c). Tell me which and I will do it that way.

> (Please quote the code; to reply to this, I need to switch to your
> patches again).
>
> I can guess you write u32 and then u8 for optimizing stack. Maybe,
> you can rename the names or change types. Just keep reverse X'mas
> order as possible as you can. One exception is dereference prior
> pointer (but still can change the code to fix reverse X'mas order).
> Another exception is put 'struct' declarations first, and then
> fundamental data type.
>
> Please try your ways to fit simple rules. Otherwise, if I accept this,
> it is hard to me to explain the reasons if other people ask me days
> later.

Here is the code you marked, from rtw8723b_reassert_rx_path():

	u32 rf_wlint_before;
	u32 rx_path_before;
	u32 fpga0_before;
	u8 sys_func_before;
	u8 rf_ctrl_before;

You are right about the cause, it is grouped by type and not by line
length. It was not for stack packing, the compiler decides the layout
either way; the grouping just read better to me, which is not a good
enough reason against a rule. The first assignment in the body is
sys_func_before, then rf_ctrl_before, fpga0_before, rx_path_before,
rf_wlint_before, so the block is reverse of use, not reverse of line
length.

Longest line first would put the two u8 names between the u32 names,
because of the length of the names, not the types:

	u32 rf_wlint_before;     21
	u32 rx_path_before;      20
	u8 sys_func_before;      20
	u8 rf_ctrl_before;       19
	u32 fpga0_before;        18

That is why I did not just reorder it. Taking your suggestion of
renaming, the type grouping and the length order can both hold:

	u32 rf_wlint_before;
	u32 rx_path_before;
	u32 fpga0_before;
	u8 sys_before;
	u8 rf_before;

If you prefer the plain longest first order with the current names, I
will do that instead, it is a two line move.

While I was in the file I applied the same check to every declaration
block, not only that one. Ten others are ordered by type rather than by
line length:

  rtw8723b_default_cck_index()       u8 swing before u8 i
  rtw8723b_phy_load_bb_tables()      rfe_def before chip
  rtw8723b_lck()                     ret after val_ctx and rf_val
  rtw8723b_iqk_tx_path_a()           sdio_iqk first
  rtw8723b_iqk_one_round()           a_ok before i
  rtw8723b_phy_calibration()         final_candidate second, after dm_inf=
o
  rtw8723b_pwr_track()               dm_info before efuse
  rtw8723b_coex_write_bb_sel_btg()   sys_func_before before readback
  rtw8723b_coex_set_rfe_type()       hci_type first, then aux; coex has
                                     to stay ahead of coex_rfe, which
                                     dereferences it
  rtw8723b_fill_txdesc_checksum()    words before checksum

Two of those (coex_set_rfe_type, and phy_calibration if the structs stay
together) fall under your exceptions and cannot be fully ordered without
renaming. So my question is whether you want all of them converted the
same way as reassert_rx_path(), including renaming where the types and
the length order disagree, or only the ones that can be fixed by moving
lines, and the type grouped ones documented as the exception.

What I would like to send in v5, once you say which way you want each:

  - the MAC init block: (a) inline, or (c) shared helper, and the
    missing hal.rxfltmap1 fixed either way;
  - the RCR in rtw_core_init() as you asked, in patch 3 or as a patch
    before the series, with the shared 8723x behaviour left alone;
  - fill_txdesc_checksum as a wrapper unless the non-inverted sum is
    deliberate;
  - the declaration order converted as far as the simple rules go.

On your last sentence, that the reason is hard to explain later if it is
not written down: whatever we change will carry its reason in the code
or in the commit message, not only in this mail. The same goes for the
two things I am asking to keep, cfg_ldo25() and the RESP_SIFS writes,
which will say why they are there.

I will rebuild, run sparse and smatch, and rerun the hardware suite and
the reload soak on the new tip before sending. The driver is still
station only, the five extra SDIO IDs are still untested, and the
firmware leave LPS stall is still there.

Best regards,
Luka Gejak
