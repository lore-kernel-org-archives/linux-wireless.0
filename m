Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([212.112.241.193]:42379 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab0LIKzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 05:55:07 -0500
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-wireless@vger.kernel.org
Cc: Sven Neumann <s.neumann@raumfeld.com>
Subject: [PATCH] cfg80211: update information elements in cached BSS struct
Date: Thu,  9 Dec 2010 11:48:10 +0100
Message-Id: <1291891690-26118-1-git-send-email-s.neumann@raumfeld.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a cached BSS struct is updated because a new beacon was received,
the code replaces the cached information elements by the IEs from the
new beacon. However it did not update the pub.information_elements
and pub.len_information_elements fields leaving them either pointing
to the old beacon IEs or in an inconsistent state where the data is
replaced by the new beacon IEs but len_information_elements still has
its value from the first beacon.

Fix this by updating the information elements fields if they are
pointing to beacon IEs.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
---
 net/wireless/scan.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 503ebb8..629bfaa 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -465,6 +465,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
 			size_t ielen = res->pub.len_beacon_ies;
 
+                        int information_elements_is_beacon_ies =
+                                (found->pub.information_elements == found->pub.beacon_ies);
+
 			if (found->pub.beacon_ies &&
 			    !found->beacon_ies_allocated &&
 			    ksize(found) >= used + ielen) {
@@ -487,6 +490,11 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 					found->pub.len_beacon_ies = ielen;
 				}
 			}
+
+                        if (information_elements_is_beacon_ies) {
+                                found->pub.information_elements = found->pub.beacon_ies;
+                                found->pub.len_information_elements = found->pub.len_beacon_ies;
+                        }
 		}
 
 		kref_put(&res->ref, bss_release);
-- 
1.7.1

