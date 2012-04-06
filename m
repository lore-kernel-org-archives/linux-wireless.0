Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43367 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2DFKj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 06:39:57 -0400
Received: by qafi31 with SMTP id i31so467182qaf.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 03:39:57 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 6 Apr 2012 12:39:57 +0200
Message-ID: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com> (sfid-20120406_124001_086979_8243923B)
Subject: carl9170: not able to add P2P_GO - add_interface fail with -EBUSY
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, chunkeey@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

With latest compat, wpa_supplicant seems p2p_concurent is set for
car9170 driver based on information from driver.
So, next after p2p_group_add new virtual interface is created for that
- p2p-wlan0-0.

Next, carl9170_op_add_interface() return -EBUSY because there is
already main_vif (NL80211_IFTYPE_STATION) created by default on
startup.
Because of that p2p_group_add() always fail with such chipset and
p2p_concurent=1.

STEPS:
- run wpa_supplicant
- run wpa_cli
- p2p_group_add
FAIL

Is that chipset limitation we could add only new STA interface when
main_vif is also STA?
Where could I find HW documentation for carl9170?



I suspect lower change is not acceptable because of HW limitation?

        main_vif = carl9170_get_main_vif(ar);

        if (main_vif) {
                switch (main_vif->type) {
                case NL80211_IFTYPE_STATION:
-                       if (vif->type == NL80211_IFTYPE_STATION)
+                       if ((vif->type == NL80211_IFTYPE_STATION) ||
+                           (vif->type == NL80211_IFTYPE_AP))
                                break;



BR
Janusz
