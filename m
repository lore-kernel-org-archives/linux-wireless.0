Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64081 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab1JSMSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 08:18:54 -0400
Received: by qabj40 with SMTP id j40so1184479qab.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 05:18:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Oct 2011 14:18:53 +0200
Message-ID: <CAFED-jn-b914FHogzb+ad76XrYaXe+aY4_U1o_Qd2mo6bx4Cog@mail.gmail.com> (sfid-20111019_141858_071819_AAEA490F)
Subject: mac80211: ROC timeout and back to oper channel when associated
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am doing such test with wpa_supplicant:
1) p2p_connect to GO (GO oper channel different than our listen
channel) - connected state
2) p2p_find
3) p2p_stop_find (we left on listen channel and didn't back oper channel).

Seems in case we have empty work queue in mac80211 we will not back to
oper channel (we are connected with GO).
In case after step 3 I will trigger some action,  eg. scan we will
back to oper channel correctly.

My driver don't have HW_ROC callbacks.

I don't know ieee80211_work_work() code well and all flags we have
inside, so probably this patch don't cover all cases but generally
works.
Could you help with fix for that problem?

--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1089,6 +1089,8 @@ static void ieee80211_work_work(struct work_struct *work)
                        list_del_rcu(&wk->list);
                        synchronize_rcu();
                        list_add(&wk->list, &free_work);
+                       if (!ieee80211_cfg_on_oper_channel(local))
+                               ieee80211_hw_config(local, 0);
                        break;
                default:


BR
Janusz
