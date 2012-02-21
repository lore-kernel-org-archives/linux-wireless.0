Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35442 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2BUTwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:40 -0500
Message-ID: <4F43F5F8.6050108@hauke-m.de> (sfid-20120221_205243_686889_4A2BB502)
Date: Tue, 21 Feb 2012 20:52:24 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch
Subject: Re: [PATCH 00/11] ssb/bcma/BCM47XX: sprom fixes and extensions
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de> <20120221193744.GB19354@tuxdriver.com>
In-Reply-To: <20120221193744.GB19354@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2012 08:37 PM, John W. Linville wrote:
> Has Ralf seen the arch/mips patches?
> 
I just send it to the mips list, I will send v2 of the patches
explicitly to him and ask him.

> On Sun, Feb 19, 2012 at 07:32:14PM +0100, Hauke Mehrtens wrote:
>> This patch series fixes some errors in the sprom structures and extends 
>> it to contain members for all sprom values for sprom version 1 to 9. 
>> This was done by looking into the open source part of the Broadcom SDK. 
>> This also adds a fallback sprom registration method to bcma.
>> It also contains some small fixes for the bcma47xx arch code and a 
>> rewrite of the code to provide the sprom from flash. It now also 
>> provides sprom from flash for devices using bcma to control the system 
>> bus.
>>
>> This patch series is based on wireles-testing. I think it is the best 
>> way to merge this through John's wireless tree as the changes in the 
>> sprom struct should be used in further patches extending the pci sprom 
>> parsing and the usage of struct sprom by the brcmsmac driver.
>>
>> Hauke Mehrtens (11):
>>   ssb: sprom fix some sizes / signedness
>>   ssb: remove 5GHz antenna gain from sprom
>>   ssb: fix per path sprom vars
>>   ssb: add ccode
>>   ssb: add some missing sprom attributes
>>   bcma: export bcma_find_core
>>   bcma: add support for sprom not found on the device.
>>   MIPS: BCM47XX: return number of written bytes in nvram_getenv
>>   MIPS: BCM47XX: fix signature of nvram_parse_macaddr
>>   MIPS: BCM47XX: move and extend sprom parsing
>>   MIPS: BCM47XX: provide sprom to bcma bus
>>
>>  arch/mips/bcm47xx/Makefile                   |    2 +-
>>  arch/mips/bcm47xx/nvram.c                    |    3 +-
>>  arch/mips/bcm47xx/setup.c                    |  188 ++-------
>>  arch/mips/bcm47xx/sprom.c                    |  618 ++++++++++++++++++++++++++
>>  arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    3 +
>>  arch/mips/include/asm/mach-bcm47xx/nvram.h   |    2 +-
>>  drivers/bcma/main.c                          |    3 +-
>>  drivers/bcma/sprom.c                         |   75 +++-
>>  drivers/net/wireless/b43legacy/phy.c         |    2 +-
>>  drivers/ssb/pci.c                            |   40 +--
>>  drivers/ssb/pcmcia.c                         |   12 +-
>>  drivers/ssb/sdio.c                           |   12 +-
>>  include/linux/bcma/bcma.h                    |    7 +
>>  include/linux/ssb/ssb.h                      |  102 ++++-
>>  14 files changed, 844 insertions(+), 225 deletions(-)
>>  create mode 100644 arch/mips/bcm47xx/sprom.c
>>
>> -- 
>> 1.7.5.4
>>
>>
> 

