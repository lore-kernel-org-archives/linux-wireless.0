Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2439CD14
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724128; cv=none; b=mCcvdEMoo4E9y8CmYkwqjPyJDA1KM6n1bckP+exTEIoZ2Vaz9tMs1qMVy1PSUhsPqz5beVzqaEEVq41iK73b6pa4xE/CYGSBP7K7vRMWNuj8p7yT6dDA7u15Dbgbh6gamYuhRiO2zgP462+IERdzs4MjEFNembrqDN4MeKB0hdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724128; c=relaxed/simple;
	bh=Ytmx7QEPBPOZdpc/QHFzpNSV1GdU5pRz8PGES8bQl2s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=R5MzT/SQOpLrB7ENjTC43C6oFJYdxFqINZS2nzk6THU3b/4Ba/Jo1/TwihbOHanAUOHDJAaOSZBNK0SOx+ITpQuYR5UB/QaWzX+rv3ez2NScQCOc0wEJDaIWrU+WgfRIUXx+zNph2orwdKwiTevXWPoxi0UVFzQDQp1T3GIbR1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcbtZPOZ; arc=none smtp.client-ip=91.218.175.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcbtZPOZ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ytmx7QEPBPOZdpc/QHFzpNSV1GdU5pRz8PGES8bQl2s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791724123; v=1; x=1792328923;
 b=bcbtZPOZm2nNYXTOWYn619noY5xVzvsTtII05VtX3Eybnqh9986XDFhcvL/aZB495Hi7w+rV
 PBrUzLtWI0/swL+US6esQgHCCB320OUEIDfD6mFVpD2TqRPZtwIkM2FFrq6rVKGbnk1Lx2P96Bp
 1Z3PtS9Mh6iluiTUeoeuIrGM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 844091e216f5c9f5;
	Sun, 11 Oct 2026 13:08:43 +0000
X-Mizu-Trace-ID: 844091e216f5c9f5
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Oct 2026 13:08:39 +0000
Message-Id: <DM216XAEDYAN.IZDPPZ4YWPLG@linux.dev>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Kalle
 Valo" <kvalo@kernel.org>, "Brian Norris" <briannorris@chromium.org>
Subject: Re: [PATCH wireless 2/2] wifi: rtw88: restore the control frame
 filter when the device is started
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Jeremy Fareau" <jeremy.fareau@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
X-Mailer: aerc 0.22.0
References: <20261007091225.413-1-jeremy.fareau@gmail.com>
 <20261007091225.413-3-jeremy.fareau@gmail.com>
In-Reply-To: <20261007091225.413-3-jeremy.fareau@gmail.com>

On Wed Oct 7, 2026 at 9:12 AM UTC, Jeremy Fareau wrote:
> Commit ed51a86b787f ("wifi: rtw88: Enable receiving control frames in
> monitor mode") writes REG_RXFLTMAP1 from configure_filter(), but that
> register is reset to the chip default by the chip's mac_init() during
> power_on().  mac80211 only calls ieee80211_ops::configure_filter() when
> its own filter flags change, so after a stop/start cycle the flags are
> unchanged and the control frame filter silently reverts: monitor mode
> stops delivering control frames again.
>=20
> Keep track of the value configure_filter() last asked for and restore
> it in rtw_core_start(), next to the RCR restore, which exists for the
> same reason.
>=20
> Measured on an RTL8814AU and an RTL8812AU in monitor mode on channel 6,
> 40 s captures taken after a down/up cycle.  Control frames go from 0 to
> 23184 and from 0 to 483 respectively; without this change both are 0.
>=20
> Fixes: ed51a86b787f ("wifi: rtw88: Enable receiving control frames in mon=
itor mode")

Please add Cc: stable@vger.kernel.org

> Assisted-by: LLM
> Signed-off-by: Jeremy Fareau <jeremy.fareau@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 5 +++--
>  drivers/net/wireless/realtek/rtw88/main.c     | 8 ++++++++
>  drivers/net/wireless/realtek/rtw88/main.h     | 1 +
>  3 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/=
wireless/realtek/rtw88/mac80211.c
> index 827f38390969..84d869f1efe0 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -300,9 +300,10 @@ static void rtw_ops_configure_filter(struct ieee8021=
1_hw *hw,
> =20
>  	if (changed_flags & FIF_CONTROL) {
>  		if (*new_flags & FIF_CONTROL)
> -			rtw_write16(rtwdev, REG_RXFLTMAP1, 0xffff);
> +			rtwdev->hal.rxfltmap1_cur =3D 0xffff;
>  		else
> -			rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rxfltmap1);
> +			rtwdev->hal.rxfltmap1_cur =3D rtwdev->hal.rxfltmap1;
> +		rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rxfltmap1_cur);
>  	}
>  	if (changed_flags & FIF_ALLMULTI) {

I would change the new rxfltmap1_cur because hal->rxfltmap1 is not a consta=
nt.
The beamforming code edits it and writes the register with the
edited value:

          bf.c:140        rtwdev->hal.rxfltmap1 &=3D ~BIT_RXFLTMAP1_BF_REPO=
RT_POLL;
          bf.c:141        rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rx=
fltmap1);
          bf.c:273        rtwdev->hal.rxfltmap1 |=3D BIT_RXFLTMAP1_BF;
          bf.c:274        rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rx=
fltmap1);

So after this patch the driver keeps two cached copies of one register. On =
an
8822C in monitor mode, configure_filter() caches 0xffff while bf.c has clea=
red
the report poll bit in hal->rxfltmap1, so the next stop/start restores 0xff=
ff
and undoes that. The reverse happens too: a request with FIF_CONTROL off
caches hal->rxfltmap1 as it stands at that moment, and later bf.c edits are
lost at the next restart.

I would keep one variable and add one flag instead of a second shadow value=
.
It would remember whether control frames were requested, and then on restor=
e
it would rebuild the register from that flag and hal->rxfltmap1.

> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wire=
less/realtek/rtw88/main.c
> index cd9254370fcc..ea61020a0622 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1528,6 +1528,14 @@ int rtw_core_start(struct rtw_dev *rtwdev)
>  	/* rcr reset after powered on */
>  	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
> =20
> +	/* REG_RXFLTMAP1 is reset by the chip's mac_init() during power_on(),
> +	 * and mac80211 only calls ieee80211_ops::configure_filter() when its
> +	 * own filter flags change.  After a stop/start cycle the flags are
> +	 * unchanged, so restore the value configure_filter() last asked for.
> +	 */

Comment style, same as in patch 1.

> +	if (rtwdev->hal.rxfltmap1_cur)
> +		rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rxfltmap1_cur);
> +

A nit: this line doubles as "configure_filter has run". It only works becau=
se
no chip has a zero default (0x400, 0x0FFF, 0xFFFF), so an explicit flag wou=
ld
not depend on that.

Best regards,
Luka Gejak
