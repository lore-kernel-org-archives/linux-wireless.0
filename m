Return-path: <linux-wireless-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Received: from havoc.gtf.org ([69.61.125.42]:41743 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXJWWoq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 18:44:46 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 10/12] mac80211: fix warning created by BIT()
Message-Id: <20071023223645.421AB1F81B6@havoc.gtf.org> (sfid-20071023_234507_864116_FA3D188D)
Date: Tue, 23 Oct 2007 18:36:45 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that BIT() forces unsigned long, this warning appears:

net/mac80211/ieee80211_sta.c: In function =E2=80=98ieee80211_rx_mgmt_as=
soc_resp=E2=80=99:
net/mac80211/ieee80211_sta.c:1187: warning: format =E2=80=98%d=E2=80=99=
 expects type =E2=80=98int=E2=80=99, but argument 7 has type =E2=80=98l=
ong unsigned int=E2=80=99

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.=
c
index f7ffeec..bdfd901 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct n=
et_device *dev,
 	aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
=20
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=3D0x%x "
-	       "status=3D%d aid=3D%d)\n",
+	       "status=3D%d aid=3D%ld)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
