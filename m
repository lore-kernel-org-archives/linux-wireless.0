Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16810361667
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 04:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791261036; cv=none; b=uq+A2hLOjiAiFu3NdfGxQGNb09eAFNe/mz2UEqQR5j63ZtwgbcDYOKTH8ojwmoMnUUJkZIxTfa9fG/+wl0iRYV7L3jWvceZzEO6KLzGSUpeK7RyMraUHhPPDX1e7cfCdxXG0v4za+/UsRC3cwkM7Tvtk45vsdJpRqKgu3Ry/U04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791261036; c=relaxed/simple;
	bh=gEY86cxzkz1jPkG0EfHoRb22XGZVTL36qRBvQHNrtAc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=V7qUmBxW9PBXPgUGEvxMBU/0U48Xu0FBe2nWqfef1KItJphnDtgN7Wnmfxq95Bh3XhRD0G/hDdSMzNopJ7RF3bL0K5sAkpUcHArQOtO2X8jmx5HJeDOpk4bN92moGCtxAJsvDfQFPfMdYfQRPdgX5JRwoYBxr4lbWtapRuS+mb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nCJnhZb6; arc=none smtp.client-ip=91.218.175.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nCJnhZb6"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gEY86cxzkz1jPkG0EfHoRb22XGZVTL36qRBvQHNrtAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791261030; v=1; x=1791865830;
 b=nCJnhZb699bKX/AYg5tIN6oG5due3zh1v1qSPULx4Yoh5+bZY07weDk6GZ2hzzWrJBkhdcco
 E1hnPHQggT+PIXS+NkDiWcGKXXWlbVROFyXoCiL0GyxiAOAT8adPJY1kOS7qzJTLVKKxb+qzWmS
 KPaTsUszYp06j3z+vH0/gR1I=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 348e9ae5c01bf31f;
	Tue, 06 Oct 2026 04:30:27 +0000
X-Mizu-Trace-ID: 348e9ae5c01bf31f
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 04:30:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>

October 6, 2026 at 02:39, "Ping-Ke Shih" <pkshih@realtek.com mailto:pkshi=
h@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wr=
ote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> On Mon Oct 5, 2026 at 8:08 AM CEST, Ping-Ke Shih wrote:
> >  Luka Gejak <luka.gejak@linux.dev> wrote:
> >  [...]
> >  +/*
> >  + * Shares the receive PHY status layout, the SDIO aggregation burst=
 fields
> >  + * and a few baseband registers with the RTL8703B; reuse that heade=
r.
> >  + */
> >  +#include "rtw8703b.h"
> >=20
>=20>  Which layout you are using?
> >  Should you move the layout to rtw8723x.h ?
> >=20
>=20>=20=20
>=20>  The layout I reuse is the RTL8703B receive PHY status structure, s=
truct
> >  phy_status_8703b, together with the SDIO aggregation burst fields an=
d four
> >  baseband registers.
> >=20
>=20Let's use another patch to move the struct out of rtw8703b.h, and ren=
ame
> to phy_status_8723x for example.

Understood, will do.

>=20
>=20>=20
>=20> However, including rtw8703b.h from another chip driver is
> >  already established, rtw8723cs.c includes it to reuse rtw8703b_hw_sp=
ec.
> >=20
>=20As I know, 8723CS and 8723B are mutual alias, no?

As far as I know, they are not. They are different chips.

>=20
>=20>=20
>=20> So I
> >  would rather keep the same include here, and if you want the layout =
in rtw8723x.h
> >  I can send that as a separate patch later, so this series does not t=
ouch
> >  additional 2 drivers.
> >=20
>=20Yes, another patch before this one.=20
>=20

Ok.

