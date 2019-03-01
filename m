Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44B2C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 08:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5512085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 08:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfCAIcm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:32:42 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCAIcm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 03:32:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gzdae-0007qz-1l; Fri, 01 Mar 2019 09:32:20 +0100
Message-ID: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of
 tx_status frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Julius Niedworok <julius.n@gmx.net>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-wireless@vger.kernel.org, ga58taw@mytum.de,
        David Hildenbrand <david@redhat.com>, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 01 Mar 2019 09:32:18 +0100
In-Reply-To: <AD1F7A49-B3F3-4033-8B0A-D1F8C2C6C834@gmx.net> (sfid-20190228_100617_950752_7E2B5208)
References: <20190226094104.35192-1-julius.n@gmx.net>
         <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
         <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net>
         <550ff2ac45c891a3fcf3dd8a454f9732d8aa1b70.camel@sipsolutions.net>
         <AD1F7A49-B3F3-4033-8B0A-D1F8C2C6C834@gmx.net>
         (sfid-20190228_100617_950752_7E2B5208)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Let us briefly describe our test setup to ensure everyone on this mailing
> list is one the same page.
> 
> Our general setup looks like this:
> 1 $ iw wlp1s0 info
> Interface wlp1s0
>       ifindex 5
>       wdev 0x1
>       addr 4c:5e:0c:11:43:ac
>       type managed
>       wiphy 0
>       txpower 30.00 dBm
> 1 $ iw phy phy0 interface add mon0 type monitor
> 1 $ iw phy phy0 interface add mon1 type monitor
> 
> When we send (raw) packets on mon0 using packetspammer [1] and listen on
> the _other_ monitor mode interface mon1, we receive frames that were sent
> on the first one:
> 1 $ packetspammer mon0
> 2 $ tcpdump -i mon1 'wlan addr2 13:22:33:44:55:66'
> 
> This is due to the fact that frames sent on mon0 are echoed back as TX
> status frames, because REQ_TX_STATUS is always set for frames sent from
> monitor mode interfaces.

Yes, I understand :-)

> But when we replace mon0 with an interface in managed mode (wlp1s0), the
> receipt of frames stops, because in managed mode REQ_TX_STATUS is cleared
> in most frames:
> 1 $ ifup wlp1s0
> 1 $ ping -I wlp1s0 192.168.254.1 # this address is not assigned to any host
> 2 $ tcpdump -i mon1 ‚wlan addr2 4c:5e:0c:11:43:ac‘

Yes, also understand.

> > What you're proposing is to use IFF_ECHO to show frames transmitted
> > through *other* interfaces on the monitor interface.
> > 
> > I don’t think the IFF_ECHO semantics really match this.
> 
> What we propose is to use IFF_ECHO to force REQ_TX_STATUS being set for all
> frames sent on the interface. But you are right: The goal is that frames
> transmitted through the other interface show up on the monitor interface
> (but only after passing the driver). However, this is exactly how we
> understand the semantics of IFF_ECHO in the kernel documentation.

I disagree.

First of all, IFF_ECHO is only documented/used *inside* the kernel, and
cannot be set by userspace today. It's documented by CAN as such:

Documentation/networking/can.rst:

   Local Loopback of Sent Frames
   -----------------------------

   As described in :ref:`socketcan-local-loopback1` the CAN network
   device driver should
   support a local loopback functionality similar to the local echo
   e.g. of tty devices. In this case the driver flag IFF_ECHO has to be
   set to prevent the PF_CAN core from locally echoing sent frames
   (aka loopback) as fallback solution::

       dev->flags = (IFF_NOARP | IFF_ECHO);

   Note that everything here is specific to a single interface.

   Also note that it's a signal from the *driver* to the *stack* to not do
   the loopback itself, because the driver will do it.

   I think in the case of all other sockets/interfaces, the stack will do
   the echo anyway, for tcpdump etc. purposes.

   The documentation in the uapi just states:
     @IFF_ECHO: echo sent packets. Volatile.
   and makes no representation about which interface, but I'd argue that
   all the flags are specific to a single interface and thus you'd expect
   this to also be.


   Thus, I don't think this was ever intended for any cross-interface
   behaviour, even if it may be on the same physical NIC.


   > As far as we know, drivers must return a TX status frame, if REQ_TX_STATUS
> is set, but can do whatever they want, if it is clear.

Not all drivers can and do this, I believe. Some things don't work very
well if they don't do it, but I _think_ you've just been lucky and used
hardware that does in fact support it.

Also note that for some hardware that does support this, there's
sometimes significant overhead - not just the performance overhead of
actually reporting the frames, but sometimes also overhead in how the
hardware is programmed and used, and how TX status is extracted.

> This is no problem for our
> functionality, because we force the delivery of TX status frames by
> permanently setting REQ_TX_STATUS. As long as the semantics of
> REQ_TX_STATUS remains like it is now, the functionality will always be
> as expected from our API.

Sure, for now, for your specific case of ath9k :-)

> We could also achieve the functionality by modifying the drivers but this
> would mean that we had to add this functionality to every driver.
> Moreover, the feature of TX status frames, how it is implemented currently
> for monitor mode interfaces, is part of the mac80211 implementation. The
> decision to force TX status frames for monitor mode interfaces is made in
> the common mac80211 implementation.

I suppose it could be in mac80211 (perhaps debugfs?) too. I just really
don't think IFF_ECHO is the right approach.

johannes

