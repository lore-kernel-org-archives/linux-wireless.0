Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53000 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZLNOAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 09:00:23 -0500
Date: Mon, 14 Dec 2009 08:52:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Message-ID: <20091214135229.GA18945@tuxdriver.com>
References: <87ljhb0x0h.fsf@purkki.valot.fi> <20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi> <43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com> <20091210143754.GA2955@tuxdriver.com> <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com> <20091210150318.GB2955@tuxdriver.com> <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com> <20091210162517.GD2955@tuxdriver.com> <4B263063.4030000@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B263063.4030000@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2009 at 02:32:35PM +0200, Luciano Coelho wrote:
> ext John W. Linville wrote:
>> On Thu, Dec 10, 2009 at 08:14:34AM -0800, Luis R. Rodriguez wrote:
>>> On Thu, Dec 10, 2009 at 7:03 AM, John W. Linville
>>> <linville@tuxdriver.com> wrote:
>>
>>>> Yes.  If you want me to do git pulls then you need to separate fixes
>>>> into a tree based on wireless-2.6.  Also, you should be conscientious
>>>> about adding "Cc: stable@kernel.org" to commit logs as appropriate.
>>>> The whole point of the pulls is to keep me from having to touch
>>>> the patches.
>>> OK last question, is if we do take up the pull request method for
>>> ath9k at Atheros we still have people sending patches from the
>>> community so who would pick those up. Is it easier for you if we do so
>>> and then get them to you through our pull request? How about the
>>> stable fixes? Reason I ask if you pick some of these up it just means
>>> we need to rebase and I do prefer to keep a clean tree myself as well,
>>> although not required at all.
>>
>> In the generic case, the driver/subsystem maintainer and I should
>> negotiate that in advance -- either way might be acceptable and either
>> way might call for special cases for individual patches.
>>
>> So, feel free to propose how you would like to do it for ath9k in
>> another thread or a private email.  But in general I would think that
>> letting "outsider" (for lack of a better term) patches flow through
>> a driver/subsystem maintainer tree would be acceptable.  After all,
>> that implies a higher level of domain-specific review.
>
> This is cool! I might consider sending pull-reqs for the wl1271 driver as 
> well, so I don't send these patchbombs every now and then. ;) The 
> advantage of this is that we can have a review round before the patches 
> actually go in.  So we as the driver/subsystem maintainers can decide 
> when the patches are ready to go to wireless-next-2.6.
>
> Now it's my turn to ask a question... What happens in the case when there 
> is an API change, say, in mac80211 that requires changes in a few 
> different drivers? Those changes are usually done in a single patch that 
> changes both the API and the affected drivers in one go.  In this case we 
> will end up having to rebase our own trees.
>
> How is this done in higher levels, for instance when something that 
> changed in the net subsystem requires changes in the wireless 
> "sub-subsystem"?

Well, git is really good at merges.  So in general things will "just
work".  In cases where you _need_ a patch that has been merged in my
tree you can just pull from me (possibly resolving merge conflicts)
and then continue from there.  But in many/most cases you can just not
worry about those things and I'll reserve conflicts in my tree instead.
Note that the above is true for driver-specific changes as well.
So for example if I were to merge a fix for iwlwifi, the iwlwifi tree
could either simply ignore the fix in their tree or pull from me to
get the fix before applying any following patches.

I would ask that before pulling from me you make sure that I have
pulled your latest round of preceding changes.  That way when you pull
from me it is a "fast forward" for your tree, and your pull requests
to me do not include many/any "pull from wireless-2.6" merge entries.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
