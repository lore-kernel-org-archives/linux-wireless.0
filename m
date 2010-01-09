Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60192 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0AIImZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 03:42:25 -0500
Received: by ewy6 with SMTP id 6so19724043ewy.29
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 00:42:23 -0800 (PST)
Date: Sat, 9 Jan 2010 11:41:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [patch] iwlwifi: silence buffer overflow warning
Message-ID: <20100109084147.GB7840@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch (and presumably other static checkers) complain that MAX_TID_COUNT is 
past the end of the array.  In the resulting discussion, Zhu Yi pointed out
that this value is not used in real life and the assignment was only there to
silence a gcc warning.

If there were a bug in the surrounding code and the value were used, the 
WARN_ON(!qc) would print a warning before the crash.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-01-03 11:02:42.000000000 +0300
+++ devel/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-01-06 00:27:00.000000000 +0300
@@ -1961,7 +1961,7 @@ static void iwl4965_rx_reply_tx(struct i
 	struct ieee80211_tx_info *info;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->u.status);
-	int tid = MAX_TID_COUNT;
+	int uninitialized_var(tid);
 	int sta_id;
 	int freed;
 	u8 *qc = NULL;
