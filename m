Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47812 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbG1Irz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:47:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 00/21] cover letter of Atmel WILC1000 patches
Date: Tue, 28 Jul 2015 17:47:19 +0900
Message-ID: <1438073261-28315-1-git-send-email-tony.cho@atmel.com> (sfid-20150728_104942_066024_77829F3B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,                                                                        
                                                        
I am Tony from Atmel working together with Johnny in charge of Atmel wireless   
driver, especially ATWILC1000 single WLAM driver. I know WILC1000 driver is     
very far from Linux coding style and there are so many changes required to be   
proper kernel driver over the Linux kernel tree. However, the progress was got
stucked due to mess related to 64-bit support problems as I know. So, I will
support him to go through it.

There are still many issues to tackle the 64-bit problem, mostly structural
issues. However, I will frequently send small patches while changing the
structural issues to be the kernel driver.

As listed in the TODO file, the followings will be patched:
- removing most warnings reported by checkpatch.pl
- removing OS wrapper to replace them by kernel API as is if possible
- removing 64-bit compile warnings
- removing platform dependencies in complie-time basis
- updating the WILC1000 driver with the latest version
- removing CamelCases
- removing the warnings for line over 80 characters

The followings are highlight in this patch:
- remove the unnecessary files which is not used anymore to simplify the driver.
- remove the dead conditionals related to SIMULATION which are not used.
- add more comments to describe the config symbols in the Kconfig.
- remove the platform dependencies in the wilc_sdio.c file.
- rewrte the wilc_sdio.c for the preprocessor conditionals to compile out
  the entire functions rather than portions of the function.
- remove the warnings reported by checkpatch.pl.

I always appreciate your comment and advice for my patches.

Best Regards,
Tony.

Jude.Lee (2):
  staging: wilc1000: remove multiple blank lines
  staging: wilc1000: alignment should match open parenthesis

Kim, Leo (3):
  staging: wilc1000: remove braces {} for single statement blocks
  staging: wilc1000: remove warnings on the multiple blank lines uses
  staging: wilc1000: remove unnecessary spcae

Tony Cho (16):
  staging: wilc1000: remove unnecessary files
  staging: wilc1000: describe the config symbol fully
  staging: wilc1000: remove dead codes related to SIMULATION
  staging: wilc1000: remove warnings on the multiple line uses
  staging: wilc1000: remove the warnings on missing blank line
  staging: wilc1000: remove the warnings on unnecessary braces
  staging: wilc1000: remove preprocessor conditionals unused
  staging: wilc1000: remove a dead preprocessor conditionals
  staging: wilc1000: #ifdef conditionals cover entire functions
  staging: wilc1000: remove unused functions
  staging: wilc1000: remove errors on required space
  staging: wilc1000: remove warnings on unnecessary braces
  staging: wilc1000: remove warnings on missing blank line
  staging: wilc1000: remove unnecessary inner braces
  staging: wilc1000: remove unnecessary blank lines
  staging: wilc1000: update TODO list of WILC1000

 drivers/staging/wilc1000/Kconfig                  |  28 +-
 drivers/staging/wilc1000/Makefile                 |   4 +-
 drivers/staging/wilc1000/TODO                     |  13 +-
 drivers/staging/wilc1000/coreconfigsimulator.h    |  17 -
 drivers/staging/wilc1000/coreconfigurator.c       |  86 --
 drivers/staging/wilc1000/coreconfigurator.h       |  15 +-
 drivers/staging/wilc1000/fifo_buffer.c            | 132 ----
 drivers/staging/wilc1000/fifo_buffer.h            |  26 -
 drivers/staging/wilc1000/host_interface.c         |  23 -
 drivers/staging/wilc1000/host_interface.h         |   1 -
 drivers/staging/wilc1000/linux_mon.c              |  15 +-
 drivers/staging/wilc1000/linux_wlan.c             | 169 +---
 drivers/staging/wilc1000/wilc_sdio.c              | 788 ++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  13 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.c     | 909 ----------------------
 drivers/staging/wilc1000/wilc_wlan.c              |   1 -
 16 files changed, 383 insertions(+), 1857 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/coreconfigsimulator.h
 delete mode 100644 drivers/staging/wilc1000/fifo_buffer.c
 delete mode 100644 drivers/staging/wilc1000/fifo_buffer.h
 delete mode 100644 drivers/staging/wilc1000/wilc_wfi_netdevice.c

-- 
1.9.1

