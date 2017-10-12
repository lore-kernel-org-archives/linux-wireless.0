Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36515 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdJLLzp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 07:55:45 -0400
Received: by mail-oi0-f68.google.com with SMTP id s185so2333960oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Oct 2017 04:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171012003350.GA88621@google.com>
References: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com>
 <87wp4l6au9.fsf@kamboji.qca.qualcomm.com> <CAEhWJF=NusRJmdhQ7W9OPVjGG=XYAWU-+gnu_mYck2BsAOK+pg@mail.gmail.com>
 <87fuaqqbpa.fsf@kamboji.qca.qualcomm.com> <20171012003350.GA88621@google.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 12 Oct 2017 17:25:44 +0530
Message-ID: <CAEhWJFmnpvUP64vVgUssryWLKT3OLy9kJ7nqbwew=JQ44FRWkg@mail.gmail.com> (sfid-20171012_135549_041394_CE769A64)
Subject: Re: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 12, 2017 at 6:03 AM, Brian Norris <briannorris@chromium.org> wrote:
> Hi Amitkumar,
>
> On Wed, Oct 11, 2017 at 12:24:17PM +0300, Kalle Valo wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>> > On Tue, Sep 26, 2017 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> >> And even if that would be the right approach it needs to be properly
>> >> described in the commit log, a vague sentence in the end of a commit log
>> >> is not enough.
>> >
>> > Understood. I will add detailed description and send updated version
>> > if the patch is fine.
>>
>> Not sure if this is fine or not. I think what you do here is ugly but I
>> guess it's better than nothing?
>
> I don't see why you can't try to reuse the existing mac80211 reset;
> seems like you'd need to factor out some pieces of rsi_reset_card() and
> call that from the ieee80211_ops::start() method. Then, you just call
> ieee80211_restart_hw() from the appropriate place, instead of
> implementing your own tear-down/reset.

Thanks for the feedback
We will try ieee80211_restart_hw() based approach.

Regards,
Amitkumar
