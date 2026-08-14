Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4811189F43;
	Fri, 14 Aug 2026 06:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689152; cv=none; b=DClmVp6l9gV+bt5+WJXlQslhMg5/XB1yW/1ob8SIatbtPOlIRUiITqlxr9zdW+9Y2Id7gP1Yn8Zuv6dkXvCqfouuU/L0lRBNMLMHVceDi+Mt7Jku8BlvZbhji9jPjxNirQoul6w2SRrY3z/WIy8Wtdetpw9PV138n80KOU//rCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689152; c=relaxed/simple;
	bh=pJfCwsY7G03rnoIBPnfmwiLLPf7mJ0yxv6tz/r5sffI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HSZMlKBjSlu1txVfEZbHpVNKLChlBc+Sty5H49piW1w7UU1ldDXQkjYb5b+NNgqTyWCukTNMFhN2lyTht0sEQFUIAW6V6PDV5hweE3BPsVStSvZyhDzS+KSbFcJie9qCnmgiqFppAYPIWHu972dfix3lrasw1RbQfNAbdaS02DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Mwoi/ExW; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Mwoi/ExW"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E6WGX501038746, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786689136; bh=Ze+5mQAtQzpA5l/bNtuOuzH9t5JYM98wNtB2mEp5aCA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Mwoi/ExWCOdHyew/IozIRATqgNx/pGxMD9aJRmVGklZwm2DoalI6jFkFG3bc6mhM6
	 JQgQ/PTC9bOdFm9h7fjUGjtFDgh0ILwRVsSKBKZW9fr7ewxkNjWX2zCnZ2kl5upUN3
	 FDEG1jI3FJjI43QjQS8L3kijmblp5x9VmWsECA6RiMSuF+5a/sx19STWSDAacevoMy
	 DeZb+sS+T14VBVoeXXJJAjr3hFourt6HJab4eDRScAcGwcMLKNTBkXu+gpVyIsIt2P
	 vYYeicOGTpBBBX9B5sjANz9T188QblwBzRbb4CPXndJkEyu8VNhKIHUUlzIHOHeK0d
	 HclcJ6+aje+HQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E6WGX501038746
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 14:32:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 14:32:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 14:32:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 5/7] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v4 5/7] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdKXGpB77ftglV7EyMyPGArfPjp7adD9cw
Date: Fri, 14 Aug 2026 06:32:15 +0000
Message-ID: <4e17292f3b424b71a4194c0b8ebb705e@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-6-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-6-luka.gejak@linux.dev>
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
> while pages are in fact available. It also gates transmission on a free
> count in the SDIO output queue, REG_SDIO_OQT_FREE_PG, which rtw88 does

It seems like I asked you what OQT is... Output Queue Track?
Please mention it in commit message. I'd be easier to reviewers.=20

> not track at all. That count is how many more descriptors the SDIO
> engine can accept, and the chip discards writes that arrive with none
> left.
>=20
> Mirror the vendor driver and keep the per-queue and public page counts
> in software, seeded at start and resynchronised from the chip only when
> the cached counts say there is not enough room. Wait for a free output
> queue entry before writing, and account for the pages consumed after a
> successful transfer.
>=20
> Transfers also have to be padded up to the SDIO block size for this
> chip rather than using the generic alignment, so size the write
> separately from the frame and trim the skb back afterwards.
>=20
> Measured on RTL8723BS hardware against an iperf3 server one hop behind
> the AP, with the wlan0 byte counters as ground truth. On the generic
> path the association completes but no data passes at all: TCP and UDP
> both measure 0 bit/s in either direction. With this patch TCP is
> 25.3 Mbit/s up and 37.3 Mbit/s down, and UDP is 25.0 Mbit/s up at 0%
> loss.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 245 ++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/sdio.h |  10 +
>  2 files changed, 243 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index 5b40d74b16ee..493eda559607 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -20,6 +20,7 @@
>  #include "tx.h"
>=20
>  #define RTW_SDIO_INDIRECT_RW_RETRIES                   50
> +#define RTW_SDIO_OQT_TIMEOUT_MS                                1000

