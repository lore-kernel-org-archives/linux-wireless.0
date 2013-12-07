Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13473 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab3LFOZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 09:25:17 -0500
Date: Fri, 6 Dec 2013 19:54:08 -0800
From: Avinash Patil <patila@marvell.com>
To: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [RFC] cfg80211: set regulatory request processed for initiator core
Message-ID: <20131207035407.GA19456@pe-lt052.marvell.com> (sfid-20131206_152526_245728_6B3AC295)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During cfg80211 init, cfg80211 initializes regulatory to set to
world domain. Here we dont set last request processed flag.
This results into further request set to pending indefinitely.

This patch fixes this by setting last request to processed.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 net/wireless/reg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec54e1a..70a8f0a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1670,6 +1670,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	switch (reg_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		reg_process_hint_core(reg_request);
+		nl80211_send_reg_change_event(reg_request);
+		reg_set_request_processed();
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
 		treatment = reg_process_hint_user(reg_request);
-- 
1.7.3.4

