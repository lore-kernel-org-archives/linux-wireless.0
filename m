Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52370 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0KJPNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 10:13:30 -0500
Received: by gxk23 with SMTP id 23so398676gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 07:13:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com>
References: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
 <AANLkTinT72TE_z2JW1x+pMHNys6jVEeGfkQZFAW_f+48@mail.gmail.com> <AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 10 Nov 2010 17:13:08 +0200
Message-ID: <AANLkTikx=wmDbQEz8bAsLKmjx88mQYsBjFctpntV3ex1@mail.gmail.com>
Subject: Re: wl1271 sdio timeouts on omap3
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joerie,

On Wed, Nov 10, 2010 at 5:01 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> Sorry, I've attached a full diff of the board changes below.

Ok, thanks.

I took a brief look and couldn't find anything outstanding, but as I
said, if you passed CMD5 (very early at the SDIO init process) then
your card is powered and communicating.

Can you pls tell me what's the output of those commands (after
bringing up the wlan interface):

mount -t debugfs none /sys/kernel/debug
cat /sys/kernel/debug/mmc2/ios

> The board shipped with a firmware image which uses the TI proprietary

Can you say what board is it ? is it something you assembled or is it
off-the-shelf ?

Honestly I would hook up a hw scope and sniff the SDIO lines to see
what's going on.

> driver, that works.. I've carefully checked my pin muxing (the other
> pads on which MMC3 may be muxed are disabled).
>
>> I suggest you to try working with 1 bit SDIO and/or low clock speeds
>> and see if stability is improved.
>
> Setting .wires to 1 unfortunately didn't help. I'm not sure how to
> lower the clock speeds though.

There are several ways to do that.

Check out mmc_sdio_init_card() - the clock rate is increased there.

Regards,
Ohad.

