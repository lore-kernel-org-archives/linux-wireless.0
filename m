Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47107 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbbFQJ6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:58:36 -0400
Message-ID: <1434535105.1884.36.camel@sipsolutions.net> (sfid-20150617_115839_333159_F1849B5D)
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:58:25 +0200
In-Reply-To: <55814109.7030100@openwrt.org> (sfid-20150617_114251_641123_637D2FB2)
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
		<21889.11726.101648.552280@gargle.gargle.HOWL>
		<55812FB5.1070005@openwrt.org>
		<21889.14109.54454.563245@gargle.gargle.HOWL>
		<CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com>
	 <21889.16487.258289.588207@gargle.gargle.HOWL>
	 <55814109.7030100@openwrt.org> (sfid-20150617_114251_641123_637D2FB2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 11:42 +0200, Felix Fietkau wrote:
> On 2015-06-17 11:39, Sujith Manoharan wrote:
> > Janusz Dziedzic wrote:
> >> This is what I have with use_chanctx=1
> >> Jun 17 06:57:54 dell6430 kernel: [53297.753256] xxx ath_calcrxfilter
> >> filter: 0x207
> >> 
> >> 0x000000080 is for probe_req
> > 
> > Ok, so the probe_req filter is set before actually initiating
> > RoC - this appears to be the current design in wpa_s.
> > 
> > I am not sure if using a global filter that disregards
> > the opmode of a context is the right approach, though...
> The filter is intended to be global in the mac80211 API.
> Treating it as per channel-context inside the driver is a bug.

We have a patch somewhere in our pipeline (not ready/complete yet) that
will change it to be per interface. From there, you could derive per
channel context too if you wish.

johannes

