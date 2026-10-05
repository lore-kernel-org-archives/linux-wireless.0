Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A28E5474E;
	Mon,  5 Oct 2026 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791180537; cv=none; b=NowGPAAlVaNXLXfe+nMqyD1l8bx8yStXnMpx7mlJQ302goQozQ5hSoonA6n4rD/nX24LTw6ST2kLrKMxgRy3GRBCxU73BGjX9Vayxxr5U1B9qZ05BecEJ/wRf4fNLKul/rtKQerEYjKvyv6heY4V6FOTZ0EVut6/TF1tZgK/eRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791180537; c=relaxed/simple;
	bh=OqrYdfocAV3Ne9xe55PeqM1pTWsjtJqqxrsIySk3Qpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IbOxcBl5nLi2xIskoZbO2L8f74hxD21NM0Wjtgn3FjpvO58aCmB1s/taXBUMmI2j1PQXFV4+qGOA232qeqzs5HA6EqOihiYmyrcOMVpky8dejtc5V2+74sWG5/12j6Tn20zFgvRGBLECGNgDoqQgYS1HnRtpcUZzRqLcYtbibaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GHt+LWub; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GHt+LWub"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69568imN61706503, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791180524; bh=GH18l2PwL1ZlKfwVKhLJ8NhI1vRhmVKb1mguo7/lxw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=GHt+LWub68Z5oIK3oE2uDdAUFl/xHoa/d7j6wndSAqmkzvvHaVAsdBDq+Msb1Qmbx
	 ZggtSuYxC8ceF1gTf0OMx1xfdT1jEhmSGVXnUo+QyLHydSVcwtPTrkAFmeVyTc1zCp
	 F3VntRsuLQyY+0u++C1gEysfv1KBkUp21q6EqHLWpzf9im0JHXNR4OdX1rTXf2WTx7
	 RgPmc7/KLJvmy1SWmrdEJFST0tM9OOKlrXuI0cna8h+CVqTEExJRkY+qGilxmIsp+0
	 0wQywOsgLEEWtIVGAXwOKxKN0gQwNC47MjE6UCALlBOEDhfkiucgb+ZJqbyaX+9AHF
	 SpZg54D3FMfhg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69568imN61706503
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 14:08:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 14:08:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 14:08:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdUkEe+6mTN1t+pkmrNCm0JOCqYbbudRJA
Date: Mon, 5 Oct 2026 06:08:44 +0000
Message-ID: <aa7d919d98304ee095990735f39095ac@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-5-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> power sequences, the efuse layout, the RF and IQ calibration, and the
> chip specific coexistence handling.
>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2550 +++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
>  2 files changed, 2564 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> new file mode 100644
> index 000000000000..8791cd2e0e27
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> @@ -0,0 +1,2550 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) 2026  Realtek Corporation
> + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> + */
> +
> +#include "main.h"
> +#include "coex.h"
> +#include "fw.h"
> +#include "mac.h"
> +#include "phy.h"
> +/*
> + * Shares the receive PHY status layout, the SDIO aggregation burst fiel=
ds
> + * and a few baseband registers with the RTL8703B; reuse that header.
> + */
> +#include "rtw8703b.h"

Which layout you are using?
Should you move the layout to rtw8723x.h ?

