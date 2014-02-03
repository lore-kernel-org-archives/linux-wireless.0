Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaBCNSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:18:42 -0500
Message-ID: <1391433519.4488.17.camel@jlt4.sipsolutions.net> (sfid-20140203_141844_583477_11C3103A)
Subject: Re: [RFC 1/2] mac80211: merge STA CSA code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 14:18:39 +0100
In-Reply-To: <1391421529-6067-2-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110353_085758_75CBE901)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110353_085758_75CBE901)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
> + *	Function (TSF) timer when the frame containing the channel switch
> + *	announcement was received. This is simply the rx.mactime parameter
> + *	the driver passed in.

That doesn't make a lot of sense, since "rx.mactime" is a mac80211
thing, so you should probably describe this. I'm not sure it really
needs to be mactime/TSF, does that even make sense? It seems more likely
you'd actually need the device time, i.e. something that works across
multiple vifs?

Not sure this even belongs into this patch anyway though?

johannes

