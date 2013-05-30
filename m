Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49308 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072Ab3E3Qrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 12:47:31 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so442650wgh.30
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 09:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369470049.9074.2.camel@jlt4.sipsolutions.net>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
 <1368233453-10581-3-git-send-email-ashok@cozybit.com> <1369432740.13623.12.camel@johannes>
 <CACcxo+pWnCFW3wvdjhHZvhb065Trup1KL=8fj7bbBhC5m4evqQ@mail.gmail.com> <1369470049.9074.2.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 30 May 2013 09:47:10 -0700
Message-ID: <CACcxo+qncV+jqi_yxeJTkkhEH4K01epDNy6ZvUxi-Uh-o549PA@mail.gmail.com> (sfid-20130530_184735_473011_D239E33C)
Subject: Re: [PATCH 3/3] {nl,mac,cfg}80211: Allow user to configure basic
 rates for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 25, 2013 at 1:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > I think you should consider allowing this attribute only if the channel
>> > is also specified (NL80211_ATTR_WIPHY_FREQ, parsed below), and not make
>> > it nested with rates for both bands but just the selected band.
>> >
>> Yes, I think by this approach, we eliminate the need for the user to
>> provide rates for both bands and also not require to have a per-band
>> for basic_rates.
>>
>> Said that, I am wondering why give mcast_rate for both bands, but
>> basic_rates only for one band?
>
> Heh, good question. I think it was probably copied from IBSS where you
> can pick another channel? Doesn't make all that much sense for mesh I
> guess, unless MBSS channel switch could cause us to use another channel?
> But then presumably you should follow the basic rates from the STA
> initiating the switch, or something, since mesh networks are only
> compatible with the same basic rates, right?
>

Yes, that is right. I will come up with a patch now for basic_rates
configuration as per your suggestion.

Thanks,
Ashok
> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
