Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:14285 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752996Ab0LGCXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:23:23 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0388498597
	for <linux-wireless@vger.kernel.org>; Tue,  7 Dec 2010 11:23:21 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: build error without  CONFIG_MAC80211_MESH
Date: Tue, 7 Dec 2010 11:23:03 +0900
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201012071123.03046.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Building current wireless-testing (master-2010-12-06) without the Mesh option 
is broken:

  CC [M]  net/mac80211/main.o
/home/br1/ath/wireless-testing/net/mac80211/main.c: In function 
‘ieee80211_bss_info_change_notify’:
/home/br1/ath/wireless-testing/net/mac80211/main.c:250: error: ‘union 
<anonymous>’ has no member named ‘mesh’
make[3]: *** [net/mac80211/main.o] Error 1
make[2]: *** [net/mac80211] Error 2
make[1]: *** [net] Error 2
make: *** [sub-make] Error 2

It needs something like:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 40bd12e..3d988ca 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -245,10 +245,12 @@ void ieee80211_bss_info_change_notify(struct 
ieee80211_sub_if_data *sdata,
                                sdata->vif.bss_conf.enable_beacon =
                                        !!sdata->u.ibss.presp;
                                break;
+#ifdef CONFIG_MAC80211_MESH
                        case NL80211_IFTYPE_MESH_POINT:
                                sdata->vif.bss_conf.enable_beacon =
                                        !!sdata->u.mesh.mesh_id_len;
                                break;
+#endif
                        default:
                                /* not reached */
                                WARN_ON(1);

bruno
