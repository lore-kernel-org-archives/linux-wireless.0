Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54171 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 04:33:14 -0500
Received: by iakc1 with SMTP id c1so3444379iak.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 01:33:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323162136.4696.2.camel@jlt3.sipsolutions.net>
References: <1323102012.4051.38.camel@jlt3.sipsolutions.net>
	<CAB3XZEdk73G-1tfCOPUGDH5jVO7NZ_Wh5ObDWi7EJSZRSeSa9g@mail.gmail.com>
	<1323162136.4696.2.camel@jlt3.sipsolutions.net>
Date: Tue, 6 Dec 2011 11:33:13 +0200
Message-ID: <CAB3XZEf--cVNOSF4WP6UurEeydUyLtXX+vykvJJJdvN9BBbc=g@mail.gmail.com> (sfid-20111206_103319_997291_5CCB1BEE)
Subject: Re: [PATCH] mac80211: accept public action frames with mismatched BSSID
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Arik Nemtsov <anamtsov@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 6, 2011 at 11:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-12-06 at 09:15 +0200, Eliad Peller wrote:
>
>> > +static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
>> > +                                             size_t len)
>> > +{
>> > +       struct ieee80211_mgmt *mgmt = (void *)hdr;
>> > +
>> > +       if (len < 25)
>> > +               return false;
>>
>> maybe use offsetof() to make clearer?
>
> Hm. The problem with that is that you need
>        offsetof(... u.action.category ...) + 1
> still since the *offset* is 24 and the size is implicit. Going beyond
> that in the offset calculation would be even stranger... I think 25 is a
> sufficiently non-magic number since everybody knows 24 is the "normal"
> header length, and it matches the style used in this file elsewhere.
>
you can do something like:
#define end_offsetof(TYPE, MEMBER) offsetof(TYPE, MEMBER) + \
		sizeof(((TYPE *)0)->MEMBER)

but hey, whatever :)

Eliad.
