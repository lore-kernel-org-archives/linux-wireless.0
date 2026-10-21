Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609556;
	b=eKOmxaokAL4DgVN/AyXl9eLa3BjXmhibL0OUzDS3SSnPsvPvvQ0wLaRxA8pNsZOnWqih
	 6IbQAIBewTyU9eZ7wNQq/dzCa3D0nJispzFoe1saC3py0spg8+NtK4VEJYPG82oZXxrLO
	 nuemBQKYdDw8PfDZMWb/cQBdL5hmwX57+sMwpooVyChQhvEvATMMa4V3sJzNbUgFoT/Jy
	 fb7WDk4qYxgF785MfSe9imfMPpLrs/Pnm8zq/DJxm+F4ocROYtBQ5csiotGJvq8GCCNFf
	 pa0yfQCYz6Le7v2O7J66htT4FCkrM2SItufbjWVnThdRwAkA/86GX8mRq4n0LbZWRdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609556;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=xGkOicwBwIFMqNp8elb2iZowRXibLk2gdk2Zzed64pU=;
	b=yVE8FVjQFxcEb5grh0M6nsg8QIhjfJcEcMrlvGvIreSMANZTarZPqQN9xoWF4f5nL0sz
	 xli7qOS4B7+ZKmm98CykUwHmR6TwZ898uiLxGmwObSrw9bQ13AUhzzNQ2FFAglFrX+7UH
	 R4TBt5SblNVD7974A17zoPnZd0p9DrY39JSztzXI2kHtWXjTafkEkI+f27I7sc2oKb+r4
	 MJP2Q0EWsDJeecELJQ5/yDxZbayyLRciX6O84HxH1Cb5See2lSrsk4DmrBb9WpNlGsvpb
	 0nfdBU5Tk+WQe1iglEM0oiGyZkugB5olO3RQC5KkbKm9g4Rv87SR8UBQ+U/tNJt3VnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=FDFMyXBA;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13C606A326
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D13C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=FDFMyXBA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609553;
	bh=J2lbVwtV+SV1WyP7H/2W0kUeR9iagLY4kjoCgOpcShU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDFMyXBAAIlVYwbJmVyZ1ayierGxJZZyBYy7bak0S7H1YBaM0VNCqhXR6d/EJP6u6
	 dDgB9nRTaYb2o2gxP0ne6MKO0yFJBdbc1BChi/JYmeuInJ8A+a8BVLY1IGZdMEEM32
	 O+n0w4EjZo6wRmBF0cX3QjlaPAU5Zpiwh7p0N+0fOA+QZ5wTcd5Rg18pc+FYLAFfBo
	 Z1PJf8h/7rgujrU76C9dVw5x9WN30UOAVxQ7iHHcDTidAUBhoUwkV0GXH48+xzaqBM
	 8M53VWyamiEr3HVWT0DwXbqaBpTw+HvsdpCUquioJbFjSd2VWtWX9vxn+zHtyltrBE
	 oF7csZ5EuNOSQ==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EA5FD17E0203;
	Wed, 21 Oct 2026 21:05:52 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: Re: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning CCMP replay counter
Date: Wed, 21 Oct 2026 20:05:19 +0100
Message-ID: <20261021190529.3893821-1-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Beckett <bob.beckett@collabora.com>

patches that follow are:
- 1/5 is Luka's patch;
- 2/5–4/5 are debug aids, not for merging, which report suspect frames,
  optionally drop them and poison/re-check RX buffers. We are rolling
  them out with the next SteamOS kernel so users can test and report.
- 5/5 is a standalone fix that we might want to include in the tree. I
  cam upstream separately if desired.

They are included for reference mostly. Details inline below

