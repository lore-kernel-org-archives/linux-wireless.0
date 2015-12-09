Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36855 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbbLINKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 08:10:13 -0500
Received: by lbblt2 with SMTP id lt2so29768149lbb.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2015 05:10:11 -0800 (PST)
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>,
	Amit Kucheria <amit.kucheria@linaro.org>, arm@kernel.org,
	Haavard Skinnemoen <hskinnemoen@gmail.com>,
	Sonic Zhang <sonic.zhang@analog.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	Anatolij Gustschin <agust@denx.de>,
	linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 000/182] Rid struct gpio_chip from container_of() usage
Date: Wed,  9 Dec 2015 14:08:35 +0100
Message-Id: <1449666515-23343-1-git-send-email-linus.walleij@linaro.org> (sfid-20151209_141027_685668_7C59697E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the use of container_of() constructions from *all*
GPIO drivers in the kernel. It is done by instead adding an
optional void *data pointer to the struct gpio_chip and an
accessor function, gpiochip_get_data() to get it from a driver.

WHY?

Because we want to have a proper userspace ABI for GPIO chips,
which involves using a character device that the user opens
and closes. While the character device is open, the underlying
kernel objects must not go away.

Currently the GPIO drivers keep their state in the struct
gpio_chip, and that is often allocated by the drivers, very
often as a part of a containing per-instance state container
struct for the driver:

struct foo_state {
   struct gpio_chip chip;  <- OMG my state is there
};

Drivers cannot allocate and manage this state: if a user has the
character device open, the objects allocated must stay around
even if the driver goes away. Instead drivers need to pass a
descriptor to the GPIO core, and then the core should allocate
and manage the lifecycle of things related to the device, such
as the chardev itself or the struct device related to the GPIO
device.

Thus what is today gpiochip_add() (and after this patch set
gpiochip_add_data()) must return a pointer/cookie to an object
maintained elsewhere. The object passed back to the functions
in the vtable of a gpio_chip like .request(), .get_value(),
.set_value() etc must also be changed.

Thus container_of() constructions will not work, because
container_of(), clever as it is, does not work with a member
that is a pointer: it needs a full struct inside the
containing struct.

This patch set takes the first step by eliminating container_of()
and replacing it with a data pointer mechanism.

The patch set is just a step in the larger refactoring needed
but stands on its own as it happens to remove 500+ lines
of code and (IMO) makes the code in all drivers easier
to read and understand.

I need ACKs to merge this through the GPIO tree.

I do not think we will see collissions in the merge window
but if you're adding new gpio_chips or deleting drivers,
write me so we can work something out. (Immutable branches
that I can pull and make fixes on top of would be the
best.)

And as mentioned this kind of series will continue.

If you think it looks invasive, think of the changes done
for irq_chip over the year. GPIO is in a similar situation.

Linus Walleij (182):
  gpio: forward-declare enum gpiod_flags
  gpio: add a data pointer to gpio_chip
  gpio: of: provide optional of_mm_gpiochip_add_data() function
  gpio: generic: factor into gpio_chip struct
  gpio: 104-idi-48: use gpiochip data pointer
  gpio: 104-idio-16: use gpiochip data pointer
  gpio: 74x164: use gpiochip data pointer
  gpio: adnp: use gpiochip data pointer
  gpio: adp5520: use gpiochip data pointer
  gpio: adp5588: use gpiochip data pointer
  gpio: altera: use gpiochip data pointer
  gpio: amd8111: use gpiochip data pointer
  gpio: amdpt: use gpiochip data pointer
  gpio: arizona: use gpiochip data pointer
  gpio: ath79: use gpiochip data pointer
  gpio: bcm-kona: use gpiochip data pointer
  gpio: bt8xx: use gpiochip data pointer
  gpio: crystalcove: use gpiochip data pointer
  gpio: cs5535: use gpiochip data pointer
  gpio: da9052: use gpiochip data pointer
  gpio: da9055: use gpiochip data pointer
  gpio: davinci: use gpiochip data pointer
  gpio: dln2: use gpiochip data pointer
  gpio: em: use gpiochip data pointer
  gpio: f7188: use gpiochip data pointer
  gpio: intel-mid: use gpiochip data pointer
  gpio: it87: use gpiochip data pointer
  gpio: kempld: use gpiochip data pointer
  gpio: lp3943: use gpiochip data pointer
  gpio: lpc18xx: use gpiochip data pointer
  gpio: lpc32xx: use gpiochip data pointer
  gpio: lynxpoint: use gpiochip data pointer
  gpio: max730x: use gpiochip data pointer
  gpio: max732x: use gpiochip data pointer
  gpio: mb86s7x: use gpiochip data pointer
  gpio: mc33880: use gpiochip data pointer
  gpio: mc9s08dz60: use gpiochip data pointer
  gpio: mcp: use gpiochip data pointer
  gpio: ml-ioh: use gpiochip data pointer
  gpio: mm-lantiq: use gpiochip data pointer
  gpio: mpc5200: use gpiochip data pointer
  gpio: mpc8xxx: use gpiochip data pointer
  gpio: msic: use gpiochip data pointer
  gpio: mvebu: use gpiochip data pointer
  gpio: octeon: use gpiochip data pointer
  gpio: omap: use gpiochip data pointer
  gpio: palmas: use gpiochip data pointer
  gpio: pca953x: use gpiochip data pointer
  gpio: pcf857x: use gpiochip data pointer
  gpio: pch: use gpiochip data pointer
  gpio: pl061: use gpiochip data pointer
  gpio: pxa: use gpiochip data pointer
  gpio: rc5t583: use gpiochip data pointer
  gpio: rcar: use gpiochip data pointer
  gpio: rdc321x: use gpiochip data pointer
  gpio: samsung: use gpiochip data pointer
  gpio: sch: use gpiochip data pointer
  gpio: sch311x: use gpiochip data pointer
  gpio: spear-spics: use gpiochip data pointer
  gpio: sta2x11: use gpiochip data pointer
  gpio: stmpe: use gpiochip data pointer
  gpio: stp-xway: use gpiochip data pointer
  gpio: sx150x: use gpiochip data pointer
  gpio: syscon: use gpiochip data pointer
  gpio: tb10x: use gpiochip data pointer
  gpio: tc3589x: use gpiochip data pointer
  gpio: timberdale: use gpiochip data pointer
  gpio: tps6586x: use gpiochip data pointer
  gpio: tps65910: use gpiochip data pointer
  gpio: tps65912: use gpiochip data pointer
  gpio: ts5500: use gpiochip data pointer
  gpio: twl4030: use gpiochip data pointer
  gpio: tz1090-pdc: use gpiochip data pointer
  gpio: tz1090: use gpiochip data pointer
  gpio: ucb1400: use gpiochip data pointer
  gpio: vf610: use gpiochip data pointer
  gpio: viperboard: use gpiochip data pointer
  gpio: vx855: use gpiochip data pointer
  gpio: wm831x: use gpiochip data pointer
  gpio: wm8350: use gpiochip data pointer
  gpio: wm8994: use gpiochip data pointer
  gpio: xgene: use gpiochip data pointer
  gpio: xilinx: use gpiochip data pointer
  gpio: xlp: use gpiochip data pointer
  gpio: zevio: use gpiochip data pointer
  gpio: zx: use gpiochip data pointer
  gpio: zynq: use gpiochip data pointer
  gpio: convert remaining users to gpiochip_add_data()
  gpio: fix misleading comment
  pinctrl: cygnus-gpio: use gpiochip data pointer
  pinctrl: baytrail: use gpiochip data pointer
  pinctrl: bcm2835: use gpiochip data pointer
  pinctrl: cherryview: use gpiochip data pointer
  pinctrl: intel: use gpiochip data pointer
  pinctrl: meson: use gpiochip data pointer
  pinctrl: nomadik: use gpiochip data pointer
  pinctrl: abx500: use gpiochip data pointer
  pinctrl: adi2: use gpiochip data pointer
  pinctrl: amd: use gpiochip data pointer
  pinctrl: as3722: use gpiochip data pointer
  pinctrl: at91: use gpiochip data pointer
  pinctrl: u300: use gpiochip data pointer
  pinctrl: digicolor: use gpiochip data pointer
  pinctrl: pistachio: use gpiochip data pointer
  pinctrl: rockchip: use gpiochip data pointer
  pinctrl: st: use gpiochip data pointer
  pinctrl: msm: use gpiochip data pointer
  pinctrl: spmi: use gpiochip data pointer
  pinctrl: spmi-mpp: use gpiochip data pointer
  pinctrl: ssbi-mpp: use gpiochip data pointer
  pinctrl: ssbi-gpio: use gpiochip data pointer
  pinctrl: samsung: use gpiochip data pointer
  pinctrl: sunxi: use gpiochip data pointer
  pinctrl: sh-pfc: use gpiochip data pointer
  pinctrl: sirf-atlas7: use gpiochip data pointer
  pinctrl: sirf: use gpiochip data pointer
  pinctrl: spear-plgpio: use gpiochip data pointer
  pinctrl: mediatek: use gpiochip data pointer
  pinctrl: at91-pio4: use gpiochip data pointer
  pinctrl: xway: use gpiochip data pointer
  pinctrl: exynos5440: use gpiochip data pointer
  pinctrl: vt8500-wmt: use gpiochip data pointer
  ARM: scoop: use gpiochip data pointer
  ARM: gemini: switch to gpiochip_add_data()
  ARM: imx: switch to gpiochip_add_data()
  ARM: ixp4xx: switch to gpiochip_add_data()
  ARM: s3c24xx: switch to gpiochip_add_data()
  ARM: simpad: switch to gpiochip_add_data()
  ARM: w90x900: use gpiochip data pointer
  ARM: plat-orion: use gpiochip data pointer
  avr32: gpio: use gpiochip data pointer
  blackfin: gpio: switch to gpiochip_add_data()
  blackfin: extgpio: switch to gpiochip_add_data()
  m68k: gpio: switch to gpiochip_add_data()
  MIPS: alchemy: switch to gpiochip_add_data()
  MIPS: ar7: use gpiochip data pointer
  MIPS: bcm63xx: switch to gpiochip_add_data()
  MIPS: jz4740: use gpiochip data pointer
  MIPS: txx9: switch to gpiochip_add_data()
  MIPS: rb532: use gpiochip data pointer
  MIPS: txx9: iocled: use gpiochip data pointer
  MIPS: txx9: rbtx4938: switch to gpiochip_add_data()
  powerpc: mpc52xx_gpt: use gpiochip data pointer
  powerpc: mpc8349emitx: use gpiochip data pointer
  powerpc: sysdev: cpm1: use gpiochip data pointer
  powerpc: cpm_common: use gpiochip data pointer
  powerpc: ppc4xx: use gpiochip data pointer
  powerpc: qe_lib-gpio: use gpiochip data pointer
  powerpc: simple-gpio: use gpiochip data pointer
  sh: sdk7786-gpio: switch to gpiochip_add_data()
  sh: x3proto-gpio: switch to gpiochip_add_data()
  unicore32: gpio: switch to gpiochip_add_data()
  bcma: gpio: use gpiochip data pointer
  hid: cp2112: use gpiochip data pointer
  input: adp5588-keys: use gpiochip data pointer
  input: adp5589-keys: use gpiochip data pointer
  input: ad7879: use gpiochip data pointer
  leds: pca9532: use gpiochip data pointer
  leds: tca6507: use gpiochip data pointer
  [media]: cxd2830r: use gpiochip data pointer
  mfd: asic3: use gpiochip data pointer
  mfd: dm355evm_msp: switch to gpiochip_add_data()
  mfd: htc-egpio: use gpiochip data pointer
  mfd: htc-i2cpld: use gpiochip data pointer
  mfd: sm501: use gpiochip data pointer
  mfd: tc6393xb: use gpiochip data pointer
  mfd: tps65010: use gpiochip data pointer
  mfd: ucb1x00: use gpiochip data pointer
  mfd: vexpress-sysreg: switch to gpiochip_add_data()
  platform: x86: intel-pmic: use gpiochip data pointer
  ssb: gpio_driver: use gpiochip data pointer
  staging: vme: use gpiochip data pointer
  serial: max310x: use gpiochip data pointer
  serial: sc16is7xx: use gpiochip data pointer
  video: fbdev: via: use gpiochip data pointer
  ASoC: rt5677: use gpiochip data pointer
  ASoC: wm5100: use gpiochip data pointer
  ASoC: wm8903: use gpiochip data pointer
  ASoC: wm8962: use gpiochip data pointer
  ASoC: wm8996: use gpiochip data pointer
  ASoC: ac97: use gpiochip data pointer
  gpio: remove non-parametrized register functions

 arch/arm/common/scoop.c                        |  10 +-
 arch/arm/mach-clps711x/board-autcpu12.c        |   2 +-
 arch/arm/mach-clps711x/board-p720t.c           |   2 +-
 arch/arm/mach-gemini/gpio.c                    |   4 +-
 arch/arm/mach-imx/mach-mx21ads.c               |   2 +-
 arch/arm/mach-imx/mach-mx27ads.c               |   4 +-
 arch/arm/mach-ixp4xx/common.c                  |   4 +-
 arch/arm/mach-omap1/board-ams-delta.c          |   2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c             |   2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c          |   2 +-
 arch/arm/mach-sa1100/simpad.c                  |   4 +-
 arch/arm/mach-w90x900/gpio.c                   |  13 +-
 arch/arm/plat-orion/gpio.c                     |  24 +-
 arch/avr32/mach-at32ap/pio.c                   |  12 +-
 arch/blackfin/kernel/bfin_gpio.c               |   4 +-
 arch/blackfin/mach-bf538/ext-gpio.c            |   6 +-
 arch/m68k/coldfire/gpio.c                      |   2 +-
 arch/mips/alchemy/common/gpiolib.c             |   8 +-
 arch/mips/ar7/gpio.c                           |  26 +--
 arch/mips/bcm63xx/gpio.c                       |   4 +-
 arch/mips/jz4740/gpio.c                        |  10 +-
 arch/mips/kernel/gpio_txx9.c                   |   4 +-
 arch/mips/rb532/gpio.c                         |  12 +-
 arch/mips/txx9/generic/setup.c                 |  10 +-
 arch/mips/txx9/rbtx4938/setup.c                |   3 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |  13 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   6 +-
 arch/powerpc/sysdev/cpm1.c                     |  36 +--
 arch/powerpc/sysdev/cpm_common.c               |  18 +-
 arch/powerpc/sysdev/ppc4xx_gpio.c              |  16 +-
 arch/powerpc/sysdev/qe_lib/gpio.c              |  20 +-
 arch/powerpc/sysdev/simple_gpio.c              |  13 +-
 arch/sh/boards/mach-sdk7786/gpio.c             |   4 +-
 arch/sh/boards/mach-x3proto/gpio.c             |   4 +-
 arch/unicore32/kernel/gpio.c                   |   4 +-
 drivers/bcma/driver_gpio.c                     |  23 +-
 drivers/gpio/gpio-104-idi-48.c                 |  15 +-
 drivers/gpio/gpio-104-idio-16.c                |  17 +-
 drivers/gpio/gpio-74x164.c                     |  11 +-
 drivers/gpio/gpio-74xx-mmio.c                  |  37 ++--
 drivers/gpio/gpio-adnp.c                       |  27 +--
 drivers/gpio/gpio-adp5520.c                    |  10 +-
 drivers/gpio/gpio-adp5588.c                    |  18 +-
 drivers/gpio/gpio-altera.c                     |  23 +-
 drivers/gpio/gpio-amd8111.c                    |  16 +-
 drivers/gpio/gpio-amdpt.c                      |  16 +-
 drivers/gpio/gpio-arizona.c                    |  15 +-
 drivers/gpio/gpio-ath79.c                      |  16 +-
 drivers/gpio/gpio-bcm-kona.c                   |  25 +--
 drivers/gpio/gpio-brcmstb.c                    |  80 +++----
 drivers/gpio/gpio-bt8xx.c                      |  10 +-
 drivers/gpio/gpio-clps711x.c                   |  28 +--
 drivers/gpio/gpio-crystalcove.c                |  32 +--
 drivers/gpio/gpio-cs5535.c                     |  15 +-
 drivers/gpio/gpio-da9052.c                     |  17 +-
 drivers/gpio/gpio-da9055.c                     |  17 +-
 drivers/gpio/gpio-davinci.c                    |  15 +-
 drivers/gpio/gpio-dln2.c                       |  28 +--
 drivers/gpio/gpio-dwapb.c                      |  92 ++++----
 drivers/gpio/gpio-em.c                         |   4 +-
 drivers/gpio/gpio-ep93xx.c                     |  25 ++-
 drivers/gpio/gpio-etraxfs.c                    |  49 ++---
 drivers/gpio/gpio-f7188x.c                     |  14 +-
 drivers/gpio/gpio-ge.c                         |  24 +-
 drivers/gpio/gpio-generic.c                    | 292 +++++++++++--------------
 drivers/gpio/gpio-grgpio.c                     |  73 +++----
 drivers/gpio/gpio-ich.c                        |   2 +-
 drivers/gpio/gpio-intel-mid.c                  |  19 +-
 drivers/gpio/gpio-iop.c                        |   2 +-
 drivers/gpio/gpio-it87.c                       |  17 +-
 drivers/gpio/gpio-janz-ttl.c                   |   2 +-
 drivers/gpio/gpio-kempld.c                     |  17 +-
 drivers/gpio/gpio-ks8695.c                     |   2 +-
 drivers/gpio/gpio-loongson.c                   |   2 +-
 drivers/gpio/gpio-lp3943.c                     |  19 +-
 drivers/gpio/gpio-lpc18xx.c                    |  13 +-
 drivers/gpio/gpio-lpc32xx.c                    |  33 ++-
 drivers/gpio/gpio-lynxpoint.c                  |  22 +-
 drivers/gpio/gpio-max730x.c                    |  10 +-
 drivers/gpio/gpio-max732x.c                    |  25 +--
 drivers/gpio/gpio-mb86s7x.c                    |  19 +-
 drivers/gpio/gpio-mc33880.c                    |   4 +-
 drivers/gpio/gpio-mc9s08dz60.c                 |  14 +-
 drivers/gpio/gpio-mcp23s08.c                   |  14 +-
 drivers/gpio/gpio-ml-ioh.c                     |  12 +-
 drivers/gpio/gpio-mm-lantiq.c                  |   9 +-
 drivers/gpio/gpio-moxart.c                     |  29 ++-
 drivers/gpio/gpio-mpc5200.c                    |  22 +-
 drivers/gpio/gpio-mpc8xxx.c                    |  23 +-
 drivers/gpio/gpio-msic.c                       |   4 +-
 drivers/gpio/gpio-mvebu.c                      |  23 +-
 drivers/gpio/gpio-mxc.c                        |  27 +--
 drivers/gpio/gpio-mxs.c                        |  33 ++-
 drivers/gpio/gpio-octeon.c                     |  10 +-
 drivers/gpio/gpio-omap.c                       |  20 +-
 drivers/gpio/gpio-palmas.c                     |  17 +-
 drivers/gpio/gpio-pca953x.c                    |  25 +--
 drivers/gpio/gpio-pcf857x.c                    |   8 +-
 drivers/gpio/gpio-pch.c                        |  12 +-
 drivers/gpio/gpio-pl061.c                      |  20 +-
 drivers/gpio/gpio-pxa.c                        |   5 +-
 drivers/gpio/gpio-rc5t583.c                    |  19 +-
 drivers/gpio/gpio-rcar.c                       |  33 +--
 drivers/gpio/gpio-rdc321x.c                    |  10 +-
 drivers/gpio/gpio-sa1100.c                     |   2 +-
 drivers/gpio/gpio-samsung.c                    |   4 +-
 drivers/gpio/gpio-sch.c                        |  14 +-
 drivers/gpio/gpio-sch311x.c                    |  21 +-
 drivers/gpio/gpio-sodaville.c                  |  13 +-
 drivers/gpio/gpio-spear-spics.c                |  11 +-
 drivers/gpio/gpio-sta2x11.c                    |  12 +-
 drivers/gpio/gpio-stmpe.c                      |  29 +--
 drivers/gpio/gpio-stp-xway.c                   |   8 +-
 drivers/gpio/gpio-sx150x.c                     |  25 +--
 drivers/gpio/gpio-syscon.c                     |  17 +-
 drivers/gpio/gpio-tb10x.c                      |  17 +-
 drivers/gpio/gpio-tc3589x.c                    |  25 +--
 drivers/gpio/gpio-tegra.c                      |   2 +-
 drivers/gpio/gpio-timberdale.c                 |   8 +-
 drivers/gpio/gpio-tps6586x.c                   |  15 +-
 drivers/gpio/gpio-tps65910.c                   |  15 +-
 drivers/gpio/gpio-tps65912.c                   |  12 +-
 drivers/gpio/gpio-ts5500.c                     |  17 +-
 drivers/gpio/gpio-twl4030.c                    |  21 +-
 drivers/gpio/gpio-twl6040.c                    |   2 +-
 drivers/gpio/gpio-tz1090-pdc.c                 |  13 +-
 drivers/gpio/gpio-tz1090.c                     |  17 +-
 drivers/gpio/gpio-ucb1400.c                    |  10 +-
 drivers/gpio/gpio-vf610.c                      |  23 +-
 drivers/gpio/gpio-viperboard.c                 |  28 +--
 drivers/gpio/gpio-vr41xx.c                     |   2 +-
 drivers/gpio/gpio-vx855.c                      |   8 +-
 drivers/gpio/gpio-wm831x.c                     |  21 +-
 drivers/gpio/gpio-wm8350.c                     |  17 +-
 drivers/gpio/gpio-wm8994.c                     |  21 +-
 drivers/gpio/gpio-xgene-sb.c                   |  40 ++--
 drivers/gpio/gpio-xgene.c                      |  17 +-
 drivers/gpio/gpio-xilinx.c                     |  17 +-
 drivers/gpio/gpio-xlp.c                        |  23 +-
 drivers/gpio/gpio-xtensa.c                     |   4 +-
 drivers/gpio/gpio-zevio.c                      |  15 +-
 drivers/gpio/gpio-zx.c                         |  23 +-
 drivers/gpio/gpio-zynq.c                       |  27 +--
 drivers/gpio/gpiolib-of.c                      |  12 +-
 drivers/gpio/gpiolib.c                         |  12 +-
 drivers/gpio/gpiolib.h                         |   2 +-
 drivers/hid/hid-cp2112.c                       |  16 +-
 drivers/input/keyboard/adp5588-keys.c          |  10 +-
 drivers/input/keyboard/adp5589-keys.c          |  10 +-
 drivers/input/touchscreen/ad7879.c             |  10 +-
 drivers/leds/leds-pca9532.c                    |   8 +-
 drivers/leds/leds-tca6507.c                    |   4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c    |  11 +-
 drivers/mfd/asic3.c                            |  10 +-
 drivers/mfd/dm355evm_msp.c                     |   2 +-
 drivers/mfd/htc-egpio.c                        |  10 +-
 drivers/mfd/htc-i2cpld.c                       |  15 +-
 drivers/mfd/sm501.c                            |  15 +-
 drivers/mfd/tc6393xb.c                         |  14 +-
 drivers/mfd/tps65010.c                         |   8 +-
 drivers/mfd/ucb1x00-core.c                     |  14 +-
 drivers/mfd/vexpress-sysreg.c                  |   8 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c          |  10 +-
 drivers/pinctrl/bcm/pinctrl-cygnus-gpio.c      |  33 ++-
 drivers/pinctrl/intel/pinctrl-baytrail.c       |  32 ++-
 drivers/pinctrl/intel/pinctrl-cherryview.c     |  20 +-
 drivers/pinctrl/intel/pinctrl-intel.c          |  15 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c  |  12 +-
 drivers/pinctrl/meson/pinctrl-meson.c          |  17 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c       |  27 +--
 drivers/pinctrl/nomadik/pinctrl-nomadik.c      |  25 +--
 drivers/pinctrl/pinctrl-adi2.c                 |  16 +-
 drivers/pinctrl/pinctrl-amd.c                  |  33 ++-
 drivers/pinctrl/pinctrl-as3722.c               |  13 +-
 drivers/pinctrl/pinctrl-at91-pio4.c            |  14 +-
 drivers/pinctrl/pinctrl-at91.c                 |  26 +--
 drivers/pinctrl/pinctrl-coh901.c               |  31 +--
 drivers/pinctrl/pinctrl-digicolor.c            |  10 +-
 drivers/pinctrl/pinctrl-pistachio.c            |  23 +-
 drivers/pinctrl/pinctrl-rockchip.c             |  15 +-
 drivers/pinctrl/pinctrl-st.c                   |  21 +-
 drivers/pinctrl/pinctrl-xway.c                 |  10 +-
 drivers/pinctrl/qcom/pinctrl-msm.c             |  29 +--
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c       |  19 +-
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c        |  19 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c       |  14 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c        |  14 +-
 drivers/pinctrl/samsung/pinctrl-exynos5440.c   |  14 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c      |  15 +-
 drivers/pinctrl/sh-pfc/gpio.c                  |  16 +-
 drivers/pinctrl/sirf/pinctrl-atlas7.c          |  29 +--
 drivers/pinctrl/sirf/pinctrl-sirf.c            |  29 +--
 drivers/pinctrl/spear/pinctrl-plgpio.c         |  22 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c          |  10 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c           |  10 +-
 drivers/platform/x86/intel_pmic_gpio.c         |   6 +-
 drivers/ssb/driver_gpio.c                      |  33 ++-
 drivers/staging/vme/devices/vme_pio2_gpio.c    |  17 +-
 drivers/tty/serial/max310x.c                   |  12 +-
 drivers/tty/serial/sc16is7xx.c                 |  16 +-
 drivers/video/fbdev/via/via-gpio.c             |  17 +-
 include/linux/basic_mmio_gpio.h                |  80 -------
 include/linux/gpio/driver.h                    |  64 +++++-
 include/linux/of_gpio.h                        |   5 +-
 sound/soc/codecs/rt5677.c                      |  17 +-
 sound/soc/codecs/wm5100.c                      |  16 +-
 sound/soc/codecs/wm8903.c                      |  17 +-
 sound/soc/codecs/wm8962.c                      |  15 +-
 sound/soc/codecs/wm8996.c                      |  16 +-
 sound/soc/soc-ac97.c                           |   8 +-
 210 files changed, 1602 insertions(+), 2178 deletions(-)
 delete mode 100644 include/linux/basic_mmio_gpio.h

-- 
2.4.3

