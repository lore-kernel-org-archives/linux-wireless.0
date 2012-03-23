Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2CWPGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 11:06:43 -0400
Message-ID: <1332515202.10384.42.camel@jlt3.sipsolutions.net> (sfid-20120323_160647_135213_C28D7F15)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 16:06:42 +0100
In-Reply-To: <1332514895.10384.40.camel@jlt3.sipsolutions.net> (sfid-20120323_160141_068030_63DCD1AC)
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
	 <4F6C82A5.5080302@tieto.com>
	 (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>
	 (sfid-20120323_160141_068030_63DCD1AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 16:01 +0100, Johannes Berg wrote:

> struct ieee80211_ops {
> 	...
> 	void (*add_channel_context)(hw, ctx),
> 	void (*remove_channel_context)(hw, ctx),
> 	void (*change_channel_type)(hw, ctx),
> 	void (*assign_vif_channel_context)(hw, vif, ctx),
> };

And then we come full circle back to the queue mappings of course --
when the channel context is assigned, the driver is able to change the
queue details in the vif to map to whatever it needs, if anything
different. Like I said in the other email, some devices may use queues
for each interface regardless of channel (e.g. wl12xx, from discussions
with them) while others (ath9k at least, I suspect) would use queues per
channel context. For iwlwifi, I'm not sure yet.

johannes

