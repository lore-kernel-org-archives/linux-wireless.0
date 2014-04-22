Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:61424 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaDVRjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:39:16 -0400
Received: by mail-la0-f44.google.com with SMTP id b8so1041716lan.17
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 10:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140422193029.2d81fac5@xenia.leun.net>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
 <20140422180003.6438dbb7@xenia.leun.net> <CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
 <20140422184824.74973bb3@xenia.leun.net> <CAB=NE6W64b5VS5pTnxrcRRkRdje6h_hQcGmF9jUiXO55b+nHRw@mail.gmail.com>
 <20140422193029.2d81fac5@xenia.leun.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 10:38:54 -0700
Message-ID: <CAB=NE6UCS3ZSE3CQ_98vBHQqZRR31PwF61_G+UZ-mEp=WqEDeQ@mail.gmail.com> (sfid-20140422_193929_095419_67EB10FC)
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 10:30 AM, Michael Leun
<lkml20140418@newton.leun.net> wrote:
> On Tue, 22 Apr 2014 10:04:19 -0700
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>
>> On Tue, Apr 22, 2014 at 9:48 AM, Michael Leun
>> <lkml20140418@newton.leun.net> wrote:
>> > 1611                    if (wiphy->regulatory_flags &
>> > REGULATORY_COUNTRY_IE_IGNORE) 1612
>> > return REG_REQ_IGNORE;
>>
>> Interesting -- same line as your regression test had found, wiphy->
>> must be NULL. Digging deeper, you can discard that patch now, we can
>> rule out the reprocessing of the request.
>
>
> OK, but if this adds any useful information: Meanwhile I applied the
> 2nd patch you posted ontop test-ariks-patch-for-314.patch (with some
> fuzz), and that did change something:
>
> Does not wait until I try to hibernate to bang, it barfs already during
> boot and that seems to look different. Didnt have a chance to copy that
> yet, but could, if useful.

Yeah we don't want that 2nd patch, your issue seems like a race on the
 wiphy during suspend, which is very surprising, specially that no one
else would have picked up on this before. I'll go build v3.14.1 and
reproduce with rtcwake -m mem -s 30.

  Luis
