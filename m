Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37876 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753489AbdJQPKv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 11:10:51 -0400
Message-ID: <1508253043.10607.89.camel@sipsolutions.net> (sfid-20171017_171054_522281_7DD3AD68)
Subject: Re: Commit 0711d638 breaks mwifiex
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Sung <jesse.sung@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 17:10:43 +0200
In-Reply-To: <CAH10aOizMKboDOW27gvz=YEcRT1_tMj+W6iwJ47n=T=-Q7U14A@mail.gmail.com>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
         <1508233890.10607.70.camel@sipsolutions.net>
         <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
         <1508237298.10607.76.camel@sipsolutions.net>
         <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com>
         <1508246019.10607.77.camel@sipsolutions.net>
         <CAH10aOgfNZbhUYfRa7VRPwvzDNTYtmeDYnDEMtq+6HPqbq94hg@mail.gmail.com>
         <CAH10aOizMKboDOW27gvz=YEcRT1_tMj+W6iwJ47n=T=-Q7U14A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > https://p.sipsolutions.net/8f9d5917a5cbe4b3.txt
> > > 
> > > Can you also give that a spin?

Thanks for testing!

> > Issued four reassociate, the network interface is still alive. Also
> > with this patch it stays with BSSID1 and I don't see any
> > "Association request to the driver failed" in the process.
> 
> Correction: I can still see "Association request to the driver
> failed" and switching between BSSIDs with more reassociates but I
> think that shouldn't be an issue?

Not sure what you mean by "with more reassociates"?

In any case, we suspect that there's another underlying issue in
mwifiex, which happens to tickle this problem.

Could you record a full trace with -e cfg80211 for me (and send it
privately, please compress trace.dat e.g. with xz, it compresses really
well)

Thanks,
johannes
