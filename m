Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3LDUfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 15:35:09 -0500
Date: Wed, 4 Dec 2013 23:34:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: re: ath5k: fix tx status reporting issues
Message-ID: <20131204203451.GA18708@elgon.mountain> (sfid-20131204_213514_624501_958776C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix Fietkau,

The patch 6d7b97b23e11: "ath5k: fix tx status reporting issues" from 
Apr 9, 2011, leads to the following
static checker warning: "drivers/net/wireless/ath/ath5k/base.c:1683 
ath5k_tx_frame_completed()
	 error: buffer overflow 'info->status.rates' 4 <= 4"

drivers/net/wireless/ath/ath5k/base.c
  1675          for (i = 0; i < ts->ts_final_idx; i++) {
  1676                  struct ieee80211_tx_rate *r =
  1677                          &info->status.rates[i];
  1678  
  1679                  r->count = tries[i];
  1680          }
  1681  
  1682          info->status.rates[ts->ts_final_idx].count = ts->ts_final_retry;
  1683          info->status.rates[ts->ts_final_idx + 1].idx = -1;
                                   ^^^^^^^^^^^^^^^^^^^^
It's complaining about this.

  1684  

->ts_final_idx is set in ath5k_hw_proc_4word_tx_status() it comes from
the hardware but in theory it could be a number between 0-3...  I'm not
sure.

regards,
dan carpenter

