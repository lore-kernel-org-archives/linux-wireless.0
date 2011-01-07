Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1AGAF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:05:56 -0500
Received: by iyi12 with SMTP id 12so15346750iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 16:05:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2655E6.3020304@candelatech.com>
References: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com> <4D2655E6.3020304@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 16:05:35 -0800
Message-ID: <AANLkTin1cpOwdwhHudcVhdckMgPpYcZGgRJkN+MpmrVm@mail.gmail.com>
Subject: Re: [ath9k-devel] [ath9k] skbuff alloc of size 3872 failed
To: Ben Greear <greearb@candelatech.com>
Cc: Matt Turner <mattst88@gmail.com>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Michael Guntsche <mike@it-loops.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 3:53 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 12/22/2010 11:22 AM, Matt Turner wrote:
>> With the ath9k driver, I get "skbuff alloc of size 3872 failed"
>>
>> I hit this again today after not using wireless for quite sometime. It
>> looks like it was originally reported against 2.6.35-rc1. Eric Dumazet
>> provided a patch which fixed the issue, but apparently it's still not
>> upstream. Why is this?
>>
>> If it is suitable for upstream inclusion, please take my Tested-by:
>> Matt Turner<mattst88@gmail.com>
>>
>> https://patchwork.kernel.org/patch/104271/
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
> Eric:  If the patch is fine as is, and if you are too busy to
> submit it, I can do so with your Signed-off-by if you want.

Eric, also please make sure you read and understand what using a SOB means:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches;h=689e2371095cc5dfea9927120009341f369159aa;hb=HEAD#l309

  Luis
