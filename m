Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45592 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbbBFTfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 14:35:16 -0500
Message-ID: <1423251313.2037.30.camel@sipsolutions.net> (sfid-20150206_203520_496596_67248C6E)
Subject: Re: [PATCH] cfg80211: PBSS basic support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	'Vladimir Kondratiev' <qca_vkondrat@qca.qualcomm.com>
Date: Fri, 06 Feb 2015 20:35:13 +0100
In-Reply-To: <002801d03a40$55b81630$01284290$@codeaurora.org>
References: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org>
		 <1422347067.1890.49.camel@sipsolutions.net>
		 <002501d03a1f$024d1e30$06e75a90$@codeaurora.org>
	 <1422356461.1890.64.camel@sipsolutions.net>
	 <002801d03a40$55b81630$01284290$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry about the delay.

> > > wdev->bss_type refers to the BSS that we are connecting/connected to (Maybe rename to "conn_bss_type"?).
> > > This member is used in sme.c. It was introduced because once the connect is complete and driver calls cfg80211_connect_result(), cfg needs to find the BSS being connected to.
> > 
> > Ok I was thinking you were adding it to struct cfg80211_bss. Wouldn't that make a bit more sense? Of course it can also be derived from cfg80211_bss::channel and cfg80211_bss::capability, your call.
> > 
> > However, it doesn't seem that you need it in wdev if you have it there inside wdev->current_bss?
> 
> current_bss is set later.
> 
> inside __cfg80211_connect_result(), we look for the BSS being connected to:
>   bss = cfg80211_get_bss(..., bssid, wdev->bss_type, ...)
> only after that, current_bss is set to this BSS:
>   wdev->current_bss = bss_from_pub(bss);

Ok.

johannes

