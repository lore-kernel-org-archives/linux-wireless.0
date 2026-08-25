Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7B3B388A;
	Tue, 25 Aug 2026 06:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787638399; cv=none; b=mHfDCrsPVjQznF2q2N8u8IopNmdTvdSQXDjykuhtF2qzA3FlpChqb5a2PLJC56r1FFxkDX4iRXe2AtSGrzVR/W4t5RceppXSGURSgcbEG6fxscx561SLR6pXA1HlslWfcax5PtkDaUtWOa7uOF3+sf8PFGi3A+npsOd9E4UdlpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787638399; c=relaxed/simple;
	bh=VvRvrfLk6g1WTW7NZy05xUGJZLg+M1vzfxYtxvnDukw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKJd0jRq9b+LBoJKrgL1zlMQDPPKUmP/DdaQS9PUWxr/n+a2O3RdyjlCmLgaYaSTOzVURnnw/YnmJw6ddlvc8U/65Pb6uQKOkQiyebY9GTvJGOCMxwgF03eaACzppjPlxGtFu0bF3RqbOnVUwnNEVa8dxEGLrUYDS65DNFZhz40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dhL1ZuL2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dhL1ZuL2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P6Cw2bA3530939, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787638378; bh=cYNgnlQ0iAcgy3yCX/DMnYwPfyfyn42FgsYyk5PL4Vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=dhL1ZuL2Pli1O3t6iEh2BDPiGZUbfo1Y5F1DspBHXO5qR3H6IaDtTPxsNBoHj+m3u
	 8VreTMFK4bm+XEGxA0tkuIP73Cj2qzqAbZ59UYPXIr6STBEFZ2MgDldmV+H+dkq1YX
	 pl0Hm5ebahIueVpzIrPgzD2wrZYnDEWoN/MVTRCZevQ5GdvSLj2e2hx559RnhMBaRY
	 gf1Znv2tqYY0EVwZxYl9Angl9A+N/9PnbpZeWo+/FrGbaIVeKCj2ahr0b+SopHo1gR
	 XiVJtM+uz6f5iL61Xolkaz/z5Eyo/ONp5cskcTChwELDk5eBWXajXBS8VcqJOxLH2M
	 nk2GzF+xKTIJg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P6Cw2bA3530939
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 14:12:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 14:12:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 14:12:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 14:12:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw
Date: Tue, 25 Aug 2026 06:12:58 +0000
Message-ID: <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
In-Reply-To: <20260820090412.19574-5-luka.gejak@linux.dev>
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

>  static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *s=
kb,
>                                enum rtw_tx_queue_type queue)
>  {
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       bool rtl8723bs =3D rtw_is_8723bs(rtwdev);
> +       unsigned int pages;
> +       size_t write_size;
>         bool bus_claim;
>         size_t txsize;
>         u32 txaddr;
> @@ -645,31 +837,73 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwd=
ev, struct sk_buff *skb,
>         if (!txaddr)
>                 return -EINVAL;
>=20
> -       txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len);
> +       if (rtl8723bs) {
> +               txsize =3D round_up(skb->len, 4);
> +               write_size =3D txsize > RTW_SDIO_BLOCK_SIZE ?
> +                            round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsi=
ze;
> +
> +               /*
> +                * __skb_pad() zeroes the padding without moving skb->len=
 and
> +                * reallocates when the skb is cloned or short on tailroo=
m,
> +                * so the padding can never land in a buffer a clone stil=
l
> +                * shares. It must not free the skb on failure: both call=
ers
> +                * still own it, one requeues it and the other frees it.
> +                */

I think you only need to note 'not free the skb on failure'.=20

> +               if (write_size > skb->len) {

And move comment here to note __skb_pad().

By the way, we can have a local variable 'pad_size =3D write_size > skb->le=
n'.
Then,

    if (pad_size) {
        ret =3D __skb_pad( ..., pad_size, ...);
        ...
    }

> +                       ret =3D __skb_pad(skb, write_size - skb->len, fal=
se);
> +                       if (ret)
> +                               return ret;
> +               }
> +       } else {
> +               txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len);
> +               write_size =3D txsize;
> +       }
> +
> +       /*
> +        * The free page check, the output queue wait and the accounting
> +        * after the transfer must not interleave with another writer: th=
e
> +        * TX worker and the H2C path run concurrently, and two writers t=
hat
> +        * both pass the checks can claim the same pages and output queue
> +        * entry, after which the chip silently discards whichever transf=
er
> +        * arrives second.
> +        */

Not sure if the comment along declaration of tx_credit_lock is enough?
If so, maybe we don't need this comment.=20

> +       if (rtl8723bs)
> +               mutex_lock(&rtwsdio->tx_credit_lock);

guard(mutex)(&rtwsdio->tx_credit_lock);

I think you can add lockdep_assert_held() to the places the locks (mutex)
must be held, and run test if somewhere throw warning (must not).=20

>=20
>         ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
>         if (ret)
> -               return ret;
> +               goto out_unlock;
> +
> +       if (rtl8723bs) {
> +               ret =3D rtw_sdio_8723bs_wait_tx_oqt(rtwdev);
> +               if (ret)
> +                       goto out_unlock;
> +       }
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
> -       if (ret)
> +       if (ret) {
>                 rtw_warn(rtwdev,
>                          "Failed to write %zu byte(s) to SDIO port 0x%08x=
",
> -                        txsize, txaddr);
> +                        write_size, txaddr);
> +       } else if (rtl8723bs) {
> +               pages =3D DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
> +               rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
> +       }
>=20
> +out_unlock:
> +       if (rtl8723bs)
> +               mutex_unlock(&rtwsdio->tx_credit_lock);
>         return ret;
>  }
>=20

[...]


