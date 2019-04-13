Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80436C282CE
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6C02084D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfDMHkG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 03:40:06 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41147 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfDMHkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 03:40:06 -0400
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.84_2)
        (envelope-from <laforge@gnumonks.org>)
        id 1hFDGe-0007mm-3t; Sat, 13 Apr 2019 09:40:04 +0200
Received: from laforge by nataraja.lan with local (Exim 4.92)
        (envelope-from <laforge@gnumonks.org>)
        id 1hFDBp-0008OA-LX; Sat, 13 Apr 2019 09:35:05 +0200
Date:   Sat, 13 Apr 2019 09:35:05 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     openbsc@lists.osmocom.org, radiotap@netbsd.org,
        linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: gsmtap design/extensions?
Message-ID: <20190413073505.GD24451@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <20190410233213.GN25552@nataraja>
 <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

I'll only adress some of the points that haven't been clarified in other
mails in this thread alreasdy:

On Fri, Apr 12, 2019 at 02:24:25PM +0200, Johannes Berg wrote:

> Kernel drivers need to transport multiple data streams, like VoLTE (IP)
> data, IP data, and control data. Currently, they do this in various ways
> (cdc_mbim uses VLAN tags, rmnet/qmi_wwan uses Qualcomm QMI headers),
> when you capture data you have to understand what you're dealing with
> and maybe extend wireshark to even understand these headers.
> 
> I'm looking for a general vendor-agnostic encapsulation that would solve
> this part of the problem.

understood.

> At the same time, I come from WiFi, where - while we don't have these
> sessions as such but can have different virtual interfaces as well, e.g.
> for connections to different APs - it's often very useful to also
> understand the PHY parameters that were used for TX/seen on RX. Now, I
> realize this isn't something that modems will do right now - they just
> don't seem to tell you any lower-level information on RX of a packet,
> but it seemed like it might be worthwhile to not *exclude* this
> possibility either.

Agreed.  However, the protocol stacks on WiFi and cellular technologies
are very different, to say the least.  There is no easy mapping of PHY
related parameters to a given IP packet, and the related quality metrics
of the radio channels don't work that way.

But yes, I agree, that whatever transport mechanism you wan to use between the modem
and the user/Linux side should allow for additional, extensible metadata beyond
the identifier of the PDP/PDN context.

> > GSMTAP was designed as a format to encapsulate protocols normally not spoken over IP
> > (such as classic GSM radio protocols, e.g. the Layer 2 LAPDm over GSM Um)
> > inside an IP transport.
> 
> Sure, but wifi is also not spoken over IP, yet we don't encapsulate our
> 802.11 frames into IP to show them in wireshark :-)

This is because your 802.11 implementations are in hardware, while the
open source GSM/UMTS/LTE implementations using GSMTAP are implemented in
userspace - or at the very least the higher-level parts of the protocol
stacks, or the tracing frameworks that are used to generate the GSMTAP
data from some hardware.

> This is the part I guess I don't understand. I haven't really tried, but
> it seems you should be able to encapsulate arbitrary protocols into
> 802.3 OUI-based ethertype or so?

But why?  I'm in an userspace program, and I want to send data to one or
more other userspace programs.  Why would I not simply open a UDP socket
to do so?  I would have to have CAP_NET_RAW and open a packet socket,
and then generate ethernet frames from that?

I admit that the use case with wireshark is a bit odd, but there are
other receivers out there.

Also, for debugging cellular network elements, it's very useful if you
can look at the RAN or core network interfaces (Abis, Gb, Gp, A, Iu, S1,
...) in the same protocol trace in which you also get traces from the
radio interface in GSMTAP.  Then you can see what happens at each and
every interface / network element in one time-line.

And as the Osmcoom programs also allow generating log output wrapped in
GSMTAP, you get not only protocol traces of all the interfaces, but even
textual log information (with machine-readable log level + sub-system)
information all in one capture/timeline.

> But I guess if your primary use case is actually to transport them over
> the network, this makes more sense.

The use cases differ, but having UDP encapsulation enables a lot of
flexibility and has been proven very useful so far.

> Our primary use case with wifi is much more local - capture what's going
> on - but do the capturing on the local system and write it to a file
> there.

Yes, you're looking only at a single interface (the radio interface
between one BSS and one STA).  You're not looking at five different
interfaces at five different levels of network hierarchy/topology in the "wifi
controller" and want to mix in a radio interface trace in the same
timeline.

> > We also have a virtual physical layer between OsmocomBB and OsmoBTS called
> > virt_phy where the GSMTAP over multicast IP is used to simulate/virtualize
> > the entire Layer1 / PHY / radio interface between phone and base station.
> > 
> > Once again, all related network elements are implemented in userspace,
> > and having an 
> 
> ...?

sorry. '... UDP based transport is ahat enables theis use case'

> Basically, I was looking at it as if it was like WiFi in a sense - you
> have an IP frame, you're going to transport it over some physical link,
> so it gets PHY information in the sense of modulation etc.

As stated elsewhere, there's an M:N mapping between user (IP) payload
and actual radio interface "MAC blocks", so I'm not aware of anyone
mapping radio interface performance to user plane IP.

> That doesn't seem to be the case for GSM, I guess? Does the IP frame get
> encapsulated in some kind of 3GPP message first, and then transported
> over the physical link, and the physical link info isn't even there in
> GSMTAP?

the "physical link info" is present in GSMTAP, but the granularity of
GSMTAP frames is not user-IP frames, but "MAC blocks".  So your user IP
frame might not be visible as it's still compressed, encrypted,
fragmented, etc.

> > > Or would it make more sense to define a new ARPHDR_WWANTAP like
> > > ARPHDR_IEEE80211_RADIOTAP and just use that instead of encapsulating in
> > > IP/UDP, and then have a completely new (extensible) protocol inside of
> > > that? 
> > 
> > No userspace source would ever be able to generate such data and stream
> > it real-time into wireshark, would it?  Sure, I can write pcap file with
> > such ARPHDR_* values, but I could never do this in real-time.  For many
> > but not all use cases, that's really what it is: A vehicle to stream
> > real-time non-IP protocol traces into wireshark so it can visualize
> > the protocol traces.
> 
> I think you can pipe a stream into wireshark?
> 
> To me it feels like the wrong thing to actually make wireshark listen on
> "lo" or "eth0" or something to get data from the cellular that's
> (locally) generated by another application, 

I admit it's a bit odd.  But has been very useful, particularly in more
distributed setups with creating a shared timeline of various GSMTAP
sources that may or may not run on the same machine.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
