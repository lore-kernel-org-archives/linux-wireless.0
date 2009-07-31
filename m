Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imo-d22.mx.aol.com ([205.188.144.208]:35128 "EHLO
	imo-d22.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZGaIHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 04:07:50 -0400
Message-ID: <4A72A462.6060107@netscape.net>
Date: Fri, 31 Jul 2009 01:59:30 -0600
From: Patrick Simmons <linuxrocks123@netscape.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Subject: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running zd1211rw on SPARC64 and was getting a lot of "unaligned 
access" messages in dmesg.  I tracked the problem down to this line, and 
changing the cast to a memcpy fixes the issue.

Please CC me with any comments as I am not subscribed to the list.

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>

--- a/drivers/net/wireless/zd1211rw/zd_mac.c    2009-07-30 
23:23:50.000000000 -0600
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c    2009-07-30 
23:58:19.000000000 -0600
@@ -694,7 +694,7 @@
                        && !mac->pass_ctrl)
                return 0;
 
-       fc = *(__le16 *)buffer;
+       memcpy(&fc,buffer,sizeof(__le16));
        need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
 
        skb = dev_alloc_skb(length + (need_padding ? 2 : 0));

