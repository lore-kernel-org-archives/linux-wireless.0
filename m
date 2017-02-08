Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754083AbdBHJ3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:29:43 -0500
Message-ID: <1486546181.2533.5.camel@redhat.com> (sfid-20170208_103246_368506_3440A0D9)
Subject: Re: [PATCH net] brcmfmac: clear skb head state on xmit
From: Paolo Abeni <pabeni@redhat.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        hante Meuleman <hante.meuleman@broadcom.com>
Date: Wed, 08 Feb 2017 10:29:41 +0100
In-Reply-To: <CACna6rxc6kAtAbknMGVoW5jWoxnUibD83jcVsHmU6gWhSVTWzQ@mail.gmail.com>
References: <e5bb3c8e8be4417cc648cfb53add2c89d2c89aa9.1486486128.git.pabeni@redhat.com>
         <f755ffe7-ea05-7481-af51-da2489bc8a43@broadcom.com>
         <1486543119.2533.3.camel@redhat.com>
         <CACna6rxc6kAtAbknMGVoW5jWoxnUibD83jcVsHmU6gWhSVTWzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-08 at 09:52 +0100, Rafał Miłecki wrote:
> On 8 February 2017 at 09:38, Paolo Abeni <pabeni@redhat.com> wrote:
> > On Tue, 2017-02-07 at 20:23 +0100, Arend Van Spriel wrote:
> > > On 7-2-2017 17:50, Paolo Abeni wrote:
> > > > the skbs can be held by the driver for a long time, so we need
> > > > to clear any state on xmit to avoid hanging other subsystems.
> > > > The skbs are already orphaned later in cmsg code, so we just
> > > > need to clear the nf/dst/secpath.
> > > > Do it early, while the relevant entries are hopefully still
> > > > hot in the cache.
> > > 
> > > What is this about really? A bit more background about the issue
> > > might
> > > help understanding the need for this patch. Is this really
> > > specific
> > > to
> > > brcmfmac. For instance is something similar already done in
> > > mac80211?
> > 
> > The issue is apparently driver specific, as reported in:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1294415
> > 
> > This is caused by xmit skbs carrying a notrack ct entry not being
> > freed
> > by the device driver in a timely manner. Removing the ct module
> > waits
> > for such entries refcount going to zero and hangs the kernel in
> > busy
> > loop (for several minutes).
> > 
> > The relevant skbs are icmp6 packets (ND if I recall correctly, they
> > bcast packets at the mac level).
> > 
> > The only other known device driver suffering for the issue is the
> > infiniband ipoib driver, I send a separate patch for it.
> > 
> > I lack the broadcom h/w, but with infiniband the bug can be
> > reproduced
> > with the following steps:
> > 
> > - ensure ipv6 is enabled on the target device, and firewalld is
> > running
> > (e.g. the module nf_conntrack_ipv6 is loaded)
> > - assign a static ip to the device
> > - shut down the firewall (e.g. try to remove the module
> > nf_conntrack)
> > 
> > For the brcmfmac driver most probably it is necessary being
> > disassociated from the AP before shutting down the firewall (but I
> > can't double check). This is probably why mac80211 does not suffer
> > this
> > issue.
> > 
> > The root cause for the issue could be actually a firmware issue,
> > any
> > better clues are more than welcome!
> 
> Do I get this correctly brcmfmac gets some skb for transmitting it
> and
> doesn't free it for few minutes? It sounds like some bug that should
> be fixed instead of hiding it.

I mostly agreed, but please also note that early clearing the skb head
state makes sense from a performance pov: we can do the costly,
required, atomic operations while the data is still hot in the cpu L1
cache.

I'm unable to find anything obvious at the driver level, and I think
the root cause could be in the firmware. I hope some more knowledgeable
than me on this topics can have a better look.

Thank you,

Paolo
