Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdIMEU0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Sep 2017 00:20:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kevin Cernekee <cernekee@chromium.org>,
        franky.lin@broadcom.com, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
References: <20170909193020.19061-1-cernekee@chromium.org>
        <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com>
        <87tw08mpq1.fsf@purkki.adurom.net> <59B78E94.5040909@broadcom.com>
        <87o9qgicju.fsf@kamboji.qca.qualcomm.com>
        <59B793C9.2030103@broadcom.com>
        <87k214ibps.fsf@kamboji.qca.qualcomm.com>
        <59B79838.6090408@broadcom.com> <20170912123341.GA19179@kroah.com>
Date: Wed, 13 Sep 2017 07:20:05 +0300
In-Reply-To: <20170912123341.GA19179@kroah.com> (Greg KH's message of "Tue, 12
        Sep 2017 05:33:41 -0700")
Message-ID: <87ingngrgq.fsf@kamboji.qca.qualcomm.com> (sfid-20170913_062030_123099_7EA7F87A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> On Tue, Sep 12, 2017 at 10:18:00AM +0200, Arend van Spriel wrote:
>> + Greg KH
>> 
>> On 9/12/2017 10:05 AM, Kalle Valo wrote:
>> > Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>> > 
>> > > It is actually in the stable-kernel-rules documentation [1]:
>> > > 
>> > > """
>> > > Also, some patches may have kernel version prerequisites.  This can be
>> > > specified in the following format in the sign-off area:
>> > > 
>> > > .. code-block:: none
>> > > 
>> > >       Cc: <stable@vger.kernel.org> # 3.3.x
>> > > 
>> > > The tag has the meaning of:
>> > > 
>> > > .. code-block:: none
>> > > 
>> > >       git cherry-pick <this commit>
>> > > 
>> > > For each "-stable" tree starting with the specified version.
>> > > """
>> > 
>> > Yeah, but it says "starting with" which I interpret as "starting with
>> > string '3.3'". For example the commit here would be applied to 3.3.1,
>> > 3.3.2 and 3.3.3 etc but _not_ to 3.4, 3.4.1, 3.5 or any later release.
>> > 
>> > Of course I can be way off here, wouldn't be the first :)
>> 
>> Dito. I interpret "each -stable tree" as each stable branch in the stable
>> repository. Would Greg know?
>
> "# 3.8+" and "# 3.8" mean the same thing to me, we would never backport
> something to only a very specific kernel version, and leave newer kernel
> versions to not have that fix.  That would be crazy, and would break our
> "no regressions" rule (i.e. newer kernels should always work as good as
> older kernels.)

Indeed, that would be crazy. Didn't think it like that, thanks for the
clarification.

> Don't get hung up on the semantics here people, it's not all that
> complicated, and I do it all by hand anyway :)

Manually? Oh man, that has to be so hard. I cannot understand how you
can do it.

-- 
Kalle Valo
