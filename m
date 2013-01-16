Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3APN7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:59:20 -0500
Message-ID: <1358344785.22862.5.camel@jlt4.sipsolutions.net> (sfid-20130116_145936_304239_E31C1D66)
Subject: Re: pull-request: iwlwifi-next 2013-01-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 14:59:45 +0100
In-Reply-To: <1358344682.22862.4.camel@jlt4.sipsolutions.net> (sfid-20130116_145748_538519_53BA0B56)
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
	 (sfid-20130116_145748_538519_53BA0B56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 14:58 +0100, Johannes Berg wrote:
> John,
> 
> Please pull a few updates for iwlwifi. These are just some cleanups and
> a debug improvement.

Oh, I forgot to mention that there's a merge conflict with
iwlwifi-fixes, but it's easy:

--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@@ -1217,14 -1205,8 +1210,15 @@@ int iwlagn_rx_reply_tx(struct iwl_priv 
                        freed++;
                }
  
 +              if (tid != IWL_TID_NON_QOS) {
 +                      priv->tid_data[sta_id][tid].next_reclaimed =
 +                              next_reclaimed;
 +                      IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
 +                                         next_reclaimed);
 +              }
 +
-               WARN_ON(!is_agg && freed != 1);
+               if (!is_agg && freed != 1)
+                       IWL_ERR(priv, "Q: %d, freed %d\n", txq_id, freed);
  
                /*
                 * An offchannel frame can be send only on the AUX queue, where

johannes

