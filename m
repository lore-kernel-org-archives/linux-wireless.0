Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35075 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaBUXIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 18:08:48 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so2858027lab.23
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 15:08:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=rgxNa=tRW-evzfjG56BWqjmDU85jemRqFBFZO4zeGPaA@mail.gmail.com>
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com>
 <CALhHN=qnWsY3cEewxAOR+KafW8L-VFFG9djk5shS_BSdepKqnw@mail.gmail.com>
 <1392880090.5073.2.camel@jlt4.sipsolutions.net> <CALhHN=rgxNa=tRW-evzfjG56BWqjmDU85jemRqFBFZO4zeGPaA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 15:08:27 -0800
Message-ID: <CAB=NE6Xr=SK3rdpS2SoE-k94EhLkdFsLPCtEjk95o8KSjYoMkg@mail.gmail.com> (sfid-20140222_000857_485836_BB9F2D76)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 11:25 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 20 February 2014 08:08, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2014-02-20 at 07:07 +0100, Janusz Dziedzic wrote:
>>
>>> > What happens if an old kernel gets a new wireless-regdb with AUTO on
>>> > all of its 5 GHz regdomain for the country it using ? I see no mention
>>> > of this anywhere in the documentation and at least from the code
>>> > review I just did it seemed like we'd use 0. I hope I'm wrong as
>>> > otherwise that'd introduce a severe regression when this is introduced
>>> > to wireless-regdb.
>>
>>> Old-kernel + new wireless-regdb + new crda.
>>> In case of AUTO we will not set NL80211_ATTR_FREQ_RANGE_MAX_BW we will
>>> get -EINVAL
>>
>> That seems like a problem.
>>
> So, we can always add NL80211_ATTR_FREQ_RANGE_MAX_BW set as 0 in crda.
> Then all channels where BW=0 will be HT20 only for old kernel.

That also seems like a problem.

  Luis
