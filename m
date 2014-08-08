Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:63669 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbaHHPzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 11:55:36 -0400
Received: by mail-oi0-f48.google.com with SMTP id h136so3744909oig.7
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 08:55:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53E4EFCB.5090501@candelatech.com>
References: <53E3F65D.8080102@candelatech.com>
	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
	<53E4EFCB.5090501@candelatech.com>
Date: Fri, 8 Aug 2014 08:55:35 -0700
Message-ID: <CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com> (sfid-20140808_175541_285113_5B5C8755)
Subject: Re: Reporting firmware stats to ethtool
From: Dave Taht <dave.taht@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 8, 2014 at 8:42 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 08/08/2014 02:06 AM, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
>>> as ethtool stats, somewhat similar to how ath9k does it.
>>>
>>> I notice that my user-space tool is reporting huge numbers because
>>> the stats are reset to zero when firmware restarts, and so my tool
>>> thinks the stats wrapped.
>>>
>>> I can fix my tool easily enough, but I first wanted to see if
>>> anyone had strong feelings about keeping the stats from resetting
>>> to zero by storing history and calculating diffs in the driver.
>>>
>>> I think my preference is to punt this to user-space, but if
>>> someone feels otherwise, please let me know sooner than later.
>>
>> I also prefer to have this in user space, but how does user space know
>> when the stats have been zeroed?
>
> Poll often enough that it cannot increment more than 2 billion (or other large number)
> between polls, and then if polled value is less than previous (and difference is > 2 billion),
> we know we had a reset and not a wrap.

I do kind of prefer 64 bit counters in the general case. Nuke it from
orbit, it's the only way to be sure.

> User-space stats will not be perfect in the case of firmware resets, or resets
> after the 'large number', but nothing is going to make it perfect, and in
> practice, this seems good enough.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k



-- 
Dave Täht

NSFW: https://w2.eff.org/Censorship/Internet_censorship_bills/russell_0296_indecent.article
