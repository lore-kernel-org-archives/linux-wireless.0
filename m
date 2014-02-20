Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41003 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaBTHZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:25:31 -0500
Received: by mail-la0-f46.google.com with SMTP id b8so1054751lan.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 23:25:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392880090.5073.2.camel@jlt4.sipsolutions.net>
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com>
	<CALhHN=qnWsY3cEewxAOR+KafW8L-VFFG9djk5shS_BSdepKqnw@mail.gmail.com>
	<1392880090.5073.2.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Feb 2014 08:25:29 +0100
Message-ID: <CALhHN=rgxNa=tRW-evzfjG56BWqjmDU85jemRqFBFZO4zeGPaA@mail.gmail.com> (sfid-20140220_082534_131125_90B3C20A)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 February 2014 08:08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-20 at 07:07 +0100, Janusz Dziedzic wrote:
>
>> > What happens if an old kernel gets a new wireless-regdb with AUTO on
>> > all of its 5 GHz regdomain for the country it using ? I see no mention
>> > of this anywhere in the documentation and at least from the code
>> > review I just did it seemed like we'd use 0. I hope I'm wrong as
>> > otherwise that'd introduce a severe regression when this is introduced
>> > to wireless-regdb.
>
>> Old-kernel + new wireless-regdb + new crda.
>> In case of AUTO we will not set NL80211_ATTR_FREQ_RANGE_MAX_BW we will
>> get -EINVAL
>
> That seems like a problem.
>
So, we can always add NL80211_ATTR_FREQ_RANGE_MAX_BW set as 0 in crda.
Then all channels where BW=0 will be HT20 only for old kernel.

BR
Janusz
