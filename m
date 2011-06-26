Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:46012 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1FZPJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 11:09:49 -0400
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mmc: sdio: fix runtime PM path during driver removal
References: <1307662827-16618-1-git-send-email-ohad@wizery.com>
	<BANLkTi=JcXG04coTJCA=fvwxXzuRsYzT4Q@mail.gmail.com>
Date: Sun, 26 Jun 2011 11:09:43 -0400
In-Reply-To: <BANLkTi=JcXG04coTJCA=fvwxXzuRsYzT4Q@mail.gmail.com> (Ohad
	Ben-Cohen's message of "Sun, 26 Jun 2011 14:50:50 +0300")
Message-ID: <m2tybceiiw.fsf@bob.laptop.org> (sfid-20110626_171306_454055_F7DA6E46)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On Sun, Jun 26 2011, Ohad Ben-Cohen wrote:
> On Fri, Jun 10, 2011 at 2:40 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> After commit e1866b3 "PM / Runtime: Rework runtime PM handling
>> during driver removal" was introduced, the driver core stopped
>> incrementing the runtime PM usage counter of the device during
>> the invocation of the ->remove() callback.
>>
>> This indirectly broke SDIO's runtime PM path during driver removal,
>> because no one calls _put_sync() anymore after ->remove() completes.
>>
>> This means that the power of runtime-PM-managed SDIO cards is kept
>> high after their driver is removed (even if it was powered down
>> beforehand).
>>
>> Fix that by directly calling _put_sync() when the last usage
>> counter is downref'ed by the SDIO bus.
>
> Can you please take this 1-liner into 3.0-rc ?
>
> It fixes SDIO runtime PM after a breakage was introduced in 3.0.

Merged, thanks.  I'll be sending a pull request on my for-linus branch
shortly:

http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=shortlog;h=refs/heads/for-linus

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
