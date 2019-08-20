Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E37C3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 06:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83CB20C01
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 06:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfHTG7G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 02:59:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59190 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfHTG7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 02:59:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hzy6h-00082E-S3; Tue, 20 Aug 2019 08:59:03 +0200
Message-ID: <6835732fcc59ba8dbbcda4abc6e17dad499a7d8d.camel@sipsolutions.net>
Subject: Re: [RFC 0/1] Allow MAC change on up interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 20 Aug 2019 08:59:02 +0200
In-Reply-To: <c6b719d6279211bbf52443f327884d96ef63f2b2.camel@gmail.com> (sfid-20190819_231529_805133_AD4E6DEE)
References: <20190815185702.30937-1-prestwoj@gmail.com>
         (sfid-20190815_205833_978900_86B1E73D) <645af7dad899e8eb186b3fee0f8a8a151a408557.camel@sipsolutions.net>
         <394092a2f20697c9b055166a8254a5ef888551a5.camel@gmail.com>
         (sfid-20190819_175627_344053_E33FB9B0) <4848c3a9d0b330fab4442436244387a2c127fa03.camel@sipsolutions.net>
         <c6b719d6279211bbf52443f327884d96ef63f2b2.camel@gmail.com>
         (sfid-20190819_231529_805133_AD4E6DEE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi James,

Thanks for staying on topic.

> > I don't, short of
> > 
> > 1) don't do that then
> > 2) extend the network stack to have
> > IFF_LIVE_BUT_NO_CARRIER_ADDR_CHANGE
> >    or something like that
> 
> So you mean 2 is my only option... ;) I am fine with this.

:-)

I thought so, but I had another thought later. It might be possible to
set LIVE_ADDR_CHANGE, but then block it in mac80211 when the interface
is already connected (or beaconing, or whatever, using the MAC address
in some way - even while scanning, remain-on-channel is active, etc.)

I still think you'd have to bake it into the mac80211<->driver API
somehow, because we normally "add_interface()" with the MAC address, and
nothing says that the driver cannot ignore the MAC address from that
point on. The fact that iwlwifi just copies it into every new MAC_CTXT
command and the firmware actually accepts the update seems rather
accidental and therefore fragile to rely on.

> The iwlwifi change was just an example. It ultimately would be up to
> the maintainers of each driver to support this or not. 

Sure. I was just trying to say what I wrote one paragraph up.

> > You've also not really explained what exactly is troubling you with
> > changing the MAC address, you just mentioned some sort of "race
> > condition"?
> 
> In order to change the MAC on a per-AP/SSID is to: ifdown, change MAC,
> ifup via RTNL. The problem is that ifdown generates an RTNL link down
> event and there is no way of knowing how this event was generated (by
> you, hot-unplug, or some other issue in kernel?). Handling this without
> a race is simply not possible. You sort of just have to pray none of
> this happens (and its unlikely but it *could* happen).

I see, at least sort of. I'm having a hard time seeing how this really
is a problem in practice, but I suppose that's because I haven't tried
implementing a fully event-driven stack.

> The connect path is just what we (IWD) use for almost all types of
> connections that support it (apart from things like SAE/OWE/FT). Not
> sure what you mean for "usually not taken for iwlwifi"? If you have an
> iwlwifi card and you issue CMD_CONNECT thats the path it takes...

Interesting. I didn't think you'd do that, since it gives you far less
control over things, and you need the other paths anyway for the
features you mention, and the implementation in cfg80211 is far less
complete than a typical firmware implementation would be.

johannes

