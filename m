Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B19392802;
	Fri, 28 Aug 2026 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909025; cv=none; b=H5qkf42vO+6H7jZEjPuayf1sN0vWwwDI8g2MlsXGNhAai/fEqpyCU27tq1jbmDGMnZ3oSstcFUtSOLMpDGOHUQjnorNAYlv0SQFg0Bn0Z9un9JyrMokZ66C0a4DBcz6Ss0mdChFo44ZnZfJfs4z1xDMuDoGf8T/eEGMYScazFBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909025; c=relaxed/simple;
	bh=JXFSQGhs2YpYZMaJ7A3NIvc/oK/xTw+ge2K2Y/QnAB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eLLlztlZMRV11AyTKLI38hZynUw35gUhTwGHPjWIDJ9q7Dc1RVpTTp/x9thaOK2VoHchuwURjlNeuLHFC33s4l9Js8QypM4iBxztv4GZ/GimiGmqPvZWxpfoNY/j1x69Y59+jjjgq76m/q0xvVbwhoKj+roSFB3axWw8rK3DrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AmmegmnN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AmmegmnN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S9NReH42322882, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787909007; bh=KKCnsukBj6wzZL+c35EyAkWhdtuofVdrCiPXhLkUqZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=AmmegmnNBP6OzpiqZf0KQKQCADyjJiE5Z1l8PPYs5oHt2M7M1ngK15//M954ERDwI
	 l5cErJBuscI2SsXbCQqentz6vi8Hto5g/9uOT/uSrI0W1bq9ivaudzpzajoO2JuMsf
	 sX8QUGcQXYvMFQn8Qx9jwjsVbG18IFTRIa2tnJpVcPBeD8CdXo6GOSLUSfBPFt/wdC
	 ptFwGC0RWjdCWo2uE4QaCFov6SPD5p6GENpX1fc7s/+6ehme7um6ZwnloAyGeN/PEh
	 RU2dtE+N0mDaXomfZ8vDe1VUmEmeLuQOMXpbXS+mpFGn4eAYgZKqP7Fgb38IXTUoHp
	 oHux7Y5aG4I8A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S9NReH42322882
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 17:23:27 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 17:23:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 17:23:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 17:23:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v8 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v8 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdNK+E+2zknme7j02xPKXo7LOY17azMKZg
Date: Fri, 28 Aug 2026 09:23:26 +0000
Message-ID: <068b8747563444869e19399fbfa78654@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <20260825163314.1590-5-luka.gejak@linux.dev>
In-Reply-To: <20260825163314.1590-5-luka.gejak@linux.dev>
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

> +static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *s=
kb,
> +                              enum rtw_tx_queue_type queue)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       size_t write_size;
> +       size_t txsize;
> +       u32 txaddr;
> +       int ret;
> +
> +       txaddr =3D rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
> +       if (!txaddr)
> +               return -EINVAL;
> +
> +       if (!rtw_is_8723bs(rtwdev)) {
> +               txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len);
> +
> +               ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
> +               if (ret)
> +                       return ret;
> +
> +               if (!IS_ALIGNED((unsigned long)skb->data,
> +                               RTW_SDIO_DATA_PTR_ALIGN))
> +                       rtw_warn(rtwdev,
> +                                "Got unaligned SKB in %s() for queue %u\=
n",
> +                                __func__, queue);
> +
> +               return rtw_sdio_write_to_port(rtwdev, skb, txaddr, txsize=
);

Since you have two branches for RTL8723BS and others, let's implement them
by individual functions. Here can just dispatch, like

int rtw_sdio_write_port()
{
    if (rtw_is_8723bs(rtwdev))
        return rtw_sdio_write_port_8723bs();
    else
        return rtw_sdio_write_port_common();=20
}

> +       }
> +
> +       txsize =3D round_up(skb->len, 4);
> +       write_size =3D txsize > RTW_SDIO_BLOCK_SIZE ?
> +                    round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsize;
> +
> +       if (write_size > skb->len) {
> +               size_t pad_size =3D write_size - skb->len;
> +
> +               /*
> +                * __skb_pad() must not free the skb on failure: both cal=
lers
> +                * still own it, one requeues it and the other frees it.
> +                */
> +               ret =3D __skb_pad(skb, pad_size, false);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       guard(mutex)(&rtwsdio->tx_credit_lock);
> +
> +       return rtw_sdio_8723bs_write_port(rtwdev, skb, queue, txaddr, txs=
ize,
> +                                         write_size);
> +}
> +

