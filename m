Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1KUNRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 08:17:37 -0500
Received: by iage36 with SMTP id e36so7261193iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 05:17:36 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 17:17:36 +0400
Message-ID: <CAG5dHkSFU-y7ONHdtSj+uXJL0ndhg9W4q9rQXHfrNpeqiOvhGg@mail.gmail.com> (sfid-20111121_141741_056803_11D94562)
Subject: [RFC v2 4/8] mac80211: mesh non-peer power mode indication in beacons
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE80211s standard a mesh STA shall indicate itsnon-peer
mesh power mode with the Power Management field in the FrameControl
field and the Mesh Power Save Level field in the MeshCapability field
in Beacon and Probe Response frames.
Signed-off-by: Ivan Bezyazychnyy
<ivan.bezyazychnyy@gmail.com>Signed-off-by: Mike Krinkin
<krinkin.m.u@gmail.com>Signed-off-by: Max Filippov
<jcmvbkbc@gmail.com>--- net/mac80211/mesh.c |    2 ++
net/mac80211/mesh.h |    3 +++ net/mac80211/tx.c   |    3 +++ 3 files
changed, 8 insertions(+), 0 deletions(-)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.cindex
a7078fd..5b8c5d3 100644--- a/net/mac80211/mesh.c+++
b/net/mac80211/mesh.c@@ -242,6 +242,8 @@ mesh_add_meshconf_ie(struct
sk_buff *skb, struct ieee80211_sub_if_data *sdata) 	/* Mesh capability
*/ 	ifmsh->accepting_plinks = mesh_plink_availables(sdata); 	*pos =
MESHCONF_CAPAB_FORWARDING;+	if (sdata->u.mesh.mshcfg.power_mode ==
NL80211_MESH_POWER_DEEP_SLEEP)+		*pos |=
MESHCONF_CAPAB_POWER_SAVE_LEVEL; 	*pos++ |= ifmsh->accepting_plinks ?
	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00; 	*pos++ = 0x00;diff --git
a/net/mac80211/mesh.h b/net/mac80211/mesh.hindex 6842453..e62c53b
100644--- a/net/mac80211/mesh.h+++ b/net/mac80211/mesh.h@@ -188,6
+188,9 @@ struct mesh_rmc { /* Maximum number of paths per interface
*/ #define MESH_MAX_MPATHS		1024 +/* capability power save flag mask
*/+#define MESHCONF_CAPAB_POWER_SAVE_LEVEL	0x80+ /* Public interfaces
*/ /* Various */ int ieee80211_fill_mesh_addresses(struct
ieee80211_hdr *hdr, __le16 *fc,diff --git a/net/mac80211/tx.c
b/net/mac80211/tx.cindex 500c3ce..aeb2968 100644---
a/net/mac80211/tx.c+++ b/net/mac80211/tx.c@@ -2339,6 +2339,9 @@ struct
sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon)); 		mgmt->frame_control
= 		    cpu_to_le16(IEEE80211_FTYPE_MGMT |
IEEE80211_STYPE_BEACON);+		if (sdata->u.mesh.mshcfg.power_mode != +		
  NL80211_MESH_POWER_ACTIVE)+			mgmt->frame_control |=
cpu_to_le16(IEEE80211_FCTL_PM); 		memset(mgmt->da, 0xff, ETH_ALEN);
		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN); 		memcpy(mgmt->bssid,
sdata->vif.addr, ETH_ALEN);-- 1.7.3.4
