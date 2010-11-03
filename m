Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35755 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0KCRES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 13:04:18 -0400
Message-ID: <4CD19608.4050901@candelatech.com>
Date: Wed, 03 Nov 2010 10:04:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>	<4CD046D2.4080703@openwrt.org>	<4CD04C61.4070007@openwrt.org>	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>	<4CD05E49.70701@openwrt.org>	<AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>	<4CD08C86.9030202@openwrt.org>	<AANLkTi=zzGv7Vagb18Rpby=Xo_+g2yuVoFvAejU1KEud@mail.gmail.com>	<4CD14D39.5020401@openwrt.org>	<AANLkTinvmmqCsgKsfAikdsb88_bCV=VL2+1ZxrwdFHFm@mail.gmail.com> <4CD19421.6000407@openwrt.org>
In-Reply-To: <4CD19421.6000407@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 09:56 AM, Felix Fietkau wrote:

>> Other than that I guess that it's basically an argument about
>> aesthetics, and you may very well be right. All I know is that I've
>> been following ath9k development now for almost two years and I'm
>> amazed by the severity of bugs that are still found, and I guess yet
>> to be found. We're dma:ing all over the place, deadlocking queues and
>> so on, on a regular basis, or at least we where 3 months ago. After
>> each one of these is fixed the attitude seems to be "now everything is
>> perfect and suggesting there could be some more problems or will be in
>> the future is just plain rude". Then yet another is found...
> I'm not saying we should assume that everything is always fine, but I do
> object to adding defensive code against made up scenarios of potential
> bugs that "might" be introduced at some point in the future.


I think a few WARN_ON_ONCE calls might be nice to have..folks
changing one part of the network stack often don't realize the subtle dependencies
in other parts..and a WARN_ON is a lot easier to debug than random
crashes and DMA errors.  For anyone reading the code, it is quite
obvious that you should never hit the WARN_ON, so I don't think it
adds any real clutter.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

