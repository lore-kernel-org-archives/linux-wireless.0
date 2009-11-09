Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZKIW4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:56:04 -0500
Date: Mon, 09 Nov 2009 16:56:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix sparse warnings
Message-ID: <4af89e06.WiuJ+1TkMf6eizxN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to a missing header include, sparse generates the following warnings:

  CHECK   drivers/net/wireless/rtl818x/rtl8187_rfkill.c
warning: symbol 'rtl8187_rfkill_init' was not declared. Should it be static?
warning: symbol 'rtl8187_rfkill_poll' was not declared. Should it be static?
warning: symbol 'rtl8187_rfkill_exit' was not declared. Should it be static?

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.33 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
@@ -18,6 +18,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8187.h"
+#include "rtl8187_rfkill.h"
 
 static bool rtl8187_is_radio_enabled(struct rtl8187_priv *priv)
 {
