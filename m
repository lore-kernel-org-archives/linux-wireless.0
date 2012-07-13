Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48171 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2GMRJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 13:09:04 -0400
Received: by pbbrp8 with SMTP id rp8so5756733pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 10:09:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342183848.4452.1.camel@jlt3.sipsolutions.net>
References: <20120712123358.22054.62538.stgit@localhost6.localdomain6> <1342183848.4452.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Jul 2012 10:08:44 -0700
Message-ID: <CAB=NE6Uo02ADchkcy156=uZ3dwLiC529YvvqhR6pkS81s3xadQ@mail.gmail.com> (sfid-20120713_190909_906117_986B25A5)
Subject: Re: [PATCH] cfg80211: fix set_regdom() to cancel requests with same alpha2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 13, 2012 at 5:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Luis?

It follows the -EALREADY convention of when a regdomain is already applied.

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

>>               if (!regdom_changes(rd->alpha2))
>> -                     return -EINVAL;
>> +                     return -EALREADY;
>>       }
>>
>>       /*
>> @@ -2325,6 +2325,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
>>       /* Note that this doesn't update the wiphys, this is done below */
>>       r = __set_regdom(rd);
>>       if (r) {
>> +             if (r == -EALREADY)
>> +                     reg_set_request_processed();
>> +
>
> I'm not really sure I like the reliance on the error code ... would it
> make more sense to invent a status enum? Or just return 0 to start with?

The code already did this with -EALREADY, if we want to treat this
differently we should go in and sweep change all that. But the big
sweep is better to happen on the regsim IMHO. I've been trying to do
as little changes as possible to existing code.

  Luis
