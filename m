Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:43399 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751414AbXKGLVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 06:21:39 -0500
Date: Wed, 7 Nov 2007 12:18:47 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 doesn't reassociate after failed ProbeResp
Message-ID: <20071107121847.72d46dac@morte> (sfid-20071107_112146_238671_702CC72C)
In-Reply-To: <20071107104222.1fa0b728@morte>
References: <20071107102158.61b4ca3d@morte>
	<20071107104222.1fa0b728@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the issue for me. Note that this is a dirty hack and may break
roaming and everything badly. Will try to fix this better.

--- net/mac80211/ieee80211_sta.c~       2007-11-07 12:08:08.847346973 +0100
+++ net/mac80211/ieee80211_sta.c        2007-11-07 12:08:08.848346821 +0100
@@ -785,7 +785,7 @@
                                       "range\n",
                                       dev->name, print_mac(mac, ifsta->bssid));
                                disassoc = 1;
-                               sta_info_free(sta);
+//                             sta_info_free(sta);
                        } else
                                ieee80211_send_probe_req(dev, ifsta->bssid,
                                                         local->scan_ssid,


-- 
Ciao
Stefano
