Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:49360 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbdJLAdy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 20:33:54 -0400
Received: by mail-pf0-f173.google.com with SMTP id l188so2596628pfc.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Oct 2017 17:33:54 -0700 (PDT)
Date: Wed, 11 Oct 2017 17:33:51 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
Message-ID: <20171012003350.GA88621@google.com> (sfid-20171012_023400_954645_FDCA257C)
References: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com>
 <87wp4l6au9.fsf@kamboji.qca.qualcomm.com>
 <CAEhWJF=NusRJmdhQ7W9OPVjGG=XYAWU-+gnu_mYck2BsAOK+pg@mail.gmail.com>
 <87fuaqqbpa.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fuaqqbpa.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Wed, Oct 11, 2017 at 12:24:17PM +0300, Kalle Valo wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
> > On Tue, Sep 26, 2017 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> >> And even if that would be the right approach it needs to be properly
> >> described in the commit log, a vague sentence in the end of a commit log
> >> is not enough.
> >
> > Understood. I will add detailed description and send updated version
> > if the patch is fine.
> 
> Not sure if this is fine or not. I think what you do here is ugly but I
> guess it's better than nothing?

I don't see why you can't try to reuse the existing mac80211 reset;
seems like you'd need to factor out some pieces of rsi_reset_card() and
call that from the ieee80211_ops::start() method. Then, you just call
ieee80211_restart_hw() from the appropriate place, instead of
implementing your own tear-down/reset.

Brian
