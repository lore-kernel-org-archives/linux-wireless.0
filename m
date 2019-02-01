Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6648EC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 23:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C04214C6
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 23:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfBAXXh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 18:23:37 -0500
Received: from mail.w1.fi ([212.71.239.96]:33236 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbfBAXXh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 18:23:37 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2019 18:23:36 EST
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id 698DA11C51;
        Fri,  1 Feb 2019 23:16:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SdtqmzvUw8sJ; Fri,  1 Feb 2019 23:16:38 +0000 (UTC)
From:   Jouni Malinen <j@w1.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH] mac80211_hwsim: Support boottime in scan results
Date:   Sat,  2 Feb 2019 01:16:31 +0200
Message-Id: <1549062991-28148-1-git-send-email-j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes the age information for cfg80211 scan results more accurate
and fixes issues with wpa_supplicant dropping "old" scan results (e.g.,
"wlan0: Own scan request started a scan in 0.000456 seconds") that
looked like would have been received before a scan started due to the
inaccuracy of the default timing mechanism for calculating the BSS entry
age. This makes hwsim test cases significantly more robust to run.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 320edca..87be2b1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1273,10 +1273,12 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	 * probably doesn't really matter.
 	 */
 	if (ieee80211_is_beacon(hdr->frame_control) ||
-	    ieee80211_is_probe_resp(hdr->frame_control))
+	    ieee80211_is_probe_resp(hdr->frame_control)) {
+		rx_status.boottime_ns = ktime_get_boot_ns();
 		now = data->abs_bcn_ts;
-	else
+	} else {
 		now = mac80211_hwsim_get_tsf_raw();
+	}
 
 	/* Copy skb to all enabled radios that are on the current frequency */
 	spin_lock(&hwsim_radio_lock);
-- 
2.7.4