nit: The unit can be '_MS' only if the delay in the loop is
'usleep_range(1000, 2000);' (1ms).=20

With _MS, it is easier to understand, but any opinion to improve it?

>=20
>  static bool rtw_sdio_is_bus_addr(u32 addr)
>  {
> @@ -548,12 +549,122 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwd=
ev, u8 *buf, size_t count)
>         return ret;
>  }
>=20
> +/*
> + * The cached free page counters are a fast path hint only. They are wri=
tten
> + * from the single threaded TX work and, for H2C and reserved page write=
s,
> + * from process context, so they are atomic_t; whenever they claim there=
 is
> + * not enough room they are resynchronised from the chip before the call=
er
> + * gives up, which also absorbs a lost update.
> + */
> +static void rtw_sdio_8723bs_store_free_txpg(struct rtw_dev *rtwdev,
> +                                           u32 free_txpg)
> +{

nit: It looks like you can combine callers of rtw_sdio_8723bs_store_free_tx=
pg()
into single function. Maybe, just rtw_sdio_8723bs_sync_free_txpg(), and add
a return value for rtw_sdio_8723bs_init_free_txpg().

How about you?

> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +
> +       atomic_set(&rtwsdio->free_pg_high,
> +                  u32_get_bits(free_txpg, BIT_FREE_TXPG_HIGH));
> +       atomic_set(&rtwsdio->free_pg_normal,
> +                  u32_get_bits(free_txpg, BIT_FREE_TXPG_NORMAL));
> +       atomic_set(&rtwsdio->free_pg_low,
> +                  u32_get_bits(free_txpg, BIT_FREE_TXPG_LOW));
> +       atomic_set(&rtwsdio->free_pg_pub,
> +                  u32_get_bits(free_txpg, BIT_FREE_TXPG_PUB));
> +}
> +

[...]

> @@ -749,8 +939,39 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
>         return 0;
>  }
>=20
> +static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
> +{
> +       const struct rtw_chip_info *chip =3D rtwdev->chip;
> +       struct rtw_fifo_conf *fifo =3D &rtwdev->fifo;
> +       const struct rtw_page_table *pg_tbl;
> +       u16 reserved_num;
> +       u32 free_txpg;
> +       u16 pubq_num;
> +
> +       free_txpg =3D rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +       if (free_txpg || !fifo->acq_pg_num)

It will return directly if free_txpg is not zero... what does it mean?

> +               return;
> +
> +       pg_tbl =3D &chip->page_table[0];
> +       reserved_num =3D pg_tbl->hq_num + pg_tbl->lq_num + pg_tbl->nq_num=
 +
> +                      pg_tbl->exq_num + pg_tbl->gapq_num;
> +       if (fifo->acq_pg_num <=3D reserved_num)

If it falls into this case, can it still work? If not, should it return
an error?

> +               return;
> +
> +       pubq_num =3D fifo->acq_pg_num - reserved_num;
> +       rtw_write32(rtwdev, REG_RQPN_NPQ,
> +                   BIT_RQPN_NE(pg_tbl->nq_num, pg_tbl->exq_num));
> +       rtw_write32(rtwdev, REG_RQPN,
> +                   BIT_RQPN_HLP(pg_tbl->hq_num, pg_tbl->lq_num, pubq_num=
));
> +}
> +
>  static int rtw_sdio_start(struct rtw_dev *rtwdev)
>  {
> +       if (rtw_is_8723bs(rtwdev)) {
> +               rtw_sdio_8723bs_check_rqpn(rtwdev);
> +               rtw_sdio_8723bs_init_free_txpg(rtwdev);
> +       }
> +
>         rtw_sdio_enable_rx_aggregation(rtwdev);
>         rtw_sdio_enable_interrupt(rtwdev);
>=20

[...]

