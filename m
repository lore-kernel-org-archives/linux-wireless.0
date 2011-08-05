Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37481 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1HEJqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 05:46:32 -0400
Received: by fxh19 with SMTP id 19so2649182fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Aug 2011 02:46:31 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@adurom.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
Date: Fri,  5 Aug 2011 11:46:19 +0200
Message-Id: <1312537579-18950-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110805_114635_482839_AB63725E)
In-Reply-To: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
References: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2007, 7.3.1.14 it is compliant to use a buf_size of
0 in ADDBA requests. But some devices (AVM Fritz Stick N) arn't able to
handle that correctly and will reply with an ADDBA reponse with a
buf_size of 0 which in turn will disallow BA sessions for these
devices.

To work around this problem, initialize hw.max_tx_aggregation_subframes
to the maximum AMPDU buffer size 0x40.

Using 0 as default for the bufsize was introduced in commit
5dd36bc933e8be84f8369ac64505a2938f9ce036 (mac80211: allow advertising
correct maximum aggregate size).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 866f269..104fdd9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -608,6 +608,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.max_rates = 1;
 	local->hw.max_report_rates = 0;
 	local->hw.max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	local->hw.max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
-- 
1.7.3.4

