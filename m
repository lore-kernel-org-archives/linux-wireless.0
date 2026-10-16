Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C0E49BB7C
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792178030; cv=none; b=ScXwWsM6/hpyxiUn5AxBWZOlwErIcirgX4krjFnWnYk9dwZQfdhK8KzVJkYh/ryNx2tnLLjHbsmuqGdlUMNqN5wWt9J/y+9EgjzEYUpZzx94ZtOnn3psI+YxFsZkU2zLJFJ6Zx0GC21vz14K0V/mteCy+itXSpm4Wih+BANzZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792178030; c=relaxed/simple;
	bh=pg3KByLUuEscpyxsXrI6Pc/yKgRV4tnT8Hg1Vcq3tyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fFOmTyrhT47ZLW0UXRNOLsl0dkvCU2NreGhMRQ7VJCZMZ7AIiEp6Lx45lYzOrH7Bcm5MrAkqa5/NDrnv8RE8NgU3uB9364JCSR3OJOzAUhjGOarQ+roZMVZs59Re+UzoJPXzGFUh0jCrESAE6QX+AXvpTVz0227A/ExmaQPos/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Lvyri1c1; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Lvyri1c1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792178025;
	bh=pg3KByLUuEscpyxsXrI6Pc/yKgRV4tnT8Hg1Vcq3tyk=;
	h=From:To:Cc:Subject:Date:From;
	b=Lvyri1c1SieGTMjyRRNaG/uVQvufD+sfLRCB3nKzhCzAbgwjg8E+KJ58AgaH8sa+w
	 VvG0YOplJnFfz4aS6yD4P9o+kRXfnhPRPmQKa2Q3sbjOmklhhaZslJRkfjr/maghcX
	 pwMCC8t7YyKylH9/tJ3rrtUdgH8nMg2v10Vk+14jRtfMuslBK4prKIFrRGL4cCSUU1
	 IG/ohZW1jGNB1OfZoarsVDylBMly5e1SFR6YgvhX9hDza0CQPFpYt3YRjo4935l1La
	 m2ypVYSBu1Opq5O18w+RuIl7oj3UVNwk3q8+lM255FX/OmyxZqiTZCRawiBZByKGHq
	 uwzFB99oi7PUQ==
