Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:56239 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbbLJJlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 04:41:31 -0500
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out06.msg.oleane.net with ESMTP id tBA9fThB001128
	for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2015 10:41:29 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id tBA9LJvr010200
	for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2015 10:21:19 +0100
Subject: Mac80211 driver crash in monitor mode
Date: Thu, 10 Dec 2015 10:21:19 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <773DB8A82AB6A046AE0195C68612A31901C5B2F9@sbs2003.acksys.local> (sfid-20151210_104136_918063_D0BC614D)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi, 

I'm using mac80211/ATH9K driver in monitor mode to inject some packets.

With the latest driver version my packet injector software generated a
kernel panic.

The reason of this crash is:
In mac80211/tx.c, function __ieee80211_tx:

	case NL80211_IFTYPE_MONITOR:
		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) {
			vif = &sdata->vif;
			break;
		}
		sdata = rcu_dereference(local->monitor_sdata);
		if (sdata) {
			vif = &sdata->vif;
			info->hw_queue =
	
vif->hw_queue[skb_get_queue_mapping(skb)];
		} else if (ieee80211_hw_check(&local->hw,
QUEUE_CONTROL)) {
			ieee80211_purge_tx_queue(&local->hw, skbs);
			return true;
		} else
			vif = NULL;
		break; 

If I don't enable the MONITOR_FLAG_ACTIVE I'm going to the line vif =
null, this function will continue and will call ieee80211_tx_frags and
this function will call ieee80211_drv_tx.

In ieee80211_drv_tx function:
 
	if (pubsta) {
		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;

		txq = pubsta->txq[tid];
	} else if (vif) {
		txq = vif->txq;
	} 

In my case pubsta == null so I'm going to else statement. The line
vif->txq generate kernel pannic because the VIF pointer have been
initialized to null in __ieee80211_tx function.

Do you have any suggestion to fix this crash?

Cedric Voncken.
