Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49055 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1KOGeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:34:04 -0500
Date: Tue, 15 Nov 2011 09:33:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: use kfree_skb() instead of kfree()
Message-ID: <20111115063309.GB30827@elgon.mountain> (sfid-20111115_073411_110164_EB28A936)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sk_buff structs should be freed using kfree_skb().

This was introduced recently in 029458212 "mac80211: Save probe
response data for bss".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 12a6d4b..b34ca0c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -474,7 +474,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
-		kfree(old_probe_resp);
+		kfree_skb(old_probe_resp);
 
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