Received: from hermes-devbox (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2D6A017E02C7;
	Fri, 16 Oct 2026 21:13:45 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	kernel@collabora.com,
	matthew.leach@collabora.com
Subject: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning CCMP replay counter
Date: Fri, 16 Oct 2026 20:11:00 +0100
Message-ID: <20261016191100.1781056-1-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

We are investigating a Wi-Fi failure on the Steam Deck LCD (RTL8822CE,
rtw88) and would appreciate your input; details below.

Summary
=======

On RTL8822CE (PCIe, rtw88), during heavy 5 GHz VHT downlink from one AP
model, the driver occasionally hands mac80211 a frame with these
properties:
- the RX descriptor looks normal: CRC OK, ICV OK, AES, not
  software-decrypted;
- the 802.11 header is correct;
- the bytes from the CCMP header onwards are garbage.

Because rtw88 sets RX_FLAG_DECRYPTED for it, mac80211 trusts the frame
and takes its PN, a random 48-bit value, as the new last PN for that
key/TID. Every later genuine frame has a lower PN and is dropped as
RX_DROP_U_REPLAY. The station stays associated with good signal but no
data gets through until new keys are installed (reconnect). Userspace
sees this as "limited connectivity".

The AP's own PN sequence is consistent before and after the bad frame,
so the corruption happens on the receive side. The host-side DMA
bookkeeping looks consistent: the RX buffer-descriptor tag never
mismatched. The corruption starts exactly where the CCMP header begins,
which points at the device's RX decrypt/payload path rather than host
DMA. The same hardware works with this AP under Windows, so we would
like to know what the vendor driver does differently, and whether the
descriptor can tell us when a frame's payload cannot be trusted.

Setup
=====

- Steam Deck LCD: RTL8822CE (AzureWave), PCIe x1 Gen1, rtw88_8822ce
- Firmware 9.9.15 (WOW 9.9.4), H2C version 15
- Seen on SteamOS kernels 6.18.50 and 7.2.7. Both carry rtw88 backports
  from rtw-next; the 7.2.7 rtw88 is close to rtw-next as of 2026-09.
- AP: Free "Freebox Revolution", 5 GHz channel 36, 80 MHz, VHT, max MPDU
  11454, max A-MSDU (HT) 3839, CCMP pairwise and group, PSK/SAE
- Link at the time: signal -30 to -34 dBm, RX VHT-MCS 8-9 NSS 2 80 MHz,
  during a bulk TCP download (game download) at ~20k RX descriptors/s
- wpa_supplicant + NetworkManager

Public reports of the same symptom with this AP (Steam Deck LCD +
Freebox Revolution, 5 GHz, drops when a download starts, fixed by
disabling 802.11ac on the AP, works under Windows) go back to at least
September 2024.

How it was captured
===================

The capture used bpftrace on the stock kernel, with no driver changes:
- a kprobe on ieee80211_crypto_ccmp_decrypt() compares the frame's PN
  with key->u.ccmp.rx_pn[rx->security_idx] before the check, and on a
  forward jump above 0x10000 dumps:
  - the frame;
  - the rtw88 RX descriptor plus drv_info area, which is still in the
    skb in front of skb->data (rtw_pci_rx_napi() uses skb_pull());
  - the previous 16 and next 24 CCMP frames;
- a kprobe on rtw_rx_query_rx_desc() classifies every descriptor;
- an fexit on rtw_pci_read32() for HISR0/HISR1;
- tracepoint:skb:kfree_skb provides drop reasons;
- mac80211 debugfs keys/*/rx_spec and replays were sampled every 2 s.

Evidence 1: the replay counter is poisoned by one frame
=======================================================

From mac80211 debugfs, for the pairwise key at TID 0:

  Run       rx_spec before  At failure    ~1 min later  replays
  --------  --------------  ------------  ------------  ------------
  A (6.18)  0000000004b1    38edae88b295  38edae88b295  1508 -> 2759
  B (7.2)   0000000093d2    cc7106634a65  cc7106634a65  748 -> 1832

- The stored PN never moves again, so no pairwise-protected frame is
  accepted after the bad one: every one that reaches the CCMP check is
  dropped as RX_DROP_U_REPLAY (skb:kfree_skb reason 0x10002 in
  ieee80211_rx_handlers). The only data still accepted is
  group-addressed traffic, which uses the unaffected group key; its PN
  keeps advancing normally.
- Reconnecting installs new keys and traffic resumes, until the next bad
  frame.

Evidence 2: the bad frames
==========================

Run C (7.2.7) caught 4 PN jumps in about 6 minutes:

  #  seq         last PN         PN in frame     expected PN
  -  ----------  --------------  --------------  -----------------------
  1  4025        0xb8fba         0x3dcdcabef924  0xb8fbc (4026: 0xb8fbd)
  2  3174        0xcc69          0x08e1ad331968  0xcc6a  (3175: 0xcc6b)
  3  64 (retry)  0x15043         0x4bf378495044  0x15044 (66: 0x15046)
  4  65 (retry)  0x4bf378495044  0xf0e626ce3844  0x15045

  All four: QoS data, TID 0, A-MSDU, 3088 bytes. 3 and 4 came seconds
  after a reconnect. "Expected PN" is derived from the neighbouring
  frames (next SN in brackets).

Around jump 1, the AP's PN sequence was:
- seq 4009-4023: PN 0xb8fac-0xb8fba, consecutive;
- seq 4024: never reached the CCMP check;
- seq 4025: the bad frame;
- seq 4026, 4027, ...: PN 0xb8fbd, 0xb8fbe, ..., all rejected as
  replays.

So the AP transmitted a normal PN for 4025.

The four bad frames share these properties:
- The RX descriptor is identical to the good frames around them:
  w0=0x00c40c14, i.e. pkt_len 3092, drv_info_sz 4, PHYST 0, enc AES,
  CRC32 0, ICV_ERR 0, SWDEC 0. w1=0x2100b004, w3=0x3f (VHT 2SS MCS9).
  The low 12 bits of w2 equal the 802.11 sequence number of the frame.
- The 802.11 header is correct: FC 0x4288/0x4a88 (QoS data, FromDS,
  Protected, +/-Retry), correct addresses, sequence number matching the
  descriptor, QoS control 0x0080 (TID 0, A-MSDU present).
- The bytes from header offset 26 are garbage. A valid CCMP header has
  byte 2 = 0x00 and byte 3 = 0x20 (ExtIV, key ID 0), as all the good
  frames do:
  - frame 1: 24 f9 1a 04 ...
  - frame 2: 68 19 8e b7 ...
  - frame 4: 44 38 f1 14 ...
  - frame 3: 44 50 00 20 49 78 f3 4b. The first four bytes match the
    expected PN 0x015044 exactly, then it is garbage from header offset
    30.
  - The "decrypted" A-MSDU body that follows is random. It should start
    with a subframe header containing the station's own address.
- mac80211 receives flag=0x20102, i.e. RX_FLAG_DECRYPTED |
  RX_FLAG_NO_SIGNAL_VAL | RX_FLAG_MACTIME_START (no PHY status, so no
  signal value).

In other words, the descriptor and roughly the first 26-30 bytes of the
frame are right, and the rest of the buffer does not contain this
frame's data.

Evidence 3: other RX-path anomalies in the same run
===================================================

- 33 s before the first jump, during the download and with no other
  activity, one descriptor claims pkt_len 11619 (above the 11454
  maximum), and rtw_rx_query_rx_desc() returns -EINVAL twice in the same
  second. These are garbage descriptors, which the rtw-next
  RX-descriptor validation correctly rejected. This was never seen in a
  21-minute ~540 Mbit/s test against a different AP.
- Not related to the bug (capture artifacts): the HISR1 RXFOVW bit (RX
  FIFO overflow) and 18 "coex request time out" errors appeared only
  within 1-2 s of the capture tool's debugfs snapshots. Those snapshots
  read coex_info and the mac_*/bb_* register dumps, which hold
  rtwdev->mutex and leave deep PS. None of the PN jumps coincide with a
  snapshot.
- Firmware communication otherwise looked healthy: no H2C send failures;
  663 "C2H 0x15 isn't handled" (benign); 3 TX-report purge timeouts in
  ~8 minutes.

Observation: heavy AP retry activity around the event
-----------------------------------------------------

Shortly after jump 1, the genuine TID 0 stream shows a single PN gap
with consecutive sequence numbers:

    seq=4044 pn=0x0000000b8fcf  w0=0x00c40c14  (no PHY status)
    seq=4045 pn=0x0000000b9053  w0=0x04c40c14
        (PHY status present: first MPDU of a new PPDU)

- Of 69 consecutive-SN pairs logged in this run, this is the only one
  where the PN advances by more than 1; here it advances by 0x84.
- The PN counter is per key and the SN counter per TID, so the AP
  encrypted 131 other frames for this station in between without using
  new TID 0 sequence numbers.
- No other TID's PN counter on the pairwise key ever advanced (rx_spec
  for TIDs 1-15 stays 0), so these were not frames on another TID that
  we accepted.
