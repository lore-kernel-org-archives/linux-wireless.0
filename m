Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2HBPhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 11:37:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwxSc-0004jJ-J4
	for linux-wireless@vger.kernel.org; Thu, 02 Aug 2012 17:37:14 +0200
Message-ID: <1343921832.4471.14.camel@jlt3.sipsolutions.net> (sfid-20120802_173721_885221_C9412F4B)
Subject: mac80211-next preview
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 17:37:12 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's a preview (in form of the shortlog) of what's to come for 3.7 in
my tree right now:
 * I picked up the wlcore fixes, to be able to pick up
 * Thomas's patch to change the TX API
 * VHT association support from Mahesh
 * an improvement for PS in multi-vif scenarios from Eliad
 * a few cleanups/improvements/small fixes overall
 * my preparation work for multi-channel, using the correct channel
   pointer throughout mac80211

All of this is in the mac80211-next/master branch right now.

johannes



Arik Nemtsov (2):
      wlcore: don't get the hlid from a queued skb
      wlcore: op_tx: pass sta explicitly when inferring frame hlid

Chun-Yeow Yeoh (1):
      mac80211: don't re-init rate control when receiving mesh beacon

Eliad Peller (1):
      mac80211: add PS flag to bss_conf

Emmanuel Grumbach (1):
      mac80211: don't call mgd_prepare_tx when associated

Johannes Berg (14):
      mac80211: don't react to beacon loss if HW monitoring
      mac80211: supress HT/VHT disable if not supported
      mac80211: rename sta to new_sta
      mac80211: set channel only once during auth/assoc
      mac80211: use oper_channel in mesh
      mac80211: use oper_channel in ibss
      mac80211: use oper_channel in managed mlme
      mac80211: use oper_channel in utils and config
      mac80211: fix current vs. operating channel in preq/beacon
      mac80211: use correct channel in TX
      mac80211: manage carrier state in mesh
      mac80211: enable WDS carrier only after adding station
      mac80211: use eth_broadcast_addr
      mac80211: reset station MLME flags upon new association

Mahesh Palivela (1):
      mac80211: VHT (11ac) association

Thomas Huehn (1):
      mac80211: move TX station pointer and restructure TX

Vladimir Kondratiev (1):
      cfg80211: unify IE search


