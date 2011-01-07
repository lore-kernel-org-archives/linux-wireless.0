Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63027 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1AGAEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:04:53 -0500
Received: by wyb28 with SMTP id 28so16922643wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 16:04:52 -0800 (PST)
Subject: Re: [ath9k] skbuff alloc of size 3872 failed
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Matt Turner <mattst88@gmail.com>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, Michael Guntsche <mike@it-loops.com>
In-Reply-To: <4D2655E6.3020304@candelatech.com>
References: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
	 <4D2655E6.3020304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 01:04:48 +0100
Message-ID: <1294358688.2704.15.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le jeudi 06 janvier 2011 à 15:53 -0800, Ben Greear a écrit :
> On 12/22/2010 11:22 AM, Matt Turner wrote:
> > With the ath9k driver, I get "skbuff alloc of size 3872 failed"
> >
> > I hit this again today after not using wireless for quite sometime. It
> > looks like it was originally reported against 2.6.35-rc1. Eric Dumazet
> > provided a patch which fixed the issue, but apparently it's still not
> > upstream. Why is this?
> >
> > If it is suitable for upstream inclusion, please take my Tested-by:
> > Matt Turner<mattst88@gmail.com>
> >
> > https://patchwork.kernel.org/patch/104271/
> 
> I applied this patch and it seems to work fine, but there
> were some questions by Eric in the patchwork thread that should probably
> be answered by ath9k folks.
> 
> For instance:
> 
> IEEE80211_MAX_MPDU_LEN being 3840 + somebits is suspect, since it doesnt
> match 802.11 specs.
> 
> It should be more close of 2304 + MAC header (32bytes) + FCS (4 bytes) ?
> 
> 
> Eric:  If the patch is fine as is, and if you are too busy to
> submit it, I can do so with your Signed-off-by if you want.
> 

Well, problem is I dont have this hardware and various reports were very
confusing.

Certainly a word from authors/maintainers of this driver is wanted ;)

Thanks !



