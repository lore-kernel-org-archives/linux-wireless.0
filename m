Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaDQKol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 06:44:41 -0400
Date: Thu, 17 Apr 2014 13:44:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: eyal@wizery.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: rs: use correct max expected throughput figures
Message-ID: <20140417104439.GA9658@mwanda> (sfid-20140417_124445_274778_EBD7A79E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eyal Shapira,

The patch 198266a3c110: "iwlwifi: mvm: rs: use correct max expected
throughput figures" from Mar 31, 2014, leads to the following static
checker warning:

	drivers/net/wireless/iwlwifi/mvm/rs.c:2433 iwl_mvm_rs_rate_init()
	warn: was expecting a 64 bit value instead of '(2)'

drivers/net/wireless/iwlwifi/mvm/rs.c
  2427                  /* active_siso_rate mask includes 9 MBits (bit 5),
  2428                   * and CCK (bits 0-3), supp_rates[] does not;
  2429                   * shift to convert format, force 9 MBits off.
  2430                   */
  2431                  lq_sta->active_siso_rate = ht_cap->mcs.rx_mask[0] << 1;
  2432                  lq_sta->active_siso_rate |= ht_cap->mcs.rx_mask[0] & 0x1;
  2433                  lq_sta->active_siso_rate &= ~((u16)0x2);

Your patch changes this from being a u16 to being a unsigned long and
triggers this static checker warning.  The code still works fine because
the u16 cast is a no-op which ends up being processed as
"~((type promote to int)(u16)0x2)".  The negative bit gets pushed out to
64 bits giving "0xfffffffffffffffd" which we want.  But it's still a
confusing left over remnant.

Also this struct has another definition where it is still a u16 in the
drivers/net/wireless/iwlwifi/dvm/ driver.

  2434                  lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
  2435  
  2436                  /* Same here */
  2437                  lq_sta->active_mimo2_rate = ht_cap->mcs.rx_mask[1] << 1;
  2438                  lq_sta->active_mimo2_rate |= ht_cap->mcs.rx_mask[1] & 0x1;
  2439                  lq_sta->active_mimo2_rate &= ~((u16)0x2);
                                                        ^^^^^^^
Same here.

  2440                  lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
  2441  
  2442                  lq_sta->is_vht = false;
  2443          } else {

regards,
dan carpenter
