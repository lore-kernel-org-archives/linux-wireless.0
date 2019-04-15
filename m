Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80FAC282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90D4A20656
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfDOJ0b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:26:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35208 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfDOJ0a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:26:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFxsd-0003bZ-HG; Mon, 15 Apr 2019 11:26:23 +0200
Message-ID: <77ac708e198c8b04f45e47f53f63bd2f4ed006df.camel@sipsolutions.net>
Subject: Re: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     openbsc@lists.osmocom.org, radiotap@netbsd.org,
        linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Date:   Mon, 15 Apr 2019 11:26:22 +0200
In-Reply-To: <20190413073505.GD24451@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <20190410233213.GN25552@nataraja>
         <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
         <20190413073505.GD24451@nataraja>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Harald,

> Agreed.  However, the protocol stacks on WiFi and cellular technologies
> are very different, to say the least.  There is no easy mapping of PHY
> related parameters to a given IP packet, and the related quality metrics
> of the radio channels don't work that way.

Sure. I'm (vaguely) aware of that.

> But yes, I agree, that whatever transport mechanism you wan to use between the modem
> and the user/Linux side should allow for additional, extensible metadata beyond
> the identifier of the PDP/PDN context.

Really the question it goes down to is whether there's possible overlap
here with GSMTAP or not.

If yes - we can define a GSMTAPv3, with TLVs or so, and add a "PDP/PDN
context" or "session" field or something like that, and maybe a tag that
says "IP packet is here", or some kind of "content type" field. I expect
there would be some such "sessions" that actually just transport the
local AT command chat.

If no, I guess we'll just define something else for this use case? Or,
perhaps, even get rid of it entirely and just rely on trace-cmd
recording or so, though then I guess we'd really want to teach libpcap
and/or wireshark to understand this in some way.

Though it almost sounds like in GSMTAP you're never actually
transporting IP data, but other types of packets that in turn transport
the (fragmented/compressed/encrypted) IP data. That would kinda mean
there's very little potential overlap.

> > This is the part I guess I don't understand. I haven't really tried, but
> > it seems you should be able to encapsulate arbitrary protocols into
> > 802.3 OUI-based ethertype or so?
> 
> But why?  I'm in an userspace program, and I want to send data to one or
> more other userspace programs.  Why would I not simply open a UDP socket
> to do so?  I would have to have CAP_NET_RAW and open a packet socket,
> and then generate ethernet frames from that?
> 
> I admit that the use case with wireshark is a bit odd, but there are
> other receivers out there.

Yeah, ok. I was thinking kinda the other way around - if all you need is
network transparency for wireshark it shouldn't matter, but that's
really discussed over in the other subthread with Guy Harris better.

Anyway it doesn't matter, and I'm beginning to understand that a (maybe
even the primary) use case is getting multiple parts of your stack to
talk to each other (over UDP).

> Yes, you're looking only at a single interface (the radio interface
> between one BSS and one STA).  You're not looking at five different
> interfaces at five different levels of network hierarchy/topology in the "wifi
> controller" and want to mix in a radio interface trace in the same
> timeline.

Indeed. Well, actually, we often do, but use different mechanics for
that (trace-cmd record comes to mind, it records all our driver/fw chat
as well as possibly adding in logging from wpa_supplicant etc.)

> > Basically, I was looking at it as if it was like WiFi in a sense - you
> > have an IP frame, you're going to transport it over some physical link,
> > so it gets PHY information in the sense of modulation etc.
> 
> As stated elsewhere, there's an M:N mapping between user (IP) payload
> and actual radio interface "MAC blocks", so I'm not aware of anyone
> mapping radio interface performance to user plane IP.

Right, OK.

> the "physical link info" is present in GSMTAP, but the granularity of
> GSMTAP frames is not user-IP frames, but "MAC blocks".  So your user IP
> frame might not be visible as it's still compressed, encrypted,
> fragmented, etc.

Sure. As Guy Harris pointed out, this is also true for wifi though - we
don't have compression, but certainly encryption & fragmentation,
wireshark was taught to handle that and recreate the original MSDU (mac
service data unit).

johannes

