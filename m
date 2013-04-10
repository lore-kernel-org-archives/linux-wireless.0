Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51586 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080Ab3DJXYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 19:24:06 -0400
Message-ID: <5165F491.2060301@openwrt.org> (sfid-20130411_012410_364310_9CFD1E01)
Date: Thu, 11 Apr 2013 01:24:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Respect current txpower setting
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de> <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-11 1:20 AM, Adrian Chadd wrote:
> On 10 April 2013 15:03, Tobias Steinicke
> <tobias.steinicke@net.t-labs.tu-berlin.de> wrote:
>> In routine ath_tx_fill_desc(), the txpower is only set to
>> MAX_RATE_POWER. Now it respects the txpower from bss_conf and set it if it
>> is (txpower * 2) < MAX_RATE_POWER else set to MAX_RATE_POWER.
> 
> This doesn't do anything unless TPC is enabled.
> 
> And if TPC is enabled, you have to jump through hoops to set the
> correct target TX power, as it's not always 1:1 between dBm value
> programmed in and dBm value transmitted.
I think TPC power value mappings were only problematic in pre-802.11n
chipsets, all chipsets supported by ath9k should be fine. There may be
some minor changes missing to enable it on some older chipsets, but
other than that it should be functional.

- Felix
