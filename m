Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([94.100.176.85]:58092 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZIQCcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 22:32:10 -0400
Date: Thu, 17 Sep 2009 06:38:55 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1502527774.20090917063855@mail.ru>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re[4]: 2.6.25 kernel & compat-wireless-2009-09-14
In-reply-To: <1253153088.9450.10.camel@johannes.local>
References: <191513177.20090917035628@mail.ru>
 <43e72e890909161654x141f48e4q54f0526bf6c04ea3@mail.gmail.com>
 <142272111.20090917060119@mail.ru> <1253153088.9450.10.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thursday, September 17, 2009, 5:04:48 AM, Johannes Berg wrote:
>>
>> --- everything.orig/net/wireless/core.c 2009-09-16 23:45:40.000000000 +0400
>> +++ everything/net/wireless/core.c      2009-09-16 23:48:22.000000000 +0400
>> @@ -350,6 +350,7 @@
>>  
>>         /* give it a proper name */
>>         dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
>> +       snprintf(rdev->wiphy.dev.bus_id, BUS_ID_SIZE, PHY_NAME "%d", rdev->wiphy_idx);

> Isn't that exactly what dev_set_name() is/was supposed to do?
Well, probably yes, but still it doesn't set bus_id, I've checked.
Probably it needs some correction.

> johannes


