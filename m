Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:40611 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab1AaL2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:28:53 -0500
Date: Mon, 31 Jan 2011 13:28:41 +0200
From: Jouni Malinen <j@w1.fi>
To: Pat Erley <pat-lkml@erley.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why is wmm_param required for HT40- in mlme.c
Message-ID: <20110131112841.GA2628@jm.kir.nu>
References: <4D44F94F.8040707@candelatech.com>
 <1296380208.3616.0.camel@jlt3.sipsolutions.net>
 <4D45A2B1.5050006@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D45A2B1.5050006@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 12:41:05PM -0500, Pat Erley wrote:
> Having run into this same issue before, I considered adding some
> default values for the case that wmm is not configured, but someone
> tries to enable 802.11n, I just never decided where the best spot
> for that would be.  Should this sort of thing be a hostapd default
> or somewhere in the cfg80211/mac80211 layer?  I was thinking this
> should be something that hostapd does.
> 
> As I see it, there are a few ways to prevent this problem:
> 
> 1. Hostapd doesn't allow 802.11n to be enabled without wmm

I don't think that that would ever happen since as far as I can tell,
WMM is not required from 802.11n based on any standard or specification.
(Sure, there may be some non-IEEE certifications that require it, but
hostapd is not limited by such requirements; it just needs to allow one
to implement a device to meet such needs.)

> 2. Hostapd does allow 802.11n to be enabled without wmm, but uses
>    defaults

What do you mean with "defaults" here?

> 3. Hostapd doesn't care about this, and the kernel doesn't allow
>    802.11n without wmm

My comment on (1) would apply here.

> 4. Hostapd doesn't care, but the kernel makes the correnctions

I don't think that that would be a good idea either and well, not really
at all suitable for the current design of where the HT/WMM IEs come from
for management frames in AP mode.

> I believe 2 is the cleanest solution.  So that the packets passed
> from hostapd can make it through unmolested, and new hostapd versions
> can work with older kernels.  Any other solution I'm not thinking of?

I do not fully understand what (2) is, but it may be close enough to
what I think would be a reasonable approach:
- for non-AP STA case, allows association with HT even if WMM (or IEEE
  802.11 QoS) is not enabled (mac80211 change)
- for AP case, make hostapd default to enabling WMM with default EDCA
  parameters if HT is enabled and there is no explicit configuration
  for disabling WMM
- if WMM is explicitly disabled in hostapd.conf, allow IEEE 802.11n
  to be enabled without WMM/QoS

The main focus here is to make it less likely for users to end up
configuring something they did not plan on doing while not removing
flexibility in configuration. I don't know any particularly good reasons
for disabling WMM/QoS/aggregation, but that is not good enough
justification to make it impossible to do so.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
