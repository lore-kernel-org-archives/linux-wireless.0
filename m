Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate1.ipvision.dk ([94.127.49.2]:59123 "EHLO gate1.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0A0Npd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 08:45:33 -0500
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Dunc <dunc@lemonia.org>
Cc: Kalle Valo <kalle.valo@iki.fi>, David Miller <davem@davemloft.net>,
	kaber@trash.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
References: <877hr5nkx0.fsf@purkki.valot.fi>
	<20100126.041610.226004766.davem@davemloft.net>
	<87wrz5m3cd.fsf@purkki.valot.fi>
	<20100126.050645.184040277.davem@davemloft.net>
	<87my01m0zm.fsf@purkki.valot.fi> <4B5EF5DF.2070005@lemonia.org>
Date: Wed, 27 Jan 2010 14:24:28 +0100
In-Reply-To: <4B5EF5DF.2070005@lemonia.org> (dunc@lemonia.org's message of
	"Tue, 26 Jan 2010 14:02:07 +0000")
Message-ID: <m3636nd6k3.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dunc <dunc@lemonia.org> writes:

> If applications set the QoS values, the who's to stop someone (for
> example) writing a bittorrent client that marks all packets for the
> highest priority as if they were VoIP or something?

Nothing, but nothing stops them from writing a bittorrent client which
does "optimistic ACK" either. Yet noone seems to bother.

Also, bittorrent marked as EF could easily get hit by a "don't queue
voice packets, just drop instead" policy. Late voice packets are useless
and might as well be dropped, but TCP streams like bittorrent react
badly to packet loss.

All in all there is little incentive for people to game the system.
Should it happen anyway, network administrators have plentiful tools for
fixing it, up to and including ip link set dev whatever down.


/Benny

