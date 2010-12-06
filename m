Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15331 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0LFTxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 14:53:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 11:53:01 -0800
Date: Mon, 6 Dec 2010 11:53:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
Message-ID: <20101206195313.GE21442@tux>
References: <4CF44543.9070605@candelatech.com>
 <20101130004424.GC1901@tux>
 <4CF6D8C8.2000308@candelatech.com>
 <4CF8A6DE.4020804@candelatech.com>
 <4CFAFBE1.3080505@openwrt.org>
 <4CFB20BA.5090300@candelatech.com>
 <20101206193600.GC21442@tux>
 <4CFD3DE3.4000207@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CFD3DE3.4000207@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 06, 2010 at 11:47:47AM -0800, Ben Greear wrote:
> On 12/06/2010 11:36 AM, Luis R. Rodriguez wrote:
> 
> > Can you clarify the status of this issue. It remains unclear to me from
> > your above description how things are going. As I read it some things
> > look OK now but you still get a warning.
> 
> Ok, since you asked :)
> 
> I worked on this over the weekend and this morning.  I had all sorts of
> issues until I realized that I had one STA with non-configured SSID.
> It sometimes connected to one /a AP and the other STAs attempted to connect
> to another /n (on entirely different band) AP.  I basically got zero stations associated for any length
> of time due to constant channel switching.  No crashes, but lots of
> warnings about DMA failing to stop.
> 
> Now..I've fixed this configuration issue (and adding steps to help prevent this mis-configuration
> again).
> 
> With 16 properly configured non-encrypted stations, running with wpa-supplicant
> with netlink driver & sharing scan results,  the interfaces quickly associate.
> 
> However, I do continue to see DMA warnings such as these (I had picked up my
> portable phone, and it knocked all the interfaces offline ..here
> they are coming back up after I hung up the phone).
> 
> Please note that I ported Felix's 2.6.37 patch he posted this morning
> to wireless-testing and have applied it.
> 
> I'm highly tempted to just make that a WARN_ON_ONCE so at least my logs
> aren't spammed so heavily with the recv.c:531 DMA warning.

You can send this change upstream as well.

  Luis
