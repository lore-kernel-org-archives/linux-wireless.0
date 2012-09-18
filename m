Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3026 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2IRJAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 05:00:54 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] cfg80211: remove obselete comment for
 .sched_scan_stop() callback
Date: Tue, 18 Sep 2012 10:59:59 +0200
Message-ID: <1347958799-4060-1-git-send-email-arend@broadcom.com> (sfid-20120918_110058_850724_FBC5F23A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kerneldoc comment for .sched_scan_stop() callback describes a
driver_initiated flag, but the interface does not hold such a flag.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

Was working on scheduled scan support for brcmfmac and got a little
confused about .sched_scan_stop() documentation. Not sure if this
was stale documentation.

The patch applies to master branch in mac80211-next repository.

Gr. AvS
---
 include/net/cfg80211.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 903683b1..1a3fe9a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1580,9 +1580,7 @@ struct cfg80211_gtk_rekey_data {
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
- * @sched_scan_stop: Tell the driver to stop an ongoing scheduled
- *	scan.  The driver_initiated flag specifies whether the driver
- *	itself has informed that the scan has stopped.
+ * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan.
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
-- 
1.7.9.5


