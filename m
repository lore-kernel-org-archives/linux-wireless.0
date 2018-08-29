Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:36016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbeH2LTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 07:19:49 -0400
Message-ID: <1535527450.5215.8.camel@sipsolutions.net> (sfid-20180829_092422_378089_1CC440C3)
Subject: Re: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
From: Johannes Berg <johannes@sipsolutions.net>
To: sanjay <sanjay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant2k1513@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        siva8118@gmail.com
Date: Wed, 29 Aug 2018 09:24:10 +0200
In-Reply-To: <5B83C2FE.90000@redpinesignals.com>
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
                 (sfid-20180802_055141_811857_426FAC5B) <1534246392.3547.26.camel@sipsolutions.net>
         <5B83C2FE.90000@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh, why did you send this like 10 times? Also, HTML is dropped by the
list ...

> > I'm not convinced - why would you set that? It seems to me that drivers
> > might, for example, still do one band in hardware and the other in
> > software, or something like that? You might also run into the WARN_ON
> > here?
> 
> If we don't set this bit, observed "scan aborted" when "iw dev wlan0
> scan" command
> is given in redpine dual band modules(Didn't see any issue with single
> band module).
> sh# iw dev wlan0 scan
> scan aborted!

What happened underneath here? I'm having a hard time understanding -
perhaps you can at least capture some mac80211 event tracing for this?
perhaps with function graph tracing too, so we see where exactly the
abort happens.

Unless you already know why this happens, and that's why you set the
cancel bit?

So I think the clearer thing to do would be to have a separate bit for
this and check it in the right place.

johannes
