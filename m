Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209263;
	b=mBobUP3jIjwmYLeAhkR1oqCMnHFWqF9K/DgOl8o0UXrtbf+sKX5NdiLdS3yAQv9MX1j6
	 ltt89h+S0Ss1LxbAh0dZlpiWkFS+4qByKScsp6x4xz9kk7yN4Y0snFA//1ss89yatDhyE
	 URFAwPcrkntvXlm5+pcahFoF0YseO3Vlt0XBVwJqp7pYNPrjGD8vrcfdDYFG+nfAZTJgb
	 OCw2QoRX+ZVxr93LKpKhnyDEPZpEUW3RpTTY/qnySqtO6SwTRRt9UPrzCvdXfHeazKspr
	 3IDP3S5A9m1ivTyrGkexfySA1BrnxTRWSTMc8rndKS1qanzGj1BhSL6IHPvBr+8E2ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:From:Subject:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bKEddF200A5Fji/8mKWoxDNoJ3pSAPZUATgBbE0Ij0M=;
	b=df40FsClh0br1i+hOqhy/APkDUOzHwdSdZFFVwpBwld/y9SDDOjUa1bsqDby7vZ5Nkyy
	 I9KmuV+KJgZ88HproxReAjRsGdU4+/ew7QfBgXqEdwUj6VMqoPm2jDHd71NpBsTh+3O/K
	 vp7G+rKhjTl4j5caEe8UWZWHzeDJOXa+8ylYKx4+q4cTGZN1R44bwSpyPe5QhDsTL0BRd
	 nwmDtXszaghAd3zJPXVZUvJcaOyvngflj31f+V1mxtRiBQhuPWGv7lWbhRdrEZgUg1ylq
	 29W41T9mraN8UKovdpcU8ne3xXr77S3zh/J6LzdDKIeenCslIlAnNzVw6EcGF9rzT8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lYTaYCcN;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF034606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 17:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF034606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lYTaYCcN
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so15771005e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 10:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793209261; x=1793814061; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bKEddF200A5Fji/8mKWoxDNoJ3pSAPZUATgBbE0Ij0M=;
        b=lYTaYCcNMkAKIRU3LZsCTt/AnaIzS9iBgUSVhIy0XMbUHFv7bOCQoDijnhQpipPCKw
         fxVQDn8hV72p1BcbENkXLRv/Yw9THR0uFdfKDTWwFTcfB+X0KslyKh918Tc8Yv9d374M
         DeB4kzdsnLFFT6NTDPh8QfDGgh7NWBcbJh+V0yTkPQYemyfAqf+NHtfCUJF0l78/aUzp
         cJpaPW2SCbNcQOiDPKhSItrdwXg+UD7OXD1Vifl5jIdW3FPQqEXqi/rJo1RqwEEmGav+
         z5iI/UkfUgGhWOMOYmnI/CnbGLJ1f4i4okrcJwsRnYeOSf93QK3vEWBA5S6RUu+jqjFT
         DPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209261; x=1793814061;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bKEddF200A5Fji/8mKWoxDNoJ3pSAPZUATgBbE0Ij0M=;
        b=FiNx1vl9Ys0mg0yj+MSy6mCchXX+S/PSNpdKdkJcCNVfoAIDewzPqmsmr5MYxinrW1
         ymZDc81pH+GKCILkd9j1bTB9EDHKa0CdPles9Oel/T07ChgvtldUFnaDQpYcY36fvwSo
         h/oVdMVfvIcc5PkecxGAgy63MDUG6xyL+Fz7CQdHwc2EQk2/ahlC9NGz/bHA34QKkXPO
         n8dwATlSCjG+CxV462l3bEpmfV7Upyh80reRudRUffdhU5Di7Xn179lWDFsB5TSEBBn2
         MCvO4GdZ1gnYq6V1MUFQNhnj5Re4LfeBeLYmYXKq9qbeqlKnMlHxQKfsVf9JlnQebv46
         6qPw==
