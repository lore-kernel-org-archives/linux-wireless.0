Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39073 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbKIQrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 11:47:12 -0500
Subject: Re: ath10k AP "failed to delete peer" errors when using Nexus 5X
To: Robert Hancock <hancockrwd@gmail.com>, ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CADLC3L1xeetwWLn1FbSyzvFYHvPw2z8C3OmQ-w9Bi0U=iLqZiA@mail.gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5640CE0E.8040206@candelatech.com> (sfid-20151109_174715_765881_6C18FF7C)
Date: Mon, 9 Nov 2015 08:47:10 -0800
MIME-Version: 1.0
In-Reply-To: <CADLC3L1xeetwWLn1FbSyzvFYHvPw2z8C3OmQ-w9Bi0U=iLqZiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2015 10:02 PM, Robert Hancock wrote:
> I'm using OpenWRT on a TP-Link Archer C7, currently running
> development rev 47397 which is kernel 4.1.1 and compat-wireless
> 2015-10-26. Ever since I got a new Nexus 5X phone, it seems like
> periodically (once a day or so), the 5GHz wireless (using ath10k)
> craps out and I get a bunch of errors in the kernel log on the router.
> I have to reboot the router to get the 5GHz working again. Full kernel
> log from one of these failures is below. Any thoughts on what is going
> on here?
>
> There are reports of a newer Android build (which I don't have yet)
> which supposedly has some wireless fixes on the Nexus 5X, but I'm not
> sure what it could be doing that would be causing the router to crap
> out like this.

> [ 2178.931641] ---[ end trace 6751cc6390d26848 ]---
> [ 2181.926812] ath10k_pci 0000:01:00.0: failed to delete peer
> 8c:3a:e3:15:29:f3 for vdev 0: -11
> [ 2184.946721] ath10k_pci 0000:01:00.0: failed to set beacon mode for
> vdev 0: -11
> [ 2187.946538] ath10k_pci 0000:01:00.0: failed to set dtim period for
> vdev 0: -11
> [ 2190.986373] ath10k_pci 0000:01:00.0: failed to recalculate rts/cts
> prot for vdev 0: -11
> [ 2193.986210] ath10k_pci 0000:01:00.0: failed to set protection mode
> 0 on vdev 0: -11
> [ 2196.986045] ath10k_pci 0000:01:00.0: failed to set preamble for vdev 0: -11

Usually this means firmware has stopped processing WMI messages.

You might try different firmware versions in hopes one of them fixes the
problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

