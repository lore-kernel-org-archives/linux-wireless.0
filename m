Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21033B27FF;
	Wed, 19 Aug 2026 01:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102065; cv=none; b=sNlsmGfiyKmSziqVxS4wwIIrCuas5PdPalsOQ5mCRi2hIMU5qPBOySjTRIew7zl6++8X/g0X1H1FrZa8cccopZ7P3Vsd66m2xCUCoYeTHeLSX6mvJyxsGF5+72IwtyxzUPZxb1gXcpGGrO1IXfriPYRpfxmZNkRuTzeXZQSOjPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102065; c=relaxed/simple;
	bh=5hwrGOpmXabryIi9CyOkTtB2+XbZlDIGTZE/fGhVBZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N1JSwNKe0XEMov6+rg54Y7RzZJDYUoa2/iofo65Is4SNYTUkMjsTRVmufGzWTZqjfrvh16Md5PcvpuJsNpAFIqLut9LS4OjexvAxm1FmfQf5RKFIr/kTzFqBP8PZmtts+z8TMzsD+DpWOhHEQ4KhUMaSGzHL2P27nePtI+pj3uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jnsgde7G; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jnsgde7G"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J1ECtrC1951784, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787102052; bh=XPeXvEJFVLQYQUVqv00G0RDCzdX5maTJk9BSlwy3W6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=jnsgde7GuX9r0S3aOa9cAcIjuNjb9swk8AmAdxvyInxfSnJr+K4rksCt5kkq66H44
	 pGHQmHpvYI8TA285RHs6rXmPo6pUYgsfQPwU70yioj1w2akkZvgALqerXLGLnpIeL/
	 bNctTcUvuTu7hNQ8MFY+OCT9Nob9oLBMhbjLkABMp9tK0WrCZRPuOU6XIPTGRjklfD
	 dT1hUtggZuqRTpm1tmMmYaMZTW/f3z7GV/FMC7UL0io9A8mOZVEO7UZnQ09bgfofjW
	 nZP4u+tb8TRe/Uhe/07Ruv7UuBxCxHeJHX9ynrVAr240F/1AL3vGWWyMMvSbFGU7ud
	 PaHwZWIcdBSkg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J1ECtrC1951784
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 09:14:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 09:14:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 09:14:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdK9tF/dBhEaQ+I0uj6E6RhFUyKbaklmjw
Date: Wed, 19 Aug 2026 01:14:11 +0000
Message-ID: <257b9af907e84e439ae6a9fd55bf3f09@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <20260814105327.6687-7-luka.gejak@linux.dev>
In-Reply-To: <20260814105327.6687-7-luka.gejak@linux.dev>
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
> +
> +static void rtw_sdio_reschedule_tx_work(struct rtw_dev *rtwdev,
> +                                       struct rtw_sdio_work_data *work_d=
ata,
> +                                       unsigned long delay)
> +{
> +       struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
> +
> +       queue_delayed_work(rtwsdio->txwq, &work_data->work, delay);
>  }

Actually, I didn't request this wrapper by v4. (Also I don't prefer a
simple wrapper like this that hides kernel API).

(See below)

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
> +                       if (ret > 0)
> +                               break;
> +
> +                       if (ret < 0) {
> +                               /*
> +                                * A page or output queue shortage and a =
failed
> +                                * skb expansion are both transient, and =
the
> +                                * frame is still queued, so come back fo=
r it.
> +                                * That matters once the queue can be sto=
pped:
> +                                * a stopped queue is handed no further f=
rames,
> +                                * so nothing else would kick this work i=
tem and
> +                                * the queue would stay stopped for good.=
 The
> +                                * remaining errors cannot succeed on a r=
etry
> +                                * and each log where they happen.
> +                                */
> +                               if (rtl8723bs &&
> +                                   (ret =3D=3D -EBUSY || ret =3D=3D -ENO=
MEM)) {
> +                                       rtw_sdio_reschedule_tx_work(rtwde=
v, work_data,
> +                                                                   RTW_S=
DIO_TX_RETRY_DELAY);
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
> +                               rtw_sdio_reschedule_tx_work(rtwdev, work_=
data, 0);
> +                               return;
> +                       }

I'd move this chunk you are adding to a function. I think it is just to
reschedule TX work for RTL8723BS for certain conditions, but explaining=20
a lot of things (conditions) in common flow makes people hard to read
the flow.=20

>=20
>                         if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
>                                 break;