X-Forwarded-Encrypted: i=1; AKwUvBw6im34mbb8Cj2dUQGbeAfgDYsY2Y4xGa8fb/04nviPGESc4IIczTOybCXyb2SBGqW5J19Rfc1pw2kYVMjFlw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJMhKX2Zyp9XSvyCaHUxdYxXeW3YqtLTbUwOrLeTcwgRApNImyU
	+6Hp1Tf0u+IdjHZsx7dlxTsaZ4vYC1zg4aDAOqvm827rvEyWG4nyaxVo
X-Gm-Gg: AYBFou0g6DBokIVkN9Clb8MsiFITL/m8xfYtWw3xAU28cnlbwPOBTVeIh1qA4qEncjI
	qXpQrsbZNxSnrUBxOJqJroAidyrSL8N82A9baf8D7edgbaAW53ElExOE5k0vLuLmoTgSXwucu2y
	iO4XGAGtNn85La05Bj6BvBf5eN06HESojVkp+D+O0P6aADXJl9Ot6xr6B9j637fyox/i1et0VIc
	MTri/ffYUppDYeNoFRQY4JupEwBWUbrtKlhYUsMgE8VAsob5YSCpdM4I2lK2yAOEo9t7pEHgtfZ
	osbZSVn9gPZHQcbDpVLK05L8EVstV0lNqncuql2XB9FPbgCqyBIG15kvJxmHT2Q5r9RcCtNVf2J
	4iKaW+cZzWD+7F/ZgDnGmkzq8nO07HKGeA8Cyw/izeMckJEDtzZrKRsTDQtq958CruLgn0seghq
	RJO2ro8Mi8xB+on3vFvhRWdANoEsk9X08QZftbyVKAd/TUkSgv/YADPQhzhgxFdKMpGPhOksNZt
	5kJdVklBTnfZfn7bmb1tn7OjzvXHUexaoaYBCr2qx3echHCMCmWj6dBp27S0tWwaGR2q2ZK68wy
	jfgfpTNO/ixdMcAA8Sj7KkfP7KLp9uLQLkhC1++iNAexaOH6QJppIH66Rw==
X-Received: by 2002:a05:600c:3b07:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4a967203057mr68045325e9.31.1793209260904;
        Wed, 28 Oct 2026 10:41:00 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa8213ead6sm6817045e9.14.2026.10.28.10.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 10:40:58 -0700 (PDT)
Message-ID: <c035c434-ac56-49b0-bc28-730caae58670@gmail.com>
Date: Wed, 28 Oct 2026 19:40:56 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next 4/5] wifi: rtw88: pci: Add functions to support
 older chips
To: Luka Gejak <luka.gejak@linux.dev>, linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <35e9d20a-4f0c-42c3-9d06-358a5620251c@gmail.com>
 <152a5489440fbddb039d515af46fa46b30bfb109@linux.dev>
Content-Language: en-US
In-Reply-To: <152a5489440fbddb039d515af46fa46b30bfb109@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 24/10/2026 11:36, Luka Gejak wrote:
> Hi Bitterblue,
> 
> Thanks for working on this. I went through pci_old.c and have a few
> questions.
> 
> 
> October 24, 2026 at 1:02 AM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
> 
>> +++ b/drivers/net/wireless/realtek/rtw88/pci_old.c
> 
> [...]
> 
>> +static void rtw_pci_old_reset_buf_desc(struct rtw_dev *rtwdev)
>> +{
> 
> [...]
> 
>> +     rtw_write32(rtwdev, REG_RX_DESA,
>> +                 rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma);
>> +
>> +     rtw_write8(rtwdev, RTK_PCI_CTRL + 3, 0x77);
>> +}
> 
> If I read this right, this only runs on setup, and rtw_pci_stop() still
> goes to the new rtw_pci_reset_buf_desc() when the device stops:
> 
> rtw_pci_stop()
>   rtw_pci_dma_release()
>     rtw_pci_reset_trx_ring()
>       rtw_pci_reset_buf_desc()
> 
> Some of those offsets seem to be different registers on these chips,
> for example 0x340 is REG_RX_DESA and 0x338 is REG_BKQ_DESA in
> pci_old.h. Since rtw88xxa_power_off() calls rtw_hci_stop() before it
> clears REG_CR, I think RX would still be running when they get written.

