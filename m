Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:63701 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab0CDN5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 08:57:33 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KYR00H2KG3WUBH0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Thu, 04 Mar 2010 14:57:32 +0100 (CET)
Message-id: <4B8FBC4A.6010904@nets.rwth-aachen.de>
Date: Thu, 04 Mar 2010 14:57:30 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k IBSS mode high latency
References: <4B8D37AC.4010000@nets.rwth-aachen.de>
 <b6c5339f1003030906jaa47f8dld615865b52bf19a1@mail.gmail.com>
In-reply-to: <b6c5339f1003030906jaa47f8dld615865b52bf19a1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 03.03.2010 18:06, schrieb Bob Copeland:
> On Tue, Mar 2, 2010 at 11:07 AM, Arnd Hannemann
> <hannemann@nets.rwth-aachen.de> wrote:
>> Hi,
>>
>> I'm currently experimenting with ath5k of kernel 2.6.33 in our
>> mesh network. We, were previously using madwifi in "ahdemo" mode,
>> which worked reasonably well.
>>
>> At the same time there is no reasonable traffic that justifies this high backlog.
>> I'm not yet sure, but it may be related to this message in dmesg:
>>
>> [ 3681.006797] ath5k phy0: no further txbuf available, dropping packet
> 
> It's likely.
> 
> When this happens, we tell mac80211 to stop all of the
> tx queues -- regardless of which queue stopped -- until
> the hardware interrupts begin processing tx status
> descriptors.  We re-enable them when there is a certain
> amount of headroom.
> 
>> Any idea how to debug this problem further?
> 
> I would add a printk to where the queues are stopped
> and re-enabled, and when packets are queued, to determine
> which queue is using up all of the descriptors.  I can put
> together a patch with the appropriate debug for you if you
> like, but in a day or two when I'm a bit less busy.

That would be nice.
However, I have to wait until saturday to get access
to the testbed again...

> 
> By the way, I did notice that if we fail to map DMA
> buffers we can leak tx descriptors, but this is unlikely
> to be the cause.
> 

Best regards,
Arnd
