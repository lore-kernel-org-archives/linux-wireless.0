Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36200 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0AZO1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 09:27:34 -0500
To: Dunc <dunc@lemonia.org>
Cc: David Miller <davem@davemloft.net>, kaber@trash.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
References: <877hr5nkx0.fsf@purkki.valot.fi>
	<20100126.041610.226004766.davem@davemloft.net>
	<87wrz5m3cd.fsf@purkki.valot.fi>
	<20100126.050645.184040277.davem@davemloft.net>
	<87my01m0zm.fsf@purkki.valot.fi> <4B5EF5DF.2070005@lemonia.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 26 Jan 2010 16:27:29 +0200
In-Reply-To: <4B5EF5DF.2070005@lemonia.org> (dunc@lemonia.org's message of "Tue\, 26 Jan 2010 14\:02\:07 +0000")
Message-ID: <87iqaplz5a.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dunc <dunc@lemonia.org> writes:

> If applications set the QoS values, the who's to stop someone (for
> example) writing a bittorrent client that marks all packets for the
> highest priority as if they were VoIP or something?

Nobody. That would a bug in the application which should be fixed.
Badly behaving applications can disrupt the network, with or without
QoS support. So no need to blame QoS for this.

And if the network doesn't want to trust applications, it's free to do
so. Nothing prevents that. And based on the discussion so far, the
networks already ignore QoS classifations coming from other network
realms.

> At this point all the good work done in the applications is useless
> and the network admin is going to have to not trust the QoS values
> and then attempt to classify traffic by themselves, so it was all a
> waste of time.

Because of one badly behaving application? I think that's a bit
extreme. If QoS API brings benefits to the user (for example in this
case bittorrent giving bandwith to more important streams), most
probably applications try to get it right.

> It's probably better to just always leave it up to the network devices IMHO.

If we are happy with the current situation, sure, no need to do
anything. But if we want to improve network services, we need to start
to do something about this.

I want to emphasise that we shouldn't look at this just from the core
network point of view, but with a broader look. We have now different
network technologies and devices where Linux is used. We should not
just look at this from a point where a Linux workstation (or router)
is connected with a fast access to Internet. For example, I want to
have my ssh terminal connection higher priority compared to emails
downloading background on a slow cellular network.

-- 
Kalle Valo
