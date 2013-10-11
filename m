Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52178 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3JKSaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 14:30:06 -0400
Received: by mail-pd0-f171.google.com with SMTP id g10so4589307pdj.30
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 11:30:05 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh beaconing
Date: Fri, 11 Oct 2013 11:29:47 -0700
Message-Id: <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203015_579176_5A15AC8F)
In-Reply-To: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support the adding of CSA and MCSP elements while building the beacon
for mesh if necessary. This is defined in the IEEE Std 802.11-2012
section 10.9.8.4.3 that both CSA and MCSP elements must be included
in beacon and probe response frames until the intended channel
switch time.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mesh.c        |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 829ff7e..f10907f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -599,7 +599,9 @@ struct ieee80211_if_mesh {
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
 	/* Channel Switching Support */
+	struct cfg80211_csa_settings *csa_settings;
 	bool chsw_init;
+	u8 chsw_ttl;
 	u16 pre_value;
 };
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0a3ccaa..f849153 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -624,6 +624,10 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 
 	head_len = hdr_len +
 		   2 + /* NULL SSID */
+		   /* Channel Switch Announcement */
+		   2 + sizeof(struct ieee80211_channel_sw_ie) +
+		   /* Mesh Channel Swith Parameters */
+		   2 + sizeof(struct ieee80211_mesh_chansw_params_ie) +
 		   2 + 8 + /* supported rates */
 		   2 + 3; /* DS params */
 	tail_len = 2 + (IEEE80211_MAX_SUPP_RATES - 8) +
@@ -665,6 +669,36 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0x0;
 
+	if (ifmsh->csa_settings) {
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+		__le16 pre_value;
+
+		pos = skb_put(skb, 13);
+		memset(pos, 0, 13);
+		*pos++ = WLAN_EID_CHANNEL_SWITCH;
+		*pos++ = 3;
+		*pos++ = 0x0;
+		*pos++ = ieee80211_frequency_to_channel(
+				ifmsh->csa_settings->chandef.chan->center_freq);
+		sdata->csa_counter_offset_beacon = hdr_len + 6;
+		*pos++ = ifmsh->csa_settings->count;
+		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
+		*pos++ = 6;
+		if (ifmsh->chsw_init) {
+			*pos++ = ifmsh->mshcfg.dot11MeshTTL;
+			*pos |= WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+		} else {
+			*pos++ = ifmsh->chsw_ttl;
+		}
+		*pos++ |= ifmsh->csa_settings->block_tx ?
+			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
+		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos);
+		pos += 2;
+		pre_value = cpu_to_le16(ifmsh->pre_value);
+		memcpy(pos, &pre_value, 2);
+		pos += 2;
+	}
+
 	if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 	    mesh_add_ds_params_ie(sdata, skb))
 		goto out_free;
@@ -942,6 +976,7 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	offset_ttl = (len < 42) ? 7 : 10;
 	*(pos + offset_ttl) -= 1;
 	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+	sdata->u.mesh.chsw_ttl = *(pos + offset_ttl);
 
 	memcpy(mgmt_fwd, mgmt, len);
 	eth_broadcast_addr(mgmt_fwd->da);
-- 
1.7.9.5

