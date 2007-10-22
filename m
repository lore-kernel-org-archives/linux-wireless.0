Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXJVOKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 10:10:03 -0400
Subject: [PATCH] mac80211: fix printk warning on 64-bit
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Oct 2007 14:51:37 +0200
Message-Id: <1193057497.9793.3.camel@johannes.berg> (sfid-20071022_151010_468966_C51A16C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My AID message patch introduced a warning on 64-bit machines because ~
extends to unsigned long:

| net/mac80211/ieee80211_sta.c: In function =E2=80=98ieee80211_rx_mgmt_=
assoc_resp=E2=80=99:
| net/mac80211/ieee80211_sta.c:1187: warning: format =E2=80=98%d=E2=80=99=
 expects type =E2=80=98int=E2=80=99, but argument 7 has type =E2=80=98l=
ong unsigned int=E2=80=99

This fixes it by explicitly casting the result to u16 (which 'aid' is).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.=
c
index f7ffeec..db3cf23 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1184,7 +1184,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct n=
et_device *dev,
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=3D0x%x "
 	       "status=3D%d aid=3D%d)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
-	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
+	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
=20
 	if (status_code !=3D WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=3D%d)\n",


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
