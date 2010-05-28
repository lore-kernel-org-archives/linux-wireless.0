Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:56409 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab0E1UPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 16:15:06 -0400
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: paged RX skbs and BlockAck Request packets
Date: Fri, 28 May 2010 12:46:27 -0700
Message-Id: <7994C719-E1C8-4818-A03E-0566E8380CC3@cs.washington.edu>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the latest iwlwifi-2.6.git from http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git

When using 802.11n aggregation and the other endpoint sends a BlockAck Request, many times the transfer will completely stall.

It looks like the relevant code is in net/mac80211/rx.c:ieee80211_rx_h_ctrl . I found that the sequence numbers used are invalid. If instead I linearize the SKB, then the sequence numbers become valid, so I believe it's a problem with the use of paged RX skbs. Mailing both lists since I'm not sure where the fix should go.

The paged RX SKBs are set up in drivers/net/wireless/iwlwifi:iwl-agn-lib.c:iwl_pass_packet_to_mac80211. I made a temporary fix at net/mac80211/rx.c:__ieee80211_rx_handle_packet

by changing 

        if (ieee80211_is_mgmt(fc))
                err = skb_linearize(skb);

to

        if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc))
                err = skb_linearize(skb);

Can anyone more knowledgeable than I please tell me the right fix?

Thanks!
-Dan