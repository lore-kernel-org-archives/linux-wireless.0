Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42355 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2E0SOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 14:14:10 -0400
Message-ID: <4FC26EED.5090906@openwrt.org> (sfid-20120527_201414_071113_64D70EAD)
Date: Sun, 27 May 2012 20:14:05 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Ben Greear <greearb@candelatech.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL> <4FC2437C.9090106@candelatech.com> <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
In-Reply-To: <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-27 7:40 PM, Adrian Chadd wrote:
> On 27 May 2012 08:08, Ben Greear <greearb@candelatech.com> wrote:
> 
>> Do you have a link to anyone selling this AP, or is it just an
>> engineering sample as well?
> 
> The board is an engineering sample but (a) customers and developers
> can ask for them under NDA, (b) yes, openwrt developers have done this
> and have the hardware, and (c) the chip is shipping as far as I'm
> aware.
> 
> It's "just" a MIPS74k + AR9340 (3x3) + on-board AR9580 I think. I'll
> have to double check. The wireless NIC side of things is pretty
> standard though, so any Osprey NIC will be fine.
> 
>> I can't even find marketing type pages for AR9340, search results come up
>> empty at www.atheros.com :P
>>> [  3] 33.0-34.0 sec  39.0 MBytes   327 Mbits/sec   0.253 ms   13/ 5002
>>> (0.26%)
> 
>> Those are nice results!  I'll try WPEA-127N as AP and STA and see what I
>> get.
> 
> That's what you should be getting. I'd be really surprised if you didn't. :-)
> 
> nbd has said he'll look into it, so between Sujith and Felix I think
> we're well covered for now.
> 
> Thanks for bringing this to everyone's attention Ben!
I already committed some performance fixes in OpenWrt that bring UDP
performance over a WDS link between an AR9344+AR9380 (Atheros DB120) and
an AR7242+AR9380 (TP-Link TL-WR2543ND) up to about 310-320 Mbit/s, when
doing Tx on the DB120 side. Reverse direction is slower, because AR7242
isn't as powerful as the AR9344.

These fixes do not touch ath9k, I only tweaked the network stack to
avoid redundant copying/reallocation of skb data.

- Felix
