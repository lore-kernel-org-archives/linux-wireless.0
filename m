Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:20273 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZB0DSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 22:18:52 -0500
MIME-Version: 1.0
In-Reply-To: <1235698640.4936.6.camel@johannes.local>
References: <20090223192659.GB3553@tuxdriver.com>
	 <1235457113.4455.89.camel@johannes.local>
	 <20090224.235510.30497146.davem@davemloft.net>
	 <1235637360.29050.16.camel@johannes.local>
	 <20090226161340.GA4430@tuxdriver.com>
	 <1235698640.4936.6.camel@johannes.local>
Date: Thu, 26 Feb 2009 19:18:49 -0800
Message-ID: <43e72e890902261918p47e45b14i7528dd0f40685879@mail.gmail.com> (sfid-20090227_041857_360196_B8C194F0)
Subject: Re: pull request: wireless-next-2.6 2009-02-23
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 5:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-26 at 11:13 -0500, John W. Linville wrote:
>
>> > Now I just have to get around to fixing it, it's proving to be har=
der
>> > than I thought, and I don't have much time right now.
>>
>> I suppose I could just drop that one. =C2=A0IIRC there was another p=
atch
>> from you that depended upon that one as well?
>
> Ok, so I looked into this, and it turns out that it's harder to fix t=
han
> I thought. Fixing the genl code to call the pre_dumpit at the right
> place is hard and requires netlink (not genl) changes. I'm not in a
> position to do such changes right now, so I would suggest to revert i=
t,
> and for now take the easy way of restructuring nl80211 to take, in ea=
ch
> operation, the rtnl before any other locks instead of trying to do th=
is
> generically.
>
> Luis, would you be up to that? Basically go from
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cfg80211_mtx)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock()
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_unlock()
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&cfg80211_mtx)
>
> to
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock()
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&cfg80211_mtx)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&cfg80211_mtx)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_unlock()
>
> everywhere.

Sure, I'll give it a shot tomorrow unless someone else gets to it first=
=2E

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
