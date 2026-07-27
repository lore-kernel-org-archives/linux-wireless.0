Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2594377EC5;
	Mon, 27 Jul 2026 07:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785139136; cv=none; b=dlaQ9XsTQrfobCfrJY3NP3qnZeAiBSuepr/tMJbnPI0lK6RS1NBLAXVSkkpWEdIsmalTO0Ici9xSMZlr03iSkKa2vdyM3P2gcTKPSoDXuDkI5IjK1r3JPkXpPpOwIlAmieWPd51rsa5Jh9ElwAjlnh0d4GXK6Jdv31PmgdI8e9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785139136; c=relaxed/simple;
	bh=gRj9NhGIekUAVZvEeb5gVXY4MVBunx56T2gcfzWLuDA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F8k9cb5neVfNE3OXcXnL1jQzby6GCYH5vp3OBgVED6eQz4C6l9K/c9olV01SiPR9sBJMgMAWYdS889Xx1YpAy21JUN7/Q7vjZK1j4a5+agHYWzWTcdwT0L7JQlnlPT7QO4xCkeJvZfD44DJIiuYUIOP6GOmx4j6mshDk+D8lSRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DHZPRbRG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DHZPRbRG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R7wiYyB2937915, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785139125; bh=2u5mWR3lwGRKfksGV1YyeOx51Eo4h0vBoOUC2LfFG4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DHZPRbRGNvfb/eTQkuY0Kq2X8udCaho+bK2GhMp6NG/oQRa8lBCmktgDDyb7Zp3gH
	 rhM1P2ku5CI0nyAq93gbWp+R2tsA2jpQ00Y4reXjHq7bLtHfn6MDGmVUFwTCqUH1vS
	 nEwvQIVaCPxSeXxUuriBduZbjdIeIOd3EbpgXYDc2m3JBFVt7lg5qIA+2ZK38FmC0a
	 g8J1ah4vJo1kh76GeWsZ/QyyhFM4u1OyMcY24satulOhkoOPy4HMh56zNC2Ce61S8u
	 luXhCGtx9LGBSD8hzlOTJAl/KsYfXhRjHS0n3S1U4CSmDA6Ccg5yz+mr31l2y1gil+
	 74dtXWD/JqTsg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R7wiYyB2937915
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:58:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 15:58:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 15:58:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 05/11] wifi: rtw88: coex: add the RTL8723BS scan
 antenna workaround
Thread-Topic: [PATCH v2 05/11] wifi: rtw88: coex: add the RTL8723BS scan
 antenna workaround
Thread-Index: AQHdHEb5CiflpTNtb02S3URNeZUsfraA/X/g
Date: Mon, 27 Jul 2026 07:58:44 +0000
Message-ID: <c04cb1048e1940b1bc63dd68732998d8@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-6-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-6-luka.gejak@linux.dev>
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
> On the RTL8723BS the PTA antenna path has to be programmed directly
> during scan. The vendor driver keeps its own scan-time antenna state and
> does not run the generic coexistence algorithm on boards where BT is
> disabled, and following it is necessary here: without the antenna and
> CCK priority setup applied at scan start, the site survey does not hear
> the AP reliably.
>=20
> Detect the BT-disabled case, replay the vendor BT_MP and BT_INFO queries
> once the firmware has been up long enough for RX DMA to be stable, then
> establish the scan path antenna configuration and skip the generic run.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/coex.c | 179 +++++++++++++++++++++-
>  drivers/net/wireless/realtek/rtw88/coex.h |   2 +
>  drivers/net/wireless/realtek/rtw88/reg.h  |   1 +
>  3 files changed, 181 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wire=
less/realtek/rtw88/coex.c
> index 37c336def419..daba6082f850 100644
> --- a/drivers/net/wireless/realtek/rtw88/coex.c
> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
> @@ -1443,6 +1443,156 @@ static void rtw_coex_set_ant_path(struct rtw_dev =
*rtwdev, bool force, u8 phase)
>  #define case_ALGO(src) \
>         case COEX_ALGO_##src: return #src
>=20
> +/* 8723BS SDIO WiFi/BT coexistence antenna handling. On BT-disabled boar=
ds the
> + * scan/auth window still routes through the PTA mux; these helpers forc=
e the
> + * vendor-shaped WiFi-owned antenna path so directed management TX reach=
es air.
> + */

comment style.

> +#define REG_8723BS_BT_COEX_CTRL                0x0039
> +#define REG_8723BS_BB_ANT_CFG          0x0930
> +#define REG_8723BS_BB_ANT_CFG1         0x0944
> +#define REG_8723BS_BB_ANT_BUF          0x0974
> +#define RTW8723BS_COEX_H_WLAN_ACTIVE   0x1800101b

define these in reg.h

