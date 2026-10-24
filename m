Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792830972;
	b=suVc7+xp1EtskdADTpwh4bFFd9sxrkuok8t2emZ4idP99ODAnqvyPPkdZTRnVXmv6CPs
	 GW34ri30nVP6wRCByvWIrnPw/wYKgDVE4y6ufqtGepEKTYEKoexEaX1T0UuL7XUAn9MnE
	 Eg1d2aCd/VEDjELYaqVmrYJp5WjiEAJaFZbVuQyKGPWSzpfHO0iRRHVsAPh04qqQd8QrO
	 3AA/oUkKq3ENWKWJJzZC3HgZHBG7kkUyewXCFEbylXBLspdU2ib+gPZh1W+saylAU1WMI
	 kSIYdBhWPpsblenkFwaMl+W/JtUC+LMaPBtd5FpKLOQd3qOIqwehCofmCyHUQfxdjTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792830972;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=QtGlS4EglnBgNQaC6C9G8US2ps6URhRnKST9mNR6wBE=;
	b=eJXLJF+SX0iA70JrvgySBL60Ex0le1YCkKjOOX7o87yOCttyXS74U2LPW102sYdiXCSw
	 ax2liiQFOquQJsKAyVDwecrbTEi8Llivgs21Z6ZLCCVobOfhhTlEtFSek3LJ+Yb0j/mIb
	 HEvUqngbN/C9wVZldL0JqPsYqGJV7CjsEZUFfcbDwYscDXYye1kP0P1zIA5UAqEWW2sc+
	 bGQy2TJKknLXIjNal8LRqiQijYZC5OFRGIDETSAGkZ90Umkp0uZnCvFlfNFi+RTfgP7Ly
	 MG1thlvn0NYkUAIj0mSlzUDrh+sqpbS7EvLd0WIpdKKSPtViq/pnmXj77YS6m1JoliQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O8oxzNgZ;
	arc=none smtp.remote-ip=91.218.175.85
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E07606A31B
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 08:36:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5E07606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O8oxzNgZ
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2qO/hXGzSYWxgbhi/dlCTauWp6z1uxeCyVqm2WqlGDs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792830968; v=1; x=1793435768;
 b=O8oxzNgZ5jEZCDpRcGJkQqp40Oy7x7rlnsm2E8+deal7j573tmbi4v/L4NPdFn1bwXm8UpFn
 bbE3cF56eQA8izjeLIrs+k+7bbcJ/GzQ4Na76aV4JbPDaQzCsQ9JhBo5AncxIavzqvXnweJN9Vr
 HbvjtWXpjtZTwbkl1WfGMlQc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2ec1e08c1151954b;
	Sat, 24 Oct 2026 08:36:08 +0000
X-Mizu-Trace-ID: 2ec1e08c1151954b
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sat, 24 Oct 2026 08:36:08 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <152a5489440fbddb039d515af46fa46b30bfb109@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next 4/5] wifi: rtw88: pci: Add functions to support
 older chips
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <35e9d20a-4f0c-42c3-9d06-358a5620251c@gmail.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <35e9d20a-4f0c-42c3-9d06-358a5620251c@gmail.com>

Hi Bitterblue,

Thanks for working on this. I went through pci_old.c and have a few
questions.


October 24, 2026 at 1:02 AM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:

> +++ b/drivers/net/wireless/realtek/rtw88/pci_old.c

[...]

> +static void rtw_pci_old_reset_buf_desc(struct rtw_dev *rtwdev)
> +{

[...]

> +     rtw_write32(rtwdev, REG_RX_DESA,
> +                 rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma);
> +
> +     rtw_write8(rtwdev, RTK_PCI_CTRL + 3, 0x77);
> +}

If I read this right, this only runs on setup, and rtw_pci_stop() still
goes to the new rtw_pci_reset_buf_desc() when the device stops:

rtw_pci_stop()
  rtw_pci_dma_release()
    rtw_pci_reset_trx_ring()
      rtw_pci_reset_buf_desc()

Some of those offsets seem to be different registers on these chips,
for example 0x340 is REG_RX_DESA and 0x338 is REG_BKQ_DESA in
pci_old.h. Since rtw88xxa_power_off() calls rtw_hci_stop() before it
clears REG_CR, I think RX would still be running when they get written.
Would it make sense to send rtw_pci_dma_release() through pci_gen too?

Also, after stop the descriptors keep their OWN bit and buffer address,
and only rp and wp are reset. If a frame was still queued at that point,
could the hardware pick it up again after the next start? Would clearing
them here help?

[...]

> +     /*
> +      * Because the time taked by the I/O in __pci_get_hw_tx_ring_rp i=
s a
> +      * bit dynamic, it's hard to define a reasonable fixed total time=
out to
> +      * use read_poll_timeout* helper. Instead, we can ensure a reason=
able
> +      * polling times, so we just use for loop with udelay here.
> +      */

This comment looks copied, I don't see any I/O in this loop.

[...]

