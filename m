Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcBHSWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 13:22:38 -0500
Date: Mon, 8 Feb 2016 21:22:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: re: rtlwifi: fix broken VHT support
Message-ID: <20160208182224.GC18802@mwanda> (sfid-20160208_192241_861235_D9CDA49C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry Finger,

The patch d76d65fd2695: "rtlwifi: fix broken VHT support" from Feb 1,
2016, leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/rc.c:144 _rtl_rc_rate_set_series()
	warn: impossible condition '(wireless_mode == 256) => (0-255 == 256)'

drivers/net/wireless/realtek/rtlwifi/rc.c
   135                  if (sgi_20 || sgi_40 || sgi_80)
   136                          rate->flags |= IEEE80211_TX_RC_SHORT_GI;
   137                  if (sta && sta->ht_cap.ht_supported &&
   138                      ((wireless_mode == WIRELESS_MODE_N_5G) ||
   139                       (wireless_mode == WIRELESS_MODE_N_24G)))
   140                          rate->flags |= IEEE80211_TX_RC_MCS;
   141                  if (sta && sta->vht_cap.vht_supported &&
   142                      (wireless_mode == WIRELESS_MODE_AC_5G ||
   143                       wireless_mode == WIRELESS_MODE_AC_24G ||
   144                       wireless_mode == WIRELESS_MODE_AC_ONLY))
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Not possible.  sta_entry->wireless_mode is u8 and WIRELESS_MODE_AC_ONLY
is 0x100.

   145                          rate->flags |= IEEE80211_TX_RC_VHT_MCS;
   146          }
   147  }


regards,
dan carpenter