> +
> +static bool rtw_coex_8723bs_ant_is_aux(struct rtw_dev *rtwdev)
> +{
> +       return !!(rtwdev->efuse.bt_setting & BIT(6));
> +}
> +
> +static bool rtw_coex_8723bs_bt_disabled(struct rtw_dev *rtwdev)
> +{
> +       return rtw_is_8723bs(rtwdev) && rtwdev->coex.stat.bt_disabled;
> +}
> +
> +static u32 rtw_coex_8723bs_pta_ant_path(struct rtw_dev *rtwdev)
> +{
> +       return rtw_coex_8723bs_ant_is_aux(rtwdev) ? 0x80 : 0x200;
> +}
> +
> +/* Write BB_SEL_BTG, retrying once with SYS_FUNC BB reset if the first
> + * write does not stick (RF/BB clock may have been gated).
> + */

With the given name, this comment seems not necessary.=20

> +static u32 rtw_coex_8723bs_write_bb_sel_btg(struct rtw_dev *rtwdev, u32 =
value)
> +{
> +       u8 sys_func_before;
> +       u32 readback;
> +
> +       sys_func_before =3D rtw_read8(rtwdev, REG_SYS_FUNC_EN);
> +       if ((sys_func_before & (BIT(0) | BIT(1))) !=3D (BIT(0) | BIT(1)))=
 {
> +               rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));

Use given names for BIT 0/1.

> +               usleep_range(10, 11);
> +       }
> +
> +       rtw_write32(rtwdev, REG_BB_SEL_BTG_8723B, value);
> +       readback =3D rtw_read32(rtwdev, REG_BB_SEL_BTG_8723B);
> +       if (readback =3D=3D value)
> +               return readback;
> +
> +       usleep_range(10, 11);
> +       rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> +       rtw_write32(rtwdev, REG_BB_SEL_BTG_8723B, value);
> +
> +       return rtw_read32(rtwdev, REG_BB_SEL_BTG_8723B);
> +}
> +
> +static u32 rtw_coex_8723bs_reassert_pta_ant(struct rtw_dev *rtwdev)
> +{
> +       return rtw_coex_8723bs_write_bb_sel_btg(rtwdev,
> +                                               rtw_coex_8723bs_pta_ant_p=
ath(rtwdev));

Just call rtw_coex_8723bs_write_bb_sel_btg() ?

> +}
> +
> +static void rtw_coex_8723bs_set_cck_pri(struct rtw_dev *rtwdev, bool hig=
h)
> +{
> +       if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +               return;
> +
> +       if (high) {
> +               rtw_write32(rtwdev, REG_BT_COEX_TABLE_H,
> +                           RTW8723BS_COEX_H_WLAN_ACTIVE);
> +       } else {
> +               rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_TX_CCK, false=
);
> +               rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_RX_CCK, false=
);
> +       }
> +}
> +
> +static void rtw_coex_8723bs_restore_pad_ctrl(struct rtw_dev *rtwdev,
> +                                            bool keep_pta_owner)
> +{
> +       u32 before, after;
> +
> +       before =3D rtw_read32(rtwdev, REG_PAD_CTRL1);
> +       after =3D before & ~(BIT_LNAON_WLBT_SEL | BIT_SW_DPDT_SEL_DATA);
> +       if (keep_pta_owner)
> +               after |=3D BIT_PAPE_WLBT_SEL;
> +       else
> +               after &=3D ~BIT_PAPE_WLBT_SEL;
> +       if (after !=3D before)
> +               rtw_write32(rtwdev, REG_PAD_CTRL1, after);
> +}
> +
> +static void rtw_coex_8723bs_fw_gnt_bt_low(struct rtw_dev *rtwdev)
> +{
> +       if (!rtw_coex_8723bs_bt_disabled(rtwdev))

Please review your calling path. I think callers should ensure RTL8723BS
before calling. (But here needs additional condition bt_disabled though)

> +               return;
> +
> +       if (rtw_read8(rtwdev, REG_GNT_BT) =3D=3D 0x00 &&
> +           rtw_read8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL) =3D=3D 0x0c)
> +               return;
> +
> +       rtw_fw_set_gnt_bt(rtwdev, 0);
> +}
> +
> +static void rtw_coex_8723bs_reassert_ant_buffer(struct rtw_dev *rtwdev)
> +{
> +       u8 sys_func_before;
> +
> +       sys_func_before =3D rtw_read8(rtwdev, REG_SYS_FUNC_EN);
> +       if ((sys_func_before & (BIT(0) | BIT(1))) !=3D (BIT(0) | BIT(1)))=
 {

Please use given names for BIT 0/1.

> +               rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> +               usleep_range(10, 11);
> +       }
> +
> +       rtw_write8_mask(rtwdev, REG_8723BS_BT_COEX_CTRL, BIT(3), 0x1);
> +       rtw_write8(rtwdev, REG_8723BS_BB_ANT_BUF, 0xff);
> +       rtw_write8_mask(rtwdev, REG_8723BS_BB_ANT_CFG1, 0x3, 0x3);
> +       rtw_write8(rtwdev, REG_8723BS_BB_ANT_CFG, 0x77);
> +}
> +
> +static void rtw_coex_8723bs_apply_scan_table(struct rtw_dev *rtwdev)
> +{
> +       rtwdev->coex.dm.cur_table =3D 2;
> +       rtw_coex_set_table(rtwdev, true, 0x5a5a5a5a, 0x5a5a5a5a);
> +}
> +
> +/* Non-connected scan/auth workaround: PS-TDMA type 8 off, PTA antenna p=
ath,
> + * coex table type 2 (matches the vendor non-connected arbitration).
> + */
> +void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev)
> +{
> +       struct rtw_coex_dm *coex_dm =3D &rtwdev->coex.dm;
> +       struct rtw_coex_stat *coex_stat =3D &rtwdev->coex.stat;
> +
> +       if (!rtw_is_8723bs(rtwdev))

Caller check this already.

> +               return;
> +
> +       coex_dm->cur_ps_tdma_on =3D false;
> +       coex_dm->cur_ps_tdma =3D 8;
> +       coex_dm->ps_tdma_para[0] =3D 0x08;
> +       coex_dm->ps_tdma_para[1] =3D 0x00;
> +       coex_dm->ps_tdma_para[2] =3D 0x00;
> +       coex_dm->ps_tdma_para[3] =3D 0x00;
> +       coex_dm->ps_tdma_para[4] =3D 0x00;
> +
> +       rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +       rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
> +       rtw_coex_set_ant_path(rtwdev, true, COEX_SET_ANT_2G);
> +       rtw_coex_8723bs_reassert_ant_buffer(rtwdev);
> +       rtw_coex_8723bs_apply_scan_table(rtwdev);
> +       if (coex_stat->bt_disabled)

It looks like callers check this already.=20

> +               rtw_coex_8723bs_set_cck_pri(rtwdev, true);
> +       rtw_coex_8723bs_reassert_pta_ant(rtwdev);
> +       rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);

