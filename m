Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1HLMcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:32:33 -0400
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312998657.3128.45.camel@alex-2> (sfid-20110810_195131_446985_B9D37FE4)
References: <1888623.Vt5VZUN2cU@alex-1>  <8106144.ZkUl7u1lz4@alex-1>
	 (sfid-20110808_140459_252308_3B0F09A2)  <1312984428.4325.10.camel@jlt3.sipsolutions.net>
	 <1312991321.3128.34.camel@alex-2>
	 (sfid-20110810_174931_439213_A3C417AC)  <1312992332.4325.22.camel@jlt3.sipsolutions.net>
	 <1312998657.3128.45.camel@alex-2> (sfid-20110810_195131_446985_B9D37FE4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 14:32:31 +0200
Message-ID: <1313152351.4022.6.camel@jlt3.sipsolutions.net> (sfid-20110812_143236_411418_884F27A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 19:50 +0200, Alexander Simon wrote:

> The problem I'm facing here is that I really *need* to check the HT mode
> _inside_ the loop. Hence i need a _ht version.
> OR I could change cfg80211_get_bss only, causing to add the new
> parameters in *all* calls of cfg80211_get_bss... Whatever you prefer.

Well, I would keep the wrapper but make it an inline, not a separate
exported function, like cfg80211_get_ibss() (which really is quite
pointless, does anything still use it?)

johannes

