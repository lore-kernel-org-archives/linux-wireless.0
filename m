Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35553 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbeASNda (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 08:33:30 -0500
Received: by mail-it0-f42.google.com with SMTP id e1so2133848ita.0
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 05:33:30 -0800 (PST)
From: Kyle Evans <kvans32@gmail.com>
Date: Fri, 19 Jan 2018 11:05:54 -0500
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kyle Evans <kvans32@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: sdio failure to initialize on warm boot.
Message-ID: <20180119160554.GA4162@localhost.localdomain> (sfid-20180119_143334_955816_C3BF6AD4)
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com>
 <20180118172804.GA1170@localhost.localdomain>
 <5A61AA9E.6000505@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A61AA9E.6000505@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Arend van Spriel <arend.vanspriel@broadcom.com>:
> On 1/18/2018 6:50 PM, Kyle Evans wrote:
> > * Arend van Spriel <arend.vanspriel@broadcom.com>:
> >> On 1/12/2018 9:18 PM, Kyle Evans wrote:
> >>> 2) After reboot I get this nasty error...
> >>> [    0.000000] Kernel command line: console=tty0 selinux=0
> >>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
> >>> [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
> >>> [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
> >>> using ADMA
> >>> [    2.645242] mmc0: error -110 whilst initialising SDIO card
> >>
> >> Ok. I suppose you mean a warm reboot. So I suppose the card is not
> >> properly power cycled. If your SDHCI controller driver (is it
> >> sdhci-acpi?) is loaded as a module, you could try to unload it and load
> >> it again. Let me know if that works for you to confirm my guess.
> >
> > Your guess is correct. The following brings up wifi after failure to do
> > so during warm boot.
> >
> > modprobe -r sdhci-tegra; modprobe sdhci-tegra;
> 
> Do you know if your uses a device tree and where I can find it? 
> Typically, there is a GPIO to the wifi device that needs to be toggled 
> using mmc powerseq.

I had a hunch this is was the next step. This device did not ship with a 
DT, but I have one in the works. My initial trial & error has been met 
with error. 

This is what I have so far, which is wrong since adding pwrseq (boot panic):
	sdhci@c8000000 {
                compatible = "nvidia,tegra20-sdhci";
                reg = <0xc8000000 0x200>;
                interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
                clocks = <&tegra_car TEGRA20_CLK_SDMMC1>;
                resets = <&tegra_car 14>;
                reset-names = "sdhci";

                status = "okay";
                //power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
                bus-width = <4>;
                keep-power-in-suspend;
                non-removable;
                mmc-pwrseq = <&wlan_rst>;

                brcmf: wifi@1 {
                        compatible = "brcm,bcm4329-fmac";
                        interrupt-parent = <&gpio>;
                        interrupts = <TEGRA_GPIO(Y, 6) GPIO_ACTIVE_HIGH>,
                                     <TEGRA_GPIO(S, 0) GPIO_ACTIVE_HIGH>;
                        interrupt-names = "host-wake";
                };
        };

        wlan_rst: sdhci0_pwrseq {
                compatible = "mmc-pwrseq-simple";
                reset-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_LOW>;
        };


This stuff is from a pre-DT kernel:

#define TF101_WLAN_RST  TEGRA_GPIO_PK6
#define TF101_WLAN_WOW  TEGRA_GPIO_PS0
#define TF101_SDIO_WOW  TEGRA_GPIO_PY6

static struct embedded_sdio_data embedded_sdio_data1 = {
        .cccr   = {
                .sdio_vsn       = 2,
                .multi_block    = 1,
                .low_speed      = 0,
                .wide_bus       = 0,
                .high_power     = 1,
                .high_speed     = 1,
        },
        .cis  = {
                .vendor         = 0x02d0,
                .device         = 0x4329,
        },
}
static struct tegra_sdhci_platform_data tegra_sdhci_platform_data1 = {
        .mmc_data = {
                .register_status_notify = tf101_wifi_status_register,
                .embedded_sdio = &embedded_sdio_data1,
                .built_in = 0,
        },
        .wow_gpio = TF101_SDIO_WOW,
        .cd_gpio = -1,
        .wp_gpio = -1,
        .power_gpio = -1,
        .max_clk_limit = 40000000,
}

static int tf101_wifi_power(int on)
{
        pr_debug("%s: %d\n", __func__, on);

#if 0
        gpio_set_value(TF101_WLAN_PWR, on);
        mdelay(100);
#endif
        gpio_set_value(TF101_WLAN_RST, on);
        mdelay(200);

        return 0;
}

static int __init tf101_wifi_init(void)
{
        //gpio_request(TF101_WLAN_PWR, "wlan_power");
        gpio_request(TF101_WLAN_RST, "wlan_rst");
        gpio_request(TF101_WLAN_WOW, "bcmsdh_sdmmc");

        //tegra_gpio_enable(TF101_WLAN_PWR);
        tegra_gpio_enable(TF101_WLAN_RST);
        tegra_gpio_enable(TF101_WLAN_WOW);

        //gpio_direction_output(TF101_WLAN_PWR, 0);
        gpio_direction_output(TF101_WLAN_RST, 0);
        gpio_direction_input(TF101_WLAN_WOW);

        platform_device_register(&tf101_wifi_device);

        device_init_wakeup(&tf101_wifi_device.dev, 1);
        device_set_wakeup_enable(&tf101_wifi_device.dev, 0);

        return 0;
}

static struct resource tf101_bcm4329_rfkill_resources[] = {
        {
                .name   = "bcm4329_nshutdown_gpio",
                .start  = TEGRA_GPIO_PU0,
                .end    = TEGRA_GPIO_PU0,
                .flags  = IORESOURCE_IO,
        },
};

static struct resource tf101_bluesleep_resources[] = {
        [0] = {
                .name = "gpio_host_wake",
                        .start  = TEGRA_GPIO_PU6,
                        .end    = TEGRA_GPIO_PU6,
                        .flags  = IORESOURCE_IO,
        },
        [1] = {
                .name = "gpio_ext_wake",
                        .start  = TEGRA_GPIO_PU1,
                        .end    = TEGRA_GPIO_PU1,
                        .flags  = IORESOURCE_IO,
        },
        [2] = {
                .name = "host_wake",
                        .start  = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PU6),
                        .end    = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PU6),
                        .flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
        },
};

Asside from getting reboot to work, I am at a loss where to put all of 
the wakeup sources and rfkill nodes.
S,0 - WLAN_WOW
Y,6 - SDIO_WOW
U,6 - bt host_wake
U,1 - bt ext_wake
U,0 - rfkill

Thanks,
Kyle

> 
> Regards,
> Arend
> 
