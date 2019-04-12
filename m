Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F48EC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F7F220818
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfDLMYi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:24:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47044 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfDLMYi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:24:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEvEJ-0007Nz-48; Fri, 12 Apr 2019 14:24:27 +0200
Message-ID: <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
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
Date:   Fri, 12 Apr 2019 14:24:25 +0200
In-Reply-To: <20190410233213.GN25552@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <20190410233213.GN25552@nataraja>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-11 at 01:32 +0200, Harald Welte wrote:
> Hi Johannes,
> 
> On Tue, Apr 09, 2019 at 03:50:45PM +0200, Johannes Berg wrote:
> > As I'm looking into adding a generic cell modem framework to the linux
> > kernel (to create session netdevs etc.), I started looking for a
> > metadata encapsulation, a la Radiotap (I'm a wifi guy :-) ).
> 
> Is there any discussion about "session netdevs, etc." anywhere?  What exactly
> do you have in mind for that "generic cell modem framework"?  I'm quite
> curious to learn more about it and happy to provide feedback from the
> perspective of my cellular protocols/specs/systems knowledge.

Yeah. I was too much in my little bubble when I wrote this. I just wrote
a lengthy reply to Marcel that explains a little more, but basically to
summarize:

Kernel drivers need to transport multiple data streams, like VoLTE (IP)
data, IP data, and control data. Currently, they do this in various ways
(cdc_mbim uses VLAN tags, rmnet/qmi_wwan uses Qualcomm QMI headers),
when you capture data you have to understand what you're dealing with
and maybe extend wireshark to even understand these headers.

I'm looking for a general vendor-agnostic encapsulation that would solve
this part of the problem.

At the same time, I come from WiFi, where - while we don't have these
sessions as such but can have different virtual interfaces as well, e.g.
for connections to different APs - it's often very useful to also
understand the PHY parameters that were used for TX/seen on RX. Now, I
realize this isn't something that modems will do right now - they just
don't seem to tell you any lower-level information on RX of a packet,
but it seemed like it might be worthwhile to not *exclude* this
possibility either.

> > 1) Why the design with encapsulating it in UDP? Radiotap is just a raw
> >    header without IP etc. in front, and you use it with tcpdump,
> >    wireshark or similar tools on the local system. What's the value in
> >    having something "network transparent"?
> 
> GSMTAP was designed as a format to encapsulate protocols normally not spoken over IP
> (such as classic GSM radio protocols, e.g. the Layer 2 LAPDm over GSM Um)
> inside an IP transport.

Sure, but wifi is also not spoken over IP, yet we don't encapsulate our
802.11 frames into IP to show them in wireshark :-)

> The existing implementations of such protocols all live outside of the
> kernel but in userspace.  So you either have
> 
> a) a pure SDR software implementation of a GSM phy, whether on the MS/UE
>    side or on the BTS/network side, or whether in sniffing mode, running
>    as a userspace process.  This could e.g. be airprobe or gr-gsm
> 
> b) a OsmocomBB phone attached over serial port running the Osmocom Layer1
>    firmware on the baseband processor, with some userspace program on a Linux
>    PC implementing higher layers
> 
> c) GSM base station software such as osmo-bts, running in userspace
> 
> d) Using an old nokia phone attached via serial cable to a Linux PC running
>    dct3-gsmtap.

Sure.

> So for any of those, if you want to provide real-time data streams, you have to
> somehow transmit those over some kind of network technology.   One could have
> done raw ethernet frames or raw IP frames, but using UDP seemed straight-forward
> as one can create UDP socket from non-privileged processes.

This is the part I guess I don't understand. I haven't really tried, but
it seems you should be able to encapsulate arbitrary protocols into
802.3 OUI-based ethertype or so?

But I guess if your primary use case is actually to transport them over
the network, this makes more sense.

Our primary use case with wifi is much more local - capture what's going
on - but do the capturing on the local system and write it to a file
there.

> We also have a virtual physical layer between OsmocomBB and OsmoBTS called
> virt_phy where the GSMTAP over multicast IP is used to simulate/virtualize
> the entire Layer1 / PHY / radio interface between phone and base station.
> 
> Once again, all related network elements are implemented in userspace,
> and having an 

...?

> > (speaking of versions - the docs say "version, set to 0x01 currently"
> > but "#define GSMTAP_VERSION 0x02")
> 
> Sorry, it's the usual "developer changes code but not comment". patches
> are welcome, we use gerrit.osmocom.org :)

Ok :-)

> > 3) Does the packet data follow the gsmtap header? It's not really clear
> >    to me based on reading the wireshark code.
> 
> Sure, the packet data follows the GSMTAP header, and the type of data
> is defined by the GSMTAP type / sub-type as per the specific use case.  As
> you can see, there's 18 TYPE by now (each of which has at least one
> program/implementation generating the data).

Right.

> I think the best way to learn about GSMTAP is to use any of the many
> programs that support it by now.  I think not only the examples above
> use it, but meanwhile many others like the independently-developed OpenBTS
> project that's unrelated to Osmocom, as are other projects implementing LTE.

OK.

> > In particular, the data I'm thinking of is higher-level things, like the
> > session ID for a frame when it's going through the kernel, or perhaps a
> > flow label on RX, etc.
> 
> I'm not quite sure how that relates to GSM?  GSMTAP so far was intended
> to encapsulate ETSI/3GPP messages inside UDP/IP, particularly messages of
> protocols that don't traditionally are transported over IP baesd transports.

Yeah, I think here's where I got confused or just don't know enough
about GSM.

Basically, I was looking at it as if it was like WiFi in a sense - you
have an IP frame, you're going to transport it over some physical link,
so it gets PHY information in the sense of modulation etc.

That doesn't seem to be the case for GSM, I guess? Does the IP frame get
encapsulated in some kind of 3GPP message first, and then transported
over the physical link, and the physical link info isn't even there in
GSMTAP?

> Having said, we're open to extending the scope - it just all needs to make
> sense

See above for a bit better description of what I'm trying to solve.

> > I do note that this
> > wouldn't be compatible with the current wireshark code as it doesn't
> > check the version, just shows it...
> 
> If that's the case that's sad, and I should have paid more attention to
> it when originally writing it.  We should get a related fix into
> wireshark ASAP then.  But then, the current dissector would just state
> something like unsupported version instead of showing some garbage it
> cannot parse.  Either way, you will of course need new sources and
> sink side implemetations.

Sure. Just a note in passing.

> > Or would it make more sense to define a new ARPHDR_WWANTAP like
> > ARPHDR_IEEE80211_RADIOTAP and just use that instead of encapsulating in
> > IP/UDP, and then have a completely new (extensible) protocol inside of
> > that? 
> 
> No userspace source would ever be able to generate such data and stream
> it real-time into wireshark, would it?  Sure, I can write pcap file with
> such ARPHDR_* values, but I could never do this in real-time.  For many
> but not all use cases, that's really what it is: A vehicle to stream
> real-time non-IP protocol traces into wireshark so it can visualize
> the protocol traces.

I think you can pipe a stream into wireshark?

To me it feels like the wrong thing to actually make wireshark listen on
"lo" or "eth0" or something to get data from the cellular that's
(locally) generated by another application, but I guess that's only
about how you think about it - and if it's not generated locally then
that's an easy transport. I'm not sure it makes *sense* because then you
need permissions to capture on the wired network etc. where you don't
*really* need that for this stream, but it's convenient for sure.

johannes

