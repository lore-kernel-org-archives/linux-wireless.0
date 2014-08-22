Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22290 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbaHVOe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 10:34:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	<20140821124907.27159.64620.stgit@potku.adurom.net>
	<1408626616.4388.0.camel@jlt4.sipsolutions.net>
	<877g21c3dd.fsf@kamboji.qca.qualcomm.com>
	<1408670355.4388.4.camel@jlt4.sipsolutions.net>
Date: Fri, 22 Aug 2014 17:34:43 +0300
In-Reply-To: <1408670355.4388.4.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 22 Aug 2014 03:19:15 +0200")
Message-ID: <87egw8a8zg.fsf@kamboji.qca.qualcomm.com> (sfid-20140822_163506_679537_52B57321)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2014-08-21 at 17:40 +0300, Kalle Valo wrote:
>
>> Heh, this has been a pretty long review period. To be honest I really
>> would like to get this just out of my hands :) And we do have a need for
>> this. When are you planning to implement that generic framework?
>
> Soon (TM). We need it, so really, I should do it soon.
>
>> What I understood is that this is already pretty close what you are
>> planning. Instead of creating a debugfs file of our own and allocating a
>> vmalloc buffer (which we do now), we would just use the buffer provided
>> by cfg80211 (or whatever component that would be) and use the sysfs file
>> the framework provides. So hopefully it would be pretty easy to convert
>> this to use your framework.
>
> I'm thinking now that since vmalloc space is limited on some
> architectures, we should just have a list of pages, but of course we
> could copy it there from vmalloc area.
>
> Anyway, yes, it should be fairly simple to convert - but is it worth it
> for you to have it now? Depends how you use it, I guess.

We really would have use for this, that's why I'm hesitant to wait more.
Even having this from an "unofficial" location would be a big help. If
it's ok for you, I would like to apply this once all review comments are
addressed. But naturally if you think it's better to wait, I will do
that.

-- 
Kalle Valo
