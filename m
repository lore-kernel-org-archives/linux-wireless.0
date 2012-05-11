Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53262 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2EKMFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 08:05:09 -0400
Received: by lbbgm6 with SMTP id gm6so1821924lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 05:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335493323-3448-1-git-send-email-Woody.Hung@mediatek.com>
References: <1335493323-3448-1-git-send-email-Woody.Hung@mediatek.com>
Date: Fri, 11 May 2012 14:05:06 +0200
Message-ID: <CAL1gcdPnKvy+paZsWvdfBHTY10Q-hOgHvJY+UDWNCGQO8fOChg@mail.gmail.com> (sfid-20120511_140517_342366_82C0D3BB)
Subject: Re: [PATCH] rt2x00 : RT3290 chip support
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jay.hung@mediatek.com, pohsun.yang@mediatek.com,
	dennis.lee@mediatek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Woody,

On Fri, Apr 27, 2012 at 4:22 AM, Woody Hung <Woody.Hung@mediatek.com> wrote:
> This support RT3290 chip
>
> Signed-off-by: Woody Hung <Woody.Hung@mediatek.com>

I'm sorry for the late review. I couldn't find time sooner to look at this.

See further down for a number of comments to your patch.

> ---
>  drivers/net/wireless/rt2x00/Kconfig     |    8 +
>  drivers/net/wireless/rt2x00/rt2800.h    |  120 +++++++++-
>  drivers/net/wireless/rt2x00/rt2800lib.c |  395 ++++++++++++++++++++++++++++--
>  drivers/net/wireless/rt2x00/rt2800lib.h |    3 +-
>  drivers/net/wireless/rt2x00/rt2800pci.c |   12 +
>  drivers/net/wireless/rt2x00/rt2800pci.h |    3 +
>  drivers/net/wireless/rt2x00/rt2x00.h    |    3 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    6 +
>  8 files changed, 520 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 299c387..c7548da 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -99,6 +99,14 @@ config RT2800PCI_RT53XX
>          rt2800pci driver.
>          Supported chips: RT5390
>
> +config RT2800PCI_RT3290
> +       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL
> +       default y
> +       ---help---
> +         This adds support for rt3290 wireless chipset family to the
> +         rt2800pci driver.
> +         Supported chips: RT3290
>  endif
>
>  config RT2500USB
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index d91f4f6..39b1685 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -70,7 +70,7 @@
>  #define RF5370                         0x5370
>  #define RF5372                         0x5372
>  #define RF5390                         0x5390
> -
> +#define RF3290                         0x3290
>  /*
>  * Chipset revisions.
>  */

Please add the define in the right numerical order. It just looks
nicer when things are in numerical order.

