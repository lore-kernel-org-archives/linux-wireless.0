Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44888 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762700AbdJQOIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 10:08:12 -0400
Received: from mail-ua0-f173.google.com ([209.85.217.173])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <jesse.sung@canonical.com>)
        id 1e4SXS-0007qY-VJ
        for linux-wireless@vger.kernel.org; Tue, 17 Oct 2017 14:08:11 +0000
Received: by mail-ua0-f173.google.com with SMTP id f46so1250261uae.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 07:08:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508246019.10607.77.camel@sipsolutions.net>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net> <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
 <1508237298.10607.76.camel@sipsolutions.net> <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com>
 <1508246019.10607.77.camel@sipsolutions.net>
From: Jesse Sung <jesse.sung@canonical.com>
Date: Tue, 17 Oct 2017 22:08:09 +0800
Message-ID: <CAH10aOgfNZbhUYfRa7VRPwvzDNTYtmeDYnDEMtq+6HPqbq94hg@mail.gmail.com> (sfid-20171017_160825_978205_723668A8)
Subject: Re: Commit 0711d638 breaks mwifiex
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 9:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2017-10-17 at 21:07 +0800, Jesse Sung wrote:
> >
> > > Not really quite sure about it yet, but that should address the
> > > issue?
> >
> > A very rough test by issuing reassociate in wpa_cli:
> > mwifiex works after reassociate - looks good
>
> Ok. Discussing this with Ilan, we realized that this was buggy, and
> came up with this patch instead:
>
> https://p.sipsolutions.net/8f9d5917a5cbe4b3.txt
>
> Can you also give that a spin?

Issued four reassociate, the network interface is still alive. Also with this
patch it stays with BSSID1 and I don't see any "Association request to
the driver failed" in the process.

Thanks,
Jesse
