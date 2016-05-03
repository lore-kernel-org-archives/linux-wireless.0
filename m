Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbcECLwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 07:52:43 -0400
Date: Tue, 3 May 2016 14:52:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: add the MVM driver
Message-ID: <20160503115232.GA11129@mwanda> (sfid-20160503_135247_210251_7370881B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes Berg,

The patch 8ca151b568b6: "iwlwifi: add the MVM driver" from Jan 24,
2013, leads to the following static checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2080 __iwl_mvm_resume()
	error: uninitialized symbol 'd3_status'.

drivers/net/wireless/intel/iwlwifi/mvm/d3.c
  2057  static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
  2058  {
  2059          struct ieee80211_vif *vif = NULL;
  2060          int ret = 1;
  2061          enum iwl_d3_status d3_status;
  2062          bool keep = false;
  2063          bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
  2064                                           IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
  2065  
  2066          u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
  2067                                      CMD_WAKE_UP_TRANS;
  2068  
  2069          mutex_lock(&mvm->mutex);
  2070  
  2071          /* get the BSS vif pointer again */
  2072          vif = iwl_mvm_get_bss_vif(mvm);
  2073          if (IS_ERR_OR_NULL(vif))
  2074                  goto err;
  2075  
  2076          ret = iwl_trans_d3_resume(mvm->trans, &d3_status, test, !unified_image);


iwl_trans_d3_resume() just calls a resume() function pointer, but if
that pointer is NULL then it's a no-op.

  2077          if (ret)
  2078                  goto err;
  2079  
  2080          if (d3_status != IWL_D3_STATUS_ALIVE) {
                    ^^^^^^^^^
This would still be uninitialized.

  2081                  IWL_INFO(mvm, "Device was reset during suspend\n");
  2082                  goto err;
  2083          }

regards,
dan carpenter