> @@ -112,6 +112,12 @@
>  * Registers.
>  */
>
> +
> +/*
> + * MAC_CSR0_3290: MAC_CSR0 for rt3290 to identity MAC version number.
> + */
> +#define MAC_CSR0_3290                          0x0000
> +
>  /*
>  * E2PROM_CSR: PCI EEPROM control register.
>  * RELOAD: Write 1 to reload eeprom content.
> @@ -305,6 +311,118 @@
>  #define GPIO_CTRL_CFG_GPIOD_BIT7       FIELD32(0x00008000)
>
>  /*
> + * WLAN_CTRL_CFG
> + */
> +#define WLAN_FUN_CTRL                  0x80
> +#define WLAN_EN                                FIELD32(0x00000001)
> +#define WLAN_CLK_EN                    FIELD32(0x00000002)
> +#define WLAN_RSV1                      FIELD32(0x00000004)
> +#define WLAN_RESET                     FIELD32(0x00000008)
> +#define PCIE_APP0_CLK_REQ              FIELD32(0x00000010)
> +#define FRC_WL_ANT_SET                 FIELD32(0x00000020)
> +#define INV_TR_SW0                     FIELD32(0x00000040)
> +#define WLAN_GPIO_IN_BIT0              FIELD32(0x00000100)
> +#define WLAN_GPIO_IN_BIT1              FIELD32(0x00000200)
> +#define WLAN_GPIO_IN_BIT2              FIELD32(0x00000400)
> +#define WLAN_GPIO_IN_BIT3              FIELD32(0x00000800)
> +#define WLAN_GPIO_IN_BIT4              FIELD32(0x00001000)
> +#define WLAN_GPIO_IN_BIT5              FIELD32(0x00002000)
> +#define WLAN_GPIO_IN_BIT6              FIELD32(0x00004000)
> +#define WLAN_GPIO_IN_BIT7              FIELD32(0x00008000)
> +#define WLAN_GPIO_IN_BIT_ALL           FIELD32(0x0000ff00)
> +#define WLAN_GPIO_OUT_BIT0             FIELD32(0x00010000)
> +#define WLAN_GPIO_OUT_BIT1             FIELD32(0x00020000)
> +#define WLAN_GPIO_OUT_BIT2             FIELD32(0x00040000)
> +#define WLAN_GPIO_OUT_BIT3             FIELD32(0x00050000)
> +#define WLAN_GPIO_OUT_BIT4             FIELD32(0x00100000)
> +#define WLAN_GPIO_OUT_BIT5             FIELD32(0x00200000)
> +#define WLAN_GPIO_OUT_BIT6             FIELD32(0x00400000)
> +#define WLAN_GPIO_OUT_BIT7             FIELD32(0x00800000)
> +#define WLAN_GPIO_OUT_BIT_ALL          FIELD32(0x00ff0000)
> +#define WLAN_GPIO_OUT_OE_BIT0          FIELD32(0x01000000)
> +#define WLAN_GPIO_OUT_OE_BIT1          FIELD32(0x02000000)
> +#define WLAN_GPIO_OUT_OE_BIT2          FIELD32(0x04000000)
> +#define WLAN_GPIO_OUT_OE_BIT3          FIELD32(0x08000000)
> +#define WLAN_GPIO_OUT_OE_BIT4          FIELD32(0x10000000)
> +#define WLAN_GPIO_OUT_OE_BIT5          FIELD32(0x20000000)
> +#define WLAN_GPIO_OUT_OE_BIT6          FIELD32(0x40000000)
> +#define WLAN_GPIO_OUT_OE_BIT7          FIELD32(0x80000000)
> +#define WLAN_GPIO_OUT_OE_BIT_ALL       FIELD32(0xff000000)
> +
> +/*
> + * CMB_CTRL_CFG
> + */
> +#define CMB_CTRL               0x20
> +#define AUX_OPT_BIT0           FIELD32(0x00000001)
> +#define AUX_OPT_BIT1           FIELD32(0x00000002)
> +#define AUX_OPT_BIT2           FIELD32(0x00000004)
> +#define AUX_OPT_BIT3           FIELD32(0x00000008)
> +#define AUX_OPT_BIT4           FIELD32(0x00000010)
> +#define AUX_OPT_BIT5           FIELD32(0x00000020)
> +#define AUX_OPT_BIT6           FIELD32(0x00000040)
> +#define AUX_OPT_BIT7           FIELD32(0x00000080)
> +#define AUX_OPT_BIT8           FIELD32(0x00000100)
> +#define AUX_OPT_BIT9           FIELD32(0x00000200)
> +#define AUX_OPT_BIT10          FIELD32(0x00000400)
> +#define AUX_OPT_BIT11          FIELD32(0x00000800)
> +#define AUX_OPT_BIT12          FIELD32(0x00001000)
> +#define AUX_OPT_BIT13          FIELD32(0x00002000)
> +#define AUX_OPT_BIT14          FIELD32(0x00004000)
> +#define AUX_OPT_BIT15          FIELD32(0x00008000)
> +#define LDO25_LEVEL            FIELD32(0x00030000)
> +#define LDO25_LARGEA           FIELD32(0x00040000)
> +#define LDO25_FRC_ON           FIELD32(0x00080000)
> +#define CMB_RSV                        FIELD32(0x00300000)
> +#define XTAL_RDY               FIELD32(0x00400000)
> +#define PLL_LD                 FIELD32(0x00800000)
> +#define LDO_CORE_LEVEL         FIELD32(0x0F000000)
> +#define LDO_BGSEL              FIELD32(0x30000000)
> +#define LDO3_EN                        FIELD32(0x40000000)
> +#define LDO0_EN                        FIELD32(0x80000000)
> +
> +/*
> + * OSC_CTRL_CFG
> + */
> +#define OSC_CTRL               0x38
> +#define OSC_REF_CYCLE          FIELD32(0x00001fff)
> +#define OSC_RSV                        FIELD32(0x0000e000)
> +#define OSC_CAL_CNT            FIELD32(0x0fff0000)
> +#define OSC_CAL_ACK            FIELD32(0x10000000)
> +#define OSC_CLK_32K_VLD                FIELD32(0x20000000)
> +#define OSC_CAL_REQ            FIELD32(0x40000000)
> +#define OSC_ROSC_EN            FIELD32(0x80000000)
> +
> +/*
> + * PLL_CTRL_CFG
> + */
> +#define PLL_CTRL               0x50
> +#define PLL_RESERVED_INPUT1    FIELD32(0x000000ff)
> +#define PLL_RESERVED_INPUT2    FIELD32(0x0000ff00)
> +#define PLL_CONTROL            FIELD32(0x00070000)
> +#define PLL_LPF_R1             FIELD32(0x00080000)
> +#define PLL_LPF_C1_CTRL        FIELD32(0x00300000)
> +#define PLL_LPF_C2_CTRL        FIELD32(0x00c00000)
> +#define PLL_CP_CURRENT_CTRL    FIELD32(0x03000000)
> +#define PLL_PFD_DELAY_CTRL     FIELD32(0x0c000000)
> +#define PLL_LOCK_CTRL          FIELD32(0x70000000)
> +#define PLL_VBGBK_EN           FIELD32(0x80000000)
> +
> +/*
> + * COEX_CFG_0
> + */
> +#define COEX_CFG0                      0x40
> +
> +/*
> + * COEX_CFG_1
> + */
> +#define COEX_CFG1                      0x44
> +
> +/*
> + * COEX_CFG_2
> + */
> +#define COEX_CFG2                      0x48
> +
> +/*
>  * MCU_CMD_CFG
>  */
>  #define MCU_CMD_CFG                    0x022c
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 1cd16b4..7753791 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -361,6 +361,10 @@ int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
>                multiple = true;
>        } else {
>                fw_len = 8192;
> +
> +               if (rt2x00_rt(rt2x00dev, RT3290))
> +                       fw_len = 4096;
> +
>                multiple = true;
>        }
>

