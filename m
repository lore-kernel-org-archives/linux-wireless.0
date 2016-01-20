Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38686 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556AbcATRz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 12:55:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH RFC] wireless:libertas: enable auto deep sleep
References: <1453275709-25276-1-git-send-email-andreas@kemnade.info>
	<87lh7k2zi0.fsf@kamboji.qca.qualcomm.com>
	<20160120174322.67fdbc27@kemnade.info>
Date: Wed, 20 Jan 2016 19:55:15 +0200
In-Reply-To: <20160120174322.67fdbc27@kemnade.info> (Andreas Kemnade's message
	of "Wed, 20 Jan 2016 17:43:22 +0100")
Message-ID: <878u3k2l18.fsf@kamboji.qca.qualcomm.com> (sfid-20160120_185546_909297_9905D523)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Kemnade <andreas@kemnade.info> writes:

> On Wed, 20 Jan 2016 14:42:47 +0200
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Andreas Kemnade <andreas@kemnade.info> writes:
>> 
>> > Enables auto deep sleep whenever the interface is up and
>> > power managament is enabled, so there is also power management
>> > when there is no connection
>> > That reduces power consumption between scanning
>> > intervals. Deep sleep mode is entered when there is
>> > no activity for 1s.
>> >
>> > The code looks a bit different to how things were done
>> > with the wext interface in earlier times.
>> >
>> > Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
>> 
>> Please use just "libertas: " as the prefix and drop the "wireless:".
>> 
> Hmm, is there any rule for that or do I just find that out
> by analysing git log output?

No generic rule as far as I know. I recommend to use git log to see the
most common prefix:

git log --oneline --follow --no-merges -- drivers/net/wireless/libertas

> BTW: That patch depends on my ieee80211 powersave mode series where I sent
> a second version today.

It's a good idea to document that in the patch, for example after "---"
line.

> Has that series found the way into your review queue?

You can check the status from patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?state=*

I haven't opened wireless-drivers-next yet due to the merge window, I
will do that after -rc1 is released.

-- 
Kalle Valo
