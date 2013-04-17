Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3DQGWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 02:22:50 -0400
Date: Wed, 17 Apr 2013 08:23:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	Jonas Gorski <jogo@openwrt.org>
Subject: [PATCH 3/2] iwlwifi: remove unneeded goto from
 iwl_dbgfs_log_event_read
Message-ID: <20130417062350.GC1597@redhat.com> (sfid-20130417_082254_096949_43E08E0B)
References: <20130416133828.GA20024@redhat.com>
 <20130416134053.GB20024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416134053.GB20024@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make code simpler a bit.

Reported-by: Jonas Gorski <jogo@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 17f04de..d532948 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2241,10 +2241,8 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 	ssize_t ret;
 
 	ret = iwl_dump_nic_event_log(priv, true, &buf);
-	if (ret < 0)
-		goto err;
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
-err:
+	if (ret > 0)
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
 	kfree(buf);
 	return ret;
 }
-- 
1.7.11.7