>
> I've enabled MMC debugging, which yields the following dmesg output
> (tried to bring the interface up at t=265).
>
> [    6.108154] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
> [    6.108215] mmc2: starting CMD52 arg 80042202 flags 00000195
> [    6.108245] mmc2: req done (CMD52): 0: 00001002 00000000 00000000 00000000
> [    6.112121] wl1271: loaded
> [    6.112152] wl1271: initialized
> [   15.989318] wl1271: mac80211 start
> [   15.989410] wl1271: mac80211 stop
> [  265.258666] wl1271: mac80211 start
> [  265.258758] wl1271: mac80211 add interface type 2 mac 9e:be:10:f4:a4:d6
> [  265.512664] SDIO: Enabling device mmc2:0001:2...
> [  265.512695] mmc2: starting CMD52 arg 00000400 flags 00000195
> [  279.317413] INFO: task ifconfig:1301 blocked for more than 10 seconds.
> [  279.317443] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  279.317474] ifconfig      D c03111d4     0  1301   1269 0x00000000
> [  279.317535] [<c03111d4>] (schedule+0x37c/0x404) from [<c0311814>]
> (schedule_timeout+0x18/0x1dc)
> [  279.317565] [<c0311814>] (schedule_timeout+0x18/0x1dc) from
> [<c0311698>] (wait_for_common+0xf0/0x1a8)
> [  279.317626] [<c0311698>] (wait_for_common+0xf0/0x1a8) from
> [<c02194a8>] (mmc_wait_for_req+0x224/0x244)
> [  279.317657] [<c02194a8>] (mmc_wait_for_req+0x224/0x244) from
> [<c021952c>] (mmc_wait_for_cmd+0x64/0x74)
> [  279.317687] [<c021952c>] (mmc_wait_for_cmd+0x64/0x74) from
> [<c021d8dc>] (mmc_io_rw_direct_host+0xc0/0x124)
> [  279.317749] [<c021d8dc>] (mmc_io_rw_direct_host+0xc0/0x124) from
> [<c021efcc>] (sdio_enable_func+0x64/0x15c)
> [  279.317779] [<c021efcc>] (sdio_enable_func+0x64/0x15c) from
> [<c01cdaec>] (wl1271_sdio_set_power+0x20/0x44)
> [  279.317810] [<c01cdaec>] (wl1271_sdio_set_power+0x20/0x44) from
> [<c01c500c>] (wl1271_chip_wakeup+0x28/0x2f0)
> <snip>
>
> Joerie
>
> ----
>
> diff --git b/arch/arm/mach-omap2/board-nowplus.c
> a/arch/arm/mach-omap2/board-nowplus.c
> index 54246dd..af47e98 100644
> --- b/arch/arm/mach-omap2/board-nowplus.c
> +++ a/arch/arm/mach-omap2/board-nowplus.c
> @@ -29,6 +29,7 @@
>  #include <linux/input.h>
>  #include <linux/input/matrix_keypad.h>
>
> +#include <linux/wl12xx.h>
>  #include <linux/leds-bd2802.h>
>  #include <linux/max17040_battery.h>
>
> @@ -52,6 +53,8 @@
>
>  #define NOWPLUS_CHARGER_ENABLE_GPIO    157
>  #define NOWPLUS_CHARGING_STATUS_GPIO   16
> +#define NOWPLUS_WLAN_IRQ_GPIO          21
> +#define NOWPLUS_WLAN_PMENA_GPIO        160
>
>  static struct bd2802_led_platform_data nowplus_led_data = {
>        .reset_gpio = 151,
> @@ -119,6 +122,14 @@ static struct omap2_hsmmc_info nowplus_mmc[] = {
>                .gpio_cd        = -EINVAL,
>                .gpio_wp        = -EINVAL,
>        },
> +       {
> +               .name           = "wl1271",
> +               .mmc            = 3,
> +               .wires          = 4,
> +               .nonremovable   = 1,
> +               .gpio_cd        = -EINVAL,
> +               .gpio_wp        = -EINVAL,
> +       },
>        {}      /* Terminator */
>  };
>
> @@ -213,6 +224,16 @@ static struct regulator_consumer_supply
> nowplus_vpll2_supply = {
>        .dev                    = &nowplus_dss_device.dev,
>  };
>
> +static struct regulator_consumer_supply nowplus_vsim_supply = {
> +       .supply                 = "vmmc",
> +};
> +
> +
> +static struct regulator_consumer_supply nowplus_wl1271_supply = {
> +       .supply                 = "vmmc_aux",
> +       .dev_name               = "mmci-omap-hs.2",
> +};
> +
>  /* VMMC1 for MMC1 card */
>  static struct regulator_init_data nowplus_vmmc1 = {
>        .constraints = {
> @@ -311,6 +332,53 @@ static struct regulator_init_data nowplus_vpll2 = {
>        .consumer_supplies      = &nowplus_vpll2_supply,
>  };
>
> +/* VSIM for WiFi SDIO */
> +static struct regulator_init_data nowplus_vsim = {
> +       .constraints = {
> +               .name                   = "VSIM",
> +               .min_uV                 = 1800000,
> +               .max_uV                 = 1800000,
> +               .apply_uV               = true,
> +               .valid_modes_mask       = REGULATOR_MODE_NORMAL
> +                                       | REGULATOR_MODE_STANDBY,
> +               .valid_ops_mask         = REGULATOR_CHANGE_MODE
> +                                       | REGULATOR_CHANGE_STATUS,
> +       },
> +       .num_consumer_supplies  = 1,
> +       .consumer_supplies      = &nowplus_vsim_supply,
> +};
> +
> +static struct regulator_init_data nowplus_wlgpio = {
> +       .constraints = {
> +               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
> +       },
> +       .num_consumer_supplies  = 1,
> +       .consumer_supplies      = &nowplus_wl1271_supply,
> +};
> +
> +static struct fixed_voltage_config nowplus_vwlan = {
> +       .supply_name            = "vwl1271",
> +       .microvolts             = 1800000, /* 1.8V */
> +       .gpio                   = NOWPLUS_WLAN_PMENA_GPIO,
> +       .startup_delay          = 70000, /* 70msec */
> +       .enable_high            = 1,
> +       .enabled_at_boot        = 0,
> +       .init_data              = &nowplus_wlgpio,
> +};
> +
> +static struct platform_device nowplus_vwlan_device = {
> +       .name           = "reg-fixed-voltage",
> +       .id             = 1,
> +       .dev = {
> +               .platform_data  = &nowplus_vwlan,
> +       },
> +};
> +
> +struct wl12xx_platform_data nowplus_wlan_data __initdata = {
> +       .irq = OMAP_GPIO_IRQ(NOWPLUS_WLAN_IRQ_GPIO),
> +       .board_ref_clock = 1, /* 26 MHz */
> +};
> +
>  static int nowplus_twl_gpio_setup(struct device *dev,
>                unsigned gpio, unsigned ngpio)
>  {
> @@ -467,6 +535,19 @@ static void __init nowplus_init_irq(void)
>
>  #ifdef CONFIG_OMAP_MUX
>  static struct omap_board_mux board_mux[] __initdata = {
> +       /* WLAN IRQ - GPIO 21 */
> +       OMAP3_MUX(ETK_D7, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP),
> +       /* WLAN POWER ENABLE - GPIO 160 */
> +       OMAP3_MUX(MCBSP_CLKS, OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
> +       /* WLAN SDIO: MMC3 CMD */
> +       OMAP3_MUX(MCSPI1_CS1, OMAP_MUX_MODE3 | OMAP_PIN_INPUT_PULLUP),
> +       /* WLAN SDIO: MMC3 CLK */
> +       OMAP3_MUX(MCSPI1_CS2, OMAP_MUX_MODE3 | OMAP_PIN_INPUT_PULLUP),
> +       /* WLAN SDIO: MMC3 DAT[0-3] */
> +       OMAP3_MUX(ETK_D3, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +       OMAP3_MUX(ETK_D4, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +       OMAP3_MUX(ETK_D5, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +       OMAP3_MUX(ETK_D6, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
>        { .reg_offset = OMAP_MUX_TERMINATOR },
>  };
>  #else
> @@ -483,10 +564,14 @@ static void __init nowplus_init(void)
>  {
>        omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>
> +       if (wl12xx_set_platform_data(&nowplus_wlan_data))
> +               pr_err("error setting wl12xx data\n");
> +
>        nowplus_i2c_init();
>
>        platform_add_devices(nowplus_devices,
>                        ARRAY_SIZE(nowplus_devices));
> +       platform_device_register(&nowplus_vwlan_device);
>
>        spi_register_board_info(nowplus_spi_board_info,
>                        ARRAY_SIZE(nowplus_spi_board_info));
>
