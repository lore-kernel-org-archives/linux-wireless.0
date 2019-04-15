Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B622C10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139A62070D
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mork.no header.i=@mork.no header.b="Gx4zXUEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfDOK3o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:29:44 -0400
Received: from canardo.mork.no ([148.122.252.1]:58271 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfDOK3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:29:44 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x3FATACi011192
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 12:29:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1555324152; bh=ZUwwzFpwn0RRWe35hkDYzhY8T2o7sok5wK9SV9zz9A8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Gx4zXUEjjFNCxfS3SM5gqkkllghZz82jb06h5D+KAcalkBNMwWoLpNS/+0zEJh9Oj
         J7b7iJlsL1Cw+3bbG6OMQxIrfMLOTVBrvJqjUHYMrgYawHDy38Nn4KwR8VmZLwaUXd
         DFgy5RO6F/1z+4SwCDSnWGhlk140npjYu9T+MMek=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1hFyrN-0003ZD-Pz; Mon, 15 Apr 2019 12:29:09 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        Harald Welte <laforge@gnumonks.org>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "open list\:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: gsmtap design/extensions?
Organization: m
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
        <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
        <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
        <6F1998DC-EFD2-4145-BD81-A80F9DC7ED2D@holtmann.org>
        <1d64c578cd5b254d301cf1cac82f32a062916888.camel@sipsolutions.net>
        <D4D12CF9-9CE5-46FB-9738-F89DB6B6F9EA@holtmann.org>
        <92e8e142b6d441c1c995abc57d64ad7b7747a688.camel@sipsolutions.net>
Date:   Mon, 15 Apr 2019 12:29:09 +0200
In-Reply-To: <92e8e142b6d441c1c995abc57d64ad7b7747a688.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 15 Apr 2019 11:11:54 +0200")
Message-ID: <87d0ln1s0a.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

>> As I said, as long as you do not get the QMI, AT command, MBIM etc.
>> control path session recorded as well, you have nothing to really
>> analyze.
>
> But you do - afaict there are no ways other than the netdevs to
> communicate with the device,

I don't understand where you are going here? Neither QMI, AT command nor
MBIM management are transported over netdevs. AT is usually transported
using simple USB bulk streams, exported to userspace as tty devices by
some USB serial driver.  Both QMI and MBIM management are transported as
USB control messages, and exported to userspace as chardevs.  There are
no netdevs involved.

> and people do things like "socat" to set up
> PTYs and pretend to have serial channels there, on top of the netdevs?

I assume you are referring to my MBIM DSS examples here.  I don't know
if anyone is actually using that, so you should probably ignore it...
I'll happily admit it was a bad idea.  Should have just added the
necessary code to map DSS channels to some sort of character device in
the driver, like most users requested.

But there really isn't anything in the MBIM spec saying how DSS should
be used. DSS is a generic data stream.  Could easily be connected to a
single TCP session for example, in which case you'd probably want to
connect it to a TCP session in the other end too.  So I wouldn't want to
force DSS into character devices on the host end.  This doesn't rule out
a userspace controlled optional mapping though. We could probably still
add that, replacing the VLAN mapping with a chardev for a specific DSS
session if requested by userspace.  I guess this is something to
consider for a generic cellular framework - supporting non-ip data
streams between modem and host.

Adding to my previous excuses: The DSS implementation in the cdc_mbim
driver was added without having seen a single modem firmware with *any*
type of DSS support.  It was purely based on spec{ification,culation}.
The VLAN mapping, along with examples of how to use socat to further map
the streams from VLANs into suitable application specific forms, seemed
like a simple and flexible enough solution.


Bj=C3=B8rn
