Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:39366 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754188AbXKABmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 21:42:39 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ilog2 overkill in ieee80211_get_hdrlen?
Date: Thu, 1 Nov 2007 10:42:36 +0900
Cc: linux-wireless@vger.kernel.org
References: <200710311514.48896.bruno@thinktube.com> <1193833235.12078.22.camel@johannes.berg>
In-Reply-To: <1193833235.12078.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711011042.37192.bruno@thinktube.com> (sfid-20071101_014242_382821_8365C83E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

johannes,

thanks for the explanation!

bruno

On Wednesday 31 October 2007 21:20:35 Johannes Berg wrote:
> > in 'net/mac80211/util.c', in ieee80211_get_hdrlen (line 175), a function
> > ilog2 is used to determine the number of bits to shift for
> > IEEE80211_STYPE_QOS_DATA. isn't that a bit of an overkill when we could
> > just do >> 6? i mean IEEE80211_STYPE_QOS_DATA isn't going to change after
> > all...
>
> Yeah but ilog2() evaluates to a constant here so it doesn't matter, and
> I think this is more readable.
>
> > if (fc & IEEE80211_STYPE_QOS_DATA)
> > 	hdrlen += 2;
> >
> > would be a bit more readable.
>
> It used to be that but that's a branch and the generated code is better
> the other way.
>
> johannes


