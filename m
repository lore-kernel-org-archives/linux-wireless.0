Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:42474 "EHLO
	mail.vsrv30783.customer.vlinux.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753466Ab3KKPEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 10:04:44 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [RFC v3 1/4] mac80211: don't transmit beacon with CSA count 0
Date: Mon, 11 Nov 2013 15:57:42 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311111557.42832.sw@simonwunderlich.de> (sfid-20131111_160447_529391_186473ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> A beacon should never have a Channel Switch Announcement information
> element with a count of 0, because a count of 1 means switch just
> before the next beacon.  So, if a count of 0 was valid in a beacon, it
> would have been transmitted in the next channel already, which is
> useless.  A CSA count equal to zero is only meaningful in action
> frames or probe_responses.
> 
> Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
> functions accordingly.

Just to make future bisecting easier, shouldn't this patch go after "only set 
CSA beacon when at least one beacon must be transmitted" in the series? 
Otherwise userspace may change the channel with count=0 and hit a warning 
here, because this is not supported anymore.

Apart from that, the series looks fine. I'd like to test the next v4 then.

I guess we still need to do the action frame part - for IBSS mode we already 
have code but we probably need to make sure that these packets go out before 
actually changing the channel. Do you plan to work on that?

Thanks for your work. :)
   Simon