It would look better to create an else-branch for the fw_len = 8192
assignment. Now it looks odd with overwriting the earlier given value.

> @@ -417,7 +421,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>        if (rt2x00_is_pci(rt2x00dev)) {
>                if (rt2x00_rt(rt2x00dev, RT3572) ||
>                    rt2x00_rt(rt2x00dev, RT5390) ||
> -                   rt2x00_rt(rt2x00dev, RT5392)) {
> +                   rt2x00_rt(rt2x00dev, RT5392) ||
> +                   rt2x00_rt(rt2x00dev, RT3290)) {
>                        rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
>                        rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
>                        rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);

I will just mention this once, but this applies for the whole patch:
Please include the condition in the correct numerical order. It just
makes it easier to look through the code if the RT chipset checks are
in numerical order.

> @@ -844,6 +849,10 @@ int rt2800_rfkill_poll(struct rt2x00_dev *rt2x00dev)
>  {
>        u32 reg;
>
> +       if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> +               return rt2x00_get_field32(reg, WLAN_GPIO_IN_BIT0);
> +       } else
>        rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
>        return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
>  }

This looks fishy, as I think both the register_read and the return
statement need to be part of the else branch. Technically the code
still behaves correctly, but it just looks fishy.

> @@ -1930,7 +1939,8 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>
>  #define RT5390_POWER_BOUND     0x27
>  #define RT5390_FREQ_OFFSET_BOUND       0x5f
> -
> +#define RT3290_POWER_BOUND     0x27
> +#define RT3290_FREQ_OFFSET_BOUND       0x5f
>  static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
>                                         struct ieee80211_conf *conf,
>                                         struct rf_channel *rf,

No need to remove the empty line. Also, if these values are the same
as for the RT5390 defines, can we combine these in a more generically
named set of defines?

> @@ -2025,6 +2035,67 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
>        rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
>  }
>
> +
> +static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
> +                                        struct ieee80211_conf *conf,
> +                                        struct rf_channel *rf,
> +                                        struct channel_info *info)
> +{
> +       u8 rfcsr;
> +
> +       rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
> +       rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
> +       rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
> +       rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
> +       rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
> +       if (info->default_power1 > RT5390_POWER_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT3290_POWER_BOUND);
> +       else
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
> +       rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
> +
> +       rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> +       if (rt2x00dev->freq_offset > RT3290_FREQ_OFFSET_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
> +                                 RT3290_FREQ_OFFSET_BOUND);
> +       else
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
> +       rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> +
> +       if (rf->channel <= 14) {
> +               rt2800_rfcsr_read(rt2x00dev, 32, &rfcsr);
> +               rfcsr &= ~0xF8;
> +               rfcsr |= (0x1f << 3);
> +               rt2800_rfcsr_write(rt2x00dev, 32, rfcsr);
> +               rt2800_rfcsr_read(rt2x00dev, 31, &rfcsr);
> +               rfcsr &= ~0xF8;
> +               rfcsr |= (0x1f << 3);
> +               rt2800_rfcsr_write(rt2x00dev, 31, rfcsr);

Can we create some defines for this RFCSR so that we don't have to do
this bit manipulation magic? That would make the code more readable
and better understandable.

> +
> +               if (rf->channel == 6)
> +                       rt2800_bbp_write(rt2x00dev, 68, 0x0c);
> +               else
> +                       rt2800_bbp_write(rt2x00dev, 68, 0x0b);
> +
> +               if (rf->channel >= 1 && rf->channel <= 6)
> +                       rt2800_bbp_write(rt2x00dev, 59, 0x0f);
> +               else if (rf->channel >= 7 && rf->channel <= 11)
> +                       rt2800_bbp_write(rt2x00dev, 59, 0x0e);
> +               else if (rf->channel >= 12 && rf->channel <= 14)
> +                       rt2800_bbp_write(rt2x00dev, 59, 0x0d);
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
> +}
>  static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>                                  struct ieee80211_conf *conf,
>                                  struct rf_channel *rf,

There is quite a bit of overlap with the already existing
rt2800_config_channel_rf53xx function. Is it possible to share more
code between the two?

> @@ -2058,6 +2129,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>        case RF5390:
>                rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
>                break;
> +       case RF3290:
> +               rt2800_config_channel_rf3290(rt2x00dev, conf, rf, info);
> +               break;
>        default:
>                rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
>        }

Again, please put the case in the correct numerical order.

