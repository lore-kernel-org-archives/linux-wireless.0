Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96E3B2FE9;
	Sun,  6 Sep 2026 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788661371; cv=none; b=SXtPWAzfat2ntFER+xBlfSdcI0joeV+FU2cYad+6YWIRqyJha8fi1sYhGLYmVohYNMrQ8ds/eymtjZs25qnMlHlnxkj3KTmqE/Hhdt5Z4YF0pMuz9PCsBomKmokZ3EmNHwzncW1F/EXYmInhi9taDYvGIKNAoWSlhMA+QjI7I/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788661371; c=relaxed/simple;
	bh=q7OnOI531hnFUN325dgZAIm3qIPZs3GBQAzC93nLN2o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8Eh3cx8S/fH6nJxASeTLr15b9QMlxq2eNcRqqxxmhxjgre3dgRYLCB45UmHpeL1Bdo4/Z9SzAnzP2UIAF9De5OfJEL4e0/NwWHflM0zxfDYUdcf+kEMYa/Ob9y6CrcueZx8p6DFSfNw7N92pDvLbMxl23mYbAj2qkVisUkLS9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MjfWl9t5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MjfWl9t5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6862Mfy261577868, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788661361; bh=qxA1SUIIGkwQOzjsQpSVuAs8T9ZHqUxPh1gwWXAn+G4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MjfWl9t5jyMZN7yLwcWhaDx7cLF5CL1mN0mX5neK1iXv926JUHCzBNeBkY9vsSauQ
	 tnndwrdX8hyJGv7WoV9Psx0/R2jI+OsHLtAhIs9vI2RwmPq4rmKxHxQDOrzMf4vHir
	 wLkD/mQDddNQLnJcbHikfeHJUiQK0oFSh39PD69U0YJgc8lGH2evEVFqzGY8fgsW0G
	 OZlj3l4kSnUdTuk2KNOXIfGeLptPwRd03dMcGtUQwdTvNze0agdCTQanEzar7xY+8e
	 K1ZgLzB/HCaQxodhLg1Ohe4fx/8Xe+LwoflLpJEZkw5Zky/igg8LRWuhiQH3smRdDn
	 tXvHmKL7EQhDA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6862Mfy261577868
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 10:22:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 10:22:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 10:22:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 10:22:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v9 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v9 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdOQ+tujcloACDt0ancBmQ7iNVjbbA0nqA
Date: Sun, 6 Sep 2026 02:22:40 +0000
Message-ID: <d4a8b1203ee0402483269a31ad4d6dd2@realtek.com>
References: <20260831061144.18631-1-luka.gejak@linux.dev>
 <20260831061144.18631-5-luka.gejak@linux.dev>
In-Reply-To: <20260831061144.18631-5-luka.gejak@linux.dev>
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

>=20
> Transfers also have to be padded up to the SDIO block size for this
> chip rather than using the generic alignment, so size the write
> separately from the frame and zero the padding with __skb_pad(), which
> also reallocates a cloned skb instead of writing into a buffer a clone
> still shares.

If the __skb_padd() is necessary for original (generic) part, please
add another patch to fix it. (see below comment)

[...]

> +/*
> + * The free page check, the output queue wait and the accounting after t=
he
> + * transfer have to be one unit, or two writers can both pass the checks=
 and
> + * claim the same pages and output queue entry.
> + */

In this patchset, you add many comments. Please review them across whole
patchset to see if they actually need. Like this one, do you think the code
can't explain itself?

> +static int rtw_sdio_write_port_8723bs(struct rtw_dev *rtwdev,
> +                                     struct sk_buff *skb,
> +                                     enum rtw_tx_queue_type queue)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +       unsigned int pages;
> +       size_t write_size;
> +       size_t txsize;
> +       u32 txaddr;
> +       int ret;
> +
> +       txaddr =3D rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
> +       if (!txaddr)
> +               return -EINVAL;
> +
> +       txsize =3D round_up(skb->len, 4);
> +       write_size =3D txsize > RTW_SDIO_BLOCK_SIZE ?
> +                    round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsize;

As we have sdio_set_block_size(sdio_func, RTW_SDIO_BLOCK_SIZE),
can here use sdio_align_size() to get the writ_size?

> +
> +       if (write_size > skb->len) {
> +               size_t pad_size =3D write_size - skb->len;

I think write_size must be large or equal to skb->len, right?
Therefore, declare size_t pad_size at top of function, and then

    write_size =3D ...
    pad_size =3D write_size - skb->len;

    if (pad_size > 0) {
         ...
         __skb_pad( ... pad_size ...);
    }

I think this is easier to read.

> +
> +               /*
> +                * __skb_pad() must not free the skb on failure: both cal=
lers
> +                * still own it, one requeues it and the other frees it.
> +                */
> +               ret =3D __skb_pad(skb, pad_size, false);

Why doesn't rtw_sdio_write_port_generic() need __skb_pad() as well?
Is there an existing problem by original?

> +               if (ret)
> +                       return ret;
> +       }
> +
> +       guard(mutex)(&rtwsdio->tx_credit_lock);
> +
> +       ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D rtw_sdio_8723bs_wait_tx_oqt(rtwdev);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D rtw_sdio_write_to_port(rtwdev, skb, queue, txaddr, write_=
size);
> +       if (ret) {
> +               /* nothing was queued, so hand the output queue entry bac=
k */
> +               atomic_inc(&rtwsdio->tx_oqt_free);
> +               return ret;
> +       }
> +
> +       pages =3D DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
> +       rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
> +
> +       return 0;
> +}
> +


