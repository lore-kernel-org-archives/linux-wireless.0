Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2K0MoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:44:03 -0500
Message-ID: <1354020270.9576.8.camel@jlt4.sipsolutions.net> (sfid-20121127_134407_527019_8113EED2)
Subject: Re: [PATCH 2/3] mac80211: support VHT association
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Nov 2012 13:44:30 +0100
In-Reply-To: <50B4AE29.3040600@posedge.com>
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
	 <1353939915-25121-3-git-send-email-johannes@sipsolutions.net>
	 <50B4AE29.3040600@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 17:42 +0530, Mahesh Palivela wrote:

> > +		vht_cap = (void *)(vht_cap_ie + 2);
> > +		tx_mcs_map = le16_to_cpu(vht_cap->supp_mcs.tx_mcs_map);
> 
> Guess we should take rx_mcs_map as we are determining vht_rx_chains?

No, when we determine our needed RX chains, we need to know what the AP
can transmit to us, not what the AP can receive.

johannes

