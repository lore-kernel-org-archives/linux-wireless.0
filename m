Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2021 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/13] brcmfmac: remove null-pointer check in
 .sched_scan_start() callback
Date: Sun, 3 Mar 2013 12:45:25 +0100
Message-ID: <1362311132-29561-7-git-send-email-arend@broadcom.com> (sfid-20130303_124614_507438_745E0AB2)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_cfg80211_sched_scan_start() the request parameter was checked
for being non-null. However, it never is so remove the check which gets
rid of following smatch warning:

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:2904
brcmf_cfg80211_sched_scan_start()
warn: variable dereferenced before check 'request' (see line 2897)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 73f5528..d6f8c1a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3054,16 +3054,16 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	int i;
 	int ret = 0;
 
-	brcmf_dbg(SCAN, "Enter n_match_sets:%d   n_ssids:%d\n",
+	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
 		  request->n_match_sets, request->n_ssids);
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
 
-	if (!request || !request->n_ssids || !request->n_match_sets) {
+	if (!request->n_ssids || !request->n_match_sets) {
 		brcmf_err("Invalid sched scan req!! n_ssids:%d\n",
-			  request ? request->n_ssids : 0);
+			  request->n_ssids);
 		return -EINVAL;
 	}
 
-- 
1.7.6


