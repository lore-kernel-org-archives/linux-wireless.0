Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20525 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab0IQXNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:13:49 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:13:43 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
	"greg@kroah.com" <greg@kroah.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Fri, 17 Sep 2010 16:11:57 -0700
Subject: RE: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <35B17FE5076C7040809188FBE7913F983F23937DAE@SC1EXMB-MBCL.global.atheros.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com>
In-Reply-To: <4C93A412.2070005@oracle.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> Thanks for the patch, but I still get these errors & warnings:
> 
> on linux-next 2010-0915:
> 
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c: In function
> 'SetupHIFScatterSupport':
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error:
> 'struct mmc_host' has no member named 'max_hw_segs'
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error:
> 'struct mmc_host' has no member named 'max_hw_segs'
> 
This is because of a recent change in the mmc_host structure that removes the distinction between hw and phys segments. The structure is different in the staging-next-2.6 tree which is where I usually build and test the changes. 

Greg, 
   The two trees linux-next and staging-next are not in sync so what is the process that is usually followed under these circumstances? I see little point in using the staging-next-2.6 tree to generate and test my patches since the tree eventually drains into linux-next. Should I stop worrying about if the patch works for the staging-next tree and just focus on that things should work with linux-next?

> and on linux-next 2010-0917:
> 
> drivers/staging/ath6kl/os/linux/ar6000_drv.c: In function
> 'ar6000_transfer_bin_file':
> drivers/staging/ath6kl/os/linux/ar6000_drv.c:1129: warning: cast from
> pointer to integer of different size
> drivers/staging/ath6kl/os/linux/ar6000_drv.c:1129: warning: cast to
> pointer from integer of different size
> drivers/staging/ath6kl/wmi/wmi.c: In function 'wmi_bssInfo_event_rx':
> drivers/staging/ath6kl/wmi/wmi.c:1459: error: 'i' undeclared (first use in
> this function)
> 
> 
This is due to a recent patch that went it to use '%pM' format specifier to print MAC addresses. I'll fix it.
