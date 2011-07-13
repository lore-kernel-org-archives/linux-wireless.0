Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33578 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1GMUGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 16:06:04 -0400
Message-ID: <4E1DFAA2.8060800@hauke-m.de> (sfid-20110713_220608_844395_E449F361)
Date: Wed, 13 Jul 2011 22:05:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Subject: Re: [PATCH 10/11] bcm47xx: add support for bcma bus
References: <1310209563-6405-1-git-send-email-hauke@hauke-m.de> <1310209563-6405-11-git-send-email-hauke@hauke-m.de> <CAOiHx=myVVQYJumwhy7FwoSp5-mebhryDs1xnKMLCZpn=NP-7Q@mail.gmail.com>
In-Reply-To: <CAOiHx=myVVQYJumwhy7FwoSp5-mebhryDs1xnKMLCZpn=NP-7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi  Jonas,

Thank you for the review.

On 07/13/2011 09:52 PM, Jonas Gorski wrote:
> On 9 July 2011 13:06, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This patch add support for the bcma bus. Broadcom uses only Mips 74K
>> CPUs on the new SoC and on the old ons using ssb bus there are no Mips
>> 74K CPUs.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  arch/mips/bcm47xx/Kconfig                    |   13 ++++++
>>  arch/mips/bcm47xx/gpio.c                     |   22 +++++++++++
>>  arch/mips/bcm47xx/nvram.c                    |   10 +++++
>>  arch/mips/bcm47xx/serial.c                   |   29 ++++++++++++++
>>  arch/mips/bcm47xx/setup.c                    |   53 +++++++++++++++++++++++++-
>>  arch/mips/bcm47xx/time.c                     |    5 ++
>>  arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    8 ++++
>>  arch/mips/include/asm/mach-bcm47xx/gpio.h    |   41 ++++++++++++++++++++
>>  drivers/watchdog/bcm47xx_wdt.c               |   11 +++++
>>  9 files changed, 190 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
>> index 0346f92..6210b8d 100644
>> --- a/arch/mips/bcm47xx/Kconfig
>> +++ b/arch/mips/bcm47xx/Kconfig
>> @@ -15,4 +15,17 @@ config BCM47XX_SSB
>>
>>         This will generate an image with support for SSB and MIPS32 R1 instruction set.
>>
>> +config BCM47XX_BCMA
>> +       bool "BCMA Support for Broadcom BCM47XX"
>> +       select SYS_HAS_CPU_MIPS32_R2
>> +       select BCMA
>> +       select BCMA_HOST_SOC
>> +       select BCMA_DRIVER_MIPS
>> +       select BCMA_DRIVER_PCI_HOSTMODE if PCI
>> +       default y
>> +       help
>> +        Add support for new Broadcom BCM47xx boards with Broadcom specific Advanced Microcontroller Bus.
>> +
>> +        This will generate an image with support for BCMA and MIPS32 R2 instruction set.
>> +
> 
> BCM47XX_SSB and BCM47XX_BCMA should either exclude each other, or
> SYS_HAS_CPU_MIPS32_R2 should only be selected when BCM47XX_SSB isn't
> selected.
> I would expect an image built when having both selected to also
> support both systems, but selecting MIPS32_R2 as the CPU this will
> make it actually not work on SSB systems.
It should be possible to build a kernel capable of running with both
versions. I would change "select SYS_HAS_CPU_MIPS32_R2" to "select
SYS_HAS_CPU_MIPS32_R2 if !BCM47XX_SSB" that should make the image mips
r1 compatible if it was build for older cpus.
> 
>> diff --git a/arch/mips/bcm47xx/gpio.c b/arch/mips/bcm47xx/gpio.c
>> index 3320e91..9d5bafe 100644
>> --- a/arch/mips/bcm47xx/gpio.c
>> +++ b/arch/mips/bcm47xx/gpio.c
>> @@ -36,6 +36,16 @@ int gpio_request(unsigned gpio, const char *tag)
>>
>>                return 0;
>>  #endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +       case BCM47XX_BUS_TYPE_BCMA:
>> +               if ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES)
> 
> gpio is already unsigned, you shouldn't need to cast it.
Will do that.
> 
>> +                       return -EINVAL;
>> +
>> +               if (test_and_set_bit(gpio, gpio_in_use))
>> +                       return -EBUSY;
>> +
>> +               return 0;
>> +#endif
>>        }
>>        return -EINVAL;
>>  }
>> @@ -57,6 +67,14 @@ void gpio_free(unsigned gpio)
>>                clear_bit(gpio, gpio_in_use);
>>                return;
>>  #endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +       case BCM47XX_BUS_TYPE_BCMA:
>> +               if ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES)
> 
> Ditto.

