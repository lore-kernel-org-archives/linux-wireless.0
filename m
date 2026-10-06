Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492A195B1A;
	Tue,  6 Oct 2026 01:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791249986; cv=none; b=f25SvTbi65gFmNL7AwEnjpq8IIRdZd/eseskqTaJsD5E7IJw+bVlDoO+7EtD8zLbjYfAU66PbpWWbbEpnvdyyLSmQ6p/xgHJVthkEiGYTtm6eBXP0Ddx7kffaBPMTZMDhiVaAV0+HFOBpSUwLongeV2JUCJGMUa01PDcATAwHOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791249986; c=relaxed/simple;
	bh=ehhVOIPSodQG9/F+IIPADjNCLJHSXKRIOot2TqDmLPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gmZSOFQL5y7CJNias6TJAk2srK4Mq7tEM0qiJRzMbfGVd21OTG7donhuhc0oAzZZtiQgkbv4aPRF80VbTf3OgL5czz0uGVJoamEb8QOtMOhFlvFgqv2DnAG0hPp5jNNK06b+IsrcCdMOrjX6gF4lwdiSdvTnd3U7qZQoa+AO0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HJLpFuTa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HJLpFuTa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6961Q5Tu82443276, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791249965; bh=r7wtAToNeVDGpigk+RYLAwD6PlpfgpJFjuHM4zWkZCA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HJLpFuTaQIeUfYKV+fO4diEom46VFCsng41A4TfifHw82rupWxHdQr6qOVcbxv73f
	 6RIMkTCYFi2FKGIXJrtkkHIRQgMxQ/D7eK7VQg8L0gMidBoLJGybcaR8QdH7YWKndn
	 ojss1B+oGljiPUjKC9CMLQ18KlRe8q+cBdC1zWgJwOSeoNJaXXJRsVrjPVq7uuVDPk
	 DEAAdhulo0f8mBzc1VUJXFu5r3REQkpd2ZJeeyKZtHm6RUb/pnMq1q+tBStSo1p6r1
	 UF/03Dj9rG4e7Jx5tg+cKXtX8RK1xAeb9GWP18oQ7f/Vl0e2uJURwmb4GaKDOOtWbR
	 10ufCxcbC15vA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6961Q5Tu82443276
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 09:26:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 09:26:06 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 09:26:06 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdVNbGRyo/aSSZhk+/tharL8dRjLbvr7cw
Date: Tue, 6 Oct 2026 01:26:05 +0000
Message-ID: <151d3d60da614e00b3a94bebd4f4f3a8@realtek.com>
References: <20261005143523.130287-1-mehmet.fide@gmail.com>
 <20261005143523.130287-3-mehmet.fide@gmail.com>
In-Reply-To: <20261005143523.130287-3-mehmet.fide@gmail.com>
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
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wirele=
ss/realtek/rtw88/fw.c
> index 3cd17a3bb494..5e68ba73548a 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1802,14 +1802,73 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtw=
dev)
>         return ret;
>  }
>=20
> +static struct ieee80211_vif *rtw_fw_beacon_vif(struct rtw_dev *rtwdev)

There is single one caller, so just squash into rtw_fw_csa_active().

I asked to move CS work to vif, because I want to avoid this kind of
getting vif from rsvd_pkt->rtwvif. Is there any way to avoid this?

