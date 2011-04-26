Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46431 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1DZTgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:36:10 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so787546iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 12:36:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110426191247.GJ2804@tuxdriver.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
 <1303129610.3588.7.camel@jlt3.sipsolutions.net> <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
 <1303216566.3603.6.camel@jlt3.sipsolutions.net> <BANLkTik81g3NOwHcQk2eqOcMjaubCLdk+w@mail.gmail.com>
 <1303286933.3619.0.camel@jlt3.sipsolutions.net> <20110426191247.GJ2804@tuxdriver.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 26 Apr 2011 22:35:55 +0300
Message-ID: <BANLkTi=4eoqJrjfWdoTV0cwVDq0ahsV2Tg@mail.gmail.com> (sfid-20110426_213614_458738_17669453)
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet loss
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 22:12, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Apr 20, 2011 at 10:08:53AM +0200, Johannes Berg wrote:
>> On Wed, 2011-04-20 at 00:54 +0300, Arik Nemtsov wrote:
>>
>> > > That's your choice, but I wouldn't do it. You'll have to support TX
>> > > status when requested, otherwise AP operation won't work, so you need
>> > > the code anyway.
>> >
>> > Can you elaborate why?
>> >
>> > I'm assuming you mean the removal of
>> > IEEE80211_HW_REPORTS_TX_ACK_STATUS (in the second patch of this
>> > series). Note that it was only added recently, and AP/STA modes seemed
>> > to work fine without it.
>> > From a look in the code it seems this flag helps with connection
>> > monitoring in STA mode. The other use is determining the current PS
>> > mode when IEEE80211_HW_PS_NULLFUNC_STACK is enabled. These two are
>> > done by HW in wl12xx cards.
>>
>> Well, there's the flag saying "you can rely on it", but there's also the
>> fact that AP mode relies on status for (some) frames anyway. So if you
>> just want to remove the flag I guess that's OK, but if you want to
>> remove all status processing .. that'll cause issues with AP mode.
>
> Do the wl12xx guys still want this?
>

Yes definitely.

The above is a discussion about providing reliable TX status to
certain packets. It's not really related.
But Johannes has a point here and it was noted.

Regards,
Arik
