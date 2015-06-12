Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34812 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbFLWiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 18:38:21 -0400
Received: by igbhj9 with SMTP id hj9so20909033igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 15:38:21 -0700 (PDT)
Message-ID: <557B5F4F.1060703@cococorp.com> (sfid-20150613_003824_998936_628CC44B)
Date: Fri, 12 Jun 2015 15:38:07 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: Check SN for deactivated mpaths
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jesse Jones <jjones@cococorp.com>

When processing a PREQ or PREP it's critical to use the incoming SN. If
that is improperly done routing loops and other types of badness can
happen. But the code was always processing path messages for deactivated
paths. This path fixes that so that if we have a valid SN then we use it
to verify that it is a message we can accept. For reference the relevant
section of the standard is 13.10.8.4 which doesn't address the deactivated
path case at all.

I also included a special case for when our peer reboots or restarts
networking. This is an important case because without it there can be a
very long delay before we accept path messages from that peer. It's also a
simple case and intimately associated with processing messages for
deactivated paths so I used one patch instead of two.

Signed-off-by: Alexis Green <agreen@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 45485f3..3c5f76a 100755
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -79,6 +79,12 @@ static inline u16 u16_field_get(const u8 *preq_elem, int offset, bool ae)
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define SN_GT(x, y) ((s32)(y - x) < 0)
 #define SN_LT(x, y) ((s32)(x - y) < 0)
+#define MAX_SANE_SN_DELTA 32
+
+static inline u32 SN_DELTA(u32 x, u32 y)
+{
+	return x >= y ? x - y : y - x;
+}
 
 #define net_traversal_jiffies(s) \
 	msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
@@ -441,6 +447,26 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					process = false;
 					fresh_info = false;
 				}
+			} else if (!(mpath->flags & MESH_PATH_ACTIVE)) {
+				bool have_sn, newer_sn, bounced;
+
+				have_sn = mpath->flags & MESH_PATH_SN_VALID;
+				newer_sn = have_sn && SN_GT(orig_sn, mpath->sn);
+				bounced = have_sn &&
+					(SN_DELTA(orig_sn, mpath->sn) >
+					MAX_SANE_SN_DELTA);
+
+				if (!have_sn || newer_sn) {
+					/* if SN is newer than what we had
+					 * then we can take it */;
+				} else if (bounced) {
+					/* if SN is way different than what
+					 * we had then assume the other side
+					 * rebooted or restarted */;
+				} else {
+					process = false;
+					fresh_info = false;
+				}
 			}
 		} else {
 			mpath = mesh_path_add(sdata, orig_addr);
