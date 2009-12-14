Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64475 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZLNMdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 07:33:05 -0500
Message-ID: <4B263063.4030000@nokia.com>
Date: Mon, 14 Dec 2009 14:32:35 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi> <20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi> <43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com> <20091210143754.GA2955@tuxdriver.com> <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com> <20091210150318.GB2955@tuxdriver.com> <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com> <20091210162517.GD2955@tuxdriver.com>
In-Reply-To: <20091210162517.GD2955@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext John W. Linville wrote:
> On Thu, Dec 10, 2009 at 08:14:34AM -0800, Luis R. Rodriguez wrote:
>> On Thu, Dec 10, 2009 at 7:03 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
> 
>>> Yes.  If you want me to do git pulls then you need to separate fixes
>>> into a tree based on wireless-2.6.  Also, you should be conscientious
>>> about adding "Cc: stable@kernel.org" to commit logs as appropriate.
>>> The whole point of the pulls is to keep me from having to touch
>>> the patches.
>> OK last question, is if we do take up the pull request method for
>> ath9k at Atheros we still have people sending patches from the
>> community so who would pick those up. Is it easier for you if we do so
>> and then get them to you through our pull request? How about the
>> stable fixes? Reason I ask if you pick some of these up it just means
>> we need to rebase and I do prefer to keep a clean tree myself as well,
>> although not required at all.
> 
> In the generic case, the driver/subsystem maintainer and I should
> negotiate that in advance -- either way might be acceptable and either
> way might call for special cases for individual patches.
> 
> So, feel free to propose how you would like to do it for ath9k in
> another thread or a private email.  But in general I would think that
> letting "outsider" (for lack of a better term) patches flow through
> a driver/subsystem maintainer tree would be acceptable.  After all,
> that implies a higher level of domain-specific review.

This is cool! I might consider sending pull-reqs for the wl1271 driver as well, 
so I don't send these patchbombs every now and then. ;) The advantage of this is 
that we can have a review round before the patches actually go in.  So we as the 
driver/subsystem maintainers can decide when the patches are ready to go to 
wireless-next-2.6.

Now it's my turn to ask a question... What happens in the case when there is an 
API change, say, in mac80211 that requires changes in a few different drivers? 
Those changes are usually done in a single patch that changes both the API and 
the affected drivers in one go.  In this case we will end up having to rebase 
our own trees.

How is this done in higher levels, for instance when something that changed in 
the net subsystem requires changes in the wireless "sub-subsystem"?


-- 
Cheers,
Luca.
