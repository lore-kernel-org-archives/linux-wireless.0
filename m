Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21918 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1LTUZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:25:25 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 3/3] cfg80211: relicense reg.c reg.h and genregdb.awk to ISC
Date: Tue, 20 Dec 2011 12:23:38 -0800
Message-ID: <1324412618-25131-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_212533_594944_EE9AB86A)
In-Reply-To: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Following the tradition we have had with ath5k, ath9k, CRDA,
wireless-regdb I'd like to license this code under the permissive ISC
license for the code sharing purposes with other OSes, it'd sure be nice
to help the landscape in this area. Although I am %82.89 owner of the
regulatory code I have asked every contributor to the regulatory code
and have receieved positive Acked-bys from everyone except two deceased
entities:

 o Frans Pop RIP 2010 [0]
	- Frans Pop <elendil@planet.nl>
	- Frans Pop <fjp@debian.org>
 o Nokia     RIP February, 11, 2011 [1], [2]
	- ext-yuri.ershov@nokia.com
	- kalle.valo@nokia.com

Frans Pop's contribution was a simple patch 55f98938, titled,
"wireless: remove trailing space in messages" which just add a \n
to some printk lines. I'm going to treat these additions as
uncopyrightable.

As for the contributions made by employees on behalf of Nokia
my contact point was Petri Karhula <petri.karhula@nokia.com> but
after one month he noted he had not been able to get traction from the
legal department on this request, as such it I proceeded by replacing
their contributions in previous patches.

The end goal is to help a clean rewrite that starts in userspace
that is shared under ISC license which currently is taking place with
the regulatory simulator [3].

[0] http://lists.debian.org/debian-devel/2011/12/msg00263.html
[1] http://press.nokia.com/2011/02/11/nokia-outlines-new-strategy-introduces-new-leadership-operational-structure/
[2] http://NokiaPlanB.com
[3] git://github.com/mcgrof/regsim.git

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Acked-by: Dan Carpenter <error27@gmail.com>
Acked-by: Mihai Moldovan <ionic@ionic.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sven Neumann <s.neumann@raumfeld.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Tony Vroon <tony@linx.net>
Acked-by: Pavel Roskin <proski@gnu.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Acked-by: Pat Erley <pat-lkml@erley.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Joe Perches <joe@perches.com>
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: John Gordon <john@devicescape.com>
Acked-by: Simon Barber <protocolmagic@gmail.com>
Acked-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Acked-by: Jiri Benc <jbenc@upir.cz>
Acked-by: Bruno Randolf <br1@einfach.org>
Acked-by: Scott James Remnant <keybuk@google.com>
Acked-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/genregdb.awk |   13 ++++++++++---
 net/wireless/reg.c        |   17 +++++++++++++----
 net/wireless/reg.h        |   15 +++++++++++++++
 net/wireless/regdb.h      |   16 ++++++++++++++++
 4 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 53c143f..9392f8c 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -7,10 +7,17 @@
 #
 # Copyright 2009 John W. Linville <linville@tuxdriver.com>
 #
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License version 2 as
-# published by the Free Software Foundation.
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
 #
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 BEGIN {
 	active = 0
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c0e0e42..b65c0e9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2,13 +2,22 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2008	Luis R. Rodriguez <lrodriguz@atheros.com>
+ * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+
 /**
  * DOC: Wireless regulatory infrastructure
  *
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 786e414..e2aaaf5 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -1,5 +1,20 @@
 #ifndef __NET_WIRELESS_REG_H
 #define __NET_WIRELESS_REG_H
+/*
+ * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
 
 extern const struct ieee80211_regdomain *cfg80211_regdomain;
 
diff --git a/net/wireless/regdb.h b/net/wireless/regdb.h
index 818222c..3279cfc 100644
--- a/net/wireless/regdb.h
+++ b/net/wireless/regdb.h
@@ -1,6 +1,22 @@
 #ifndef __REGDB_H__
 #define __REGDB_H__
 
+/*
+ * Copyright 2009 John W. Linville <linville@tuxdriver.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 extern const struct ieee80211_regdomain *reg_regdb[];
 extern int reg_regdb_size;
 
-- 
1.7.4.15.g7811d

