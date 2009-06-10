Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f186.google.com ([209.85.221.186]:61504 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFJWm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 18:42:58 -0400
Received: by qyk16 with SMTP id 16so478863qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 15:43:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244668077.4706.4.camel@johannes.local>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	<1244666973.20900.399.camel@rc-desk> <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	<1244667817.20900.402.camel@rc-desk> <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
	<1244668077.4706.4.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Jun 2009 15:42:40 -0700
Message-ID: <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching bands
	and not scanning
To: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 2:07 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-06-10 at 14:04 -0700, Luis R. Rodriguez wrote:
>> On Wed, Jun 10, 2009 at 2:03 PM, reinette
>> chatre<reinette.chatre@intel.com> wrote:
>>
>> >> > This touches code targeted for removal in recent "mac80211: disconnect
>> >> > when user changes channel" patch.
>> >>
>> >> Heh I don't see that patch yet but if it exists that should fix this
>> >> too unless that patch didn't deauth/disassoc. Did you try with it
>> >> applied by any chance? I can't seem to find that patch on the list.
>> >
>> > That patch does seem to have same intention as yours. It is still RFC so
>> > I am not sure about its status. I did not test with it, but will do so.
>> > The patch can be found at
>> > http://marc.info/?l=linux-wireless&m=124458448631186&w=2
>>
>> Thanks yes, I see, yup I think that should fix it, we need a fix for
>> stable though. Not sure how John or Johannes want to handle this.
>
> *scratches head*
> are you advocating those rate cleanups for stable?

No, a few fixes are needed for stable (now 2.6.30) though. For example
the assert downgrade patch can be used but most likely that'll just be
doing something completely wrong, so we do need to ensure the dynamic
ps stuff does not trigger when scanning and I do consider that a
proper fix for stable. I forget when ps stuff when in.

The issue here is this *is* a bug not only for iwlwifi. iwlwifi
currently gets no warning because of a work around in the driver's
rate control algorithm as it is in stable. I haven't tried running
this band change with ath9k but I might bet here that we'll hit the
same assert, in that case (which is very likely) we'll need a proper
respective fix for stable for this issue as not all drivers have a
rate control algorithm work around for this condition.

 Luis
