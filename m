Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:37114 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2HET5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 15:57:20 -0400
Date: Sun, 5 Aug 2012 22:57:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: re: net: wireless: add brcm80211 drivers
Message-ID: <20120805195716.GA12400@elgon.mountain> (sfid-20120805_215744_798347_01D6DB24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

The patch 5b435de0d786: "net: wireless: add brcm80211 drivers" from
Oct 5, 2011, leads to the following warning:
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1699 brcmf_sdbrcm_readframes()
	 warn: is it ok to set 'rxseq' to -1?

  1697                          cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
  1698                          brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
  1699                          rxseq += cnt - 1;
  1700                          rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
  1701                          continue;

This isn't a warning, it's just one of the things I audit.
brcmf_sdbrcm_rxglom() can return 0 so it's weird that we do
"rxseq += 0 - 1;"  Was that intended?

regards,
dan carpenter

