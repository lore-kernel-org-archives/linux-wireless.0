Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imo-m22.mx.aol.com ([64.12.137.3]:37834 "EHLO
	imo-m22.mail.aol.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbZHBI4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 04:56:51 -0400
Message-ID: <4A755264.60201@netscape.net>
Date: Sun, 02 Aug 2009 02:46:28 -0600
From: Patrick Simmons <linuxrocks123@netscape.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>, mb@bu3sch.de,
	dsd@gentoo.org, kune@deine-taler.de,
	Patrick Simmons <linuxrocks123@netscape.net>
Subject: [PATCH] zd1211rw: fix unaligned access in zd_mac_rx
References: <1249029583.29587.46.camel@johannes.local>	 <20090731.222350.254918321.davem@davemloft.net>	 <200908011240.17229.mb@bu3sch.de>	 <20090801.091207.217317135.davem@davemloft.net>	 <4A74EEB2.6040400@netscape.net> <1249199441.2007.7.camel@johannes.local>
In-Reply-To: <1249199441.2007.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an unaligned memory access in the zd_mac_rx function of zd1211rw 
that causes problems on SPARC64.

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>

--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -694,7 +694,7 @@
                        && !mac->pass_ctrl)
                return 0;

-       fc = *(__le16 *)buffer;
+       fc = get_unaligned((__le16*)buffer);
        need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);

        skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
