Received: from mail-10697.protonmail.ch (mail-10697.protonmail.ch [79.135.106.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3726C192D8A
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 02:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790909389; cv=none; b=U6nV0Ue2pqEusyio1g4bSxRsppPfSybjLUZrcFbfz3d9MW9C46M/AM4rVQ3Wv7CRdEbvOwchJhu9pA9HvTaM5HYOyeptD6QZ/R+KHa0tUK3W/q601jG0EELlQ35fk2mEp8HPzWM0IFEIh/hSJBM9xZMia8414J6lCHWi9vyftw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790909389; c=relaxed/simple;
	bh=NtgAXm2AY4dCx6yXpwt/+3ab8yqkCfLMYOQgP/A5pL8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Q/1PygaI5uyYFbh+DzPtfm3nkS8MfAJ5BiIAd7bXvtEsv7lpSWPHZKxH62ClF7NJcJyWWOdbYxw6tQ5//s73Th+CUXNiHCuIiusuKJ3DnKqx/GzKl3pADfLhiAYn1UbrgmuRWwRb/MD4CobTrrISC5sj8LEwsHtsXsT5D7vu8jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=IeBIwQil; arc=none smtp.client-ip=79.135.106.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="IeBIwQil"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790909374; x=1791168574;
	bh=l1gGDrgbK8T5dc/HknqE5dRjmD+cBJxXQ6C9XM9TUiY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=IeBIwQilp8JD74HwQTF7AiiZyxa8RJpTsFva2s8/VoLI25+SWzCw9uoWhuDwyiX11
	 g9uxlKvutiCkZEQtHLTASUZYMyF5Bu61w1fm5lJt8+mgjE/gZixiWJQ3n+LL9Dm8k5
	 yAvcYcu9Y7aNBJhehlyQ9a2L7iS+vugm2NkD5QA6zdJM9dgv0vqJxDLfHQHNkmRstJ
	 okRAuXObI5v1UvnwEWk+15bNwvUIBVLY5+MUv3gSw+HK0CJzJEVmimKJV5DSseyvW5
	 2p3/ZmFVlnnvlZ5MFsTRf4oRMbIVEMqG47cHiQNAIjd0g06WfduuKvzTw7I4VWmkq7
	 ToPUN2qilyNzw==
Date: Fri, 02 Oct 2026 02:49:30 +0000
To: "pkshih@realtek.com" <pkshih@realtek.com>
From: Adilson <aoleandro@proton.me>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wifi: rtw89: 8852AE: zero SMA in addr CAM for virtual monitor vif, and ~200 ms delay before first TX attempt of injected unicast
Message-ID: <b41nlcULR-r_hxbVG6EOsjESlvS4yT_ArYlWgP26g34UKbdoMRoLxMd2pLl4h0L6sB1GOAGr2pT2ofsCRXAcJSqm4lxEWIwH4gTZbjFVmiI=@proton.me>
Feedback-ID: 225530312:user:proton
X-Pm-Message-ID: 327e77a324c2513b9333c2e979879caf9802b0ac
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ping-Ke,

I am working on Linux interoperability with Apple's AirDrop, using a
userspace AWDL implementation (OWL, from TU Darmstadt's SEEMOO Lab) on
top of a monitor interface with radiotap injection. While testing on an
RTL8852AE I found two issues in the monitor/injection path. The first
has a cause and an experimental fix; the second is a question about
firmware behavior.

With the fix for (1) and a workaround for (2), a complete transfer of a
small test file from a current macOS to this card now succeeds
(discovery, request and upload, with the received file identical to
the original). So the fix seems useful in practice, and the remaining
delay is the main obstacle to a clean implementation.

Setup:
- RTL8852AE, PCIe 10ec:8852, firmware 0.13.36.2 (52acc807)
- kernel 7.2.8; the rtw89 directory is identical to upstream v7.2.8
- passive monitor interface (rtw89 does not support active monitor),
  injected data frames at a fixed rate of 12 Mb/s via radiotap
- peer: a MacBook, on channel 149

I checked rtw-next and wireless-next as of October 1, 2026 and found no
changes touching these paths.

1) The virtual monitor vif gets SMA 00:00:00:00:00:00 in the addr CAM

I understand that a passive monitor interface is not expected to ACK.
The problem is that, when injecting, the peer then retransmits every
frame it sends back to us: in a 40-packet ping test, the peer sent 15
original frames and 89 retries. The concrete cause seems to be the
address of the virtual monitor vif.

rtw89 sets WANT_MONITOR_VIF. Without active monitor, mac80211 does not
pass the monitor netdev to the driver and creates the virtual monitor
vif in ieee80211_add_virtual_monitor(). That vif is allocated zeroed and
reaches the driver without an address. rtw89 copies it into
rtwvif->mac_addr and rtwvif_link->mac_addr, and rtw89_mac_add_vif()
then programs the addr CAM (rtw89_mac_vif_init() -> rtw89_fw_h2c_cam()
-> rtw89_cam_fill_addr_cam_info()) with SMA =3D 00:00:00:00:00:00, and
TMA =3D the zero BSSID. A debugfs dump of the addr CAM (mac_mem_dump)
confirms it: entry 0 is valid, with both SMA and TMA zero.

For context, mac80211 marks passive monitor interfaces with
vif->addr_valid =3D false, not with a zero address; the zero address comes
only from the internal virtual monitor vif, which is what rtw89 receives
with WANT_MONITOR_VIF. So the question is rather what rtw89 should
program into the addr CAM for that vif when frames are injected through
it.

Experimental fix: when the vif is a monitor vif and its address is all
zeros, use the permanent address of the device before the CAM is
programmed (behind a module parameter, default off, in my test build).
With it, the addr CAM entry carries the real address, and in the same
40-ping test the peer's retries dropped from 89 to 1, with no
duplicates in the ping. So in this mode the hardware does ACK unicast
frames addressed to it once the SMA is set. Managed mode is unaffected:
the change only acts on a monitor vif with a zero address, and since
ieee80211_open() rejects any netdev without a valid address, only the
virtual monitor vif (which has no netdev) can reach the driver that
way.

Would a patch along these lines be acceptable upstream? And would it
be enough for, or a step towards, advertising ACTIVE_MONITOR on these
chips? The fix could also key on addr_valid instead of testing for a
zero address, if you prefer.

2) Injected unicast waits ~200 ms before the first TX attempt

Injected unicast data frames reach the peer much later than injected
multicast. Your series from November 2025 (rate/bw/GI for injected
packets) is included in this kernel; it does not seem to touch this
wait. What I measured:

- mac80211 to driver: 5 to 19 us (bpftrace on the TX path).
- With the default retry settings, the peer's ACK (seen in an
  over-the-air capture) arrives 150 to 469 ms after the driver hands the
  frame to the hardware.
