Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60415 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0K3WIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 17:08:30 -0500
Received: by iwn10 with SMTP id 10so260738iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 14:08:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 30 Nov 2010 13:59:53 -0800
Message-ID: <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joerie,

On Tue, Nov 30, 2010 at 11:35 AM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> Now I've got it to work using the firmware recently contributed to
> linux-firmware by TI, but I've run into another issue. The first time
> the interface is brought up everything appears to work fine (a scan
> returns APs), but once I bring the interface down any subsequent
> attempt to bring the interface back up again fail.

Make sure you have CONFIG_REGULATOR_FIXED_VOLTAGE enabled, and please
send us a full terminal log from boot to first error after applying
the following patch:

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 2fe9d99..6476137 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -49,6 +49,7 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
        struct fixed_voltage_data *data = rdev_get_drvdata(dev);

        if (gpio_is_valid(data->gpio)) {
+               pr_info("%s %d\n", __func__, data->gpio);
                gpio_set_value_cansleep(data->gpio, data->enable_high);
                data->is_enabled = true;
        }
@@ -61,6 +62,7 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
        struct fixed_voltage_data *data = rdev_get_drvdata(dev);

        if (gpio_is_valid(data->gpio)) {
+               pr_info("%s %d\n", __func__, data->gpio);
                gpio_set_value_cansleep(data->gpio, !data->enable_high);
                data->is_enabled = false;
        }

In addition, please execute 'cat /sys/kernel/debug/mmc2/ios' (so we
can see the results in the log) at the following points:

1. right after boot
2. after insmodding the drivers
3. after bringing up wlan0
4. after taking wlan0 down
5. after the second attempt to bring up wlan0

(obviously you will have to mount -t debugfs none /sys/kernel/debug for that)



