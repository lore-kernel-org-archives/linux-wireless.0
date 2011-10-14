Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab1JNPaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:30:10 -0400
Received: by wyg36 with SMTP id 36so197085wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 08:30:09 -0700 (PDT)
Message-ID: <4E985579.9010401@gmail.com> (sfid-20111014_173014_738171_B8BA7DA1)
Date: Fri, 14 Oct 2011 17:30:01 +0200
From: Loiseau Lucien <loiseau.lucien@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] patch on comment
References: <1317543352-29019-1-git-send-email-eliad@wizery.com>	 (sfid-20111002_101552_130579_7FDA5164) <1318433496.3933.44.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318433496.3933.44.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Digging into the source code, i noticed that the documentation tells 
that the tx function from ieee80211_ops should return NETDEV_TX_OK while 
the tx function is now a void function. Here is a very little patch to 
remove this information from the comment :

--- mac80211.h
+++ mac80211.h
@@ -1744,8 +1744,6 @@
   *    configuration in the TX control data. This handler should,
   *    preferably, never fail and stop queues appropriately, more
   *    importantly, however, it must never fail for A-MPDU-queues.
- *    This function should return NETDEV_TX_OK except in very
- *    limited cases.
   *    Must be implemented and atomic.
   *
   * @start: Called before the first netdevice attached to the hardware


Best Regards,

Lucien Loiseau.
