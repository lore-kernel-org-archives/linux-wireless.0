Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03BE37757D;
	Tue, 25 Aug 2026 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639807; cv=none; b=OOk/WAHz/oORSHx8OK0frhNPYeTArxtOq2SNpQghCfslwwa5XpYQVBMisDFXuF+bHKScpbiEktN1B+IoIGkF+sAmlk7uAhpal9vhLcGMCyFXcT3W1on9xQlAyKlOY2nbH3trDMgh7l3k1XpkWAdcP2RnR7pDlmrEDR8nCODvLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639807; c=relaxed/simple;
	bh=umpCwq8wpVyk3iQWWZV4x/SY7gHDLHRX/uIta/s5tzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D3v86YdiHPXi6UR4durNwBX3pSDLMNlP90ySyqKMRABCWH8cv5m/xRKaAWPNzm9qjUMMN8fFqVN76mPZMPFaWhVY+QCTg2ADfU46uUduG6+vnNUCs/0zRvrrOEfbSsUFZmrqrGlMpNOZzHNZ/0YVAhLr8buhj1SkGs/2bS/I73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aRl+5xf/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aRl+5xf/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P6aU4V13543457, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787639790; bh=TEdtak1K52xeGBBp7XqbZrTMMqQD0bAY30KxaYWmciQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=aRl+5xf/riRMuIJHFjJMLDWbknbefZhkww+2FHWbczdRCmfL3psRpaHcyTP1FF/XA
	 F6dmNnf0TURWrNKL08oPlMtc4WPHyUBkNrD+cdEdkEHL8irqyy8jxlqLmCZZ900toY
	 brCBo0u9gvDIETWS+qVFbOK3Bc5oFITgrUwFDTsa+vK1lAcLDK9ZbojmIAGsrPcxzg
	 Jj/nOZ0tPMifNf8Qed1twgvLCsG4HdoRdPbsh6pdPtFC+z+FBOT4zeFJ1gjARScx2v
	 ROdDpQJQPqRxaLiYOoDXo5LtwA8E0zEK0N0UQVTtxMfq857mfuIhyeCznWZ/mb/Zd5
	 w6zxdgziClPJg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P6aU4V13543457
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 14:36:30 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 14:36:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 14:36:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 14:36:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v7 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdMIL7G//TSj3zZkqzYEB+swGRO7auVSeA
Date: Tue, 25 Aug 2026 06:36:30 +0000
Message-ID: <348bea609cee45179ee2a0c7dd03f0d1@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-7-luka.gejak@linux.dev>
In-Reply-To: <20260820090412.19574-7-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:

[...]

> +/*
> + * Back-pressure on the data ACs (BK/BE/VI/VO): once the software FIFO f=
ills
> + * past the high watermark, stop the corresponding mac80211 queue so it =
stops
> + * handing frames down, which bounds the queueing latency. The queue is =
woken
> + * again from the TX drain path once the FIFO falls back to the low wate=
rmark.
> + */
> +static void rtw_sdio_8723bs_stop_tx_queue(struct rtw_dev *rtwdev,
> +                                         enum rtw_tx_queue_type queue,
> +                                         u16 q_map)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +
> +       if (!rtw_is_8723bs(rtwdev) || queue >=3D RTW_TX_QUEUE_BCN)
> +               return;
> +
> +       if (READ_ONCE(rtwsdio->tx_queue_stopped[queue]))
> +               return;
> +
> +       if (skb_queue_len(&rtwsdio->tx_queue[queue]) < RTW_SDIO_TX_FIFO_H=
IWATER)
> +               return;
> +
> +       WRITE_ONCE(rtwsdio->tx_queue_stopped[queue], true);
> +       ieee80211_stop_queue(rtwdev->hw, q_map);
> +
> +       /*
> +        * The worker may have drained the queue between the length check
> +        * above and the flag becoming visible; its wake check then saw t=
he
> +        * flag still clear and this stop would never be undone. Re-check
> +        * now that the flag is set and undo the stop if so. Both sides c=
an
> +        * wake, which is harmless; the barrier pairs with the one in
> +        * rtw_sdio_8723bs_wake_tx_queue() so at least one side does.
> +        */
> +       smp_mb();

With WRITE_ONCE() and READ_ONCE(), I think it will concurrency work
well. Did you really encounter problems with smp_mb()?

a blank line.

> +       if (skb_queue_len(&rtwsdio->tx_queue[queue]) <=3D
> +           RTW_SDIO_TX_FIFO_LOWATER) {
> +               WRITE_ONCE(rtwsdio->tx_queue_stopped[queue], false);
> +               ieee80211_wake_queue(rtwdev->hw, q_map);
> +       }
> +}
> +
> +static void rtw_sdio_8723bs_wake_tx_queue(struct rtw_dev *rtwdev,
> +                                         enum rtw_tx_queue_type queue,
> +                                         u16 q_map)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +
> +       if (!rtw_is_8723bs(rtwdev) || queue >=3D RTW_TX_QUEUE_BCN)
> +               return;
> +
> +       /* pairs with the barrier in rtw_sdio_8723bs_stop_tx_queue() */
> +       smp_mb();
> +
> +       if (!READ_ONCE(rtwsdio->tx_queue_stopped[queue]))
> +               return;
> +
> +       if (skb_queue_len(&rtwsdio->tx_queue[queue]) > RTW_SDIO_TX_FIFO_L=
OWATER)
> +               return;
> +
> +       WRITE_ONCE(rtwsdio->tx_queue_stopped[queue], false);
> +       ieee80211_wake_queue(rtwdev->hw, q_map);
> +}
> +

[...]

>=20
> -static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
> -                                     enum rtw_tx_queue_type queue)
> +/*
> + * Send one frame from @queue. Returns 0 when a frame was written, 1 whe=
n the
> + * queue was empty and a negative errno when the write failed, in which =
case
> + * the frame is put back at the head of the queue.
> + */
> +static int rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
> +                                    enum rtw_tx_queue_type queue)
>  {
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
>         struct sk_buff *skb;
> +       u16 q_map;
>         int ret;
>=20
>         skb =3D skb_dequeue(&rtwsdio->tx_queue[queue]);
>         if (!skb)
> -               return;
> +               return 1;
>=20
> +       q_map =3D skb_get_queue_mapping(skb);

Can we move below just before the user?

>         ret =3D rtw_sdio_write_port(rtwdev, skb, queue);
>         if (ret) {
>                 skb_queue_head(&rtwsdio->tx_queue[queue], skb);
> -               return;
> +               return ret;
>         }
>=20
>         rtw_sdio_indicate_tx_status(rtwdev, skb);
> +
> +       rtw_sdio_8723bs_wake_tx_queue(rtwdev, queue, q_map);
> +
> +       return 0;
> +}
> +


