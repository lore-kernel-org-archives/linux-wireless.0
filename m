Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26687 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbcECMDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 08:03:45 -0400
Date: Tue, 3 May 2016 15:03:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: david.spinadel@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: support sched scan if supported by the fw
Message-ID: <20160503120334.GA2258@mwanda> (sfid-20160503_140348_948765_9D72F4ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello David Spinadel,

The patch 35a000b7c1bb: "iwlwifi: mvm: support sched scan if
supported by the fw" from Aug 28, 2013, leads to the following static
checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/scan.c:572 iwl_mvm_lmac_scan_abort()
	error: uninitialized symbol 'status'.

drivers/net/wireless/intel/iwlwifi/mvm/scan.c
   560  static int iwl_mvm_lmac_scan_abort(struct iwl_mvm *mvm)
   561  {
   562          int ret;
   563          struct iwl_host_cmd cmd = {
   564                  .id = SCAN_OFFLOAD_ABORT_CMD,
   565          };
   566          u32 status;
   567  
   568          ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
   569          if (ret)
   570                  return ret;
   571  
   572          if (status != CAN_ABORT_STATUS) {
                    ^^^^^^

There is a "success" path in iwl_mvm_send_cmd_status() where we don't
set status.  It's commented inside the function.

   573                  /*
   574                   * The scan abort will return 1 for success or
   575                   * 2 for "failure".  A failure condition can be
   576                   * due to simply not being in an active scan which
   577                   * can occur if we send the scan abort before the
   578                   * microcode has notified us that a scan is completed.
   579                   */
   580                  IWL_DEBUG_SCAN(mvm, "SCAN OFFLOAD ABORT ret %d.\n", status);
   581                  ret = -ENOENT;
   582          }
   583  
   584          return ret;
   585  }

regards,
dan carpenter
