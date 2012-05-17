Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31686 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab2EQTNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 15:13:54 -0400
Date: Thu, 17 May 2012 22:13:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hauke@hauke-m.de, Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: re: brcmsmac: use sprom from bcma
Message-ID: <20120517191339.GA17018@elgon.mountain> (sfid-20120517_211357_834596_A682B01C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Hauke, Arend,

The patch 898d3c3b2462: "brcmsmac: use sprom from bcma" from Apr 29, 
2012, leads to the following warning:
drivers/net/wireless/brcm80211/brcmsmac/channel.c:645 
brcms_c_country_valid()
	 error: buffer overflow 'ccode' 2 <= 2

-       if (ccode && brcms_c_country_valid(ccode))
-               strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+       if (sprom->alpha2 && brcms_c_country_valid(sprom->alpha2))
                                                   ^^^^^^^^^^^^^
This is a two character array.  It's not NULL terminated.

+               strncpy(wlc->pub->srom_ccode, sprom->alpha2, sizeof(sprom->alpha2));

But in brcms_c_country_valid() we check for the NULL terminator.

   637  static bool brcms_c_country_valid(const char *ccode)
   638  {
   639          /*
   640           * only allow ascii alpha uppercase for the first 2
   641           * chars.
   642           */
   643          if (!((0x80 & ccode[0]) == 0 && ccode[0] >= 0x41 && ccode[0] <= 0x5A &&
   644                (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A &&
   645                ccode[2] == '\0'))
                      ^^^^^^^^^^^^^^^^
Here.

   646                  return false;

My guess is that this works because -> leddc_on_time is mostly zero.

regards,
dan carpenter

