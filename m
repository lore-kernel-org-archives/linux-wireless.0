Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23033 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2D3LW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 07:22:26 -0400
Date: Mon, 30 Apr 2012 14:22:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: frankyl@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: re: brcm80211: fmac: fix missing completion events issue
Message-ID: <20120430112219.GA23246@elgon.mountain> (sfid-20120430_132250_642856_DC977032)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Franky Lin,

The patch b948a85c1f26: "brcm80211: fmac: fix missing completion 
events issue" from Apr 23, 2012, leads to the following Smatch warning:
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2650 
brcmf_sdbrcm_dpc_thread()
	 error: double unlock 'spin_lock:&bus->dpc_tl_lock'


  2631  
  2632                  spin_lock_irqsave(&bus->dpc_tl_lock, flags);
  2633                  list_for_each_safe(cur_hd, tmp_hd, &bus->dpc_tsklst) {
  2634                          spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
  2635  
  2636                          if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
  2637                                  /* after stopping the bus, exit thread */
  2638                                  brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
  2639                                  bus->dpc_tsk = NULL;
  2640                                  break;
                                        ^^^^^^
We are not holding the lock here.

  2641                          }
  2642  
  2643                          if (brcmf_sdbrcm_dpc(bus))
  2644                                  brcmf_sdbrcm_adddpctsk(bus);
  2645  
  2646                          spin_lock_irqsave(&bus->dpc_tl_lock, flags);
  2647                          list_del(cur_hd);
  2648                          kfree(cur_hd);
  2649                  }
  2650                  spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Double unlock.  Double IRQ restore.

regards,
dan carpenter

