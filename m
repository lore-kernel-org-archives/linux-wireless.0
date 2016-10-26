Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbcJZHOl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 03:14:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kaufman\, Liad" <liad.kaufman@intel.com>
Subject: Re: [PATCH 09/10] iwlwifi: mvm: operate in dqa mode
References: <20161019100755.23874-1-luca@coelho.fi>
        <20161019100755.23874-10-luca@coelho.fi>
        <87eg337h7v.fsf@kamboji.qca.qualcomm.com>
        <1477464284.27792.4.camel@intel.com>
Date: Wed, 26 Oct 2016 10:14:05 +0300
In-Reply-To: <1477464284.27792.4.camel@intel.com> (Luciano Coelho's message of
        "Wed, 26 Oct 2016 06:44:45 +0000")
Message-ID: <87r37360qq.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_091449_546080_B4DF4477)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

> Hi Kalle,
>
> On Wed, 2016-10-26 at 09:32 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>>=20
>> > From: Liad Kaufman <liad.kaufman@intel.com>
>> >=20
>> > Run DQA flows by default, as long as the FW supports it.
>> >=20
>> > Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>>=20
>> What's this DQA mode? A short summary would have been nice why it's
>> useful.
>
> DQA is Dynamic Queue Allocation. =C2=A0We have been working on this for
> quite a while now (since v4.7) and have many patches mentioning that
> are already merged.  The first patch is this:
>
> commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc
> of queues")

Yeah, but that's commited over six month ago.

> Its commit message has some explanation and we also have a DOC section
> in our driver that explains it in further details:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.=
git/tree/drivers/net/wireless/intel/iwlwifi/mvm/sta.h#n82

And that's too detailed. I was hoping more like an executive summary in
few sentences.

> Since we've been working on this for so long and already use the term
> DQA broadly, we thought it wouldn't be necessary to explain more when
> we are finally enabling it by default.  But of course I can change that
> if you prefer.

I guessed I could find more information from the history and I know this
is obvious to your team, but it's not obvious to everyone. The commit
log should always answer the questions "Why?" and this isn't answering
that. For example, I need this information when sending pull requests to
Dave and I'm sure lots of other people find it useful as well,
especially when enabling a new feature.

So I'm not asking for a long essay, something like this would be
adequate:

"Run DQA flows by default, as long as the FW supports it. It's currently
supported on 1234, 3456 and 7654, maybe more in the future. DQA improves
latency when X is used or throughput when Y is disabled. On the downside
it sometimes slows down throughput when using Z but that's still
accetable as it's so rarely used."

But no need to change anything for this commit, but just keep in mind
for the future.

--=20
Kalle Valo
