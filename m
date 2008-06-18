Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:40562 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbYFRV6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 17:58:55 -0400
Received: by wa-out-1112.google.com with SMTP id j37so334238waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 14:58:54 -0700 (PDT)
Message-ID: <1ba2fa240806181458u1b47474bkc5e3d74128588141@mail.gmail.com> (sfid-20080618_235911_988543_4EE8CF62)
Date: Thu, 19 Jun 2008 00:58:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213823853.1312.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
	 <1213803431.1312.24.camel@johannes.berg>
	 <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com>
	 <1213809824.1312.34.camel@johannes.berg>
	 <1ba2fa240806181411j15544134ga55607c394ff5db7@mail.gmail.com>
	 <1213823853.1312.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 12:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> Yes, this is handled by firmware, What is important is to make switch
>> on beacon edge.
>> Still our implementation uses also timer in mac rather then some mac
>> to driver over complicated synchronization.
>> Other thing is that the firmware enforce the switching, traffic on the
>> old channel is not allowed after the switch.
>
> Yeah, ok. As for enforcing the traffic, true as well. However, I'd like
> mac80211 to help out with this for those drivers that don't do it all in
> firmware (all others, I'd assume); it's not overly important that you
> switch instantly after receiving the switch beacon, if you take a bit
> longer to do that you'll just potentially miss a few packets. No big
> deal.

Sending few packets  on the old channel would be the spec violation
meaning it will fail the certification if you would
be interested in one.
Anyhow I hope that our patch takes care of the cases with not
supporting fimrware as well.
Thanks
Tomas
