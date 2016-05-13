Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18399 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbcEMIyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 04:54:39 -0400
Date: Fri, 13 May 2016 11:54:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sara.sharon@intel.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: re: iwlwifi: mvm: add reorder buffer per queue
Message-ID: <20160513085428.GA13194@mwanda> (sfid-20160513_105444_163228_034AF989)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sara Sharon,

The patch b915c10174fb: "iwlwifi: mvm: add reorder buffer per queue"
from Mar 23, 2016, leads to the following static checker warnings:

	drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912 iwl_mvm_rx_mpdu_mq()
	error: potential NULL dereference 'sta'.

	drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912 iwl_mvm_rx_mpdu_mq()
	error: we previously assumed 'sta' could be null (see line 796)


drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
   779  
   780          if (le16_to_cpu(desc->status) & IWL_RX_MPDU_STATUS_SRC_STA_FOUND) {
   781                  u8 id = desc->sta_id_flags & IWL_RX_MPDU_SIF_STA_ID_MASK;
   782  
   783                  if (!WARN_ON_ONCE(id >= IWL_MVM_STATION_COUNT)) {
   784                          sta = rcu_dereference(mvm->fw_id_to_mac_id[id]);
   785                          if (IS_ERR(sta))
   786                                  sta = NULL;
                                        ^^^^^^^^^^^
Assigned to NULL here.

   787                  }
   788          } else if (!is_multicast_ether_addr(hdr->addr2)) {
   789                  /*
   790                   * This is fine since we prevent two stations with the same
   791                   * address from being added.
   792                   */
   793                  sta = ieee80211_find_sta_by_ifaddr(mvm->hw, hdr->addr2, NULL);
   794          }
   795  
   796          if (sta) {
                    ^^^
NULL here.

   797                  struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
   798                  u8 baid = (u8)((le32_to_cpu(desc->reorder_data) &
   799                                 IWL_RX_MPDU_REORDER_BAID_MASK) >>
   800                                 IWL_RX_MPDU_REORDER_BAID_SHIFT);

[ snip ]

   909          /* TODO: PHY info - gscan */
   910  
   911          iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
   912          if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
                                                       ^^^
New unchecked dereference inside the function call.

   913                  iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
   914          rcu_read_unlock();
   915  }

regards,
dan carpenter
