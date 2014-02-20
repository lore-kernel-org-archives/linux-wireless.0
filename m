Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43209 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaBTGH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 01:07:59 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so991087lbv.24
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 22:07:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com>
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com>
Date: Thu, 20 Feb 2014 07:07:57 +0100
Message-ID: <CALhHN=qnWsY3cEewxAOR+KafW8L-VFFG9djk5shS_BSdepKqnw@mail.gmail.com> (sfid-20140220_070818_052879_92237473)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 19:51, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Thu, Jan 30, 2014 at 12:52 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>>
>> We don't need any changes in CRDA or internal regulatory.
>
> What happens if an old kernel gets a new wireless-regdb with AUTO on
> all of its 5 GHz regdomain for the country it using ? I see no mention
> of this anywhere in the documentation and at least from the code
> review I just did it seemed like we'd use 0. I hope I'm wrong as
> otherwise that'd introduce a severe regression when this is introduced
> to wireless-regdb.

Old wireless-regdb also allow 0 :-) (the same case like last one)

Old-kernel + new wireless-regdb + new crda.
In case of AUTO we will not set NL80211_ATTR_FREQ_RANGE_MAX_BW we will
get -EINVAL

Old-kernel + new wireless-regd + old crda (will send 0):
We will set on channels: IEEE80211_CHAN_NO_HT40 |
IEEE80211_CHAN_NO_HT80 | IEEE80211_CHAN_NO_HT160
So, all channels where BW=0 will be HT20 only - isn't that default?

BR
Janusz