> @@ -2545,6 +2619,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
>        case RF5370:
>        case RF5372:
>        case RF5390:
> +       case RF3290:
>                rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
>                rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
>                rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
> @@ -2677,7 +2752,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>                    rt2x00_rt(rt2x00dev, RT3090) ||
>                    rt2x00_rt(rt2x00dev, RT3390) ||
>                    rt2x00_rt(rt2x00dev, RT5390) ||
> -                   rt2x00_rt(rt2x00dev, RT5392))
> +                   rt2x00_rt(rt2x00dev, RT5392) ||
> +                   rt2x00_rt(rt2x00dev, RT3290))
>                        return 0x1c + (2 * rt2x00dev->lna_gain);
>                else
>                        return 0x2e + rt2x00dev->lna_gain;
> @@ -2771,9 +2847,47 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>        rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
>        rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
>
> +       if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800pci_3290_enable_wlan(rt2x00dev);
> +               rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> +               if (rt2x00_get_field32(reg, WLAN_EN) == 1) {
> +                       rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 1);
> +                       rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
> +               }
> +
> +               rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
> +               if (!(rt2x00_get_field32(reg, LDO0_EN) == 1)) {
> +                       rt2x00_set_field32(&reg, LDO0_EN, 1);
> +                       rt2x00_set_field32(&reg, LDO_BGSEL, 1);
> +                       rt2800_register_write(rt2x00dev, CMB_CTRL, reg);
> +               }
> +
> +               rt2800_register_read(rt2x00dev, OSC_CTRL, &reg);
> +               rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
> +               rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
> +               rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
> +               rt2x00_set_field32(&reg, OSC_CAL_REQ, 1);
> +               rt2x00_set_field32(&reg, OSC_REF_CYCLE, 0x27);
> +               rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
> +               rt2800_register_read(rt2x00dev, COEX_CFG0, &reg);
> +               reg &= ~(0xFF000000);
> +               reg |= 0x5E000000;
> +               rt2800_register_write(rt2x00dev, COEX_CFG0, reg);
> +               rt2800_register_write(rt2x00dev, COEX_CFG2, 0x0017937F);
> +               rt2800_register_read(rt2x00dev, PLL_CTRL, &reg);
> +               rt2x00_set_field32(&reg, PLL_CONTROL, 1);
> +               rt2800_register_write(rt2x00dev, PLL_CTRL, reg);
> +       }
> +
>        if (rt2x00_rt(rt2x00dev, RT3071) ||
>            rt2x00_rt(rt2x00dev, RT3090) ||
> -           rt2x00_rt(rt2x00dev, RT3390)) {
> +           rt2x00_rt(rt2x00dev, RT3390) ||
> +               rt2x00_rt(rt2x00dev, RT3290)) {
> +
> +               if (rt2x00_rt(rt2x00dev, RT3290))
> +                       rt2800_register_write(rt2x00dev, TX_SW_CFG0,
> +                               0x00000404);
> +               else
>                rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
>                rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
>                if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
> @@ -3184,7 +3298,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                return -EACCES;
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392)) {
> +               rt2x00_rt(rt2x00dev, RT5392)    ||
> +               rt2x00_rt(rt2x00dev, RT3290)) {
>                rt2800_bbp_read(rt2x00dev, 4, &value);
>                rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
>                rt2800_bbp_write(rt2x00dev, 4, value);
> @@ -3193,25 +3308,32 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        if (rt2800_is_305x_soc(rt2x00dev) ||
>            rt2x00_rt(rt2x00dev, RT3572) ||
>            rt2x00_rt(rt2x00dev, RT5390) ||
> -           rt2x00_rt(rt2x00dev, RT5392))
> +           rt2x00_rt(rt2x00dev, RT5392) ||
> +           rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 31, 0x08);
>
>        rt2800_bbp_write(rt2x00dev, 65, 0x2c);
>        rt2800_bbp_write(rt2x00dev, 66, 0x38);
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 68, 0x0b);
>
>        if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
>                rt2800_bbp_write(rt2x00dev, 69, 0x16);
>                rt2800_bbp_write(rt2x00dev, 73, 0x12);
>        } else if (rt2x00_rt(rt2x00dev, RT5390) ||
> -                          rt2x00_rt(rt2x00dev, RT5392)) {
> +                       rt2x00_rt(rt2x00dev, RT5392) ||
> +                       rt2x00_rt(rt2x00dev, RT3290)) {
>                rt2800_bbp_write(rt2x00dev, 69, 0x12);
>                rt2800_bbp_write(rt2x00dev, 73, 0x13);
>                rt2800_bbp_write(rt2x00dev, 75, 0x46);
>                rt2800_bbp_write(rt2x00dev, 76, 0x28);
> +
> +               if (rt2x00_rt(rt2x00dev, RT3290))
> +                       rt2800_bbp_write(rt2x00dev, 77, 0x58);
> +               else
>                rt2800_bbp_write(rt2x00dev, 77, 0x59);
>        } else {
>                rt2800_bbp_write(rt2x00dev, 69, 0x12);

Please adjust the indentation of the else branch. You can't just
insert the else and leave the code that is now in the else branch at
its old indentation level.

> @@ -3237,9 +3359,17 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 81, 0x37);
>        }
>
> +       if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800_bbp_write(rt2x00dev, 74, 0x0b);
> +               rt2800_bbp_write(rt2x00dev, 79, 0x18);
> +               rt2800_bbp_write(rt2x00dev, 80, 0x09);
> +               rt2800_bbp_write(rt2x00dev, 81, 0x33);
> +       }
> +
>        rt2800_bbp_write(rt2x00dev, 82, 0x62);
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 83, 0x7a);
>        else
>                rt2800_bbp_write(rt2x00dev, 83, 0x6a);
> @@ -3247,13 +3377,15 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
>                rt2800_bbp_write(rt2x00dev, 84, 0x19);
>        else if (rt2x00_rt(rt2x00dev, RT5390) ||
> -                        rt2x00_rt(rt2x00dev, RT5392))
> +                       rt2x00_rt(rt2x00dev, RT5392) ||
> +                       rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 84, 0x9a);
>        else
>                rt2800_bbp_write(rt2x00dev, 84, 0x99);
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 86, 0x38);
>        else
>                rt2800_bbp_write(rt2x00dev, 86, 0x00);
> @@ -3264,7 +3396,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        rt2800_bbp_write(rt2x00dev, 91, 0x04);
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 92, 0x02);
>        else
>                rt2800_bbp_write(rt2x00dev, 92, 0x00);
> @@ -3281,13 +3414,15 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>            rt2x00_rt(rt2x00dev, RT3572) ||
>            rt2x00_rt(rt2x00dev, RT5390) ||
>            rt2x00_rt(rt2x00dev, RT5392) ||
> +           rt2x00_rt(rt2x00dev, RT3290) ||
>            rt2800_is_305x_soc(rt2x00dev))
>                rt2800_bbp_write(rt2x00dev, 103, 0xc0);
>        else
>                rt2800_bbp_write(rt2x00dev, 103, 0x00);
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 104, 0x92);
>
>        if (rt2800_is_305x_soc(rt2x00dev))
> @@ -3295,10 +3430,13 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        else if (rt2x00_rt(rt2x00dev, RT5390) ||
>                         rt2x00_rt(rt2x00dev, RT5392))
>                rt2800_bbp_write(rt2x00dev, 105, 0x3c);
> +       else if (rt2x00_rt(rt2x00dev, RT3290))
> +               rt2800_bbp_write(rt2x00dev, 105, 0x1c);
>        else
>                rt2800_bbp_write(rt2x00dev, 105, 0x05);
>
> -       if (rt2x00_rt(rt2x00dev, RT5390))
> +       if (rt2x00_rt(rt2x00dev, RT5390) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 106, 0x03);
>        else if (rt2x00_rt(rt2x00dev, RT5392))
>                rt2800_bbp_write(rt2x00dev, 106, 0x12);
> @@ -3306,7 +3444,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 106, 0x35);
>
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392))
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290))
>                rt2800_bbp_write(rt2x00dev, 128, 0x12);
>
>        if (rt2x00_rt(rt2x00dev, RT5392)) {
> @@ -3331,6 +3470,27 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 138, value);
>        }
>
> +       if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800_bbp_write(rt2x00dev, 67, 0x24);
> +               rt2800_bbp_write(rt2x00dev, 143, 0x04);
> +               rt2800_bbp_write(rt2x00dev, 142, 0x99);
> +               rt2800_bbp_write(rt2x00dev, 150, 0x30);
> +               rt2800_bbp_write(rt2x00dev, 151, 0x2e);
> +               rt2800_bbp_write(rt2x00dev, 152, 0x20);
> +               rt2800_bbp_write(rt2x00dev, 153, 0x34);
> +               rt2800_bbp_write(rt2x00dev, 154, 0x40);
> +               rt2800_bbp_write(rt2x00dev, 155, 0x3b);
> +               rt2800_bbp_write(rt2x00dev, 253, 0x04);
> +
> +               rt2800_bbp_read(rt2x00dev, 47, &value);
> +               rt2x00_set_field8(&value, RFCSR2_RESCAL_EN, 1);
> +               rt2800_bbp_write(rt2x00dev, 47, value);
> +
> +               rt2800_bbp_read(rt2x00dev, 3, &value);
> +               value &= (~0xc0);
> +               value |= 0xc0;
> +               rt2800_bbp_write(rt2x00dev, 3, value);
> +       }

