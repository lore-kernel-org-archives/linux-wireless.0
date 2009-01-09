Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7062 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZAITK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 14:10:26 -0500
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Deuce <the_deuce@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <326502.74480.qm@web57615.mail.re1.yahoo.com>
References: <326502.74480.qm@web57615.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:12:04 -0800
Message-Id: <1231528324.30298.14.camel@rc-desk> (sfid-20090109_201034_167724_D8911199)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-08 at 19:28 -0800, Deuce wrote:
> Kernel BUG in iwl3945 with 20090107 wireless-testing and firmware 15.28.2.8  The Microcode SW error detected seems to be the beginning of the end.  An attempt with Ubuntu's distributed iwlwifi-3945-1.ucode firmware was not successful either (I do not know the version).
> 
> The BUG happens a short period after logging in when Netmanager starts to scan and attempt to associate.  Association never completes.
> 
> Curiously, the bug was not triggered the first time I finally booted up with iwl3945 debug=0x43fff and netconsole functioning.  However it was immediately triggered on a subsequent reboot.  The first try may have been a warm reboot vs. a cold reboot.
> 
> Below is the dmesg output without debug.  Attached is a full dmesg output with debug=0x43fff.

There appears to be a few things going on here. I am still investigating
the firmware error, but we could start with something that will not let
your machine crash and get us some more information about one of the
issues.

Could you please try with this patch? Please do run your test with
debugging enabled as you have done before. Thank you very much.

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a23d51d..09c1c8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 	int cmd_index;
 	struct iwl_cmd *cmd;
 
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		return;
+	}
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];


