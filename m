Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57018 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761309AbXHOPvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:51:14 -0400
Subject: Re: [PATCHv2] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1187142421.31200.55.camel@johannes.berg>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
	 <1187142421.31200.55.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 11:51:13 -0400
Message-Id: <1187193073.6462.29.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-15 at 03:47 +0200, Johannes Berg wrote:
>      When a key-mapping key for an address pair is
>      present, the WEP Key ID subfield in the MPDU shall
>      be set to 0 on transmit and ignored on receive.

I'm pretty sure this is from the TKIP part. There, the unicast key index
is indeed always 0. However, for WEP (and WEP only) this is not
regulated.
 
> > I see some similar (wrong) assumptions about keyidx==0 being the
> > unicast key in ieee80211_rx_michael_mic_report. [...]
> In fact, that isn't wrong.

Yes, I was wrong here: Because Michael MIC only matters for TKIP it is
safe to assume that keyidx==0.

As for the ieee80211_rx_h_load_key, that doesn't exist in intel's
mac80211-9.0.4. I'll try wireless-dev again, but iwl4965 tends to hang
my computer a lot with other versions of mac80211.


