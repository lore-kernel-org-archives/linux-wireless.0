Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E40DC10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DC720656
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfDOJMH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:12:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34972 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOJMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:12:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFxef-0003KV-1X; Mon, 15 Apr 2019 11:11:57 +0200
Message-ID: <92e8e142b6d441c1c995abc57d64ad7b7747a688.camel@sipsolutions.net>
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
Date:   Mon, 15 Apr 2019 11:11:54 +0200
In-Reply-To: <D4D12CF9-9CE5-46FB-9738-F89DB6B6F9EA@holtmann.org>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
         <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
         <6F1998DC-EFD2-4145-BD81-A80F9DC7ED2D@holtmann.org>
         <1d64c578cd5b254d301cf1cac82f32a062916888.camel@sipsolutions.net>
         <D4D12CF9-9CE5-46FB-9738-F89DB6B6F9EA@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-12 at 21:49 +0200, Marcel Holtmann wrote:
> 
> > Yes, that's true, though the control path is actually going through one
> > of the data pipes as well.
> 
> I think that viewpoint is too simplistic. And for sure we have no such
> system where the control path is done as IP packets for Ethernet
> packets.

That's true, but as far as I can tell in a lot of cases the pipe is
actually still a virtual netdev (session, encoded in whatever way) using
some sort of serial line format on top?

But I agree that typically this will not be sufficient anyway.

> > Right. This is something we'd typically use tracing for in wifi.
> 
> Same thing, but different way of doing it. Mind you that Bluetooth
> support is older than tracing.

Sure. Looking forward though, perhaps tracing *would* indeed be the
simplest thing to do.

> > There are a few reasons why I think that this model of having a single
> > underlying netdev controlled by the modem driver, with additional
> > netdevs layered on top in software will not work right in the future. I
> > think drivers should and will need to migrate to creating "real" netdevs
> > for the sessions instead of pure software ones.
> 
> I do not follow on why is that. Why would I care if wwan0 is self-
> sustained of just a VLAN device. Or for that matter any other kind of
> slave/child device.

From a driver perspective I think it makes a difference. For example, if
you just have a single netdev from the driver, it gets harder to do
multiple TX/RX queues properly.

> 3GPP and 3GPP2 are not Ethernet frame based. We only have raw IPv4 and
> IPv6 packets for the data path.

Sure. Though some drivers/devices fake them anyway.

> And for 3GPP you have context identifiers that at least within the
> context of the control path make logical sense of the data streams and
> what they are assigned to. This goes back to my original point. You
> need to capture the control path to see what APN context is set up and
> how. Mind you that you also have the fun between primary context and
> secondary context (primarily for quality of service in VoLTE cases).

Right.

> > It may well be that doing kernel-tracing instead of doing it via some
> > kind of monitor netdev is perfectly sufficient, but I have a feeling
> > that the relative simplicity of starting tcpdump/wireshark might be
> > preferable.
> 
> As I said, as long as you do not get the QMI, AT command, MBIM etc.
> control path session recorded as well, you have nothing to really
> analyze.

But you do - afaict there are no ways other than the netdevs to
communicate with the device, and people do things like "socat" to set up
PTYs and pretend to have serial channels there, on top of the netdevs?

johannes

