Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33202 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeCUHFj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:05:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id z73so4054351wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 00:05:38 -0700 (PDT)
Received: from iss.Home (static.183.55.0.81.ibercom.com. [81.0.55.183])
        by smtp.gmail.com with ESMTPSA id x18sm2996551wmc.2.2018.03.21.00.05.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Mar 2018 00:05:37 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Set wmediumd for new radios
Date: Wed, 21 Mar 2018 08:05:18 +0100
Message-Id: <20180321070518.29732-1-andrew.zaborowski@intel.com> (sfid-20180321_080542_837919_631A825D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the wmediumd to the net's wmediumd when the radio gets created.
Radios created after HWSIM_CMD_REGISTER don't currently get their
data->wmediumd set and the userspace would need to reconnect to
netlink to be able to call HWSIM_CMD_REGISTER again.

Alternatively I think data->netgroup and data->wmedium could be
replaced with a pointer to hwsim_net.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b6c3640a9..100cf42db6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2742,6 +2742,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	mutex_init(&data->mutex);
 
 	data->netgroup = hwsim_net_get_netgroup(net);
+	data->wmediumd = hwsim_net_get_wmediumd(net);
 
 	/* Enable frame retransmissions for lossy channels */
 	hw->max_rates = 4;
-- 
2.14.1
