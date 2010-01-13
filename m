Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54471 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab0AMV3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:29:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: missing ksize export
Date: Wed, 13 Jan 2010 22:29:04 +0100
Message-Id: <1263418145-30380-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ksize is used two times now in net/wireless/scan.c
This changes the check into false, if the kernel does not export ksize.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/02-ksize.patch |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/patches/02-ksize.patch b/patches/02-ksize.patch
index 013c0b4..726fa2b 100644
--- a/patches/02-ksize.patch
+++ b/patches/02-ksize.patch
@@ -12,16 +12,33 @@ of the situation.
 
 --- a/net/wireless/scan.c
 +++ b/net/wireless/scan.c
-@@ -423,7 +423,12 @@ cfg80211_bss_update(struct cfg80211_regi
+@@ -424,9 +424,14 @@ cfg80211_bss_update(struct cfg80211_regi
  			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
- 			size_t ielen = res->pub.len_information_elements;
+ 			size_t ielen = res->pub.len_proberesp_ies;
  
 +#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28)
 +			if (0) {
 +				used = 0; /* just to shut up the compiler */
 +#else
- 			if (!found->ies_allocated && ksize(found) >= used + ielen) {
+ 			if (found->pub.proberesp_ies &&
+ 			    !found->proberesp_ies_allocated &&
+ 			    ksize(found) >= used + ielen) {
 +#endif
- 				memcpy(found->pub.information_elements,
- 				       res->pub.information_elements, ielen);
- 				found->pub.len_information_elements = ielen;
+ 				memcpy(found->pub.proberesp_ies,
+ 				       res->pub.proberesp_ies, ielen);
+ 				found->pub.len_proberesp_ies = ielen;
+@@ -457,9 +462,14 @@ cfg80211_bss_update(struct cfg80211_regi
+ 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+ 			size_t ielen = res->pub.len_beacon_ies;
+ 
++#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28)
++			if (0) {
++				used = 0; /* just to shut up the compiler */
++#else
+ 			if (found->pub.beacon_ies &&
+ 			    !found->beacon_ies_allocated &&
+ 			    ksize(found) >= used + ielen) {
++#endif
+ 				memcpy(found->pub.beacon_ies,
+ 				       res->pub.beacon_ies, ielen);
+ 				found->pub.len_beacon_ies = ielen;
-- 
1.6.3.3

