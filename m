Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41114 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2K0HZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 02:25:40 -0500
Date: Tue, 27 Nov 2012 10:25:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: ath6kl: move ath6kl_wmi_startscan_cmd()
Message-ID: <20121127072531.GB8239@elgon.mountain> (sfid-20121127_082543_263952_B62F745F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle Valo,

The patch c8c72b74e289: "ath6kl: move ath6kl_wmi_startscan_cmd()" 
from Jul 19, 2012, leads to the following warning:
drivers/net/wireless/ath/ath6kl/wmi.c:2016 ath6kl_wmi_beginscan_cmd()
	 error: buffer overflow 'sc->supp_rates' 2 <= 2

drivers/net/wireless/ath/ath6kl/wmi.c

  2009          for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
                                      ^^^^^^^^^^^^^^^^^^^
This is 3.

  2010                  sband = ar->wiphy->bands[band];
  2011  
  2012                  if (!sband)
  2013                          continue;
  2014  
  2015                  ratemask = rates[band];
  2016                  supp_rates = sc->supp_rates[band].rates;

->supp_rates has only ATH6KL_NUM_BANDS (2) elements so we are reading
one element beyond the end.

  2017                  num_rates = 0;

regards,
dan carpenter

