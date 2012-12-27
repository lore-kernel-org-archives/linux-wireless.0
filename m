Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61413 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2L0Pzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 10:55:41 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] ath6kl: convert ath6kl_info/err/warn macros to real functions
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
	<20121227114447.27069.54329.stgit@localhost6.localdomain6>
	<1356610754.15149.11.camel@jlt4.sipsolutions.net>
	<871uebfqe3.fsf@qca.qualcomm.com>
Date: Thu, 27 Dec 2012 17:55:46 +0200
In-Reply-To: <871uebfqe3.fsf@qca.qualcomm.com> (Kalle Valo's message of "Thu,
	27 Dec 2012 17:47:48 +0200")
Message-ID: <87wqw3ebgd.fsf@qca.qualcomm.com> (sfid-20121227_165555_544593_D504BFD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> Note that by inserting the tracing here later, you're relying on the
>> fact that "%pV" does va_copy(). This isn't true in all kernel versions,
>> I think there's on version or so where %pV is supported but didn't
>> va_copy(). That may lead to problems (I don't remember what kind) here.
>>
>> This is relevant for compat only, I think I carry a patch there to add
>> va_copy() into the tracing or something.
>
> Compat-drivers has 55-iwlwifi-msg-trace-fix.patch which says:
>
> "In recent kernels, %pV will copy the va_list before using it.
> This isn't true for all kernels, so copy the va_list for use
> by the dev_*() functions, otherwise the kernel will crash if
> the message is printed and traced."
>
> I take it that the problem happens when the message is both printed and
> traced at the same time. So ath6kl will need a similar patch as well.

For the archives: I'm guessing this is the commit which fixed the issue:

commit 5756b76e4db643d8f75174a9a50038523d4b9e32
Author: Jan Beulich <JBeulich@suse.com>
Date:   Mon Mar 5 16:49:24 2012 +0000

    vsprintf: make %pV handling compatible with kasprintf()

And git-describe tells me that it was introduced in 3.3-rc7, so quite
recent.

Kalle
