Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32B03793A5;
	Mon, 27 Jul 2026 08:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142363; cv=none; b=f5VISPSsmlwyrpq9dDpgCYKkyLR1hjjXEoho1LUm74SLsShkFGP9wOXXWar1FCRdGBtDtrEqI/gw+M2rDBhUxnApm1uM8aq+4DZ5+84UTkwoFlNYh1Hn74mSqx6p8OK17KvO5RnTanMyjJL72zRJavT+1ny96bBgL/9Jj9HtO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142363; c=relaxed/simple;
	bh=i/zuG/fHjoSVm6EMlbuwjb8LjbPYivo4GQpNF4CG4jg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DKtsjOUcubtoP4PsqcDZp8QNIsFIzLctwGeE/lRpcdZyLiWLFQllMwLIz0rJiR/KR5JKS8b80U39myZSxijYO6/kiYb2js0zx49yBEB9nzQCJMxWEZoiNPHnJ5MCEKJNPCkRNxyQLKAHE8nYhtxR37idPYoM4ety4oYvM+MF/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VAboJyCq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VAboJyCq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R8qUPA12979124, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785142350; bh=+F1hYD9aHHwG36oBuyUbwLbgvUa9B22V4SanEEk0iKg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VAboJyCqCBFV92j+8sPP1FXITK7bO73YxmW9/Dp0XkAq/5Wz7WQJJKwIBI1ipvXsr
	 yYErl7SqQY6CIMZaCqmHYWRsoFdR3/hiYbjYNsF97zYqN3fhmyWCRvLSLZd3CO77Ed
	 pyn+/1v7zutANiypo1wtekQfWVXFt1xDQIGWS99szamEmABiueDtS+Yl1QxPMLSsFi
	 goR7DBgyulsRM7axmL3tyDaajPhGireKkNjqomkJ8wiqxWyreyiVbFgfBs5LV23F4G
	 9+CibRP2NBLPW27MdLxss7xhGGyNQgyq8SuTIdy8MELDHQARd4VSP3HJ5y2IitEaKu
	 aXQSJA/xIiqhA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R8qUPA12979124
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 16:52:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 07/11] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v2 07/11] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdHEb7u0WNahp1iUK78oKqvdhnpbaBCi0A
Date: Mon, 27 Jul 2026 08:52:30 +0000
Message-ID: <cc9251b01235422e8b5a22fc0997b0f7@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-8-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-8-luka.gejak@linux.dev>
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
> The RTL8723BS reports free TX page counts that the generic 8051 path
> reads back from the chip on every transfer, which is both slow over SDIO
> and unreliable on this part: the register frequently reads back zero
> while pages are in fact available. It also gates transmission on an
> output queue token count that rtw88 does not track at all.
>=20
> Mirror the vendor driver and keep the per-queue and public page counts
> in software, seeded at start and resynchronised from the chip only when
> the cached counts say there is not enough room. Wait for an OQT credit

Does OQT mean Output Queue Token? Could you explain a little bit?

> before writing, and account for the pages consumed after a successful
> transfer.
>=20
> Transfers also have to be padded up to the SDIO block size for this
> chip rather than using the generic alignment, so size the write
> separately from the frame and trim the skb back afterwards.

I think this can largely improve SDIO. Please share the performance=20
numbers before/after this patch.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 220 ++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/sdio.h |   6 +
>  2 files changed, 215 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index 5b40d74b16ee..adf0b509e2cc 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -20,6 +20,7 @@
>  #include "tx.h"
>=20
>  #define RTW_SDIO_INDIRECT_RW_RETRIES                   50
> +#define RTW_SDIO_OQT_TIMEOUT_MS                                1000
>=20
>  static bool rtw_sdio_is_bus_addr(u32 addr)
>  {
> @@ -548,12 +549,91 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwde=
v, u8 *buf, size_t count)
>         return ret;
>  }
>=20
> +static void rtw_sdio_init_free_txpg(struct rtw_dev *rtwdev)

_8723bs_ specific so add to the function name

> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       const struct rtw_page_table *pg_tbl;
> +       u32 free_txpg;
> +       u16 pubq_num;
> +
> +       if (!rtw_is_8723bs(rtwdev))
> +               return;
> +
> +       pg_tbl =3D &rtwdev->chip->page_table[0];
> +       pubq_num =3D rtwdev->fifo.acq_pg_num - pg_tbl->hq_num - pg_tbl->l=
q_num -
> +                  pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
> +       free_txpg =3D rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +       if (free_txpg) {
> +               atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
> +               atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0=
xff);
> +               atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xf=
f);
> +               atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xf=
f);
> +       } else {
> +               atomic_set(&rtwsdio->free_pg_high, pg_tbl->hq_num);
> +               atomic_set(&rtwsdio->free_pg_normal, pg_tbl->nq_num);
> +               atomic_set(&rtwsdio->free_pg_low, pg_tbl->lq_num);
> +               atomic_set(&rtwsdio->free_pg_pub, pubq_num);
> +       }
> +
> +       atomic_set(&rtwsdio->tx_oqt_free,
> +                  rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG));
> +}
> +
> +static void rtw_sdio_sync_free_txpg(struct rtw_dev *rtwdev)

