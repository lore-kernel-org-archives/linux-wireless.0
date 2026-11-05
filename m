Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793885496;
	b=CRifd4fj5CFAGeUfHrAvI8qGhEqlnQBi56Yzgg2tflvctxnr0rGvPQ+Zu6OnGlQR9Msk
	 RDO7LF2J0G5qgGztFq5AtEf6foRrE2JFI54GH45dd2dZyoRYprLBCmyWznSdAUsCmoF3l
	 ZODy3Mqv0CLFPUmzY3kN4yWP/YgxvAV4n5+z1fbhooCmkLtorx2iVi/wL8HzOP3zNB+zz
	 qwkwzCyDtoWVsvUVCcHo7glF1rahrlvX4CB3QOCY/JWvWS8mu37yJkd1BeDXd/11pQTCp
	 sZCYxaZEp1Yfw2kRKIWVOwmRgzYZqMFSHqgqRAU3VuWIUGYnPVjlQJzpkEi/ppcuKYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793885496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:From:Subject:To:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=c1TYCaawHF9Qh/HMTmrG4qEvk+h7Jd0bESBrUuO2QUs=;
	b=2E4Ym/zD072Wt11HZ/TmN+ni9sCM9rzvxaK3VI7pm5rqPN4RuUzmZcQ8E/0gZUp/jXlq
	 nv62gk0rFFyu4Uom/ArsxeXve5Rt6FQSbKXKdEgBecJDIKsdptj5WB578pewqZ1w3kXRm
	 Z+Zq2V2n9EtGFugFVPiEfLwVJMFalHELbrvIDbjkIUUC2VfR9yJtzqEvFMgywZR8pWLKp
	 HhaRhsN+LxoidWdYdFcZ1bhJFfjC57TXk4UaWRJLkcnu/MEK1YErGo81hbTvyNyWHGGLR
	 6tKHMhLQHHMLWVLJO07qrifNaqOhu7Jl8Sc9x4Fkxh2wYTWs+CArBMSjJiUrk8ZSEFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBI0tha7;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF9D606A32E
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 13:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EF9D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBI0tha7
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so291471766b.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 05:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793885494; x=1794490294; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c1TYCaawHF9Qh/HMTmrG4qEvk+h7Jd0bESBrUuO2QUs=;
        b=GBI0tha7l2gZ/NxkOjUn5QG1p85LPyHBbu0R0IN2aEXTjdNfQztc1tRKW4prdGVCdU
         BDZ7o+7l0Is9rteAojabgDN08PoJcQS2hufCCL40dhPpzl3vahJy0OUco3sTPg9t6V/T
         5I3EnK4mHDr5faAYapnS3gokqzFFp6y3B+YT573RZGD4sDIkVTP7ABLaaMAegaXEBs/a
         f+J881QQhrf1lY0ag6kJwQRmscczgrq3CLxbJ0gZPQKqyik52DSAvwS75iw2mNFobNaV
         KB9X1qUubemOInFQN0oZvqqS/gwnCfRIG3t+mY/xsFbutW5aOlgkM1K71GLAKgedasTp
         FcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793885494; x=1794490294;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=c1TYCaawHF9Qh/HMTmrG4qEvk+h7Jd0bESBrUuO2QUs=;
        b=1L/X5TCz7l2C6kETxakaxvCuz63ZwHe61N7HkdvQEjC9vwswstHWY2BLLxKtm7xD2M
         9TLfsGOYCm+oZNyiuQMc/M7LO3WfuAEtc01ph3XSDAfIHQqMZwiIChmnR/LuoQaJGsPY
         auKdhn2Byz6GgZbX2cEyvVYqprBGH9erj6cj75EMx2eeOU2y8Pve07w9tdQM4pf1uQ+n
         Y8XtTgMr18s9V4pBqMN15niRiLF/Toh9aATy17c+Q3LekcU+aVlPgNBQRNmjTZsMeP69
         xj2hAW1Xld0ihBvpZYmvmDO2aDdVu5iBqHS3XAwnWea42haum4Erc17ABRVJKTAaFByY
         26zw==
X-Forwarded-Encrypted: i=1; AKwUvBz2X7qK7V0UP7f3bJ3czwxGJe6Z+6AR0azlpnUKFk51pXv0yuFb4TEAdhbPgPu18Fhi8wN6y+pTRSPOb5yaJQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9bq2DPaCYgSq61MSBumU2f5VHHm2S16wc2Kz9ch8Zs1YzFhVUd
	PWfe8abYst2Ugdm3ww7IM3WKm5ugfKD1Hg14I4q6KzSXNxh6OwSB74l4dsaa7Fzx
X-Gm-Gg: AYBFou1nfEP4s0MG37GHdmKu3Ggrshq1VS7MI3moJVLCfJ3jWj5bB/Ftdeyi+YqF9EZ
	dHaGotMxoFMqryuq2wPjtcBgNGrJ4RLgjctUfQxvxocGL2EIgWAgeRqSO87hXf/uaeGSFTbjdd4
	t6WMgJLHbKDEYhg9EDge5HF+5gc2NjK7AOUticbQRTE7qAbKv4EeBVuncXon28//MbofFJo//6/
	gtT0U6/4YGstMXOD6D5iGwyTv4gLCc41XFsgo9WVsbIfaIt50m85OJC5KlCO4Yicz905LatpRBI
	aarl5HQDc8aSykF4fwkwBZP5fJ5rfbwn0W5v6t63wwab93TA4mGP7TwQ4k8WzhwrRSDAuY9ydfp
	Nxtx+9M6ioaB4/K93FyJIwwZEieDzLf0IY3l/GBc/riI84AK+mGOi/1voU7Aqk1EdRvw4/T/qsy
	/kLUXxI3aqPJiEyImSZ7GocnN9nSbCh0dSaCOqqp7yXN4jCE/Y3gyl1QRogVFZAFylgTlKhGaIW
	5ojPd1vCMdvl1JgoYCg70iP9rcTnNgBUfauvE5wsqGTaY7ULjIJYIeIZ13yUMFrV/I0uODbpKLp
	jSp5wmcSO1ltYfkzwETG/FZ4RtSX27KqERiw
