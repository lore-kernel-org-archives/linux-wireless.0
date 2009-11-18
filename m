Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:36875 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbZKRWIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 17:08:32 -0500
Received: by iwn8 with SMTP id 8so1257700iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 14:08:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258581492.10593.24.camel@mj>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	<4B03193E.2080304@roinet.com> <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	<4B031B48.1090105@roinet.com> <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	<4B032390.3080501@roinet.com> <20091117225408.GA20540@jm.kir.nu>
	<43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
	<1258581492.10593.24.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 18 Nov 2009 14:08:16 -0800
Message-ID: <43e72e890911181408r43dadf7av277b255eb9007481@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: Pavel Roskin <proski@gnu.org>
Cc: David Acker <dacker@roinet.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 1:58 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2009-11-17 at 15:12 -0800, Luis R. Rodriguez wrote:
>> On Tue, Nov 17, 2009 at 2:54 PM, Jouni Malinen <j@w1.fi> wrote:
>>
>> > Supporting half/quarter width channels sounds reasonable in general. The
>> > main problem with this one seems to have been in getting someone
>> > dedicated enough to go through the effort in a way that would cleanly
>> > extend the regulatory framework in use with cfg80211.
>>
>> I'll elaborate on this part.
>>
>> There actually is no requirement to extend the regulatory framework to
>> get this done.
>
> I think we should try to err on the safe side when dealing with
> regulations.
>
> CRDA regulates the frequencies allocated for 802.11 protocol.

Well we are only listing frequency ranges which the kernel can make
use of for 802.11 as that is what we use it for on the kernel. But if
wimax/bluetooth want to add some frequency range they can perfectly do
so.

> Part of the protocol is collision avoidance using RTS/CTS.

Don't see how this relates to regulatory rules.

> Stations using half and quarter channels won't see standard width
> control frames.  Likewise, standard stations won't be able to interpret
> any narrow channel traffic.  Thus, the stations using different channel
> width affect each other as dumb noise emitters, somewhat like bluetooth
> and even microwave ovens.
>
> My impression is that many new bands are allocated for 802.11 under
> strict conditions, such as power limits, DFS and TPC.  TPC in particular
> is designed to reduce interference between networks.
>
> Is it true that no country limits transmissions in any band to the
> standard channel width?  Can we reasonably rely on things staying that
> way?

So for now countries either take the FCC, are part of a larger group
like in Europe or are a head ache to deal with due to historical
changes on regulatory rules (Japan). So far I've seen rules set for
bands and with max EIRP and antenna gain. Sometimes you have quirky
rules for antenna gain like in the US for the 3:1 rule (but we don't
yet allow you to modify your antenna on linux and specific your new
dbi antenna gain, and this actually is assumed won't change on the
client side).

For width I'm told some countries do not allow HT40 and that this
should change in the future.

I haven't seen rules for finer level of control which is why I said I
we should not need to change anything. Right now  I've only have heard
of countries sometimes disallowing HT40, but that's it.

Are you aware of any regulatory rules which prohibit narrower
channels? It just seems odd.

  Luis
