Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:59950 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbABTBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 14:01:10 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so41207023oif.7
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2015 11:01:09 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 2 Jan 2015 19:01:09 +0000
Message-ID: <CAAXZBWLOKL8Uu9No_tQga34nFurmeK2HP9qixO1jCXw1Y0t5HA@mail.gmail.com> (sfid-20150102_200114_099984_C94251AC)
Subject: [PATCH] rfkill: parameters documentation
From: Andrew Clausen <andrew.p.clausen@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This patch documents two rfkill module parameters, namely
rfkill.default_state and rfkill.master_switch_mode.

I constructed the patch from Ubuntu packaged source, but I'm happy to
adapt it to any git tree.

Kind regards,
Andrew

Signed-off-by: Andrew Clausen <andrew.p.clausen@gmail.com>
---

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 011855b..824ee3b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2999,6 +2999,20 @@ bytes respectively. Such letter suffixes can
also be entirely omitted.

     retain_initrd    [RAM] Keep initrd memory after extraction

+    rfkill.default_state=
+        0        "airplane mode".  All wifi, bluetooth, wimax,
+                gps, fm, etc. communication is blocked by
+                default.
+        1        Unblocked.
+
+    rfkill.master_switch_mode=
+        0        The "airplane mode" button does nothing.
+        1        The "airplane mode" button toggles between
+                everything blocked and the previous
+                configuration.
+        2        The "airplane mode" button toggles between
+                everything blocked and everything unblocked.
+
     rhash_entries=    [KNL,NET]
             Set number of hash buckets for route cache

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 427e897..2ee6ef9 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -25,6 +25,9 @@ whether they can be changed or not:
  - soft block: writable radio block (need not be readable) that is set by
                the system software.

+The rfkill subsystem has two parameters, rfkill.default_state and
+rfkill.master_switch_mode, which are documented in kernel-parameters.txt.
+

 2. Implementation details
