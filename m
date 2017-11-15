Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49636 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbdKOMaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 07:30:06 -0500
Date: Wed, 15 Nov 2017 15:29:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mac80211: fix VLAN handling with TXQs
Message-ID: <20171115122952.2rzx6kv2lycq5go5@mwanda> (sfid-20171115_133010_908764_213EBC40)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ I fixed a Smatch bug and now it started warning about this code -dan ]

Hello Johannes Berg,

This is a semi-automatic email about new static checker warnings.

The patch 531682159092: "mac80211: fix VLAN handling with TXQs" from 
Jun 22, 2017, leads to the following Smatch complaint:

    net/mac80211/tx.c:3529 ieee80211_tx_dequeue()
     error: we previously assumed 'skb' could be null (see line 3511)

net/mac80211/tx.c
  3500                                             tx.key, skb);
  3501          } else {
  3502                  if (invoke_tx_handlers_late(&tx))
  3503                          goto begin;
  3504  
  3505                  skb = __skb_dequeue(&tx.skbs);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The NULL skb would have to come from here.

  3506  
  3507                  if (!skb_queue_empty(&tx.skbs))
  3508                          skb_queue_splice_tail(&tx.skbs, &txqi->frags);
  3509          }
  3510	
  3511		if (skb && skb_has_frag_list(skb) &&
                    ^^^
Old code checks

  3512		    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST)) {
  3513			if (skb_linearize(skb)) {
  3514				ieee80211_free_txskb(&local->hw, skb);
  3515				goto begin;
  3516			}
  3517		}
  3518	
  3519		switch (tx.sdata->vif.type) {
  3520		case NL80211_IFTYPE_MONITOR:
  3521			if (tx.sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE) {
  3522				vif = &tx.sdata->vif;
  3523				break;
  3524			}
  3525			tx.sdata = rcu_dereference(local->monitor_sdata);
  3526			if (tx.sdata) {
  3527				vif = &tx.sdata->vif;
  3528				info->hw_queue =
  3529					vif->hw_queue[skb_get_queue_mapping(skb)];
                                                                            ^^^
Patch adds unchecked dereference (might be a false positive).

  3530			} else if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
  3531				ieee80211_free_txskb(&local->hw, skb);

regards,
dan carpenter