Again, please introduce some define so that we do not have to do this
bit manipulation magic.

>        if (rt2x00_rt(rt2x00dev, RT5390) ||
>                rt2x00_rt(rt2x00dev, RT5392)) {
>                int ant, div_mode;
> @@ -3467,6 +3627,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rt(rt2x00dev, RT3572) &&
>            !rt2x00_rt(rt2x00dev, RT5390) &&
>            !rt2x00_rt(rt2x00dev, RT5392) &&
> +           !rt2x00_rt(rt2x00dev, RT3290) &&
>            !rt2800_is_305x_soc(rt2x00dev))
>                return 0;
>
> @@ -3474,7 +3635,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>         * Init RF calibration.
>         */
>        if (rt2x00_rt(rt2x00dev, RT5390) ||
> -               rt2x00_rt(rt2x00dev, RT5392)) {
> +               rt2x00_rt(rt2x00dev, RT5392) ||
> +               rt2x00_rt(rt2x00dev, RT3290)) {
>                rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
>                rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
>                rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> @@ -3752,6 +3914,53 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                        rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
>                        rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
>                        rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
> +       } else if (rt2x00_rt(rt2x00dev, RT3290)) {
> +                       rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
> +                       rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> +                       rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
> +                       rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
> +                       rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
> +                       rt2800_rfcsr_write(rt2x00dev, 8, 0xf3);
> +                       rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
> +                       rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> +                       rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> +                       rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
> +                       rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> +                       rt2800_rfcsr_write(rt2x00dev, 18, 0x02);
> +                       rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> +                       rt2800_rfcsr_write(rt2x00dev, 25, 0x83);
> +                       rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
> +                       rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> +                       rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> +                       rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
> +                       rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> +                       rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
> +                       rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
> +                       rt2800_rfcsr_write(rt2x00dev, 34, 0x05);
> +                       rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> +                       rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> +                       rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
> +                       rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> +                       rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
> +                       rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> +                       rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
> +                       rt2800_rfcsr_write(rt2x00dev, 43, 0x7b);
> +                       rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> +                       rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> +                       rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> +                       rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
> +                       rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> +                       rt2800_rfcsr_write(rt2x00dev, 49, 0x98);
> +                       rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
> +                       rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
> +                       rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
> +                       rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
> +                       rt2800_rfcsr_write(rt2x00dev, 56, 0x02);
> +                       rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
> +                       rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
> +                       rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
> +                       rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> +                       rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
>        }
>
>        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
> @@ -3935,6 +4144,12 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>        }
>
> +       if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
> +               rfcsr = ((rfcsr & ~0xc0) | 0xc0);
> +               rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
> +       }
> +
>        return 0;
>  }