I wonder how you can make this workaround? There are so many arguments.

> +}
> +
>  static const char *rtw_coex_get_algo_string(u8 algo)
>  {
>         switch (algo) {
> @@ -2770,7 +2920,7 @@ void rtw_coex_power_on_setting(struct rtw_dev *rtwd=
ev)
>         coex->stop_dm =3D true;
>         coex->wl_rf_off =3D false;
>=20
> -       /* enable BB, we can write 0x948 */
> +       /* enable BB, so BB_SEL_BTG is writable */
>         rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
>                        BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB);
>=20
> @@ -2877,6 +3027,33 @@ void rtw_coex_scan_notify(struct rtw_dev *rtwdev, =
u8 type)
>         coex->freeze =3D false;
>         rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, t=
rue);
>=20
> +       /* 8723BS SDIO BT-disabled: keep the scan/auth PTA antenna state =
the
> +        * vendor uses and skip the generic coex run. At scan start (firm=
ware
> +        * has been up long enough for stable RX DMA) replay the vendor B=
T_MP /
> +        * BT_INFO queries, then re-establish the scan-path PTA setup.
> +        */
> +       if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
> +               if (type =3D=3D COEX_SCAN_START_2G || type =3D=3D COEX_SC=
AN_START) {
> +                       struct rtw_coex_info_req req =3D {};
> +
> +                       coex_stat->cnt_wl[COEX_CNT_WL_SCANAP] =3D 0;
> +                       coex_stat->wl_hi_pri_task2 =3D true;
> +
> +                       req.seq =3D 0x0e;
> +                       req.op_code =3D BT_MP_INFO_OP_SUPP_VER;
> +                       rtw_fw_query_bt_mp_info(rtwdev, &req);
> +                       req.seq =3D 0x0f;
> +                       req.op_code =3D BT_MP_INFO_OP_PATCH_VER;
> +                       rtw_fw_query_bt_mp_info(rtwdev, &req);

These two are debug purpose. When you cat debugfs, it will try to query the
version, won't it?

> +                       rtw_fw_query_bt_info(rtwdev);

It seems to be called at initial. Is it necessary?

> +
> +                       rtw_coex_8723bs_scan_workaround(rtwdev);
> +               } else {
> +                       coex_stat->wl_hi_pri_task2 =3D false;
> +               }
> +               return;

Since RTL8723BS does special handle, just move all into a function, but put
in common flow.

> +       }
> +
>         if (type =3D=3D COEX_SCAN_START_5G) {
>                 rtw_dbg(rtwdev, RTW_DBG_COEX,
>                         "[BTCoex], SCAN START notify (5G)\n");
> diff --git a/drivers/net/wireless/realtek/rtw88/coex.h b/drivers/net/wire=
less/realtek/rtw88/coex.h
> index c398be8391f7..72b1353c9313 100644
> --- a/drivers/net/wireless/realtek/rtw88/coex.h
> +++ b/drivers/net/wireless/realtek/rtw88/coex.h
> @@ -430,4 +430,6 @@ static inline void rtw_coex_active_query_bt_info(stru=
ct rtw_dev *rtwdev)
>                 rtw_coex_query_bt_info(rtwdev);
>  }
>=20
> +void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev);
> +

Just static no need to export.

>  #endif

