Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30982 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0LPDYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 22:24:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 19:24:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] cfg80211/ath: custom regulatory bug fixes
Date: Wed, 15 Dec 2010 19:24:10 -0800
Message-ID: <1292469852-2987-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a couple of fixes for the recent change we did where we
moved the core regulatory hint to the queue. In a really slow box
or if you are doing crazy testing this can potentilly occur. I take
it the patch "cfg80211: put core regulatory request into queue"
will note make it in until 2.6.38, so these are not a stable fixes.

I was able to force the condition by doing:

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 99d4183..e6f483d0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1481,7 +1481,7 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
-	reg_process_hint(reg_request);
+	//reg_process_hint(reg_request);
 
 out:
 	mutex_unlock(&reg_mutex);

This mimics the situation of either having a slow box or you
doing some crazy module load/unload testing.

Luis R. Rodriguez (2):
  cfg80211: fix null pointer dereference with a custom regulatory
    request
  ath: fix NULL pointer dereference on reg_notifier()

 drivers/net/wireless/ath/regd.c |    8 ++++++++
 include/net/cfg80211.h          |    4 +++-
 net/wireless/reg.c              |    3 ++-
 3 files changed, 13 insertions(+), 2 deletions(-)

-- 
1.7.3.2.90.gd4c43

