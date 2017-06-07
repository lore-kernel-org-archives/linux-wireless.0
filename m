Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33366 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdFGWeC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 18:34:02 -0400
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: luca@coelho.fi
Cc: Seraphime Kirkovski <kirkseraph@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: wireless: intel: iwlwifi: dvm: fix tid mask
Date: Thu,  8 Jun 2017 00:33:52 +0200
Message-Id: <20170607223354.22399-1-kirkseraph@gmail.com> (sfid-20170608_003435_965667_158D8449)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the tid mask covers the first 4 bits of iwlagn_tx_resp::ra_tid,
which gives 16 possible values for tid.
This is problematic because IWL_MAX_TID_COUNT is 8, so indexing
iwl_priv::tid_data can go very wrong.

With UBSAN I can it happening while establishing the first connection
after module load.

[  272.143440] UBSAN: Undefined behaviour in drivers/net/wireless/intel/iwlwifi/dvm/tx.c:777:32
[  272.143447] index 8 is out of range for type 'iwl_tid_data [8]'
[  272.143457] CPU: 0 PID: 4605 Comm: irq/32-iwlwifi Not tainted 4.12.0-dirty #2
[  272.143460] Hardware name: Hewlett-Packard HP EliteBook 2560p/162B, BIOS 68SSU Ver. F.02 07/26/2011
[  272.143462] Call Trace:
[  272.143472]  dump_stack+0x9c/0x10b
[  272.143477]  ? _atomic_dec_and_lock+0x285/0x285
[  272.143486]  ubsan_epilogue+0xd/0x4e
[  272.143493]  __ubsan_handle_out_of_bounds+0xef/0x118
[  272.143498]  ? __ubsan_handle_shift_out_of_bounds+0x221/0x221
[  272.143519]  ? iwl_trans_pcie_reclaim+0x153/0xc90 [iwlwifi]
[  272.143539]  iwlagn_check_ratid_empty+0x337/0x410 [iwldvm]
[  272.143556]  ? iwl_hcmd_names_cmp+0x2f/0x60 [iwlwifi]
[  272.143571]  iwlagn_rx_reply_tx+0x8a4/0x1820 [iwldvm]

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
   I'm currently running this patch on my machines and I have wifi.
   The patch presumes а cleanup patch, I sent yesterday:
      https://www.spinics.net/lists/kernel/msg2526314.html

 drivers/net/wireless/intel/iwlwifi/dvm/commands.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 37d2ba5ae852..e5994df9ea4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -1448,7 +1448,7 @@ struct agg_tx_status {
  */
 /* refer to ra_tid */
 #define IWLAGN_TX_RES_TID_POS	0
-#define IWLAGN_TX_RES_TID_MSK	0x0f
+#define IWLAGN_TX_RES_TID_MSK	0x07
 #define IWLAGN_TX_RES_RA_POS	4
 #define IWLAGN_TX_RES_RA_MSK	0xf0
 
-- 
2.11.0
