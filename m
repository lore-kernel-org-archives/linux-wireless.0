Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56639 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755892Ab0KJN0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:26:04 -0500
Message-ID: <4CDA9D68.3080108@openwrt.org>
Date: Wed, 10 Nov 2010 14:26:00 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] ath9k_hw: Add support for Tx beamforming.
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com> <1289391829-8577-2-git-send-email-vnatarajan@atheros.com> <1289391829-8577-3-git-send-email-vnatarajan@atheros.com> <1289391829-8577-4-git-send-email-vnatarajan@atheros.com> <1289391829-8577-5-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-5-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 1:23 PM, Vivek Natarajan wrote:
> Initialize Tx beamforming capabilities, related registers and set
> descriptors for sounding frames.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/Makefile      |    3 +-
>  drivers/net/wireless/ath/ath9k/ar9003_mac.c  |   80 ++++++-
>  drivers/net/wireless/ath/ath9k/ar9003_mac.h  |   22 ++
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h  |   11 +
>  drivers/net/wireless/ath/ath9k/ar9003_txbf.c |  359 ++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/ar9003_txbf.h |   87 +++++++
>  drivers/net/wireless/ath/ath9k/hw.c          |    3 +
>  drivers/net/wireless/ath/ath9k/hw.h          |   56 ++++
>  drivers/net/wireless/ath/ath9k/mac.h         |   48 ++++-
>  drivers/net/wireless/ath/ath9k/reg.h         |  119 +++++++++-
>  10 files changed, 782 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_txbf.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_txbf.h
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> index 3394dfe..a1fada3 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> @@ -101,6 +101,8 @@
>   */
>  #define AR_PHY_TIMING2_USE_FORCE_PPM    0x00001000
>  #define AR_PHY_TIMING2_FORCE_PPM_VAL    0x00000fff
> +#define AR_PHY_TIMING2_HT_Fine_Timing_EN    0x80000000
> +
>  #define AR_PHY_TIMING3_DSC_MAN      0xFFFE0000
>  #define AR_PHY_TIMING3_DSC_MAN_S    17
>  #define AR_PHY_TIMING3_DSC_EXP      0x0001E000
> @@ -188,6 +190,12 @@
>  #define AR_PHY_RADAR_DC_PWR_THRESH_S    15
>  #define AR_PHY_RADAR_LB_DC_CAP          0x7f800000
>  #define AR_PHY_RADAR_LB_DC_CAP_S        23
> +#define AR_PHY_PERCHAIN_CSD_chn1_2chains    0x0000001f
> +#define AR_PHY_PERCHAIN_CSD_chn1_2chains_S  0
> +#define AR_PHY_PERCHAIN_CSD_chn1_3chains    0x000003e0
> +#define AR_PHY_PERCHAIN_CSD_chn1_3chains_S  5
> +#define AR_PHY_PERCHAIN_CSD_chn2_3chains    0x00007c00
> +#define AR_PHY_PERCHAIN_CSD_chn2_3chains_S  10
>  #define AR_PHY_FIND_SIG_LOW_FIRSTEP_LOW (0x3f << 6)
>  #define AR_PHY_FIND_SIG_LOW_FIRSTEP_LOW_S   6
>  #define AR_PHY_FIND_SIG_LOW_FIRPWR      (0x7f << 12)
Lowercase/Uppercase consistency?

> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_txbf.h b/drivers/net/wireless/ath/ath9k/ar9003_txbf.h
> new file mode 100644
> index 0000000..1b6f5f8
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_txbf.h
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (c) 2008-2010, Atheros Communications Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#ifndef _ATH_AR9000_TxBF_CAL_H_
> +#define _ATH_AR9300_TxBF_CAL_H_
> +
> +#define debugKa     0
> +#define debugRC     0
> +#define debugWinRC  0
???

> +
> +#define NUM_OF_BW   2   /* two bandwidth used for mapping:20M,40M */
> +#define NUM_OF_Ng   3   /* three group define used for mapping :Ng=0,Ng=1,Ng=2*/
> +
> +#define MAX_BITS_PER_SYMBOL 8
> +#define NUM_OF_CHAINMASK (1 << AR9300_MAX_CHAINS)

