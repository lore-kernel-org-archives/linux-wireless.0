Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43580 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0GUWQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 18:16:34 -0400
Received: by fxm14 with SMTP id 14so3934768fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 15:16:33 -0700 (PDT)
Date: Thu, 22 Jul 2010 00:16:16 +0200
From: Dan Carpenter <error27@gmail.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: potential null deref in iwlagn_request_scan()?
Message-ID: <20100721221616.GT17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains about iwlagn_request_scan().

drivers/net/wireless/iwlwifi/iwl-agn-lib.c +1354 iwlagn_request_scan(204)
	error: we previously assumed 'vif' could be null.

  1351          if (!priv->is_internal_short_scan) {
  1352                  cmd_len = iwl_fill_probe_req(priv,
  1353                                          (struct ieee80211_mgmt *)scan->data,
  1354                                          vif->addr,
						^^^^^^^^^

  1355                                          priv->scan_request->ie, 
  1356						priv->scan_request->ie_len,
  1357                                          IWL_MAX_SCAN_SIZE - sizeof(*scan));
  1358          } else {
  1359                  /* use bcast addr, will not be transmitted but must be valid */

This was added in 3a0b9aad0a8166e9f "iwlwifi: use virtual interface
address for scan".  Prior to that commit the function assumed that vif
could be NULL throughout.

I don't know the code well enough to know what to do about this.

Also the same thing for:
drivers/net/wireless/iwlwifi/iwl3945-base.c +2963 iwl3945_request_scan(158)
	error: we previously assumed 'vif' could be null.

  2962          if (!priv->is_internal_short_scan) {
  2963                  scan->tx_cmd.len = cpu_to_le16(
  2964                          iwl_fill_probe_req(priv,
  2965                                  (struct ieee80211_mgmt *)scan->data,
  2966                                  vif->addr,
					^^^^^^^^^
  2967                                  priv->scan_request->ie,
  2968                                  priv->scan_request->ie_len,
  2969                                  IWL_MAX_SCAN_SIZE - sizeof(*scan)));
  2970          } else {

This is from the above commit as well.

regards,
dan carpenter

