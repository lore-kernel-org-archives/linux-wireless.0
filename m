Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38522 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbdJEMNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 08:13:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1e0523-0002pr-7n
        for linux-wireless@vger.kernel.org; Thu, 05 Oct 2017 14:13:39 +0200
Message-ID: <1507205618.2387.19.camel@sipsolutions.net> (sfid-20171005_141343_627525_0BA9C0DF)
Subject: converting mac80211 to TXQs entirely
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Oct 2017 14:13:38 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Part 1 is just a dump of my notes analysing the current TX scheme.


driver setup
============

non-QUEUE_CONTROL drivers
 * have >= 4 queues
   - per-AC queues [0-3]
 * have < 4 queues
   - all goes to queue 0

QUEUE_CONTROL drivers
 * hwsim (doesn't handle CAB correctly)
   - each vif: 0...3
   - each cab: 0
   - offchannel: 4
 * TI (doesn't set HOST_BROADCAST_PS_BUFFERING)
   - each vif: 4 queues (separate)
   - each cab: separate queue
   - offchannel: separate from all others
 * iwldvm/iwlmvm (doesn't set HOST_BROADCAST_PS_BUFFERING)
   - each vif: 4 queues (separate)
   - each cab: separate queue
   - offchannel: separate from all others (AUX)
 * ath9k (uses TXQ, sets HOST_BROADCAST_PS_BUFFERING)
   - each vif: 4 queues (shared based on chanctx)
   - each cab: all the same (# queues - 2)
   - offchannel: separate from all others
 * ath10k (may use TXQ, doesn't set HOST_BROADCAST_PS_BUFFERING)
   - each vif: 1 queue for all ACs
   - each cab: same queue as for ACs
   - offchannel: separate from all others


current TX scheme
=================
HOST_BROADCAST_PS_BUFFERING && IEEE80211_TX_CTL_SEND_AFTER_DTIM
 --> queue for ieee80211_get_buffered_bc()

!AP_LINK_PS && sta sleeping
 --> queue on sta->ps_tx_buf[ac] for wakeup/poll
 --> send on poll with IEEE80211_TX_CTRL_PS_RESPONSE
 --> send on wakeup as normal frame (with or without TXQ)
     [NB: with TXQs, this is buggy due to waking old TXQ before tx_filtered]

finally
 --> send directly (with or without TXQ)

if filtered TX status
 --> append to tx_filtered[ac] and use that before ps_tx_buf[ac]

TXQ scheme (where used)
=======================

MONITOR || IEEE80211_TX_CTL_SEND_AFTER_DTIM || IEEE80211_TX_CTRL_PS_RESPONSE || non-data
 --> send directly (to TX queue number as given above)
have STA
 --> per-STA/TID TXQ
otherwise
 --> per-VIF TXQ (for VLAN use AP instead)
