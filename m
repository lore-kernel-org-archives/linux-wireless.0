Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53262 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaAVJJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:09:54 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so4668188eek.17
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 01:09:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390380813.4334.5.camel@jlt4.sipsolutions.net>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	<1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	<1390319550.6199.59.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=sWMSN5NveRf0aw98mMYWks2eXKWzZvk4NZgGLOctuQQ@mail.gmail.com>
	<1390380813.4334.5.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 10:09:53 +0100
Message-ID: <CA+BoTQnL5WKMb1TN7ZtDziRQ8=A8F0qq0r6jDOWCZJDCsV5cQA@mail.gmail.com> (sfid-20140122_100959_258548_9E4F5542)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 09:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 07:36 +0100, Michal Kazior wrote:
>
>> >> +     if (!attrs[NL80211_ATTR_IFINDEX])
>> >> +             return -EINVAL;
>> >
>> > Hmm, shouldn't you use the ifindex from the csa_attrs? Or are you
>> > requiring one to be in the outer data to identify the wiphy? But that
>> > seems odd too, you can just get the wiphy in whatever way by asking the
>> > pre_doit for that?
>>
>> I'm not sure I understand you.
>>
>> There are two command variants now:
>>
>> 1: the old one, which has ifindex in the root
>> 2: the new one, which has wiphy in the root, and an array of (1)
>> within CH_SWITCH_IFACES (and each entry has ifindex at its root)
>
> Yeah I think I confused the two. This is handling case 1 only, right?

No. It handles both cases.


> But you have to check the ifindex manually since for case 2 you can only
> require the pre_doit() to give you the wiphy.

In case 2 ifindex is not available in the attribute root. Can you
require pre_doit() to check ifindex if it's possible for ifindex to be
missing (case 2)?


Michał