Oh, I missed that. I'll fix it.

> Would it make sense to send rtw_pci_dma_release() through pci_gen too?

I think just rtw_pci_reset_trx_ring().

> 
> Also, after stop the descriptors keep their OWN bit and buffer address,
> and only rp and wp are reset. If a frame was still queued at that point,
> could the hardware pick it up again after the next start? Would clearing
> them here help?
> 

Any frames still in the TX queues are unmapped on stop. I think we would
get an error if the hardware tried to pick them up. That has not happened
so far.

> [...]
> 
>> +     /*
>> +      * Because the time taked by the I/O in __pci_get_hw_tx_ring_rp is a
>> +      * bit dynamic, it's hard to define a reasonable fixed total timeout to
>> +      * use read_poll_timeout* helper. Instead, we can ensure a reasonable
>> +      * polling times, so we just use for loop with udelay here.
>> +      */
> 
> This comment looks copied, I don't see any I/O in this loop.

Indeed.

> 
> [...]
> 
>> +     if (queue == RTW_TX_QUEUE_BCN)
>> +             rtw_pci_release_rsvd_page(rtwpci, ring);
>> +     else if (le32_get_bits(tx_desc[wp].w0_9.w0, RTW_TX_DESC_W0_OWN))
>> +             return -ENOSPC;
> 
> I'm wondering if checking only OWN is enough here. OWN is cleared when
> the hardware is done, but the skb stays in ring->queue until
> rtw_pci_old_tx_isr() runs. rtw_pci_tx_write() only stops the mac80211
> queue of the current skb, and the MGMT ring can get frames from more
> than one queue (BARs use the AC of their TID), so I think the ring could
> fill up completely. Then wp == rp, and the next frame would overwrite a
> descriptor whose skb isn't freed yet. Would the avail_desc() check from
> rtw_pci_tx_write_data() make sense here too?
> 

Is it a problem if it overwrites a descriptor whose skb isn't freed yet?

> [...]
> 
>> +             if (dma != tx_data->dma)
>> +                     rtw_err(rtwdev,
>> +                             "tx_data dma %pad != tx_desc dma %pad\n",
>> +                             &tx_data->dma, &dma);
>> +
>> +             dma_unmap_single(&rtwpci->pdev->dev, dma, skb->len,
>> +                              DMA_TO_DEVICE);
> 
> If that can happen, dma here would belong to the next skb, so it would
> be unmapped too early and this skb's mapping would leak. Maybe use
> tx_data->dma like rtw_pci_tx_isr() does?
> 

I added that check just to see if it ever happens, but it never did so far.

