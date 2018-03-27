Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752902AbeC0NWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:22:10 -0400
Message-ID: <1522156927.3050.25.camel@sipsolutions.net> (sfid-20180327_152222_791463_5F0489D5)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Date: Tue, 27 Mar 2018 15:22:07 +0200
In-Reply-To: <CAEhWJFn3ncMaqrJgndiXRNctbX2vKsBFGoGhh-EP5RRHv5qSwA@mail.gmail.com> (sfid-20180323_155057_219419_50FBC275)
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
         <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
         <87ina00zwv.fsf@purkki.adurom.net>
         <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com>
         <871sgl90im.fsf@kamboji.qca.qualcomm.com>
         <CAEhWJF=RByV+Ux2AuMTiWFRsG=3Jqe-2BzCDe=XQir98ex3Zag@mail.gmail.com>
         <1521585123.19123.2.camel@sipsolutions.net>
         <CAEhWJFn3ncMaqrJgndiXRNctbX2vKsBFGoGhh-EP5RRHv5qSwA@mail.gmail.com>
         (sfid-20180323_155057_219419_50FBC275)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-23 at 20:20 +0530, Amitkumar Karwar wrote:

> > But maybe that's not really true at all? At least in one case it seems
> > you just kick off something called "bgscan".
> 
> Yes. We have different scan implementations for device is connected
> and non-connected cases. In connected case, firmware will take care of
> timings when driver configures bgscan parameters due to power save and
> coex restrictions. In non-connected state, driver is taking care of
> it.
> I found hardware scan in mac80211 more suitable for our device.

Yeah it's a bit odd though that you're still implementing software scan
:-)

Perhaps we could make a special return code from the hwscan callback
that would tell mac80211 to fall back to software scanning, so you'd
only implement the connected case, and leave the rest up to mac80211?

johannes