> +     if (queue =3D=3D RTW_TX_QUEUE_BCN)
> +             rtw_pci_release_rsvd_page(rtwpci, ring);
> +     else if (le32_get_bits(tx_desc[wp].w0_9.w0, RTW_TX_DESC_W0_OWN))
> +             return -ENOSPC;

I'm wondering if checking only OWN is enough here. OWN is cleared when
the hardware is done, but the skb stays in ring->queue until
rtw_pci_old_tx_isr() runs. rtw_pci_tx_write() only stops the mac80211
queue of the current skb, and the MGMT ring can get frames from more
than one queue (BARs use the AC of their TID), so I think the ring could
fill up completely. Then wp =3D=3D rp, and the next frame would overwrite=
 a
descriptor whose skb isn't freed yet. Would the avail_desc() check from
rtw_pci_tx_write_data() make sense here too?

[...]

> +             if (dma !=3D tx_data->dma)
> +                     rtw_err(rtwdev,
> +                             "tx_data dma %pad !=3D tx_desc dma %pad\n=
",
> +                             &tx_data->dma, &dma);
> +
> +             dma_unmap_single(&rtwpci->pdev->dev, dma, skb->len,
> +                              DMA_TO_DEVICE);

If that can happen, dma here would belong to the next skb, so it would
be unmapped too early and this skb's mapping would leak. Maybe use
tx_data->dma like rtw_pci_tx_isr() does?

[...]

> +             if (ring->queue_stopped &&
> +                 avail_desc(ring->r.wp, ring->r.rp, ring->r.len) <=3D =
4) {

rtw_pci_tx_isr() uses > 4 here, so this seems to be the other way
around. Is that on purpose? I guess it came from rtlwifi.

[...]

> +     /*
> +      * TODO: is it correct? it seems to work, but should we count
> +      * the number of occupied buffers for rtw_pci_napi_poll?
> +      */
> +     return 0;

About the TODO, I'm not sure returning 0 is enough. rtw_pci_napi_poll()
uses this to pick up frames that are already in the ring when interrupts
are enabled again. rtw_pci_old_rx_napi() doesn't count C2H or bad
frames, so it could return 0 while there's still data in the ring, which
would then wait for the next interrupt. Would checking OWN on the
descriptor at ring->r.rp be enough?

[...]

> +             if (le32_get_bits(rx_desc[cur_rp].w0_5.w0, RTW_RX_DESC_W0=
_OWN))
> +                     break;

Does this need a dma_rmb() after the OWN check? As far as I understand,
a weakly ordered CPU like arm64 could read the rest of the descriptor
and the buffer before it sees OWN cleared, and dma_sync_single_for_cpu()
doesn't add a barrier when the device is DMA coherent. It looks like the
example in Documentation/memory-barriers.txt. The new design gets this
from the readl() in rtw_pci_get_hw_rx_ring_nr().

Also, I think the wmb() calls could be dma_wmb().

[...]

> +             new_len =3D pkt_stat.pkt_len + pkt_offset;
> +             new =3D dev_alloc_skb(new_len);
> +             if (WARN_ONCE(!new, "rx routine starvation\n"))
> +                     goto next_rp;
> +
> +             skb_put_data(new, skb->data, new_len);

rtw_pci_rx_napi() got a length check in 6e76e9ed273d ("wifi: rtw88: fix
OOB read from firmware RX descriptor exceeding DMA buffer"), should it
be added here too? rtw_rx_query_rx_desc() allows pkt_len up to 11454, so
with 32 bytes of drv_info and a shift of 3 new_len could reach 11489,
while the buffer is 11478 bytes.

[...]

> +             wmb();
> +             le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
> +                                RTW_RX_DESC_W0_OWN);
> +
> +             if (cur_rp =3D=3D ring->r.len - 1)
> +                     le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
> +                                        RTW_RX_DESC_W0_EOR);

Is it safe to set EOR after OWN? le32p_replace_bits() reads and writes
back the whole w0, so if the hardware fills this descriptor in between,
I think the old value with OWN set could end up on top of its status,
and RX would wait there until the hardware wraps around. Setting EOR
before the wmb(), together with PKT_LEN, might avoid that.

[...]

> +             pcie_capability_set_word(pdev, PCI_EXP_LNKCTL,
> +                     PCI_EXP_LNKCTL_CCC | PCI_EXP_LNKCTL_ASPMC);

checkpatch --strict complains about the alignment here.

[...]

> +++ b/drivers/net/wireless/realtek/rtw88/pci_old.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

Is GPL-2.0 only intended for this header? The rest of rtw88, pci_old.c
included, is GPL-2.0 OR BSD-3-Clause.

[...]

> +++ b/drivers/net/wireless/realtek/rtw88/reg.h
> @@ -11,6 +11,7 @@
>  #define BIT_FEN_PPLL         BIT(7)
>  #define BIT_FEN_PCIEA                BIT(6)
>  #define BIT_FEN_DIO_PCIE     BIT(5)
> +#define BIT_FEN_PCIED                BIT(8)

Maybe put BIT(8) above BIT_FEN_PPLL, these seem to be sorted high to low.

Best regards,
Luka Gejak
