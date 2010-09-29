Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34860 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0I2Fss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 01:48:48 -0400
Date: Tue, 28 Sep 2010 22:48:41 -0700
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
Message-ID: <20100929054841.GB8382@jm.kir.nu>
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
 <1285632457-27539-2-git-send-email-greearb@candelatech.com>
 <1285658564.3885.1.camel@jlt3.sipsolutions.net>
 <4CA1F2A4.2090005@candelatech.com>
 <1285682224.3885.18.camel@jlt3.sipsolutions.net>
 <4CA206F0.40607@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CA206F0.40607@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 08:17:04AM -0700, Ben Greear wrote:
> On 09/28/2010 06:57 AM, Johannes Berg wrote:
> >You can run all networks in a single wpa_s instance, I believe, and then
> >it'd know about all this, right?
> 
> But then, if you want to add an additional interface, you have to restart
> everything.

We would you restart everything? You can add/remove interface
dynamically..

> I was thinking that maybe I could keep the logic in wpa_s, but instead of
> all the special casing, just locate the current associated channel for the
> phy in question and populate the scan-req with that single channel.

wpa_supplicant already stores the operating channel: wpa_s->assoc_freq.
You can iterate over the configured interfaces and fetch the current
operating channel(s) using that without adding anything new to the
kernel. With that, you could make some wpa_supplicant scans (e.g.,
bgscan or scan for new networks if only a single network block is
enabled) restrict the list of channels to scan. Still, some other scan
requests (e.g., user initiated full scan or P2P Search) would need to be
able to specify more channels even if one of the interfaces is
associated.

I would like to get rid of the one-channel-per-phy restriction, so I
don't think I would like to see new code added for that.

-- 
Jouni Malinen                                            PGP id EFC895FA
