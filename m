Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38796 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932123AbeCKQF5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Mar 2018 12:05:57 -0400
Cc: andresx7@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20180309221243.15489-2-andresx7@gmail.com>
 <20180309230925.3573-1-andresx7@gmail.com>
 <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
 <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com>
From: Andres Rodriguez <andresx7@gmail.com>
Message-ID: <bbdc304f-edd5-38df-ea88-012fefc54b90@gmail.com> (sfid-20180311_170615_844153_C8300AE2)
Date: Sun, 11 Mar 2018 12:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanks for all your feedback, greatly appreciated.

On 2018-03-10 09:40 AM, Luis R. Rodriguez wrote:
> On Sat, Mar 10, 2018 at 6:35 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> You also I take it have users in
>> mind? I'd like to see at least one user of the API or this fixing a
>> reported issue. Ie, if users have reported this as issues incorrectly,
>> referring to those incorrect posts as issues and how this created
>> confusion would help.

The current user I have in mind is amdgpu. I've got some local patches 
for changing it to use request_firmware_optional() for the optional 
firmware files. I will include them in the v3 of this series.

I've also queried some devs from the other DRM drivers in case this 
might be useful to them. So far I've gotten a reply from the nouveau 
devs who are also interested.

> 
> Your patch series then should also have the driver callers who you
> want to modify to use this new API. Collect from the 802.11 folks the
> other drivers which I think they wanted changed as well.

Arend, Kalle, would love to hear your feedback.

> The old up on
> that front was that the firmware API was in a huge state of flux and
> debate about *how* we'd evolve the API, either through a data driven
> API or functional driven API, ie whether or not we'd add a flexible
> one API call with a set of options, or keep extending functionality
> with new exported symbols per use case. The later is how we'd keep
> evolving the API as such the way you are doing it is fine. Ie, if
> there is a use case for an optional firmware also for the async case a
> new API call will have to be made. As stupid as this sounds.
>

Seems like I got lucky with my timing for this request :)


> Also please take a look at lib/test_firmware.c -- I don't think it
> makes sense to add a new test case for this API call, so at least
> worth documenting why somewhere if you find a suitable place for that.
> > Also - I forgot to ask you to extend the
> Documentation/driver-api/firmware/ documentation accordingly. Please
> do that.
> 

Will do, for these and the feedback in the previous Email.

-Andres

>    Luis
> 
