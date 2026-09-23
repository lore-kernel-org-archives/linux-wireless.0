Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5C134CCF;
	Wed, 23 Sep 2026 08:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152270; cv=none; b=MuEiGHirPBvq2X721Y4GSuZmfKBVw3CbaVAAfjlMWZJ8+z/cdnlunHeudyDR5aDOicddY93stnt5KmrMvrbd78pvvAmWC2JOVVgTQQZ2FMmr3yLn86c5F0cEeeyslExcZFC7yl7Lk3xSVmEEbP2i9T495MRC6g3Hh4XwB1vMXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152270; c=relaxed/simple;
	bh=v2h39OQVEP7oKHia2lSFV3FTj37hfeXP4B+8hZYIGUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vAfvgjbhsTJwH3TbImFFT2hqG8zcvaqOgBC5hQAbopulL/PVpeumChbX4uvuY+ScPidDdc8n4PVG/+BNwBtGX6d/Grdl/uub297AlXGFJJoHkXDJY5g/9sQiiVKnm4NrZ7ug6JkN//Iuml5O/lJJMV1ntjcOBCTPRcqOnRg3veU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=el0YU8zx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="el0YU8zx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N8UweU6159804, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790152258; bh=UAT4pz++wwTmP3HpdwWj1Fy+TdP2ofM0ilI2HfWlfYU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=el0YU8zxBNFqqqp5Dh4YcL91e1VCw7l2pHvxtzc4CZ2WDWysE1VP6RcgujW3h04DY
	 eOICDI5rJVlFf+TlGR9wxrVTnx3C4jH0Mr32dQ4gydAqkTG1+msAuWbHHwH9qQ5PE3
	 skOHVI3vcBatwQZ0HzgSkJx0/eSk6Ghj2GJSDq4uxfIarDjE0gN8oJpmc3tU13teNK
	 ieZKCYJgjjD12j2UZWU1NxSNcSTBf5FNGZLmCVX+ysn27hwv90IEVedteV2GQdGEfQ
	 ZreA2cAQBegWx/J7Pjf9vLF/qmfva5jj1oIxh4iU3B4KyKQhqTMH45mp6fJfgRLJMb
	 C1hGyFe/2dCdA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N8UweU6159804
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 16:30:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 16:30:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 16:30:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
Thread-Topic: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
Thread-Index: AQHdSeAWPTTocmDvm0SCIQejTVX877bbzMuQ
Date: Wed, 23 Sep 2026 08:30:57 +0000
Message-ID: <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
In-Reply-To: <20260921154347.82317-4-luka.gejak@linux.dev>
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
> This depends on the shared core handling sent as a separate series,
> "wifi: rtw88: preparations for RTL8723B/RTL8723BS". The driver is not
> built yet; the Kconfig and Makefile entries follow.

No need this paragraph.

>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2938 +++++++++++++++++

As LOC is large, I think I can't address all flaws in single one review
iteration. Please also review patches yourself before sending out.
I think you're quite experienced now.

>  drivers/net/wireless/realtek/rtw88/rtw8723b.h |   12 +
>  2 files changed, 2950 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> new file mode 100644
> index 000000000000..9e53ba49def3
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> @@ -0,0 +1,2938 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/*
> + * Copyright(c) 2007-2017  Realtek Corporation
> + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> + */
> +
> +#include <linux/unaligned.h>
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
> +#include "rtw8723b.h"
> +#include "rtw8723b_table.h"
> +#include "sdio.h"
> +#include "tx.h"

In increasing alphabet order.=20

[...]

> +/* 0x03a05611 is the normal RX path (staging and the BB table agree);
> + * 0x03a05600 is only an IQK temporary value and must not be reasserted.
> + */

Keep first line of block comment blank.

> +#define WLAN_RX_PATH_A_8723B                   0x03a05611
> +
> +#define ADDA_ON_VAL_8723B                      0x01c00014
> +
> +#define MASK_NETTYPE   0x30000
> +#define _NETTYPE(x)    (((x) & 0x3) << 16)
> +#define NT_LINK_AP     0x2

The PORT_SET_NET_TYPE in rtw_vif_port_config() does similar thing=20
relying on ``` static const struct rtw_vif_port rtw_vif_port[]```.

