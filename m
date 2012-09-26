Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32552 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2IZOGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 10:06:08 -0400
Date: Wed, 26 Sep 2012 17:05:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ilane@ti.com
Cc: linux-nfc@lists.01.org, linux-wireless@vger.kernel.org
Subject: re: NFC: Set local general bytes in nci_start_poll
Message-ID: <20120926140553.GA31568@elgon.mountain> (sfid-20120926_160613_064964_A53FF15C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ilan Elias,

The patch 7e0352306f68: "NFC: Set local general bytes in 
nci_start_poll" from Aug 15, 2012, leads to the following warning:
net/nfc/nci/core.c:427 nci_set_local_general_bytes()
	 error: buffer overflow 'local_gb' 48 <= 250

   416          __u8 local_gb[NFC_MAX_GT_LEN];
                              ^^^^^^^^^^^^^^
48 elements.

   417          int i, rc = 0;
   418  
   419          param.val = nfc_get_local_general_bytes(nfc_dev, &param.len);
   420          if ((param.val == NULL) || (param.len == 0))
   421                  return rc;
   422  
   423          if (param.len > NCI_MAX_PARAM_LEN)
                                ^^^^^^^^^^^^^^^^^
Capped at 250.  Probably NFC_MAX_GT_LEN was intended?

   424                  return -EINVAL;
   425  
   426          for (i = 0; i < param.len; i++)
   427                  local_gb[param.len-1-i] = param.val[i];
                                 ^^^^^^^^^^^^^
Writing to the 250th element.

This is just a sanity check and nfc_get_local_general_bytes() will only
return NFC_MAX_GT_LEN max because of the check in nfc_llcp_build_gb().

regards,
dan carpenter

