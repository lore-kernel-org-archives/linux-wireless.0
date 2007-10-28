Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55591 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXJ1LAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 07:00:39 -0400
Message-ID: <472473D2.8040102@freemail.hu> (sfid-20071028_110104_288558_2E3B7035)
Date: Sun, 28 Oct 2007 12:34:42 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix printk() format string
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

Get rid of the following compiler warning message:

net/mac80211/ieee80211_sta.c: In function 'ieee80211_rx_mgmt_assoc_resp=
':
net/mac80211/ieee80211_sta.c:1187: warning: format '%d' expects type 'i=
nt', but argument 7 has type 'long unsigned int'

Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
---
--- linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c.orig	2007-10-24 05:50=
:57.000000000 +0200
+++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c	2007-10-28 11:20:23.0=
00000000 +0100
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);

 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=3D0x%x "
-	       "status=3D%d aid=3D%d)\n",
+	       "status=3D%d aid=3D%lu)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