_8723bs_ specific so add to the function name

> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       u32 free_txpg =3D rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +
> +       if (!free_txpg)
> +               return;
> +
> +       atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
> +       atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0xff);
> +       atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xff);
> +       atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xff);

It is clear that bit masks of REG_SDIO_FREE_TXPG are PG_{HIGH, NORMAL, LOW,=
 PUB}.=20
Let's define them in reg.h, and use u32_get_bits() to read out the values.

> +}
> +
> +static int rtw_sdio_8723bs_free_txpg(struct rtw_dev *rtwdev, u8 queue)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +
> +       switch (queue) {
> +       case RTW_TX_QUEUE_BCN:
> +       case RTW_TX_QUEUE_H2C:
> +       case RTW_TX_QUEUE_HI0:
> +       case RTW_TX_QUEUE_MGMT:
> +       case RTW_TX_QUEUE_VO:
> +               return atomic_read(&rtwsdio->free_pg_high);
> +       case RTW_TX_QUEUE_VI:
> +               return atomic_read(&rtwsdio->free_pg_normal);
> +       case RTW_TX_QUEUE_BE:
> +       case RTW_TX_QUEUE_BK:
> +               return atomic_read(&rtwsdio->free_pg_low);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
>  static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
>                                     size_t count)
>  {
>         unsigned int pages_free, pages_needed;
>=20
> -       if (rtw_chip_wcpu_8051(rtwdev)) {
> +       if (rtw_is_8723bs(rtwdev)) {
> +               struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->p=
riv;
> +               int dedicated =3D rtw_sdio_8723bs_free_txpg(rtwdev, queue=
);
> +
> +               if (dedicated < 0)
> +                       return dedicated;
> +               pages_free =3D dedicated + atomic_read(&rtwsdio->free_pg_=
pub);
> +               pages_needed =3D DIV_ROUND_UP(count, rtwdev->chip->page_s=
ize);
> +               if (pages_needed <=3D pages_free)
> +                       return 0;
> +
> +               rtw_sdio_sync_free_txpg(rtwdev);
> +               dedicated =3D rtw_sdio_8723bs_free_txpg(rtwdev, queue);

Why do you check ` dedicated < 0` for this case?

> +               pages_free =3D dedicated + atomic_read(&rtwsdio->free_pg_=
pub);
> +       } else if (rtw_chip_wcpu_8051(rtwdev)) {
>                 u32 free_txpg;
>=20
>                 free_txpg =3D rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG)=
;
> @@ -632,44 +712,131 @@ static int rtw_sdio_check_free_txpg(struct rtw_dev=
 *rtwdev, u8 queue,
>         return 0;
>  }
>=20
> +static int rtw_sdio_wait_tx_oqt(struct rtw_dev *rtwdev)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       int i;
> +       u8 free;
> +
> +       if (!rtw_is_8723bs(rtwdev))
> +               return 0;
> +
> +       if (atomic_add_unless(&rtwsdio->tx_oqt_free, -1, 0))
> +               return 0;
> +
> +       for (i =3D 0; i < RTW_SDIO_OQT_TIMEOUT_MS; i++) {
> +               free =3D rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG);
> +               if (free) {
> +                       atomic_set(&rtwsdio->tx_oqt_free, free - 1);
> +                       return 0;
> +               }
> +               usleep_range(1000, 2000);
> +       }
> +
> +       return -EBUSY;
> +}
> +
> +static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queu=
e,
> +                                        unsigned int pages)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       atomic_t *dedicated;
> +       int free;
> +
> +       switch (queue) {
> +       case RTW_TX_QUEUE_VI:
> +               dedicated =3D &rtwsdio->free_pg_normal;
> +               break;
> +       case RTW_TX_QUEUE_BE:
> +       case RTW_TX_QUEUE_BK:
> +               dedicated =3D &rtwsdio->free_pg_low;
> +               break;
> +       default:
> +               dedicated =3D &rtwsdio->free_pg_high;
> +               break;
> +       }
> +
> +       free =3D atomic_read(dedicated);
> +       if (pages <=3D free) {
> +               atomic_sub(pages, dedicated);
> +       } else {
> +               atomic_set(dedicated, 0);
> +               atomic_sub(pages - free, &rtwsdio->free_pg_pub);
> +       }
> +}
> +
>  static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *s=
kb,
>                                enum rtw_tx_queue_type queue)
>  {
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       unsigned int orig_len =3D skb->len;
> +       bool rtl8723bs =3D rtw_is_8723bs(rtwdev);

reverse X'mas tree=20

> +       unsigned int pages;
>         bool bus_claim;
>         size_t txsize;
> +       size_t write_size;
>         u32 txaddr;
>         int ret;
>=20
> -       txaddr =3D rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
> -       if (!txaddr)
> -               return -EINVAL;
> +       if (rtl8723bs) {
> +               txsize =3D round_up(orig_len, 4);
> +               write_size =3D txsize > RTW_SDIO_BLOCK_SIZE ?
> +                            round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsi=
ze;
> +       } else {
> +               txsize =3D sdio_align_size(rtwsdio->sdio_func, orig_len);
> +               write_size =3D txsize;
> +       }
> +
> +       if (write_size > orig_len) {
> +               unsigned int padding =3D write_size - orig_len;
> +
> +               if (skb_tailroom(skb) < padding) {
> +                       ret =3D pskb_expand_head(skb, 0,
> +                                              padding - skb_tailroom(skb=
),
> +                                              GFP_KERNEL);
> +                       if (ret)
> +                               return ret;
> +               }
> +               skb_put_zero(skb, padding);
> +       }
>=20
> -       txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len);
> +       txaddr =3D rtw_sdio_get_tx_addr(rtwdev, txsize, queue);
> +       if (!txaddr) {
> +               ret =3D -EINVAL;
> +               goto out_trim;
> +       }
>=20
>         ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
>         if (ret)
> -               return ret;
> +               goto out_trim;
> +       ret =3D rtw_sdio_wait_tx_oqt(rtwdev);
> +       if (ret)
> +               goto out_trim;
>=20
>         if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN=
))
>                 rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\=
n",
>                          __func__, queue);
>=20
>         bus_claim =3D rtw_sdio_bus_claim_needed(rtwsdio);
> -
>         if (bus_claim)
>                 sdio_claim_host(rtwsdio->sdio_func);
> -
> -       ret =3D sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data, t=
xsize);
> -
> +       ret =3D sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data,
> +                              write_size);
>         if (bus_claim)
>                 sdio_release_host(rtwsdio->sdio_func);
>=20
> +       if (!ret && rtl8723bs) {
> +               pages =3D DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
> +               rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
> +       }