On Wed, 21 Oct 2026 07:30:58 +0000, Ping-Ke Shih <pkshih@realtek.com> wrote:
> Bob Beckett <bob.beckett@collabora.com> wrote:
> > Hi Ping-Ke,
> >
> > We are investigating a Wi-Fi failure on the Steam Deck LCD (RTL8822CE,
> > rtw88) and would appreciate your input; details below.
> >
> > Summary
> > =======
> >
> > On RTL8822CE (PCIe, rtw88), during heavy 5 GHz VHT downlink from one AP
> > model,
>
> Since The RTL8822CE works long time in field, is the symptom only on
> specific AP with heavy load?

Yes, it only occurs with a specific AP so far. It is a Freebox Revolution Light
that is only used in France by the ISP. To be clear, we do not think that the
AP is doing anything wrong, we suspect that it is just exposing an issue with
rtw88 as it is known not to happen on Windows with the same router.

I am working on getting hold of one of those devices. So far all testing
and capture has been done via an end user who is very generously helping us
out. Once I've gotten one of these devices I'll be able to test much more
locally and grab air captures. Until then, I am reluctant to ask end users
who are not engineers to attempt significant changes to their devices for
testing.

>
> If you change to another AP or lower load (e.g. 100Mbps), does problem
> still present?

I've not been able to repro on my Asus router. Others have tested on
other devices without repro. So far only the Freebox is able to expose
the issue.

>
> > the driver occasionally hands mac80211 a frame with these
> > properties:
> > - the RX descriptor looks normal: CRC OK, ICV OK, AES, not
> >   software-decrypted;
>
> Luka's patch can fix partial, so is it still normal?

unknown yet. I'm rolling out the following patches with the next
SteaomOS kernel. It includes Luka's patch and some testing and logging
patches to hopefully get more details, no behavioural changes for
normal use. It will take a while to get details back. I'll reply once we
know more.

>
> > - the 802.11 header is correct;
> > - the bytes from the CCMP header onwards are garbage.
>
> Do you have an air capture to compare with? I'd like to bisect the cause
> if AP TX weird packets? or receive side process it wrongly?

Not yet. I can attempt that once I have a device to test locally. (this
answer applies to most other questions below requiring device access or
making modifications to device/sw setup)

>
> >
> > The AP's own PN sequence is consistent before and after the bad frame,
> > so the corruption happens on the receive side.
>
> Maybe this is a hint to make a patch to defer (drop) reporting weird packet,
> as Luka has fixed 3 of 4 problems.
>
> > Public reports of the same symptom with this AP (Steam Deck LCD +
> > Freebox Revolution, 5 GHz, drops when a download starts, fixed by
> > disabling 802.11ac on the AP, works under Windows) go back to at least
> > September 2024.
>
> With disabling 802.11ac, how about the change of traffic? become not a heavy
> load? Can you test with 802.11ac enabled but lower load as disabling 80211.ac?
>
>
> >
> > Evidence 3: other RX-path anomalies in the same run
> > ===================================================
> >
> > - 33 s before the first jump, during the download and with no other
> >   activity, one descriptor claims pkt_len 11619 (above the 11454
> >   maximum), and rtw_rx_query_rx_desc() returns -EINVAL twice in the same
> >   second. These are garbage descriptors, which the rtw-next
> >   RX-descriptor validation correctly rejected. This was never seen in a
> >   21-minute ~540 Mbit/s test against a different AP.
>
> If we enlarge RTK_PCI_RX_BUF_SIZE (e.g. +1000 bytes), would it help?
> But it is still weird to me why the pkt_len 11619 can present.

The bad frames are 3092 bytes (pkt_len from the descriptor), against a
11478-byte buffer, so each one is well inside its own buffer, and the corruption
starts 26–30 bytes in. Nothing from this AP came close to the limit: the
largest A-MSDU in the captures was about 9.7 KB, and the
new_len > RTK_PCI_RX_BUF_SIZE drop never triggered.

