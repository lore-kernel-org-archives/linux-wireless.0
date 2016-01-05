Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38497 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcAEJsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <568B7F06.1010500@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net> <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net> <20160104092857.GD5284@mwanda>
 <568A4CFF.8060600@users.sourceforge.net> <20160104114849.GH5284@mwanda>
 <568A668D.8090007@users.sourceforge.net> <CAGRGNgXw+G6ZcmFmM=VWZT_jibuZyxe-kSvPSF8W7hPueLhNrw@mail.gmail.com>
 <568B7F06.1010500@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 5 Jan 2016 20:47:42 +1100
Message-ID: <CAGRGNgVVnFGt_mHV+ZrZW0HuGuuh++ohkkNMHPBFt73-+X3L8Q@mail.gmail.com> (sfid-20160105_104836_828110_92868E4F)
Subject: Re: rsi: Delete unnecessary variable initialisations in rsi_send_mgmt_pkt()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Tue, Jan 5, 2016 at 7:29 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> That said, if you figure out some change that produces significant
>> reductions in code or binary size on multiple architectures without
>> making things more complicated, less readable or making the code or
>> binary size larger, then by all means propose it.
>
> Are you looking also for "a proof" that such changes are worthwhile?

It'd be better than "I think doing things this way is better", which
is the hallmark of most of your patch sets. (Admittedly not this one,
but this one is where the discussion is now, so that's where we're
discussing it.)

>> "This makes things smaller" carries much more weight than
>> "I think this is better".
>
> Can the discussed implementation of a function like "rsi_send_mgmt_pkt"
> become a bit smaller by the deletion of extra variable initialisations

I'm talking in general.

In this case you're asking people to review a patch which requires a
lot of careful review for a fairly minor improvement. I must also note
that you haven't CC'd the people who wrote this driver, so it's
possible that the only people who have reviewed it aren't experts in
the code.

The patches you sent recently which moved labels into if statements
were a clear case of "I think this is better" where any actual benefit
from the changes was eclipsed by the style and readability issues they
introduced.

>> Almost all of the changes you've proposed that have seen any
>> discussion whatsoever fall into the latter category.
>
> Thanks for your interesting feedback.

No problem.

> Can a further constructive dialogue evolve from the presented information?

Part of the issue here is that you don't seem to be listening to the
discussion of your patches, or if you are, you're not significantly
changing your approach or attitude in response.

Every time you send a set of patches, there are legitimate issues
which people raise, and every time they are discussed, you assert that
your patches improve things and seem to ignore the concerns people
raise.

I've seen this same pattern of discussion here with these patches,
with your patches to move labels into if statements, with the patches
you sent late June last year, your patches to remove conditions before
kfree() and friends, etc.

You need to change you attitude: just because you can see some benefit
from your patches doesn't mean others do and it doesn't mean that
they're willing to accept them.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
