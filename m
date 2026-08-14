Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4322F3F326A;
	Fri, 14 Aug 2026 07:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691712; cv=none; b=qFidQbPzrlyD80XXtXgB9LHMXtOyozA9CEDIih8q9eZWx8mz5wfXermQ33xNpPuyD+1njlxbkWqOzOlsRMrxkq5GDkNQxEDxrqAOMYgXD0Bs3z/lWKUwiwUdmVUazMwbU39Igoa/f79MblVwyONW5bExbfyPFaXRGROM0n6DQ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691712; c=relaxed/simple;
	bh=3AAqCQycodoszfwaOVxP2S6mLBd+39fUTF/fWd53cGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WBitZ83ennxY//+zQqRsjUKIHmNp4IObcIp3wzXDjaMSOT141OObQQx8O/nsBF5n2Ad0UuqwnV0DgD8bz2X3ibHzkpLy/pVz3hdksspniW6GMdKa0yfhTs6DBZxTLivC+1c1eSfFT8SGWG5Qpf8plAO/w5DtdYJ+xFU6SHQJp1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=csy5n8OP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="csy5n8OP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7EqZO21058893, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786691693; bh=A/zzKYqT2yQprKKXagGQgWj6+4t97dUYBNhhivpzG7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=csy5n8OPP2HBS9MtzbhD4h9dhGZUDuqn1eLn0A9Ewk7dxi6jAfjZOUa5IkL5tOScj
	 jmUNHpcwXiYUTttw7u8m1QCrlktKzTeGeIFt7zN0gDIJpm73DamO4wOR+k17NtFW4I
	 XZJab9tJvazXnO5rRm0ZptmoulJ8UYMeamy60kOMUPKLTESpR+J+dYyciHejbQWCGF
	 95hLpkUmlIk3vuepqi899SPFM5b6URjYW7A8MLWJI86NGXi85vtfMl0WAh8zSzX+Q7
	 cUGGgGZavP8ayCPEAmwtQ0Zwh9uHiDeapQ/dWJW46kk8pbn82UQ78WRaj1791J/GoL
	 gN1sc2Xl0nIpQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7EqZO21058893
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:14:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:14:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:14:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:14:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 7/7] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v4 7/7] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdKXGrLBtcgkdsek6vm9JcLVT6ULadHpRQ
Date: Fri, 14 Aug 2026 07:14:52 +0000
Message-ID: <498fd000eb68454fb9842c3f9879ea4e@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-8-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-8-luka.gejak@linux.dev>
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
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> Two problems show up on RTL8723BS uplink. The per-AC software FIFO is
> unbounded, so mac80211 keeps handing frames down until latency collapses
> under load. And when the chip runs out of free TX pages the queue is
> simply abandoned for that pass, which stalls the AC until something else
> kicks the worker.
>=20
> Stop the mac80211 queue once a data AC fills past a high watermark and
> wake it from the drain path when it falls back to a low one. Convert the
> TX work item to a delayed work so a temporary page shortage can be
> retried shortly afterwards instead of stalling, and cancel it on
> teardown.
>=20
> Measured on RTL8723BS hardware, uplink goes from 11.9 Mbit/s with 204
> TCP retransmits to 20.1 Mbit/s with 2.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 99 ++++++++++++++++++++---
>  drivers/net/wireless/realtek/rtw88/sdio.h |  3 +-
>  2 files changed, 91 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index e9f0d23113f3..ed1bed8ea144 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -22,6 +22,16 @@
>  #define RTW_SDIO_INDIRECT_RW_RETRIES                   50
>  #define RTW_SDIO_OQT_TIMEOUT_MS                                1000
>=20
> +/*
> + * 8723BS SDIO TX FIFO back-pressure watermarks: stop the mac80211 queue=
 once
> + * the per-AC software FIFO fills past the high watermark, and wake it f=
rom the
> + * TX drain path once it falls back to the low one. Bounds the queueing =
latency
> + * that otherwise causes uplink bufferbloat / congestion collapse.
> + */
> +#define RTW_SDIO_TX_FIFO_HIWATER                       16
> +#define RTW_SDIO_TX_FIFO_LOWATER                       8
> +#define RTW_SDIO_TX_RETRY_DELAY                        msecs_to_jiffies(=
1)

If HZ is smaller than 1000, the value will be 0 I think. Is it expected?
(may be not a problem)

> +
>  static bool rtw_sdio_is_bus_addr(u32 addr)
>  {
>         return !!(addr & RTW_SDIO_BUS_MSK);
> @@ -1053,7 +1063,11 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *r=
twdev)
>  {
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
>=20
> -       queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
> +       /*
> +        * A retry may already be pending with a delay; re-arm it so a ne=
wly
> +        * queued frame is not held back by it.
> +        */
> +       mod_delayed_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work, =
0);
>  }
>=20
>  static void rtw_sdio_link_ps(struct rtw_dev *rtwdev, bool enter)
> @@ -1177,6 +1191,19 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwde=
v,
>=20
>         skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
>=20
> +       /*
> +        * Back-pressure on the data ACs (BK/BE/VI/VO): once the FIFO fil=
ls past
> +        * the high watermark, stop the corresponding mac80211 queue so i=
t stops
> +        * handing us frames, bounding the queueing latency. Resumed from=
 the TX
> +        * drain path once the FIFO drains below the low watermark.
> +        */
> +       if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
> +           !rtwsdio->queue_stopped[queue] &&
> +           skb_queue_len(&rtwsdio->tx_queue[queue]) >=3D RTW_SDIO_TX_FIF=
O_HIWATER) {
> +               rtwsdio->queue_stopped[queue] =3D true;
> +               ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(sk=
b));
> +       }
> +