> +{
> +       struct rtw_rsvd_page *rsvd_pkt;
> +
> +       rsvd_pkt =3D list_first_entry_or_null(&rtwdev->rsvd_page_list,
> +                                           struct rtw_rsvd_page, build_l=
ist);
> +       if (!rsvd_pkt || rsvd_pkt->type !=3D RSVD_BEACON)
> +               return NULL;
> +
> +       return rtwvif_to_vif(rsvd_pkt->rtwvif);
> +}
> +
> +bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
> +{
> +       struct ieee80211_vif *vif =3D rtw_fw_beacon_vif(rtwdev);
> +
> +       return vif && vif->bss_conf.csa_active;
> +}
> +
>  void rtw_fw_update_beacon_work(struct work_struct *work)
>  {
>         struct rtw_dev *rtwdev =3D container_of(work, struct rtw_dev,
>                                               update_beacon_work);
>=20
>         mutex_lock(&rtwdev->mutex);
> +
> +       if (rtw_fw_csa_active(rtwdev))
> +               goto out;
> +
>         rtw_fw_download_rsvd_page(rtwdev);
>         rtw_send_rsvd_page_h2c(rtwdev);
> +
> +out:
> +       mutex_unlock(&rtwdev->mutex);
> +}
> +

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wirele=
ss/realtek/rtw88/fw.h
> index 48ad9ceab6ea..a0a1dcbf93de 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.h
> +++ b/drivers/net/wireless/realtek/rtw88/fw.h
> @@ -863,7 +863,9 @@ void rtw_add_rsvd_page_pno(struct rtw_dev *rtwdev,
>  void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
>                            struct rtw_vif *rtwvif);
>  int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev);
> +bool rtw_fw_csa_active(struct rtw_dev *rtwdev);
>  void rtw_fw_update_beacon_work(struct work_struct *work);
> +void rtw_fw_csa_beacon_work(struct wiphy *wiphy, struct wiphy_work *work=
);
>  void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
>  int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
>                            u32 offset, u32 size, u32 *buf);
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 2a9b09fa76e7..4c5be1bd9875 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -164,6 +164,9 @@ static int rtw_ops_add_interface(struct ieee80211_hw =
*hw,
>         memset(&rtwvif->bfee, 0, sizeof(struct rtw_bfee));
>         rtw_txq_init(rtwdev, vif->txq);
>         INIT_LIST_HEAD(&rtwvif->rsvd_page_list);
> +       if (!test_bit(RTW_FLAG_RESTARTING, rtwdev->flags))

Will it be a problem just unconditionally initializing csa work?

> +               wiphy_delayed_work_init(&rtwvif->csa_beacon_work,
> +                                       rtw_fw_csa_beacon_work);
>=20
>         mutex_lock(&rtwdev->mutex);
>=20
> @@ -235,6 +238,8 @@ static void rtw_ops_remove_interface(struct ieee80211=
_hw *hw,
>         rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM mac_id %d on port %d=
\n",
>                 vif->addr, rtwvif->mac_id, rtwvif->port);
>=20
> +       wiphy_delayed_work_cancel(hw->wiphy, &rtwvif->csa_beacon_work);
> +
>         mutex_lock(&rtwdev->mutex);
>=20
>         rtw_leave_lps_deep(rtwdev);
> @@ -438,6 +443,13 @@ static void rtw_ops_bss_info_changed(struct ieee8021=
1_hw *hw,
>                 rtw_set_dtim_period(rtwdev, conf->dtim_period);
>                 rtw_fw_download_rsvd_page(rtwdev);
>                 rtw_send_rsvd_page_h2c(rtwdev);
> +               if (conf->csa_active) {
> +                       u32 interval =3D ieee80211_tu_to_usec(conf->beaco=
n_int);
> +
> +                       wiphy_delayed_work_queue(hw->wiphy,
> +                                                &rtwvif->csa_beacon_work=
,
> +                                                usecs_to_jiffies(interva=
l));
> +               }
>         }
>=20
>         if (changed & BSS_CHANGED_BEACON_ENABLED) {
> @@ -487,8 +499,11 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
>                             struct ieee80211_vif *vif,
>                             struct ieee80211_bss_conf *link_conf)
>  {
> +       struct rtw_vif *rtwvif =3D (struct rtw_vif *)vif->drv_priv;
>         struct rtw_dev *rtwdev =3D hw->priv;
>=20
> +       wiphy_delayed_work_cancel(hw->wiphy, &rtwvif->csa_beacon_work);
> +
>         mutex_lock(&rtwdev->mutex);
>         rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
>         rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
> @@ -556,6 +571,17 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, =
struct ieee80211_sta *sta,
>         return 0;
>  }
>=20
> +static void rtw_ops_channel_switch_beacon(struct ieee80211_hw *hw,
> +                                         struct ieee80211_vif *vif,
> +                                         struct cfg80211_chan_def *chand=
ef)
> +{
> +       u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +       struct rtw_vif *rtwvif =3D (struct rtw_vif *)vif->drv_priv;
> +
> +       wiphy_delayed_work_queue(hw->wiphy, &rtwvif->csa_beacon_work,
> +                                usecs_to_jiffies(interval));
> +}
> +
>  static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd=
,
>                            struct ieee80211_vif *vif, struct ieee80211_st=
a *sta,
>                            struct ieee80211_key_conf *key)
> @@ -626,7 +652,8 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, e=
num set_key_cmd cmd,
>         }
>=20
>         /* download new cam settings for PG to backup */
> -       if (rtw_get_lps_deep_mode(rtwdev) =3D=3D LPS_DEEP_MODE_PG)
> +       if (rtw_get_lps_deep_mode(rtwdev) =3D=3D LPS_DEEP_MODE_PG &&
> +           !rtw_fw_csa_active(rtwdev))

