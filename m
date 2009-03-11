Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:27921 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZCKQ1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 12:27:19 -0400
MIME-Version: 1.0
In-Reply-To: <1236772199.20266.3.camel@johannes.local>
References: <20090223192659.GB3553@tuxdriver.com>
	 <1235457113.4455.89.camel@johannes.local>
	 <20090224.235510.30497146.davem@davemloft.net>
	 <1235637360.29050.16.camel@johannes.local>
	 <20090226161340.GA4430@tuxdriver.com>
	 <1235698640.4936.6.camel@johannes.local>
	 <43e72e890902261918p47e45b14i7528dd0f40685879@mail.gmail.com>
	 <1236772199.20266.3.camel@johannes.local>
Date: Wed, 11 Mar 2009 09:27:16 -0700
Message-ID: <43e72e890903110927i2ef8012dn86e0e72fb048aea3@mail.gmail.com> (sfid-20090311_172724_630879_378C7937)
Subject: Re: pull request: wireless-next-2.6 2009-02-23
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 4:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-26 at 19:18 -0800, Luis R. Rodriguez wrote:
>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cfg80211_mtx)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock()
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_unlock()
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&cfg80211_mtx)
>> >
>> > to
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock()
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cfg80211_mtx)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&cfg80211_mtx)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_unlock()
>> >
>> > everywhere.
>>
>> Sure, I'll give it a shot tomorrow unless someone else gets to it fi=
rst.
>
> Did you get a chance to look at this? Otherwise I'll just do it later
> today.

Unfortunately not, please do.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
