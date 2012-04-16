Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58604 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2DPGal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:30:41 -0400
Received: by vcqp1 with SMTP id p1so3112529vcq.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 23:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F8B1312.2010108@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
 <1334484941-27673-2-git-send-email-nbd@openwrt.org> <CALSq=BZgn+O2BNq=yAe_g5DAqR7jO3eSX2AcABtWqGUcYjB_qQ@mail.gmail.com>
 <4F8B1312.2010108@openwrt.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 15 Apr 2012 23:30:20 -0700
Message-ID: <CALSq=BZMi0Tc+7paCi_Fid5hurXVxBCROe3xOzpP+o1BW1EBQA@mail.gmail.com> (sfid-20120416_083044_305797_9BA5DA1B)
Subject: Re: [PATCH 2/9] ath9k_hw: do not override SIFS time for half/quarter channels
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 15, 2012 at 11:27 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-04-15 8:22 PM, Daniel Halperin wrote:
>> Felix,
>>
>> This whole patch series throws the NICs out of spec compliance. For
>> instance, page 626 of the 802.11-2007 standard (Table 17-15) says that
>> aSIFStime is 32 us in 10 MHz mode and 64 us in 5 MHz mode.
>>
>> This might be okay to do for certain implementations (as, apparently,
>> AR9280/AR9380), but will break compatibility with any device obeying
>> the standard instead.
>>
>> (I wonder that, if this code below still works, then it seems that you
>> might not be properly downclocking the chips' reference clock...)
>>
>> Are you aware there's a standard for this? Why violate it?
> I'm aware that there's a standard for it, but if I put in the standard
> values, the connection gets unreliable to the point where it's almost
> unusable. That's why I chose to use existing products with 5/10 MHz
> support as reference instead.
>

I hear you, but still suspect the bug's somewhere else. Violating the
standard likely isn't the right choice unless you have a good
reason... it sounds like you don't know why this is happening but this
hack 'seems to work'.

(UBNT is also ath-based, right? So it's not really proof that this
hack doesn't break compatibility..)

Dan