- The gap falls between two A-MPDUs.

The likeliest explanation is that the AP retransmitted about 131
already-numbered MPDUs and re-encrypted each retransmission with a fresh
PN. IEEE 802.11 expects retransmissions to keep their PN, but some
implementations re-encrypt on software retry. This matches what else
happened around the onset:
- a BlockAck Request (BAR_RX_EVENT) and a BlockAck frame timeout;
- about 3,500 data frames in the second after the jump that never
  reached the CCMP check and left no kfree_skb drop reason. That is
  consistent with mac80211's A-MPDU reorder buffer discarding
  out-of-date retransmissions via dev_kfree_skb(), i.e. consume_skb(),
  which kfree_skb tracing cannot see.

This is not confirmed yet; a follow-up capture traces skb:consume_skb
per caller to account for those frames. A PN gap is legal and is not the
cause of the failure. It does suggest that the bad frames arrive while
the AP is doing heavy retry/re-aggregation toward the station.

Where the corruption appears to come from
=========================================

Host DMA bookkeeping is consistent. rtw88's rtw_pci_dma_check() compares
the RX tag in each buffer descriptor with the expected sequence and logs
"pci bus timeout, check dma status" on a mismatch (an unconditional
dev_warn). That warning appears zero times in all three runs, so every
buffer descriptor had been written when the driver consumed it. The
start of each bad buffer is also fresh: the RX descriptor's sequence
number (w2[11:0]) matches the 802.11 header's.

