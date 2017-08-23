Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32779 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdHWLLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 07:11:05 -0400
Date: Wed, 23 Aug 2017 14:10:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: prameela.j04cs@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rsi: data and managemet path changes for AP mode
Message-ID: <20170823110547.4pjlb6k6eptljdlf@mwanda> (sfid-20170823_131108_820939_4CEB4643)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Prameela Rani Garnepudi,

The patch 19844c0a9a19: "rsi: data and managemet path changes for AP
mode" from Aug 16, 2017, leads to the following static checker
warning:

	drivers/net/wireless/rsi/rsi_91x_core.c:397 rsi_core_xmit()
	error: buffer overflow 'rsta->start_tx_aggr' 16 <= 16

drivers/net/wireless/rsi/rsi_91x_core.c
   369          if ((ieee80211_is_mgmt(wh->frame_control)) ||
   370              (ieee80211_is_ctl(wh->frame_control)) ||
   371              (ieee80211_is_qos_nullfunc(wh->frame_control))) {
   372                  q_num = MGMT_SOFT_Q;
   373                  skb->priority = q_num;
   374          } else {
   375                  if (ieee80211_is_data_qos(wh->frame_control)) {
   376                          tid = (skb->data[24] & IEEE80211_QOS_TID);
                                ^^^
tid is capped at 15 here so that's fine.

   377                          skb->priority = TID_TO_WME_AC(tid);
   378                  } else {
   379                          tid = IEEE80211_NONQOS_TID;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
but here it's set to 16.

   380                          skb->priority = BE_Q;
   381                  }
   382  
   383                  q_num = skb->priority;
   384                  tx_params->tid = tid;
   385  
   386                  if ((vif->type == NL80211_IFTYPE_AP) &&
   387                      (!is_broadcast_ether_addr(wh->addr1)) &&
   388                      (!is_multicast_ether_addr(wh->addr1))) {
   389                          rsta = rsi_find_sta(common, wh->addr1);
   390                          if (!rsta)
   391                                  goto xmit_fail;
   392                          tx_params->sta_id = rsta->sta_id;
   393                  }
   394  
   395                  if (rsta) {
   396                          /* Start aggregation if not done for this tid */
   397                          if (!rsta->start_tx_aggr[tid]) {
                                     ^^^^^^^^^^^^^^^^^^^^^^^^
Smatch complains that this might be out of bounds.

   398                                  rsta->start_tx_aggr[tid] = true;
   399                                  ieee80211_start_tx_ba_session(rsta->sta,
   400                                                                tid, 0);
   401                          }
   402                  }
   403          }

regards,
dan carpenter