Is that not suitable for RTL8723B? If so, should the common flow
avoid RTL8723B?

> +
> +#define WLAN_RX_FILTER0                        0xFFFF
> +#define WLAN_RX_FILTER1                        0x400
> +#define WLAN_RX_FILTER2                        0xFFFF
> +/* Keep BIT_APP_FCS: rtw88 advertises RX_INCLUDES_FCS for every chip, an=
d
> + * without it mac80211 trims four bytes of real frame data.
> + */

Please review block comment style. (I'd not point out this afterward)

[...]

> +
> +static const struct rtw_pwr_seq_cmd trans_pre_enable_8723b[] =3D {
> +       /* unlock ISO/CLK/power control register */
> +       {REG_RSV_CTRL,
> +        RTW_PWR_CUT_ALL_MSK,
> +        RTW_PWR_INTF_ALL_MSK,
> +        RTW_PWR_ADDR_MAC,
> +        RTW_PWR_CMD_WRITE, 0xff, 0},
> +

Not prefer the blank line. (apply this rule to tables below)

> +       {TRANS_SEQ_END},
> +};
> +

[...]

> +
> +static void rtw8723b_efuse_grant(struct rtw_dev *rtwdev, bool on)
> +{
> +       /*
> +        * This chip wraps the common efuse power switch in a BT power cu=
t
> +        * (0x6A[14] =3D 1) when granting access and a BT output isolatio=
n
> +        * (0x6A[15] =3D 1) when releasing it.
> +        */
> +       rtw_write8_set(rtwdev, 0x6b, on ? BIT(6) : BIT(7));

By comment above, I guess you can give proper names for 0x6b and bit 6 and =
7.

> +
> +       rtw8723x_efuse_grant(rtwdev, on);
> +}
> +

[...]

> +static u8 rtw8723b_default_ofdm_index(struct rtw_dev *rtwdev)
> +{
> +       u8 i;
> +       u32 val32;
> +       u32 swing;

Reverse x'mas tree order. (Please apply to whole patchset)

> +
> +       swing =3D rtw_read32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE, =
0xffc00000);
> +
> +       for (i =3D 0; i < RTW_OFDM_SWING_TABLE_SIZE; i++) {
> +               val32 =3D rtw8723b_ofdm_swing_table[i];
> +
> +               if (val32 >=3D 0x100000)
> +                       val32 >>=3D 22;

I think shift 22 bits because of 0xffc00000.=20

Add a name for 0xffc00000 and use __ffs() to get the shift.

> +
> +               if (val32 =3D=3D swing)
> +                       break;
> +       }
> +
> +       if (i >=3D RTW_OFDM_SWING_TABLE_SIZE)
> +               i =3D 30;

A comment for 30.

/* 30, +0dB */

> +
> +       return i;
> +}
> +
> +static u8 rtw8723b_default_cck_index(struct rtw_dev *rtwdev)
> +{
> +       u8 i;
> +       u8 swing;
> +
> +       swing =3D rtw_read8(rtwdev, rtw8723b_cck_pwr_regs[0]);
> +
> +       for (i =3D 0; i < RTW_CCK_SWING_TABLE_SIZE; i++) {
> +               if (rtw8723b_cck_swing_table_ch1_ch13[i][0] =3D=3D swing)
> +                       break;
> +       }
> +
> +       if (i >=3D RTW_CCK_SWING_TABLE_SIZE)
> +               i =3D 20;

A comment for 20.

> +
> +       return i;
> +}
> +
> +static void rtw8723b_pwrtrack_init(struct rtw_dev *rtwdev)
> +{
> +       struct rtw_dm_info *dm_info =3D &rtwdev->dm_info;
> +       u8 path;
> +
> +       dm_info->default_ofdm_index =3D rtw8723b_default_ofdm_index(rtwde=
v);
> +       dm_info->default_cck_index =3D rtw8723b_default_cck_index(rtwdev)=
;
> +
> +       /* Clear the OFDM remnant per path: tracking keeps one per path. =
*/
> +       for (path =3D RF_PATH_A; path < rtwdev->hal.rf_path_num; path++) =
{
> +               ewma_thermal_init(&dm_info->avg_thermal[path]);
> +               dm_info->delta_power_index[path] =3D 0;
> +               dm_info->txagc_remnant_ofdm[path] =3D 0;
> +       }
> +       dm_info->pwr_trk_triggered =3D false;
> +       dm_info->pwr_trk_init_trigger =3D true;
> +       dm_info->thermal_meter_k =3D rtwdev->efuse.thermal_meter_k;
> +       dm_info->txagc_remnant_cck =3D 0;
> +}
> +
> +static bool rtw8723b_sdio_needs_rx_path_fix(struct rtw_dev *rtwdev)

