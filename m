Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5F8C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 19:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6EFC218C3
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 19:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfDLT7p convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:59:45 -0400
Received: from d.mail.sonic.net ([64.142.111.50]:39648 "EHLO d.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbfDLT7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 15:59:45 -0400
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3CJmuFo023496
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Apr 2019 12:48:56 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
Date:   Fri, 12 Apr 2019 12:48:54 -0700
Cc:     Harald Welte <laforge@gnumonks.org>, openbsc@lists.osmocom.org,
        radiotap@netbsd.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Transfer-Encoding: 8BIT
Message-Id: <1089142F-2966-4C41-921B-465FBA721E79@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <20190410233213.GN25552@nataraja>
 <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVZH1aLfTAcWCJ+KlF6kvxo6D9pp4wphNG8VeOzu42LSA1ZTCrUVXpzadVOoo3lrlYuCxia1TKJ/AumdsljuX4PI
X-Sonic-ID: C;9HD0AVxd6RGzPaVsT+DgAQ== M;sq45Alxd6RGzPaVsT+DgAQ==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 12, 2019, at 5:24 AM, Johannes Berg <johannes@sipsolutions.net> wrote:

> On Thu, 2019-04-11 at 01:32 +0200, Harald Welte wrote:
> 
>> GSMTAP was designed as a format to encapsulate protocols normally not spoken over IP
>> (such as classic GSM radio protocols, e.g. the Layer 2 LAPDm over GSM Um)
>> inside an IP transport.
> 
> Sure, but wifi is also not spoken over IP, yet we don't encapsulate our
> 802.11 frames into IP to show them in wireshark :-)

That's just because the rpcap protocol hasn't been revved yet to handle the new create/set options/activate mechanism in libpcap to allow monitor-mode capturing, so you only get to see fake Ethernet frames. :-)

I.e., there's a split there between "capture" and "getting the packets from a capture delivered to you over an IP network".

Perhaps there should be a GSMTAP link-layer header type, so you can have a GSMTAP pcap file or GSMTAP interface in a pcapng file, combined with a more general "remote capture" mechanism in libpcap so that you could capture on gsmtap://host:port and capture from a host using the GSMTAP-over-UDP encapsulation - or capture using rpcap.

>> No userspace source would ever be able to generate such data and stream
>> it real-time into wireshark, would it?  Sure, I can write pcap file with
>> such ARPHDR_* values, but I could never do this in real-time.  For many
>> but not all use cases, that's really what it is: A vehicle to stream
>> real-time non-IP protocol traces into wireshark so it can visualize
>> the protocol traces.
> 
> I think you can pipe a stream into wireshark?

1) You could pipe into libpcap or otherwise have a way for a libpcap module to connect to a user space source and get packets from it.

2) You could pipe a pcap file into tcpdump/Wireshark/etc..

3) You could have an extcap program:

	https://www.wireshark.org/docs/wsdg_html_chunked/ChCaptureExtcap.html

provide packets to Wireshark.

> To me it feels like the wrong thing to actually make wireshark listen on
> "lo" or "eth0" or something to get data from the cellular that's
> (locally) generated by another application, but I guess that's only
> about how you think about it - and if it's not generated locally then
> that's an easy transport. I'm not sure it makes *sense* because then you
> need permissions to capture on the wired network etc.

Depending on how your system is set up:

	$ ls -l /dev/bpf*
	crw-rw----  1 root  access_bpf   23,   0 Apr 10 22:57 /dev/bpf0
	crw-rw----  1 root  access_bpf   23,   1 Apr 10 22:56 /dev/bpf1

		...

and it could just be rw-rw-rw-.  Perhaps other systems make it harder to grant capture privileges.

> where you don't *really* need that for this stream

If there's a need for that, whatever provides the packets could impose that (by finding out the UID/GID of the other process if this is going over a UNIX-domain socket, at least on some UN*Xes, or by requiring a login if this is going over a network).
