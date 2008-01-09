Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:23727 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYAINDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 08:03:51 -0500
Received: by fg-out-1718.google.com with SMTP id e21so256800fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 05:03:50 -0800 (PST)
Message-ID: <247d6d340801090503k289902afwd9fc22dbb4a1e70b@mail.gmail.com> (sfid-20080109_130356_099072_06D29AAF)
Date: Wed, 9 Jan 2008 15:03:49 +0200
From: "Guy Cohen" <guy.cohen@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: WMM QoS classification with local bridging (bridge_packets=1)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running in AP mode with 4956 and I see that frames transmitted
from one client through the AP to a second client will not have the
correct TID set in the QoS header after being forwarded from the AP.

At the end of ieee80211_deliver_skb there is this code that redirects
rx frames sent to local stations back to the wireless driver:

	if (xmit_skb) {
		/* send to wireless media */
		xmit_skb->protocol = __constant_htons(ETH_P_802_3);
		skb_reset_network_header(xmit_skb);
		skb_reset_mac_header(xmit_skb);
		dev_queue_xmit(xmit_skb);
	}

Then in classify_1d:

	if (skb->protocol != __constant_htons(ETH_P_IP) ||
	    skb->len < offset + sizeof(*ip))
		return 0;

The thing is that the protocol is set to ETH_P_802_3 and not IP...

What do you think is the right way to fix this? Parse the frame in
deliver_skb and set the protocol to be IP (when IP frame), or leave
that as is and in classify_1d parse the frame instead of testing the
protocol field?

I'm running with a slightly older version of mac, but I think it is
the same behavior in wireless-dev 2.6 latest sources.

Thanks,
Guy.
