Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1JUIhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:37:21 -0400
Received: by ywf7 with SMTP id 7so3652119ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:37:20 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:37:20 +0400
Message-ID: <CAG5dHkQTpfXvhC8w_1z5MvuKxWV32u2+PM8VKq4Lc5pZm2hAug@mail.gmail.com> (sfid-20111021_103725_207935_F2BAF542)
Subject: [RFC 3/7] mac80211: mesh non-peer power mode indication in beacons
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

inidicate local mesh sta non-peer power mode in beacons

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 net/mac80211/mesh.c |    3 +++
 net/mac80211/mesh.h |    3 +++
 net/mac80211/tx.c   |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a7078fd..c16a203 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -242,6 +242,9 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct
ieee80211_sub_if_data *sdata)
 	/* Mesh capability */
 	ifmsh->accepting_plinks = mesh_plink_availables(sdata);
 	*pos = MESHCONF_CAPAB_FORWARDING;
+	if (sdata->u.mesh.mshcfg.power_mode == NL80211_MESH_POWER_DEEP_SLEEP) {
+		*pos |= MESHCONF_CAPAB_PS_LEVEL;
+	}
 	*pos++ |= ifmsh->accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 6842453..188cc86 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -188,6 +188,9 @@ struct mesh_rmc {
 /* Maximum number of paths per interface */
 #define MESH_MAX_MPATHS		1024

+/* capability power save flag mask */
+#define MESHCONF_CAPAB_PS_LEVEL	0x80
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8f2bc51..b1b1234 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2344,6 +2344,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct
ieee80211_hw *hw,
 		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 		mgmt->frame_control =
 		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
+		if (sdata->u.mesh.mshcfg.power_mode != NL80211_MESH_POWER_ACTIVE) {
+			mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+		}
 		memset(mgmt->da, 0xff, ETH_ALEN);
 		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-- 
1.7.3.4