> +#define BITS_PER_BYTE       8
What's this for?

> +#define BITS_PER_COMPLEX_SYMBOL (2 * BITS_PER_SYMBOL)
> +#define BITS_PER_SYMBOL      10
> +
> +#define MAX_STREAMS 3
> +#define MAX_PILOTS  6
> +#define EVM_MIN     -128
> +
> +#define Tone_40M	114
> +#define Tone_20M	56
> +#define NUM_ITER	8
> +
> +#define Nb_phin		(10-1)
> +#define Nb_coridc	(12-1)
> +#define Nb_sin		(8-1)
> +#define	Nb_ph		5
> +#define	Nb_psi		4
> +#define	NUM_ITER_V	6
> +
> +#define Nb_MHINV	13
> +#define EVM_TH		10
> +#define rc_max		6000
> +#define rc_min		100
> +
> +#define BW_40M      1
> +#define BW_20M_low  2
> +#define BW_20M_up   3
What are those for?

> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_txbf.c b/drivers/net/wireless/ath/ath9k/ar9003_txbf.c
> new file mode 100644
> index 0000000..94a5133
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_txbf.c
> @@ -0,0 +1,359 @@
> +/*
> + * Copyright (c) 2008-2010, Atheros Communications Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#include "hw.h"
> +#include "ar9003_txbf.h"
> +#include "ar9003_phy.h"
> +#include "ar9003_mac.h"
> +/* number of carrier mappings under different bandwidth and grouping, ex:
> + * bw = 1 (40M), Ng=0 (no group), number of carrier = 114*/
> +static u8 const Ns[NUM_OF_BW][NUM_OF_Ng] = {
> +	{56, 30, 16},
> +	{114, 58, 30}
> +};
> +static u8 const Valid_bits[MAX_BITS_PER_SYMBOL] = {
> +	0x1, 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff
> +};
Unused, also rather useless, there are kernel functions for that sort of
thing.

> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 8bebc3e..670a5ca 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -238,6 +238,29 @@ struct ath9k_ops_config {
>  	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
>  	u8 max_txtrig_level;
>  	u16 ani_poll_interval; /* ANI poll interval in ms */
> +	u8    ath_hw_cvtimeout;
> +	u8    ath_hw_txbf_ctl;
> +#define TxBFCtl_ImBF                        0x01
> +#define TxBFCtl_ImBF_S                      0
> +#define TxBFCtl_Non_ExBF                    0x02
> +#define TxBFCtl_Non_ExBF_S                  1
> +#define TxBFCtl_Comp_ExBF                   0x04
> +#define TxBFCtl_Comp_ExBF_S                 2
> +#define TxBFCtl_ImBF_FB                     0x08
> +#define TxBFCtl_ImBF_FB_S                   3
> +#define TxBFCtl_Non_ExBF_Immediately_Rpt    0x10
> +#define TxBFCtl_Non_ExBF_Immediately_Rpt_S  4
> +#define TxBFCtl_Comp_ExBF_Immediately_Rpt   0x20
> +#define TxBFCtl_Comp_ExBF_Immediately_Rpt_S 5
> +
> +#define TxBFCtl_Non_ExBF_delay_Rpt          0x40
> +#define TxBFCtl_Non_ExBF_delay_Rpt_S        6
> +#define TxBFCtl_Comp_ExBF_delay_Rpt         0x80
> +#define TxBFCtl_Comp_ExBF_delay_Rpt_S       7
Why the _S defines? Also, why not just use BIT() instead of the raw hex
values.

> @@ -603,6 +626,28 @@ struct ath_nf_limits {
>  	s16 nominal;
>  };
>  
> +struct hal_txbf_caps {
> +	u8 channel_estimation_cap;
> +	u8 csi_max_rows_bfer;
> +	u8 comp_bfer_antennas;
> +	u8 noncomp_bfer_antennas;
> +	u8 csi_bfer_antennas;
> +	u8 minimal_grouping;
> +	u8 explicit_comp_bf;
> +	u8 explicit_noncomp_bf;
> +	u8 explicit_csi_feedback;
> +	u8 explicit_comp_steering;
> +	u8 explicit_noncomp_steering;
> +	u8 explicit_csi_txbf_capable;
> +	u8 calibration;
> +	u8 implicit_txbf_capable;
> +	u8 tx_ndp_capable;
> +	u8 rx_ndp_capable;
> +	u8 tx_staggered_sounding;
> +	u8 rx_staggered_sounding;
> +	u8 implicit_rx_capable;
> +};
Maybe rename this to ath9k_hw_txbf_caps?

> @@ -955,6 +1002,15 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
>  void ath9k_hw_proc_mib_event(struct ath_hw *ah);
>  void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
>  
> +extern void ar9003_init_txbf(struct ath_hw *ah);
> +extern void ar9003_set_11n_txbf_sounding(struct ath_hw *ah,
> +		void *ds, struct ath9k_11n_rate_series series[],
> +		u8 cec, u16 opt);
> +extern void ar9003_fill_txbf_capabilities(struct ath_hw *ah);
> +extern struct ieee80211_txbf_caps
> +		ar9003_get_txbf_capabilities(struct ath_hw *ah);
> +extern bool ar9300_read_key_cache_mac(struct ath_hw *ah, u16 entry,
> +		u8 *mac);
>  #define ATH_PCIE_CAP_LINK_CTRL	0x70
>  #define ATH_PCIE_CAP_LINK_L0S	1
>  #define ATH_PCIE_CAP_LINK_L1	2
> diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
> index 22907e2..7110506 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.h
> +++ b/drivers/net/wireless/ath/ath9k/mac.h
> @@ -89,7 +89,7 @@
>  #define ATH9K_TX_DATA_UNDERRUN     0x08
>  #define ATH9K_TX_DELIM_UNDERRUN    0x10
>  #define ATH9K_TX_SW_FILTERED       0x80
> -
> +#define ATH9K_TX_BF_ERR		   0xa0
>  /* 64 bytes */
>  #define MIN_TX_FIFO_THRESHOLD   0x1
>  
> @@ -124,6 +124,12 @@ struct ath_tx_status {
>  	u32 evm0;
>  	u32 evm1;
>  	u32 evm2;
> +	u8  ts_txbfstatus;  /* Tx bf status */
> +#define AR_BW_Mismatch      0x1
> +#define AR_Stream_Miss      0x2
> +#define AR_CV_Missed        0x4
> +#define AR_Dest_Miss        0x8
> +#define AR_Expired          0x10
>  };
>  
>  struct ath_rx_status {
> @@ -151,6 +157,11 @@ struct ath_rx_status {
>  	u32 evm2;
>  	u32 evm3;
>  	u32 evm4;
> +	u8 rx_hw_upload_data:1,
> +	   rx_not_sounding:1,
> +	   rx_Ness:2,
> +	   rx_hw_upload_data_valid:1,
> +	   rx_hw_upload_data_type:2;
>  };
>  
>  struct ath_htc_rx_status {
> @@ -263,6 +274,15 @@ struct ath_desc {
>  #define ATH9K_TXDESC_VMF		0x0100
>  #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
>  #define ATH9K_TXDESC_LOWRXCHAIN		0x0400
> +#define ATH9K_TXDESC_TXBF         0x0800  /*for txbf*/
> +#define ATH9K_TXDESC_TXBF_SOUND   0x1000  /* for sounding settings*/
> +#define ATH9K_TXDESC_TXBF_SOUND_S 11
It's just one bit, it doesn't need a _S

> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index fa05b71..3d9914e 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h

> @@ -1816,5 +1849,89 @@ enum {
>  #define AR_PHY_AGC_CONTROL_CLC_SUCCESS		0x00080000  /* carrier leak calibration done */
>  #define AR_PHY_AGC_CONTROL_YCOK_MAX		0x000003c0
>  #define AR_PHY_AGC_CONTROL_YCOK_MAX_S		6
> -
> +#define AR_TXBF_DBG             0x10000
> +
> +#define AR_TXBF          0x10004
> +#define AR_TXBF_CB_TX       0x00000003
> +#define AR_TXBF_CB_TX_S     0
> +#define AR_TXBF_PSI_1_PHI_3         0
> +#define AR_TXBF_PSI_2_PHI_4         1
> +#define AR_TXBF_PSI_3_PHI_5         2
> +#define AR_TXBF_PSI_4_PHI_6         3
> +
> +#define AR_TXBF_NB_TX       0x0000000C
> +#define AR_TXBF_NB_TX_S     2
> +#define AR_TXBF_NUMBEROFBIT_4       0
> +#define AR_TXBF_NUMBEROFBIT_2       1
> +#define AR_TXBF_NUMBEROFBIT_6       2
> +#define AR_TXBF_NUMBEROFBIT_8       3
> +
> +#define AR_TXBF_NG_RPT_TX   0x00000030
> +#define AR_TXBF_NG_RPT_TX_S 4
> +#define AR_TXBF_No_GROUP            0
> +#define AR_TXBF_TWO_GROUP           1
> +#define AR_TXBF_FOUR_GROUP          2
> +
> +#define AR_TXBF_NG_CVCACHE  0x000000C0
> +#define AR_TXBF_NG_CVCACHE_S  6
> +#define AR_TXBF_FOUR_CLIENTS        0
> +#define AR_TXBF_EIGHT_CLIENTS       1
> +#define AR_TXBF_SIXTEEN_CLIENTS     2
> +
> +#define AR_TXBF_TXCV_BFWEIGHT_METHOD 0x00000600
> +#define AR_TXBF_TXCV_BFWEIGHT_METHOD_S 9
> +#define AR_TXBF_NO_WEIGHTING        0
> +#define AR_TXBF_MAX_POWER           1
> +#define AR_TXBF_KEEP_RATIO          2
> +
> +#define AR_TXBF_RLR_EN        0x00000800
> +#define AR_TXBF_RC_20_U_DONE  0x00001000
> +#define AR_TXBF_RC_20_L_DONE  0x00002000
> +#define AR_TXBF_RC_40_DONE        0x00004000
> +#define AR_TXBF_FORCE_UPDATE_V2BB       0x00008000
> +
> +#define AR_TXBF_TIMER            0x10008
> +#define AR_TXBF_TIMER_TIMEOUT     0x000000FF
> +#define AR_TXBF_TIMER_TIMEOUT_S   0
> +#define AR_TXBF_TIMER_ATIMEOUT    0x0000FF00
> +#define AR_TXBF_TIMER_ATIMEOUT_S  8
> +
> +/* for SVD cache update */
> +#define AR_TXBF_SW                     0x1000c
> +#define AR_LRU_ACK                      0x00000001
> +#define AR_LRU_ADDR                     0x000003FE
> +#define AR_LRU_ADDR_S           1
> +#define AR_LRU_EN                       0x00000400
> +#define AR_LRU_EN_S                     11
> +#define AR_DEST_IDX                     0x0007f000
> +#define AR_DEST_IDX_S           12
> +#define AR_LRU_WR_ACK			0x00080000
> +#define AR_LRU_WR_ACK_S			19
> +#define AR_LRU_RD_ACK			0x00100000
> +#define AR_LRU_RD_ACK_S			20
> +
> +#define AR_RC0_0                       0x11000
> +#define AR_RC0(_idx)            (AR_RC0_0+(_idx))
> +#define AR_RC1_0                       0x11200
> +#define AR_RC1(_idx)            (AR_RC1_0+(_idx))
> +
> +#define AR_CVCACHE_0            0x12400
> +#define AR_CVCACHE(_idx)        (AR_CVCACHE_0+(_idx))
> +#define AR_CVCACHE_Ng_IDX       0x0000C000
> +#define AR_CVCACHE_Ng_IDX_S     14
> +#define AR_CVCACHE_BW40         0x00010000
> +#define AR_CVCACHE_BW40_S       16
> +#define AR_CVCACHE_IMPLICIT     0x00020000
> +#define AR_CVCACHE_IMPLICIT_S   17
_S unnecessary here as well

- Felix
