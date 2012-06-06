Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:59639 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2FFLk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:40:28 -0400
Message-ID: <4FCF41AA.9070400@tieto.com> (sfid-20120606_134031_534134_32F32F15)
Date: Wed, 6 Jun 2012 13:40:26 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>, Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC 07/14] cfg80211: track monitor interfaces count
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>  <1338203942-5667-8-git-send-email-michal.kazior@tieto.com> <1338973824.4513.42.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338973824.4513.42.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The other thing we might then want to is make this more general and not
> just inform the driver about the monitor/no-monitor layout change, but
> also tell it which interface combination we're in right now? Might look
> a bit more like
>
> set_iface_combination(wiphy, dev, combination);
>
> or even
> set_iface_combination(wiphy, dev, combination, have_monitor);
>
>
> Then pure monitor would be "combination == NULL, have_monitor=True",
> etc. The only downside is that we don't have combinations advertised for
> when there's a single interface only, so we'd have to point to some
> internal single-interface combinations then (static in cfg80211).
> Thoughts?

I'm afraid we can't simply tell which combination we're in. I imagine 
there may be two or three combinations matching at the same time. Take 
this for example:

   comb1: 1xSTA + 1xAP (max channels = 1)
   comb2: 2xSTA (max channels = 2)

   wlan0 is running as STA @ chan=1

Which combination are we in? Which one should we report to the driver?

I don't see what passing current interface combination would be useful 
for. Do you have something particular in mind?


-- 
Pozdrawiam / Best regards, Michal Kazior.
