Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:43347 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbZKIPuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 10:50:01 -0500
MIME-Version: 1.0
In-Reply-To: <20091109071558.GC453@elte.hu>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
	<alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
	<20091105071431.GA14055@elte.hu> <43e72e890911081135q78416ef7ua6c5991b15fb2659@mail.gmail.com>
	<20091109071558.GC453@elte.hu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 9 Nov 2009 07:49:46 -0800
Message-ID: <43e72e890911090749r5b35fb83s4991bb9c44a1773a@mail.gmail.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Yannick Roehlly <yannick.roehlly@free.fr>,
	Yinghai Lu <yinghai@kernel.org>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2009 at 11:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
>> On Wed, Nov 4, 2009 at 11:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >
>> >> On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
>> >> >
>> >> > Can you please consider reviewing this issue and help determine if
>> >> > this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
>> >> >
>> >> > I am curious if other devices would work by reverting this as well.
>> >> > [ ... ] For details please feel free to check:
>> >> >
>> >> > http://bugzilla.kernel.org/show_bug.cgi?id=14402
>> >>
>> >> That same commit was the cause for
>> >>
>> >> ?? ?? ?? http://bugzilla.kernel.org/show_bug.cgi?id=13940
>> >>
>> >> and we just increased the rounding to make it go away (see commit
>> >> 15b812f1). But that was a hack.
>> >>
>> >> And if that didn't help the ath9k case, then we should just revert
>> >> entirely.
>> >
>> > Agreed - below is the combo 15b812f1 + 5d423ccd revert. (Would be nice
>> > to get the boot log of the latest post-15b812f1 kernel that Yinghai
>> > asked for before we revert, in the hope of better understanding the
>> > problem.)
>>
>> Bernhard has confirmed the new patch fixes this issue.
>
> Good - so latest kernels should be fine (on Bernhard's box) and no
> change is needed, right?

Yea, but it does mean we need a fix propagated down to older kernels.

  Luis
