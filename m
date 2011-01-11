Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46629 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1AKKXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 05:23:03 -0500
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0BAN1WA008010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 04:23:01 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0BAN1eq004995
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 04:23:01 -0600 (CST)
Received: from DNCE73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0BAN0ZW017110
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 04:23:01 -0600 (CST)
From: "DE CESCO, Jonathan" <jonathanc@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Coelho, Luciano" <coelho@ti.com>
Date: Tue, 11 Jan 2011 11:22:57 +0100
Subject: wl12xx compat wireless rcu_read_lock issue
Message-ID: <13872098A06B02418CF379A158C0F146015BEB592B@dnce02.ent.ti.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	<1294062164-3459-2-git-send-email-shahar_levi@ti.com>
	<1294671655.1992.103.camel@pimenta>
	<AANLkTi=KnSjVVCN=9=PaL9_GYpDOpJFvD-LGxFXEevhw@mail.gmail.com>
 <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
In-Reply-To: <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When trying to test wl12xx driver from compat-wireless-2010-12-13 (with a wl1273 device), I notice a crash when initializing the wlan interface.

Find below the patch that seems to solve the issue:

diff --git a/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c b/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
index 1fc5a36..480f44b 100644
--- a/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
+++ b/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
@@ -1858,11 +1858,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 {
            enum wl1271_cmd_ps_mode mode;
            struct wl1271 *wl = hw->priv;
-           struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
+          rcu_read_lock();
+          struct ieee80211_sta *sta;
            bool do_join = false;
            bool set_assoc = false;
            int ret;

+          sta = ieee80211_find_sta(vif, bss_conf->bssid);
+          if (!sta) {
+                      rcu_read_unlock();
+                      return;
+          }

            wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+     	rcu_read_unlock();
            mutex_lock(&wl->mutex);

--

Is this a known bug that has already been encountered? I am using the compat wireless flavor of the mac80211 framework and driver so I don't really know if you can come across this issue with standard kernel.

Thanks,

John
