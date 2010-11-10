Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0KJCVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:05 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:05 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 11/44] compat/2.6.24: add compat macro for sk_alloc()
Date: Tue,  9 Nov 2010 21:19:53 -0500
Message-Id: <1289355626-25373-12-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was part of the network namespace move.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.24.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index f9c777c..6d5dce5 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <net/sock.h>
 
 #define KEY_BLUETOOTH	237
 #define KEY_WLAN	238
@@ -161,6 +162,8 @@ struct ssb_device_id {
 /* Namespace stuff, introduced on 2.6.24 */
 #define dev_get_by_index(a, b)		dev_get_by_index(b)
 #define __dev_get_by_index(a, b)	__dev_get_by_index(b)
+#define sk_alloc(net, fam, pri, prot)	sk_alloc(fam, pri, prot, 1)
+
 
 /*
  * Display a 6 byte device address (MAC) in a readable format.
-- 
1.7.2.30.gc37d7.dirty

