Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60491 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbYBHLSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 06:18:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: zd1211rw still crashes on device pull
Date: Fri, 8 Feb 2008 12:17:38 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802081217.38466.mb@bu3sch.de> (sfid-20080208_111817_649487_0F72CA8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to remind you. The kernel still crashes sometimes, if
you pull the device while mac80211 is trying to submit a packet.
It will crash with an skb_under_panic in the zd1211 TX path, because
mac80211 allocated it with wrong header size information (zd1211 seems
to already have zero'd the structure out while we pulled the device).

-- 
Greetings Michael.
