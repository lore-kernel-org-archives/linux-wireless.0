Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2391BD9D0
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 06:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791356173; cv=none; b=nRvu86708ZfMVY/5EMu9YmK12hCePEUbfX95tml6dXmoXV77q4yn+j6A0orvv7vs2C3/KoEyj8Km6RuJqYGmLgzJi5VGf6t/VoQW1H2G4+ZGwPxJXR1sFLPnGVlhhqBCtRYrtBn+s0nSkvscVaayGE6Lo+Kkl3d1mkegOPKMxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791356173; c=relaxed/simple;
	bh=mPOvJG+Ziey8rOnXrm2JZksycs/MgRXkSM6LzT8+SRs=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=go7WAmNT2GgXjVPUuaQgT05DpzoRVwZQjfr6qlKB+V5aWd8tV4lFu9eH0M98O+5O7XGqka6DFDYZPPEGoDq48XxQDtXNBEKiMVL7sVB0e2oIUwbkqYxux7nFD0XButo3QZiUIFAdSbAhVNBAdDo9TtRWbrvTy+WJOzn6ureG68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YOxlz2a2; arc=none smtp.client-ip=91.218.175.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YOxlz2a2"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mPOvJG+Ziey8rOnXrm2JZksycs/MgRXkSM6LzT8+SRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791356169; v=1; x=1791960969;
 b=YOxlz2a2uoYMhdI3RtGnKKJ89/Fux+7PfyVqTcLXyv91SAhC2XFCsF1zJESUJRBqrpF5Aw1i
 G2bw7hcIXmaa4ov7/yzh3cHfDW0WFkOCC3B68p86nuA75vtbTh0Zgcgj3cMWfvnJxfoJtKbbbPb
 tD2jfVlqrXizqp1oD6igQXvE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 81c8206f9f617cbb;
	Wed, 07 Oct 2026 05:21:24 +0000
X-Mizu-Trace-ID: 81c8206f9f617cbb
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 05:21:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <9f5d3b374ac9793b745e96121fcfc875083dc873@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v4 2/4] wifi: rtw88: sdio: Track running state
 and cancel TX worker on stop
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Alastair D'Silva"
 <alastair@d-silva.org>, linux-wireless@vger.kernel.org, "Kalle Valo"
 <kvalo@kernel.org>
Cc: "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Jernej
 Skrabec" <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 luka.gejak@linux.dev
In-Reply-To: <1b8a86e84c474693bfa71f39e946e7e6@realtek.com>
References: <20261005084849.3109337-1-alastair@d-silva.org>
 <20261005084849.3109337-3-alastair@d-silva.org>
 <6665409e1d374c1face4936b827a6a9d@realtek.com>
 <ccc69689fe2a2cccc39d40221056722e24263f2f@linux.dev>
 <1b8a86e84c474693bfa71f39e946e7e6@realtek.com>

October 7, 2026 at 03:26, "Ping-Ke Shih" <pkshih@realtek.com mailto:pkshi=
=3D
h@realtek.com?to=3D3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > =
wr=3D
ote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> > @@ -1703,6 +1712,9 @@ static void rtw_sdio_tx_handler(struct work=
=3D
_struct *work)
> >  > rtwdev =3D3D work_data->rtwdev;
> >  > rtwsdio =3D3D (struct rtw_sdio *)rtwdev->priv;
> >  >
> >  > + if (!rtwsdio->running)
> >  > + return;
> >  > +
> >  >
> >  I don't think we need this, since you added cancel_delayed_work_sync=
=3D
() in
> >  rtw_sdio_stop().
> >=20
>=20>  I think we should keep the check. The tx work arms the SDIO work a=
=3D
t the end,
> >  and stop does not cancel it:
> >=20
>=20>  rtw_hci_tx_kick_off(rtwdev);
> >=20
>=20>  cancel_work_sync(&rtwdev->c2h_work);
> >  cancel_work_sync(&rtwdev->update_beacon_work);
> >  cancel_delayed_work_sync(&rtwdev->watch_dog_work);
> >  cancel_delayed_work_sync(&coex->bt_relink_work);
> >  cancel_delayed_work_sync(&coex->bt_reenable_work);
> >  cancel_delayed_work_sync(&coex->defreeze_work);
> >  cancel_delayed_work_sync(&coex->wl_remain_work);
> >  cancel_delayed_work_sync(&coex->bt_remain_work);
> >  cancel_delayed_work_sync(&coex->wl_connecting_work);
> >  cancel_delayed_work_sync(&coex->bt_multi_link_remain_work);
> >  cancel_delayed_work_sync(&coex->wl_ccklock_work);
> >=20
>=20In rtw_sdio_stop(), it does cancel_delayed_work_sync(&rtwsdio->tx_han=
=3D
dler_data->work);
> Is it not enough?
>=20

That=20is enough for a work item that is already armed. It does not cover=
=3D
 an
arm that lands after the call, and that can happen:

[...]
>  1. rtwsdio->running =3D3D false;
>  // prevent to schedule rtwsdio->tx_handler_data->work again

Nothing reads rtwsdio->running on the arming path. wake_tx_queue() tests
the flag at the top and queues the work at the bottom:

	if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
		return;

	if (txq->ac =3D3D=3D3D IEEE80211_AC_VO)
		__rtw_tx_work(rtwdev);
	else
		queue_work(rtwdev->tx_wq, &rtwdev->tx_work);

then __rtw_tx_work() kicks the SDIO work at the end:

	rtw_hci_tx_kick_off(rtwdev);

The sequence:

1. wake_tx_queue() reads the flag while it is still set and queues
   rtwdev->tx_work.
2. rtw_core_stop() clears the flag and cancels its list of works.
3. rtw_sdio_stop() sets running to false and disables the interrupts. The
   cancel_delayed_work_sync() finds nothing armed and returns at once.
4. rtw_tx_work() runs now, nothing cancelled it, and it ends in
   rtw_sdio_tx_kick_off(), which arms the delayed work again with
   mod_delayed_work().
5. rtw_sdio_tx_handler() runs, and without the check it calls
   rtw_sdio_deep_ps_leave() and then walks the queues on a MAC that is
   being powered off.

So the cancel only orders against a kick that came before it, and the
check covers the other order.

Best regards,
Luka Gejak
