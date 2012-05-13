Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19269 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2EMRnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 13:43:41 -0400
Date: Sun, 13 May 2012 20:43:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: re: net: wireless: add brcm80211 drivers
Message-ID: <20120513174333.GB4280@elgon.mountain> (sfid-20120513_194344_849388_ED62FB9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

This code is not really new, but I thought I would email you anyway
because I know you are responsive.  :)

The patch 5b435de0d786: "net: wireless: add brcm80211 drivers" from 
Oct 5, 2011, leads to the following Smatch complaint:

drivers/net/wireless/brcm80211/brcmsmac/ampdu.c:741 brcms_c_sendampdu()
	 warn: variable dereferenced before check 'p' (see line 739)

drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
   733                  /*
   734                   * check to see if the next pkt is
   735                   * a candidate for aggregation
   736                   */
   737                  p = pktq_ppeek(&qi->q, prec);
   738			/* tx_info must be checked with current p */
   739			tx_info = IEEE80211_SKB_CB(p);
                                  ^^^^^^^^^^^^^^^^
"p" is dereferenced inside the call to IEEE80211_SKB_CB().

   740	
   741			if (p) {
                           ^^^
Checked too late.

   742				if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
   743				    ((u8) (p->priority) == tid)) {

regards,
dan carpenter

