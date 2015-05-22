Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38391 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbbEVI5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:57:44 -0400
Received: by wichy4 with SMTP id hy4so40040818wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 01:57:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] mac80211: guard against invalid ptr deref
Date: Fri, 22 May 2015 10:57:23 +0200
Message-Id: <1432285043-8878-2-git-send-email-michal.kazior@tieto.com> (sfid-20150522_105750_719653_542BE0F3)
In-Reply-To: <1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
 <1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible for mac80211 to be coerced into an
unexpected flow causing sdata union to become
corrupted. Station pointer was put into
sdata->u.vlan.sta memory location while it was
really master AP's sdata->u.ap.next_beacon. This
led to station entry being later freed as
next_beacon before __sta_info_flush() in
ieee80211_stop_ap() and a subsequent invalid
pointer dereference crash.

The problem was that ieee80211_ptr->use_4addr
wasn't cleared on interface type changes.

This could be reproduced with the following steps:

 # host A and host B have just booted; no
 # wpa_s/hostapd running; all vifs are down
 host A> iw wlan0 set type station
 host A> iw wlan0 set 4addr on
 host A> printf 'interface=wlan0\nssid=4addrcrash\nchannel=1\nwds_sta=1' > /tmp/hconf
 host A> hostapd -B /tmp/conf
 host B> iw wlan0 set 4addr on
 host B> ifconfig wlan0 up
 host B> iw wlan0 connect -w hostAssid
 host A> pkill hostapd
 # host A crashed:

 [  127.928192] BUG: unable to handle kernel NULL pointer dereference at 00000000000006c8
 [  127.929014] IP: [<ffffffff816f4f32>] __sta_info_flush+0xac/0x158
 ...
 [  127.934578]  [<ffffffff8170789e>] ieee80211_stop_ap+0x139/0x26c
 [  127.934578]  [<ffffffff8100498f>] ? dump_trace+0x279/0x28a
 [  127.934578]  [<ffffffff816dc661>] __cfg80211_stop_ap+0x84/0x191
 [  127.934578]  [<ffffffff816dc7ad>] cfg80211_stop_ap+0x3f/0x58
 [  127.934578]  [<ffffffff816c5ad6>] nl80211_stop_ap+0x1b/0x1d
 [  127.934578]  [<ffffffff815e53f8>] genl_family_rcv_msg+0x259/0x2b5

Even though this can and should be fixed in
cfg80211 it still makes sense to add a sanity
check to mac80211 to prevent future problems.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * improve commit log [Johannes]

 net/mac80211/cfg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb9f83640b46..d1f8d615701c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1395,6 +1395,12 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (params->vlan->ieee80211_ptr->use_4addr) {
+			if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN) {
+				WARN_ON(1);
+				err = -EINVAL;
+				goto out_err;
+			}
+
 			if (vlansdata->u.vlan.sta) {
 				err = -EBUSY;
 				goto out_err;
-- 
2.1.4

