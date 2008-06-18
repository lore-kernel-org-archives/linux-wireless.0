Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:22915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYFRVLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 17:11:05 -0400
Received: by wa-out-1112.google.com with SMTP id j37so322386waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 14:11:04 -0700 (PDT)
Message-ID: <1ba2fa240806181411j15544134ga55607c394ff5db7@mail.gmail.com> (sfid-20080618_231139_076959_07E86A07)
Date: Thu, 19 Jun 2008 00:11:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213809824.1312.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
	 <1213803431.1312.24.camel@johannes.berg>
	 <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com>
	 <1213809824.1312.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 18, 2008 at 8:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> We need driver support mainly for quiet period and channel
>> switch.(patches will follow)
>> Not sure how the precise timing  will be handled in mac80211. So we
>> don't advertise spectrum capability to AP if we cannot handle 11h
>> actions.
>
> Channel switch is interesting. Do you actually handle that in firmware?
> Most drivers don't.

Yes, this is handled by firmware, What is important is to make switch
on beacon edge.
Still our implementation uses also timer in mac rather then some mac
to driver over complicated
synchronization.
Other thing is that the firmware enforce the switching, traffic on the
old channel is not allowed after the switch.

>
> Also, does your firmware implement full radar detection? Broadcom and
> Atheros hardware seem to only pass information about pulse edges up to
> the driver (in different ways, obviously) and pulse/radar detection
> needs to be done in software, I'd like that to be somehow shareable.
>
iwl drivers were designed for laptop marked mostly unlike like other
vendors that plays in AP market so the radar awareness is in slave
mode. I think the hw actually support radar detection but I'm not sure
it was ever employed in a product.

Tomas
