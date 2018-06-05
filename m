Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57534 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbeFELkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 07:40:11 -0400
Date: Tue, 5 Jun 2018 14:40:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: eyalreizer@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wlcore: sdio: check for valid platform device data
 before suspend
Message-ID: <20180605114001.surh4nfayfj7vs4l@kili.mountain> (sfid-20180605_134014_535393_073FE673)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eyal Reizer,

The patch 6e91d48371e7: "wlcore: sdio: check for valid platform
device data before suspend" from May 28, 2018, leads to the following
static checker warning:

	drivers/net/wireless/ti/wlcore/sdio.c:404 wl1271_suspend()
	warn: missing error code here? 'platform_get_drvdata()' failed. 'ret' = '0'

drivers/net/wireless/ti/wlcore/sdio.c
   391  #ifdef CONFIG_PM
   392  static int wl1271_suspend(struct device *dev)
   393  {
   394          /* Tell MMC/SDIO core it's OK to power down the card
   395           * (if it isn't already), but not to remove it completely */
   396          struct sdio_func *func = dev_to_sdio_func(dev);
   397          struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
   398          struct wl1271 *wl = platform_get_drvdata(glue->core);
   399          mmc_pm_flag_t sdio_flags;
   400          int ret = 0;
   401  
   402          if (!wl) {
   403                  dev_err(dev, "no wilink module was probed\n");
   404                  goto out;

We should set -ENOMEM or something?

   405          }
   406  
   407          dev_dbg(dev, "wl1271 suspend. wow_enabled: %d\n",
   408                  wl->wow_enabled);
   409  
   410          /* check whether sdio should keep power */
   411          if (wl->wow_enabled) {
   412                  sdio_flags = sdio_get_host_pm_caps(func);
   413  
   414                  if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
   415                          dev_err(dev, "can't keep power while host "
   416                                       "is suspended\n");
   417                          ret = -EINVAL;
   418                          goto out;
   419                  }
   420  
   421                  /* keep power while host suspended */
   422                  ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
   423                  if (ret) {
   424                          dev_err(dev, "error while trying to keep power\n");
   425                          goto out;
   426                  }
   427          }
   428  out:
   429          return ret;
   430  }

regards,
dan carpenter