Each bad buffer also starts with a valid descriptor whose sequence number
matches its own header, so it isn't spill-over from an earlier frame. 
The 11619 descriptor is above the 11454 VHT maximum, so it can't be a real
frame, it is just as garbage as the bad payloads, and the descriptor validation
drops it regardless of buffer size. So I don't expect a larger buffer to help
here.

Separately, 11454 + 24 has no room for PHY status and shift for a maximum-size
MPDU, which may be worth fixing on its own.

>
> For different AP, it might not send a specific size of packets, so it
> never happens. No idea.
>
> >
> > Where the corruption appears to come from
> > =========================================
> >
> > Host DMA bookkeeping is consistent. rtw88's rtw_pci_dma_check() compares
> > the RX tag in each buffer descriptor with the expected sequence and logs
> > "pci bus timeout, check dma status" on a mismatch (an unconditional
> > dev_warn). That warning appears zero times in all three runs,
>
> Good to know this.
>
> > so every
> > buffer descriptor had been written when the driver consumed it. The
> > start of each bad buffer is also fresh: the RX descriptor's sequence
> > number (w2[11:0]) matches the 802.11 header's.
> >
> > The corruption boundary does not line up with PCIe writes. The device
> > has MaxPayload 128 bytes, and on this host nearly every RX buffer goes
> > through SWIOTLB bounce slots, which start 2 KB-aligned because rtw88
> > sets no min_align_mask (see below). So DMA writes split at 128-byte
> > boundaries of the buffer. The good data ends 82 or 86 bytes into the
> > buffer, which is not such a boundary.
>
> What is the problem? Cache-line size? or device DMA corruption over boundary?

no idea yet. Hopefully these next tests can at least help rule out dma
still in flight.

>
> As Luka's suggestion, it is worth to try IOMMU.

I'll try that once I have the router.

>
> > Ruled out
> > =========
> >
> > - Oversized MPDUs (new_len > RTK_PCI_RX_BUF_SIZE): the bad frames are
> >   3092 bytes, and A-MSDUs from this AP top out at about 9.7 KB.
>
> The bad frames are never over RTK_PCI_RX_BUF_SIZE, right?

correct

>
> > - ASPM / deep LPS: jumps 3 and 4 happened seconds after reloading with
> >   disable_aspm=1 disable_lps_deep=1.
>
> With disable_aspm=1, you should turn off/on (cold reboot) platform to
> take effect.

oof. yeah. I missed that.
So our testing with aspm off is not reliable for previous runs.
I added patch 5/5 below that should allow it to take effect while loading the
module and will include it in the next SteamOS kernel.

>
> > - Power save (iw ... power_save off) and beamformee (support_bf=0 +
> >   reconnect): no effect.
> > - Driver consuming a ring entry before its buffer descriptor was
> >   written: no RX-tag mismatch ("pci bus timeout") in any run.
> > - The AP sending a bad PN: the PN sequences on both sides of each bad
> >   frame are consecutive.
>
> Can you confirm this by an air capture?

Once I have the AP

>
> > - The RX-descriptor validation added in rtw-next: it does not reject
> >   these frames, because their descriptors are well-formed.
> >
> > Questions for Realtek
> > =====================
> >
> > 1. Is there a known condition on 8822C (or 8822B/8821C) where a
> >    hardware-decrypted MPDU or A-MSDU is delivered with a valid RX
> >    descriptor (CRC32 0, ICV_ERR 0, SWDEC 0, enc AES) and a valid 802.11
> >    header, but an invalid CCMP header and payload? Does the RX
> >    descriptor or drv_info have any bit that flags it? For example
> >    "payload invalid", "decrypt engine bypassed or aborted", or a
> >    per-packet RX FIFO overflow.
>
> As I know, no.
>
> > 2. What does the vendor/Windows driver check before trusting a
> >    hardware-decrypted frame, and does it handle HISR1 RXFOVW / HISR0
> >    RDU? rtw88 masks and ignores both.
>
> Why do you think rtw88 needs to handle them?
>
> RXFOVW and RDU are to tell driver the info, but data should be handled
> by hardware properly -- with some missing data, but should not receive
> corrupted data to driver.

