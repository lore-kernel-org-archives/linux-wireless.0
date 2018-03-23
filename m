Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:40715 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbeCWOu5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 10:50:57 -0400
Received: by mail-wr0-f172.google.com with SMTP id z8so12396830wrh.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 07:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521585123.19123.2.camel@sipsolutions.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> <87ina00zwv.fsf@purkki.adurom.net>
 <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
 <871sgl90im.fsf@kamboji.qca.qualcomm.com> <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com>
 <1521585123.19123.2.camel@sipsolutions.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Fri, 23 Mar 2018 20:20:55 +0530
Message-ID: <CAEhWJFn3ncMaqrJgndiXRNctbX2vKsBFGoGhh-EP5RRHv5qSwA@mail.gmail.com> (sfid-20180323_155108_823395_CE65EB76)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018 at 4:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2018-03-15 at 14:57 +0530, Amitkumar Karwar wrote:
>>
>> > What I don't like here is that you are duplicating functionality
>> > already
>> > existing in mac80211 and I hope there is a better way to solve the
>> > problem. Just as a a crazy idea what if the driver returns
>> > -EOPNOTSUPP
>> > when hardware scan is not possible and mac80211 falls back to
>> > software
>> > scan? But of course this depends on what Johannes thinks.
>>
>> Currently mac80211 offloads scan to driver if "ops->hw_scan" is
>> implemented. Otherwise falls back to software scan.
>> I can see below vendors have already implemented hw_scan with their
>> own scan state machine. This patch does the same thing.
>> Let me know if I missed anything here.
>
> I think the argument is that at least it looks like you're implementing
> the timing etc. in software in the driver again, which others don't do,
> they do it in firmware. Which is just software again, but we don't see
> it ;-)

Understood. Timing logic is either is hardware or mac80211 for others.

> But maybe that's not really true at all? At least in one case it seems
> you just kick off something called "bgscan".

Yes. We have different scan implementations for device is connected
and non-connected cases. In connected case, firmware will take care of
timings when driver configures bgscan parameters due to power save and
coex restrictions. In non-connected state, driver is taking care of
it.
I found hardware scan in mac80211 more suitable for our device.

Regards,
Amitkumar Karwar