The corruption boundary does not line up with PCIe writes. The device
has MaxPayload 128 bytes, and on this host nearly every RX buffer goes
through SWIOTLB bounce slots, which start 2 KB-aligned because rtw88
sets no min_align_mask (see below). So DMA writes split at 128-byte
boundaries of the buffer. The good data ends 82 or 86 bytes into the
buffer, which is not such a boundary.

It lines up with the CCMP header. In frame coordinates, the good data
ends exactly at offset 26 (the start of the CCMP header), or 4 bytes
into it in one frame. That is where the part of the frame the MAC passes
through unchanged (the 802.11 header) ends, and the part handled by the
hardware decryption engine begins. Our reading is that for these frames
the payload/decrypt path produced wrong data while the descriptor still
reported CRC OK, ICV OK and hardware-decrypted. That would be a
device-internal condition, possibly related to the RX FIFO: the garbage
descriptors at Evidence 3 point the same way.

Remaining host-side possibilities, considered less likely:
- Relaxed Ordering: DevCtl: RlxdOrd+ is enabled for the device. If its
  payload writes carried the RO attribute, they could in principle be
  overtaken by the descriptor/tag write. It can be tested at runtime by
  clearing RO with setpci.
- Index ahead of DMA: Realtek fixed this class of race in rtw89
  (0bc7d1d4e63c "validate RX tag for RXQ and RPQ": "DMA and ring index
  are asynchronous, so suddenly driver gets newer index ahead before
  DMA"; also 94298477f81a, dda27a47c036). For pre-WiFi 7 chips the
  commit says they "use different design and don't really meet this
  situation". Here the buffer descriptor and the head of the buffer were
  demonstrably complete.

Platform note: the kernel boots with amd_iommu=off ("PCI-DMA: Using
software bounce buffering for IO (SWIOTLB)"). rtw88 uses the default
32-bit DMA mask, because its RX buffer descriptor holds a 32-bit
address, and the machine has 16 GB, so nearly every RX buffer is
bounced. rtw_pci_rx_napi() syncs the full RTK_PCI_RX_BUF_SIZE (11478
bytes) per frame regardless of length, about 230 MB/s of memcpy at 20k
frames/s. This does not explain a boundary at the CCMP header, but it is
unnecessary overhead.

For comparison, rtlwifi's 8192EE ("new TRX flow" rings, commented "in
Windows, this == Rx_92EE_Interrupt") polls the RX buffer descriptor
before use (rtl92ee_rx_check_dma_ok()), and only passes frames up when
!crc && !hwerror (hwerror = crc | icv). rtw88 passes ICV-error frames up
as decrypted.

Ruled out
=========

- Oversized MPDUs (new_len > RTK_PCI_RX_BUF_SIZE): the bad frames are
  3092 bytes, and A-MSDUs from this AP top out at about 9.7 KB.
- ASPM / deep LPS: jumps 3 and 4 happened seconds after reloading with
  disable_aspm=1 disable_lps_deep=1.
- Power save (iw ... power_save off) and beamformee (support_bf=0 +
  reconnect): no effect.
- Driver consuming a ring entry before its buffer descriptor was
  written: no RX-tag mismatch ("pci bus timeout") in any run.
- The AP sending a bad PN: the PN sequences on both sides of each bad
  frame are consecutive.
- The RX-descriptor validation added in rtw-next: it does not reject
  these frames, because their descriptors are well-formed.

Questions for Realtek
=====================

1. Is there a known condition on 8822C (or 8822B/8821C) where a
   hardware-decrypted MPDU or A-MSDU is delivered with a valid RX
   descriptor (CRC32 0, ICV_ERR 0, SWDEC 0, enc AES) and a valid 802.11
   header, but an invalid CCMP header and payload? Does the RX
   descriptor or drv_info have any bit that flags it? For example
   "payload invalid", "decrypt engine bypassed or aborted", or a
   per-packet RX FIFO overflow.
2. What does the vendor/Windows driver check before trusting a
   hardware-decrypted frame, and does it handle HISR1 RXFOVW / HISR0
   RDU? rtw88 masks and ignores both.
3. Are there RX FIFO, RX DMA, security-engine or RX aggregation settings
   in the Windows driver for 8822CE that differ from rtw88's and matter
   for high-rate VHT A-MSDU reception (80 MHz, 2SS MCS 8-9, ~3 KB
   A-MSDUs at ~20k/s)?
4. For completeness: on these chips can RXBD_IDX or the
   buffer-descriptor RX tag ever be updated before the packet data DMA
   has completed, as described for WiFi 7 in rtw89 0bc7d1d4e63c?
5. rtw_rx_fill_rx_status() sets RX_FLAG_DECRYPTED whenever !swdec &&
   enc_type != NONE, ignoring ICV_ERR. rtw89 sets RX_FLAG_FAILED_FCS_CRC
   and not DECRYPTED on icv_err; mt76 marks such frames monitor-only;
   rtlwifi drops them. rtw88 does not set BIT_AICV in RCR, so such
   frames are presumably dropped in hardware, and these frames had
   ICV_ERR clear anyway. Would you take a patch aligning rtw88 with
   rtw89 regardless?

Possible mitigation
===================

Whatever the device-side cause turns out to be, one bad frame should not
take the link down. As a defence, rtw88 could refuse to claim decryption
for an AES frame whose CCMP header is malformed. The ExtIV bit must be
set and the reserved byte must be zero for CCMP/GCMP. That lets mac80211
treat the frame as not decrypted: it then fails software decryption and
is dropped without updating the PN. This would have caught 3 of the 4
frames above; frame 3 had a plausible first half of the IV. Sketch,
untested:

    /* rx.c, rtw_rx_fill_rx_status() */
    	if (pkt_stat->crc_err || pkt_stat->icv_err)
    		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
    	if (pkt_stat->decrypted && !pkt_stat->icv_err &&
    	    rtw_rx_ccmp_hdr_valid(pkt_stat, hdr))
    		rx_status->flag |= RX_FLAG_DECRYPTED;

    static bool rtw_rx_ccmp_hdr_valid(struct rtw_rx_pkt_stat *pkt_stat,
    				  struct ieee80211_hdr *hdr)
    {
    	u8 *iv;

    	if (!ieee80211_has_protected(hdr->frame_control))
    		return true;
    	if (pkt_stat->pkt_len < ieee80211_hdrlen(hdr->frame_control) +
    				IEEE80211_CCMP_HDR_LEN)
    		return false;
    	iv = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
    	/* CCMP/GCMP header: byte 2 reserved (0), byte 3 ExtIV must be set */
    	return iv[2] == 0 && (iv[3] & 0x20);
    }

(This only applies when the hardware's enc_type is AES, and needs
pkt_len to be checked against the copied length.)

This does not catch a frame whose corruption begins after the ExtIV
byte, like frame 3. The real fix depends on Realtek's answer to
questions 1-3: a descriptor bit to honour, or an RX setting that avoids
the condition. A more general option would be a mac80211-side sanity
limit on the forward PN jump accepted from hardware-decrypted frames,
but that is a policy change in mac80211 rather than a driver fix.

Unrelated to the bug: syncing only the descriptor first and then
(pkt_len + offset) bytes, instead of the full 11478, would cut the
SWIOTLB copy cost per frame by about 4x for typical 3 KB frames on hosts
like this one.

Appendix: raw dumps (run C, MACs redacted)
==========================================

MAC addresses are redacted: SS = station (Steam Deck), AA = AP.

Layout of the buffer dump: 24-byte RX descriptor, 32-byte drv_info area
(PHYST=0, so this area is not a PHY status and contains stale bytes),
then the 802.11 frame.

Jump 1
------

    q=0 seq=4025 last=0x0000000b8fba pn=0x3dcdcabef924 len=3088
      flag=0x20102 hdrlen=26 fc=0x4288 desc_off=56 w0=0x00c40c14 w3=0x0000003f
    RX desc dwords: w0=00c40c14 w1=2100b004 w2=80890fb9
                    w3=0000003f w4=3ffe7600 w5=0476df59

    buffer (RX desc 24 + drv_info 32, then frame):
    0000: 14 0c c4 00 04 b0 00 21 b9 0f 89 80 3f 00 00 00
    0010: 00 76 fe 3f 59 df 76 04 96 3f a1 bd fb 6c 9f 26
    0020: 5b 31 fa 29 90 c6 2c 92 f9 f4 86 44 70 47 1d 2a
    0030: a2 47 2c df 83 43 0f ae 88 42 30 00 SS SS SS SS

    frame[0:128] as passed to mac80211:
    0000: 88 42 30 00 SS SS SS SS SS SS AA AA AA AA AA AA
    0010: AA AA AA AA AA AA 90 fb 80 00 24 f9 1a 04 be ca
    0020: cd 3d f1 98 26 03 ca 51 c5 d7 72 b4 5c cb d4 a9
    0030: 20 09 37 ed 83 6c c8 0d 1f 45 03 ac 86 ec d1 30
    0040: d2 42 b1 ac 33 33 8f b6 95 66 c1 c3 28 ea 84 a7
    0050: dc a3 6d 4a 86 10 9d f6 ce a8 a3 91 5b 7d be ad
    0060: d0 40 2a 35 cf b5 69 60 58 a5 6a df fd 62 b4 df
    0070: 4c c3 c6 c0 17 28 4c 25 ae b2 24 1d 05 44 e9 28

Jump 2
------

    q=0 seq=3174 last=0x00000000cc69 pn=0x08e1ad331968 len=3088
      flag=0x20102 hdrlen=26 fc=0x4288 desc_off=56 w0=0x00c40c14 w3=0x0000003f
    RX desc dwords: w0=00c40c14 w1=2100b004 w2=e0890c66
                    w3=0000003f w4=3ffea000 w5=0042a4f3

    buffer (RX desc 24 + drv_info 32, then frame):
    0000: 14 0c c4 00 04 b0 00 21 66 0c 89 e0 3f 00 00 00
    0010: 00 a0 fe 3f f3 a4 42 00 e7 ee 7c c1 05 59 a8 1f
    0020: 14 0c c4 00 04 b0 00 21 5d 0c 89 e0 3f 00 00 00
    0030: 00 a0 fe 3f fa a3 42 00 88 42 30 00 SS SS SS SS

    frame[0:128] as passed to mac80211:
    0000: 88 42 30 00 SS SS SS SS SS SS AA AA AA AA AA AA
    0010: AA AA AA AA AA AA 60 c6 80 00 68 19 8e b7 33 ad
    0020: e1 08 62 33 52 ed 0d 6a 45 ae 7d b0 a8 cc 18 03
    0030: 4a e2 fc 7e cd b3 e8 fc 99 d2 03 86 19 f1 a9 c5
    0040: 5f ef ba d6 91 24 48 24 a2 e6 de bb dd 42 4f 16
    0050: cc 0f bd ff d5 c4 a8 8b 8e ca f0 ed 77 ea c5 e8
    0060: 95 b9 51 1a 8a 88 bb 11 08 2a 54 7c 74 08 b5 df
    0070: b7 6b e1 5d 5b c6 0e fa a6 f8 7b 05 57 98 69 c8

Jump 3
------

    q=0 seq=64 last=0x000000015043 pn=0x4bf378495044 len=3088
      flag=0x20102 hdrlen=26 fc=0x4a88 desc_off=56 w0=0x00c40c14 w3=0x0000003f
    RX desc dwords: w0=00c40c14 w1=2100b004 w2=80890040
                    w3=0000003f w4=3ffee400 w5=00e8b9cd

    buffer (RX desc 24 + drv_info 32, then frame):
    0000: 14 0c c4 00 04 b0 00 21 40 00 89 80 3f 00 00 00
    0010: 00 e4 fe 3f cd b9 e8 00 c3 55 de b3 f6 ad 3a 63
    0020: a3 c2 45 b0 5e f6 1c a3 9a 18 cc e1 a8 be 11 9e
    0030: ec a8 48 3d d1 3f 03 be 88 4a 30 00 SS SS SS SS

    frame[0:128] as passed to mac80211:
    0000: 88 4a 30 00 SS SS SS SS SS SS AA AA AA AA AA AA
    0010: AA AA AA AA AA AA 00 04 80 00 44 50 00 20 49 78
    0020: f3 4b 75 3e db 0e a4 3d 81 52 1c 1a ff b2 f2 cd
    0030: 04 dd ca 84 b9 e8 05 cc 72 7b e6 5a 7e 03 40 a6
    0040: 95 6f d6 d8 94 89 ef 3f 95 76 cc 37 c2 40 6c 35
    0050: a4 93 9f 13 8d fb 0f ad 15 45 47 32 86 96 b0 bc
    0060: 1f 76 b5 af 83 b1 ed 87 d6 c0 79 12 56 89 57 c4
    0070: de dc dd 44 27 77 a3 65 cd 67 1e 49 a1 ab d8 c1

Jump 4
------

    q=0 seq=65 last=0x4bf378495044 pn=0xf0e626ce3844 len=3088
      flag=0x20102 hdrlen=26 fc=0x4a88 desc_off=56 w0=0x00c40c14 w3=0x0000003f
    RX desc dwords: w0=00c40c14 w1=2100b004 w2=80890041
                    w3=0000003f w4=3ffee400 w5=00e8b9e9

    buffer (RX desc 24 + drv_info 32, then frame):
    0000: 14 0c c4 00 04 b0 00 21 41 00 89 80 3f 00 00 00
    0010: 00 e4 fe 3f e9 b9 e8 00 75 04 60 c1 fa f1 24 13
    0020: 47 b6 bc 69 fe 61 9d c0 23 83 52 cb 32 12 4d b1
    0030: e4 8c ec 59 84 ec 40 fa 88 4a 30 00 SS SS SS SS

    frame[0:128] as passed to mac80211:
    0000: 88 4a 30 00 SS SS SS SS SS SS AA AA AA AA AA AA
    0010: AA AA AA AA AA AA 10 04 80 00 44 38 f1 14 ce 26
    0020: e6 f0 d3 39 6d 3f 56 26 4b 47 7f 76 8e 53 e4 0b
    0030: dc 81 57 79 85 94 0b d5 c0 f7 d9 00 84 6f 34 58
    0040: 6f f7 54 33 48 55 9f c5 82 69 71 6a 1b 6e 99 2c
    0050: 64 54 62 9e 73 f1 80 4e 8b 3f d4 3e 24 bc c7 a9
    0060: 81 15 18 82 eb d9 06 57 ae 14 e2 cb c0 61 2a 9f
    0070: ab d9 4d 92 9f d6 d6 fb ea 28 09 64 b5 6e f5 6d

Notes
=====

- The capture reads rtw88's rsvd_page debugfs file. On kernels without
  rtw-next 81510c3d6f21 ("debugfs: don't vzalloc(0) when rsvd_page is
  read unconfigured"), that triggers a vmalloc !size WARN. This is
  unrelated to this issue.

Thanks,
Bob
