Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40306 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0KZVKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 16:10:01 -0500
Message-ID: <4CF02226.2030403@candelatech.com>
Date: Fri, 26 Nov 2010 13:09:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] supplicant:  Enable sharing of scan results.
References: <1289950756-18452-1-git-send-email-greearb@candelatech.com> <20101126205002.GA4302@jm.kir.nu>
In-Reply-To: <20101126205002.GA4302@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2010 12:50 PM, Jouni Malinen wrote:
> On Tue, Nov 16, 2010 at 03:39:16PM -0800, Ben Greear wrote:
>> When using multiple VIFs on the same physical radio,
>> we can share scan results with sibling interfaces.
>> This decreases time it takes to connect many VIFs.
>
> Thanks! This looks reasonable. I did some cleanup and applied it.
>
> Based on a quick test, this seemed to be able to connect over 100
> station vifs using WPA2-Personal to a single AP without major problems.
> Some resources are running out (just CPU?) that makes some of the 4-way
> handshakes fail (timeout?), but after couple of tries, I got 116 of
> 124 stations connected. This is with all interfaces starting at the
> same time; using some more latency there would likely make this quite a
> bit more robust.
>
> wpa_supplicant seemed to stop trying to reconnect in some cases, so this
> probably triggered some bugs that need to be addressed. Anyway, manual
> "wpa_cli -i<ifname>  reassociate" on the missing eight vifs was able to
> get all the 124 stations connected at the same time.

Excellent!

Was this an ath5k or ath9k NIC (or something else?)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
