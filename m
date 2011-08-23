Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1813 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/8] staging: brcm80211: fix rtnl_lock issue when
 bringing down brcmfmac
Date: Tue, 23 Aug 2011 14:13:57 +0200
Message-ID: <1314101640-4229-6-git-send-email-arend@broadcom.com> (sfid-20110823_141429_584378_8E67E2BF)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When bringing down the netdevice interface a deadlock occurred
sporadically due to the rtnl_lock being held by a task that was
waiting for another task trying to get the lock. This patch fixes
that issue.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 95d6944..f9742b0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3189,7 +3189,14 @@ static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	if (cfg_priv->iscan_on && iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		send_sig(SIGTERM, iscan->tsk, 1);
+
+		/*
+		 * The iscan task may want to acquire the rtnl_lock
+		 * so release it here upon stopping the task.
+		 */
+		rtnl_unlock();
 		kthread_stop(iscan->tsk);
+		rtnl_lock();
 		iscan->tsk = NULL;
 
 		/* Abort iscan running in FW */
-- 
1.7.4.1


