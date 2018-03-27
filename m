Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:43604 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbeC0ObH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 10:31:07 -0400
Received: by mail-wr0-f181.google.com with SMTP id p53so15113236wrc.10
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2018 07:31:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87po3pppo4.fsf@kamboji.qca.qualcomm.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> <87ina00zwv.fsf@purkki.adurom.net>
 <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
 <871sgl90im.fsf@kamboji.qca.qualcomm.com> <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com>
 <1521585123.19123.2.camel@sipsolutions.net> <CAEhWJFn3ncMaqrJgndiXRNctbX2vKsBFGoGhh-EP5RRHv5qSwA@mail.gmail.com>
 <1522156927.3050.25.camel@sipsolutions.net> <87po3pppo4.fsf@kamboji.qca.qualcomm.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 27 Mar 2018 20:01:05 +0530
Message-ID: <CAEhWJFnY5gUhzk1jJb=-N25eUi_qeZtGWomix=iu6Hu9UYcswA@mail.gmail.com> (sfid-20180327_163111_634861_5AA5D714)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle/Johannes,

On Tue, Mar 27, 2018 at 7:48 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Fri, 2018-03-23 at 20:20 +0530, Amitkumar Karwar wrote:
>>
>>> > But maybe that's not really true at all? At least in one case it seems
>>> > you just kick off something called "bgscan".
>>>
>>> Yes. We have different scan implementations for device is connected
>>> and non-connected cases. In connected case, firmware will take care of
>>> timings when driver configures bgscan parameters due to power save and
>>> coex restrictions. In non-connected state, driver is taking care of
>>> it.
>>> I found hardware scan in mac80211 more suitable for our device.
>>
>> Yeah it's a bit odd though that you're still implementing software scan
>> :-)
>>
>> Perhaps we could make a special return code from the hwscan callback
>> that would tell mac80211 to fall back to software scanning, so you'd
>> only implement the connected case, and leave the rest up to mac80211?
>
> Hehe, this is exactly what I proposed during my review :)
>

Sounds good. I will prepare a patch with this approach.

Regards,
Amitkumar
