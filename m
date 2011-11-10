Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1KJIow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 03:44:52 -0500
Subject: [PATCH] nl80211: fix compiler warning
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20111109215007.GD10712@tuxdriver.com> (sfid-20111109_230016_428309_0817D10D)
References: <20111109215007.GD10712@tuxdriver.com>
	 (sfid-20111109_230016_428309_0817D10D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 09:44:46 +0100
Message-ID: <1320914686.3967.4.camel@jlt3.sipsolutions.net> (sfid-20111110_094456_632513_1E2E338C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

John reported the following warning:

net/wireless/nl80211.c: In function ‘nl80211_tx_mgmt’:
net/wireless/nl80211.c:5286:8: warning: ‘hdr’ may be used uninitialized in this function

Evidently, his version of gcc isn't able to see that
when "msg" is initialized, "hdr" must also be. My
gcc, 4.6.1, can actually see that and doesn't warn.
Simply initialize the variable to NULL. That means
if the compiler was ever right we'll crash though so
isn't really optimal since it may hide warnings from
the compiler when somebody modifies this code in the
future.

Reported-by: John Linville <linville@tuxdriver.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/nl80211.c	2011-11-10 09:36:08.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-10 09:42:15.000000000 +0100
@@ -5283,7 +5283,7 @@ static int nl80211_tx_mgmt(struct sk_buf
 	bool channel_type_valid = false;
 	u32 freq;
 	int err;
-	void *hdr;
+	void *hdr = NULL;
 	u64 cookie;
 	struct sk_buff *msg = NULL;
 	unsigned int wait = 0;


