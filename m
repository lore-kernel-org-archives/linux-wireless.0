Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41386 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbZKRV6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:58:10 -0500
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
 why?
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Acker <dacker@roinet.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	 <4B02DFF4.1060509@roinet.com>
	 <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
	 <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	 <4B03193E.2080304@roinet.com>
	 <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	 <4B031B48.1090105@roinet.com>
	 <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	 <4B032390.3080501@roinet.com> <20091117225408.GA20540@jm.kir.nu>
	 <43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 Nov 2009 16:58:12 -0500
Message-Id: <1258581492.10593.24.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-11-17 at 15:12 -0800, Luis R. Rodriguez wrote:
> On Tue, Nov 17, 2009 at 2:54 PM, Jouni Malinen <j@w1.fi> wrote:
> 
> > Supporting half/quarter width channels sounds reasonable in general. The
> > main problem with this one seems to have been in getting someone
> > dedicated enough to go through the effort in a way that would cleanly
> > extend the regulatory framework in use with cfg80211.
> 
> I'll elaborate on this part.
> 
> There actually is no requirement to extend the regulatory framework to
> get this done.

I think we should try to err on the safe side when dealing with
regulations.

CRDA regulates the frequencies allocated for 802.11 protocol.  Part of
the protocol is collision avoidance using RTS/CTS.

Stations using half and quarter channels won't see standard width
control frames.  Likewise, standard stations won't be able to interpret
any narrow channel traffic.  Thus, the stations using different channel
width affect each other as dumb noise emitters, somewhat like bluetooth
and even microwave ovens.

My impression is that many new bands are allocated for 802.11 under
strict conditions, such as power limits, DFS and TPC.  TPC in particular
is designed to reduce interference between networks.

Is it true that no country limits transmissions in any band to the
standard channel width?  Can we reasonably rely on things staying that
way?

-- 
Regards,
Pavel Roskin
