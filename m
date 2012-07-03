Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:49977 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2GCKxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 06:53:52 -0400
Date: Tue, 3 Jul 2012 13:53:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: cfg80211: add 802.11ad (60gHz band) support
Message-ID: <20120703105342.GA29879@elgon.mountain> (sfid-20120703_125355_865535_D89FFB14)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Vladimir Kondratiev,

The patch 3a0c52a6d82c: "cfg80211: add 802.11ad (60gHz band) support" 
from Jul 2, 2012, leads to the following warning:
drivers/net/wireless/mac80211_hwsim.c:1841 init_mac80211_hwsim()
	 warn: buffer overflow 'data->bands' 2 <= 2

drivers/net/wireless/mac80211_hwsim.c
  1839  
  1840                  for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
                                                                ^^^^^^^^^^^^^^^^^^^
We raised IEEE80211_NUM_BANDS to 3.

  1841                          struct ieee80211_supported_band *sband = &data->bands[band];
                                                                                ^^^^^^^^^^^
This only has 2 elements still.

  1842                          switch (band) {
  1843                          case IEEE80211_BAND_2GHZ:

It causes a bogus dereference later.

regards,
dan carpenter

