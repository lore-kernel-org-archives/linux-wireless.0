Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35480 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966508AbcCPOWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 10:22:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1agCLU-0003qi-J2
	for linux-wireless@vger.kernel.org; Wed, 16 Mar 2016 15:22:45 +0100
Received: from nsg-static-020.220.71.182.airtel.in ([nsg-static-020.220.71.182.airtel.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 15:22:44 +0100
Received: from neelansh by nsg-static-020.220.71.182.airtel.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 15:22:44 +0100
To: linux-wireless@vger.kernel.org
From: Neelansh <neelansh@gmail.com>
Subject: Why does =?utf-8?b?aWVlZTgwMjExX3J4KCk=?= requires the bottom halves to be disbaled?
Date: Wed, 16 Mar 2016 14:22:30 +0000 (UTC)
Message-ID: <loom.20160316T151540-162@post.gmane.org> (sfid-20160316_152253_347238_0D091AF6)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3823 static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
3824                                    struct sk_buff *skb)
3825 {
3826         local_bh_disable();
3827         ieee80211_rx(hw, skb);
3828         local_bh_enable();
3829 }

Why bottom halves on the local processor need to disabled, when 
ieee80211_rx is called. What is synchronization issue here?

