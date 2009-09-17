Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx34.mail.ru ([94.100.176.48]:64965 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbZIPXt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 19:49:57 -0400
Received: from [94.242.37.174] (port=21622 helo=zhubr.mshome.net)
	by mx34.mail.ru with asmtp
	id 1Mo4G8-0009Zu-00
	for linux-wireless@vger.kernel.org; Thu, 17 Sep 2009 03:50:00 +0400
Date: Thu, 17 Sep 2009 03:56:28 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <191513177.20090917035628@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: 2.6.25 kernel & compat-wireless-2009-09-14
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

After some more digging I think I've found an incompatibility.

device_add in 2.6.25.20 wants some bus_id, but bus_id seems to not
be assigned anymore, so device_add fails. Therefore, wiphy_register
fails, and then clearly ieee80211_register_hw fails too.

Any ideas how to properly fix this?


Thank you,
 Nikolai


