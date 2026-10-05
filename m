Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C8DDF72;
	Mon,  5 Oct 2026 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791164970; cv=none; b=Vcw83DEoHRSanEmfDPoK8Q2/1/2HmWC2cmA+8nsY6HtaJeoa9086tFxfLWOO7gPYjtqxifEAAnR7J9rvD6L8rn+aIYV2wSQme8Q8RECBoOyxrhCCNa3VW9+Efko3qt4pEBuVcEHQ0+CWQBx7kA9y9tDckfL/sHzt8tHW45TrDU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791164970; c=relaxed/simple;
	bh=P6tM1GepEDncPpTabwKYhdOepRadGq146gRj+qp5v/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SpmJKOFhJNNtUSlWGF+ePsoyrGcZlI7WtBACIzIARDkVuIGR1HB7p1YsxF64w+Rkz8jwzW81hZO6ToMFyRPJYi3iFaQAojkViuSjIxkGKul9Fzkq55TZlfDEAQpzchvMGCfdVFohKDc9IfDEcJCSbf+PNIvWR19X+zwACOF3ocI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZPjmHGF8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZPjmHGF8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6951nO8A11529328, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791164965; bh=ATMfFjo8RDL/fg0WN7mpbU6ak9iSdGFPJMZPUUX7dog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZPjmHGF8QmPl//fH2w+Njy/ZQ/o3DXYbbChh3AU0JG21Up1hCG/2XSK/3QFveVde4
	 KKMfhrNV2AyyR24SOYkMLTVMzdurewNCENrZdHVUdxqRMt0jS5PFVPnH4HXdGAS+31
	 UI2eVrhj3u0kNP091SlEdhdKU2DxHvQlYaQTQfeL05Q1h1z+mdQ5kqNExa7f8FqBCN
	 1Zonduxmu9hLq0ZWvynoAlsyGrgmskPGR1vBniBDtui/IYJZU7Cavd8cnRuCZOBopB
	 gTmDCw7GrhQQ2D4OBK8NMlAQatS6MH5uuBtHFiAmWseNSlBpyx7rYB6aoDqYhziBpL
	 hEaqhBLzRZc2Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6951nO8A11529328
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 09:49:24 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:49:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:49:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 09:49:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next 1/2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Topic: [PATCH rtw-next 1/2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Index: AQHdUsND//yj2HyI1EGhe1jdZ9x1BLbuMJig
Date: Mon, 5 Oct 2026 01:49:24 +0000
Message-ID: <f7f10dc29e1641999903347b94815e09@realtek.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
 <20261002231013.11792-2-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261002231013.11792-2-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> For a queue stopped by the PCI TX ring-full path, ring->queue_stopped
> is normally cleared and the stop reason released only from the
> completion loop in rtw_pci_tx_isr(). When the rings are reset the
> pending descriptors are dropped and their skbs are freed directly by
> rtw_pci_free_tx_ring_skbs(), so that loop never runs for them. The flag
> and the stop reason both survive the reset, and because the ring is now
> empty no completion will ever arrive to clear them. Any queue stopped
> that way stays stopped.
>=20
> This makes ieee80211_restart_hw() unable to recover a device that
> stopped a queue before the restart, which is the opposite of what the
> recovery is for.
>=20
> Reproduced on an RTL8821CE by pausing TX in hardware, which freezes the
> read index while the driver keeps submitting, the same shape the chip
> shows when it wedges on its own:
>=20
>     # echo "522 f 1" > /sys/kernel/debug/ieee80211/phy0/rtw88/write_reg
>     # ... push traffic until the ring fills ...
>     BE 0x3a8: 0x0081007f, avail_desc() 1, BE queue stop reason 0x1
>=20
>     # (call rtw_fw_recovery() from a debug build)
>     firmware crash, start reset and recover
>     ieee80211 phy1: Hardware restart was requested
>     wlan0: associated
>=20
>     REG_TXPAUSE 0x00, BE 0x3a8: 0x00000000, ring empty
>     BE queue stop reason 0x1, 100% packet loss, no recovery in 90 s
>=20
> The station reassociated twice during those 90 s, so the link was fine;
> only the queue was still stopped. With this patch the same sequence
> clears the stop reason and traffic returns within 2 s.

I feel there are too much detail in commit message. Just describe why
this patch is necessary, and how it fix the problem.

>=20
> Record the queue mappings this path stops and release them both from
> the completion loop and when the reset empties the ring. It has to be a
> set rather than one value: the stop runs after every submission that
> leaves fewer than two descriptors, rtw_pci_tx_write_data() still
> accepts a frame while one is left, and rtw_tx_queue_mapping() places
> management frames on the MGMT ring and multicast on HI0 whatever their
> skb queue mapping is, so one ring can stop two different queues before
> it is emptied. Keeping only the last one would leave the other stopped
> for good.
>=20
> Recording the mappings also limits the wake to the queues this
> ring-full path actually stopped, instead of waking every mac80211
> queue.
>=20
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")

This is to assist with recovery, right? So at the initial moment,
we didn't support recovery yet. No this fixes then.

> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
> ---

[...]

>  static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)
>  {
> +       struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +       struct rtw_pci_tx_ring *ring;
> +       enum rtw_tx_queue_type queue;
> +
>         rtw_pci_reset_buf_desc(rtwdev);
> +
> +       /*
> +        * The rings are empty again, so nothing is left whose completion
> +        * could reach the wake in rtw_pci_tx_isr(). Release the queues t=
his
> +        * path stopped - the stop reasons it set are cleared nowhere els=
e,
> +        * and over an empty ring no completion will ever arrive to clear
> +        * them.
> +        */
> +       for (queue =3D 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
> +               ring =3D &rtwpci->tx_rings[queue];
> +
> +               if (!ring->queue_stopped)
> +                       continue;
> +
> +               rtw_pci_wake_stopped_queues(rtwdev, ring);
> +       }

Is it enough just a ieee80211_wake_queues()? No other changes.

>  }
>=20
>  static void rtw_pci_enable_interrupt(struct rtw_dev *rtwdev,


