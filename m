Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52681 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaEZMFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 08:05:51 -0400
Received: by mail-qc0-f178.google.com with SMTP id l6so11845113qcy.23
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 05:05:51 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 May 2014 14:05:51 +0200
Message-ID: <CALhHN=qvsT0SFRnQUvt+XusOymVBh9NV2WRc9jx9xV5rqJkQ6g@mail.gmail.com> (sfid-20140526_140555_209050_516E1E21)
Subject: regulatory - issue after intersection
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This is scenario:

1) insmod cfg80211.ko
2) iw reg set FR
3) modprobe ath10k_pci (default US will be registered)
4) intersection here - is it as designed? Country "98"
5) after that no way to setup new country using iw reg set (lock),
always fail in such code:

__reg_process_hint_user(...)
        if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
             lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
             lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
             regdom_changes(lr->alpha2))
               return REG_REQ_IGNORE;

Last request still have "US" - shouldn't be "98" like we set in intersection?

Such patch setup same alpha2 for last request (also in case of we will
change this in intersection)
@Luis could you check this patch, I am not sure this is best fix for that?

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1219a07..df70db7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -271,6 +271,7 @@ static void reset_regdomains(bool full_reset,
                             const struct ieee80211_regdomain *new_regdom)
 {
        const struct ieee80211_regdomain *r;
+       struct regulatory_request *lr;

        ASSERT_RTNL();

@@ -284,6 +285,12 @@ static void reset_regdomains(bool full_reset,
        if (r == &world_regdom)
                r = NULL;

+       lr = get_last_request();
+       if (lr && new_regdom) {
+               lr->alpha2[0] = new_regdom->alpha2[0];
+               lr->alpha2[1] = new_regdom->alpha2[1];
+       }
+
        rcu_free_regdom(r);
        rcu_free_regdom(cfg80211_world_regdom);


BR
Janusz
