Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50286 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaGHNnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:43:17 -0400
Date: Tue, 8 Jul 2014 16:43:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Max.Stepanov@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: add generic cipher scheme support
Message-ID: <20140708134312.GA6538@mwanda> (sfid-20140708_154323_656155_51EA9E52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Max Stepanov,

This is a semi-automatic email about new static checker warnings.

The patch 2475b1cc0d52: "mac80211: add generic cipher scheme support" 
from Mar 24, 2013, leads to the following Smatch complaint:

net/mac80211/rx.c:1551 ieee80211_rx_h_decrypt()
	 error: we previously assumed 'rx->sta' could be null (see line 1401)

net/mac80211/rx.c
  1400	
  1401		if (rx->sta) {
                    ^^^^^^^
Many places in this function assume that ->sta can be NULL.

  1402			int keyid = rx->sta->ptk_idx;
  1403	
  1404			if (ieee80211_has_protected(fc) && rx->sta->cipher_scheme) {
  1405				cs = rx->sta->cipher_scheme;
  1406				keyid = iwl80211_get_cs_keyid(cs, rx->skb);

[ snip ]

  1547		case WLAN_CIPHER_SUITE_AES_CMAC:
  1548			result = ieee80211_crypto_aes_cmac_decrypt(rx);
  1549			break;
  1550		default:
  1551			result = ieee80211_crypto_hw_decrypt(rx);
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
But if it's NULL here then we will Oops.

  1552		}
  1553	

regards,
dan carpenter
