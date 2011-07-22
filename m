Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36159 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1GVOiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 10:38:20 -0400
Received: by vws1 with SMTP id 1so1639473vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 07:38:19 -0700 (PDT)
Message-ID: <4E298B57.6070808@lwfinger.net> (sfid-20110722_163823_090049_257FB8A1)
Date: Fri, 22 Jul 2011 09:38:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43legacy: dma: cache translation (routing bits)
References: <1311287100-3888-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311287100-3888-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2011 05:25 PM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> Ideally this should have been applied before:
> ssb: return correct translation bit for 64-bit DMA
>
> This is because mentioned patch added TMSHIGH register read on every
> ssb_dma_translation call which affected performance.
>
> If we can live with affected performance between that 2 commits, please
> just apply this ASAP.
>
> It affected performance (however I don't expect anything like making it
> 90% slower) is not acceptable, please revert mentioned patch, apply this
> one and then re-apply reverted patches.
> ---

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

The patch is fine. In fact, I didn't notice much difference in CPU usage in the 
before/after tests; however, my b43legacy device only handles 802.11b, thus 
there are not a lot of packets per second.

The failure to boot with the latest pull is more problematic. My bisection try 
led to the nonsensical result of a branch commit. I will pull mainline 3.0 to 
see if it has the same problem.

Larry

