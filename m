Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36745 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbcLGJuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:50:19 -0500
Received: by mail-io0-f178.google.com with SMTP id l140so87089451iol.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 01:49:19 -0800 (PST)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com. [209.85.223.182])
        by smtp.gmail.com with ESMTPSA id c101sm10670005ioj.25.2016.12.07.01.49.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2016 01:49:18 -0800 (PST)
Received: by mail-io0-f182.google.com with SMTP id l140so87088954iol.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 01:49:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1481091554.4092.7.camel@sipsolutions.net>
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
 <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
 <CAOq732LOk-GQiSfs9Js-qEgvmbNMD_xf6j_1NR88Z1SDL=J8WA@mail.gmail.com> <1481091554.4092.7.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 7 Dec 2016 10:49:18 +0100
Message-ID: <CAOq732KP0SiJo-m5FGi9-SrmUmWy+Bs2eX06K33UknEH2TXpaA@mail.gmail.com> (sfid-20161207_105022_451907_8B1E337B)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 December 2016 at 07:19, Johannes Berg <johannes@sipsolutions.net> wrote:
>> Possibly Johanness refers to the fact that if you use
>> CMD_AUTHENTICATE, or if you use CMD_CONNECT but the driver implements
>> the SME -- doesn't use the cfg80211 software SME -- then
>> cfg80211_disconnect won't do anything if we're not associated, only
>> authenticated.  Currently cfg80211 doesn't have knowledge of whether
>> it is authenticated and where to.
>
> We used to track it, but it was a nightmare and just always buggy :)
>
>> With the software SME current_bss would be set from the moment the
>> authentication attempt starts,
>
> I'm almost certain this isn't true, what makes you think so?

Ok, I think I misread the code, indeed it looks consistent between the
driver SME and cfg80211 SME.

I'm fine only adding the socket owner flag to CMD_ASSOCIATE and
CMD_CONNECT.  I'll need to store the bssid of the association in
progress so we can send the Deauthenticate if the socket is closed
before association finishes.

>
>> so there seems to be an inconsistency
>> which would affect for example the NL80211_BSS_STATUS_ASSOCIATED
>> flags in the result of CMD_GET_SCAN.
>
> Thus this can't be the case.
>
>> Perhaps this can be fixed by always
>> setting current_bss on auth attempt start, with flags to indicate
>> whether authentication has happened and whether association happened.
>
> No! That would be wrong!
>
>> At the very least with this patch if you set the socket owner during
>> CMD_AUTHENTICATE and then separately associate, you'd get the
>> expected deauthentication.
>
> That would *NOT* be expected. There's no need to even authenticate
> through CMD_AUTHENTICATE at all to connect to (another) AP!
>
> You need to think beyond the 1996 version of 802.11 ;-)

Best regards
