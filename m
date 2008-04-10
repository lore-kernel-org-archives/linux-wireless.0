Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30539 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbYDJWzT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 18:55:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH RFC] mac80211: Fixes n-band association problem with certain APs
Date: Thu, 10 Apr 2008 15:49:05 -0700
Message-Id: <1207867745-26538-1-git-send-email-reinette.chatre@intel.com> (sfid-20080410_235525_024632_89BF71AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

=46or WME(221) tag in beacon frames from certain n-only aps=C2=B7
5th bit is not set.So while parsing the beacon frame the wmm_info=C2=B7
structure is used instead of wmm_param. wmm_info structure is=C2=B7
never used to set bss->wmm_ie. While sending the association request to
n-only ap it checks for wmm_ie. If it is set then only ieee80211_ht_cap
is sent during association request.So n-only association fails.
This patch fixes this problem by copying the WME information from wmm_i=
nfo
to bss->wmm_ie and thus enabling n-band association.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/mlme.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 83e8b49..ec2f722 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2668,7 +2668,18 @@ static void ieee80211_rx_bss_info(struct net_dev=
ice *dev,
 			bss->wmm_ie_len =3D elems.wmm_param_len + 2;
 		} else
 			bss->wmm_ie_len =3D 0;
-	} else if (!elems.wmm_param && bss->wmm_ie) {
+	} else if (elems.wmm_info &&
+		    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems.wmm_info_len ||
+		     memcmp(bss->wmm_ie, elems.wmm_info,elems.wmm_info_len))) {
+		kfree(bss->wmm_ie);
+		bss->wmm_ie =3D kmalloc(elems.wmm_info_len + 2, GFP_ATOMIC);
+		if (bss->wmm_ie) {
+			memcpy(bss->wmm_ie, elems.wmm_info - 2,
+			       elems.wmm_info_len + 2);
+			bss->wmm_ie_len =3D elems.wmm_info_len + 2;
+		} else
+			bss->wmm_ie_len =3D 0;
+	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
 		kfree(bss->wmm_ie);
 		bss->wmm_ie =3D NULL;
 		bss->wmm_ie_len =3D 0;
--=20
1.5.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
