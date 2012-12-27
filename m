Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36333 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2L0Pru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 10:47:50 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] ath6kl: convert ath6kl_info/err/warn macros to real functions
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
	<20121227114447.27069.54329.stgit@localhost6.localdomain6>
	<1356610754.15149.11.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Dec 2012 17:47:48 +0200
In-Reply-To: <1356610754.15149.11.camel@jlt4.sipsolutions.net> (Johannes
	Berg's message of "Thu, 27 Dec 2012 13:19:14 +0100")
Message-ID: <871uebfqe3.fsf@qca.qualcomm.com> (sfid-20121227_164754_111011_64A5ACEA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2012-12-27 at 13:44 +0200, Kalle Valo wrote:
>
>> +	va_start(args, fmt);
>> +	vaf.va = &args;
>> +	ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
>> +	va_end(args);
>
> Note that by inserting the tracing here later, you're relying on the
> fact that "%pV" does va_copy(). This isn't true in all kernel versions,
> I think there's on version or so where %pV is supported but didn't
> va_copy(). That may lead to problems (I don't remember what kind) here.
>
> This is relevant for compat only, I think I carry a patch there to add
> va_copy() into the tracing or something.

Compat-drivers has 55-iwlwifi-msg-trace-fix.patch which says:

"In recent kernels, %pV will copy the va_list before using it.
This isn't true for all kernels, so copy the va_list for use
by the dev_*() functions, otherwise the kernel will crash if
the message is printed and traced."

I take it that the problem happens when the message is both printed and
traced at the same time. So ath6kl will need a similar patch as well.

Thanks for the heads up.

Kalle
