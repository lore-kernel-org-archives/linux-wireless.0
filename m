Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648835975;
	Mon,  5 Oct 2026 03:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791169934; cv=none; b=IlXQJm3JOiWHZ9NWFF7H4rTfqn1uq6X9Ir4JxaGF/0gZq4TEgVpqN2Iokf9YthMbqBOsQT+Ggeq3Pm5QH4wUDFzMbtFKUPaQQOMtO01lX2qCbB5E5rNm7dTXfZz6QEwZhK75lz9XFZGxb3FMsSCp+hJiWcW96qUPcJtHM8kkE7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791169934; c=relaxed/simple;
	bh=PcHUeufBxlek5ogqz3nQgdAdG40DUA9yb0bCkkjQ6QQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CThfWXMWTmFYNTRfran1BLYtLdRXPpEWo4JWpLz6kre1F51icOpx0HJRtwROWc1/P63/NE5o+6c9V+uoxfGwBb0eXAfIKUdFPoObbgZ6chn/5yBCnVEK6ohfcI41/huT1oQ4N/71UAC+yXmtu78Md5O0YK3EWgwdRqmDp+umCOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RG6m4rln; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RG6m4rln"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6953BnZZ21604451, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791169910; bh=bh5yvq68X/KKmWoa52t/wNsQQ71FQ7suOQaBkKtY/Yc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RG6m4rlnaF/5KZ1Z8dVgTPaPDQWkxHALmbdeTXSjCZjLQo9UiJSJSPUPEhTHWGn1J
	 1FWVJawWDhWxO+s9t7IdsuBH/nNopnH8oP0ZyD+3ryqwWXmYe3Gx79Gc3DVuRalFCp
	 JDWEluxiIOrpnoyWB5TR61Fd6McuftE7f4dN5LW7v/wweRaxrSv9mWiEoBqmPQoywC
	 kDVIxatXOKCo3pVEfTNVfYNxHS67N+qoGyBl8Up1j35b5P40kaAnHwHElg+96eRRB7
	 Zxt+3Tv3IZpgl5sBNSjfKqRek86xOUKUiGCOj3TRJ6fZjNRRLNCL6WKtgDMR/dHDiC
	 2c6huxtwdiscQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6953BnZZ21604451
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 11:11:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:11:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 11:11:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v2 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdUK+Uwza6GnHkZUe/N3QzQMgqr7buRteQ
Date: Mon, 5 Oct 2026 03:11:49 +0000
Message-ID: <135e11c2a24642d0af774d6fd3c7f5a2@realtek.com>
References: <20260930074444.1991223-1-mehmet.fide@gmail.com>
 <20260930074444.1991223-3-mehmet.fide@gmail.com>
In-Reply-To: <20260930074444.1991223-3-mehmet.fide@gmail.com>
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
> hostapd's CHAN_SWITCH is refused because the driver does not announce
> channel switch support, so an AP on rtw88 can only change its channel
> by being torn down and started again.
>=20
> Declare WIPHY_FLAG_HAS_CHANNEL_SWITCH and implement
> ieee80211_ops::channel_switch_beacon: the firmware repeats the beacon
> held in the first reserved page, so while a switch is announced the
> page is downloaded again every beacon interval to renew the countdown,
> and ieee80211_csa_finish() is called once it completes. IBSS, which
> the flag enables too, shares the page and the work.
>=20
> The work is a wiphy delayed work of the device, like
> update_beacon_work:=20

rtw88 doesn't switch to wiphy work yet. Mixing to use ieee80211 and wiphy
works with driver mutext still is harmless I think.

> rtw88 runs one beaconing interface, a hw restart
> replays add_interface without remove_interface, and the wiphy lock
> serializes it with the mac80211 state it reads. It is cancelled when
> the AP stops, when the vif goes away and on WoWLAN suspend, and a
> hardware scan is refused while a switch is announced, since it would
> take the AP off the channel its stations count down to.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c       | 41 +++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/fw.h       |  1 +
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 46 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/main.c     |  4 +-
>  drivers/net/wireless/realtek/rtw88/main.h     |  1 +
>  5 files changed, 92 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wirele=
ss/realtek/rtw88/fw.c
> index 49f09a9f4ed6..1ad25e0539c4 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1813,6 +1813,47 @@ void rtw_fw_update_beacon_work(struct work_struct =
*work)
>         mutex_unlock(&rtwdev->mutex);
>  }
>=20
> +/* renew the countdown in the firmware's beacon page until it completes =
*/

I think this is unnecessary.=20