> >=20
>=20> +/*
> >  + * Row 20 (-6.0 dB) intentionally does not match the v5.2.17 vendor=
 driver,
> >=20
>=20>  I really don't want to mention vendor driver here. If you really n=
eed it,
> >  mention it in commit message or cover-letter.
> >=20
>=20>  + * which has 0x1c, 0x1a, 0x18, 0x12, 0x0e, 0x08 there. Every othe=
r row agrees.
> >  + * The values below are what rtl8723be, the mainline driver for thi=
s same
> >  + * chip, uses at the same index, and they are also what the vendor'=
s own
> >  + * cck_swing_table_ch1_ch13_92e and the staging rtl8723bs driver us=
e. They
> >  + * also track the 0.5 dB step of the surrounding rows: against row =
32 as 0 dB,
> >  + * 0x1b is within 0.06 of the ideal -6.0 dB value while 0x1c is 0.9=
4 away,
> >  + * the largest error anywhere in the table. Treat the vendor row as=
 the
> >  + * anomaly and do not "fix" this towards it.
> >=20
>=20>  And you have comments each row. Is it still need this block commen=
t to explain?
> >=20
>=20>=20=20
>=20>  I agree, will drop vendor reference and block comment.
> >=20
>=20I'm not sure if LLM writes this? LLM always write verbose comments fo=
r
> each line it added. Just ask LLM to write self-explained code.

No, I wrote it because only 1 row differs from vendor driver and I
thought I should mention it.

>=20
>=20[...]
>=20
>=20>=20
>=20> +
> >  +static const struct rtw_chip_ops rtw8723b_ops =3D {
> >  + .power_on =3D rtw_power_on,
> >  + .power_off =3D rtw_power_off,
> >  +
> >  + .mac_init =3D rtw8723x_mac_init,
> >  + .mac_postinit =3D rtw8723x_mac_postinit,
> >  +
> >  + .dump_fw_crash =3D NULL,
> >  + /*
> >  + * 8723d sets REG_HCI_OPT_CTRL BIT_USB_SUS_DIS in its shutdown
> >  + * function; that is USB-only.
> >  + */
> >  + .shutdown =3D NULL,
> >  + .read_efuse =3D rtw8723b_read_efuse,
> >  + .phy_set_param =3D rtw8723b_phy_set_param,
> >  +
> >  + .set_channel =3D rtw8723b_set_channel,
> >  +
> >  + .query_phy_status =3D rtw8723b_query_phy_status,
> >  + .read_rf =3D rtw_phy_read_rf_sipi,
> >  + .write_rf =3D rtw_phy_write_rf_reg_sipi,
> >  + .set_tx_power_index =3D rtw8723x_set_tx_power_index,
> >  + .rsvd_page_dump =3D NULL,
> >  + .set_antenna =3D NULL,
> >  + .cfg_ldo25 =3D rtw8723b_cfg_ldo25,
> >  + .efuse_grant =3D rtw8723b_efuse_grant,
> >  + .set_ampdu_factor =3D NULL,
> >  + .false_alarm_statistics =3D rtw8723x_false_alarm_statistics,
> >  + .phy_calibration =3D rtw8723b_phy_calibration,
> >  + .dpk_track =3D NULL,
> >  + .cck_pd_set =3D rtw_phy_cck_pd_set,
> >  + .pwr_track =3D rtw8723b_pwr_track,
> >  + .config_bfee =3D NULL,
> >  + .set_gid_table =3D NULL,
> >  + .cfg_csi_rate =3D NULL,
> >  + .adaptivity_init =3D NULL,
> >  + .adaptivity =3D NULL,
> >  + .cfo_init =3D NULL,
> >  + .cfo_track =3D NULL,
> >  + .config_tx_path =3D NULL,
> >  + .config_txrx_mode =3D NULL,
> >  + .led_set =3D NULL,
> >  + .fill_txdesc_checksum =3D rtw8723b_fill_txdesc_checksum,
> >  +
> >  + .coex_set_init =3D rtw8723b_coex_cfg_init,
> >  + .coex_set_ant_switch =3D rtw8723b_coex_cfg_ant_switch,
> >  + .coex_set_gnt_fix =3D rtw8723b_coex_set_gnt_fix,
> >  + .coex_set_gnt_debug =3D rtw8723b_coex_set_gnt_debug,
> >  + .coex_set_rfe_type =3D rtw8723b_coex_set_rfe_type,
> >  + .coex_set_wl_tx_power =3D rtw8723b_coex_set_wl_tx_power,
> >  + .coex_set_wl_rx_gain =3D rtw8723b_coex_set_wl_rx_gain,
> >  +};
> >  +
> >  +const struct rtw_chip_info rtw8723b_hw_spec =3D {
> >  + .ops =3D &rtw8723b_ops,
> >  + .id =3D RTW_CHIP_TYPE_8723B,
> >  + .fw_name =3D "rtw88/rtw8723b_fw.bin",
> >  + .wlan_cpu =3D RTW_WCPU_8051,
> >  + .tx_pkt_desc_sz =3D 40,
> >  + .tx_buf_desc_sz =3D 16,
> >  + .rx_pkt_desc_sz =3D 24,
> >  + .rx_buf_desc_sz =3D 8,
> >  + .phy_efuse_size =3D 512,
> >  + .log_efuse_size =3D 512,
> >  + .ptct_efuse_size =3D 15,
> >  + .txff_size =3D 32768,
> >  + .rxff_size =3D 16384,
> >  + .rsvd_drv_pg_num =3D 8,
> >  + .txgi_factor =3D 1,
> >  + .is_pwr_by_rate_dec =3D true,
> >  + .max_power_index =3D 0x3f,
> >  + .csi_buf_pg_num =3D 0,
> >  + .band =3D RTW_BAND_2G,
> >  + .page_size =3D TX_PAGE_SIZE,
> >  + .dig_min =3D 0x20,
> >  + .usb_tx_agg_desc_num =3D 6,
> >  + /*
> >  + * The firmware reports id 0xfd instead of C2H_HW_FEATURE_REPORT, s=
o
> >  + * the hardware feature report is not supported on this chip.
> >  + */
> >  + .hw_feature_report =3D false,
> >  + .c2h_ra_report_size =3D 4,
> >  + .old_datarate_fb_limit =3D true,
> >  + .path_div_supported =3D false,
> >  + .ht_supported =3D true,
> >  + .vht_supported =3D false,
> >  + .lps_deep_mode_supported =3D 0,
> >  + .sys_func_en =3D 0xfd,
> >  + .pwr_on_seq =3D card_enable_flow_8723b,
> >  + .pwr_off_seq =3D card_disable_flow_8723b,
> >  + .page_table =3D page_table_8723b,
> >  + .rqpn_table =3D rqpn_table_8723b,
> >  + /* same shared table as the sibling rtw8703b and rtw8723d */
> >  + .prioq_addrs =3D &rtw8723x_common.prioq_addrs,
> >  + /* used only in pci.c, not needed for SDIO devices */
> >  + .intf_table =3D NULL,
> >  + .dig =3D rtw8723x_common.dig,
> >  + /* The vendor driver never writes the CCK IGI on this chip. */
> >  + .dig_cck =3D NULL,
> >  + .rf_sipi_addr =3D {0x840, 0x844},
> >  + .rf_sipi_read_addr =3D rtw8723x_common.rf_sipi_addr,
> >  + .fix_rf_phy_num =3D 2,
> >  + /* This chip has no LTE coex registers. */
> >  + .ltecoex_addr =3D NULL,
> >  + .mac_tbl =3D &rtw8723b_mac_tbl,
> >  + .agc_tbl =3D &rtw8723b_agc_tbl,
> >  + .bb_tbl =3D &rtw8723b_bb_tbl,
> >  + .rf_tbl =3D {&rtw8723b_rf_a_tbl},
> >  + .rfe_defs =3D rtw8723b_rfe_defs,
> >  + .rfe_defs_size =3D ARRAY_SIZE(rtw8723b_rfe_defs),
> >  + .iqk_threshold =3D 8,
> >  + .rx_ldpc =3D false,
> >  + .tx_stbc =3D false,
> >  + .ampdu_density =3D IEEE80211_HT_MPDU_DENSITY_16,
> >  + .max_scan_ie_len =3D IEEE80211_MAX_DATA_LEN,
> >  + .coex_para_ver =3D 20180201, /* glcoex_ver_date_8723b_1ant */
> >  + .bt_desired_ver =3D 0x6d,
> >  + .scbd_support =3D false,
> >  + .new_scbd10_def =3D true,
> >  + .ble_hid_profile_support =3D false,
> >  + .wl_mimo_ps_support =3D false,
> >  + .pstdma_type =3D COEX_PSTDMA_FORCE_LPSOFF,
> >  + .bt_rssi_type =3D COEX_BTRSSI_RATIO,
> >  + .ant_isolation =3D 15,
> >  + .rssi_tolerance =3D 2,
> >  + .wl_rssi_step =3D wl_rssi_step_8723b,
> >  + .bt_rssi_step =3D bt_rssi_step_8723b,
> >  + .table_sant_num =3D ARRAY_SIZE(table_sant_8723b),
> >  + .table_sant =3D table_sant_8723b,
> >  + .table_nsant_num =3D ARRAY_SIZE(table_nsant_8723b),
> >  + .table_nsant =3D table_nsant_8723b,
> >  + .tdma_sant_num =3D ARRAY_SIZE(tdma_sant_8723b),
> >  + .tdma_sant =3D tdma_sant_8723b,
> >  + .tdma_nsant_num =3D ARRAY_SIZE(tdma_nsant_8723b),
> >  + .tdma_nsant =3D tdma_nsant_8723b,
> >  + .wl_rf_para_num =3D ARRAY_SIZE(rf_para_tx_8723b),
> >  + .wl_rf_para_tx =3D rf_para_tx_8723b,
> >  + .wl_rf_para_rx =3D rf_para_rx_8723b,
> >  + .bt_afh_span_bw20 =3D 0x20,
>=20>  + .bt_afh_span_bw40 =3D 0x30,
> >  + .afh_5g_num =3D ARRAY_SIZE(afh_5g_8723b),
> >  + .afh_5g =3D afh_5g_8723b,
> >  + /* BTG_SEL is driven by the cardemu_to_act power sequence instead.=
 */
> >  + .btg_reg =3D NULL,
> >  + .coex_info_hw_regs_num =3D 0,
> >  + .coex_info_hw_regs =3D NULL,
> >  +};
> >  +EXPORT_SYMBOL(rtw8723b_hw_spec);
> >=20
>=20>  I guess you copy these two tables from somewhere and modify the va=
lues.
> >  However, when I compare these with RTL8822C's ones. The order is ver=
y
> >  different... Can you align the order?
> >=20
>=20>  Realtek WiFi chips are different from one to another, and we add m=
any
> >  parameters to support the variants. To prevent the order being messe=
d
> >  up, I ask people to add dummy (unused) fields (e.g. .xxx =3D NULL, .=
yyy =3D 0)
> >  to keep the order and consistent. But now, rtw88 becomes very differ=
ent
> >  again.
> >=20
>=20>  Let me know your source, I'd think how we can align them sometime.
> >=20=20
>=20>  I took the ordering from the sibling rtw8703b and rtw8723d drivers=
. rtw8723b_ops
> >  is already in the order of the struct rtw_chip_ops declaration, and =
it follows the
> >  same order as rtw8703b_ops. I believe rtw8822c_ops is the one that d=
iffers, since it
> >  groups the fields by function instead of following the struct.
> >=20
>=20Okay. Please make sure the ordering are the same as the one you copie=
d.=20
>=20
> >=20
>=20> The values were taken
> >  from the v5.2.17 vendor driver and checked against the staging rtl87=
23bs.
> >=20
>=20I have no objection to values.=20
>=20
> >=20
>=20> So I would
> >  prefer to leave both tables as they are. If you want the unused fiel=
ds listed as dummies
> >  to pin the order, I can add them, but the sequence itself would not =
change.
> >=20
>=20I will think a bit how to align these messed tables.=20

I=20understand. I am gonna send v8 today, and do you think that v8 could
be merged, so driver lands in 7.4 release?

Best regards,
Luka Gejak
