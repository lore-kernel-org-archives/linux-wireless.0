Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33130 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYDCSil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 14:38:41 -0400
Message-ID: <47F5242D.80404@lwfinger.net> (sfid-20080403_193846_141791_6F2D15BE)
Date: Thu, 03 Apr 2008 13:38:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	KURT PETERS <peterskurt@msn.com>
Subject: [PATCH] b43legacy: Partial Fix for Range issue
References: <BAY103-F373BE8D28C2F2A21BC15E0D8F70@phx.gbl> <200804031719.44026.mb@bu3sch.de>
In-Reply-To: <200804031719.44026.mb@bu3sch.de>
Content-Type: multipart/mixed;
 boundary="------------030307020107000705000107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030307020107000705000107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When the mac80211 channel tables were recently changed,
the power_level member was removed. As a result, the value
passed to b43legacy in conf->power_level became zero. This
value is transferred to phy->power_level and used in calculating
the desired TX power, which thus became zero. This patch does not
fix all the power problems with b43legacy, but it will be needed
anyway.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.25 material.

Larry


Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -127,6 +127,7 @@ static struct ieee80211_rate __b43legacy
  	{							\
  		.center_freq	= (_freq),			\
  		.hw_value	= (_chanid),			\
+		.max_power	= 0x14,				\
  	}
  static struct ieee80211_channel b43legacy_bg_chantable[] = {
  	CHANTAB_ENT(1, 2412),


--------------030307020107000705000107
Content-Type: text/plain;
 name="monitor"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="monitor"

When the mac80211 channel tables were recently changed,
the power_level member was removed. As a result, the value
passed to b43legacy in conf->power_level became zero. This
value is transferred to phy->power_level and used in calculating
the desired power, which thus became zero.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.25 material.

Larry


Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -127,6 +127,7 @@ static struct ieee80211_rate __b43legacy
 	{							\
 		.center_freq	= (_freq),			\
 		.hw_value	= (_chanid),			\
+		.max_power	= 0x14,				\
 	}
 static struct ieee80211_channel b43legacy_bg_chantable[] = {
 	CHANTAB_ENT(1, 2412),


--------------030307020107000705000107--