> [...]
> 
>> +             if (ring->queue_stopped &&
>> +                 avail_desc(ring->r.wp, ring->r.rp, ring->r.len) <= 4) {
> 
> rtw_pci_tx_isr() uses > 4 here, so this seems to be the other way
> around. Is that on purpose? I guess it came from rtlwifi.
> 

Yes, that is what rtlwifi does. It was done for unknown reasons in
d0311314d002 ("rtlwifi: rtl8192ee: Fix handling of new style descriptors").
Before that, it was "== 2".

The vendor driver v5.3.7_27548.20180724_COEX20170206-6761 uses ">= 2"
in check_tx_desc_resource():

https://github.com/rapyuta-robotics/rtl8821ae-dkms/blob/master/hal/rtl8812a/pci/pci_ops_linux.c#L340

> [...]
> 
>> +     /*
>> +      * TODO: is it correct? it seems to work, but should we count
>> +      * the number of occupied buffers for rtw_pci_napi_poll?
>> +      */
>> +     return 0;
> 
> About the TODO, I'm not sure returning 0 is enough. rtw_pci_napi_poll()
> uses this to pick up frames that are already in the ring when interrupts
> are enabled again. rtw_pci_old_rx_napi() doesn't count C2H or bad
> frames, so it could return 0 while there's still data in the ring, which
> would then wait for the next interrupt. Would checking OWN on the
> descriptor at ring->r.rp be enough?
> 

RX didn't get any faster, so I'm not sure there is a point.

> [...]
> 
>> +             if (le32_get_bits(rx_desc[cur_rp].w0_5.w0, RTW_RX_DESC_W0_OWN))
>> +                     break;
> 
> Does this need a dma_rmb() after the OWN check? As far as I understand,
> a weakly ordered CPU like arm64 could read the rest of the descriptor
> and the buffer before it sees OWN cleared, and dma_sync_single_for_cpu()
> doesn't add a barrier when the device is DMA coherent. It looks like the
> example in Documentation/memory-barriers.txt. The new design gets this
> from the readl() in rtw_pci_get_hw_rx_ring_nr().
> 

I guess it can't hurt.

> Also, I think the wmb() calls could be dma_wmb().
> 

It looks that way. I didn't know about it.

> [...]
> 
>> +             new_len = pkt_stat.pkt_len + pkt_offset;
>> +             new = dev_alloc_skb(new_len);
>> +             if (WARN_ONCE(!new, "rx routine starvation\n"))
>> +                     goto next_rp;
>> +
>> +             skb_put_data(new, skb->data, new_len);
> 
> rtw_pci_rx_napi() got a length check in 6e76e9ed273d ("wifi: rtw88: fix
> OOB read from firmware RX descriptor exceeding DMA buffer"), should it
> be added here too? rtw_rx_query_rx_desc() allows pkt_len up to 11454, so
> with 32 bytes of drv_info and a shift of 3 new_len could reach 11489,
> while the buffer is 11478 bytes.
> 

Sure, I will add that.

> [...]
> 
>> +             wmb();
>> +             le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
>> +                                RTW_RX_DESC_W0_OWN);
>> +
>> +             if (cur_rp == ring->r.len - 1)
>> +                     le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
>> +                                        RTW_RX_DESC_W0_EOR);
> 
> Is it safe to set EOR after OWN? le32p_replace_bits() reads and writes
> back the whole w0, so if the hardware fills this descriptor in between,
> I think the old value with OWN set could end up on top of its status,
> and RX would wait there until the hardware wraps around. Setting EOR
> before the wmb(), together with PKT_LEN, might avoid that.
> 

The original authors must have thought it was safe.

> [...]
> 
>> +             pcie_capability_set_word(pdev, PCI_EXP_LNKCTL,
>> +                     PCI_EXP_LNKCTL_CCC | PCI_EXP_LNKCTL_ASPMC);
> 
> checkpatch --strict complains about the alignment here.
> 

¯\_(ツ)_/¯

> [...]
> 
>> +++ b/drivers/net/wireless/realtek/rtw88/pci_old.h
>> @@ -0,0 +1,39 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
> 
> Is GPL-2.0 only intended for this header? The rest of rtw88, pci_old.c
> included, is GPL-2.0 OR BSD-3-Clause.
> 

I'm not sure where that came from. It should be like the others.

> [...]
> 
>> +++ b/drivers/net/wireless/realtek/rtw88/reg.h
>> @@ -11,6 +11,7 @@
>>  #define BIT_FEN_PPLL         BIT(7)
>>  #define BIT_FEN_PCIEA                BIT(6)
>>  #define BIT_FEN_DIO_PCIE     BIT(5)
>> +#define BIT_FEN_PCIED                BIT(8)
> 
> Maybe put BIT(8) above BIT_FEN_PPLL, these seem to be sorted high to low.
> 
> Best regards,
> Luka Gejak

