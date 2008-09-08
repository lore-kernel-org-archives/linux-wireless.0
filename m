Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61251 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIHS4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 14:56:52 -0400
Received: by gxk9 with SMTP id 9so8623496gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 11:56:51 -0700 (PDT)
Message-ID: <43e72e890809081156y5fa034e0vb1b5b6ce35698391@mail.gmail.com> (sfid-20080908_205657_141140_44502D79)
Date: Mon, 8 Sep 2008 11:56:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH 1/2 v4] cfg80211: Add new wireless regulatory infrastructure
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>, linville@tuxdriver.com
In-Reply-To: <200809080844.59098.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220636669-8153-1-git-send-email-lrodriguez@atheros.com>
	 <1220640389.11109.15.camel@johannes.berg>
	 <43e72e890809051211r3db3ca12m671c9ed9615b9e1b@mail.gmail.com>
	 <200809080844.59098.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 11:44 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> On Friday 05 September 2008 21:11:49 Luis R. Rodriguez wrote:
>> >> +struct ieee80211_freq_range {
>> >> +     u32 start_freq;
>> >> +     u32 end_freq;
>> >> +     u32 max_bandwidth;
>> >
>> > u32 seems excessive for the bandwidth, no?
>>
>> I think its fine, remember this is in KHz.
>
> max_bandwitth_khz ???

Seems reasonable here.

>> >>       u16 center_freq;
>> >> +     u8 max_bandwidth;
>> >
>> > and here you're using u8 anyway :)
>>
>> and this is in MHz
>
> max_bandwidth_mhz ???

I'm in favor but then center_freq_mhz should also be used, but lets
not go there and simply just add _khz for the freq_range.

  Luis
