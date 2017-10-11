Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:46336 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755039AbdJKCbx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 22:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <1507532953.26041.5.camel@sipsolutions.net>
References: <20170926131945.3962-1-qasdfgtyuiop@gmail.com> <1506945898.25586.3.camel@sipsolutions.net>
 <CAMtaSwRU45ve71=H4C7cDQEHrkHg2=eMvXhYbe4HZGxsPRD+AQ@mail.gmail.com> <1507532953.26041.5.camel@sipsolutions.net>
From: Xiang Gao <qasdfgtyuiop@gmail.com>
Date: Tue, 10 Oct 2017 22:31:32 -0400
Message-ID: <CAMtaSwTgu5vV3Pr_TaEOK4-4x0WO2Mk71Wg+Nr2ukg6VwNZ+2Q@mail.gmail.com> (sfid-20171011_043256_513442_4964AA97)
Subject: Re: [PATCH] mac80211: aead api to reduce redundancy
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-10-09 3:09 GMT-04:00 Johannes Berg <johannes@sipsolutions.net>:
> On Sun, 2017-10-08 at 01:43 -0400, Xiang Gao wrote:
>>
>> By the way, I'm still struggling on how to run unit tests. It might
>> take time for me to make it run on my machine.
>
> I can run it easily, so don't worry about it too much. Running it is of
> course much appreciated, but I don't really want to go and require that
> right now, it takes a long time to run.
>
> If you do want to set it up, I suggest the vm scripts (hostap
> repository in tests/hwsim/vm/ - you can use the kernel .config there as
> a base to compile a kernel and then just kick it off from there, but it
> can take a while to run.

Thanks for your help on this. This information is actually very helpful to me.

Since the unit test is not required, I will put working on this patch
higher priority than unit tests. I will send out patches without
running unit tests for now before I can make it run on my computer.
But I'm still interested in trying to run it on my computer after I
finish this patch.

I will send PATCH v3 soon.

Thanks

>
>> Hmm... good question. The reason is, aes_ccm.c and aes_gcm.c was
>> almost exact copy of each other. But they have different copyright
>> information.
>> The copyright of aes_ccm.c was:
>>
>> Copyright 2006, Devicescape Software, Inc.
>> Copyright 2003-2004, Instant802 Networks, Inc.
>>
>> and the copyright of aes_gcm.c was:
>>
>> Copyright 2014-2015, Qualcomm Atheros, Inc.
>>
>> I just don't know how to write the copyright for the new aead_api.c,
>> so I does not put anything there.
>
> Heh, good point. Well, I guess we can pretend it wasn't already copied
> before and just "keep" both.
>
> johannes