>
> Sysfs indicates that after the interface has been brought down, the
> MMC regulator (VSIM) and the WLAN_PMENA GPIO remain enabled. Is this
> correct behavior?
>
> Upon the second ifup it seems to first fail waiting for an "init
> complete" interrupt (WL1271_ACX_INTR_INIT_COMPLETE).
>
> As for the regulators, I'm still not sure if I've configured them
> correctly (especially the consumer structs).
>
> I'm running v2.6.36 with Ohad's patches to allow wl1271 configuration
> in the board code and have also applied the runtime PM patchset
> (http://www.spinics.net/lists/linux-wireless/msg56664.html).
>
> Relevant code snippets below, as well as the kernel log
>
> Joerie
>
> ---------------------------------------------------------------
>
> #define NOWPLUS_WLAN_IRQ_GPIO           21
> #define NOWPLUS_WLAN_PMENA_GPIO         160
>
> static struct regulator_consumer_supply nowplus_vsim_supply = {
>        .supply                 = "vmmc",
> };
>
>
> static struct regulator_consumer_supply nowplus_wl1271_supply = {
>        .supply                 = "vmmc_aux",
>        .dev_name               = "mmci-omap-hs.2",
> };
>
> /* VSIM for WiFi SDIO */
> static struct regulator_init_data nowplus_vsim = {
>        .constraints = {
>                .name                   = "VSIM",
>                .min_uV                 = 1800000,
>                .max_uV                 = 1800000,
>                .apply_uV               = true,
>                .valid_modes_mask       = REGULATOR_MODE_NORMAL
>                                        | REGULATOR_MODE_STANDBY,
>                .valid_ops_mask         = REGULATOR_CHANGE_MODE
>                                        | REGULATOR_CHANGE_STATUS,
>        },
>        .num_consumer_supplies  = 1,
>        .consumer_supplies      = &nowplus_vsim_supply,
> };
>
> static struct regulator_init_data nowplus_wlgpio = {
>        .constraints = {
>                .valid_ops_mask = REGULATOR_CHANGE_STATUS,
>        },
>        .num_consumer_supplies  = 1,
>        .consumer_supplies      = &nowplus_wl1271_supply,
> };
>
> static struct fixed_voltage_config nowplus_vwlan = {
>        .supply_name            = "vwl1271",
>        .microvolts             = 1800000, /* 1.8V */
>        .gpio                   = NOWPLUS_WLAN_PMENA_GPIO,
>        .startup_delay          = 70000, /* 70msec */
>        .enable_high            = 1,
>        .enabled_at_boot        = 0,
>        .init_data              = &nowplus_wlgpio,
> };
>
> static struct platform_device nowplus_vwlan_device = {
>        .name           = "reg-fixed-voltage",
>        .id             = 1,
>        .dev = {
>                .platform_data  = &nowplus_vwlan,
>        },
> };
>
> static int nowplus_twl_gpio_setup(struct device *dev,
>                unsigned gpio, unsigned ngpio)
> {
>        omap2_hsmmc_init(nowplus_mmc);
>
>        /* link regulators to MMC adapters */
>        nowplus_vmmc1_supply.dev = nowplus_mmc[0].dev;
>        nowplus_vmmc2_supply.dev = nowplus_mmc[1].dev;
>        nowplus_vsim_supply.dev = nowplus_mmc[2].dev;
>
>        return 0;
> }
>
> ---------------------------------------------------------------
>
> [    1.475463] mmc2: card claims to support voltages below the defined
> range. These will be ignored.
> [    1.518280] mmc2: queuing unknown CIS tuple 0x91 (3 bytes)
> [    1.535400] mmc2: new SDIO card at address 0001
> [    1.540435] PM: Adding info for mmc:mmc2:0001
> [    1.545562] PM: Adding info for sdio:mmc2:0001:1
> [    1.550689] wl1271_sdio mmc2:0001:1: __pm_runtime_resume()!
> [    1.559722] mmc mmc2:0001: __pm_runtime_resume()!
> [    1.564270] mmc mmc2:0001: __pm_runtime_resume() returns 1!
> [    1.573120] wl1271_sdio mmc2:0001:1: __pm_runtime_resume() returns 0!
> [    1.582061] sdio mmc2:0001:1: __pm_runtime_suspend()!
> [    1.586608] sdio mmc2:0001:1: __pm_runtime_suspend() returns 0!
> [    1.595397] PM: Adding info for sdio:mmc2:0001:2
> [    1.600219] wl1271_sdio mmc2:0001:2: __pm_runtime_resume()!
> [    1.609069] mmc mmc2:0001: __pm_runtime_resume()!
> [    1.613464] mmc mmc2:0001: __pm_runtime_resume() returns 1!
> [    1.622375] wl1271_sdio mmc2:0001:2: __pm_runtime_resume() returns 0!
> [    1.632232] PM: Adding info for platform:wl1271
> [    1.637268] PM: Adding info for No Bus:phy0
> [    1.643096] PM: Adding info for No Bus:wlan0
> [    1.648162] wl1271: loaded
> [    1.652587] wl1271: initialized
> [    1.656768] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend()!
> [    1.665130] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend() returns 0!
> [    6.197753] Freeing init memory: 136K
> [    6.510559] PM: Adding info for No Bus:vcs2
> [    6.511383] PM: Adding info for No Bus:vcsa2
> [   13.935028] wl1271: mac80211 start
> [   13.935058] wl1271: mac80211 stop
> [   24.939239] usb0: no IPv6 routers present
>
> <wlan0 brought up>
>
> --- wlan0 down ---
> [  161.776367] wl1271: mac80211 configure filter
> [  161.776397] wl1271: waking up chip from elp
> [  161.776702] wl1271: mac80211 configure filter
> [  161.782470] wl1271: IRQ
> [  161.782531] wl1271: wakeup time: 0 ms
> [  161.782531] wl1271: acx group address tbl
> [  161.782562] wl1271: cmd configure
> [  161.783325] wl1271: IRQ work
> [  161.783447] wl1271: intr: 0x20 (fw_rx_counter = 0, drv_rx_counter =
> 0, tx_results_counter = 0)
> [  161.783477] wl1271: WL1271_ACX_INTR_HW_AVAILABLE
> [  161.783508] wl1271: acx group address tbl
> [  161.783508] wl1271: cmd configure
> [  161.783966] wl1271: mac80211 remove interface
> [  161.783996] wl1271: down
> [  161.784088] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend()!
> [  161.784149] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend() returns 0!
> [  161.784179] wl1271: mac80211 stop
> [  161.790985] wl1271: elp work
>
> --- wlan0 up ---
> [  189.104309] wl1271: mac80211 start
> [  189.104339] wl1271: mac80211 add interface type 2 mac a0:07:98:6a:f8:c7
> [  189.134704] wl1271_sdio mmc2:0001:2: __pm_runtime_resume()!
> [  189.134735] mmc mmc2:0001: __pm_runtime_resume()!
> [  189.134765] mmc mmc2:0001: __pm_runtime_resume() returns 1!
> [  189.134796] wl1271_sdio mmc2:0001:2: __pm_runtime_resume() returns 0!
> [  189.345672] wl1271: mem_start 00000000 mem_size 00000000
> [  189.345703] wl1271: reg_start 00300000 reg_size 00008800
> [  189.345703] wl1271: mem2_start 00000000 mem2_size 00000000
> [  189.345733] wl1271: mem3_start 00000000 mem3_size 00000000
> [  189.346252] wl1271: chip id 0x4030111 (1271 PG20)
> [  189.346954] wl1271: pause1 0x40f73
> [  189.347534] wl1271: mem_start 00040000 mem_size 00014FC0
> [  189.347564] wl1271: reg_start 00310000 reg_size 00006000
> [  189.347564] wl1271: mem2_start 00000000 mem2_size 00000000
> [  189.347595] wl1271: mem3_start 00000000 mem3_size 00000000
> [  189.347900] wl1271: DRPW_SCRATCH_START 0031002c
> [  189.347961] wl1271: clk2 0x80316a2c
> [  189.348022] wl1271: mem_start 00040000 mem_size 00014FC0
> [  189.348022] wl1271: reg_start 00300000 reg_size 0000A000
> [  189.348052] wl1271: mem2_start 003004F8 mem2_size 00000004
> [  189.348052] wl1271: mem3_start 00040404 mem3_size 00000000
> [  189.348480] wl1271: soft reset bootdata 0x0
> [  189.348571] wl1271: nvs burst write 0x30546c: 0x986af8c7
> [  189.348632] wl1271: nvs burst write 0x305470: 0xa007
> [  189.348693] wl1271: mem_start 00040000 mem_size 00014FC0
> [  189.348724] wl1271: reg_start 00300000 reg_size 0000A000
> [  189.348724] wl1271: mem2_start 003004F8 mem2_size 00000004
> [  189.348754] wl1271: mem3_start 00040404 mem3_size 00000000
> [  189.349121] wl1271: ACX_EEPROMLESS_IND_REG
> [  189.349212] wl1271: chip id 0x4030111
> [  189.349548] wl1271: firmware chunks to be uploaded: 6
> [  189.349578] wl1271: chunk 5 addr 0x0 len 195924
> [  189.349609] wl1271: starting firmware upload
> [  189.349609] wl1271: fw_data_len 195924 chunk_size 512
> [  189.349639] wl1271: mem_start 00000000 mem_size 000177C0
> [  189.349639] wl1271: reg_start 00300000 reg_size 00008800
> [  189.349670] wl1271: mem2_start 00000000 mem2_size 00000000
> [  189.349670] wl1271: mem3_start 00000000 mem3_size 00000000
> [  189.349975] wl1271: uploading fw chunk 0xd085900c to 0x0
> <...>
> [  191.986022] wl1271: uploading fw last chunk (176 B) 0xd089b4b0 to 0x316e00
> [  191.986297] wl1271: chip id after firmware boot: 0x4030111
> [  194.105377] wl1271: ERROR timeout waiting for the hardware to
> complete initialization
> <...>
> [  194.485961] wl1271: uploading fw last chunk (176 B) 0xd089b4b0 to 0x316e00
> [  195.884368] wl1271: ERROR sdio read failed (-110)
> [  195.884460] wl1271: ERROR sdio write failed (-110)
> [  197.282745] wl1271: ERROR sdio read failed (-110)
> [  197.282775] wl1271: chip id after firmware boot: 0x101
> [  197.282775] wl1271: ERROR chip id doesn't match after firmware boot
> [  197.282867] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend()!
> [  197.282958] wl1271_sdio mmc2:0001:2: __pm_runtime_suspend() returns 0!
> [  197.282989] wl1271: ERROR firmware boot failed despite 3 retries
> [  197.282989] wl1271: mac80211 stop
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
