Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:35919 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808AbYJ3Rnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:43:43 -0400
Received: by yw-out-2324.google.com with SMTP id 9so297644ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 10:43:41 -0700 (PDT)
Message-ID: <43e72e890810301043g17c2867cn8023c9a170bd5487@mail.gmail.com> (sfid-20081030_184408_208311_9D183EF5)
Date: Thu, 30 Oct 2008 10:43:41 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/6] cfg80211: enable 5 GHz band for world regulatory domain
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225387137.3690.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-3-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-4-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-5-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-6-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-7-git-send-email-lrodriguez@atheros.com>
	 <53ad401862d734b26836f0706a394525.squirrel@secure.sipsolutions.net>
	 <43e72e890810300909if0e2db1qf5ff8512ab760275@mail.gmail.com>
	 <1225387137.3690.70.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 10:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-30 at 09:09 -0700, Luis R. Rodriguez wrote:
>> On Thu, Oct 30, 2008 at 2:24 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Luis R. Rodriguez wrote:
>> >> Technically speaking since some countries do not support
>> >> some channels in 5 GHz the world regulatory domain should not
>> >> use them however APs should *not* be shipped in those countries
>> >> which don't allow 5 GHz operation. Because of this we can
>> >> safely assume we operate correctly in STA mode by forcing
>> >> passive scan and disabling ad-hoc in 5 GHz. We leave out
>> >> all DFS channels as we don't support DFS yet.
>> >
>> > No,  this is incorrect. The linux kernel can well act as an AP.
>>
>> An AP would/should not want to use the world regulatory domain though :)
>
> Yeah but if a user just starts hostapd without crda then we shouldn't
> allow it to operate in 5GHz

Should we rename NO-IBSS to NO-BEACONS ? This would mean we would not
allow IBSS, AP or Mesh.

  Luis
