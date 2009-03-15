Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:56769 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZCOT1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 15:27:04 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1500980wfa.4
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 12:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237139955.24381.2.camel@johannes.local>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171452.11126.11618.stgit@tikku>
	 <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com>
	 <87r60z1c8x.fsf@nokia.com> <1237139955.24381.2.camel@johannes.local>
Date: Sun, 15 Mar 2009 12:27:02 -0700
Message-ID: <43e72e890903151227q2b1cc5a8vd5dcc0e102fa7350@mail.gmail.com> (sfid-20090315_202709_545878_0C8EFECA)
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 15, 2009 at 10:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-03-15 at 09:22 +0200, Kalle Valo wrote:
>> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
>>
>> > Last we reviewed this it seemed we were set on only allowing this for
>> > hardware which supports beacon filtering with support for checksumming
>> > of the beacons. Reason checksumming is important is for considerations
>> > of DFS with the channel switch announcements, HT with with channel width
>> > changes. In fact I'm curious why checksumming would be required for 2.4 GHz
>> > single band devices. Kalle, do you happen to know?
>>
>> In my opinion also 2.4 GHz band needs checksum support. At least ERP
>> protection changes come to my mind, but maybe there are also others.
>
> Also, the virtual hardware support Jouni is working on might use quiet
> elements, and these would have to be detected by the stations. We really
> want beacon change detection somewhere.
>
>> I think this is future stuff, I would like to get the basic (and the
>> simplest) implementation to the tree first and then we can start
>> improving and extending it.
>
> Agreed, anything that is more complex than this basic stuff which
> requires proper beacon change watching by the firmware is too much for
> the first cut here -- we're having enough trouble as-is, for example
> with the BSS struct stuff.

Understood, can we just add some text to the doc then elaborating what
is expected of the hardware for now.

  Luis