More bit manipulation magic.

>
> @@ -4026,9 +4241,13 @@ EXPORT_SYMBOL_GPL(rt2800_disable_radio);
>  int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
>  {
>        u32 reg;
> +       u16 efuse_ctrl_reg;
> +       efuse_ctrl_reg = EFUSE_CTRL;
>
> -       rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
> +       if (rt2x00dev->chip.mac_version == 0x3290)
> +               efuse_ctrl_reg = 0x24;
>
> +       rt2800_register_read(rt2x00dev, efuse_ctrl_reg, &reg);
>        return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
>  }
>  EXPORT_SYMBOL_GPL(rt2800_efuse_detect);

Can you explain why we need the chip.mac_version check here instead of
just doing a check for rt2x00_rt(rt2x00dev, RT3290)?
That way we would not have to add this mac_version field.

> @@ -4037,26 +4256,44 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
>  {
>        u32 reg;
>
> +       u16 efuse_ctrl_reg;
> +       u16 efuse_data0_reg;
> +       u16 efuse_data1_reg;
> +       u16 efuse_data2_reg;
> +       u16 efuse_data3_reg;
> +
> +       efuse_ctrl_reg = EFUSE_CTRL;
> +       efuse_data0_reg = EFUSE_DATA0;
> +       efuse_data1_reg = EFUSE_DATA1;
> +       efuse_data2_reg = EFUSE_DATA2;
> +       efuse_data3_reg = EFUSE_DATA3;
> +
> +       if (rt2x00dev->chip.mac_version == 0x3290) {
> +               efuse_ctrl_reg = 0x24;
> +               efuse_data3_reg = 0x28;
> +               efuse_data2_reg = efuse_data3_reg + 4;
> +               efuse_data1_reg = efuse_data2_reg + 4;
> +               efuse_data0_reg = efuse_data1_reg + 4;
> +       }
>        mutex_lock(&rt2x00dev->csr_mutex);
>
> -       rt2800_register_read_lock(rt2x00dev, EFUSE_CTRL, &reg);
> +       rt2800_register_read_lock(rt2x00dev, efuse_ctrl_reg, &reg);
>        rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
>        rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
>        rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
> -       rt2800_register_write_lock(rt2x00dev, EFUSE_CTRL, reg);
> +       rt2800_register_write_lock(rt2x00dev, efuse_ctrl_reg, reg);
>
>        /* Wait until the EEPROM has been loaded */
> -       rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
> -
> +       rt2800_regbusy_read(rt2x00dev, efuse_ctrl_reg, EFUSE_CTRL_KICK, &reg);
>        /* Apparently the data is read from end to start */
> -       rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
> +       rt2800_register_read_lock(rt2x00dev, efuse_data3_reg, &reg);
>        /* The returned value is in CPU order, but eeprom is le */
>        *(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);
> -       rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
> +       rt2800_register_read_lock(rt2x00dev, efuse_data2_reg, &reg);
>        *(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
> -       rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
> +       rt2800_register_read_lock(rt2x00dev, efuse_data1_reg, &reg);
>        *(u32 *)&rt2x00dev->eeprom[i + 4] = cpu_to_le32(reg);
> -       rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0, &reg);
> +       rt2800_register_read_lock(rt2x00dev, efuse_data0_reg, &reg);
>        *(u32 *)&rt2x00dev->eeprom[i + 6] = cpu_to_le32(reg);
>
>        mutex_unlock(&rt2x00dev->csr_mutex);
> @@ -4218,9 +4455,13 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>         * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
>         * RT53xx: defined in "EEPROM_CHIP_ID" field
>         */
> +       if (rt2x00dev->chip.mac_version == 0x3290)
> +               rt2800_register_read(rt2x00dev, MAC_CSR0_3290, &reg);
> +       else
>        rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
>        if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 ||
> -               rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392)
> +               rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392 ||
> +               rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT3290)
>                rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
>        else
>                value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
> @@ -4239,6 +4480,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        case RT3572:
>        case RT5390:
>        case RT5392:
> +       case RT3290:
>                break;
>        default:
>                ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
> @@ -4259,6 +4501,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        case RF5370:
>        case RF5372:
>        case RF5390:
> +       case RF3290:
>                break;
>        default:
>                ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
> @@ -4572,7 +4815,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>                   rt2x00_rf(rt2x00dev, RF3320) ||
>                   rt2x00_rf(rt2x00dev, RF5370) ||
>                   rt2x00_rf(rt2x00dev, RF5372) ||
> -                  rt2x00_rf(rt2x00dev, RF5390)) {
> +                  rt2x00_rf(rt2x00dev, RF5390) ||
> +                  rt2x00_rf(rt2x00dev, RF3290)) {
>                spec->num_channels = 14;
>                spec->channels = rf_vals_3x;
>        } else if (rt2x00_rf(rt2x00dev, RF3052)) {
> @@ -4658,6 +4902,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        case RF5370:
>        case RF5372:
>        case RF5390:
> +       case RF3290:
>                __set_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags);
>                break;
>        }
> @@ -4885,6 +5130,102 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
>  }
>  EXPORT_SYMBOL_GPL(rt2800_get_survey);
>
> +int rt2800pci_3290_enable_wlan(struct rt2x00_dev *rt2x00dev)
> +{
> +       u32 wlanfunctrl;
> +       u32 glocfg;
> +       u32 cmbctrl;
> +       u8 index;
> +       int i;
> +
> +       rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &wlanfunctrl);
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
> +       rt2x00_set_field32(&wlanfunctrl, FRC_WL_ANT_SET, 1);
> +       if ((rt2x00_get_field32(wlanfunctrl, WLAN_EN) == 1))
> +               return 0;
> +
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_CLK_EN, 0);
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_EN, 1);
> +       rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, wlanfunctrl);
> +       udelay(REGISTER_BUSY_DELAY);
> +
> +       index = 0;
> +       cmbctrl = 0;
> +       for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +               rt2800_register_read(rt2x00dev, CMB_CTRL, &cmbctrl);
> +               if ((rt2x00_get_field32(cmbctrl, PLL_LD) == 1) &&
> +                       (rt2x00_get_field32(cmbctrl, XTAL_RDY) == 1))
> +                       break;
> +               udelay(REGISTER_BUSY_DELAY);
> +       }
> +
> +       if (index >= REGISTER_BUSY_COUNT) {
> +               rt2800_register_write(rt2x00dev, 0x58, 0x018);
> +               udelay(REGISTER_BUSY_DELAY);
> +               rt2800_register_write(rt2x00dev, 0x58, 0x418);
> +               udelay(REGISTER_BUSY_DELAY);
> +               rt2800_register_write(rt2x00dev, 0x58, 0x618);
> +               udelay(REGISTER_BUSY_DELAY);
> +       } else {
> +               rt2800_register_read(rt2x00dev,
> +                       WPDMA_GLO_CFG, &glocfg);
> +       }
> +       rt2x00_set_field32(&wlanfunctrl, PCIE_APP0_CLK_REQ, 0);
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_CLK_EN, 1);
> +
> +       rt2800_register_write(rt2x00dev,
> +               WLAN_FUN_CTRL, (wlanfunctrl | 0x8));
> +       udelay(REGISTER_BUSY_DELAY);
> +       rt2800_register_write(rt2x00dev,
> +               WLAN_FUN_CTRL, (wlanfunctrl &= (~0x8)));
> +       udelay(2);
> +       rt2800_register_write(rt2x00dev,
> +               INT_SOURCE_CSR, 0x7fffffff);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(rt2800pci_3290_enable_wlan);
> +
> +int rt2800pci_3290_disable_wlan(struct rt2x00_dev *rt2x00dev)
> +{
> +       u32 wlanfunctrl;
> +       u32 glocfg;
> +       u32 reg;
> +       int i;
> +
> +       /* Change Interrupt bitmask. */
> +       rt2800_register_write(rt2x00dev, INT_MASK_CSR, 0x0);
> +       rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &glocfg);
> +       rt2x00_set_field32(&glocfg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
> +       rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, glocfg);
> +
> +       /* wait RX DMA idle */
> +       for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +               rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &glocfg);
> +               if ((rt2x00_get_field32(glocfg,
> +                       WPDMA_GLO_CFG_RX_DMA_BUSY) == 0) ||
> +                       (glocfg == 0xFFFFFFFF))
> +                       break;
> +               udelay(REGISTER_BUSY_DELAY);
> +       }
> +
> +       if (i >= REGISTER_BUSY_COUNT) {
> +               rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
> +               rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 0);
> +               rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE, 0);
> +               rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 0);
> +               rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
> +               return 0;
> +               }
> +
> +       rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &wlanfunctrl);
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_EN, 0);
> +       rt2x00_set_field32(&wlanfunctrl, WLAN_CLK_EN, 0);
> +       rt2x00_set_field32(&wlanfunctrl, PCIE_APP0_CLK_REQ, 0);
> +       rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, wlanfunctrl);
> +       udelay(REGISTER_BUSY_DELAY);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(rt2800pci_3290_disable_wlan);

