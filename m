Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35257 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0CCRGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 12:06:32 -0500
Received: by gyd8 with SMTP id 8so144403gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 09:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8D37AC.4010000@nets.rwth-aachen.de>
References: <4B8D37AC.4010000@nets.rwth-aachen.de>
Date: Wed, 3 Mar 2010 12:06:26 -0500
Message-ID: <b6c5339f1003030906jaa47f8dld615865b52bf19a1@mail.gmail.com>
Subject: Re: ath5k IBSS mode high latency
From: Bob Copeland <me@bobcopeland.com>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: ath5k-devel@lists.ath5k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 2, 2010 at 11:07 AM, Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:
> Hi,
>
> I'm currently experimenting with ath5k of kernel 2.6.33 in our
> mesh network. We, were previously using madwifi in "ahdemo" mode,
> which worked reasonably well.
>
> At the same time there is no reasonable traffic that justifies this high backlog.
> I'm not yet sure, but it may be related to this message in dmesg:
>
> [ 3681.006797] ath5k phy0: no further txbuf available, dropping packet

It's likely.

When this happens, we tell mac80211 to stop all of the
tx queues -- regardless of which queue stopped -- until
the hardware interrupts begin processing tx status
descriptors.  We re-enable them when there is a certain
amount of headroom.

> Any idea how to debug this problem further?

I would add a printk to where the queues are stopped
and re-enabled, and when packets are queued, to determine
which queue is using up all of the descriptors.  I can put
together a patch with the appropriate debug for you if you
like, but in a day or two when I'm a bit less busy.

By the way, I did notice that if we fail to map DMA
buffers we can leak tx descriptors, but this is unlikely
to be the cause.

-- 
Bob Copeland %% www.bobcopeland.com