X-Received: by 2002:a17:906:9f87:b0:c33:9fab:5f61 with SMTP id a640c23a62f3a-c4ca7a80dfcmr1783355366b.29.1793885494321;
        Thu, 05 Nov 2026 05:31:34 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.160])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e42479dsm175532866b.17.2026.11.05.05.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 05:31:33 -0800 (PST)
Message-ID: <b0b75c12-9c66-4d73-b3b0-44ff4122b386@gmail.com>
Date: Thu, 5 Nov 2026 15:31:32 +0200
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
Subject: Re: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>,
 linux-wireless@vger.kernel.org
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
 <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
 <08b040fc2f7e4311aa7721cf4969896f@realtek.com>
 <716e083d-93c1-4236-bfa2-ec88d0c84ca4@gmail.com>
 <88568fb7cf038782c67e858210b843d79afc0e25@linux.dev>
Content-Language: en-US
In-Reply-To: <88568fb7cf038782c67e858210b843d79afc0e25@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/10/2026 09:42, Luka Gejak wrote:
> Hi Bitterblue,
> 
> I had taken a look at the RX slowdown on the RTL8821AE and I don't think
> it is the PCIe link that causes it.
> 
> October 30, 2026 at 7:47 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
> 
>>
>> On 30/10/2026 02:43, Ping-Ke Shih wrote:
>>
>>>
>>> Have you dug the cause RX speed is low? The PHY rate becomes low at that time?
>>> Or can air capture see any weird packets? Or did you think PCIE get stuck
>>> somehow?
>>
>> I think it's a PCIE problem. Before the first IMR_RDU the RX speed is normal.
>> After, it's low. I will test the RTL8821AE again probably next week.
> 
> As far as I can see, the RX descriptors are never given back to the
> hardware on power on. The RX ring is set up only once in probe, and on
> every power on this runs:
> 
>         rtw_hci_setup()
>           rtw_pci_setup()
>             rtw_pci_old_reset()
>               rtw_pci_old_reset_buf_desc()
> 
> which only resets the indexes and the base address:
> 
>         rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.rp = 0;
>         rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.wp = 0;
>         rtw_write32(rtwdev, REG_RX_DESA,
>                     rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma);
> 
> On the way down, rtw_pci_stop() turns off the interrupt and NAPI, but RX
> keeps running until rtw88xxa_power_off() clears REG_CR. A frame that lands
> in the ring after the last NAPI poll stays in its descriptor with OWN
> cleared.
> 
> So if I read it right, after the next power on the driver and the
> hardware both start at descriptor 0, while some descriptors are still
> owned by the host. If descriptor 0 is one of them:
> 
>         hardware fills 511, finds 0 owned by the host, raises IMR_RDU
>         driver handles 511, then 0 (an old frame), then waits at 1
>         hardware gets 0 back, fills it with a new frame, then 1, 2...
> 
> The new frame in descriptor 0 is now behind the driver, so it is only
> picked up after the next wrap, and the same thing happens again. So the
> hardware seems to be right about IMR_RDU, the descriptor it wants really
> belongs to the host, even with 510 or 511 others free.
> 
> This doesn't go away by itself. I put the ring logic in a small
> simulation, and with one stale descriptor at 0 it shows your exact order
> (511, 0, wait at 1) and an IMR_RDU on almost every lap. The frame from
> descriptor 0 is about 511 frames old by then. That is far behind the
> reorder window, so I think mac80211 drops it as out of date, and TCP sees
> a loss on every lap. That could well cap it at 70 to 100 Mbps.
> 
> It would also fit the rest of what you saw. The idle interface powers off
> and on a lot, so there are many chances to leave a frame behind. A power
> cycle doesn't help because the stale descriptors are still there after
> it, and reloading the driver helps because rtw_pci_init_rx_ring() sets up
> a fresh ring. Maybe the Bluetooth headphones matter because the
> C2H_BT_INFO reports come in through the same RX ring.
> 
> rtlwifi doesn't run into this because rtl_pci_reset_trx_ring() clears
> every RX descriptor and sets the buffer address, PKT_LEN and OWN again,
> with EOR on the last one. It is called from rtl_pci_start() and from
> rtl_ps_enable_nic(). Would it make sense to do the same in
> rtw_pci_old_reset_buf_desc()? Maybe the descriptor part of
> rtw_pci_old_reset_rx_desc() could be split out and reused there.
> 
> Sending rtw_pci_reset_trx_ring() through pci_gen for the stop path, as
> you planned for patch 4, would fix the registers, but I think it would
> still leave the descriptors as they are.
> 
> Best regards,
> Luka Gejak

I remember thinking there is nothing wrong with the RX ring because
"it looks fine".

But you're right, IMR_RDU is caused by a packet arriving after
rtw_pci_stop(). Resetting the RX ring fixes it.