What does it mean?

In many places using this function are not RX path.

> +{
> +       return rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_SDIO;
> +}
> +

[...]

> +static void rtw8723b_phy_bb_config(struct rtw_dev *rtwdev)
> +{
> +       u8 xtal_cap;
> +
> +       /* Enable BB and RF */
> +       rtw_write16_set(rtwdev, REG_SYS_FUNC_EN,
> +                       BIT_FEN_EN_25_1 | BIT_FEN_BB_GLB_RST | BIT_FEN_BB=
_RSTB);
> +
> +       if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_USB)
> +               rtw_write32(rtwdev, REG_BB_SEL_BTG, 0x0);
> +       else
> +               rtw_write32(rtwdev, REG_BB_SEL_BTG, 0x280);
> +
> +       /* Full write: preserving spuriously set bits can wedge the RF bu=
s. */
> +       rtw_write8(rtwdev, REG_RF_CTRL,
> +                  BIT_RF_EN | BIT_RF_RSTB | BIT_RF_SDM_RSTB);
> +       usleep_range(1000, 1100);

just fsleep() ?

> +       rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
> +       rtw_write8(rtwdev, REG_SYS_FUNC_EN,
> +                  BIT_FEN_PPLL | BIT_FEN_PCIEA | BIT_FEN_DIO_PCIE |
> +                  BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB);
> +       rtw_write8(rtwdev, REG_AFE_CTRL1 + 1, 0x80);
> +
> +       xtal_cap =3D rtwdev->efuse.crystal_cap & 0x3f;
> +       rtw_write32_mask(rtwdev,  REG_AFE_CTRL3, BIT_MASK_XTAL,
> +                        xtal_cap | (xtal_cap << 6));
> +}
> +

[...]

> +
> +static void rtw8723b_phy_rf6052_config(struct rtw_dev *rtwdev)
> +{
> +       struct rtw_hal *hal =3D &rtwdev->hal;
> +       u32 intf_s, intf_oe, hssi_2;
> +       u32 val32, mask;
> +       u8 path;
> +
> +       for (path =3D RF_PATH_A; path < hal->rf_path_num; path++) {

[...]

> +       }
> +
> +       /* 3 Configuration of Tx Power Tracking */

This comment looks weird.

> +}
> +

[...]

> +
> +static void rtw8723b_init_network_type(struct rtw_dev *rtwdev)
> +{
> +       u32 val32;
> +
> +       val32 =3D rtw_read32(rtwdev, REG_CR);
> +       val32 =3D (val32 & ~MASK_NETTYPE) | _NETTYPE(NT_LINK_AP);
> +       rtw_write32(rtwdev, REG_CR, val32);

This is what I point above. Please reconsider this.

> +}
> +


> +static void rtw8723b_init_wmac_setting(struct rtw_dev *rtwdev)
> +{
> +       /* Override the default rcr filter for 8723B */
> +       rtwdev->hal.rcr =3D WLAN_RCR_CFG;

Why? The default value doesn't work to RTL8723B?

	rtwdev->hal.rcr =3D BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
			  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
			  BIT_AB | BIT_AM | BIT_APM;


> +       rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
> +
> +       rtw_write32(rtwdev, REG_MAR, 0xffffffff);
> +       rtw_write32(rtwdev, REG_MAR + 4, 0xffffffff);
> +
> +       rtw_write16(rtwdev, REG_RXFLTMAP2, WLAN_RX_FILTER2);
> +       rtw_write16(rtwdev, REG_RXFLTMAP1, WLAN_RX_FILTER1);
> +       rtw_write16(rtwdev, REG_RXFLTMAP0, WLAN_RX_FILTER0);
> +}
> +

[...]