move to else-branch below?

>         if (ret)
>                 rtw_warn(rtwdev,
>                          "Failed to write %zu byte(s) to SDIO port 0x%08x=
",
> -                        txsize, txaddr);
> +                        write_size, txaddr);

		else (rtl8723bs) {
		   ...
		}

>=20
> +out_trim:
> +       if (write_size > orig_len)
> +               skb_trim(skb, orig_len);
>         return ret;
>  }
>=20
> @@ -749,8 +916,39 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
>         return 0;
>  }
>=20
> +static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
> +{
> +       const struct rtw_chip_info *chip =3D rtwdev->chip;
> +       struct rtw_fifo_conf *fifo =3D &rtwdev->fifo;
> +       const struct rtw_page_table *pg_tbl;
> +       u32 free_txpg;
> +       u16 pubq_num;
> +
> +       if (!rtw_is_8723bs(rtwdev))
> +               return;
> +
> +       free_txpg =3D rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +       if (free_txpg || !fifo->acq_pg_num)
> +               return;
> +
> +       pg_tbl =3D &chip->page_table[0];
> +       if (fifo->acq_pg_num <=3D pg_tbl->hq_num + pg_tbl->lq_num +
> +                                   pg_tbl->nq_num + pg_tbl->exq_num +
> +                                   pg_tbl->gapq_num)

second and third lines don't align.=20

> +               return;
> +
> +       pubq_num =3D fifo->acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
> +                  pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
> +       rtw_write32(rtwdev, REG_RQPN_NPQ,
> +                   BIT_RQPN_NE(pg_tbl->nq_num, pg_tbl->exq_num));
> +       rtw_write32(rtwdev, REG_RQPN,
> +                   BIT_RQPN_HLP(pg_tbl->hq_num, pg_tbl->lq_num, pubq_num=
));
> +}
> +
>  static int rtw_sdio_start(struct rtw_dev *rtwdev)
>  {
> +       rtw_sdio_8723bs_check_rqpn(rtwdev);

Should we check chip is RTL8723BS before calling?=20
I'd have consistent the calling rule -- callers check?

> +       rtw_sdio_init_free_txpg(rtwdev);

This is also RTL8723BS specific. Why not having a '_8723bs_' ?

>         rtw_sdio_enable_rx_aggregation(rtwdev);
>         rtw_sdio_enable_interrupt(rtwdev);
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wire=
less/realtek/rtw88/sdio.h
> index 457e8b02380e..12086f1aa280 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.h
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.h
> @@ -159,6 +159,12 @@ struct rtw_sdio {
>         struct workqueue_struct *txwq;
>         struct rtw_sdio_work_data *tx_handler_data;
>         struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
> +
> +       atomic_t free_pg_high;
> +       atomic_t free_pg_normal;
> +       atomic_t free_pg_low;
> +       atomic_t free_pg_pub;
> +       atomic_t tx_oqt_free;

Could I know the reason why these should be atomic_t? Which context are the=
y running?

>  };
>=20
>  extern const struct dev_pm_ops rtw_sdio_pm_ops;
> --
> 2.55.0

