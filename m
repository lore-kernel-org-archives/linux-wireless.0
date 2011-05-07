Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63530 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1EGNit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 09:38:49 -0400
Subject: Re: How to disable TCP checksum calculation?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Clouter <alex@digriz.org.uk>,
	"Wu, Xia" <xia.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <ut8f98-hoj.ln1@chipmunk.wormnet.eu>
References: <A24AE1FFE7AEC5489F83450EE98351BF35079BA24F@shsmsx502.ccr.corp.intel.com>
	 <ut8f98-hoj.ln1@chipmunk.wormnet.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 15:38:36 +0200
Message-ID: <1304775516.2821.1253.camel@edumazet-laptop> (sfid-20110507_153907_142079_6BE32FF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le samedi 07 mai 2011 à 08:28 +0100, Alexander Clouter a écrit :


> Wu, Xia <xia.wu@intel.com> wrote:
> >
> > I'm studying TCP transporting efficiency. Now I want to disable TCP 
> > checksum calculation, but I cannot find the right way to disable it. 
> > Who can give me a help on how to disable TCP checksum on Linux?
> > 
> Look at using TCP checksum offloading to see the effects:
> 
> http://en.wikipedia.org/wiki/TCP_Offload_Engine
> 
> ----
> berk:/home/alex# ethtool -k eth0
> Offload parameters for eth0:
...


Not sure what We meant here. TCP standard requires checksums to be set,
you cannot 'disable it'. Only possible thing in linux stack is to
offload tcp checksum computation to network card, if hardware permits
it.

By the way, the loopback interface (lo) pretends to support this
feature, so we dont compute tcp checksums for loopback.



