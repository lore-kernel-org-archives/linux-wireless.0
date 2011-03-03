Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44520 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1CCKsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 05:48:52 -0500
Received: by yxs7 with SMTP id 7so316893yxs.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 02:48:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299149205-21439-1-git-send-email-juhosg@openwrt.org>
References: <1299149205-21439-1-git-send-email-juhosg@openwrt.org>
Date: Thu, 3 Mar 2011 11:48:51 +0100
Message-ID: <AANLkTi=cHYkBB2711xAsm476FA5tCc5DFFqCMPUdyp_Z@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: fix whitespace damage in the rt2800 specific code
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 3, 2011 at 11:46 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The rt2800 specific code contains a lots of whitespace damage caused by
> the commit 'rt2x00: Add support for RT5390 chip'.
>
> This patch fixes those whitespace errors.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> [juhosg@idared rt2x00]$ git show cbff7d36bee3d6e7fafcfae2ab1e2ff5f7abbca6 | ./scripts/checkpatch.pl - | tail -n10
> +       { PCI_DEVICE(0x1814, 0x5390), PCI_DEVICE_DATA(&rt2800pci_ops)
> },$
>
> total: 257 errors, 370 warnings, 760 lines checked
>
> NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
>      scripts/cleanfile
>
> Your patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> [juhosg@idared rt2x00]$
>
>  drivers/net/wireless/rt2x00/rt2800.h    |   40 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c |  693 ++++++++++++++++---------------
>  drivers/net/wireless/rt2x00/rt2800pci.c |   14 +-
>  3 files changed, 378 insertions(+), 369 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 6f4a243..70b9abb 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -66,7 +66,7 @@
>  #define RF3320                         0x000b
>  #define RF3322                         0x000c
>  #define RF3853                         0x000d
> -#define RF5390                         0x5390
> +#define RF5390                         0x5390
>
>  /*
>  * Chipset revisions.
> @@ -79,7 +79,7 @@
>  #define REV_RT3071E                    0x0211
>  #define REV_RT3090E                    0x0211
>  #define REV_RT3390E                    0x0211
> -#define REV_RT5390F                    0x0502
> +#define REV_RT5390F                    0x0502
>
>  /*
>  * Signal information.
> @@ -126,9 +126,9 @@
>  /*
>  * AUX_CTRL: Aux/PCI-E related configuration
>  */
> -#define AUX_CTRL               0x10c
> -#define AUX_CTRL_WAKE_PCIE_EN          FIELD32(0x00000002)
> -#define AUX_CTRL_FORCE_PCIE_CLK        FIELD32(0x00000400)
> +#define AUX_CTRL                       0x10c
> +#define AUX_CTRL_WAKE_PCIE_EN          FIELD32(0x00000002)
> +#define AUX_CTRL_FORCE_PCIE_CLK                FIELD32(0x00000400)
>
>  /*
>  * OPT_14: Unknown register used by rt3xxx devices.
> @@ -464,7 +464,7 @@
>  */
>  #define        RF_CSR_CFG                      0x0500
>  #define RF_CSR_CFG_DATA                        FIELD32(0x000000ff)
> -#define RF_CSR_CFG_REGNUM              FIELD32(0x00003f00)
> +#define RF_CSR_CFG_REGNUM              FIELD32(0x00003f00)
>  #define RF_CSR_CFG_WRITE               FIELD32(0x00010000)
>  #define RF_CSR_CFG_BUSY                        FIELD32(0x00020000)
>
> @@ -1746,13 +1746,13 @@ struct mac_iveiv_entry {
>  */
>  #define BBP4_TX_BF                     FIELD8(0x01)
>  #define BBP4_BANDWIDTH                 FIELD8(0x18)
> -#define BBP4_MAC_IF_CTRL               FIELD8(0x40)
> +#define BBP4_MAC_IF_CTRL               FIELD8(0x40)
>
>  /*
>  * BBP 109
>  */
> -#define BBP109_TX0_POWER       FIELD8(0x0f)
> -#define BBP109_TX1_POWER       FIELD8(0xf0)
> +#define BBP109_TX0_POWER               FIELD8(0x0f)
> +#define BBP109_TX1_POWER               FIELD8(0xf0)
>
>  /*
>  * BBP 138: Unknown
> @@ -1765,7 +1765,7 @@ struct mac_iveiv_entry {
>  /*
>  * BBP 152: Rx Ant
>  */
> -#define BBP152_RX_DEFAULT_ANT  FIELD8(0x80)
> +#define BBP152_RX_DEFAULT_ANT          FIELD8(0x80)
>
>  /*
>  * RFCSR registers
> @@ -1776,7 +1776,7 @@ struct mac_iveiv_entry {
>  * RFCSR 1:
>  */
>  #define RFCSR1_RF_BLOCK_EN             FIELD8(0x01)
> -#define RFCSR1_PLL_PD                  FIELD8(0x02)
> +#define RFCSR1_PLL_PD                  FIELD8(0x02)
>  #define RFCSR1_RX0_PD                  FIELD8(0x04)
>  #define RFCSR1_TX0_PD                  FIELD8(0x08)
>  #define RFCSR1_RX1_PD                  FIELD8(0x10)
> @@ -1785,7 +1785,7 @@ struct mac_iveiv_entry {
>  /*
>  * RFCSR 2:
>  */
> -#define RFCSR2_RESCAL_EN               FIELD8(0x80)
> +#define RFCSR2_RESCAL_EN               FIELD8(0x80)
>
>  /*
>  * RFCSR 6:
> @@ -1801,7 +1801,7 @@ struct mac_iveiv_entry {
>  /*
>  * RFCSR 11:
>  */
> -#define RFCSR11_R                      FIELD8(0x03)
> +#define RFCSR11_R                      FIELD8(0x03)
>
>  /*
>  * RFCSR 12:
> @@ -1857,9 +1857,9 @@ struct mac_iveiv_entry {
>  /*
>  * RFCSR 30:
>  */
> -#define RFCSR30_TX_H20M                FIELD8(0x02)
> -#define RFCSR30_RX_H20M                FIELD8(0x04)
> -#define RFCSR30_RX_VCM         FIELD8(0x18)
> +#define RFCSR30_TX_H20M                        FIELD8(0x02)
> +#define RFCSR30_RX_H20M                        FIELD8(0x04)
> +#define RFCSR30_RX_VCM                 FIELD8(0x18)
>  #define RFCSR30_RF_CALIBRATION         FIELD8(0x80)
>
>  /*
> @@ -1871,17 +1871,17 @@ struct mac_iveiv_entry {
>  /*
>  * RFCSR 38:
>  */
> -#define RFCSR38_RX_LO1_EN      FIELD8(0x20)
> +#define RFCSR38_RX_LO1_EN              FIELD8(0x20)
>
>  /*
>  * RFCSR 39:
>  */
> -#define RFCSR39_RX_LO2_EN      FIELD8(0x80)
> +#define RFCSR39_RX_LO2_EN              FIELD8(0x80)
>
>  /*
>  * RFCSR 49:
>  */
> -#define RFCSR49_TX                     FIELD8(0x3f)
> +#define RFCSR49_TX                     FIELD8(0x3f)
>
>  /*
>  * RF registers
> @@ -1918,7 +1918,7 @@ struct mac_iveiv_entry {
>  /*
>  * Chip ID
>  */
> -#define EEPROM_CHIP_ID         0x0000
> +#define EEPROM_CHIP_ID                 0x0000
>
>  /*
>  * EEPROM Version
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index ba87662..55ccb95 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -400,15 +400,15 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>        if (rt2800_wait_csr_ready(rt2x00dev))
>                return -EBUSY;
>
> -       if (rt2x00_is_pci(rt2x00dev)) {
> -               if (rt2x00_rt(rt2x00dev, RT5390)) {
> -                       rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
> -                       rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
> -                       rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
> -                       rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
> -               }
> +       if (rt2x00_is_pci(rt2x00dev)) {
> +               if (rt2x00_rt(rt2x00dev, RT5390)) {
> +                       rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
> +                       rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
> +                       rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
> +                       rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
> +               }
>                rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
> -       }
> +       }
>
>        /*
>         * Disable DMA, will be reenabled later when enabling
> @@ -1595,92 +1595,98 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>  #define RT5390_FREQ_OFFSET_BOUND       0x5f
>
>  static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
> -                                        struct ieee80211_conf *conf,
> -                                        struct rf_channel *rf,
> -                                        struct channel_info *info)
> +                                        struct ieee80211_conf *conf,
> +                                        struct rf_channel *rf,
> +                                        struct channel_info *info)
>  {
> -       u8 rfcsr;
> -       u16 eeprom;
> -
> -       rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
> -       rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
> -       rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
> -       rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
> -       rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
> -
> -       rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
> -       if (info->default_power1 > RT5390_POWER_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
> -       else
> -               rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
> -       rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
> -
> -       rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
> -       rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
> -       rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
> -       rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
> -       rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
> -       rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
> -
> -       rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> -       if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, RT5390_FREQ_OFFSET_BOUND);
> -       else
> -               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
> -       rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> -
> -       rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> -       if (rf->channel <= 14) {
> -               int idx = rf->channel-1;
> -
> -               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
> -                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
> -                               /* r55/r59 value array of channel 1~14 */
> -                               static const char r55_bt_rev[] = {0x83, 0x83,
> -                                       0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
> -                                       0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
> -                               static const char r59_bt_rev[] = {0x0e, 0x0e,
> -                                       0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
> -                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
> -
> -                               rt2800_rfcsr_write(rt2x00dev, 55, r55_bt_rev[idx]);
> -                               rt2800_rfcsr_write(rt2x00dev, 59, r59_bt_rev[idx]);
> -                       } else {
> -                               static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
> -                                       0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
> -                                       0x88, 0x88, 0x86, 0x85, 0x84};
> -
> -                               rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
> -                       }
> -               } else {
> -                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
> -                               static const char r55_nonbt_rev[] = {0x23, 0x23,
> -                                       0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
> -                                       0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
> -                               static const char r59_nonbt_rev[] = {0x07, 0x07,
> -                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
> -                                       0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
> -
> -                               rt2800_rfcsr_write(rt2x00dev, 55, r55_nonbt_rev[idx]);
> -                               rt2800_rfcsr_write(rt2x00dev, 59, r59_nonbt_rev[idx]);
> -                       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> -                               static const char r59_non_bt[] = {0x8f, 0x8f,
> -                                       0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
> -                                       0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
> -
> -                               rt2800_rfcsr_write(rt2x00dev, 59, r59_non_bt[idx]);
> -                       }
> -               }
> -       }
> -
> -       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> -       rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
> -       rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
> -       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -
> -       rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> -       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> -       rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
> +       u8 rfcsr;
> +       u16 eeprom;
> +
> +       rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
> +       rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
> +       rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
> +       rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
> +       if (info->default_power1 > RT5390_POWER_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
> +       else
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
> +       rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
> +       rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> +       if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
> +                                 RT5390_FREQ_OFFSET_BOUND);
> +       else
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
> +       rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> +
> +       rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> +       if (rf->channel <= 14) {
> +               int idx = rf->channel-1;
> +
> +               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
> +                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
> +                               /* r55/r59 value array of channel 1~14 */
> +                               static const char r55_bt_rev[] = {0x83, 0x83,
> +                                       0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
> +                                       0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
> +                               static const char r59_bt_rev[] = {0x0e, 0x0e,
> +                                       0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
> +                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
> +
> +                               rt2800_rfcsr_write(rt2x00dev, 55,
> +                                                  r55_bt_rev[idx]);
> +                               rt2800_rfcsr_write(rt2x00dev, 59,
> +                                                  r59_bt_rev[idx]);
> +                       } else {
> +                               static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
> +                                       0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
> +                                       0x88, 0x88, 0x86, 0x85, 0x84};
> +
> +                               rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
> +                       }
> +               } else {
> +                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
> +                               static const char r55_nonbt_rev[] = {0x23, 0x23,
> +                                       0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
> +                                       0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
> +                               static const char r59_nonbt_rev[] = {0x07, 0x07,
> +                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
> +                                       0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
> +
> +                               rt2800_rfcsr_write(rt2x00dev, 55,
> +                                                  r55_nonbt_rev[idx]);
> +                               rt2800_rfcsr_write(rt2x00dev, 59,
> +                                                  r59_nonbt_rev[idx]);
> +                       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> +                               static const char r59_non_bt[] = {0x8f, 0x8f,
> +                                       0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
> +                                       0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
> +
> +                               rt2800_rfcsr_write(rt2x00dev, 59,
> +                                                  r59_non_bt[idx]);
> +                       }
> +               }
> +       }
> +
> +       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
> +       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +       rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
>  }
>
>  static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
> @@ -1707,8 +1713,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>            rt2x00_rf(rt2x00dev, RF3052) ||
>            rt2x00_rf(rt2x00dev, RF3320))
>                rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
> -       else if (rt2x00_rf(rt2x00dev, RF5390))
> -               rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
> +       else if (rt2x00_rf(rt2x00dev, RF5390))
> +               rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
>        else
>                rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
>
> @@ -1721,14 +1727,15 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>        rt2800_bbp_write(rt2x00dev, 86, 0);
>
>        if (rf->channel <= 14) {
> -               if (!rt2x00_rt(rt2x00dev, RT5390)) {
> -                       if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
> -                               rt2800_bbp_write(rt2x00dev, 82, 0x62);
> -                               rt2800_bbp_write(rt2x00dev, 75, 0x46);
> -                       } else {
> -                               rt2800_bbp_write(rt2x00dev, 82, 0x84);
> -                               rt2800_bbp_write(rt2x00dev, 75, 0x50);
> -                       }
> +               if (!rt2x00_rt(rt2x00dev, RT5390)) {
> +                       if (test_bit(CONFIG_EXTERNAL_LNA_BG,
> +                                    &rt2x00dev->flags)) {
> +                               rt2800_bbp_write(rt2x00dev, 82, 0x62);
> +                               rt2800_bbp_write(rt2x00dev, 75, 0x46);
> +                       } else {
> +                               rt2800_bbp_write(rt2x00dev, 82, 0x84);
> +                               rt2800_bbp_write(rt2x00dev, 75, 0x50);
> +                       }
>                }
>        } else {
>                rt2800_bbp_write(rt2x00dev, 82, 0xf2);
> @@ -2107,8 +2114,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>                if (rt2x00_rt(rt2x00dev, RT3070) ||
>                    rt2x00_rt(rt2x00dev, RT3071) ||
>                    rt2x00_rt(rt2x00dev, RT3090) ||
> -                   rt2x00_rt(rt2x00dev, RT3390) ||
> -                   rt2x00_rt(rt2x00dev, RT5390))
> +                   rt2x00_rt(rt2x00dev, RT3390) ||
> +                   rt2x00_rt(rt2x00dev, RT5390))
>                        return 0x1c + (2 * rt2x00dev->lna_gain);
>                else
>                        return 0x2e + rt2x00dev->lna_gain;
> @@ -2240,10 +2247,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>                rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
>                rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
>                rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x0000001f);
> -       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> -               rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> -               rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> +       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> +               rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> +               rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
>        } else {
>                rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
>                rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> @@ -2619,31 +2626,31 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                     rt2800_wait_bbp_ready(rt2x00dev)))
>                return -EACCES;
>
> -       if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_bbp_read(rt2x00dev, 4, &value);
> -               rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
> -               rt2800_bbp_write(rt2x00dev, 4, value);
> -       }
> +       if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_bbp_read(rt2x00dev, 4, &value);
> +               rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
> +               rt2800_bbp_write(rt2x00dev, 4, value);
> +       }
>
> -       if (rt2800_is_305x_soc(rt2x00dev) ||
> -           rt2x00_rt(rt2x00dev, RT5390))
> +       if (rt2800_is_305x_soc(rt2x00dev) ||
> +           rt2x00_rt(rt2x00dev, RT5390))
>                rt2800_bbp_write(rt2x00dev, 31, 0x08);
>
>        rt2800_bbp_write(rt2x00dev, 65, 0x2c);
>        rt2800_bbp_write(rt2x00dev, 66, 0x38);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 68, 0x0b);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 68, 0x0b);
>
>        if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
>                rt2800_bbp_write(rt2x00dev, 69, 0x16);
>                rt2800_bbp_write(rt2x00dev, 73, 0x12);
> -       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_bbp_write(rt2x00dev, 69, 0x12);
> -               rt2800_bbp_write(rt2x00dev, 73, 0x13);
> -               rt2800_bbp_write(rt2x00dev, 75, 0x46);
> -               rt2800_bbp_write(rt2x00dev, 76, 0x28);
> -               rt2800_bbp_write(rt2x00dev, 77, 0x59);
> +       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_bbp_write(rt2x00dev, 69, 0x12);
> +               rt2800_bbp_write(rt2x00dev, 73, 0x13);
> +               rt2800_bbp_write(rt2x00dev, 75, 0x46);
> +               rt2800_bbp_write(rt2x00dev, 76, 0x28);
> +               rt2800_bbp_write(rt2x00dev, 77, 0x59);
>        } else {
>                rt2800_bbp_write(rt2x00dev, 69, 0x12);
>                rt2800_bbp_write(rt2x00dev, 73, 0x10);
> @@ -2654,8 +2661,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        if (rt2x00_rt(rt2x00dev, RT3070) ||
>            rt2x00_rt(rt2x00dev, RT3071) ||
>            rt2x00_rt(rt2x00dev, RT3090) ||
> -           rt2x00_rt(rt2x00dev, RT3390) ||
> -           rt2x00_rt(rt2x00dev, RT5390)) {
> +           rt2x00_rt(rt2x00dev, RT3390) ||
> +           rt2x00_rt(rt2x00dev, RT5390)) {
>                rt2800_bbp_write(rt2x00dev, 79, 0x13);
>                rt2800_bbp_write(rt2x00dev, 80, 0x05);
>                rt2800_bbp_write(rt2x00dev, 81, 0x33);
> @@ -2667,62 +2674,62 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        }
>
>        rt2800_bbp_write(rt2x00dev, 82, 0x62);
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 83, 0x7a);
> -       else
> -               rt2800_bbp_write(rt2x00dev, 83, 0x6a);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 83, 0x7a);
> +       else
> +               rt2800_bbp_write(rt2x00dev, 83, 0x6a);
>
>        if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
>                rt2800_bbp_write(rt2x00dev, 84, 0x19);
> -       else if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 84, 0x9a);
> +       else if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 84, 0x9a);
>        else
>                rt2800_bbp_write(rt2x00dev, 84, 0x99);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 86, 0x38);
> -       else
> -               rt2800_bbp_write(rt2x00dev, 86, 0x00);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 86, 0x38);
> +       else
> +               rt2800_bbp_write(rt2x00dev, 86, 0x00);
>
>        rt2800_bbp_write(rt2x00dev, 91, 0x04);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 92, 0x02);
> -       else
> -               rt2800_bbp_write(rt2x00dev, 92, 0x00);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 92, 0x02);
> +       else
> +               rt2800_bbp_write(rt2x00dev, 92, 0x00);
>
>        if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
>            rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
>            rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
>            rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
> -           rt2x00_rt(rt2x00dev, RT5390) ||
> +           rt2x00_rt(rt2x00dev, RT5390) ||
>            rt2800_is_305x_soc(rt2x00dev))
>                rt2800_bbp_write(rt2x00dev, 103, 0xc0);
>        else
>                rt2800_bbp_write(rt2x00dev, 103, 0x00);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 104, 0x92);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 104, 0x92);
>
>        if (rt2800_is_305x_soc(rt2x00dev))
>                rt2800_bbp_write(rt2x00dev, 105, 0x01);
> -       else if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 105, 0x3c);
> +       else if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 105, 0x3c);
>        else
>                rt2800_bbp_write(rt2x00dev, 105, 0x05);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 106, 0x03);
> -       else
> -               rt2800_bbp_write(rt2x00dev, 106, 0x35);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 106, 0x03);
> +       else
> +               rt2800_bbp_write(rt2x00dev, 106, 0x35);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> -               rt2800_bbp_write(rt2x00dev, 128, 0x12);
> +       if (rt2x00_rt(rt2x00dev, RT5390))
> +               rt2800_bbp_write(rt2x00dev, 128, 0x12);
>
>        if (rt2x00_rt(rt2x00dev, RT3071) ||
>            rt2x00_rt(rt2x00dev, RT3090) ||
> -           rt2x00_rt(rt2x00dev, RT3390) ||
> -           rt2x00_rt(rt2x00dev, RT5390)) {
> +           rt2x00_rt(rt2x00dev, RT3390) ||
> +           rt2x00_rt(rt2x00dev, RT5390)) {
>                rt2800_bbp_read(rt2x00dev, 138, &value);
>
>                rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
> @@ -2734,41 +2741,42 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 138, value);
>        }
>
> -       if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               int ant, div_mode;
> -
> -               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> -               div_mode = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_ANT_DIVERSITY);
> -               ant = (div_mode == 3) ? 1 : 0;
> -
> -               /* check if this is a Bluetooth combo card */
> -               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> -               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
> -                       u32 reg;
> -
> -                       rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
> -                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
> -                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT6, 0);
> -                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 0);
> -                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 0);
> -                       if (ant == 0)
> -                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 1);
> -                       else if (ant == 1)
> -                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 1);
> -                       rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
> -               }
> -
> -               rt2800_bbp_read(rt2x00dev, 152, &value);
> -               if (ant == 0)
> -                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
> -               else
> -                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
> -               rt2800_bbp_write(rt2x00dev, 152, value);
> -
> -               /* Init frequency calibration */
> -               rt2800_bbp_write(rt2x00dev, 142, 1);
> -               rt2800_bbp_write(rt2x00dev, 143, 57);
> -       }
> +       if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               int ant, div_mode;
> +
> +               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> +               div_mode = rt2x00_get_field16(eeprom,
> +                                             EEPROM_NIC_CONF1_ANT_DIVERSITY);
> +               ant = (div_mode == 3) ? 1 : 0;
> +
> +               /* check if this is a Bluetooth combo card */
> +               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> +               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
> +                       u32 reg;
> +
> +                       rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
> +                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
> +                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT6, 0);
> +                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 0);
> +                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 0);
> +                       if (ant == 0)
> +                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 1);
> +                       else if (ant == 1)
> +                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 1);
> +                       rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
> +               }
> +
> +               rt2800_bbp_read(rt2x00dev, 152, &value);
> +               if (ant == 0)
> +                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
> +               else
> +                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
> +               rt2800_bbp_write(rt2x00dev, 152, value);
> +
> +               /* Init frequency calibration */
> +               rt2800_bbp_write(rt2x00dev, 142, 1);
> +               rt2800_bbp_write(rt2x00dev, 143, 57);
> +       }
>
>        for (i = 0; i < EEPROM_BBP_SIZE; i++) {
>                rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
> @@ -2858,28 +2866,28 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rt(rt2x00dev, RT3071) &&
>            !rt2x00_rt(rt2x00dev, RT3090) &&
>            !rt2x00_rt(rt2x00dev, RT3390) &&
> -           !rt2x00_rt(rt2x00dev, RT5390) &&
> +           !rt2x00_rt(rt2x00dev, RT5390) &&
>            !rt2800_is_305x_soc(rt2x00dev))
>                return 0;
>
>        /*
>         * Init RF calibration.
>         */
> -       if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
> -               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> -               msleep(1);
> -               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
> -               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> -       } else {
> -               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> -               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -               msleep(1);
> -               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> -               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -       }
> +       if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
> +               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> +               msleep(1);
> +               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> +       } else {
> +               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +               msleep(1);
> +               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +       }
>
>        if (rt2x00_rt(rt2x00dev, RT3070) ||
>            rt2x00_rt(rt2x00dev, RT3071) ||
> @@ -2970,87 +2978,87 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
>                rt2800_rfcsr_write(rt2x00dev, 31, 0x00);
>                return 0;
> -       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
> -               rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> -               rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> -               rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
> -               rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> -               rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> -               rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
> -               rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> -               rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
> -               rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
> -
> -               rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> -               rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
> -               rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> -               rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> -
> -               rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> -               rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
> -               rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
> -               rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> -               rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
> -               rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
> -               rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> -
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
> -               rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> -               rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
> -               rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
> -               rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> -               rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 46, 0x7b);
> -               rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> -               rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
> -
> -               rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
> -               rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
> -               rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
> -               rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
> -               rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
> -               rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
> -               rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
> -
> -               rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> -               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> -                       rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
> -               else
> -                       rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
> -               rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
> -               rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
> +       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
> +               rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> +               rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
> +               rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> +               rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> +               rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
> +               rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> +               rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
> +               rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
> +
> +               rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> +               rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
> +               rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> +               rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> +
> +               rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
> +               rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> +               rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
> +               rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
> +               rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> +
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
> +               rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> +               rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
> +               rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
> +               rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> +               rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 46, 0x7b);
> +               rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> +               rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
> +
> +               rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
> +               rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
> +               rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
> +               rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
> +               rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
> +               rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
> +
> +               rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> +               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> +                       rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
> +               else
> +                       rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
> +               rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>        }
>
>        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
> @@ -3104,23 +3112,23 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                        rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
>        }
>
> -       if (!rt2x00_rt(rt2x00dev, RT5390)) {
> -               /*
> -                * Set back to initial state
> -                */
> -               rt2800_bbp_write(rt2x00dev, 24, 0);
> +       if (!rt2x00_rt(rt2x00dev, RT5390)) {
> +               /*
> +                * Set back to initial state
> +                */
> +               rt2800_bbp_write(rt2x00dev, 24, 0);
>
> -               rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
> -               rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
> +               rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
>
> -               /*
> -                * Set BBP back to BW20
> -                */
> -               rt2800_bbp_read(rt2x00dev, 4, &bbp);
> -               rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
> -               rt2800_bbp_write(rt2x00dev, 4, bbp);
> -       }
> +               /*
> +                * Set BBP back to BW20
> +                */
> +               rt2800_bbp_read(rt2x00dev, 4, &bbp);
> +               rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
> +               rt2800_bbp_write(rt2x00dev, 4, bbp);
> +       }
>
>        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
>            rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
> @@ -3132,23 +3140,24 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>        rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
>        rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
>
> -       if (!rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
> -               if (rt2x00_rt(rt2x00dev, RT3070) ||
> -                   rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
> -                   rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
> -                   rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
> -                       if (!test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
> -                               rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
> -               }
> -               rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
> -               if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
> -                       rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> -                                       rt2x00_get_field16(eeprom,
> -                                               EEPROM_TXMIXER_GAIN_BG_VAL));
> -               rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> -       }
> +       if (!rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
> +               if (rt2x00_rt(rt2x00dev, RT3070) ||
> +                   rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
> +                   rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
> +                   rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
> +                       if (!test_bit(CONFIG_EXTERNAL_LNA_BG,
> +                                     &rt2x00dev->flags))
> +                               rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
> +               }
> +               rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
> +               if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
> +                       rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> +                                       rt2x00_get_field16(eeprom,
> +                                               EEPROM_TXMIXER_GAIN_BG_VAL));
> +               rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> +       }
>
>        if (rt2x00_rt(rt2x00dev, RT3090)) {
>                rt2800_bbp_read(rt2x00dev, 138, &bbp);
> @@ -3199,19 +3208,19 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
>        }
>
> -       if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
> -               rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
> +       if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
>
> -               rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
> -               rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
> +               rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
>
> -               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> -               rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
> -               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -       }
> +               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
> +               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +       }
>
>        return 0;
>  }
> @@ -3477,15 +3486,15 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
>
>        /*
> -        * Identify RF chipset by EEPROM value
> -        * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
> -        * RT53xx: defined in "EEPROM_CHIP_ID" field
> +        * Identify RF chipset by EEPROM value
> +        * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
> +        * RT53xx: defined in "EEPROM_CHIP_ID" field
>         */
>        rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
> -       if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390)
> -               rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
> -       else
> -               value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
> +       if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390)
> +               rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
> +       else
> +               value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
>
>        rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
>                        value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
> @@ -3497,8 +3506,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rt(rt2x00dev, RT3071) &&
>            !rt2x00_rt(rt2x00dev, RT3090) &&
>            !rt2x00_rt(rt2x00dev, RT3390) &&
> -           !rt2x00_rt(rt2x00dev, RT3572) &&
> -           !rt2x00_rt(rt2x00dev, RT5390)) {
> +           !rt2x00_rt(rt2x00dev, RT3572) &&
> +           !rt2x00_rt(rt2x00dev, RT5390)) {
>                ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>                return -ENODEV;
>        }
> @@ -3512,8 +3521,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rf(rt2x00dev, RF3021) &&
>            !rt2x00_rf(rt2x00dev, RF3022) &&
>            !rt2x00_rf(rt2x00dev, RF3052) &&
> -           !rt2x00_rf(rt2x00dev, RF3320) &&
> -           !rt2x00_rf(rt2x00dev, RF5390)) {
> +           !rt2x00_rf(rt2x00dev, RF3320) &&
> +           !rt2x00_rf(rt2x00dev, RF5390)) {
>                ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
>                return -ENODEV;
>        }
> @@ -3810,8 +3819,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>                   rt2x00_rf(rt2x00dev, RF2020) ||
>                   rt2x00_rf(rt2x00dev, RF3021) ||
>                   rt2x00_rf(rt2x00dev, RF3022) ||
> -                  rt2x00_rf(rt2x00dev, RF3320) ||
> -                  rt2x00_rf(rt2x00dev, RF5390)) {
> +                  rt2x00_rf(rt2x00dev, RF3320) ||
> +                  rt2x00_rf(rt2x00dev, RF5390)) {
>                spec->num_channels = 14;
>                spec->channels = rf_vals_3x;
>        } else if (rt2x00_rf(rt2x00dev, RF3052)) {
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index b74a9d7..07a8c57 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -493,12 +493,12 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
>        rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
>        rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390)) {
> -               rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
> -               rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
> -               rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
> -               rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
> -       }
> +       if (rt2x00_rt(rt2x00dev, RT5390)) {
> +               rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
> +               rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
> +               rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
> +               rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
> +       }
>
>        rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
>
> @@ -1132,7 +1132,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>        { PCI_DEVICE(0x1814, 0x3593), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  #endif
>  #ifdef CONFIG_RT2800PCI_RT53XX
> -       { PCI_DEVICE(0x1814, 0x5390), PCI_DEVICE_DATA(&rt2800pci_ops) },
> +       { PCI_DEVICE(0x1814, 0x5390), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  #endif
>        { 0, }
>  };
> --
> 1.7.2.1
>
>



-- 
---
Gertjan
