Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36221 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaC1Nmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:42:49 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so769868wiv.9
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396012968.4175.28.camel@jlt4.sipsolutions.net>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-2-git-send-email-michal.kazior@tieto.com>
	<1396011945.4175.23.camel@jlt4.sipsolutions.net>
	<CA+BoTQnpijm3JxXNaCzSf3bDx6OiPDAhseTj7=0Urv4jWav=Wg@mail.gmail.com>
	<1396012968.4175.28.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Mar 2014 14:42:47 +0100
Message-ID: <CA+BoTQngPM4RvG6OxrLrzoVj1vu6+jwvZr5BaWhdxy0NPWrOxA@mail.gmail.com> (sfid-20140328_144254_219323_FC46092B)
Subject: Re: [PATCH v2 01/13] cfg80211: allow drivers to iterate over matching combinations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2014 14:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-28 at 14:21 +0100, Michal Kazior wrote:
>
>> >> +int cfg80211_iter_combinations(struct wiphy *wiphy,
>> >> +                            const int num_different_channels,
>> >> +                            const u8 radar_detect,
>> >> +                            const int iftype_num[NUM_NL80211_IFTYPES],
>> >> +                            void (*iter)(const struct ieee80211_iface_combination *c,
>> >> +                                         void *data),
>> >> +                            void *data);
>> >
>> > Maybe *iter should have a non-void return value and allow aborting the
>> > loop somehow?
>>
>> I don't see much of use for that. You can still use *data for that.
>
> No, I meant to abort the iteration loop, say when the function returns
> true (or false, whichever way you want to look at it). That way you can
> stop iteration at the first combination that's sufficient.

I know. It's just that it bothers me - if you use true/false you end
up with "do I use true for continue or break" (and need to put
comments in the code) and having an enum for such a trivial thing
seems silly too. On the other hand using *data to guard *iter is also
silly.

So yeah.


Michał
