Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33009 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1DNH1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 03:27:52 -0400
Received: by qwk3 with SMTP id 3so724514qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 00:27:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87fwpmknk4.fsf@purkki.adurom.net>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
	<1302646041-3917-1-git-send-email-nbd@openwrt.org>
	<BANLkTingC8r-obXeYxjbHVr2G80MCbhyMQ@mail.gmail.com>
	<20110413125134.GA4832@tuxdriver.com>
	<87fwpmknk4.fsf@purkki.adurom.net>
Date: Thu, 14 Apr 2011 09:27:51 +0200
Message-ID: <BANLkTins0SRJ3JqqOsb0nJ6WoFGe+jkfKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] ath5k: optimize tx descriptor setup
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2011 at 8:34 PM, Kalle Valo <kvalo@adurom.com> wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
>
>>> Looks like this v2 did not found its way to wireless-next [1].
>>
>> That's what happens, when it is posted after I've already merged the v1. :-)
>>
>> I fixed things up and will commit the difference with the following message:
>>
>>     ath5k: improve comments for optimized tx descriptor setup
>>
>>     Comment the use of local variables to reduce the number of load/store
>>     operations on uncached memory, in hopes of not losing this optimization
>>     accidentally in the future.
>
> Thanks John. It was my fault as I was so slow to comment. But I blame
> the sun for this, it's so amazing to see the sun again after six
> months! ;)
>
> --
> Kalle Valo
>

Nice, the diff went into wireless-next-2.6 GIT [1] (even comments are welcome!).

I would enjoy in the future, if you add by yourself a Reported-by as I
saw from Linus Torvalds adding it to commits where maintainers simply
forget it.
Without reviewing/testing/reporting the code won't get better and more stable.
I had tested all 10 or 11 recent ath5k patches, but lazy or simply
trust the work by Felix.

Not sure if I should add a Tested-by to all single patches of patchset
or it's OK to reply to the 1st in series?
Often I see a summary describing the patchset, something like "0/7: My
super patchset".
Replying only to 0/7 would make life easier... but I am *still*
learning from git use-case-2-use-case.
Ted (maintainer of ext4) told me even he is distinguising between
Reported-and-tested-by and Reported-by/Tested-by.
As a summary, don't forget to give credits to people.
(P.S. I am currently here on a lame-ass IBM T40p with Pentium-M... I
will contribute till it explodes someday).

- Sedat -

P.S. I am currently here on a lame-ass IBM T40p with Pentium-M... I
will contribute till it explodes someday.

[1] http://git.us.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=8962d87129ec0a820d17ac44cbf3f51010ad8db8