As the comment, this is to download new CAM settings. If CSA is ongoning,
you ignore the download. Then, my question is when will you download
this properly?

>                 rtw_fw_download_rsvd_page(rtwdev);
>=20
>  out:
> @@ -839,6 +866,14 @@ static int rtw_ops_get_antenna(struct ieee80211_hw *=
hw,
>  }
>=20
>  #ifdef CONFIG_PM
> +static void rtw_csa_cancel_iter(void *data, struct ieee80211_vif *vif)
> +{
> +       struct rtw_vif *rtwvif =3D (struct rtw_vif *)vif->drv_priv;
> +       struct rtw_dev *rtwdev =3D data;
> +
> +       wiphy_delayed_work_cancel(rtwdev->hw->wiphy, &rtwvif->csa_beacon_=
work);
> +}
> +
>  static int rtw_ops_suspend(struct ieee80211_hw *hw,
>                            struct cfg80211_wowlan *wowlan)
>  {
> @@ -846,6 +881,7 @@ static int rtw_ops_suspend(struct ieee80211_hw *hw,
>         int ret;
>=20
>         mutex_lock(&rtwdev->mutex);
> +       rtw_iterate_vifs(rtwdev, rtw_csa_cancel_iter, rtwdev);

I'm thinking if we move back csa work to rtwdev (like v2) to avoid this kin=
d of
iterative.=20

>         ret =3D rtw_wow_suspend(rtwdev, wowlan);
>         if (ret)
>                 rtw_err(rtwdev, "failed to suspend for wow %d\n", ret);
> @@ -887,10 +923,19 @@ static void rtw_reconfig_complete(struct ieee80211_=
hw *hw,
>         mutex_unlock(&rtwdev->mutex);
>  }
>=20
> +static void rtw_csa_active_iter(void *data, struct ieee80211_vif *vif)
> +{
> +       bool *csa_active =3D data;
> +
> +       if (vif->bss_conf.csa_active)
> +               *csa_active =3D true;
> +}
> +
>  static int rtw_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif=
 *vif,
>                            struct ieee80211_scan_request *req)
>  {
>         struct rtw_dev *rtwdev =3D hw->priv;
> +       bool csa_active =3D false;
>         int ret;
>=20
>         if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
> @@ -900,6 +945,13 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, =
struct ieee80211_vif *vif,
>                 return -EBUSY;
>=20
>         mutex_lock(&rtwdev->mutex);
> +
> +       rtw_iterate_vifs(rtwdev, rtw_csa_active_iter, &csa_active);

and avoid this iterative.=20

> +       if (csa_active) {
> +               mutex_unlock(&rtwdev->mutex);
> +               return -EBUSY;
> +       }
> +
>         rtw_hw_scan_start(rtwdev, vif, req);
>         ret =3D rtw_hw_scan_offload(rtwdev, vif, true);
>         if (ret) {



