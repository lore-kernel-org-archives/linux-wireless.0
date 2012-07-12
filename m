Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36783 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181Ab2GLMeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 08:34:02 -0400
Subject: [PATCH] cfg80211: fix set_regdom() to cancel requests with same alpha2
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 12 Jul 2012 15:33:58 +0300
Message-ID: <20120712123358.22054.62538.stgit@localhost6.localdomain6> (sfid-20120712_143407_357227_CA39EE4B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While adding regulatory support to ath6kl I noticed that I easily
got the regulatory code confused. The way to reproduce the bug was:

1. iw reg set FI (in userspace)
2. cfg80211 calls ath6kl_reg_notify(FI)
3. ath6kl sets regdomain in firmware
4. firmware sends regdomain event to notify about the new regdomain (FI)
5. ath6kl calls regulatory_hint(FI)

And this (from FI to FI transition) confuses cfg80211 and after that I
only get "Pending regulatory request, waiting for it to be
processed...." messages and regdomain changes won't work anymore.

The reason why ath6kl calls regulatory_hint() is that firmware can change
the regulatory domain by it's own, for example due to 11d IEs. I could
of course workaround this in ath6kl but I think it's better to handle
the case in cfg80211.

The fix is pretty simple, use a different error code if the regdomain is
same and then just set the request processed so that it doesn't block new
requests.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 net/wireless/reg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6d57e18..dbb01df 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2205,7 +2205,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * checking if the alpha2 changes if CRDA was already called
 		 */
 		if (!regdom_changes(rd->alpha2))
-			return -EINVAL;
+			return -EALREADY;
 	}
 
 	/*
@@ -2325,6 +2325,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
 	if (r) {
+		if (r == -EALREADY)
+			reg_set_request_processed();
+
 		kfree(rd);
 		mutex_unlock(&reg_mutex);
 		return r;

