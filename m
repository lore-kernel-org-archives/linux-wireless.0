Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56032 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbbA3UfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 15:35:14 -0500
Message-ID: <1422650111.1919.45.camel@sipsolutions.net> (sfid-20150130_213519_446632_034E8D75)
Subject: Re: [IWLMVM] Firmware restart issue with 3.19-rc6-wl with AC 3160,
 REV=0x164
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 30 Jan 2015 21:35:11 +0100
In-Reply-To: <CAAd0S9BwPQZhOZSzt2NU1SGjzv8i6685Y7Zb6qRQ1BzJ0P92SA@mail.gmail.com> (sfid-20150130_212341_718339_20307764)
References: <CAAd0S9BwPQZhOZSzt2NU1SGjzv8i6685Y7Zb6qRQ1BzJ0P92SA@mail.gmail.com>
	 (sfid-20150130_212341_718339_20307764)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 21:23 +0100, Christian Lamparter wrote:

> [    6.274625] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND

> [    6.275034] iwlwifi 0000:01:00.0: FW error in SYNC CMD SCD_QUEUE_CFG

WTF. How did the firmware even announce support for this command??

Perhaps I missed it in the log, but which firmware are you using? Any
chance you also upgraded that? Because I can't imagine this code is new
in the tree...

Anyway, make this change:

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 979ac23522f2..5b8c969f457e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -874,7 +874,7 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_API_SCD_CFG;
+	return false;
 }
 
 extern const u8 iwl_mvm_ac_to_tx_fifo[];

I guess Emmanuel will look at it on Sunday :)

johannes

