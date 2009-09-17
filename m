Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx33.mail.ru ([94.100.176.47]:53951 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbZIQByZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 21:54:25 -0400
Date: Thu, 17 Sep 2009 06:01:19 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <142272111.20090917060119@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re[2]: 2.6.25 kernel & compat-wireless-2009-09-14
In-reply-To: <43e72e890909161654x141f48e4q54f0526bf6c04ea3@mail.gmail.com>
References: <191513177.20090917035628@mail.ru>
 <43e72e890909161654x141f48e4q54f0526bf6c04ea3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thursday, September 17, 2009, 2:54:28 AM, Luis R. Rodriguez wrote:
>> device_add in 2.6.25.20 wants some bus_id, but bus_id seems to not
>> be assigned anymore, so device_add fails. Therefore, wiphy_register
>> fails, and then clearly ieee80211_register_hw fails too.
>>
>> Any ideas how to properly fix this?

> FIgure out what the bus_id is used for first.

Hmm, don't know, but the following helps and wlan0 appears:

--- everything.orig/net/wireless/core.c 2009-09-16 23:45:40.000000000 +0400
+++ everything/net/wireless/core.c      2009-09-16 23:48:22.000000000 +0400
@@ -350,6 +350,7 @@
 
        /* give it a proper name */
        dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+       snprintf(rdev->wiphy.dev.bus_id, BUS_ID_SIZE, PHY_NAME "%d", rdev->wiphy_idx);
 
        mutex_init(&rdev->mtx);
        mutex_init(&rdev->devlist_mtx);


>   Luis


