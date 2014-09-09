Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43502 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbaIIJks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 05:40:48 -0400
Date: Tue, 9 Sep 2014 12:40:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: luciano.coelho@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: set the TX disable bit when doing a chanctx switch
Message-ID: <20140909094035.GA10599@mwanda> (sfid-20140909_114059_580527_9CC84F37)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luciano Coelho,

The patch 0ce04ce797f8: "iwlwifi: mvm: set the TX disable bit when
doing a chanctx switch" from May 8, 2014, leads to the following
static checker warning:

	drivers/net/wireless/iwlwifi/mvm/mac80211.c:2768 __iwl_mvm_assign_vif_chanctx()
	warn: missing error code here? 'iwl_mvm_sta_from_staid_protected()' failed. 'ret' = '0'

drivers/net/wireless/iwlwifi/mvm/mac80211.c
  2761          if (vif->csa_active && vif->type == NL80211_IFTYPE_STATION) {
  2762                  struct iwl_mvm_sta *mvmsta;
  2763  
  2764                  mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
  2765                                                            mvmvif->ap_sta_id);
  2766  
  2767                  if (WARN_ON(!mvmsta))
  2768                          goto out;

Did you want to set an error code here?  I don't know the code well
enough to say.

  2769  
  2770                  /* TODO: only re-enable after the first beacon */
  2771                  iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
  2772          }
  2773  
  2774          goto out;
  2775  
  2776  out_remove_binding:
  2777          iwl_mvm_binding_remove_vif(mvm, vif);
  2778          iwl_mvm_power_update_mac(mvm);
  2779  out:
  2780          if (ret)
  2781                  mvmvif->phy_ctxt = NULL;
  2782          return ret;
  2783  }

regards,
dan carpenter
