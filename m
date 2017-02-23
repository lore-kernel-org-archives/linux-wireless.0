Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33912 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdBWMiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 07:38:20 -0500
Received: by mail-wm0-f65.google.com with SMTP id m70so2528408wma.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 04:36:30 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id m83sm6536101wmc.33.2017.02.23.04.02.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Feb 2017 04:02:17 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211_hwsim: Make sure NEW_RADIO contains final name
Date: Thu, 23 Feb 2017 13:02:10 +0100
Message-Id: <20170223120211.22358-1-andrew.zaborowski@intel.com> (sfid-20170223_133859_059973_93F557B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_alloc_hw_nm will validate the requested name (if any) before
creating the new device and may use a name different from the one
requested rather than fail.  Make sure the HWSIM_CMD_NEW_RADIO
event/response generated has the final name or userspace will receive
the wrong name.  Note that mac80211_hwsim_new_radio may now modify
params.

A check for duplicate radio name could be added separately.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0150747..ba4978d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2438,6 +2438,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		goto failed;
 	}
 
+	/* ieee80211_alloc_hw_nm may have used a default name */
+	param->hwname = wiphy_name(hw->wiphy);
+
 	if (info)
 		net = genl_info_net(info);
 	else
-- 
2.9.3
