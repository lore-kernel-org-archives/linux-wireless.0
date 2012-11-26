Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2KZVDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 16:03:52 -0500
Date: Tue, 27 Nov 2012 00:03:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rmanohar@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: re: ath9k: Add concurrent WLAN and BT tx support for MCI based chips
Message-ID: <20121126210337.GA27645@elgon.mountain> (sfid-20121126_220356_250511_EBECE0D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rajkumar Manoharan,

The patch db60428b1af1: "ath9k: Add concurrent WLAN and BT tx support
for MCI based chips" from Oct 12, 2012, leads to the following
warning:
drivers/net/wireless/ath/ath9k/btcoex.c:414
	ath9k_hw_btcoex_set_concur_txprio()
		error: buffer overflow 'stomp_txprio' 4 <= 4

stomp_txprio has 4 elements.
	u8 stomp_txprio[] = { 0, 0, 0, 0 }; /* all, low, none, low_ftp */

drivers/net/wireless/ath/ath9k/btcoex.c
   408  void ath9k_hw_btcoex_set_concur_txprio(struct ath_hw *ah, u8 *stomp_txprio)
   409  {
   410          struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
   411          int i;
   412  
   413          for (i = 0; i < ATH_BTCOEX_STOMP_MAX; i++)
                                ^^^^^^^^^^^^^^^^^^^^
This is 5.

   414                  btcoex->tx_prio[i] = stomp_txprio[i];
                                             ^^^^^^^^^^^^^^
We are reading one positition past the end of the array.

   415  }

Possibly we need to add some code to handle ATH_BTCOEX_STOMP_AUDIO which
was added recently in 2884561a "ath9k: stomp audio profiles on weak
signal strength."

regards,
dan carpenter