> +/*
> + * Row 20 (-6.0 dB) intentionally does not match the v5.2.17 vendor driv=
er,

I really don't want to mention vendor driver here. If you really need it,
mention it in commit message or cover-letter.

> + * which has 0x1c, 0x1a, 0x18, 0x12, 0x0e, 0x08 there. Every other row a=
grees.
> + * The values below are what rtl8723be, the mainline driver for this sam=
e
> + * chip, uses at the same index, and they are also what the vendor's own
> + * cck_swing_table_ch1_ch13_92e and the staging rtl8723bs driver use. Th=
ey
> + * also track the 0.5 dB step of the surrounding rows: against row 32 as=
 0 dB,
> + * 0x1b is within 0.06 of the ideal -6.0 dB value while 0x1c is 0.94 awa=
y,
> + * the largest error anywhere in the table. Treat the vendor row as the
> + * anomaly and do not "fix" this towards it.

And you have comments each row. Is it still need this block comment to expl=
ain?

> + */
> +static const u8 rtw8723b_cck_swing_table_ch1_ch13[][8] =3D {
> +       {0x09, 0x08, 0x07, 0x06, 0x04, 0x03, 0x01, 0x01},       /* 0, -16=
.0dB */
> +       {0x09, 0x09, 0x08, 0x06, 0x05, 0x03, 0x01, 0x01},       /* 1, -15=
.5dB */
> +       {0x0a, 0x09, 0x08, 0x07, 0x05, 0x03, 0x02, 0x01},       /* 2, -15=
.0dB */
> +       {0x0a, 0x0a, 0x09, 0x07, 0x05, 0x03, 0x02, 0x01},       /* 3, -14=
.5dB */
> +       {0x0b, 0x0a, 0x09, 0x08, 0x06, 0x04, 0x02, 0x01},       /* 4, -14=
.0dB */
> +       {0x0b, 0x0b, 0x0a, 0x08, 0x06, 0x04, 0x02, 0x01},       /* 5, -13=
.5dB */
> +       {0x0c, 0x0c, 0x0a, 0x09, 0x06, 0x04, 0x02, 0x01},       /* 6, -13=
.0dB */
> +       {0x0d, 0x0c, 0x0b, 0x09, 0x07, 0x04, 0x02, 0x01},       /* 7, -12=
.5dB */
> +       {0x0d, 0x0d, 0x0c, 0x0a, 0x07, 0x05, 0x02, 0x01},       /* 8, -12=
.0dB */
> +       {0x0e, 0x0e, 0x0c, 0x0a, 0x08, 0x05, 0x02, 0x01},       /* 9, -11=
.5dB */
> +       {0x0f, 0x0f, 0x0d, 0x0b, 0x08, 0x05, 0x03, 0x01},       /* 10, -1=
1.0dB */
> +       {0x10, 0x10, 0x0e, 0x0b, 0x08, 0x05, 0x03, 0x01},       /* 11, -1=
0.5dB */
> +       {0x11, 0x11, 0x0f, 0x0c, 0x09, 0x06, 0x03, 0x01},       /* 12, -1=
0.0dB */
> +       {0x12, 0x12, 0x0f, 0x0c, 0x09, 0x06, 0x03, 0x01},       /* 13, -9=
.5dB */
> +       {0x13, 0x13, 0x10, 0x0d, 0x0a, 0x06, 0x03, 0x01},       /* 14, -9=
.0dB */
> +       {0x14, 0x14, 0x11, 0x0e, 0x0b, 0x07, 0x03, 0x02},       /* 15, -8=
.5dB */
> +       {0x16, 0x15, 0x12, 0x0f, 0x0b, 0x07, 0x04, 0x01},       /* 16, -8=
.0dB */
> +       {0x17, 0x16, 0x13, 0x10, 0x0c, 0x08, 0x04, 0x02},       /* 17, -7=
.5dB */
> +       {0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02},       /* 18, -7=
.0dB */
> +       {0x1a, 0x19, 0x16, 0x12, 0x0d, 0x09, 0x04, 0x02},       /* 19, -6=
.5dB */
> +       {0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02},       /* 20, -6=
.0dB */
> +       {0x1d, 0x1c, 0x18, 0x14, 0x0f, 0x0a, 0x05, 0x02},       /* 21, -5=
.5dB */
> +       {0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02},       /* 22, -5=
.0dB */
> +       {0x20, 0x20, 0x1b, 0x16, 0x11, 0x08, 0x05, 0x02},       /* 23, -4=
.5dB */
> +       {0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02},       /* 24, -4=
.0dB */
> +       {0x24, 0x23, 0x1f, 0x19, 0x13, 0x0c, 0x06, 0x03},       /* 25, -3=
.5dB */
> +       {0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03},       /* 26, -3=
.0dB */
> +       {0x28, 0x28, 0x22, 0x1c, 0x15, 0x0d, 0x07, 0x03},       /* 27, -2=
.5dB */
> +       {0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03},       /* 28, -2=
.0dB */
> +       {0x2d, 0x2d, 0x27, 0x1f, 0x18, 0x0f, 0x08, 0x03},       /* 29, -1=
.5dB */
> +       {0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x03},       /* 30, -1=
.0dB */
> +       {0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04},       /* 31, -0=
.5dB */
> +       {0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04},       /* 32, +0=
dB */
> +};
> +

