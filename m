Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZD3SK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 14:10:28 -0400
Subject: [PATCH] cfg80211: fix truncated IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 20:09:56 +0200
Message-Id: <1241114996.29878.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another bug in the "cfg80211: do not replace BSS structs" patch,
a forgotten length update leads to bogus data being stored and
passed to userspace, often truncated.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/scan.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/wireless/scan.c	2009-04-30 19:37:39.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-04-30 19:37:44.000000000 +0200
@@ -393,6 +393,7 @@ cfg80211_bss_update(struct cfg80211_regi
 					memcpy(ies, res->pub.information_elements, ielen);
 					found->ies_allocated = true;
 					found->pub.information_elements = ies;
+					found->pub.len_information_elements = ielen;
 				}
 			}
 		}


