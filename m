Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50931 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaK3MhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 07:37:15 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so11986762wgh.40
        for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2014 04:37:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417350731.2156.1.camel@sipsolutions.net>
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
 <1417074298-12254-2-git-send-email-arik@wizery.com> <1417182387.27562.8.camel@sipsolutions.net>
 <20141128220020.GX25677@wotan.suse.de> <CA+XVXffyFiqE31KLN2Os1Uu5z9FrFPXXs0Qs_D+OEfnqjgd8uQ@mail.gmail.com>
 <1417350731.2156.1.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 30 Nov 2014 14:36:58 +0200
Message-ID: <CA+XVXfdfiWy_6UntcGGrTjCR4TBwrdJ7q_eeys9-u9P43DJ-+w@mail.gmail.com> (sfid-20141130_133719_681431_2A14687E)
Subject: Re: [PATCH v5 2/4] cfg80211: allow usermode to query wiphy specific regdom
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 30, 2014 at 2:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-11-30 at 14:26 +0200, Arik Nemtsov wrote:
>
>> I think Johannes' point was that it's easy to overrun the message size
>> if there are a lot of wiphys.
>
> Yes.
>
>> So I'll simply add an iterator over all wiphys in "iw reg get" and
>> kernel-mode will only return a single regdomain in each GET_REG
>> invocation.
>
> Err, there's such a thing built into netlink already - just support
> dumpit instead of doit :)

That's cool. I'll use it then :)

> iw will have to fall back to doit for older kernels though I guess.

Well older kernels don't have this feature anyway, so it's fine to
leave the doit as is.
For backports, we are bringing this code with us anyway right?

>
>> About the "--all" suggestion - I think it's fine to not have backward
>> compatibility in the output of "iw reg get"? So we can just output the
>> global first, and then output private regdoms for all wiphys that have
>> them.
>>
>> Does that sound ok?
>
> Yeah I wasn't taking about the iw display, and adding --all there
> doesn't help for what I was concerned about.
>
>> Well you have to give a wiphy-idx in order to get a private regdom in
>> the first place. And only new userspace will add a wiphy-idx in the
>> first place..
>
> Are you sure about the last part though? wpa_supplicant often passed a
> netdev index instead of a wiphy index for example, so I could imagine it
> passing a wiphy index here even though it was previously ignored?
>
> If it didn't though then I think there's no problem, there shouldn't
> really be any userspace other than wpa_s and iw for this I guess/hope.

It definitely doesn't pass it now. Otherwise we wouldn't have to change it :)

Arik
