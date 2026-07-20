Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCF7390C8A
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529075; cv=none; b=WEkvyjV3HF8qK6VIB5MDfJ5tTEkwkekTt9nYs7xCloSNElmC09a/emtxXVp4B39r/mnCgdWqbaP5iOv3BS++HSGLXoCNKYf0xcwVUuZeeBYunAPV3wSj5gI5ayEU9xCoVjIUbC8najVuGnpVnU3oKKSLjdBSq96mJipd8agpg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529075; c=relaxed/simple;
	bh=j6TjcvnS+KhyCG+suD356fs5pvOCCTO6vEk8DRVbcVo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZdEv4QdyGjfq00aWCHkNg9ibnxOPutUwv3quf+e3FObbc9gMNPEu1euf2Lcs8EMypjZbDzrKd7gQXs6spHQvsNHyuD4HMl2y/jzInMKISCv39RRIT9ZEkHcrpGEFhshVcMaviyuSiTSv3W7kD3Q/HiSf8ZpAcPUMBZCcgPv/kjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=sKlkx7xj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="sKlkx7xj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66K6UxZ622251057, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784529059; bh=jKknjzJ2lqqsc7UJA9mCs4CaZyk++PisyjG0/qMN6I8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=sKlkx7xjB3X4LRZUDu/ya41sB4SFLrsQlYJ6U8wVjlRvjwgCP1FLyqTnwY7nLZg2S
	 /NQ4m75cvCeHCSluNTc40n0e8cOk8jyM2QpCqyUmWfEjlf2r/He2SrBcp+wWNCr3t8
	 a+NAkyPbFLQitEkucDB+OZbgvp+c6IXsd1iH10l2vlgsmFMzkODTnyLzDUb9XlRmzT
	 +GK+hFq2mv4iv0lM2o6KL42lfmzHK1TbnPjnRBsRcUQ9sLpF7MB4UcCegbj9oSAiK/
	 /6pg3BJPaYcqO5I8TqQjfO8TqkBMPCeaknF9rpcwcL3OCe71B5/hR8BKlbu37xw/lQ
	 S8lxdC+lIFySQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66K6UxZ622251057
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 14:30:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Jul 2026 14:30:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 20 Jul 2026 14:30:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "straube.linux@gmail.com" <straube.linux@gmail.com>
Subject: RE: [RFC PATCH v1 2/9] wifi: rtw88: 8723bs: handle SDIO management
 and data TX
Thread-Topic: [RFC PATCH v1 2/9] wifi: rtw88: 8723bs: handle SDIO management
 and data TX
Thread-Index: AQHdE7mAOHruzysQRkeH/lzRKi0f+rZ1wJ3w
Date: Mon, 20 Jul 2026 06:30:55 +0000
Message-ID: <407fdd8792e74bd4a5a163da0f2f5e98@realtek.com>
References: <cover.1784047561.git.luka.gejak@linux.dev>
 <1ac8fad97e3fcdea41f20963f771fbf5efbe6f6a.1784047561.git.luka.gejak@linux.dev>
In-Reply-To: <1ac8fad97e3fcdea41f20963f771fbf5efbe6f6a.1784047561.git.luka.gejak@linux.dev>
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
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> The RTL8723BS SDIO firmware expects the vendor TX-descriptor contract for
> management frames: SPE_RPT set so the 8051 schedules the frame on air, a
> fixed data retry limit, and management frames carried on the shared BCMC
> station context. Program the descriptor accordingly and select the
> management rate (CCK on 2.4 GHz, following the BSS basic-rate set), and a=
dd
> rtw_tx_report_handle_8723b() to consume the vendor CCX TX reports.

Doesn't the existing logic work to you? What is the problem?

>=20
> Mark non-management packets as complete first/last segments and transmit
> EAPOL at the lowest basic rate so the four-way handshake follows the
> vendor data descriptor contract.

Can you explain why this is necessary? As I know, first/last segments are
related to TX in bus. Why does it can affect four-way?

>=20
> Also apply the firmware-reported TX rate through the descriptor: on this
> chip the hardware otherwise keys the CCK floor on air regardless of the
> rate mask, so force the rate the firmware last reported via C2H while
> leaving rate fallback enabled for recovery after a power-save wake.

