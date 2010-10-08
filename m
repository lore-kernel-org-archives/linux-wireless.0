Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45827 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0JHCa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 22:30:28 -0400
Message-ID: <4CAE8237.5060801@candelatech.com>
Date: Thu, 07 Oct 2010 19:30:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <201010080942.02302.br1@einfach.org>
In-Reply-To: <201010080942.02302.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 05:42 PM, Bruno Randolf wrote:
> On Fri October 8 2010 04:27:22 Johannes Berg wrote:
>> I'm still convinced something is wrong with ath9k RX DMA, as you've seen
>> the contents of frames written to already freed memory regions. Since I
>> don't know anything about ath9k, you should probably not rely on me
>> though :-)
>
> not sure if this is related or not, but it reminds me of:
>
> "ath9k: BUG kmalloc-8192: Poison overwritten"
> http://marc.info/?l=linux-kernel&m=127379077422354&w=2

This looks identical...some sort of scan results in poisoned
buffer.

>
> and:
>
> "ath5k in monitor mode: Poison overwritten on buffers allocated from
> ath_rxbuf_alloc"
> https://bugzilla.kernel.org/show_bug.cgi?id=15861

We've been doing similar (to the ath9k issue)
tests with ath5k and it's been much more stable.  But, our kernel is
currently totally larded down with debugging so we can't the NIC as
hard as we'd like.

I'll make sure we do some hard-core testing on ath5k soon.

Thanks,
Ben

>
> bruno


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
