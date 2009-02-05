Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32836 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZBELOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 06:14:16 -0500
Date: Thu, 5 Feb 2009 13:10:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205111058.GA16422@jm.kir.nu> (sfid-20090205_121421_832276_D0A6C5D1)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local> <20090205084407.GA11126@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090205084407.GA11126@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 10:44:07AM +0200, Jouni Malinen wrote:
> As far as a possible workaround in kernel code is concerned,
> length=65535 could be considered a special case. Since it is clear that
> userspace cannot provide a larger buffer, there is not much point in
> returning -E2BIG. Instead, the results could be truncated after the last
> BSS that fit into the buffer and that would be returned to userspace.
> This is likely going to be much more useful than not being able to
> receive any result.

And here's an example patch on doing that for mac80211 (drivers that do
not use mac80211 would need to do something similar if they want to
support this mechanism). Would this change be acceptable for mac80211?

---
 net/mac80211/scan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- wireless-testing.orig/net/mac80211/scan.c	2009-02-05 11:33:37.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-02-05 13:07:41.000000000 +0200
@@ -934,6 +934,19 @@ int ieee80211_scan_results(struct ieee80
 	list_for_each_entry(bss, &local->bss_list, list) {
 		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
 			spin_unlock_bh(&local->bss_lock);
+			if (len == 65535) {
+				/*
+				 * WEXT uses 16-bit field for the length which
+				 * means that the largest buffer size that can
+				 * be used here is 65535 bytes. There is not
+				 * much help in returning -E2BIG if the user
+				 * space program cannot use a larger buffer. As
+				 * a workaround, return as many BSSes as
+				 * possible instead of making it impossible for
+				 * the application to get any results.
+				 */
+				return current_ev - buf;
+			}
 			return -E2BIG;
 		}
 		current_ev = ieee80211_scan_result(local, info, bss,
 
-- 
Jouni Malinen                                            PGP id EFC895FA