> +
> +static void rtw8723b_init_antenna_selection(struct rtw_dev *rtwdev)
> +{
> +       /* BIT(7) lets the 8051 control antenna selection, BIT(1) is LED2=
_CM. */

Just define names for these bits?

> +       rtw_write8(rtwdev, REG_LEDCFG2, BIT(7) | BIT(1));
> +}
> +

[...]

> +static void rtw8723b_phy_set_param(struct rtw_dev *rtwdev)
> +{
> +       const struct rtw_chip_info *chip =3D rtwdev->chip;
> +       u32 val32;
> +
> +       rtw8723b_post_enable_flow(rtwdev);
> +
> +       rtw_load_table(rtwdev, chip->mac_tbl);
> +       rtw8723b_phy_bb_config(rtwdev);
> +       rtw8723b_phy_load_bb_tables(rtwdev);
> +       rtw8723b_phy_rf_config(rtwdev);
> +
> +       /* enable CCK and OFDM block */
> +       rtw_write32_set(rtwdev, REG_FPGA0_RFMOD, BIT_CCKEN | BIT_OFDMEN);
> +
> +       rtw8723b_init_tx_buffer_boundary(rtwdev);
> +       rtw8723b_init_page_boundary(rtwdev);
> +       rtw8723b_init_transfer_page_size(rtwdev);
> +       rtw8723b_init_driver_info_size(rtwdev);
> +       rtw8723b_init_network_type(rtwdev);
> +
> +       rtw8723b_init_wmac_setting(rtwdev);
> +
> +       rtw8723b_init_adaptive_ctrl(rtwdev);
> +       rtw8723b_init_edca(rtwdev);
> +       rtw8723b_init_retry_function(rtwdev);

So RTL8723B is very different from existing chips?

[...]

> +static void rtw8723b_reassert_rx_path(struct rtw_dev *rtwdev)
> +{
> +       u32 rf_wlint_before;
> +       u32 rx_path_before;
> +       u32 fpga0_before;
> +       u8 sys_func_before;
> +       u8 rf_ctrl_before;

Reverse X'mas tree

> +
> +       if (!rtw8723b_sdio_needs_rx_path_fix(rtwdev))
> +               return;
> +
> +       sys_func_before =3D rtw_read8(rtwdev, REG_SYS_FUNC_EN);
> +       rf_ctrl_before =3D rtw_read8(rtwdev, REG_RF_CTRL);
> +       fpga0_before =3D rtw_read32(rtwdev, REG_FPGA0_RFMOD);
> +       rx_path_before =3D rtw_read32(rtwdev, REG_BB_RX_PATH_11N);
> +       rf_wlint_before =3D rtw_read_rf(rtwdev, RF_PATH_A, RF_WLINT, RFRE=
G_MASK);
> +
> +       if ((sys_func_before & WLAN_SYS_FUNC_BB_ENABLE) !=3D
> +           WLAN_SYS_FUNC_BB_ENABLE) {
> +               rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
> +                              WLAN_SYS_FUNC_BB_ENABLE);
> +       }

No need brace for single line branch. (apply this to whole patches)

[...]

> +const struct rtw_chip_info rtw8723b_hw_spec =3D {

Please take rtw8822c_hw_spec as template to align the style including
blank lines and order.

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
> +
> +       .txff_size =3D 32768,
> +       .rxff_size =3D 16384,
> +       .rsvd_drv_pg_num =3D 8,
> +
> +       .txgi_factor =3D 1,
> +       .is_pwr_by_rate_dec =3D true,
> +       .rx_ldpc =3D false,
> +       .tx_stbc =3D false,
> +
> +       .max_power_index =3D 0x3f,
> +
> +       .csi_buf_pg_num =3D 0,
> +       .band =3D RTW_BAND_2G,
> +       .page_size =3D TX_PAGE_SIZE,
> +
> +       .dig_min =3D 0x20,
> +       .usb_tx_agg_desc_num =3D 1,
> +
> +       /*
> +        * The firmware reports id 0xfd instead of C2H_HW_FEATURE_REPORT,=
 so
> +        * the hardware feature report is not supported on this chip.
> +        */
> +       .hw_feature_report =3D false,
> +
> +       .c2h_ra_report_size =3D 4,        /* rtw88/rtw8723b_fw.bin v41 em=
its the
> +                                        * legacy 8051 4-byte rate report
> +                                        * (rate_sgi, mac_id, byte2, stat=
us).
> +                                        * Setting this to 7, like the up=
stream
> +                                        * default, caused every C2H_RA_R=
EPORT
> +                                        * to be dropped with
> +                                        * "short ra report c2h length 4
> +                                        * expected 7" on every connect a=
ttempt
> +                                        * so the firmware-driven rate ad=
aptation
> +                                        * feedback path
> +                                        * never updated si->ra_report. T=
he
> +                                        * legacy 8051 8723b/8703b/8723d =
firmware
> +                                        * uses the same 4-byte format as=
 the
> +                                        * older 8821a/8812a chips. byte4=
..bw fall
> +                                        * back to the per-station defaul=
ts in
> +                                        * rtw_fw_ra_report_iter(), which=
 matches
> +                                        * what those chips already do sa=
fely.
> +                                        */

I don't know if these comment is actually useful for people?

> +       /* See commit c7706b1173c7 ("wifi: rtw88: Enable data rate fallba=
ck for
> +        * older chips").
> +        */

Why do you need this? Just by 'git blame' ?

> +       .old_datarate_fb_limit =3D true,
> +
> +       .path_div_supported =3D false,
> +       .ht_supported =3D true,
> +       .vht_supported =3D false,
> +       .lps_deep_mode_supported =3D 0,
> +
> +       .sys_func_en =3D 0xfd,
> +       .pwr_on_seq =3D card_enable_flow_8723b,
> +       .pwr_off_seq =3D card_disable_flow_8723b,
> +       .page_table =3D page_table_8723b,
> +
> +       .rqpn_table =3D rqpn_table_8723b,
> +       /* same shared table as the sibling rtw8703b and rtw8723d */
> +       .prioq_addrs =3D &rtw8723x_common.prioq_addrs,
> +
> +       /* used only in pci.c, not needed for SDIO devices */
> +       .intf_table =3D NULL,
> +
> +       .dig =3D rtw8723x_common.dig,
> +       .dig_cck =3D rtw8723x_common.dig_cck,
> +
> +       .rf_sipi_addr =3D {0x840, 0x844},
> +       .rf_sipi_read_addr =3D rtw8723x_common.rf_sipi_addr,
> +
> +       .fix_rf_phy_num =3D 2,
> +
> +       /* This chip has no LTE coex registers. */
> +       .ltecoex_addr =3D NULL,
> +
> +       .mac_tbl =3D &rtw8723b_mac_tbl,
> +       .agc_tbl =3D &rtw8723b_agc_tbl,
> +       .bb_tbl =3D &rtw8723b_bb_tbl,
> +       .rf_tbl =3D {&rtw8723b_rf_a_tbl},
> +
> +       .rfe_defs =3D rtw8723b_rfe_defs,
> +       .rfe_defs_size =3D ARRAY_SIZE(rtw8723b_rfe_defs),
> +       .iqk_threshold =3D 8,
> +       .ampdu_density =3D IEEE80211_HT_MPDU_DENSITY_16,
> +       .max_scan_ie_len =3D IEEE80211_MAX_DATA_LEN,
> +
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
> +
> +       .coex_info_hw_regs_num =3D 0,
> +       .coex_info_hw_regs =3D NULL,
> +};
> +EXPORT_SYMBOL(rtw8723b_hw_spec);
> +
> +MODULE_FIRMWARE("rtw88/rtw8723b_fw.bin");
> +
> +MODULE_AUTHOR("Luka Gejak <luka.gejak@linux.dev>");
> +MODULE_AUTHOR("Michael Straube <straube.linux@gmail.com>");
> +MODULE_DESCRIPTION("Realtek 802.11n wireless 8723b driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.h
> b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
> new file mode 100644
> index 000000000000..2fe00e709620
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> +/* Copyright(c) 2018-2019  Realtek Corporation

Please let copyright consistent.=20

> + */
> +
> +#ifndef __RTW8723B_H__
> +#define __RTW8723B_H__
> +
> +#include "rtw8723x.h"
> +
> +extern const struct rtw_chip_info rtw8723b_hw_spec;
> +
> +#endif
> --
> 2.55.0

