Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33116 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbG2PXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 11:23:15 -0400
Date: Wed, 29 Jul 2015 20:52:42 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: host_interface.c: Fix build warning
Message-ID: <20150729152242.GA21808@gcs-HP-Compaq-nx6320> (sfid-20150729_172333_654837_705B0B23)
References: <1438178819-12740-1-git-send-email-csgorentla@gmail.com>
 <20150729142037.GJ5180@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150729142037.GJ5180@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 05:20:37PM +0300, Dan Carpenter wrote:
> On Wed, Jul 29, 2015 at 07:36:59PM +0530, Chandra S Gorentla wrote:
> > Fixed - warning: ‘*((void *)&strHostIFmsg+4).pu8Head’ may be used uninitialized 
> > 
> 
> I can't reproduce this warning and the original code looks fine to me.
> 
> When you say the word "fix" it means the code is buggy.  Otherwise we
> are just silencing warnings or cleaning up code.  It's not clear from
> the patch description what is happening here, is it a bug or a warning
> only?
> 
> regards,
> dan carpenter
> 
Following is the build log -
----
gcs@gcs-HP-Compaq-nx6320:~/linux/git-linux$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- SUBFOLDER=drivers/staging/wilc1000/
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CHK     include/generated/bounds.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
<stdin>:1298:2: warning: #warning syscall userfaultfd not implemented [-Wcpp]
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CC [M]  drivers/staging/wilc1000/host_interface.o
drivers/staging/wilc1000/host_interface.c: In function ‘host_int_add_beacon’:
drivers/staging/wilc1000/host_interface.c:7116:16: warning: ‘*((void *)&strHostIFmsg+4).pu8Head’ may be used uninitialized in this function [-Wuninitialized]
  LD [M]  drivers/staging/wilc1000/wilc1000.o
  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready
  Building modules, stage 2.
  MODPOST 85 modules
  CC      drivers/staging/wilc1000/wilc1000.mod.o
  LDFINAL [M]  drivers/staging/wilc1000/wilc1000.ko
gcs@gcs-HP-Compaq-nx6320:~/linux/git-linux$
----
Proposed fix removes this warning.

Currently the 'wilc1000' driver in staging is marked as BROKEN in its
KConfig file at 'drivers/staging/wilc1000/'.  I had to remove this line
to execute the above make command.

Thanks,
chandra
