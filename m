Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33812 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753308AbZDXVNH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 17:13:07 -0400
Date: Fri, 24 Apr 2009 14:09:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Quentin Armitage <Quentin@armitage.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] cfg80211: remove superfluous !last_request check in
	reg_device_remove()
Message-ID: <20090424210931.GY3036@sequoia.sous-sol.org> (sfid-20090424_231313_563634_AFDB5412)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 0ad8acaf "cfg80211: fix NULL pointer deference in
reg_device_remove()" added a check that last_request is non-NULL,
rendering the 2nd check superfluous.  While there, rearrange the code a
bit so it's a little more straight forward.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/wireless/reg.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6c1993d..ab995b7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2099,14 +2099,14 @@ void reg_device_remove(struct wiphy *wiphy)
 
 	assert_cfg80211_lock();
 
+	kfree(wiphy->regd);
+
 	if (last_request)
 		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
-	kfree(wiphy->regd);
-	if (!last_request || !request_wiphy)
-		return;
-	if (request_wiphy != wiphy)
+	if (!request_wiphy || request_wiphy != wiphy)
 		return;
+
 	last_request->wiphy_idx = WIPHY_IDX_STALE;
 	last_request->country_ie_env = ENVIRON_ANY;
 }
