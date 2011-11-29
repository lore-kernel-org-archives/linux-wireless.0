Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:59359 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1K2OxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:53:14 -0500
Date: Tue, 29 Nov 2011 17:52:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: re: brcm80211: fmac: remove alignment check from
 brcmf_sdioh_request_buffer()
Message-ID: <20111129145247.GA7152@elgon.mountain> (sfid-20111129_155318_906621_EEDE610D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Arend van Spriel,

This is a semi-automatic email about new static checker warnings.

The patch 8054321b7cb8: "brcm80211: fmac: remove alignment check from 
brcmf_sdioh_request_buffer()" from Nov 22, 2011, leads to the 
following Smatch complaint:

drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c +298 brcmf_sdioh_request_buffer()
	 warn: variable dereferenced before check 'pkt' (see line 293)

drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
   292		int status;
   293		uint pkt_len = pkt->len;
                               ^^^^^^^^
New dereference.

   294		bool fifo = (fix_inc == SDIOH_DATA_FIX);
   295	
   296		brcmf_dbg(TRACE, "Enter\n");
   297	
   298		if (pkt == NULL)
                    ^^^^^^^^^^^
Old check.  Probably the check can be removed.  It from a quick glance
that this function is called from three places and pkt is always a valid
pointer.

   299			return -EINVAL;
   300	

regards,
dan carpenter

