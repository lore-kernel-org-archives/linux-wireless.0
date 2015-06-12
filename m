Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:34237 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbbFLQ6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 12:58:32 -0400
Date: Fri, 12 Jun 2015 18:58:29 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG ?] delay always evaluates to 0
Message-ID: <20150612165829.GA22474@opentech.at> (sfid-20150612_190219_773987_E4428141)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

commit 2c86c275015c ("Add ipw2100 wireless driver.") introduced

drivers/net/wireless/ipw2100.c - line-numbers are from next-20150511
1410 static int ipw2100_hw_phy_off(struct ipw2100_priv *priv)
1411 {
1412 
1413 #define HW_PHY_OFF_LOOP_DELAY (HZ / 5000)                                  
1414    
...
1437 
1438                 schedule_timeout_uninterruptible(HW_PHY_OFF_LOOP_DELAY);
1439         }

but (HZ / 5000) will evaluate to 0 for all configurable HZ values - typo ?
and this schedule_timeout_uninterruptible() is probably not doing what
is intended.

thx!
hofrat
