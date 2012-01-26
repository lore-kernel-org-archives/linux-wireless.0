Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:57448 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab2AZMmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:49 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not encrypt EAPOL frames in IBSS Mode.
Date: Thu, 26 Jan 2012 13:42:22 +0100
Message-Id: <1327581742-15460-1-git-send-email-cavallar@lri.fr> (sfid-20120126_134252_162490_7A6AB3DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, EAPOL Frames in IBSS mode are encrypted if a PTK
is available.  This patch turn off encryption for all EAPOL
frames when on IBSS mode, as there is no suitable userspace
calls to configure the control port protocol and settings.

IBSS RSN sort-of worked without this patch because PTKs
are only installed after the completion of a successful
EAPOL exchange,  so unicast operations would work,  but
multicast and rekeying would often fail.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
 net/mac80211/ibss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bed30ba..9d8e699 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1022,6 +1022,8 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
+	sdata->control_port_no_encrypt = true;
+
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 	mutex_init(&ifibss->mtx);
-- 
1.7.8.3

