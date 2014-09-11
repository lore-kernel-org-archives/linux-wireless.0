Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59275 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751266AbaIKGtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 02:49:49 -0400
Message-ID: <1410418181.14130.7.camel@dubbel> (sfid-20140911_084952_628049_03C07E64)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes@sipsolutions.net>
Date: Thu, 11 Sep 2014 09:49:41 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: CSA broken with !use_chanctx drivers?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

Johannes and I were checking the channel switch code (namely to see if
implementing the drv_channel_switch op was fine in our case) and we saw
that CSA with non-chanctx drivers seems to be broken.

In commit 4c3ebc56 (mac80211: use chanctx reservation for STA CSA) we
lost this piece of code:

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eccc849..931330b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -940,52 +940,70 @@ static void ieee80211_chswitch_work(struct work_struct *work)
[...] 
-       if (!local->use_chanctx) {
-               local->_oper_chandef = sdata->csa_chandef;
-               /* Call "hw_config" only if doing sw channel switch.
-                * Otherwise update the channel directly
-                */
-               if (!local->ops->channel_switch)
-                       ieee80211_hw_config(local, 0);
-               else
-                       local->hw.conf.chandef = local->_oper_chandef;
-       }
-

It seems that we're not updating the chandef in non-chanctx drivers.  Or
are we missing something?

--
Cheers,
Luca.