- TX status: every unicast frame without a peer ACK fails with status
  1 (retry limit exceeded); none with status 2 or 3.
- With a per-frame retry limit in the TX descriptor
  (DATA_TXCNT_LMT_SEL, the same field the driver already uses for USB,
  set here by a second experimental change, since on PCIe the driver
  does not write it), the limit is honored. Answered pings out of 40,
  before the fix in (1): limit 1: 0, limit 2: 3, limit 4: 4,
  default: 15. With a limit of 1, the failure status arrives 148 ms or
  more after the handoff; subtracting the ~8.5 ms status latency, the
  single attempt happens 140 to 445 ms after the handoff (32 of 40
  frames between 160 and 220 ms). So the wait happens before the first
  attempt, not between retries.
- Injected multicast frames usually get their TX status within 2.7 to
  9.6 ms; a few outliers took up to ~200 ms.
- The wait does not line up with a 102.4 ms beacon grid, and behaves
  like a delay counted from the handoff. (Our userspace stack always
  hands frames off at the same phase of its own slot schedule, so I
  cannot fully separate the two.)
- MACID_SLEEP_0 and SS_MACID_PAUSE_0 read zero in 10,466 samples each,
  taken every ~6 ms during traffic with the stock driver, so macid 0
  does not seem to be sleeping or paused.
- Power save cannot be turned off on the monitor interface: "iw dev
  wlan0 set power_save off" returns -EOPNOTSUPP (-95), so I could not
  rule it out from userspace.
- Setting SPE_RPT on these frames did not produce any C2H TX RPT on
  PCIe: with RTW89_DBG_TXRX enabled, the debug message in
  rtw89_mac_c2h_tx_rpt(), which is printed before the skb lookup, never
  appeared.
- The fix in (1) does not change the wait.

Workaround: since the wait behaves like a delay from the handoff, our
userspace stack now hands unicast frames to the driver earlier than the
peer's availability window, with a descriptor retry limit of 4 (set by
the same experimental driver change). Calibrating the lead time, with
the fix for (1) in place: 140 ms gave 33/40 answered pings, 180 ms gave
28/40 and 220 ms gave 13/40, against 3/40 with the same settings and no
early handoff. So the wait is stable enough to be compensated. With 140
ms, the transfer above completed. It works, but it is tuned to this
card and firmware.

My guesses, untested: injected unicast goes out through macid 0, with no
station context. The driver already sets a fixed rate for these frames
(use_rate and dis_data_fb in rtw89_core_tx_update_injection()) and does
not request aggregation (no IEEE80211_TX_CTL_AMPDU), so does the
firmware hold or aggregate unicast on its own when the macid has no
station entry? Other possibilities: a slow path for unicast to an
address with no addr CAM or station entry, or the "no link" role of the
monitor port making it defer unicast.

What is the firmware waiting for in this case? Is there a descriptor
field, an H2C command, or a CAM or station setup that makes injected
unicast go out immediately, as multicast does?
Would the diag_mac or diag_bb debugfs entries from your series help to
see what the firmware is waiting for?

Disclosure: I did this investigation with the help of an AI assistant
(Claude, by Anthropic), which I used to read the driver code, write the
measurement scripts and the experimental patches, and draft this
message. All measurements were run by me on my own hardware, and I
have reviewed every claim above and can answer questions about it.

I can share the measurement scripts, captures (with personal data
removed) and the experimental patches.

Thanks,
Adilson
