Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E20B274670;
	Sun,  6 Sep 2026 04:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788668224; cv=none; b=itlVTFSqJ4vexaYfeHcmkloU3kDu1cznmP+astbsEf0HY9Jpc4XEbWcXGHLFY0JhV8M4jIjqoUXZGMbnsLdOp5EKIPcOo4o/q2N1g979q+nRoatjhHtYF5/GLxccoi9wqcwZGU80JPFyh0gondvKRANkBYIbC7S0UqtkLME9wdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788668224; c=relaxed/simple;
	bh=IwTqmfMPncIgBjHLwSuuH7ngS6S356PSqcqPnT78y7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OLynqritWazgGdwosjXr7kCCgrnQWo0DPP3LIQrpmDY/1j+vwsxrM2iQzkMoFJnzv3iRo4Aazy8NIFrPp7feizq4ABg/AZH73ZIxm9eX7eBMU+zUlY7CsCwgjmfcoCgHstpALgFr/X8yK2F+y/4OJ7F2TPbbhVPf9rw78hmcC3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=FX25eoPT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="FX25eoPT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6864GkTC21636335, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788668206; bh=LLGZhRw50YaVUHwnsyYfR6nnwSv29pwHJaPZDbQpylg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=FX25eoPTuZY9YElHfVqIaESjzIWmvtorssb3PCmN9JhnQaaxbPmJQtEvpHhU2l5QO
	 rnvh3l4RiOobayAIJmhcp68L6ZvQf1PDZBe2NpPZefBvQ3cOatdYE3SXcBuQJqZkUn
	 rxZAOiaaHwn4o7Pgh9LWxiagqtWk5HCck6tSwJ5y3bHgQ/jC4G4hqLJPCep7XpOGau
	 l8L/eudTWg3QbU1670KGCnHzbzBXs8ocuxPyV361KuoDqf7nnrG/fFDjFwbi6c/ozN
	 5HV9pywP/cAESHsF/4nA7ZxUL9ErrrWI4z8z5HvNbJkb7/lXi9ivpqaTWgmem/itE8
	 sMWPvo1F9qHfQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6864GkTC21636335
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 12:16:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 12:16:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 12:16:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@kernel.org" <kvalo@kernel.org>, "briannorris@chromium.org"
	<briannorris@chromium.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: pci: recover from a stalled TX ring
Thread-Topic: [PATCH rtw-next] wifi: rtw88: pci: recover from a stalled TX
 ring
Thread-Index: AQHdOrv2my6O5pDEZ0akoQ39a3KAlrbA9beQ
Date: Sun, 6 Sep 2026 04:16:46 +0000
Message-ID: <6f2a314798c64ccfbfd59ac8a8ee6e01@realtek.com>
References: <20260902091738.41047-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260902091738.41047-1-abdurrahmankaradag19@gmail.com>
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

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index 66d2e5f51..f9875cb07 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -787,6 +787,72 @@ static void rtw_pci_tx_kick_off_queue(struct rtw_dev=
 *rtwdev,
>         spin_unlock_bh(&rtwpci->irq_lock);
>  }
>=20
> +/* The hardware read pointer of a TX ring can stop advancing while the d=
river

First line of comment block should be empty. We don't use special style for
networking subsystem anymroe.

> + * keeps queueing descriptors. Once the ring is full, rtw_pci_tx_write()=
 stops
> + * the mac80211 queue, and because the only wake up is inside the comple=
tion
> + * loop of rtw_pci_tx_isr(), which does not run while the read pointer i=
s
> + * frozen, the queue would stay stopped forever. Detect a ring that is n=
ot
> + * draining and kick it off again.
> + */
> +#define RTW_PCI_TX_STALL_LIMIT 3
> +
> +static void rtw_pci_tx_stall_check(struct rtw_dev *rtwdev)
> +{
> +       struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +       struct rtw_pci_tx_ring *ring;
> +       enum rtw_tx_queue_type queue;
> +       u32 bd_idx, cur_rp, wp;
> +       bool pending, kick, warn, stopped;
> +
> +       for (queue =3D 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
> +               /* BCN is the reserved page and H2C is managed by the
> +                * firmware, neither is flow controlled through mac80211
> +                */
> +               if (queue =3D=3D RTW_TX_QUEUE_BCN || queue =3D=3D RTW_TX_=
QUEUE_H2C)
> +                       continue;
> +
> +               ring =3D &rtwpci->tx_rings[queue];
> +               kick =3D false;
> +               warn =3D false;
> +
> +               spin_lock_bh(&rtwpci->irq_lock);
> +
> +               /* nothing in flight, do not touch the device */
> +               if (skb_queue_empty(&ring->queue) && !ring->queue_stopped=
) {
> +                       ring->stall_cnt =3D 0;
> +                       ring->stall_warned =3D false;
> +                       spin_unlock_bh(&rtwpci->irq_lock);
> +                       continue;
> +               }
> +
> +               bd_idx =3D rtw_read32(rtwdev, rtw_pci_tx_queue_idx_addr[q=
ueue]);
> +               cur_rp =3D (bd_idx >> 16) & TRX_BD_IDX_MASK;
> +               wp =3D ring->r.wp;
> +               pending =3D ring->queue_stopped || cur_rp !=3D wp;
> +
> +               if (pending && cur_rp =3D=3D ring->last_rp) {
> +                       if (++ring->stall_cnt >=3D RTW_PCI_TX_STALL_LIMIT=
) {
> +                               ring->stall_cnt =3D 0;
> +                               kick =3D true;
> +                               warn =3D !ring->stall_warned;
> +                               ring->stall_warned =3D true;
> +                       }
> +               } else {
> +                       ring->stall_cnt =3D 0;
> +                       ring->stall_warned =3D false;
> +               }
> +               stopped =3D ring->queue_stopped;
> +               ring->last_rp =3D cur_rp;

Does software pointer cause driver doesn't restart queue?
Or without changes of this chunk, the stuck can be resolved?

> +               spin_unlock_bh(&rtwpci->irq_lock);
> +
> +               if (warn)
> +                       rtw_warn(rtwdev, "TX queue %d stalled (rp %u wp %=
u%s), kicking\n",
> +                                queue, cur_rp, wp, stopped ? ", stopped"=
 : "");
> +               if (kick)
> +                       rtw_pci_tx_kick_off_queue(rtwdev, queue);

I mean just doing this kick is enough to resolve the stuck?

> +       }
> +}
> +
>  static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
>  {
>         struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;