agreed, but as the windows driver apparently handles this AP fine, I am
assuming that it might be more resilliant to fw erroneously indicating
decrypt success (if that is the cause here).

>
> > 3. Are there RX FIFO, RX DMA, security-engine or RX aggregation settings
> >    in the Windows driver for 8822CE that differ from rtw88's and matter
> >    for high-rate VHT A-MSDU reception (80 MHz, 2SS MCS 8-9, ~3 KB
> >    A-MSDUs at ~20k/s)?
>
> I'm not very sure they are identical (but most similar). You can check
> association frames by air sniffer to see their difference.
>
> > 4. For completeness: on these chips can RXBD_IDX or the
> >    buffer-descriptor RX tag ever be updated before the packet data DMA
> >    has completed, as described for WiFi 7 in rtw89 0bc7d1d4e63c?
>
> The RX tag in rtw88 located on memory allocated by dma_alloc_coherent(), and
> the RX tag must be set after packet data MAC completed.

Understood that this is the design intent. My question was whether the host can
ever observe the tag before the data. dma_alloc_coherent() only makes the tag
visible to the CPU without cache maintenance; the payload is in a separate
streaming mapping (a SWIOTLB bounce buffer on this platform), so the order in
which the host sees them depends on the order of the device's PCIe writes.
Relaxed Ordering is enabled on the 8822CE here (DevCtl RlxdOrd+).
Does the 8822CE set the RO attribute on RX DMA writes, in particular the
buffer-descriptor/tag update? If it does, the tag write may pass the payload
writes.

We are hoping to test this directly with the next round of tests. the rx_debug
option re-syncs a suspect buffer 100 us later, so late payload writes might
show up as changed bytes, and we can repeat the test with Relaxed Ordering
disabled.

>
> > 5. rtw_rx_fill_rx_status() sets RX_FLAG_DECRYPTED whenever !swdec &&
> >    enc_type != NONE, ignoring ICV_ERR. rtw89 sets RX_FLAG_FAILED_FCS_CRC
> >    and not DECRYPTED on icv_err; mt76 marks such frames monitor-only;
> >    rtlwifi drops them. rtw88 does not set BIT_AICV in RCR, so such
> >    frames are presumably dropped in hardware, and these frames had
> >    ICV_ERR clear anyway. Would you take a patch aligning rtw88 with
> >    rtw89 regardless?
>
> I suppose Luka's patch did them.
>
> > Appendix: raw dumps (run C, MACs redacted)
>
> If you have an air capture by another platform, it'd be helpful.

In future, hopefully.

>
>
> In my perspective, we need an air capture to bisect which part causes
> the garbage (or not properly decrypted). The packets with abnormal PN
> not handled by Luka's patch need additional workaround to drop it.

See patch 2 that follows. Assuming it works out, we can work on an
upstream version.

>
> Ping-Ke


Luka Gejak (1):
  wifi: rtw88: do not trust a claimed decryption

Robert Beckett (4):
  wifi: rtw88: report and optionally re-verify suspect hw-decrypted frames
  wifi: rtw88: pci: optional RX buffer poisoning and recheck
  wifi: rtw88: make the PN guard threshold a test parameter
  wifi: rtw88: pci: clear CLKREQ/ASPM enables when disable_aspm is set

 drivers/net/wireless/realtek/rtw88/mac80211.c |   3 +
 drivers/net/wireless/realtek/rtw88/main.c     |   9 ++
 drivers/net/wireless/realtek/rtw88/main.h     |  19 +++
 drivers/net/wireless/realtek/rtw88/pci.c      | 153 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/pci.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rx.c       | 145 ++++++++++++++++-
 6 files changed, 324 insertions(+), 7 deletions(-)

-- 
2.55.0

