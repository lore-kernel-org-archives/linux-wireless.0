Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD1BC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 13:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BDB52084C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 13:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfDINu4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:50:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50414 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDINu4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 09:50:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDr9E-0006VD-BY; Tue, 09 Apr 2019 15:50:48 +0200
Message-ID: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
Subject: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     laforge@gnumonks.org, openbsc@lists.osmocom.org
Cc:     radiotap@netbsd.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Date:   Tue, 09 Apr 2019 15:50:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

As I'm looking into adding a generic cell modem framework to the linux
kernel (to create session netdevs etc.), I started looking for a
metadata encapsulation, a la Radiotap (I'm a wifi guy :-) ).

So obviously, I found gsmtap, but for my use case it doesn't really
address most of the interesting data, and it got me wondering. So a few
questions, if I may:

1) Why the design with encapsulating it in UDP? Radiotap is just a raw
   header without IP etc. in front, and you use it with tcpdump,
   wireshark or similar tools on the local system. What's the value in
   having something "network transparent"?

2) The format of gsmtap doesn't seem very extensible, but I guess a new
   version could be made that has a TLV-based format or so. I'd have
   argued that a new version isn't even needed, but the length field is
   only 8 bits right now which seems too short.

(speaking of versions - the docs say "version, set to 0x01 currently"
but "#define GSMTAP_VERSION 0x02")

3) Does the packet data follow the gsmtap header? It's not really clear
   to me based on reading the wireshark code.


In particular, the data I'm thinking of is higher-level things, like the
session ID for a frame when it's going through the kernel, or perhaps a
flow label on RX, etc.

Also, vendor-specific data would be useful, e.g. to encapsulate the
device-specific headers like QMI, where such metadata is encapsulated in
a vendor- or device-specific way, which you'd want to see for debugging
certain things, but for other things the generic "session ID" type
information - encoded in a vendor-agnostic way - would be better to show
in wireshark.


Since it doesn't seem possible to use gsmtap in the current version,
would it make sense to define a new gsmtap that (say) has version 3 or
something, followed by an overall length and TLVs? I do note that this
wouldn't be compatible with the current wireshark code as it doesn't
check the version, just shows it...

Or would it make more sense to define a new ARPHDR_WWANTAP like
ARPHDR_IEEE80211_RADIOTAP and just use that instead of encapsulating in
IP/UDP, and then have a completely new (extensible) protocol inside of
that? I'm not really sure I see the point of UDP encapsulation anyway.

Thanks,
johannes