Can we move this chunk into a function? Then, you don't need to write
complicated conditions into a if-statement.=20

As well as the chunk to call ieee80211_wake_queue().

>         return 0;
>  }
>=20
> @@ -1479,43 +1506,92 @@ static void rtw_sdio_indicate_tx_status(struct rt=
w_dev *rtwdev,
>         ieee80211_tx_status_irqsafe(hw, skb);
>  }
>=20
> -static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
> -                                     enum rtw_tx_queue_type queue)
> +/*
> + * Send one frame from @queue. Returns 1 when a frame was written, 0 whe=
n the
> + * queue was empty=20

I'd prefer 0 is successful case. 1 is special case (queue was empty).

> and a negative errno when the write failed, in which case
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
> +               return 0;
>=20
> +       q_map =3D skb_get_queue_mapping(skb);
>         ret =3D rtw_sdio_write_port(rtwdev, skb, queue);
>         if (ret) {
>                 skb_queue_head(&rtwsdio->tx_queue[queue], skb);
> -               return;
> +               return ret;
>         }
>=20
>         rtw_sdio_indicate_tx_status(rtwdev, skb);
> +
> +       if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
> +           rtwsdio->queue_stopped[queue] &&
> +           skb_queue_len(&rtwsdio->tx_queue[queue]) <=3D
> +           RTW_SDIO_TX_FIFO_LOWATER) {
> +               rtwsdio->queue_stopped[queue] =3D false;
> +               ieee80211_wake_queue(rtwdev->hw, q_map);
> +       }

Move to a function.

> +
> +       return 1;
>  }
>=20
>  static void rtw_sdio_tx_handler(struct work_struct *work)
>  {
>         struct rtw_sdio_work_data *work_data =3D
> -               container_of(work, struct rtw_sdio_work_data, work);
> +               container_of(to_delayed_work(work), struct rtw_sdio_work_=
data,
> +                            work);
>         struct rtw_sdio *rtwsdio;
>         struct rtw_dev *rtwdev;
> -       int limit, queue;
> +       int limit, queue, ret;
> +       bool rtl8723bs;
>=20
>         rtwdev =3D work_data->rtwdev;
>         rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       rtl8723bs =3D rtw_is_8723bs(rtwdev);
>=20
>         if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_TX_WAKE))
>                 rtw_sdio_deep_ps_leave(rtwdev);
>=20
>         for (queue =3D RTK_MAX_TX_QUEUE_NUM - 1; queue >=3D 0; queue--) {
>                 for (limit =3D 0; limit < 1000; limit++) {
> -                       rtw_sdio_process_tx_queue(rtwdev, queue);
> +                       ret =3D rtw_sdio_process_tx_queue(rtwdev, queue);
> +                       if (ret =3D=3D 0)
> +                               break;
> +
> +                       if (ret < 0) {
> +                               /*
> +                                * A page shortage is transient: leave th=
e
> +                                * frame queued and come back shortly ins=
tead
> +                                * of stalling this AC until something el=
se
> +                                * kicks the worker.
> +                                */
> +                               if (rtl8723bs && ret =3D=3D -EBUSY) {
> +                                       queue_delayed_work(rtwsdio->txwq,
> +                                                          &work_data->wo=
rk,
> +                                                          RTW_SDIO_TX_RE=
TRY_DELAY);
> +                                       return;
> +                               }
> +                               break;
> +                       }
> +
> +                       /*
> +                        * Restart from the highest priority queue after =
every
> +                        * management frame so the join sequence is not h=
eld up
> +                        * behind a data backlog.
> +                        */
> +                       if (rtl8723bs && queue =3D=3D RTW_TX_QUEUE_MGMT) =
{
> +                               queue_delayed_work(rtwsdio->txwq,
> +                                                  &work_data->work, 0);
> +                               return;
> +                       }

Move this chunk into a function named reschedule_tx_work() or something
like that.

>=20
>                         if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
>                                 break;
> @@ -1542,14 +1618,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwde=
v)
>                 return -ENOMEM;
>         }
>=20
> -       for (i =3D 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
> +       for (i =3D 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
>                 skb_queue_head_init(&rtwsdio->tx_queue[i]);
> +               rtwsdio->queue_stopped[i] =3D false;
> +       }
>         rtwsdio->tx_handler_data =3D kmalloc_obj(*rtwsdio->tx_handler_dat=
a);
>         if (!rtwsdio->tx_handler_data)
>                 goto err_destroy_wq;
>=20
>         rtwsdio->tx_handler_data->rtwdev =3D rtwdev;
> -       INIT_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
> +       INIT_DELAYED_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_ha=
ndler);
>=20
>         return 0;
>=20
> @@ -1563,6 +1641,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwd=
ev)
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
>         int i;
>=20
> +       cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
>         destroy_workqueue(rtwsdio->txwq);
>         kfree(rtwsdio->tx_handler_data);
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wire=
less/realtek/rtw88/sdio.h
> index 7474a7511811..2f1b67f4bbc7 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.h
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.h
> @@ -156,7 +156,7 @@ struct rtw_sdio_tx_data {
>  };
>=20
>  struct rtw_sdio_work_data {
> -       struct work_struct work;
> +       struct delayed_work work;
>         struct rtw_dev *rtwdev;
>  };
>=20
> @@ -172,6 +172,7 @@ struct rtw_sdio {
>         struct workqueue_struct *txwq;
>         struct rtw_sdio_work_data *tx_handler_data;
>         struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
> +       bool queue_stopped[RTK_MAX_TX_QUEUE_NUM];

add 'tx_' prefix? tx_queue_stopped[]=20

>=20
>         atomic_t free_pg_high;
>         atomic_t free_pg_normal;
> --
> 2.53.0

