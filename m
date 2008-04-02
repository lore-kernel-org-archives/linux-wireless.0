Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3197 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYDBBEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 21:04:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/net/wireless/iwlwifi/iwl-debugfs.c: fix another '%llu' warning
Date: Tue,  1 Apr 2008 20:59:32 -0400
Message-Id: <1207097972-16649-1-git-send-email-linville@tuxdriver.com> (sfid-20080402_020433_602919_9374E15E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-debugfs.c: In function =E2=80=98iwl_db=
gfs_stations_read=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-debugfs.c:247: warning: format =E2=80=98=
%llu=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, bu=
t argument 4 has type =E2=80=98u64=E2=80=99

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I finally have a 64-bit box in my build stable...(thanks, Sony!)

 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/w=
ireless/iwlwifi/iwl-debugfs.c
index b2cc552..447ff2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -243,7 +243,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file =
*file, char __user *user_buf,
 						station->tid[j].agg.wait_for_ba);
 				pos +=3D sprintf(buf+pos, "%u\t%llu\t%u\n",
 						station->tid[j].agg.start_idx,
-						station->tid[j].agg.bitmap,
+						(unsigned long long)station->tid[j].agg.bitmap,
 						station->tid[j].agg.rate_n_flags);
 			}
 			pos +=3D sprintf(buf+pos, "\n");
--=20
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
