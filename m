Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE8BC282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7887C206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfDLMM5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:12:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46844 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfDLMM4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:12:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEv30-0006Di-7V; Fri, 12 Apr 2019 14:12:46 +0200
Message-ID: <1d64c578cd5b254d301cf1cac82f32a062916888.camel@sipsolutions.net>
Subject: Re: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Vadim Yanitskiy <axilirator@gmail.com>,
        Harald Welte <laforge@gnumonks.org>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Fri, 12 Apr 2019 14:12:44 +0200
In-Reply-To: <6F1998DC-EFD2-4145-BD81-A80F9DC7ED2D@holtmann.org>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
         <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
         <6F1998DC-EFD2-4145-BD81-A80F9DC7ED2D@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marcel,

> before you go all out and define this, it would suggest to understand
> what meta-data for the connection contexts you actually need as well.
> The data path itself is just a pipe and has not all the information
> attached with it. That goes via the control path and that is normally
> in user space and carries the real important information to make
> useful analysis of how the data path / context is setup.

Yes, that's true, though the control path is actually going through one
of the data pipes as well.

> From what I am seeing right now is that unless you have a method to
> also feed the control path into your GSMTAPv3, then this is rather
> useless. 

So the control path *itself* would be there, I guess, but ...

> The majority of the debugging is really done for the control path. For
> oFono that is OFONO_DEBUG=1 environment variable and while it works it
> is not the most elegant solution. I would love to feed that into a
> generic debugging / tap that you can read out later.

there's definitely room for more information than _just_ the control
path "chat", also application state etc. would be useful, and logging
etc.

Typically on wifi we feed all of this together into kernel tracing (to
record with trace-cmd) rather than trying to encapsulate it some other
way.

> As a side note, for Bluetooth we created a path where the bluetoothd
> can feed back its control debugging data back into the Bluetooth
> monitor in the kernel to allow combined userspace, mgmt and HCI
> tracing. Some really nasty issues could only be triaged by having all
> the meta data with a common timestamp.

Right. This is something we'd typically use tracing for in wifi.

I don't really know what the right model for WWAN would be, I guess.


Right now - and I really should've said this before - really the only
problem I was thinking of was how we can mux multiple "chat" sessions
with a device into a single data stream.

Currently, this is all vendor-specific. If you have a Qualcomm modem,
you'd be able to see all the open sessions on the underlying netdev, and
the QMI header tells you what session a given 'packet' belongs to, and
if you follow along maybe you can figure out if this is a control or IP
'packet' (could be an AT command).

cdc_mbim uses VLAN tags instead to achieve this, and decapsulates the
VLAN tags to send them down to the hardware in a different way.

There are a few reasons why I think that this model of having a single
underlying netdev controlled by the modem driver, with additional
netdevs layered on top in software will not work right in the future. I
think drivers should and will need to migrate to creating "real" netdevs
for the sessions instead of pure software ones.

But if you do this, you lose the ability to listen to all the session
streams at the same time, you can only do it for each netdev. Adding
this ability back seems worthwhile, but then we probably shouldn't do it
in a vendor-specific way, but rather in a generic way.

So basically right now that's all I'm trying to solve. In WiFi we don't
have the problem of "sessions" because we just use the addresses in the
frames to disambiguate - on such 'monitor' netdevs we see the frames
including full 802.11 headers.

Now, here's maybe where I'm getting off the right path - in wifi we
mostly couple that with PHY information as well, and so we have PHY
information + full 802.11 headers + data for capturing what's going on.
I figured that theoretically at least that would be possible/useful for
the modem as well (obviously control packets have no PHY data), but
there doesn't seem to be any hardware that would actually expose data in
this way. Everyone I've spoken to says these things are only available
as modem trace data. What I haven't figured out though is if that's by
some other design trade-off, or just because no such infrastructure
is/was available.

It may well be that doing kernel-tracing instead of doing it via some
kind of monitor netdev is perfectly sufficient, but I have a feeling
that the relative simplicity of starting tcpdump/wireshark might be
preferable.

johannes

