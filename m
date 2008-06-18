Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:29087 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYFRQR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 12:17:57 -0400
Received: by wa-out-1112.google.com with SMTP id j37so246175waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 09:17:56 -0700 (PDT)
Message-ID: <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com> (sfid-20080618_181803_690513_0CBD46C0)
Date: Wed, 18 Jun 2008 19:17:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213803431.1312.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
	 <1213803431.1312.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 18, 2008 at 6:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-06-18 at 17:53 +0300, Tomas Winkler wrote:
>> This patch add spectrum capability and required information
>> elements to association request providing AP has requested it and
>> it is supported by the driver
>
> Why bother splitting this up into two patches, the Kconfig option isn't
> even being used?

It will be.

>> +             if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
>> +                 (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
>> +                     capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
>
> Why do we need a hardware capability flag for this? The only thing you
> seem to be doing with it is determine whether to send the power
> capability IE?


> Will you follow up with more patches to enable radar detection and
> things like that, and shouldn't we merge that as one series? This looks
> sane enough, but it seems hard to judge whether or not it's actually the
> best way to do things.
>
> What else will depend on the hw capability flag?
>

We need driver support mainly for quiet period and channel
switch.(patches will follow)
Not sure how the precise timing  will be handled in mac80211. So we
don't advertise spectrum capability to AP if we cannot handle 11h
actions.

Don't mind that this will be applied as series. Just sending this out
to get some feedback on the way maybe I should mark them as RFCs

Thanks for review
Tomas