These two functions seems to be pci specific, shouldn't they be in
rt2800pci.c then?


>  MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
>  MODULE_VERSION(DRV_VERSION);
>  MODULE_DESCRIPTION("Ralink RT2800 library");
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
> index 18a0b67..22d7cbb 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -209,5 +209,6 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
>                      struct survey_info *survey);
>  void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
> -
> +int rt2800pci_3290_enable_wlan(struct rt2x00_dev *rt2x00dev);
> +int rt2800pci_3290_disable_wlan(struct rt2x00_dev *rt2x00dev);
>  #endif /* RT2800LIB_H */
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 931331d..9251f2d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -280,6 +280,10 @@ static void rt2800pci_stop_queue(struct data_queue *queue)
>  */
>  static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
>  {
> +
> +       if (rt2x00_rt(rt2x00dev, RT3290))
> +               return FIRMWARE_RT3290;
> +
>        return FIRMWARE_RT2860;
>  }
>

OK. Since this is a different firmware file, I assume you will be
submitting this firmware to the linux-firmware repository, right?

> @@ -536,6 +540,9 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
>                rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0);
>                rt2x00pci_register_write(rt2x00dev, TX_PIN_CFG, 0);
>        }
> +
> +       if (rt2x00_rt(rt2x00dev, RT3290))
> +               rt2800pci_3290_disable_wlan(rt2x00dev);
>  }
>
>  static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
> @@ -1028,6 +1035,8 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>         */
>        rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
>
> +       if (rt2x00_rf(rt2x00dev, RF3290))
> +               rt2800pci_3290_enable_wlan(rt2x00dev);
>        return 0;
>  }
>
> @@ -1194,6 +1203,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>        { PCI_DEVICE(0x1814, 0x539a) },
>        { PCI_DEVICE(0x1814, 0x539f) },
>  #endif
> +#ifdef CONFIG_RT2800PCI_RT3290
> +       { PCI_DEVICE(0x1814, 0x3290) },
> +#endif
>        { 0, }
>  };

