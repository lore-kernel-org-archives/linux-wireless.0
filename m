Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56889 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab1IUHZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 03:25:11 -0400
Received: by mail-bw0-f49.google.com with SMTP id t2so1860021bka.22
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 00:25:09 -0700 (PDT)
Subject: re: wl12xx: support up to 8 stations in AP-mode
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110921070525.GD4999@elgon.mountain>
References: <20110921070525.GD4999@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 10:25:00 +0300
Message-ID: <1316589900.2157.392.camel@cumari> (sfid-20110921_092515_088749_4AF3DECE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 00:05 -0700, Dan Carpenter wrote: 
> Hi Arik,
> 
> Smatch complains about c47e8229fa56 "wl12xx: support up to 8 stations
> in AP-mode"
> 
> drivers/net/wireless/wl12xx/main.c +832 wl12xx_irq_update_links_status(22)
> 	error: buffer overflow 'status->tx_lnk_free_pkts' 8 <= 10
> 
>    828          for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
>                                                              ^^^^^^^^^^^^
> We increased this to 11.
> 
>    829                  if (!wl1271_is_active_sta(wl, hlid))
>    830                          continue;
>    831  
>    832                  cnt = status->tx_lnk_free_pkts[hlid] -
>                                       ^^^^^^^^^^^^^^^^^^^^^^
> 
> But the ->tx_lnk_free_pkts[] array still only has 8 elements so we're
> reading past the end of the array.
> 
>    833                        wl->links[hlid].prev_freed_pkts;
>    834  
>    835                  wl->links[hlid].prev_freed_pkts =
>    836                          status->tx_lnk_free_pkts[hlid];
>    837                  wl->links[hlid].allocated_pkts -= cnt;
>    838  
>    839                  wl12xx_irq_ps_regulate_link(wl, hlid,
>    840                                              wl->links[hlid].allocated_pkts);
>    841          }

Good catch, Dan! Thanks for checking this.

I checked our new firmware API and it seems that the wl12xx_fw_status
structure has changed.  Now, WL12XX_MAX_LINKS, should be 12 instead of
8.

Arik, can you verify this and send a fix patch?


-- 
Cheers,
Luca.

