Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34990 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932261AbcJTQsv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 12:48:51 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Ganapathi Bhat" <gbhat@marvell.com>
Subject: cfg80211: race problem between suspend and disconnect event
Date: Thu, 20 Oct 2016 16:47:24 +0000
Message-ID: <67400d1c5c2141b3af75bdce9ec43840@SC-EXCH04.marvell.com> (sfid-20161020_184855_760482_243B2858)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

We came across one race issue while running suspend tests with Marvell device.

Mwifiex driver rejects del_key() requests from cfg80211 during suspend. They came very late when driver's cfg80211_suspend handler is already executed and driver is in the middle of SDIO's suspend handler.

In wowlan not configured case, below code ensures cfg80211 terminates connection before calling ops->suspend. However when driver reports disconnection through cfg80211_disconnected() API, cfg80211 handles EVENT_DISCONNECTED in separate work function where ops->del_key() is called in loop to flush keys.

------wiphy_suspend()-----------
if (rdev->wiphy.registered) {
         if (!rdev->wiphy.wowlan_config)
                cfg80211_leave_all(rdev);
          if (rdev->ops->suspend)
           ret = rdev_suspend(rdev, rdev->wiphy.wowlan_config);
--------------------------------

Please let us know if you have any suggestions to resolves this with cfg80211/driver change.

Regards,
Amitkumar