Numerical order, please.

>  #endif /* CONFIG_PCI */
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
> index 70e050d..dd043c7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -49,6 +49,9 @@
>  #define FIRMWARE_RT2860                        "rt2860.bin"
>  #define FIRMWARE_IMAGE_BASE            0x2000
>
> +
> +#define FIRMWARE_RT3290                        "rt3290.bin"
> +
>  /*
>  * DMA descriptor defines.
>  */

Please move the define next to the order firmware filename definition.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index ca36ccc..ee770e7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -193,10 +193,11 @@ struct rt2x00_chip {
>  #define RT3883         0x3883  /* WSOC */
>  #define RT5390         0x5390  /* 2.4GHz */
>  #define RT5392         0x5392  /* 2.4GHz */
> +#define RT3290         0x3290
>
>        u16 rf;
>        u16 rev;
> -
> +       u16 mac_version;
>        enum rt2x00_chip_intf intf;
>  };
>

As mentioned before, please explain why this new field is needed.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index 0a4653a..9bbd9a3 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -256,6 +256,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
>        struct ieee80211_hw *hw;
>        struct rt2x00_dev *rt2x00dev;
>        int retval;
> +       u16 device_id;
>
>        retval = pci_enable_device(pci_dev);
>        if (retval) {
> @@ -305,6 +306,11 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
>        if (retval)
>                goto exit_free_device;
>
> +
> +       pci_read_config_word(pci_dev, PCI_DEVICE_ID, &device_id);
> +       if (device_id == 0x3290)
> +               rt2x00dev->chip.mac_version = 0x3290;
> +
>        retval = rt2x00lib_probe_dev(rt2x00dev);
>        if (retval)
>                goto exit_free_reg;
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
