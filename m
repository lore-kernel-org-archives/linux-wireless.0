Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3IMJQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 05:16:00 -0400
Message-ID: <1379063754.14883.10.camel@jlt4.sipsolutions.net> (sfid-20130913_111604_996629_B65ABE1D)
Subject: Re: [PATCH] iwlwifi: do not dump stack whet triggering firmware
 restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
Date: Fri, 13 Sep 2013 11:15:54 +0200
In-Reply-To: <1379061930-2007-1-git-send-email-sgruszka@redhat.com> (sfid-20130913_104731_749582_6F802F06)
References: <1379061930-2007-1-git-send-email-sgruszka@redhat.com>
	 (sfid-20130913_104731_749582_6F802F06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 10:45 +0200, Stanislaw Gruszka wrote:
> We send REPLY_ERROR command to the device to force microcode error
> and restart firmware. This is not a problem, so do not dump stack
> on such situation.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/pcie/tx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
> index f45eb29..ec49033 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
> @@ -1546,7 +1546,8 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
>  	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status)) {
>  		IWL_ERR(trans, "FW error in SYNC CMD %s\n",
>  			get_cmd_string(trans_pcie, cmd->id));
> -		dump_stack();
> +		if (cmd->id != REPLY_ERROR)
> +			dump_stack();

Hmm, we changed this code like below, is this still relevant?

Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Wed Sep 11 14:16:20 2013 +0300

    iwlwifi: pcie: restart the driver when a command times out
    
    This should really not happen. If it does, restarting is the
    only way to recover since the driver and the firmware might
    very well be out of sync. Moreover, iwl_op_mode_nic_error
    will print data that might help debugging.
    
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d92baa7..32f179f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1535,7 +1535,6 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(trans_pcie, cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
-			dump_stack();
 
 			IWL_ERR(trans,
 				"Current CMD queue read_ptr %d write_ptr %d\n",
@@ -1546,6 +1545,9 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 				       "Clearing HCMD_ACTIVE for command %s\n",
 				       get_cmd_string(trans_pcie, cmd->id));
 			ret = -ETIMEDOUT;
+
+			iwl_op_mode_nic_error(trans->op_mode);
+
 			goto cancel;
 		}
 	}


johannes

