Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31477 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3BEIEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 03:04:21 -0500
Date: Tue, 5 Feb 2013 11:04:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: add the MVM driver
Message-ID: <20130205080409.GA10937@elgon.mountain> (sfid-20130205_090430_527637_47536B3A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes Berg,

The patch 8ca151b568b6: "iwlwifi: add the MVM driver" from Jan 24,
2013, leads to the following warning:
"drivers/net/wireless/iwlwifi/mvm/sta.c:1119 iwl_mvm_remove_sta_key()
	 warn: 0x300 is larger than 8 bits"

[ This is a not ready for release Smatch check ].

drivers/net/wireless/iwlwifi/mvm/sta.c
  1118  
  1119          key_flags = cpu_to_le16(keyconf->keyidx & STA_KEY_FLG_KEYID_MSK);
                                        ^^^^^^^^^^^^^^^
This is s8.
                                                          ^^^^^^^^^^^^^^^^^^^^^
STA_KEY_FLG_KEYID_MSK is 0x300.

The result after the bitwise AND is always zero because 0xff & 0x300.

  1120          key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
  1121          key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
  1122  

regards,
dan carpenter

