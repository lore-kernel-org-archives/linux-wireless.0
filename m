Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:40842 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbeHaRiK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:38:10 -0400
Received: by mail-vk0-f66.google.com with SMTP id q184-v6so5469715vke.7
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2018 06:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
 <1534246392.3547.26.camel@sipsolutions.net> <5B83C2FE.90000@redpinesignals.com>
 <1535527450.5215.8.camel@sipsolutions.net>
In-Reply-To: <1535527450.5215.8.camel@sipsolutions.net>
From: Siva Rebbagondla <siva8118@gmail.com>
Date: Fri, 31 Aug 2018 19:04:37 +0530
Message-ID: <CANGSkXTnEV7efC8nY9MRK1q2Ky-Ao_6rLoLp75oj4cvCkguZGw@mail.gmail.com> (sfid-20180831_153203_370833_E6B23CB4)
Subject: Re: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
To: johannes@sipsolutions.net
Cc: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 12:54 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Huh, why did you send this like 10 times? Also, HTML is dropped by the
> list ...
>
Hi Johannes,
There was an issue with our mailing server and we received Mail
Delivery Failure notification.
Hence, we tried multiple times by doing the changes.
Apologies for the inconvenience.
> > > I'm not convinced - why would you set that? It seems to me that drivers
> > > might, for example, still do one band in hardware and the other in
> > > software, or something like that? You might also run into the WARN_ON
> > > here?
> >
> > If we don't set this bit, observed "scan aborted" when "iw dev wlan0
> > scan" command
> > is given in redpine dual band modules(Didn't see any issue with single
> > band module).
> > sh# iw dev wlan0 scan
> > scan aborted!
>
> What happened underneath here? I'm having a hard time understanding -
> perhaps you can at least capture some mac80211 event tracing for this?
> perhaps with function graph tracing too, so we see where exactly the
> abort happens.
>
> Unless you already know why this happens, and that's why you set the
> cancel bit?
Sure Johannes. I will provide event trace or function graph details
for this and send you
the updatd patch. Is that fine?.
>
> So I think the clearer thing to do would be to have a separate bit for
> this and check it in the right place.
>
> johannes

Thanks
Siva Rebbagondla
