Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbJEStn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 14:49:43 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com> <wrfjvbbsp6ot.fsf@redhat.com>
	<1441275474.2565.18.camel@sipsolutions.net>
	<wrfjmvx2gi0m.fsf@redhat.com>
	<21994.26976.882903.355191@gargle.gargle.HOWL>
	<1442508413.2821.11.camel@sipsolutions.net>
Date: Mon, 05 Oct 2015 14:49:41 -0400
In-Reply-To: <1442508413.2821.11.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 17 Sep 2015 18:46:53 +0200")
Message-ID: <wrfjk2r1b16i.fsf@redhat.com> (sfid-20151005_204946_664597_3B73F294)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Sat, 2015-09-05 at 09:32 +0530, Sujith Manoharan wrote:
>> Jes Sorensen wrote:
>> > > Ah, this makes sense. There's an rc_update call or something like 
>> > > that,
>> > > that might have the requisite information. Not really sure off 
>> > > the top
>> > > of my head.
>> 
>> ieee80211_sta doesn't contain the preamble information, though ?
>> 
>> The bss information holds the short preamble information, so that can
>> probably be used - using BSS_CHANGED_ERP_PREAMBLE.
>
> Yes, this is a good point, and the preamble can't really be different
> for different stations since all the stations in the BSS (and even
> outside it on the same channel) must be able to decode it.
>
> So yeah - Jes, you can remove that and use the
> BSS_CHANGED_ERP_PREAMBLE.

Finally went back to look at this - I believe this is exactly what I am
doing in the driver right now. Pulling the short_preamble info from
BSS_CHANGED_ERP_PREAMBLE and storing it sta->drv_priv for use in the
tx function.

Cheers,
Jes
