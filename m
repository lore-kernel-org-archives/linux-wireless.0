Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53699 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0K2VTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 16:19:40 -0500
Received: by iwn5 with SMTP id 5so595947iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 13:19:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101129195038.GD8199@tuxdriver.com>
References: <1290279018-29716-1-git-send-email-nbd@openwrt.org>
 <20101122201511.GG2117@tuxdriver.com> <4CEAD7FA.1060107@openwrt.org> <20101129195038.GD8199@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 29 Nov 2010 13:19:19 -0800
Message-ID: <AANLkTimS1hsfoOe9bdgad7kkUPPcMVjd_kB_Ru8kbqt8@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: fix endian issues with CTLs on AR9003
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 11:50 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Nov 22, 2010 at 09:52:10PM +0100, Felix Fietkau wrote:
>> On 2010-11-22 9:15 PM, John W. Linville wrote:
>> > On Sat, Nov 20, 2010 at 07:50:18PM +0100, Felix Fietkau wrote:
>> >> Parsing data using bitfields is messy, because it makes endian handling
>> >> much harder. AR9002 and earlier got it right, AR9003 got it wrong.
>> >> Fix it by getting rid of the CTL related bitfields entirely and use
>> >> masks instead.
>> >>
>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> >> Cc: stable@kernel.org
>> >
>> > Why does this merit stable consideration?
>> It's a simple fix and I would like it to make it to stable releases,
>> because this bug might possibly cause the tx power to be too high in
>> some instances (when running on big-endian systems), violating
>> regulatory limits.
>
> After being chided for having an excessive number of patches in -next
> with "Cc: stable@kernel.org", I would prefer to avoid (or strongly
> limit) merging such patches that way.

Is this a bad thing?

> Patches intended for stable are supposed to be fixes.  Fixes are
> supposed to go to the current release, even if that means that patches
> need to be refactored to separate real fixes from other bits.
>
> Now, what constitutes a fix is that part that can sometimes be subject
> to debate.  Fixes should be small and obvious if possible, and they
> should address significant bug and/or a regression, and be documented
> with bug reports, tested by users, etc.  The later in the release,
> the stricter we must adhere to such definitions.
>
> So...I guess what I am asking is if this is a fix, can you document
> the effects of the bug?  Can you retarget the patch against 2.6.37?
>
> Otherwise, can we omit the Cc?

I just wanted to point out that last thing I heard on this topic was I
suggested I'd just take the patch and apply it to compat-wireless on
the linux-next-pending/ directory if some of these sort of patches do
not get merged as stable. After that Greg said he's be just happy
taking them, so this is what pushed us to just go ahead and send these
more grey-area fixes as stable fixes.

Come to think of it we didn't get OTP patches in for 2.6.36 so I am
not considering we should just disable AR9003 from the PCI ID list for
ath9k as all cards sold should have it so in that case this patch
would just need to go to 2.6.37 and not 2.6.36.

  Luis
