Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793432549;
	b=lIP6s+nVZaStm+/8xUh8CX5Wbhyn7qh3r+PwUHgwA7PEbLvuDpqU7DUE8zHQWcgSFAgh
	 /hY+MEg63G6W7nhsWiYm1UhDDViwSyeY5O0x4WGNu08basb6FEBvqp9e3R8BffnXlZpOl
	 xOqeXj1M9MehIx0f+quMDW0AJefiuFQssHm4Lh7qbA0pa3qSwO4E7BZJ8aAUHCe97ekJB
	 975kv4PnPOxNpoHgD3KvOsakrFZ5nMdSotG85PDfA4gsRtkJ/lIZdaZAVpMfBpFnoRab+
	 TxQmB5OPJxHoJhScie+patWxi0WpPecG5b7VmvUkHZ+ttj9lyRdwDDuRCNS0MRKA6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793432549;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:
	 In-Reply-To:References;
	bh=/QVAsfPujlGmbTkAITj1n+iU5k8n50SbH9VUDWGmFCs=;
	b=xESvKf/R79uHvAQNmbKVcQaw5Ca12nWr15MLQOV9XhbWJJEriEjCfGgJDgucOu70IhmJ
	 Eu80akRDBKLoxpc/ZfByKRmz5sTJxfhRhQK2K9lbvsXtodX3DGgJC8yvzXTCXeYLcZk5X
	 0jlhxCdOkLO+IYRYv4Sgdlx8uSa1yOqRMa2UfPE7+PUnJFfqGphzj90u776hfFH/LO/6P
	 E9FtCiyvZ19qPsHNybrx1hZZnAnc4/ZvLzKQer2OFGCxEZMhvp6V828ucnzbyU4E2FyOK
	 Ew2kMbOLTM3UeCz8gY6FrIciiq+Zelc8G3ok29k8OTb1czBOISKa254I/zV4Fc21HJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fvy8Bi4S;
	arc=none smtp.remote-ip=91.218.175.26
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F53606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F53606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fvy8Bi4S
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=labi6s1KQ3qqVu7L43Ussy5Viaxu51kBZ0O+U0Hl23M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793432545; v=1; x=1794037345;
 b=fvy8Bi4Sq1GoiZ1hiEfbM2IVCqMWjURGsYNbwRW/5/4p7Xh9EShlt3DJ7s5LznnQAdbwPala
 uxBckMn04ZRJphoYBmf8KrNzyyoRKlL8QvO8FGbv13ZTsZm5GJScoTPumP5UyjDHbEk+jKEMyOP
 YO/RBMmmF84VOS9lQ/UyX9uE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7e5e5d8a03e46bf0;
	Sat, 31 Oct 2026 07:42:25 +0000
X-Mizu-Trace-ID: 7e5e5d8a03e46bf0
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
Date: Sat, 31 Oct 2026 07:42:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <88568fb7cf038782c67e858210b843d79afc0e25@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>, linux-wireless@vger.kernel.org
In-Reply-To: <716e083d-93c1-4236-bfa2-ec88d0c84ca4@gmail.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
 <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
 <08b040fc2f7e4311aa7721cf4969896f@realtek.com>
 <716e083d-93c1-4236-bfa2-ec88d0c84ca4@gmail.com>

Hi Bitterblue,

I had taken a look at the RX slowdown on the RTL8821AE and I don't think
it is the PCIe link that causes it.

October 30, 2026 at 7:47 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>=
 wrote:

>=20
>=20On 30/10/2026 02:43, Ping-Ke Shih wrote:
>=20
>>=20
>> Have you dug the cause RX speed is low? The PHY rate becomes low at th=
at time?
>> Or can air capture see any weird packets? Or did you think PCIE get st=
uck
>> somehow?
>
> I think it's a PCIE problem. Before the first IMR_RDU the RX speed is n=
ormal.
> After, it's low. I will test the RTL8821AE again probably next week.

As far as I can see, the RX descriptors are never given back to the
hardware on power on. The RX ring is set up only once in probe, and on
every power on this runs:

        rtw_hci_setup()
          rtw_pci_setup()
            rtw_pci_old_reset()
              rtw_pci_old_reset_buf_desc()

which only resets the indexes and the base address:

        rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.rp =3D 0;
        rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.wp =3D 0;
        rtw_write32(rtwdev, REG_RX_DESA,
                    rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma);

On the way down, rtw_pci_stop() turns off the interrupt and NAPI, but RX
keeps running until rtw88xxa_power_off() clears REG_CR. A frame that land=
s
in the ring after the last NAPI poll stays in its descriptor with OWN
cleared.

So if I read it right, after the next power on the driver and the
hardware both start at descriptor 0, while some descriptors are still
owned by the host. If descriptor 0 is one of them:

        hardware fills 511, finds 0 owned by the host, raises IMR_RDU
        driver handles 511, then 0 (an old frame), then waits at 1
        hardware gets 0 back, fills it with a new frame, then 1, 2...

The new frame in descriptor 0 is now behind the driver, so it is only
picked up after the next wrap, and the same thing happens again. So the
hardware seems to be right about IMR_RDU, the descriptor it wants really
belongs to the host, even with 510 or 511 others free.

This doesn't go away by itself. I put the ring logic in a small
simulation, and with one stale descriptor at 0 it shows your exact order
(511, 0, wait at 1) and an IMR_RDU on almost every lap. The frame from
descriptor 0 is about 511 frames old by then. That is far behind the
reorder window, so I think mac80211 drops it as out of date, and TCP sees
a loss on every lap. That could well cap it at 70 to 100 Mbps.

It would also fit the rest of what you saw. The idle interface powers off
and on a lot, so there are many chances to leave a frame behind. A power
cycle doesn't help because the stale descriptors are still there after
it, and reloading the driver helps because rtw_pci_init_rx_ring() sets up
a fresh ring. Maybe the Bluetooth headphones matter because the
C2H_BT_INFO reports come in through the same RX ring.

rtlwifi doesn't run into this because rtl_pci_reset_trx_ring() clears
every RX descriptor and sets the buffer address, PKT_LEN and OWN again,
with EOR on the last one. It is called from rtl_pci_start() and from
rtl_ps_enable_nic(). Would it make sense to do the same in
rtw_pci_old_reset_buf_desc()? Maybe the descriptor part of
rtw_pci_old_reset_rx_desc() could be split out and reused there.

Sending rtw_pci_reset_trx_ring() through pci_gen for the stop path, as
you planned for patch 4, would fix the registers, but I think it would
still leave the descriptors as they are.

Best regards,
Luka Gejak
