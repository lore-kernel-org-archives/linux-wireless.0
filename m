Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55682 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCTWcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 18:32:16 -0400
Message-ID: <1521585123.19123.2.camel@sipsolutions.net> (sfid-20180320_233253_622587_15542560)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Date: Tue, 20 Mar 2018 23:32:03 +0100
In-Reply-To: <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com> (sfid-20180315_102714_410242_368CB124)
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
         <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
         <87ina00zwv.fsf@purkki.adurom.net>
         <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
         <871sgl90im.fsf@kamboji.qca.qualcomm.com>
         <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com>
         (sfid-20180315_102714_410242_368CB124)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-03-15 at 14:57 +0530, Amitkumar Karwar wrote:
> 
> > What I don't like here is that you are duplicating functionality
> > already
> > existing in mac80211 and I hope there is a better way to solve the
> > problem. Just as a a crazy idea what if the driver returns
> > -EOPNOTSUPP
> > when hardware scan is not possible and mac80211 falls back to
> > software
> > scan? But of course this depends on what Johannes thinks.
> 
> Currently mac80211 offloads scan to driver if "ops->hw_scan" is
> implemented. Otherwise falls back to software scan.
> I can see below vendors have already implemented hw_scan with their
> own scan state machine. This patch does the same thing.
> Let me know if I missed anything here.

I think the argument is that at least it looks like you're implementing
the timing etc. in software in the driver again, which others don't do,
they do it in firmware. Which is just software again, but we don't see
it ;-)

But maybe that's not really true at all? At least in one case it seems
you just kick off something called "bgscan".

johannes
