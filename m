Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48514 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1IUHHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 03:07:12 -0400
MIME-Version: 1.0
Message-ID: <20110921070525.GD4999@elgon.mountain> (sfid-20110921_090716_190621_69A0BC97)
Date: Wed, 21 Sep 2011 00:05:25 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: re: wl12xx: support up to 8 stations in AP-mode
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

Smatch complains about c47e8229fa56 "wl12xx: support up to 8 stations
in AP-mode"

drivers/net/wireless/wl12xx/main.c +832 wl12xx_irq_update_links_status(22)
	error: buffer overflow 'status->tx_lnk_free_pkts' 8 <= 10

   828          for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
                                                             ^^^^^^^^^^^^
We increased this to 11.

   829                  if (!wl1271_is_active_sta(wl, hlid))
   830                          continue;
   831  
   832                  cnt = status->tx_lnk_free_pkts[hlid] -
                                      ^^^^^^^^^^^^^^^^^^^^^^

But the ->tx_lnk_free_pkts[] array still only has 8 elements so we're
reading past the end of the array.

   833                        wl->links[hlid].prev_freed_pkts;
   834  
   835                  wl->links[hlid].prev_freed_pkts =
   836                          status->tx_lnk_free_pkts[hlid];
   837                  wl->links[hlid].allocated_pkts -= cnt;
   838  
   839                  wl12xx_irq_ps_regulate_link(wl, hlid,
   840                                              wl->links[hlid].allocated_pkts);
   841          }

regards,
dan carpenter