Not sure what the problem you encountered. For management frames, the rtw88
TX fixed rate depends on operating band and lowest supported rate.=20

And, the TX report struct only contains 'sn' not TX rate.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/tx.c | 225 +++++++++++++++++++++++-
>  drivers/net/wireless/realtek/rtw88/tx.h |   5 +
>  2 files changed, 223 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wirele=
ss/realtek/rtw88/tx.c
> index 9d747a060b98..5b4d4713be6f 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.c
> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
> @@ -37,14 +37,20 @@ void rtw_tx_fill_tx_desc(struct rtw_dev *rtwdev,
>  {
>         struct rtw_tx_desc *tx_desc =3D (struct rtw_tx_desc *)skb->data;
>         bool more_data =3D false;
> +       bool first_seg =3D false;
>=20
>         if (pkt_info->qsel =3D=3D TX_DESC_QSEL_HIGH)
>                 more_data =3D true;
>=20
> +       if (rtw_is_8723bs_sdio(rtwdev) &&
> +           pkt_info->qsel !=3D TX_DESC_QSEL_MGMT)
> +               first_seg =3D true;
> +
>         tx_desc->w0 =3D le32_encode_bits(pkt_info->tx_pkt_size, RTW_TX_DE=
SC_W0_TXPKTSIZE) |
>                       le32_encode_bits(pkt_info->offset, RTW_TX_DESC_W0_O=
FFSET) |
>                       le32_encode_bits(pkt_info->bmc, RTW_TX_DESC_W0_BMC)=
 |
>                       le32_encode_bits(pkt_info->ls, RTW_TX_DESC_W0_LS) |
> +                     le32_encode_bits(first_seg, RTW_TX_DESC_W0_FS) |
>                       le32_encode_bits(pkt_info->dis_qselseq, RTW_TX_DESC=
_W0_DISQSELSEQ);
>=20
>         tx_desc->w1 =3D le32_encode_bits(pkt_info->mac_id, RTW_TX_DESC_W1=
_MACID) |
> @@ -68,9 +74,15 @@ void rtw_tx_fill_tx_desc(struct rtw_dev *rtwdev,
>=20
>         tx_desc->w4 =3D le32_encode_bits(pkt_info->rate, RTW_TX_DESC_W4_D=
ATARATE);
>=20
> -       if (rtwdev->chip->old_datarate_fb_limit)
> +       if (rtwdev->chip->old_datarate_fb_limit &&
> +           !pkt_info->disable_data_rate_fb_limit)
>                 tx_desc->w4 |=3D le32_encode_bits(0x1f, RTW_TX_DESC_W4_DA=
TARATE_FB_LIMIT);
>=20
> +       if (pkt_info->retry_limit_en)
> +               tx_desc->w4 |=3D le32_encode_bits(true, RTW_TX_DESC_W4_RE=
TRY_LIMIT_EN) |
> +                              le32_encode_bits(pkt_info->data_retry_limi=
t,
> +                                               RTW_TX_DESC_W4_DATA_RETRY=
_LIMIT);
> +
>         tx_desc->w5 =3D le32_encode_bits(pkt_info->short_gi, RTW_TX_DESC_=
W5_DATA_SHORT) |
>                       le32_encode_bits(pkt_info->bw, RTW_TX_DESC_W5_DATA_=
BW) |
>                       le32_encode_bits(pkt_info->ldpc, RTW_TX_DESC_W5_DAT=
A_LDPC) |
> @@ -262,6 +274,36 @@ void rtw_tx_report_handle(struct rtw_dev *rtwdev, st=
ruct sk_buff *skb, int src)
>         spin_unlock_irqrestore(&tx_report->q_lock, flags);
>  }
>=20
> +/* 8723BS SDIO v41 firmware reports management TX through the vendor CCX=
 C2H
> + * (0x12 for auth/assoc/data, 0x32 for scan probe). Payload byte 0 is th=
e
> + * report type/status (bit 6 lifetime-over, bit 7 retry-over); byte 6 is=
 the
> + * W6 SW_DEFINE (sequence number) the vendor driver reads back.
> + */
> +void rtw_tx_report_handle_8723b(struct rtw_dev *rtwdev, u8 report_type,
> +                               u8 *payload, u8 len)
> +{
> +       struct rtw_tx_report *tx_report =3D &rtwdev->tx_report;
> +       struct sk_buff *cur, *tmp;
> +       unsigned long flags;
> +       bool failed =3D len > 0 && (payload[0] & (BIT(6) | BIT(7)));
> +       u8 sn =3D len >=3D 7 ? payload[6] : 0xff;

Use le8_get_bits() with predefined mask to get the value.=20

> +       u8 *n;
> +
> +       if (len < 7)
> +               return;
> +

Only the decode format is different from existing, the following can be reu=
se.

> +       spin_lock_irqsave(&tx_report->q_lock, flags);
> +       skb_queue_walk_safe(&tx_report->queue, cur, tmp) {
> +               n =3D (u8 *)IEEE80211_SKB_CB(cur)->status.status_driver_d=
ata;
> +               if (*n =3D=3D sn) {
> +                       __skb_unlink(cur, &tx_report->queue);
> +                       rtw_tx_report_tx_status(rtwdev, cur, !failed);
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&tx_report->q_lock, flags);
> +}
> +
>  static u8 rtw_get_mgmt_rate(struct rtw_dev *rtwdev, struct sk_buff *skb,
>                             u8 lowest_rate, bool ignore_rate)
>  {
> @@ -275,15 +317,118 @@ static u8 rtw_get_mgmt_rate(struct rtw_dev *rtwdev=
, struct sk_buff *skb,
>         return __ffs(vif->bss_conf.basic_rates) + lowest_rate;
>  }
>=20
> +static bool rtw_tx_8723bs_sdio_2g(struct rtw_dev *rtwdev)

rtw_tx_8723bs_sdio_2ghz

But I think we don't need this. The consumers seem not need special cases.
I mean just use existing logics.=20

> +{
> +       return rtw_is_8723bs_sdio(rtwdev) &&
> +              rtwdev->hal.current_band_type =3D=3D RTW_BAND_2G;
> +}
> +
> +static bool rtw_tx_8723bs_rates_have_cck(const u8 *ie)
> +{
> +       int i;
> +
> +       if (!ie)
> +               return false;
> +
> +       for (i =3D 2; i < ie[1] + 2; i++) {
> +               switch (ie[i] & 0x7f) {
> +               case 2:  /* 1 Mbps */
> +               case 4:  /* 2 Mbps */
> +               case 11: /* 5.5 Mbps */
> +               case 22: /* 11 Mbps */
> +                       return true;
> +               default:
> +                       break;
> +               }
> +       }
> +
> +       return false;
> +}
> +
> +static bool rtw_tx_8723bs_bss_has_cck(struct rtw_dev *rtwdev,
> +                                     struct ieee80211_vif *vif,
> +                                     const u8 *bssid,
> +                                     bool *known)
> +{
> +       struct cfg80211_bss *bss;
> +       const u8 *rates;
> +       const u8 *ext_rates;
> +       bool has_cck =3D false;
> +
> +       *known =3D false;
> +
> +       if (!vif || !bssid || !is_valid_ether_addr(bssid))
> +               return false;
> +
> +       bss =3D cfg80211_get_bss(rtwdev->hw->wiphy, NULL, bssid, NULL, 0,
> +                              IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_=
ANY);
> +       if (!bss)
> +               return false;
> +
> +       rcu_read_lock();
> +       rates =3D ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
> +       ext_rates =3D ieee80211_bss_get_ie(bss, WLAN_EID_EXT_SUPP_RATES);
> +       if (rates || ext_rates) {
> +               *known =3D true;
> +               has_cck =3D rtw_tx_8723bs_rates_have_cck(rates) ||
> +                         rtw_tx_8723bs_rates_have_cck(ext_rates);
> +       }
> +       rcu_read_unlock();
> +
> +       cfg80211_put_bss(rtwdev->hw->wiphy, bss);
> +
> +       return has_cck;
> +}
> +
> +/* 8723BS SDIO follows the vendor driver's tx_rate rule: the initial sca=
n
> + * default is 1 Mbps CCK, and join-time update_wireless_mode() keeps 1 M=
bps
> + * whenever the selected BSS rate set includes CCK; only pure-G BSSes us=
e 6
> + * Mbps OFDM.
> + */
> +static void rtw_tx_8723bs_sdio_rate(struct rtw_dev *rtwdev,
> +                                   struct rtw_tx_pkt_info *pkt_info,
> +                                   struct sk_buff *skb)
> +{
> +       struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
> +       struct ieee80211_vif *vif =3D tx_info->control.vif;
> +       struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
> +       const u8 *bssid =3D NULL;
> +       bool known =3D false;
> +       bool has_cck =3D true;
> +
> +       if (ieee80211_is_data(hdr->frame_control) ||
> +           ieee80211_is_mgmt(hdr->frame_control))
> +               bssid =3D hdr->addr1;
> +
> +       has_cck =3D rtw_tx_8723bs_bss_has_cck(rtwdev, vif, bssid, &known)=
;
> +       if (!known && vif && vif->bss_conf.basic_rates)
> +               has_cck =3D vif->bss_conf.basic_rates & 0xf;
> +       else if (!known)
> +               has_cck =3D true;
> +
> +       if (has_cck) {
> +               pkt_info->rate_id =3D RTW_RATEID_B_20M;
> +               pkt_info->rate =3D DESC_RATE1M;
> +       } else {
> +               pkt_info->rate_id =3D RTW_RATEID_G;
> +               pkt_info->rate =3D DESC_RATE6M;
> +       }
> +}
> +
>  static void rtw_tx_pkt_info_update_rate(struct rtw_dev *rtwdev,
>                                         struct rtw_tx_pkt_info *pkt_info,
>                                         struct sk_buff *skb,
>                                         bool ignore_rate)
>  {
>         if (rtwdev->hal.current_band_type =3D=3D RTW_BAND_2G) {
> -               pkt_info->rate_id =3D RTW_RATEID_B_20M;
> -               pkt_info->rate =3D rtw_get_mgmt_rate(rtwdev, skb, DESC_RA=
TE1M,
> -                                                  ignore_rate);
> +               if (rtw_tx_8723bs_sdio_2g(rtwdev)) {
> +                       rtw_tx_8723bs_sdio_rate(rtwdev, pkt_info, skb);

I don't think we need this special case.

> +               } else {
> +                       pkt_info->rate_id =3D RTW_RATEID_B_20M;
> +                       pkt_info->rate =3D rtw_get_mgmt_rate(rtwdev, skb,
> +                                                          DESC_RATE1M,
> +                                                          ignore_rate);
> +               }
>         } else {
>                 pkt_info->rate_id =3D RTW_RATEID_G;
>                 pkt_info->rate =3D rtw_get_mgmt_rate(rtwdev, skb, DESC_RA=
TE6M,
> @@ -292,6 +437,12 @@ static void rtw_tx_pkt_info_update_rate(struct rtw_d=
ev *rtwdev,
>=20
>         pkt_info->use_rate =3D true;
>         pkt_info->dis_rate_fallback =3D true;
> +
> +       /* 8723BS SDIO 2.4 GHz: the vendor path leaves dis_rate_fallback=
=3D0 for
> +        * MGNT_FRAMETAG and EAPOL/ARP data frames.
> +        */
> +       if (rtw_tx_8723bs_sdio_2g(rtwdev))
> +               pkt_info->dis_rate_fallback =3D false;

This is not necessary either.=20

>  }
>=20
>  static void rtw_tx_pkt_info_update_sec(struct rtw_dev *rtwdev,
> @@ -326,7 +477,30 @@ static void rtw_tx_mgmt_pkt_info_update(struct rtw_d=
ev *rtwdev,
>                                         struct ieee80211_sta *sta,
>                                         struct sk_buff *skb)
>  {
> +       struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
> +
>         rtw_tx_pkt_info_update_rate(rtwdev, pkt_info, skb, false);
> +
> +       if (rtw_is_8723bs_sdio(rtwdev)) {
> +               /* The vendor v41 firmware requires SPE_RPT=3D1 in the TX
> +                * descriptor to schedule a management frame for air
> +                * transmission (report=3Dtrue), with SW_DEFINE/sn=3D0. K=
eep the
> +                * retry limit and rate-fallback control aligned with the
> +                * vendor rtl8723b_fill_default_txdesc() contract.
> +                */

As rtw_tx_pkt_info_update_rate() has configured fixed rate. I suppose we
don't need so many additional settings. Especially, why does it need
report?=20

> +               pkt_info->seq =3D (le16_to_cpu(hdr->seq_ctrl) &
> +                                IEEE80211_SCTL_SEQ) >> 4;
> +               pkt_info->en_hwseq =3D true;
> +               pkt_info->hw_ssn_sel =3D 0;
> +               pkt_info->dis_rate_fallback =3D false;
> +               pkt_info->retry_limit_en =3D true;
> +               pkt_info->data_retry_limit =3D 6;
> +               pkt_info->disable_data_rate_fb_limit =3D true;
> +               pkt_info->report =3D true;
> +               pkt_info->sn =3D 0;
> +               return;
> +       }
> +
>         pkt_info->dis_qselseq =3D true;
>         pkt_info->en_hwseq =3D true;
>         pkt_info->hw_ssn_sel =3D 0;
> @@ -396,6 +570,30 @@ static void rtw_tx_data_pkt_info_update(struct rtw_d=
ev *rtwdev,
>         pkt_info->stbc =3D stbc;
>         pkt_info->ldpc =3D ldpc;
>=20
> +       /* 8723BS SDIO keys the CCK floor on air regardless of the rate m=
ask
> +        * unless the firmware-reported rate is forced through the descri=
ptor.
> +        * Apply the rate the firmware last reported via C2H as the initi=
al TX
> +        * rate. Leave rate fallback enabled (dis_rate_fallback stays 0):=
 the
> +        * applied rate is only the initial one, so a transiently-stale v=
alue -
> +        * e.g. right after a power-save wake - can still step down and r=
ecover.
> +        */
> +       if (sta && rtw_is_8723bs_sdio(rtwdev)) {
> +               si =3D (struct rtw_sta_info *)sta->drv_priv;
> +               if (si->ra_report.desc_rate >=3D DESC_RATEMCS0 &&
> +                   si->ra_report.desc_rate < DESC_RATE_MAX) {
> +                       pkt_info->rate =3D si->ra_report.desc_rate;
> +                       pkt_info->use_rate =3D true;
> +               }
> +       }
> +
> +       if (skb->protocol =3D=3D cpu_to_be16(ETH_P_PAE)) {
> +               rtw_tx_pkt_info_update_rate(rtwdev, pkt_info, skb, true);
> +
> +               if (rtw_is_8723bs_sdio(rtwdev) && info->control.vif &&
> +                   info->control.vif->bss_conf.use_short_preamble)
> +                       pkt_info->short_gi =3D true;
> +       }
> +
>         fix_rate =3D dm_info->fix_rate;
>         if (fix_rate < DESC_RATE_MAX) {
>                 pkt_info->rate =3D fix_rate;
> @@ -416,6 +614,7 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
>         struct rtw_sta_info *si;
>         struct rtw_vif *rtwvif;
>         __le16 fc =3D hdr->frame_control;
> +       bool is_mgmt =3D ieee80211_is_mgmt(fc);
>         bool bmc;
>=20
>         if (sta) {
> @@ -426,7 +625,14 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
>                 pkt_info->mac_id =3D rtwvif->mac_id;
>         }
>=20
> -       if (ieee80211_is_mgmt(fc) || ieee80211_is_any_nullfunc(fc))
> +       /* The vendor 8723BS SDIO path sends management frames through th=
e
> +        * shared BCMC station context (macid 1 in station mode). Data fr=
ames
> +        * keep the normal peer/vif macid.
> +        */
> +       if (rtw_is_8723bs_sdio(rtwdev) && is_mgmt)
> +               pkt_info->mac_id =3D 1;

I think it should still use si/vif->macid, or you should allocate another m=
ac_id
for a station (but I don't think it is actually needed).


> +
> +       if (is_mgmt || ieee80211_is_any_nullfunc(fc))
>                 rtw_tx_mgmt_pkt_info_update(rtwdev, pkt_info, sta, skb);
>         else if (ieee80211_is_data(fc))
>                 rtw_tx_data_pkt_info_update(rtwdev, pkt_info, sta, skb);
> @@ -434,7 +640,12 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
>         bmc =3D is_broadcast_ether_addr(hdr->addr1) ||
>               is_multicast_ether_addr(hdr->addr1);
>=20
> -       if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> +       /* 8723BS SDIO management frames carry the vendor SPE_RPT/sn=3D0 =
contract
> +        * set above; skip rtw_tx_report_enable() so the sn stays 0. Data
> +        * frames still use the normal CCX TX-report path.
> +        */
> +       if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS &&
> +           !(rtw_is_8723bs_sdio(rtwdev) && is_mgmt))
>                 rtw_tx_report_enable(rtwdev, pkt_info);
>=20
>         pkt_info->bmc =3D bmc;
> @@ -442,7 +653,7 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
>         pkt_info->tx_pkt_size =3D skb->len;
>         pkt_info->offset =3D chip->tx_pkt_desc_sz;
>         pkt_info->qsel =3D skb->priority;
> -       pkt_info->ls =3D true;
> +       pkt_info->ls =3D !(rtw_is_8723bs_sdio(rtwdev) && is_mgmt);
>=20
>         /* maybe merge with tx status ? */
>         rtw_tx_stats(rtwdev, vif, skb);
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wirele=
ss/realtek/rtw88/tx.h
> index d34cdeca16f1..d7e1fa83bbae 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.h
> +++ b/drivers/net/wireless/realtek/rtw88/tx.h
> @@ -26,6 +26,7 @@ struct rtw_tx_desc {
>  #define RTW_TX_DESC_W0_OFFSET GENMASK(23, 16)
>  #define RTW_TX_DESC_W0_BMC BIT(24)
>  #define RTW_TX_DESC_W0_LS BIT(26)
> +#define RTW_TX_DESC_W0_FS BIT(27)
>  #define RTW_TX_DESC_W0_DISQSELSEQ BIT(31)
>  #define RTW_TX_DESC_W1_MACID GENMASK(7, 0)
>  #define RTW_TX_DESC_W1_QSEL GENMASK(12, 8)
> @@ -45,6 +46,8 @@ struct rtw_tx_desc {
>  #define RTW_TX_DESC_W3_MAX_AGG_NUM GENMASK(21, 17)
>  #define RTW_TX_DESC_W4_DATARATE GENMASK(6, 0)
>  #define RTW_TX_DESC_W4_DATARATE_FB_LIMIT GENMASK(12, 8)
> +#define RTW_TX_DESC_W4_RETRY_LIMIT_EN BIT(17)
> +#define RTW_TX_DESC_W4_DATA_RETRY_LIMIT GENMASK(23, 18)
>  #define RTW_TX_DESC_W4_RTSRATE GENMASK(28, 24)
>  #define RTW_TX_DESC_W5_DATA_SHORT BIT(4)
>  #define RTW_TX_DESC_W5_DATA_BW GENMASK(6, 5)
> @@ -99,6 +102,8 @@ void rtw_tx_fill_tx_desc(struct rtw_dev *rtwdev,
>                          struct rtw_tx_pkt_info *pkt_info, struct sk_buff=
 *skb);
>  void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, =
u8 sn);
>  void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb, i=
nt src);
> +void rtw_tx_report_handle_8723b(struct rtw_dev *rtwdev, u8 report_type,
> +                               u8 *payload, u8 len);
>  void rtw_tx_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
>                                       struct rtw_tx_pkt_info *pkt_info,
>                                       struct sk_buff *skb,
> --
> 2.55.0

I will continue to review this RFC later.

Since this patch contains three stuffs at least, can you split the stuffs
into smaller patches?=20

I can't always have a long free time to review whole things.