> +void rtw_fw_csa_beacon_work(struct wiphy *wiphy, struct wiphy_work *work=
)
> +{
> +       struct rtw_dev *rtwdev =3D container_of(work, struct rtw_dev,
> +                                             csa_beacon_work.work);
> +       struct rtw_rsvd_page *rsvd_pkt;
> +       struct ieee80211_vif *vif;
> +       unsigned int delay;
> +
> +       lockdep_assert_wiphy(wiphy);
> +
> +       mutex_lock(&rtwdev->mutex);
> +
> +       if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
> +               goto out;
> +
> +       rsvd_pkt =3D list_first_entry_or_null(&rtwdev->rsvd_page_list,
> +                                           struct rtw_rsvd_page, build_l=
ist);
> +       if (!rsvd_pkt || rsvd_pkt->type !=3D RSVD_BEACON)
> +               goto out;
> +
> +       vif =3D rtwvif_to_vif(rsvd_pkt->rtwvif);

Should we define csa_beacon_work by vif? Then, here we can get rtwvif
(and vif) from work context.

> +       if (!vif->bss_conf.csa_active)
> +               goto out;
> +
> +       delay =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +
> +       if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
> +               rtw_fw_download_rsvd_page(rtwdev);
> +               rtw_send_rsvd_page_h2c(rtwdev);
> +
> +               wiphy_delayed_work_queue(wiphy, &rtwdev->csa_beacon_work,
> +                                        usecs_to_jiffies(delay));
> +       } else {
> +               ieee80211_csa_finish(vif, 0);
> +       }
> +
> +out:
> +       mutex_unlock(&rtwdev->mutex);
> +}
> +
>  static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u3=
2 size,
>                                   u32 *buf, u32 residue, u16 start_pg)
>  {

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 2a9b09fa76e7..7c2a373faff8 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -235,6 +235,10 @@ static void rtw_ops_remove_interface(struct ieee8021=
1_hw *hw,
>         rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM mac_id %d on port %d=
\n",
>                 vif->addr, rtwvif->mac_id, rtwvif->port);
>=20
> +       if (rtwvif->net_type =3D=3D RTW_NET_AP_MODE ||
> +           rtwvif->net_type =3D=3D RTW_NET_AD_HOC)
> +               wiphy_delayed_work_cancel(hw->wiphy, &rtwdev->csa_beacon_=
work);
> +

Why should we need check Ad-hoc? How about just removing conditions?

As above comment, I'd move csa_beacon_work to vif.

>         mutex_lock(&rtwdev->mutex);
>=20
>         rtw_leave_lps_deep(rtwdev);
> @@ -375,6 +379,13 @@ static void rtw_conf_tx(struct rtw_dev *rtwdev,
>                 __rtw_conf_tx(rtwdev, rtwvif, ac);
>  }
>=20
> +/* renew the channel switch countdown one beacon interval from now */

No need this comment.

> +static void rtw_csa_beacon_queue(struct rtw_dev *rtwdev, u16 beacon_int)
> +{
> +       wiphy_delayed_work_queue(rtwdev->hw->wiphy, &rtwdev->csa_beacon_w=
ork,
> +                                usecs_to_jiffies(ieee80211_tu_to_usec(be=
acon_int)));

Just single one statement. Can't we just call wiphy_delayed_work_queue()
directly?

> +}
> +
>  static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
>                                      struct ieee80211_vif *vif,
>                                      struct ieee80211_bss_conf *conf,
> @@ -438,6 +449,9 @@ static void rtw_ops_bss_info_changed(struct ieee80211=
_hw *hw,
>                 rtw_set_dtim_period(rtwdev, conf->dtim_period);
>                 rtw_fw_download_rsvd_page(rtwdev);
>                 rtw_send_rsvd_page_h2c(rtwdev);
> +               /* a hw restart replays the beacon, not channel_switch_be=
acon */

unnecessary comment.=20

> +               if (conf->csa_active)
> +                       rtw_csa_beacon_queue(rtwdev, conf->beacon_int);
>         }
>=20
>         if (changed & BSS_CHANGED_BEACON_ENABLED) {
> @@ -489,6 +503,8 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
>  {
>         struct rtw_dev *rtwdev =3D hw->priv;
>=20
> +       wiphy_delayed_work_cancel(hw->wiphy, &rtwdev->csa_beacon_work);
> +
>         mutex_lock(&rtwdev->mutex);
>         rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
>         rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
> @@ -556,6 +572,16 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, =
struct ieee80211_sta *sta,
>         return 0;
>  }
>=20
> +static void rtw_ops_channel_switch_beacon(struct ieee80211_hw *hw,
> +                                         struct ieee80211_vif *vif,
> +                                         struct cfg80211_chan_def *chand=
ef)
> +{
> +       struct rtw_dev *rtwdev =3D hw->priv;
> +
> +       /* the beacon that starts the countdown was just downloaded */

unnecessary comment.=20

> +       rtw_csa_beacon_queue(rtwdev, vif->bss_conf.beacon_int);
> +}
> +
>  static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd=
,
>                            struct ieee80211_vif *vif, struct ieee80211_st=
a *sta,
>                            struct ieee80211_key_conf *key)

[...]

> @@ -900,6 +937,14 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, =
struct ieee80211_vif *vif,
>                 return -EBUSY;
>=20
>         mutex_lock(&rtwdev->mutex);
> +
> +       /* the stations count down to the new channel and expect the AP t=
here */
> +       rtw_iterate_vifs(rtwdev, rtw_csa_active_iter, &csa_active);
> +       if (csa_active) {
> +               mutex_unlock(&rtwdev->mutex);
> +               return -EBUSY;
> +       }

Forgot to mention this by commit message?

> +
>         rtw_hw_scan_start(rtwdev, vif, req);
>         ret =3D rtw_hw_scan_offload(rtwdev, vif, true);
>         if (ret) {