[...]


> +
> +static void rtw8723b_query_phy_status_cck(struct rtw_dev *rtwdev, u8 *ph=
y_raw,
> +                                         struct rtw_rx_pkt_stat *pkt_sta=
t)
> +{
> +       struct phy_status_8703b *phy_status =3D (struct phy_status_8703b =
*)phy_raw;

nit: Avoid casting by argument 'void *phy_raw'.=20

> +       u8 lna_idx =3D (phy_status->cck_agc_rpt_ofdm_cfosho_a & 0xE0) >> =
5;
> +       u8 vga_idx =3D (phy_status->cck_agc_rpt_ofdm_cfosho_a & 0x1F);

u8_get_bits()

> +       s8 rx_power =3D rtw8723b_cck_rx_power(lna_idx, vga_idx);
> +       s8 min_rx_power =3D -120;
> +
> +       pkt_stat->bw =3D RTW_CHANNEL_WIDTH_20;
> +
> +       pkt_stat->rx_power[RF_PATH_A] =3D rx_power;
> +       pkt_stat->rssi =3D rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1)=
;
> +       pkt_stat->signal_power =3D max(pkt_stat->rx_power[RF_PATH_A],
> +                                    min_rx_power);
> +       rtwdev->dm_info.rssi[RF_PATH_A] =3D pkt_stat->rssi;
> +}
> +
> +static void rtw8723b_query_phy_status_ofdm(struct rtw_dev *rtwdev, u8 *p=
hy_raw,
> +                                          struct rtw_rx_pkt_stat *pkt_st=
at)
> +{
> +       struct phy_status_8703b *phy_status =3D (struct phy_status_8703b =
*)phy_raw;

ditto. (void *phy_raw)

> +
> +static const struct rtw_chip_ops rtw8723b_ops =3D {
> +       .power_on               =3D rtw_power_on,
> +       .power_off              =3D rtw_power_off,
> +
> +       .mac_init               =3D rtw8723x_mac_init,
> +       .mac_postinit           =3D rtw8723x_mac_postinit,
> +
> +       .dump_fw_crash          =3D NULL,
> +       /*
> +        * 8723d sets REG_HCI_OPT_CTRL BIT_USB_SUS_DIS in its shutdown
> +        * function; that is USB-only.
> +        */
> +       .shutdown               =3D NULL,
> +       .read_efuse             =3D rtw8723b_read_efuse,
> +       .phy_set_param          =3D rtw8723b_phy_set_param,
> +
> +       .set_channel            =3D rtw8723b_set_channel,
> +
> +       .query_phy_status       =3D rtw8723b_query_phy_status,
> +       .read_rf                =3D rtw_phy_read_rf_sipi,
> +       .write_rf               =3D rtw_phy_write_rf_reg_sipi,
> +       .set_tx_power_index     =3D rtw8723x_set_tx_power_index,
> +       .rsvd_page_dump         =3D NULL,
> +       .set_antenna            =3D NULL,
> +       .cfg_ldo25              =3D rtw8723b_cfg_ldo25,
> +       .efuse_grant            =3D rtw8723b_efuse_grant,
> +       .set_ampdu_factor       =3D NULL,
> +       .false_alarm_statistics =3D rtw8723x_false_alarm_statistics,
> +       .phy_calibration        =3D rtw8723b_phy_calibration,
> +       .dpk_track              =3D NULL,
> +       .cck_pd_set             =3D rtw_phy_cck_pd_set,
> +       .pwr_track              =3D rtw8723b_pwr_track,
> +       .config_bfee            =3D NULL,
> +       .set_gid_table          =3D NULL,
> +       .cfg_csi_rate           =3D NULL,
> +       .adaptivity_init        =3D NULL,
> +       .adaptivity             =3D NULL,
> +       .cfo_init               =3D NULL,
> +       .cfo_track              =3D NULL,
> +       .config_tx_path         =3D NULL,
> +       .config_txrx_mode       =3D NULL,
> +       .led_set                =3D NULL,
> +       .fill_txdesc_checksum   =3D rtw8723b_fill_txdesc_checksum,
> +
> +       .coex_set_init          =3D rtw8723b_coex_cfg_init,
> +       .coex_set_ant_switch    =3D rtw8723b_coex_cfg_ant_switch,
> +       .coex_set_gnt_fix       =3D rtw8723b_coex_set_gnt_fix,
> +       .coex_set_gnt_debug     =3D rtw8723b_coex_set_gnt_debug,
> +       .coex_set_rfe_type      =3D rtw8723b_coex_set_rfe_type,
> +       .coex_set_wl_tx_power   =3D rtw8723b_coex_set_wl_tx_power,
> +       .coex_set_wl_rx_gain    =3D rtw8723b_coex_set_wl_rx_gain,
> +};
> +
> +const struct rtw_chip_info rtw8723b_hw_spec =3D {
> +       .ops =3D &rtw8723b_ops,
> +       .id =3D RTW_CHIP_TYPE_8723B,
> +       .fw_name =3D "rtw88/rtw8723b_fw.bin",
> +       .wlan_cpu =3D RTW_WCPU_8051,
> +       .tx_pkt_desc_sz =3D 40,
> +       .tx_buf_desc_sz =3D 16,
> +       .rx_pkt_desc_sz =3D 24,
> +       .rx_buf_desc_sz =3D 8,
> +       .phy_efuse_size =3D 512,
> +       .log_efuse_size =3D 512,
> +       .ptct_efuse_size =3D 15,
> +       .txff_size =3D 32768,
> +       .rxff_size =3D 16384,
> +       .rsvd_drv_pg_num =3D 8,
> +       .txgi_factor =3D 1,
> +       .is_pwr_by_rate_dec =3D true,
> +       .max_power_index =3D 0x3f,
> +       .csi_buf_pg_num =3D 0,
> +       .band =3D RTW_BAND_2G,
> +       .page_size =3D TX_PAGE_SIZE,
> +       .dig_min =3D 0x20,
> +       .usb_tx_agg_desc_num =3D 6,
> +       /*
> +        * The firmware reports id 0xfd instead of C2H_HW_FEATURE_REPORT,=
 so
> +        * the hardware feature report is not supported on this chip.
> +        */
> +       .hw_feature_report =3D false,
> +       .c2h_ra_report_size =3D 4,
> +       .old_datarate_fb_limit =3D true,
> +       .path_div_supported =3D false,
> +       .ht_supported =3D true,
> +       .vht_supported =3D false,
> +       .lps_deep_mode_supported =3D 0,
> +       .sys_func_en =3D 0xfd,
> +       .pwr_on_seq =3D card_enable_flow_8723b,
> +       .pwr_off_seq =3D card_disable_flow_8723b,
> +       .page_table =3D page_table_8723b,
> +       .rqpn_table =3D rqpn_table_8723b,
> +       /* same shared table as the sibling rtw8703b and rtw8723d */
> +       .prioq_addrs =3D &rtw8723x_common.prioq_addrs,
> +       /* used only in pci.c, not needed for SDIO devices */
> +       .intf_table =3D NULL,
> +       .dig =3D rtw8723x_common.dig,
> +       /* The vendor driver never writes the CCK IGI on this chip. */
> +       .dig_cck =3D NULL,
> +       .rf_sipi_addr =3D {0x840, 0x844},
> +       .rf_sipi_read_addr =3D rtw8723x_common.rf_sipi_addr,
> +       .fix_rf_phy_num =3D 2,
> +       /* This chip has no LTE coex registers. */
> +       .ltecoex_addr =3D NULL,
> +       .mac_tbl =3D &rtw8723b_mac_tbl,
> +       .agc_tbl =3D &rtw8723b_agc_tbl,
> +       .bb_tbl =3D &rtw8723b_bb_tbl,
> +       .rf_tbl =3D {&rtw8723b_rf_a_tbl},
> +       .rfe_defs =3D rtw8723b_rfe_defs,
> +       .rfe_defs_size =3D ARRAY_SIZE(rtw8723b_rfe_defs),
> +       .iqk_threshold =3D 8,
> +       .rx_ldpc =3D false,
> +       .tx_stbc =3D false,
> +       .ampdu_density =3D IEEE80211_HT_MPDU_DENSITY_16,
> +       .max_scan_ie_len =3D IEEE80211_MAX_DATA_LEN,
> +       .coex_para_ver =3D 20180201,      /* glcoex_ver_date_8723b_1ant *=
/
> +       .bt_desired_ver =3D 0x6d,
> +       .scbd_support =3D false,
> +       .new_scbd10_def =3D true,
> +       .ble_hid_profile_support =3D false,
> +       .wl_mimo_ps_support =3D false,
> +       .pstdma_type =3D COEX_PSTDMA_FORCE_LPSOFF,
> +       .bt_rssi_type =3D COEX_BTRSSI_RATIO,
> +       .ant_isolation =3D 15,
> +       .rssi_tolerance =3D 2,
> +       .wl_rssi_step =3D wl_rssi_step_8723b,
> +       .bt_rssi_step =3D bt_rssi_step_8723b,
> +       .table_sant_num =3D ARRAY_SIZE(table_sant_8723b),
> +       .table_sant =3D table_sant_8723b,
> +       .table_nsant_num =3D ARRAY_SIZE(table_nsant_8723b),
> +       .table_nsant =3D table_nsant_8723b,
> +       .tdma_sant_num =3D ARRAY_SIZE(tdma_sant_8723b),
> +       .tdma_sant =3D tdma_sant_8723b,
> +       .tdma_nsant_num =3D ARRAY_SIZE(tdma_nsant_8723b),
> +       .tdma_nsant =3D tdma_nsant_8723b,
> +       .wl_rf_para_num =3D ARRAY_SIZE(rf_para_tx_8723b),
> +       .wl_rf_para_tx =3D rf_para_tx_8723b,
> +       .wl_rf_para_rx =3D rf_para_rx_8723b,
> +       .bt_afh_span_bw20 =3D 0x20,
> +       .bt_afh_span_bw40 =3D 0x30,
> +       .afh_5g_num =3D  ARRAY_SIZE(afh_5g_8723b),
> +       .afh_5g =3D afh_5g_8723b,
> +       /* BTG_SEL is driven by the cardemu_to_act power sequence instead=
. */
> +       .btg_reg =3D NULL,
> +       .coex_info_hw_regs_num =3D 0,
> +       .coex_info_hw_regs =3D NULL,
> +};
> +EXPORT_SYMBOL(rtw8723b_hw_spec);

I guess you copy these two tables from somewhere and modify the values.
However, when I compare these with RTL8822C's ones. The order is very
different... Can you align the order?

Realtek WiFi chips are different from one to another, and we add many
parameters to support the variants. To prevent the order being messed
up, I ask people to add dummy (unused) fields (e.g. .xxx =3D NULL, .yyy =3D=
 0)
to keep the order and consistent. But now, rtw88 becomes very different
again.=20

Let me know your source, I'd think how we can align them sometime.=20

