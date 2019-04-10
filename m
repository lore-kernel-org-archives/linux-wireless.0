Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38426C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D83206B7
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfDJH5J convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:57:09 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:48127 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfDJH5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 03:57:08 -0400
Received: from marcel-macpro.fritz.box (p4FF9F4D8.dip0.t-ipconnect.de [79.249.244.216])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1CAE8CEE9A;
        Wed, 10 Apr 2019 10:05:13 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: gsmtap design/extensions?
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
Date:   Wed, 10 Apr 2019 09:57:06 +0200
Cc:     Vadim Yanitskiy <axilirator@gmail.com>,
        Harald Welte <laforge@gnumonks.org>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <6F1998DC-EFD2-4145-BD81-A80F9DC7ED2D@holtmann.org>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

>> FYI, there already was a discussion about GSMTAPv3:
>> 
>> https://www.youtube.com/watch?v=vum9jzavZi0&list=PL07C78AF831FFE8F9&index=10
>> 
>> but unfortunately, nobody has invested time into this (yet?).
> 
> 2012! But, umm, I don't really have time for a whole video right now -
> anyone have the slides? :-)
> 
> But yeah, the first slides look sensible :-)
> 
>>> 1) Why the design with encapsulating it in UDP?
>> 
>> This gives us a possibility to "demux" multiple GSMTAP streams on the
>> receiving side, e.g. if you are running multiple processes.
> 
> Not sure I get this, but I also don't really care all that much. It's
> just a pretty strange design if the kernel were to output this, I'm not
> even sure how I'd do that properly. I don't want to be generating UDP
> packets there...
> 
> Perhaps we can define something (GSMTAPv3) to not really care how it's
> encapsulated, and for 'native' packet captures like what I want on Linux
> when integrated with the driver, actually use an ARPHDR_GSMTAP, and
> encapsulate in UDP when you create it in an application and want to send
> it elsewhere, rather than just writing it to a pcap file?

before you go all out and define this, it would suggest to understand what meta-data for the connection contexts you actually need as well. The data path itself is just a pipe and has not all the information attached with it. That goes via the control path and that is normally in user space and carries the real important information to make useful analysis of how the data path / context is setup.

From what I am seeing right now is that unless you have a method to also feed the control path into your GSMTAPv3, then this is rather useless. The majority of the debugging is really done for the control path. For oFono that is OFONO_DEBUG=1 environment variable and while it works it is not the most elegant solution. I would love to feed that into a generic debugging / tap that you can read out later.

As a side note, for Bluetooth we created a path where the bluetoothd can feed back its control debugging data back into the Bluetooth monitor in the kernel to allow combined userspace, mgmt and HCI tracing. Some really nasty issues could only be triaged by having all the meta data with a common timestamp.

Regards

Marcel

