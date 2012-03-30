Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587Ab2C3JxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 05:53:03 -0400
Message-ID: <1333101179.3908.8.camel@jlt3.sipsolutions.net> (sfid-20120330_115311_737559_47B12744)
Subject: [PATCH] compat-3.3: include module.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 11:52:59 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

compat/compat-3.3.c:172:1: warning: data definition has no type or storage class [enabled by default]
compat/compat-3.3.c:172:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_GPL’ [-Wimplicit-int]
compat/compat-3.3.c:172:1: warning: parameter names (without types) in function declaration [enabled by default]

In newer kernels we should include export.h, but
not all kernels have that so use module.h which
always works.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-3.3.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/compat/compat-3.3.c b/compat/compat-3.3.c
index 27c09e0..8489344 100644
--- a/compat/compat-3.3.c
+++ b/compat/compat-3.3.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 #include <linux/skbuff.h>
+#include <linux/module.h>
 #include <net/dst.h>
 #include <net/xfrm.h>
 
-- 
1.7.9.1



