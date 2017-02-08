Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35630 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753894AbdBHIwP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 03:52:15 -0500
Received: by mail-oi0-f65.google.com with SMTP id x84so10536503oix.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 00:52:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486543119.2533.3.camel@redhat.com>
References: <e5bb3c8e8be4417cc648cfb53add2c89d2c89aa9.1486486128.git.pabeni@redhat.com>
 <f755ffe7-ea05-7481-af51-da2489bc8a43@broadcom.com> <1486543119.2533.3.camel@redhat.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 8 Feb 2017 09:52:14 +0100
Message-ID: <CACna6rxc6kAtAbknMGVoW5jWoxnUibD83jcVsHmU6gWhSVTWzQ@mail.gmail.com> (sfid-20170208_095525_140782_B1671BCE)
Subject: Re: [PATCH net] brcmfmac: clear skb head state on xmit
To: Paolo Abeni <pabeni@redhat.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 09:38, Paolo Abeni <pabeni@redhat.com> wrote:
> On Tue, 2017-02-07 at 20:23 +0100, Arend Van Spriel wrote:
>> On 7-2-2017 17:50, Paolo Abeni wrote:
>> > the skbs can be held by the driver for a long time, so we need
>> > to clear any state on xmit to avoid hanging other subsystems.
>> > The skbs are already orphaned later in cmsg code, so we just
>> > need to clear the nf/dst/secpath.
>> > Do it early, while the relevant entries are hopefully still
>> > hot in the cache.
>>
>> What is this about really? A bit more background about the issue
>> might
>> help understanding the need for this patch. Is this really specific
>> to
>> brcmfmac. For instance is something similar already done in mac80211?
>
> The issue is apparently driver specific, as reported in:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1294415
>
> This is caused by xmit skbs carrying a notrack ct entry not being freed
> by the device driver in a timely manner. Removing the ct module waits
> for such entries refcount going to zero and hangs the kernel in busy
> loop (for several minutes).
>
> The relevant skbs are icmp6 packets (ND if I recall correctly, they
> bcast packets at the mac level).
>
> The only other known device driver suffering for the issue is the
> infiniband ipoib driver, I send a separate patch for it.
>
> I lack the broadcom h/w, but with infiniband the bug can be reproduced
> with the following steps:
>
> - ensure ipv6 is enabled on the target device, and firewalld is running
> (e.g. the module nf_conntrack_ipv6 is loaded)
> - assign a static ip to the device
> - shut down the firewall (e.g. try to remove the module nf_conntrack)
>
> For the brcmfmac driver most probably it is necessary being
> disassociated from the AP before shutting down the firewall (but I
> can't double check). This is probably why mac80211 does not suffer this
> issue.
>
> The root cause for the issue could be actually a firmware issue, any
> better clues are more than welcome!

Do I get this correctly brcmfmac gets some skb for transmitting it and
doesn't free it for few minutes? It sounds like some bug that should
be fixed instead of hiding it.

--=20
Rafa=C5=82
