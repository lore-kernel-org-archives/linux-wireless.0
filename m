Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39399 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932984AbcIHKqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 06:46:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Subject: Re: [PATCH] rsi: code clean-up
References: <1473313017-4074-1-git-send-email-prameela.j04cs@gmail.com>
        <9f56e811-e415-7a2e-605a-dce0cf6a1cf1@broadcom.com>
Date: Thu, 08 Sep 2016 13:46:46 +0300
In-Reply-To: <9f56e811-e415-7a2e-605a-dce0cf6a1cf1@broadcom.com> (Arend Van
        Spriel's message of "Thu, 8 Sep 2016 11:34:18 +0200")
Message-ID: <87inu6u0rt.fsf@kamboji.qca.qualcomm.com> (sfid-20160908_124658_574069_702EC16F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 8-9-2016 7:36, Prameela Rani Garnepudi wrote:
>> From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
>
> Seems like you missed the essential training on main-line driver
> development :-p
>
> Typically you should split this up in conceptually separate patches so
> it is easier for people to review. A large patch changing things all
> over the place solving different things is taking a lot more time to review.
>
> So go work on branch, make a commit for each issue you want to address,
> and when ready do (using 6 commits as example):
>
> $ git format-patch -s -M --cover-letter -6
>
> The '--cover-letter' results in 0000-...patch file in which you can
> summarize the changes in bullet list so Kalle can reuse that moving the
> patches upstream to networking subsystem.
>
> When done use git to send the patches:
>
> $ git send-email --to='Kalle Valo <kvalo@codeaurora.org>'
> --cc=linux-wireless@vger.kernel.org *.patch

And write a commit log for each patch. In minimum the commit log should
answer to the question "Why?".

A good way to learn how the this all works is to see how others do it.
For example, you can see all ath9k commits like this:

gitk drivers/net/wireless/ath/ath9k/

or iwlwifi:

gitk drivers/net/wireless/intel/iwlwifi/

-- 
Kalle Valo
