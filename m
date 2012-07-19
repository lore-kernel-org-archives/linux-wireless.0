Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33325 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2GSLdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:33:17 -0400
Date: Thu, 19 Jul 2012 14:33:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: helmut.schaa@googlemail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: rt2x00: Don't call ieee80211_get_tx_rate for MCS rates
Message-ID: <20120719113308.GA32491@elgon.mountain> (sfid-20120719_133321_021155_2BD59977)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut Schaa,

I'm going through some old static checker warnings and I was concerned
about this one:

The patch 55b585e29095: "rt2x00: Don't call ieee80211_get_tx_rate for
MCS rates" from Mar 3, 2011, leads to the following warning:
drivers/net/wireless/rt2x00/rt2x00queue.c:508
	rt2x00queue_create_tx_descriptor()
	error: potential NULL dereference 'hwrate'.

   482          /*
   483           * Determine rate modulation.
   484           */
   485          if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
   486                  txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;

hwrate is NULL here.

   487          else if (txrate->flags & IEEE80211_TX_RC_MCS)
   488                  txdesc->rate_mode = RATE_MODE_HT_MIX;
   489          else {
   490                  rate = ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
   491                  hwrate = rt2x00_get_rate(rate->hw_value);
   492                  if (hwrate->flags & DEV_RATE_OFDM)
   493                          txdesc->rate_mode = RATE_MODE_OFDM;
   494                  else
   495                          txdesc->rate_mode = RATE_MODE_CCK;
   496          }
   497  
   498          /*
   499           * Apply TX descriptor handling by components
   500           */
   501          rt2x00crypto_create_tx_descriptor(rt2x00dev, skb, txdesc);
   502          rt2x00queue_create_tx_descriptor_seq(rt2x00dev, skb, txdesc);
   503  
   504          if (test_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags))
   505                  rt2x00queue_create_tx_descriptor_ht(rt2x00dev, skb, txdesc,
   506                                                      hwrate);

On this path we dereference dereference hwrate if IEEE80211_TX_RC_MCS is
not set, but we don't check for IEEE80211_TX_RC_GREEN_FIELD.

   507          else
   508                  rt2x00queue_create_tx_descriptor_plcp(rt2x00dev, skb, txdesc,
   509                                                        hwrate);

On this patch we dereference hwrate unconditionally.

regards,
dan carpenter

