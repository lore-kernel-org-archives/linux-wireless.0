Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDE3F1078;
	Wed,  7 Oct 2026 06:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355172; cv=none; b=mgYUMpcgUE7weqQDnuoTM6WXLfHvFfGFUSPWTS46jfY21xUtq6hIWgMmdH3Wjkq1nAwSBiWNyLKPOPQiC/zzSdzr6VRgwz1+vpsW1wzo/qNbXRGjklzLm9N2JpZLvBK7RaaFSbxfsa33XDA80EL5Ob8HHNvk7fL73VY1PQf+yug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355172; c=relaxed/simple;
	bh=KEYWs/gLCUgSmeDj0vOJnCZhAMhwLRPvWCTFcmqDyQc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rQ8GsHVqdA2RQuhruKnS9mLfBxOAO12Og1kNaMNII6420aSeSiM1MISNNn6NU3nPWnFeoSQBY4EkT6r/9QJXF8dk1zpbUM3G8PmyUjMVEuwo/2pQOlspbjwVQCYPZIb9iVxVacT2YiiTIr7L0mJPt8IZfR/CN19PWaOPS/x+ns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CZTdJGAa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CZTdJGAa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6976d9V513630762, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791355149; bh=cYe6Noo0ARQoNBIg4oNXFTkFAPNrpCOWlCA2O65XFuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CZTdJGAaEEs2RRU5vozu/cHoftCfA/z6IgPgB4VgOL1Rog8pdXmDy1VRljf4YFHCx
	 Eix3JahCpjCsRVc5tZO2s7T3KQTvXi5itz9/1JFXOZpD/UF4SArUSXXeUyUtPVUTu1
	 yB2oZbLMpT/XbL3T3lYAEfesOchRIcUQhAJzsv9yvokcLkfvyNNDE0TnmK54Hy9CAs
	 fKbnvO1w2g0nzB4cIU2hgUddsJpEf54Bck69hxFMrExm0a7Y7s//erpqY5md0eQKRO
	 LNrF0va4FyqMI+OKAQc6uDCwRCCln02mAyPlbDTHEBwvWQUGd0Fl2E+6tZG4BXw4f1
	 KrRGsrTQI3iSQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6976d9V513630762
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 14:39:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 14:39:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 14:39:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v4 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v4 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdViKsq55Ir0Z0UEaMXTAuIl77ILbxm64g
Date: Wed, 7 Oct 2026 06:39:09 +0000
Message-ID: <63ac6992e6614de1a085131964974ff1@realtek.com>
References: <20261007061113.2083449-1-mehmet.fide@gmail.com>
 <20261007061113.2083449-3-mehmet.fide@gmail.com>
In-Reply-To: <20261007061113.2083449-3-mehmet.fide@gmail.com>
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

[...]

> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1802,14 +1802,76 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtw=
dev)
>         return ret;
>  }
>=20
> +bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
> +{

add lockdep_assert_wiphy(wiphy) to rtw_fw_csa_{active,start,stop}?
Since they access rtwdev->csa_vif.

> +       return rtwdev->csa_vif && rtwdev->csa_vif->bss_conf.csa_active;
> +}
> +
> +void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
> +{
> +       u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +
> +       rtwdev->csa_vif =3D vif;
> +       wiphy_delayed_work_queue(rtwdev->hw->wiphy, &rtwdev->csa_beacon_w=
ork,
> +                                usecs_to_jiffies(interval));
> +}
> +
> +void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
> +{
> +       if (!vif || rtwdev->csa_vif !=3D vif)
> +               return;
> +
> +       wiphy_delayed_work_cancel(rtwdev->hw->wiphy, &rtwdev->csa_beacon_=
work);
> +       rtwdev->csa_vif =3D NULL;
> +}
> +

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 2a9b09fa76e7..087268909f5f 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -235,6 +235,8 @@ static void rtw_ops_remove_interface(struct ieee80211=
_hw *hw,
>         rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM mac_id %d on port %d=
\n",
>                 vif->addr, rtwvif->mac_id, rtwvif->port);
>=20
> +       rtw_fw_csa_stop(rtwdev, vif);
> +
>         mutex_lock(&rtwdev->mutex);
>=20
>         rtw_leave_lps_deep(rtwdev);
> @@ -395,8 +397,10 @@ static void rtw_ops_bss_info_changed(struct ieee8021=
1_hw *hw,
>                 if (vif->cfg.assoc) {
>                         rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FI=
NISH);
>=20
> -                       rtw_fw_download_rsvd_page(rtwdev);
> -                       rtw_send_rsvd_page_h2c(rtwdev);
> +                       if (!rtw_fw_csa_active(rtwdev)) {

Does it actually happen to AP mode?

If it could happen, check the condition by conf->csa_active (like below)?

> +                               rtw_fw_download_rsvd_page(rtwdev);
> +                               rtw_send_rsvd_page_h2c(rtwdev);
> +                       }
>                         rtw_fw_default_port(rtwdev, rtwvif);
>                         rtw_coex_media_status_notify(rtwdev, vif->cfg.ass=
oc);
>                         if (rtw_bf_support)
> @@ -438,6 +442,8 @@ static void rtw_ops_bss_info_changed(struct ieee80211=
_hw *hw,
>                 rtw_set_dtim_period(rtwdev, conf->dtim_period);
>                 rtw_fw_download_rsvd_page(rtwdev);
>                 rtw_send_rsvd_page_h2c(rtwdev);
> +               if (conf->csa_active)
> +                       rtw_fw_csa_start(rtwdev, vif);
>         }
>=20
>         if (changed & BSS_CHANGED_BEACON_ENABLED) {
> @@ -489,6 +495,8 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
>  {
>         struct rtw_dev *rtwdev =3D hw->priv;
>=20
> +       rtw_fw_csa_stop(rtwdev, vif);
> +
>         mutex_lock(&rtwdev->mutex);
>         rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
>         rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
> @@ -556,6 +564,15 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, =
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
> +       rtw_fw_csa_start(rtwdev, vif);
> +}
> +
>  static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd=
,
>                            struct ieee80211_vif *vif, struct ieee80211_st=
a *sta,
>                            struct ieee80211_key_conf *key)
> @@ -626,7 +643,8 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, e=
num set_key_cmd cmd,
>         }
>=20
>         /* download new cam settings for PG to backup */
> -       if (rtw_get_lps_deep_mode(rtwdev) =3D=3D LPS_DEEP_MODE_PG)
> +       if (rtw_get_lps_deep_mode(rtwdev) =3D=3D LPS_DEEP_MODE_PG &&
> +           !rtw_fw_csa_active(rtwdev))

Think of this deeper.... Is it existing race between set_key and !csa->acti=
ve?

>                 rtw_fw_download_rsvd_page(rtwdev);
>=20
>  out:
> @@ -846,6 +864,7 @@ static int rtw_ops_suspend(struct ieee80211_hw *hw,
>         int ret;
>=20
>         mutex_lock(&rtwdev->mutex);
> +       rtw_fw_csa_stop(rtwdev, rtwdev->csa_vif);

Since you access rtwdev->csa_vif, should this take wiphy_lock?

>         ret =3D rtw_wow_suspend(rtwdev, wowlan);
>         if (ret)
>                 rtw_err(rtwdev, "failed to suspend for wow %d\n", ret);
> @@ -893,19 +912,30 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw,=
 struct ieee80211_vif *vif,
>         struct rtw_dev *rtwdev =3D hw->priv;
>         int ret;
>=20
> -       if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
> -               return 1;
> +       mutex_lock(&rtwdev->mutex);

guard(mutex)( &rtwdev->mutex); ?

>=20
> -       if (test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
> -               return -EBUSY;
> +       if (rtw_fw_csa_active(rtwdev)) {
> +               ret =3D -EBUSY;
> +               goto out;
> +       }
> +
> +       if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD)) =
{
> +               ret =3D 1;
> +               goto out;
> +       }
> +
> +       if (test_bit(RTW_FLAG_SCANNING, rtwdev->flags)) {
> +               ret =3D -EBUSY;
> +               goto out;
> +       }
>=20
> -       mutex_lock(&rtwdev->mutex);
>         rtw_hw_scan_start(rtwdev, vif, req);
>         ret =3D rtw_hw_scan_offload(rtwdev, vif, true);
>         if (ret) {
>                 rtw_hw_scan_abort(rtwdev);
>                 rtw_err(rtwdev, "HW scan failed with status: %d\n", ret);
>         }
> +out:
>         mutex_unlock(&rtwdev->mutex);
>=20
>         return ret;

