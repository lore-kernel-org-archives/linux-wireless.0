Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502F37B3E4;
	Tue, 22 Sep 2026 01:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042216; cv=none; b=dFYIOblBnNJXmAeEKCphqArGA+UhR19EH9fZ50a4yfwhYmkzdjyNvhuRFEtofxJYIHCfnodqnmYvnIIMtKga6g+dGVzlR7VykEeVnumTHlBNzZsNdvjKlXherTIUkQeBU6ntJvDCD/FJTEFu5ldxXAI8+fYFJAECst1677tMX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042216; c=relaxed/simple;
	bh=kn524nTwWtHv4frMMhQoAuN5yXHfSz6LrMLZum4N2Mg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EJSXMMhIqpm2wyYqIzVR2GhLTY+qH01dvLzfX7KhOKZsaN4PDcZs6044iDNprXN4Dn2ikASsScAv4ZTFi37A+Peu/o/LYZvEYi73UWCe5tQmpU/KpCSx9LCv+N5c0uh2v+e5ZbdQETyebMtXfcoOX/dZmf6cSB7oGJ2p5kMEEaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=O3ObwUbZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="O3ObwUbZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68M1uiNnB3151417, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790042204; bh=slpvxirzB/ko/Gtk6V0IdFMvMDJNuL7xmnY9aTgYSRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=O3ObwUbZY++VZ8sDRSqKkGFUO3DSPCCQBKTp/tZPKwJQKLQEac+LvaqmiasjyfBoY
	 V8YEsgbyPp/1+EZTFYDLudIDYt3cTEHP7oy+2dl+ZJRv2odk0Dvn8AQHud1zdd3UmJ
	 XtTjzlu91M6x/j0zbCMB5f1t4MUz+Rhs0+0b51pD0sR6qm+B2qmf+MCnBWmacLd8AE
	 wYxxL1gD31gvABAnt3VaVz0brL91gATU818IdOLjX8AJcKE3kUsnoGHs1cr0frpujE
	 6PNGuLPLgngAAMGLCiMpXPdK6QnZf4iZWr65WgqvYzSqZQKIlYRknxVyMxelLgZqhj
	 inRMBl4jMA2Ew==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68M1uiNnB3151417
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Sep 2026 09:56:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 09:56:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 22 Sep 2026 09:56:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211
 asks for
Thread-Topic: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211
 asks for
Thread-Index: AQHdRq+EwW8OYhDOM0qePD8BQryiXrbZ2EHw
Date: Tue, 22 Sep 2026 01:56:44 +0000
Message-ID: <dc09d252a96c4992ad18e2ba70cfad31@realtek.com>
References: <20260917141906.1361197-1-mehmet.fide@gmail.com>
In-Reply-To: <20260917141906.1361197-1-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> The per-rate power index is the by-rate value capped by the regulatory
> limit and the SAR limit; the level mac80211 hands over in conf.power_leve=
l
> is never looked at, so "iw phy <phy> set txpower fixed <mBm>" is accepted
> and silently ignored. Devices that share a small enclosure with their
> client, or that must back off for coexistence, have no way to run below
> the regulatory maximum.
>=20
> Treat the requested level like the SAR limit: convert the dBm value to
> the by-rate offset domain with the chip's gain index granularity and use
> it as one more ceiling on the offset, then program the indices again
> whenever the level changes. The level is the total the device may
> radiate, so with two, three or four transmit paths each path gets 3, 5
> or 6 dB less, the way ath9k and the vendor driver share it. mac80211
> hands over the minimum of the regulatory maximum and the user's request,
> so a channel's maximum is respected as well; before the first
> configuration there is no request and nothing is capped, which keeps the
> behaviour of a driver that does not honour the level at all.
>=20
> Tested on RTL8822BU (2T) and RTL8821CU (1T) in AP mode: "fixed 1000"
> moves every rate that sat above 10 dBm down to the 10 dBm index, less
> the 3 dB path share on the 8822BU, while the rates already below stay,
> "auto" restores the tables and the client stays associated through the
> changes; a second radio saw the beacons drop by the requested amount.

How did you measure the TX power decreasing as your expectation?

And, curiously, what is the purpose you added this? which application?

>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c |  3 +++
>  drivers/net/wireless/realtek/rtw88/phy.c      | 26 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/phy.h      |  1 +

Miss to add pwr_param->pwr_user to rtw_debugfs_get_tx_pwr_tbl() to
show the correct final TX power and pwr_user factor.

>  3 files changed, 30 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 2a9b09fa76e7..e0462e934438 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -3,6 +3,7 @@
>   */
>=20
>  #include "main.h"
> +#include "phy.h"
>  #include "sec.h"
>  #include "tx.h"
>  #include "fw.h"
> @@ -94,6 +95,8 @@ static int rtw_ops_config(struct ieee80211_hw *hw, int =
radio_idx, u32 changed)
>=20
>         if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
>                 rtw_set_channel(rtwdev);
> +       else if (changed & IEEE80211_CONF_CHANGE_POWER)

Should it be 'if' instead of 'else if'?

> +               rtw_phy_set_tx_power_level(rtwdev, rtwdev->hal.current_ch=
annel);
>=20
>         if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
>             (hw->conf.flags & IEEE80211_CONF_IDLE) &&
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wirel=
ess/realtek/rtw88/phy.c
> index e2ac5c6fd500..0dfcd0739423 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.c
> +++ b/drivers/net/wireless/realtek/rtw88/phy.c
> @@ -2236,6 +2236,29 @@ static s8 rtw_phy_get_tx_power_sar(struct rtw_dev =
*rtwdev, u8 sar_band,
>         return (s8)rtwdev->chip->max_power_index;
>  }
>=20
> +static s8 rtw_phy_get_tx_power_user(struct rtw_dev *rtwdev, u8 band, u8 =
path,
> +                                   u8 rate)
> +{
> +       struct rtw_hal *hal =3D &rtwdev->hal;
> +       const struct rtw_chip_info *chip =3D rtwdev->chip;
> +       static const u8 path_share_dbm[] =3D { 0, 0, 3, 5, 6 };
> +       int power_level =3D rtwdev->hw->conf.power_level;
> +       u8 rs =3D rtw_phy_rate_to_rate_section(rate);
> +       u8 paths =3D clamp_t(u8, hweight8(hal->antenna_tx), 1, 4);

In reverse X'mas tree order.

> +       s32 idx;
> +       s8 base;
> +
> +       if (power_level <=3D 0 || rs =3D=3D RTW_RATE_SECTION_NUM)
> +               return (s8)chip->max_power_index;
> +
> +       idx =3D (power_level - path_share_dbm[paths]) << chip->txgi_facto=
r;
> +       base =3D band =3D=3D PHY_BAND_2G ? hal->tx_pwr_by_rate_base_2g[pa=
th][rs] :
> +                                    hal->tx_pwr_by_rate_base_5g[path][rs=
];
> +
> +       return (s8)clamp_t(s32, idx, -chip->max_power_index - 1,
> +                          chip->max_power_index) - base;

Should it clamp after 'idx - base' ?

> +}
> +
>  void rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path, u8 rate, u=
8 bw,
>                              u8 ch, u8 regd, struct rtw_power_params *pwr=
_param)
>  {



