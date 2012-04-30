Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2197 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab2D3QyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 12:54:00 -0400
Message-ID: <4F9EC3A1.2070001@broadcom.com> (sfid-20120430_185405_270879_0DE5AEF7)
Date: Mon, 30 Apr 2012 09:53:53 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: brcm80211: fmac: fix missing completion events issue
References: <20120430112219.GA23246@elgon.mountain>
In-Reply-To: <20120430112219.GA23246@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2012 04:22 AM, Dan Carpenter wrote:
> Hello Franky Lin,
>
> The patch b948a85c1f26: "brcm80211: fmac: fix missing completion
> events issue" from Apr 23, 2012, leads to the following Smatch warning:
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2650
> brcmf_sdbrcm_dpc_thread()
> 	 error: double unlock 'spin_lock:&bus->dpc_tl_lock'
>
>
>    2631
>    2632                  spin_lock_irqsave(&bus->dpc_tl_lock, flags);
>    2633                  list_for_each_safe(cur_hd, tmp_hd,&bus->dpc_tsklst) {
>    2634                          spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
>    2635
>    2636                          if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
>    2637                                  /* after stopping the bus, exit thread */
>    2638                                  brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
>    2639                                  bus->dpc_tsk = NULL;
>    2640                                  break;
>                                          ^^^^^^
> We are not holding the lock here.
>
>    2641                          }
>    2642
>    2643                          if (brcmf_sdbrcm_dpc(bus))
>    2644                                  brcmf_sdbrcm_adddpctsk(bus);
>    2645
>    2646                          spin_lock_irqsave(&bus->dpc_tl_lock, flags);
>    2647                          list_del(cur_hd);
>    2648                          kfree(cur_hd);
>    2649                  }
>    2650                  spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Double unlock.  Double IRQ restore.

Hi Dan,

Thx for catching this. Working on a fix.

Regards,
Franky

